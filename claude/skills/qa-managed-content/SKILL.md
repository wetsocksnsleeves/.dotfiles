---
name: qa-managed-content
description: QA and fix managed content training course YAML files in lib/managed_content_templates/ — structure and numbering, embedded iframes and video URLs, typos and HTML entities, training categories, unreferenced assets, moderation tags, and local image formatting for ActionText processing. Use when creating, editing, or reviewing managed content templates. Triggers include "qa managed content", "check template", "review template images", /qa-managed-content, or after writing/editing any managed content template YAML file.
---

# QA Managed Content

QA and fix managed content training course YAML files in `lib/managed_content_templates/`.

## Step 1: Get Target File

Use the file path provided as argument: $ARGUMENTS

If no argument, ask user which YAML file to QA. Files are in `lib/managed_content_templates/tanda/`.

## Step 2: Run QA Checks

Search the YAML file for these issues:

### Structural Checks
- `key` matches filename
- Sections numbered sequentially from 1
- Items within sections numbered sequentially from 1
- Empty sections (`items: []`) - these should be removed
- **Unreferenced assets**: Check for images in assets directory not referenced in YAML
- **Empty thumbnail_path**: If `thumbnail_path` is empty, check for a `*_thumbnail.*` file in the assets directory

### Content Issues to Find

