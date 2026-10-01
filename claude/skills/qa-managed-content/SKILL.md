---
name: qa-managed-content
description: QA managed content template YAML files in lib/managed_content_templates/. Use when creating, editing, or reviewing managed content templates to ensure images are correctly formatted for ActionText processing. Triggers include "qa managed content", "check template", "review template images", or after writing/editing any managed content template YAML file.
---

# QA Managed Content Templates

Validate and fix managed content template YAML files to ensure images render correctly after ActionText processing.

## Why This Matters

Images in template YAML files (`lib/managed_content_templates/**/*.yml`) are processed by `Hris::ContentLibrary::Manager#process_local_images`, which replaces `<img>` tags with `ActionText::Attachment.to_html`. This wraps images in `<action-text-attachment><figure class="attachment">...</figure></action-text-attachment>`. Any inline styles on the original `<img>` are **lost** during replacement — only the wrapper `<div>` survives.

## Correct Image Pattern

Standalone/block-level images:

```html
<div class="text-center"><img class="inline-block max-h-96 w-auto rounded-md" src="lib/managed_content_templates/tanda/assets/..." alt="Description" /></div>
```

- `<div class="text-center">` — survives processing, centers the attachment
- `inline-block` — makes the image respect `text-center` on parent
- `max-h-96` — limits height
- `w-auto` — maintains aspect ratio
- `rounded-md` — rounded corners

Images inside `<figure class="image">` table cells:

```html
<figure class="image"><div class="w-full flex justify-center"><img class="max-h-96 w-auto rounded-md" src="lib/..." alt="" /></div></figure>
```

## QA Checklist

For each `<img>` tag with a local `src` (starting with `lib/`):

1. **No inline styles** — remove any `style='...'` attributes (they get lost during processing)
2. **Wrapped in centering div** — must be inside `<div class="text-center">...</div>`
3. **Required classes on img** — `inline-block max-h-96 w-auto rounded-md`
4. **Self-closing** — use `<img ... />` not `<img ...>`
5. **Has alt text** — every image should have a descriptive `alt` attribute

## Fix Pattern

Replace this (broken — inline styles lost during processing):

```html
<img src='lib/...' alt='...' style='display: block; max-width: 100%; height: auto; border-radius: 8px; margin: 16px auto;' />
```

With this (correct — centering div survives processing):

```html
<div class="text-center"><img class="inline-block max-h-96 w-auto rounded-md" src='lib/...' alt='...' /></div>
```
