---
name: dig
description: Investigate why a production or staging alert fired by fanning out parallel subagents to Grafana (CloudWatch metrics), OpenSearch (request and job logs) and Sentry (errors), then synthesising a short report with the cause, the evidence, and a fix direction. Use when the user pastes or describes an alert, page, or anomaly. Triggers include "dig into this alert", "why did this fire", a Grafana or Slack alert message, a Sentry issue link, "5xx spiked", "p99 is up", "queue latency", "DB connections", "ECS capacity", "KeyAlert", "within_30_seconds", "site slow in EU", or /dig.
---

# Dig

Coordinate subagents to explain an alert. You are the orchestrator. You do not run queries yourself. You triage, dispatch, correlate, and write the report. Subagents do the reading so their tool output stays out of your context.

The whole investigation is read-only. Never resolve Sentry issues, edit dashboards, silence alerts, or run anything that mutates a database.

## Step 1. Triage the alert into a brief

Extract these from whatever the user pasted. Infer what you can, ask only for what blocks dispatch.

| Field | How to get it |
|---|---|
| Environment | AU or NZ customers, Sydney, `f0o1`, or nothing said means `prod-apac`. EU, Frankfurt, `6g2l` means `prod-eu`. US, Ohio, `m5uj` means `prod-us`. Staging only if the alert says so. |
| Window | Alert fired-at time, plus how long it lasted. Default to fired-at minus 30 minutes to now. Convert to UTC. |
| Signal | What the alert measured. Latency, error rate, 5xx, request count, queue latency, job failures, DB connections, CPU or memory, ECS capacity, a Sentry issue, a customer report. |
| Entities | Anything named. Controller and action, job class, queue name, org id, user id, host, `payaus_trace_id`, Sentry issue id, dashboard or panel. |
| Hypotheses | Two or three plausible causes to test, so subagents have a question and not just a topic. Deploy regression, one expensive customer, external dependency timeout, worker starvation, DB saturation, traffic spike. |

Write the brief as five lines. It goes verbatim into every subagent prompt.

## Step 2. Choose sources

| Signal | Grafana | OpenSearch | Sentry | Code |
|---|---|---|---|---|
| Latency, p99, slow requests | yes | yes, applogs duration and db_runtime | if 5xx accompanied it | after the first wave |
| Error rate, 5xx | yes | yes | yes | after the first wave |
| Request count spike or drop | yes | yes, by ip, ua, controller | no | no |
| Queue latency, job backlog | yes, queueTier and queueVsService | yes, dj-events | if jobs errored | after the first wave |
| Job failures | no | yes, dj-events | yes | after the first wave |
| DB connections, CPU, timeouts | yes, databaseMetrics | yes, db_runtime and PG errors | yes, PG::QueryCanceled family | after the first wave |
| ECS or host capacity | yes, serviceMetrics and host | yes, request_received_at gap | no | no |
| WAF blocks | yes, wafMetrics panel 4 by rule | yes, waf-logs by terminatingRuleId, client_ip, ja4Fingerprint, uri sample | no | no |
| Sentry issue given | if it hints at latency or load | yes, by payaus_trace_id and culprit | yes | yes |
| Customer report, vague | yes, on-call overview or requestMetrics | yes, by org or user | yes | after the first wave |

Skip a source when the table says no. Three subagents that each answer a sharp question beat five that browse.

## Step 3. Dispatch the first wave

Launch every chosen subagent in one message so they run in parallel. Use the Agent tool with `subagent_type: "general-purpose"` on the default model. A Sonnet trial on 2026-09-09 took 3x longer on the Grafana agent, ignored the tool-call cap, and skipped a question, so do not downgrade the model.

Each agent gets two or three questions, never more. Each question should be answerable in one or two tool calls. A fourth question costs a minute and rarely changes the answer. Each prompt follows this shape:

```
You are investigating an alert. Read this file first and follow it exactly:
<absolute path to this skill>/references/<source>-brief.md

Scratchpad directory for any files you write: <scratchpad path from your system prompt>

Alert brief:
<the five-line brief from Step 1>

Answer these questions, in order:
1. <sharp question tied to a hypothesis>
2. <sharp question>
3. <optional third question>

Hard limits: stay inside <start> to <end> UTC plus the baseline windows the brief describes. At most 8 tool calls. Return the summary the brief asks for and nothing else.
```

Questions must be answerable with a number or an identifier. "Did p99 on the app target group leave baseline in the window, and when" is a question. "Look at latency" is not.

The brief files:

- `references/grafana-brief.md` for metrics. Includes the environment to datasource map, dashboard UID pattern, and the CloudWatch panel quirks.
- `references/opensearch-brief.md` for logs. Includes the wrapper path, profile map, hyphenated index names, and query recipes.
- `references/sentry-brief.md` for errors. Includes org slug, projects, and the correlation tags.

Subagents run in the background and you are notified when each finishes. Wait for the notifications. Never write a result you have not received.

## Step 4. Correlate and run a second wave if needed

When the first wave returns, line up the timelines. Then decide whether one more wave is worth it. Common follow-ups, each a single subagent with one question:

- A `payaus_trace_id` from Sentry or logs. Ask the OpenSearch subagent for the whole trace across the combined index pattern.
- A `build_version` or `release` SHA whose first appearance matches the first bad minute. Ask a code subagent, working in the repo, to run `git log -1 <sha>` and `git log --oneline <previous sha>..<sha>` and say which commits touch the culprit controller, job, or table.
- A culprit `Controller#action` or job class. Ask a code subagent to read it and name the queries or external calls it makes, with file and line.
- A single org or user dominating the counts. Ask the OpenSearch subagent what that org was doing in the window.

Stop after the second wave. If the cause is still open, report it as open with the leads.

## Step 5. Write the report

Read `references/report.md` and follow its rules and template. The report has five parts: what happened, why, evidence, fix direction, gaps. Every number carries its unit and its baseline. Inferences are labelled. The fix direction is a direction, not a patch.

Before sending, apply the unslop skill rules to the prose.

## Guardrails

- Production data only for production alerts. Staging logs never contain production traffic.
- If a subagent reports an authentication prompt for AWS SSO or Grafana, surface it to the user and pause. Do not retry blind.
- If two sources disagree, report both and say which the timeline supports.
- Do not exceed two waves or eight subagents in total. Cost matters and late evidence rarely changes the answer.
