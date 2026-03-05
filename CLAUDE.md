# Jekyll Site with Obsidian Theme Integration

## Project

Jekyll site using the Minimal Mistakes theme (by Michael Rose) with a `_notes` collection styled to match Obsidian's default dark theme. Built via GitHub Actions, hosted on GitHub Pages. Running in WSL2 Ubuntu on Windows.

## Tech Stack

- Jekyll (Ruby) with Minimal Mistakes theme
- SCSS for styling (Obsidian theme scoped to `.obsidian-note`)
- Custom Ruby plugins (require `--safe false`, handled by Actions)
- KaTeX for LaTeX math rendering (client-side)
- D3.js v7 for interactive graph view
- kramdown with GFM input and Rouge syntax highlighting

## Commands

- `bundle exec jekyll serve --livereload`: Local dev server at localhost:4000
- `bundle exec jekyll build`: Production build to `_site/`
- `bundle install`: Install/update gems
- `git push origin main`: Triggers GitHub Actions build + deploy

## Architecture

```
_config.yml                              # Site config, collections, defaults
_notes/                                  # Obsidian notes (layout: obsidian-note)
_posts/                                  # Blog posts (standard MM layout)
_pages/                                  # Static pages (standard MM layout)
_layouts/
  obsidian-note.html                     # Note layout — wraps in .obsidian-note
_sass/minimal-mistakes/
  _obsidian-theme.scss                   # Obsidian CSS, scoped to .obsidian-note
_plugins/
  obsidian_callouts.rb                   # > [!type] → styled HTML divs
  obsidian_wikilinks.rb                  # [[Page]] → <a class="internal-link">
  obsidian_tags.rb                       # #tag → <a class="ob-tag">
  obsidian_transclusions.rb              # ![[Page]] → inlined content
_includes/
  backlinks.html                         # Auto-generated backlinks panel
  graph.html                             # D3.js force-directed graph
assets/css/main.scss                     # Imports MM + obsidian-theme
```

## Key Design Decisions

- **Scoped CSS**: All Obsidian styles live inside `.obsidian-note { }` in SCSS. Only the `obsidian-note` layout applies this class. Other pages are unaffected.
- **Notes collection**: Notes go in `_notes/`, get permalink `/notes/:slug/`, and default to `layout: obsidian-note`.
- **Wikilink resolution**: Plugin builds a slug map at generate time. Links resolve by lowercase title match against `_notes` docs and site pages.
- **Transclusions**: Resolved at build time by the Generator plugin. Max 5 levels deep, circular reference detection. Supports `![[Note]]`, `![[Note#Heading]]`, `![[Note#^block-id]]`, `![[image.png|300x200]]`.
- **Callouts**: Converter plugin runs at high priority, transforms `> [!type]` blocks before kramdown processes the markdown. All 13 Obsidian callout types supported.
- **Theme modes**: Dark (default), light (`obsidian_light: true`), auto (`obsidian_auto: true`) via CSS custom properties and `prefers-color-scheme`.

## Obsidian CSS Variables

Colors are defined as CSS custom properties at the top of `_obsidian-theme.scss`. To change the theme accent color, edit `--ob-accent`. All derived colors reference these variables. Dark mode values are the defaults; light mode overrides are in `.obsidian-note.obsidian-light`.

## Plugin Execution Order

1. `obsidian_transclusions.rb` (Generator, priority: lowest) — resolves `![[embeds]]` in raw content
2. `obsidian_callouts.rb` (Converter, priority: high) — transforms callout blockquotes before kramdown
3. `obsidian_wikilinks.rb` (Generator, priority: low) — builds slug map; Liquid filter resolves `[[links]]` at render time
4. `obsidian_tags.rb` — Liquid filter converts `#tags` at render time

## Config Reference

```yaml
collections:
  notes:
    output: true
    permalink: /notes/:slug/

defaults:
  - scope:
      path: ""
      type: "notes"
    values:
      layout: obsidian-note

obsidian:
  notes_path: /notes/
  assets_path: /assets/images/
```

## Important Rules

- The `_sass/minimal-mistakes/_obsidian-theme.scss` import line goes AFTER `@import "minimal-mistakes";` in `assets/css/main.scss`
- Never put Obsidian-specific CSS outside the `.obsidian-note` scope
- Note frontmatter needs `title:` for wikilink resolution and backlink detection to work
- Image transclusions (`![[img.png]]`) resolve to `obsidian.assets_path` + filename
- Callout plugin matches `> [!type]` at line start — don't indent callout syntax
- Plugins require `--safe false` which GitHub Actions handles; they won't run on default GitHub Pages Ruby build
- The graph view (`_includes/graph.html`) loads D3 from CDN — it needs network access

## WSL2 Notes

- Jekyll livereload works but may need `--force_polling` if file watching fails
- If `bundle exec jekyll serve` can't bind, try `--host 0.0.0.0`
- Ruby gems install to the WSL2 filesystem, not Windows — run everything from WSL terminal