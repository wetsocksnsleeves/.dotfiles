# Dig report: synthesis rules and template

## Synthesis rules

1. Build one timeline in UTC from every subagent's timeline. Order by time. The first signal to move is the lead. Anything that moved after it is a consequence until shown otherwise.
2. A cause must be supported by at least two sources, or by one source plus code. One log line is a lead, not a finding.
3. Prefer the mechanical explanation. "Deploy 7bbc06e at 02:41 added a query that scans overtime_hours; p99 on TimesheetsController#show went from 400ms to 6s" beats "a performance regression".
4. Separate what is known from what is inferred. Label inferences.
5. Name what did not move. A DB that stayed flat rules out a whole class of causes and belongs in the evidence.
6. If the sources disagree, say so and pick the reading the timeline supports.
7. Keep every number with its unit and its baseline. A number without a baseline is deleted.
8. Apply the unslop skill's rules to the prose before sending.

## Template

Use this structure. Drop a section only when it is empty, and say so in one line.

```
# Dig: <alert name or one-line paraphrase>

**Environment** <prod-apac | prod-eu | prod-us | staging-*>. **Window** <start> to <end> UTC. **Status** <ongoing | recovered at HH:MM UTC | unknown>.

## What happened
Two to four sentences. What the alert measured, how far it moved from baseline, and who or what was affected. No cause yet.

## Why it happened
The cause in plain terms, mechanism first. One paragraph. Mark inferences as such.

## Evidence
Bulleted. Each bullet is one fact, its source, and the number or identifier that backs it. Order by the timeline.
- 02:41 UTC. New build_version 7bbc06e appears on app hosts (OpenSearch applogs, by_build aggregation).
- 02:43 UTC. ALB p99 on tg-app rises from 1.2s to 5.8s (Grafana tt-prod-apac-requestMetrics panel 4).
- ...
- Did not move: RDS connections, ECS task counts, Redis evictions.

## Fix direction
Two to five sentences, or "None applicable" with the reason. Say what to change and where, and what would confirm the fix. Do not write the code.

## Gaps
What could not be determined, which query or panel was empty, and what would close the gap.
```

## Length

Aim for 300 to 600 words. The reader is on call and wants to act, not read.
