# frozen_string_literal: true

require "cgi"
require "kramdown"
require "date"

module ObsidianCompat
  IMAGE_EXTENSIONS = %w[.png .jpg .jpeg .gif .webp .svg .bmp].freeze
  EMBED_RE = /!\[\[([^\]|#]+)(?:#([^\]|]+))?(?:\|([^\]]+))?\]\]/.freeze
  LINK_RE = /\[\[([^\]|#]+)(?:#([^\]|]+))?(?:\|([^\]]+))?\]\]/.freeze
  MARKDOWN_LINK_RE = /\[[^\]]+\]\(([^)]+)\)/.freeze
  TAG_RE = /(?<![\/\w#&])#([a-zA-Z][a-zA-Z0-9_\/-]*)/.freeze

  module_function

  def format_front_matter_value(value)
    case value
    when nil
      ""
    when Date, DateTime, Time
      value.strftime("%B %d, %Y")
    when Array
      value.join(", ")
    else
      value.to_s
    end
  end

  def render_obsidian_dynamic_fields(text, data)
    transformed = text

    transformed = transformed.gsub(/`=\s*this\.([a-zA-Z0-9_-]+)`/) do
      format_front_matter_value(data[Regexp.last_match(1)])
    end

    transformed = transformed.gsub(/`INPUT\[[^\]]*:\s*([a-zA-Z0-9_-]+)\]`/) do
      format_front_matter_value(data[Regexp.last_match(1)])
    end

    transformed
  end

  def normalize_key(value)
    value.to_s.strip.downcase.sub(/\.md\z/i, "")
  end

  def build_note_index(site)
    notes = site.collections["notes"]&.docs || []
    index = {}

    notes.each do |doc|
      keys = [
        normalize_key(doc.data["title"]),
        normalize_key(doc.basename_without_ext),
        normalize_key(doc.data["slug"]),
        normalize_key(doc.url.to_s.split("/").reject(&:empty?).last),
        normalize_key(Jekyll::Utils.slugify(doc.data["title"].to_s)),
        normalize_key(Jekyll::Utils.slugify(doc.basename_without_ext.to_s))
      ]

      keys.each do |key|
        next if key.empty?

        index[key] = doc
      end
    end

    site.config["obsidian_note_index"] = index
  end

  def note_url_for(site, target, heading = nil)
    clean_target = target.to_s.strip
    return clean_target if clean_target.start_with?("http://", "https://", "/")

    doc = (site.config["obsidian_note_index"] || {})[normalize_key(clean_target)]
    base_url = doc ? doc.url : "/notes/#{Jekyll::Utils.slugify(clean_target)}/"

    return base_url if heading.to_s.strip.empty?

    "#{base_url}##{Jekyll::Utils.slugify(heading.to_s.strip)}"
  end

  def note_doc_for(site, target)
    clean_target = target.to_s.strip
    return nil if clean_target.empty?

    index = site.config["obsidian_note_index"] || {}

    direct = index[normalize_key(clean_target)]
    return direct if direct

    slug_key = normalize_key(Jekyll::Utils.slugify(clean_target))
    direct = index[slug_key]
    return direct if direct

    chapter_match = clean_target.match(/\bchapter\s+(\d+)\b/i)
    return nil unless chapter_match

    chapter_num = chapter_match[1]
    notes = site.collections["notes"]&.docs || []
    notes.find do |doc|
      title = doc.data["title"].to_s
      basename = doc.basename_without_ext.to_s
      [title, basename].any? { |value| value.match?(/\bchapter\s+#{Regexp.escape(chapter_num)}\b/i) }
    end
  end

  def note_doc_for_url(site, url)
    clean_url = url.to_s.strip
    return nil if clean_url.empty?

    base = clean_url.split("#").first
    return nil if base.start_with?("http://", "https://")

    path = base
    if path.start_with?("/notes/")
      slug = path.split("/").reject(&:empty?).last
      return nil if slug.to_s.empty?

      return note_doc_for(site, slug)
    end

    return nil if path.start_with?("/")

    note_doc_for(site, path)
  end

  def backlink_entry_for(doc)
    {
      "title" => (doc.data["title"].to_s.strip.empty? ? doc.basename_without_ext : doc.data["title"]),
      "url" => doc.url
    }
  end

  def extract_linked_note_docs(site, source_doc)
    linked_docs = []

    transform_non_code_blocks(source_doc.content.to_s) do |text|
      text.scan(LINK_RE) do |target, _heading, _alias_text|
        note_doc = note_doc_for(site, target)
        linked_docs << note_doc if note_doc
      end

      text.scan(EMBED_RE) do |target, _heading, _alias_text|
        next if image_target?(target)

        note_doc = note_doc_for(site, target)
        linked_docs << note_doc if note_doc
      end

      text.scan(MARKDOWN_LINK_RE) do |url|
        note_doc = note_doc_for_url(site, url.first)
        linked_docs << note_doc if note_doc
      end

      text
    end

    linked_docs.compact.uniq
  end

  def build_backlinks(site)
    notes = site.collections["notes"]&.docs || []
    backlinks_by_url = Hash.new { |hash, key| hash[key] = [] }

    notes.each do |source_doc|
      targets = extract_linked_note_docs(site, source_doc)

      targets.each do |target_doc|
        next if target_doc.url == source_doc.url

        backlinks_by_url[target_doc.url] << backlink_entry_for(source_doc)
      end
    end

    notes.each do |doc|
      entries = backlinks_by_url[doc.url]
      doc.data["backlinks"] = entries.uniq { |entry| entry["url"] }
    end
  end

  def image_target?(target)
    IMAGE_EXTENSIONS.include?(File.extname(target.to_s).downcase)
  end

  def escape_url_path(url)
    url.split("/").map { |segment| CGI.escape(segment).gsub("+", "%20") }.join("/")
  end

  def asset_url_for(site, target)
    clean_target = target.to_s.strip
    return clean_target if clean_target.start_with?("http://", "https://", "/")

    static_file = site.static_files.find do |file|
      File.basename(file.relative_path).casecmp?(clean_target)
    end

    raw_url = static_file ? static_file.relative_path : "/assets/notes/#{clean_target}"
    escape_url_path(raw_url)
  end

  def transform_non_code_blocks(content)
    # Keep fenced code blocks untouched so examples stay valid.
    parts = content.split(/(```.*?```)/m)
    parts.map.with_index { |part, i| i.odd? ? part : yield(part) }.join
  end

  def list_line?(line)
    line.match?(/^\s*(?:[-*+]\s+|\d+\.\s+)/)
  end

  def normalize_callout_markdown(markdown)
    lines = markdown.lines
    output = []

    lines.each_with_index do |line, index|
      math_match = line.match(/^\s*\$\$(.+)\$\$\s*$/)
      if math_match
        output << "\n"
        output << "\\\\[#{math_match[1].strip}\\\\]\n"
        output << "\n"
        next
      end

      prev = index.zero? ? "" : lines[index - 1]
      if list_line?(line) && !prev.strip.empty? && !list_line?(prev)
        output << "\n"
      end

      if line.match?(/^\s*\*\*[^\n]+:\*\*\s*.+$/)
        output << "#{line.rstrip}  \n"
      else
        output << line
      end
    end

    output.join
  end

  def convert_callouts(text)
    lines = text.lines
    output = []
    i = 0

    while i < lines.length
      match = lines[i].match(/^>\s*\[!([a-zA-Z0-9_-]+)\]([+-])?\s*(.*)$/)
      unless match
        output << lines[i]
        i += 1
        next
      end

      callout_type = match[1].downcase
      callout_title = match[3].to_s.strip
      callout_title = callout_type.capitalize if callout_title.empty?

      i += 1
      body_lines = []
      while i < lines.length && lines[i].match?(/^>\s?.*$/)
        body_lines << lines[i].sub(/^>\s?/, "")
        i += 1
      end

      body_markdown = normalize_callout_markdown(body_lines.join)
      body_html = Kramdown::Document.new(body_markdown).to_html
      output << "<div class=\"obs-callout obs-callout--#{callout_type}\">\n"
      output << "<p class=\"obs-callout__title\">#{CGI.escapeHTML(callout_title)}</p>\n"
      output << body_html
      output << "</div>\n"
    end

    output.join
  end

  def convert(content, site, data = {})
    transform_non_code_blocks(content) do |text|
      transformed = render_obsidian_dynamic_fields(text, data)

      transformed = transformed.gsub(EMBED_RE) do
        target = Regexp.last_match(1).to_s.strip
        heading = Regexp.last_match(2).to_s.strip
        alias_text = Regexp.last_match(3).to_s.strip

        if image_target?(target)
          alt_text = alias_text.empty? ? File.basename(target, File.extname(target)) : alias_text
          "![#{alt_text}](#{asset_url_for(site, target)})"
        else
          label = alias_text.empty? ? target : alias_text
          "[#{label}](#{note_url_for(site, target, heading)})"
        end
      end

      transformed = transformed.gsub(LINK_RE) do
        target = Regexp.last_match(1).to_s.strip
        heading = Regexp.last_match(2).to_s.strip
        alias_text = Regexp.last_match(3).to_s.strip
        label = CGI.escapeHTML(alias_text.empty? ? target : alias_text)
        url = note_url_for(site, target, heading)

        "<a href=\"#{url}\" class=\"internal-link\">#{label}</a>"
      end

      transformed = transformed.gsub(TAG_RE) do
        tag = Regexp.last_match(1)
        slug = Jekyll::Utils.slugify(tag)
        "<a href=\"/tags/##{slug}\" class=\"ob-tag\">##{CGI.escapeHTML(tag)}</a>"
      end

      convert_callouts(transformed)
    end
  end
end

Jekyll::Hooks.register :site, :post_read do |site|
  ObsidianCompat.build_note_index(site)
  ObsidianCompat.build_backlinks(site)
end

OBSIDIAN_SKIP_EXTENSIONS = %w[.scss .sass .css .js .json .xml .txt].freeze

[:documents, :pages, :posts].each do |target|
  Jekyll::Hooks.register target, :pre_render do |doc|
    next unless doc.respond_to?(:content) && doc.content
    next if OBSIDIAN_SKIP_EXTENSIONS.include?(File.extname(doc.relative_path.to_s).downcase)

    doc.content = ObsidianCompat.convert(doc.content, doc.site, doc.data || {})
  end
end