1. **Embedded iframes**: Search for `&lt;iframe` in reference_text
2. **External images**: Search for `src="https://` URLs (note but don't fix)
3. **Embed video URLs**: Search for `player.vimeo.com` (should be `vimeo.com`)
4. **Typos**: Search for "Leaning" (should be "Learning")
5. **Double-encoded entities**: Search for `&amp;amp;`
6. **Non-breaking spaces**: Search for `&nbsp;` (should be regular space)
7. **Consecutive headings**: Search for `</hX><hY` patterns (need line break between)
8. **Training categories**: Check `training_categories_list` is relevant to content
9. **Local image formatting**: Every `<img>` with a `src` starting with `lib/` passes the Image Checklist in the Image Formatting Reference below

## Step 3: Generate Report

```markdown
## QA Report: [Course Name]

### Summary
- Sections: X | Items: X | Issues: X

### Issues Found
[List each issue with location]

### External Images (Not Fixed)
[List any external image URLs that need manual localisation]
```

## Step 4: Apply Fixes

After reporting, apply these fixes:

### Fix 1: Extract Embedded Iframes

For each `&lt;iframe src="https://player.vimeo.com/video/ID..."&gt;&lt;/iframe&gt;` found:

1. Extract the video ID from the URL
2. Determine the video title from context (nearby heading or section name)
3. Create a new item AFTER the current item with title as subheading:
   ```yaml
   - item_type: resource
     reference_text: "<h3>Peeling Technique</h3>"
     video_url: "https://vimeo.com/ID"
     item_number: [next number]
   ```
4. Remove the iframe from the original reference_text
5. Renumber subsequent items in the section

### Fix 2: External Images (Skip but Report)

Do NOT download or fix external image URLs automatically.

Instead, capture all external URLs and include them in the summary report:
- `src="https://cdn.shopify.com/..."`
- `src="https://..."`

The user will manually download and localise these images.

### Fix 3: Fix Typos

Replace "Leaning" with "Learning" in:
- reference_text content
- alt attributes

Note: Do NOT rename asset files automatically (requires separate action).

### Fix 4: Clean Video URLs

Convert embed URLs to clean URLs:
- `player.vimeo.com/video/ID?params` → `https://vimeo.com/ID`
- `youtube.com/embed/ID` → `https://youtube.com/watch?v=ID`

### Fix 5: Remove Non-Video Content

Remove vimeocdn animated thumbnails/GIFs - these are not actual videos:
- `videoapi-muybridge.vimeocdn.com/animated-thumbnails/...`

### Fix 6: Replace Non-Breaking Spaces

Replace all `&nbsp;` with a regular space character. The HTML entity does not render properly in the app.

Search and replace globally: `&nbsp;` → ` ` (space)

### Fix 7: Separate Headings with Line Breaks

Insert `<br>` between headings and before headings that follow text for better visual separation.

Patterns to fix:
- `</h2><h3>` → `</h2><br><h3>`
- `</h3><h4>` → `</h3><br><h4>`
- `</h2><h4>` → `</h2><br><h4>`
- `</p><h3>` → `</p><br><h3>`
- `</p><h4>` → `</p><br><h4>`

Any closing tag immediately followed by an opening heading tag needs a `<br>` for separation.

### Fix 8: Update Training Categories

Review the template content and update `training_categories_list` to be strictly relevant.

**Allowed categories (use lowercase in YAML):**
- `cocktails`
- `compliance`
- `hospitality`
- `safety`
- `health`
- `beverage`
- `wine`
- `brand-knowledge`

**Rules:**
- Can have multiple categories if genuinely relevant
- Must be strictly relevant to the actual content - don't add categories just because they're tangentially related
- Base selection on the core topic and learning objectives

**Examples:**
- Knife safety course → `[hospitality, safety]`
- RSA training → `[compliance, hospitality, beverage]`
- Wine service → `[hospitality, wine, beverage]`
- Food handling → `[hospitality, safety, health]`
- Tequila brand history → `[brand-knowledge]`
- Whiskey brand story with tasting notes → `[brand-knowledge, beverage]`

### Fix 9: Remove Empty Sections

Remove sections that have no items (`items: []`). After removal:

1. Renumber remaining sections sequentially from 1
2. Report which sections were removed in the final summary

**Example removal:**
```yaml
# Before
- name: Recipes
  section_number: 5
  items: []

# After: Section removed entirely, subsequent sections renumbered
```

### Fix 10: Populate Thumbnail Path

If `thumbnail_path` is empty and a thumbnail file exists in the assets directory (matching `*_thumbnail.*`), set it:

```yaml
thumbnail_path: lib/managed_content_templates/tanda/assets/COURSE_NAME/COURSE_NAME_thumbnail.jpg
```

**Do not count the thumbnail file as an unreferenced asset** — exclude it from Fix 11's unreferenced check.

### Fix 11: Remove Unreferenced Assets

**IMPORTANT:** Always run this check during Step 2 QA, not just "after the user adds images."

Check for and remove any images in the assets directory that aren't referenced in the YAML (excluding the thumbnail file if it was populated in Fix 10).

**Steps:**
1. Extract all image filenames referenced in the YAML:
   ```bash
   grep -oE 'COURSE_NAME/[^"]+\.(png|jpg|jpeg)' YAML_PATH | sed 's|COURSE_NAME/||' | sort -u > /tmp/referenced.txt
   ```

2. List all files in the assets directory:
   ```bash
   ls -1 lib/managed_content_templates/tanda/assets/COURSE_NAME/ | sort > /tmp/all_files.txt
   ```

3. Find unreferenced files:
   ```bash
   comm -23 /tmp/all_files.txt /tmp/referenced.txt
   ```

4. Delete unreferenced files:
   ```bash
   comm -23 /tmp/all_files.txt /tmp/referenced.txt | xargs -I {} trash "lib/managed_content_templates/tanda/assets/COURSE_NAME/{}"
   ```

**Report format:**
```
### Unreferenced Assets
- Total images in directory: X
- Referenced in YAML: Y
- Unreferenced (deleted): Z

Files removed:
- file1.png
- file2.png
```

### Fix 12: Format Local Images

For each `<img>` with a local `src` (starting with `lib/`) that fails the Image Checklist, rewrite it to the correct pattern in the Image Formatting Reference below: strip inline `style` attributes, wrap in `<div class="text-center">`, add `inline-block max-h-96 w-auto rounded-md`, self-close the tag, and make sure it has `alt` text. Images inside `<figure class="image">` table cells use the figure pattern instead.

## Step 5: Add Moderation Tags

After all fixes are applied, add a `moderation-tags` field to the metadata section **after the `countries` field** that lists outstanding issues requiring human attention.

Each tag goes on its own line as a YAML list item.

### Tag: `missing-video-conversions`

Add when any items have an empty `video_url: ''`. These are placeholders where the original course had a video not yet converted/uploaded.

**How to check:** Search for `video_url: ''` in the YAML.

### Tag: `external-images`

Add when any external image URLs (`src="https://..."`) were found that need manual localisation.

### Example

```yaml
metadata:
  key: course_name
  name: Course Name
  content_version: '1.0'
  available_in_production: false
  thumbnail_path: lib/managed_content_templates/tanda/assets/course_name/course_name_thumbnail.jpg
  countries:
  - australia
  moderation-tags:
  - missing-video-conversions
  - external-images
```

### No tags needed

If no outstanding issues exist, do not add the `moderation-tags` field at all.

## Step 6: Verify & Report

After applying fixes:
1. Re-check item numbering is sequential
2. Verify all local asset paths exist
3. Report changes made
4. List any external images that still need manual localisation
5. Report unreferenced assets that were removed
6. Confirm moderation tags were added (if applicable) and list them

## Image Formatting Reference

### Why This Matters

Images in template YAML files (`lib/managed_content_templates/**/*.yml`) are processed by `Hris::ContentLibrary::Manager#process_local_images`, which replaces `<img>` tags with `ActionText::Attachment.to_html`. This wraps images in `<action-text-attachment><figure class="attachment">...</figure></action-text-attachment>`. Any inline styles on the original `<img>` are **lost** during replacement — only the wrapper `<div>` survives.

### Correct Image Pattern

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

### Image Checklist

For each `<img>` tag with a local `src` (starting with `lib/`):

1. **No inline styles** — remove any `style='...'` attributes (they get lost during processing)
2. **Wrapped in centering div** — must be inside `<div class="text-center">...</div>`
3. **Required classes on img** — `inline-block max-h-96 w-auto rounded-md`
4. **Self-closing** — use `<img ... />` not `<img ...>`
5. **Has alt text** — every image should have a descriptive `alt` attribute

### Fix Pattern

Replace this (broken — inline styles lost during processing):

```html
<img src='lib/...' alt='...' style='display: block; max-width: 100%; height: auto; border-radius: 8px; margin: 16px auto;' />
```

With this (correct — centering div survives processing):

```html
<div class="text-center"><img class="inline-block max-h-96 w-auto rounded-md" src='lib/...' alt='...' /></div>
```
