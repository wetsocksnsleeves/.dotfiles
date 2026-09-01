#!/usr/bin/env ruby
# frozen_string_literal: true

# Builds a self-contained visual QA report from a manifest JSON.
# Usage: ruby build_report.rb <manifest.json> [output.html]

require "json"
require "base64"
require "cgi"

MIME = { ".png" => "image/png", ".gif" => "image/gif", ".jpg" => "image/jpeg", ".jpeg" => "image/jpeg", ".webp" => "image/webp" }.freeze

def data_uri(path)
  return nil if path.nil? || path.empty?
  raise "missing image: #{path}" unless File.exist?(path)

  mime = MIME.fetch(File.extname(path).downcase) { raise "unsupported image type: #{path}" }
  "data:#{mime};base64,#{Base64.strict_encode64(File.binread(path))}"
end

def h(text) = CGI.escapeHTML(text.to_s)

def pane(label, path, empty_text)
  uri = data_uri(path)
  body = uri ? %(<img src="#{uri}" alt="#{h(label)}">) : %(<p class="empty">#{h(empty_text)}</p>)
  %(<figure><figcaption>#{h(label)}</figcaption>#{body}</figure>)
end

manifest_path = ARGV[0] or abort "usage: build_report.rb <manifest.json> [output.html]"
m = JSON.parse(File.read(manifest_path))
out_path = ARGV[1] || File.join(File.dirname(manifest_path), "report.html")

shots = m.fetch("shots", []).map do |s|
  before = pane("Before — #{m.fetch('base', 'master')}", s["before"], s.fetch("before_missing_text", "Did not exist on this branch"))
  after = pane("After — this branch", s["after"], "No capture")
  note = s["note"].to_s.empty? ? "" : %(<p class="note">#{h(s['note'])}</p>)
  url = s["url"].to_s.empty? ? "" : %(<code>#{h(s['url'])}</code>)
  <<~HTML
    <section>
      <h2>#{h(s.fetch('label', 'Screen'))} #{url}</h2>
      #{note}
      <div class="pair">#{before}#{after}</div>
    </section>
  HTML
end.join("\n")

notes = m.fetch("notes", [])
notes_html = notes.empty? ? "" : "<ul class=\"checks\">#{notes.map { |n| "<li>#{h(n)}</li>" }.join}</ul>"

html = <<~HTML
  <!doctype html>
  <html lang="en"><head><meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Visual QA — #{h(m.fetch('branch', 'branch'))}</title>
  <style>
    :root { color-scheme: light dark; --bg:#fff; --fg:#111; --dim:#666; --line:#e3e3e3; --card:#fafafa; }
    @media (prefers-color-scheme: dark) { :root { --bg:#151515; --fg:#eee; --dim:#999; --line:#333; --card:#1d1d1d; } }
    * { box-sizing: border-box; }
    body { margin:0; padding:2rem 1.5rem 4rem; background:var(--bg); color:var(--fg);
           font:14px/1.5 -apple-system,BlinkMacSystemFont,"Segoe UI",sans-serif; max-width:1400px; margin-inline:auto; }
    header { border-bottom:1px solid var(--line); padding-bottom:1rem; margin-bottom:2rem; }
    h1 { font-size:1.25rem; margin:0 0 .35rem; }
    h2 { font-size:1rem; margin:0 0 .5rem; font-weight:600; }
    .meta { color:var(--dim); font-size:.8rem; }
    .meta code { background:var(--card); padding:.1rem .35rem; border-radius:3px; }
    .summary { margin:.75rem 0 0; }
    section { margin-bottom:2.5rem; }
    h2 code { font-weight:400; font-size:.8rem; color:var(--dim); background:var(--card); padding:.1rem .35rem; border-radius:3px; }
    .note { color:var(--dim); margin:0 0 .75rem; }
    .pair { display:grid; grid-template-columns:1fr 1fr; gap:1rem; }
    @media (max-width:900px) { .pair { grid-template-columns:1fr; } }
    figure { margin:0; }
    figcaption { font-size:.75rem; text-transform:uppercase; letter-spacing:.04em; color:var(--dim); margin-bottom:.4rem; }
    img { width:100%; border:1px solid var(--line); border-radius:4px; display:block; cursor:zoom-in; background:var(--card); }
    img.zoom { position:fixed; inset:0; z-index:9; width:auto; max-width:100vw; max-height:100vh; margin:auto; cursor:zoom-out; border-radius:0; }
    .empty { border:1px dashed var(--line); border-radius:4px; padding:2rem 1rem; text-align:center; color:var(--dim); margin:0; }
    .checks { margin:0; padding-left:1.1rem; color:var(--dim); }
    .checks li { margin-bottom:.25rem; }
    footer { border-top:1px solid var(--line); padding-top:1rem; color:var(--dim); font-size:.8rem; }
  </style></head>
  <body>
  <header>
    <h1>Visual QA — #{h(m.fetch('title', m.fetch('branch', 'branch')))}</h1>
    <p class="meta"><code>#{h(m.fetch('branch', '?'))}</code> vs <code>#{h(m.fetch('base', 'master'))}</code>#{m['url_base'] ? " · #{h(m['url_base'])}" : ''}</p>
    #{m['summary'] ? "<p class=\"summary\">#{h(m['summary'])}</p>" : ''}
  </header>
  #{shots}
  #{notes.empty? ? '' : "<footer><p><strong>Checked</strong></p>#{notes_html}</footer>"}
  <script>
    document.addEventListener('click', e => {
      if (e.target.tagName === 'IMG') e.target.classList.toggle('zoom');
    });
  </script>
  </body></html>
HTML

File.write(out_path, html)
puts "#{out_path} (#{(File.size(out_path) / 1024.0).round}KB, #{m.fetch('shots', []).size} screens)"
