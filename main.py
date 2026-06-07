import html
import os
import re
import shutil
import yaml
from collections import OrderedDict
from jinja2 import Environment, FileSystemLoader
import sys

CONTENT_DIR = "write"
TEMPLATE_DIR = "journey_templates"
OUTPUT_DIR = "docs"
TEMPLATE_FILE = "template.html"

def clean_slug(filename):
    base = os.path.splitext(filename)[0]
    base = re.sub(r'^\d+-', '', base)
    return base.lower()

def folder_label(folder_name):
    return folder_name.replace("-", " ").replace("_", " ").title()

def relative_url(from_subdir, docs_root_url):
    if not docs_root_url or docs_root_url.startswith(("#", "http", "//")):
        return docs_root_url

    if not from_subdir:
        return docs_root_url.lstrip("/")

    clean_url = docs_root_url.replace("\\", "/").lstrip("/")
    target_parts = clean_url.split("/")
    from_parts   = from_subdir.replace("\\", "/").split("/")

    if len(target_parts) == 1:
        return clean_url

    if target_parts[:-1] == from_parts:
        return target_parts[-1]

    ups = "../" * len(from_parts)
    return ups + clean_url

def highlight_dart(code):
    """Apply syntax highlighting spans for Dart code."""
    # Protect existing HTML entities and spans
    protected = []
    def _protect(m):
        protected.append(m.group(0))
        return f'\x00PROT{len(protected)-1}\x00'

    # Protect strings and comments first (so we don't highlight keywords inside them)
    # Single-line comments //
    code = re.sub(r'//.*$', _protect, code, flags=re.MULTILINE)

    # Multi-line comments /* ... */
    code = re.sub(r'/\*[\s\S]*?\*/', _protect, code)

    # Triple-quoted strings (multi-line)
    code = re.sub(r"'''[\s\S]*?'''", _protect, code)
    code = re.sub(r'"""[\s\S]*?"""', _protect, code)

    # Single-quoted strings
    code = re.sub(r"'[^'\\]*(?:\\.[^'\\]*)*'", _protect, code)

    # Double-quoted strings (including interpolated)
    code = re.sub(r'"[^"\\]*(?:\\.[^"\\]*)*"', _protect, code)

    # Raw strings
    code = re.sub(r"r'[^']*'", _protect, code)
    code = re.sub(r'r"[^"]*"', _protect, code)

    # Dart keywords
    dart_keywords = [
        'abstract', 'as', 'assert', 'async', 'await', 'break', 'case',
        'catch', 'class', 'const', 'continue', 'covariant', 'default',
        'deferred', 'do', 'dynamic', 'else', 'enum', 'export', 'extends',
        'extension', 'external', 'factory', 'false', 'final', 'finally',
        'for', 'Function', 'get', 'hide', 'if', 'implements', 'import',
        'in', 'interface', 'is', 'late', 'library', 'mixin', 'new',
        'null', 'on', 'operator', 'part', 'required', 'rethrow', 'return',
        'sealed', 'set', 'show', 'static', 'super', 'switch', 'sync',
        'this', 'throw', 'true', 'try', 'typedef', 'var', 'void',
        'while', 'with', 'yield',
    ]
    for kw in dart_keywords:
        code = re.sub(
            r'\b(' + re.escape(kw) + r')\b',
            r'<span class="code-kw">\1</span>', code
        )

    # Dart built-in types
    dart_types = [
        'String', 'int', 'double', 'bool', 'num', 'List', 'Map', 'Set',
        'Object', 'Future', 'Stream', 'Iterable', 'Duration', 'DateTime',
        'StackTrace', 'Type', 'Symbol', 'RegExp', 'BigInt', 'Record',
    ]
    for t in dart_types:
        code = re.sub(
            r'\b(' + re.escape(t) + r')\b',
            r'<span class="code-type">\1</span>', code
        )

    # Numbers (including hex, binary, floats)
    code = re.sub(
        r'\b(0x[0-9a-fA-F]+|0b[01]+|\d+\.?\d*(?:[eE][+-]?\d+)?)\b',
        r'<span class="code-num">\1</span>', code
    )

    # Annotations (e.g. @override, @deprecated)
    code = re.sub(
        r'(@[a-zA-Z_]\w*)',
        r'<span class="code-annotation">\1</span>', code
    )

    # Unprotect strings and comments with appropriate span colors
    for i, block in enumerate(protected):
        if block.startswith('//'):
            colored = f'<span class="code-comment">{html.escape(block)}</span>'
        elif block.startswith('/*'):
            colored = f'<span class="code-comment">{html.escape(block)}</span>'
        elif block.startswith("'") or block.startswith('"') or block.startswith("r'"):
            if block.startswith("r'"):
                colored = f'<span class="code-string">{html.escape(block)}</span>'
            else:
                colored = f'<span class="code-string">{html.escape(block)}</span>'
        else:
            colored = html.escape(block)
        code = code.replace(f'\x00PROT{i}\x00', colored)

    return code

def highlight_yaml(code):
    """Apply syntax highlighting for YAML code."""
    protected = []
    def _protect(m):
        protected.append(m.group(0))
        return f'\x00PROT{len(protected)-1}\x00'

    # Comments
    code = re.sub(r'#.*$', _protect, code, flags=re.MULTILINE)

    # Strings
    code = re.sub(r'"[^"]*"', _protect, code)
    code = re.sub(r"'[^']*'", _protect, code)

    # Keys (word before colon)
    code = re.sub(
        r'^(\s*)([a-zA-Z_][a-zA-Z0-9_-]*)(\s*:)',
        r'\1<span class="code-kw">\2</span>\3',
        code, flags=re.MULTILINE
    )

    # Booleans and null
    code = re.sub(r'\b(true|false|null)\b', r'<span class="code-num">\1</span>', code)

    # Numbers
    code = re.sub(r'\b(\d+\.?\d*)\b', r'<span class="code-num">\1</span>', code)

    # Restore protected blocks
    for i, block in enumerate(protected):
        if block.startswith('#'):
            colored = f'<span class="code-comment">{html.escape(block)}</span>'
        else:
            colored = f'<span class="code-string">{html.escape(block)}</span>'
        code = code.replace(f'\x00PROT{i}\x00', colored)

    return code

def highlight_bash(code):
    """Apply syntax highlighting for Bash/PowerShell code."""
    protected = []
    def _protect(m):
        protected.append(m.group(0))
        return f'\x00PROT{len(protected)-1}\x00'

    # Comments
    code = re.sub(r'#.*$', _protect, code, flags=re.MULTILINE)

    # Strings
    code = re.sub(r'"[^"]*"', _protect, code)
    code = re.sub(r"'[^']*'", _protect, code)

    # Common shell keywords/commands
    shell_kw = [
        'echo', 'export', 'cd', 'ls', 'choco', 'brew', 'apt', 'dnf',
        'winget', 'dart', 'flutter', 'pub', 'git', 'npm', 'pip',
        'python', 'node', 'Set-ExecutionPolicy', 'iex', 'where',
        'sudo', 'mkdir', 'rm', 'cp', 'mv', 'cat', 'curl', 'wget',
        'if', 'then', 'else', 'elif', 'fi', 'for', 'do', 'done',
        'while', 'case', 'esac', 'function', 'source',
    ]
    for kw in shell_kw:
        code = re.sub(
            r'\b(' + re.escape(kw) + r')\b',
            r'<span class="code-kw">\1</span>', code
        )

    # Options/flags
    code = re.sub(r'(\s)(--?[a-zA-Z0-9][a-zA-Z0-9-]*)', r'\1<span class="code-annotation">\2</span>', code)

    # Restore
    for i, block in enumerate(protected):
        if block.startswith('#'):
            colored = f'<span class="code-comment">{html.escape(block)}</span>'
        else:
            colored = f'<span class="code-string">{html.escape(block)}</span>'
        code = code.replace(f'\x00PROT{i}\x00', colored)

    return code

def highlight_cpp(code):
    """Apply syntax highlighting for C/C++ code."""
    protected = []
    def _protect(m):
        protected.append(m.group(0))
        return f'\x00PROT{len(protected)-1}\x00'

    # Comments
    code = re.sub(r'//.*$', _protect, code, flags=re.MULTILINE)
    code = re.sub(r'/\*[\s\S]*?\*/', _protect, code)

    # Strings
    code = re.sub(r'"[^"\\]*(?:\\.[^"\\]*)*"', _protect, code)

    # Keywords
    cpp_kw = [
        'int', 'return', 'void', 'char', 'float', 'double',
        'if', 'else', 'for', 'while', 'class', 'struct',
        'public', 'private', 'protected', 'virtual', 'override',
        'const', 'static', 'bool', 'auto', 'long', 'short',
        'unsigned', 'signed', 'sizeof', 'typedef', 'enum',
        'union', 'volatile', 'extern', 'using', 'namespace',
        'template', 'typename', 'new', 'delete', 'this',
        'try', 'catch', 'throw', 'include', 'define',
        'nullptr', 'true', 'false', 'switch', 'case', 'break',
        'continue', 'default', 'do', 'goto',
    ]
    for kw in cpp_kw:
        code = re.sub(
            r'\b(' + re.escape(kw) + r')\b',
            r'<span class="code-kw">\1</span>', code
        )

    # Numbers
    code = re.sub(
        r'(?<!-)\b(\d+)\b(?![^<]*>)',
        r'<span class="code-num">\1</span>', code
    )

    # Preprocessor
    code = re.sub(
        r'(#\s*[a-zA-Z_]\w*)',
        r'<span class="code-annotation">\1</span>', code
    )

    # Restore
    for i, block in enumerate(protected):
        if block.startswith('//') or block.startswith('/*'):
            colored = f'<span class="code-comment">{html.escape(block)}</span>'
        else:
            colored = f'<span class="code-string">{html.escape(block)}</span>'
        code = code.replace(f'\x00PROT{i}\x00', colored)

    return code

def highlight_code_block(code, language):
    """Route code to the appropriate syntax highlighter based on language."""
    lang_lower = language.lower() if language else ""

    if lang_lower in ("dart",):
        return highlight_dart(code)
    elif lang_lower in ("yaml", "yml"):
        return highlight_yaml(code)
    elif lang_lower in ("bash", "sh", "shell", "powershell", "ps1", "terminal", "console"):
        return highlight_bash(code)
    elif lang_lower in ("cpp", "c++", "c", "c#", "cs"):
        return highlight_cpp(code)
    else:
        return html.escape(code)

def _process_inline_formatting(text):
    """Process inline markdown formatting: code, bold, italic, links."""
    # Inline code first — strip backticks to allow bold/italic inside
    text = re.sub(
        r'`([^`]+)`',
        lambda m: f'<code class="font-code-block bg-black text-white px-1 py-0.5 brutalist-border">{html.escape(m.group(1))}</code>',
        text,
    )

    # Protect already-wrapped code and link tags from subsequent regex
    protected = []

    def _protect(m):
        protected.append(m.group(0))
        return f'\x00PROT{len(protected) - 1}\x00'

    text = re.sub(r'<(?:code|a)\b[^>]*>.*?</(?:code|a)>', _protect, text)

    # Markdown links [text](url)
    text = re.sub(
        r'\[([^\]]+)\]\(([^)]+)\)',
        r'<a href="\2" class="text-primary dark:text-zinc-100 underline decoration-dotted underline-offset-2 hover:decoration-solid">\1</a>',
        text,
    )

    # Bold and italic
    text = re.sub(r'\*\*([^*]+)\*\*', r'<strong>\1</strong>', text)
    text = re.sub(r'(?<!\*)\*([^*]+)\*(?!\*)', r'<em>\1</em>', text)

    # Restore protected blocks
    for j, block in enumerate(protected):
        text = text.replace(f'\x00PROT{j}\x00', block)

    return text


def _build_html_table(rows):
    """Build HTML table from markdown table rows."""
    if len(rows) < 2:
        return "\n".join(rows)

    def _split_cells(row):
        # Strip leading/trailing pipes, split by |, trim whitespace
        return [cell.strip() for cell in row.strip().strip("|").split("|")]

    # First row is header
    header_cells = _split_cells(rows[0])
    # Second row is separator (skip it)
    # Remaining rows are body
    body_rows = rows[2:]

    html_parts = [
        '<div class="overflow-x-auto mb-stack-md">',
        '<table class="w-full border-collapse brutalist-border dark:border-zinc-700">',
        '<thead>',
        '<tr class="bg-zinc-100 dark:bg-zinc-800">',
    ]
    for cell in header_cells:
        html_parts.append(
            f'<th class="border border-zinc-300 dark:border-zinc-600 px-4 py-2 text-left font-label-md text-sm text-on-surface dark:text-zinc-200">{_process_inline_formatting(cell)}</th>'
        )
    html_parts.append('</tr>')
    html_parts.append('</thead>')
    html_parts.append('<tbody>')
    for row in body_rows:
        cells = _split_cells(row)
        html_parts.append(
            '<tr class="even:bg-zinc-50 dark:even:bg-zinc-800/50 hover:bg-zinc-100 dark:hover:bg-zinc-800 transition-colors">'
        )
        for cell in cells:
            html_parts.append(
                f'<td class="border border-zinc-300 dark:border-zinc-600 px-4 py-2 text-sm text-on-surface dark:text-zinc-300">{_process_inline_formatting(cell)}</td>'
            )
        html_parts.append('</tr>')
    html_parts.append('</tbody>')
    html_parts.append('</table>')
    html_parts.append('</div>')
    return "\n".join(html_parts)


def parse_markdown_blocks(body_text):
    """
    Stateful parser that splits markdown body into sections.
    Properly handles code blocks with empty lines inside them,
    unordered lists, markdown tables, and inline formatting.
    """
    lines = body_text.split("\n")
    sections = []
    pending_title = None
    i = 0
    n = len(lines)

    while i < n:
        line = lines[i]

        # Skip completely empty lines between blocks (but not inside code blocks)
        if line.strip() == "":
            i += 1
            continue

        # Code block start
        if line.strip().startswith("```"):
            # Parse code block header
            header_line = line.strip().strip("` ").strip()
            if ":" in header_line:
                lang, filename = header_line.split(":", 1)
            else:
                lang = header_line
                filename = f"code.{lang}" if lang else "code"
            lang = lang.strip()
            filename = filename.strip()

            # Collect all lines until closing ```
            code_lines = []
            i += 1
            while i < n:
                if lines[i].strip().startswith("```") and not lines[i].strip() == "```":
                    # This is a line that starts with ``` but has extra content (not a closer)
                    code_lines.append(lines[i])
                    i += 1
                    continue
                if lines[i].strip() == "```":
                    # Found closing ```
                    i += 1
                    break
                code_lines.append(lines[i])
                i += 1

            code_content = "\n".join(code_lines)

            # Apply syntax highlighting based on language
            highlighted_code = highlight_code_block(code_content, lang)

            sections.append({
                "type": "code",
                "language": lang.upper() if lang else "TEXT",
                "filename": filename,
                "code": highlighted_code,
            })
            pending_title = None
            continue

        # Heading ###
        if line.strip().startswith("### "):
            pending_title = line.strip()[4:].strip()
            i += 1
            continue

        # Image
        img_match = re.match(r'^!\[(.*?)\]\((.*?)\)$', line.strip())
        if img_match:
            alt, src = img_match.groups()
            sections.append({"type": "image", "title": pending_title, "src": src, "alt": alt})
            pending_title = None
            i += 1
            continue

        # ── Unordered list items ──
        stripped = line.strip()
        if stripped.startswith("- "):
            li_items = []
            while i < n:
                s = lines[i].strip()
                if not s.startswith("- "):
                    break
                indent = len(lines[i]) - len(lines[i].lstrip())
                item_text = s[2:]  # strip "- "
                formatted = _process_inline_formatting(item_text)
                # Apply indent-based padding for visual nesting
                pad_px = indent * 2
                inline_style = f' style="padding-left: {pad_px}px;"' if indent else ""
                li_items.append(f'<li{inline_style}>{formatted}</li>')
                i += 1

            if pending_title:
                sections.append({
                    "type": "prose",
                    "content": f'<h3 class="font-headline-md text-headline-md mb-stack-md border-l-4 border-primary dark:border-zinc-700 pl-4 uppercase text-primary dark:text-zinc-100">{pending_title}</h3>'
                })
                pending_title = None

            sections.append({
                "type": "prose",
                "content": f'<ul class="list-disc pl-6 space-y-1 mb-stack-md">{ "".join(li_items) }</ul>'
            })
            continue

        # ── Table rows ──
        if stripped.startswith("|") and stripped.endswith("|"):
            table_rows = []
            while i < n and lines[i].strip().startswith("|") and lines[i].strip().endswith("|"):
                table_rows.append(lines[i].strip())
                i += 1

            if pending_title:
                sections.append({
                    "type": "prose",
                    "content": f'<h3 class="font-headline-md text-headline-md mb-stack-md border-l-4 border-primary dark:border-zinc-700 pl-4 uppercase text-primary dark:text-zinc-100">{pending_title}</h3>'
                })
                pending_title = None

            sections.append({"type": "prose", "content": _build_html_table(table_rows)})
            continue

        # Regular prose paragraph
        prose_lines = []
        while (
            i < n
            and lines[i].strip() != ""
            and not lines[i].strip().startswith("```")
            and not lines[i].strip().startswith("### ")
            and not re.match(r'^!\[(.*?)\]\((.*?)\)$', lines[i].strip())
            and not lines[i].strip().startswith("- ")
            and not (lines[i].strip().startswith("|") and lines[i].strip().endswith("|"))
        ):
            prose_lines.append(lines[i])
            i += 1

        if prose_lines:
            content = "\n".join(prose_lines)
            content = _process_inline_formatting(content)

            if pending_title:
                sections.append({
                    "type": "prose",
                    "content": f'<h3 class="font-headline-md text-headline-md mb-stack-md border-l-4 border-primary dark:border-zinc-700 pl-4 uppercase text-primary dark:text-zinc-100">{pending_title}</h3>'
                })
                pending_title = None

            sections.append({"type": "prose", "content": content})

    return sections

def _safe_yaml_front_matter(yaml_text):
    """
    Pre-process YAML front matter to quote values containing YAML-special
    characters (colon, hash, braces, brackets) that would cause parse errors.
    """
    lines = yaml_text.split("\n")
    processed = []
    for line in lines:
        # Only process key: value pairs (not comments or empty lines)
        if re.match(r'^[a-zA-Z_][a-zA-Z0-9_]*\s*:', line):
            key, value = line.split(":", 1)
            value = value.strip()
            # Skip if already quoted or empty or numeric
            if value and not (value.startswith('"') or value.startswith("'")):
                # If value contains problematic YAML characters, quote it
                if any(ch in value for ch in [': ', '#', '{', '}', '[', ']', '&', '*', '!', '|', '>', '%', '@', '`', ',']):
                    # Escape existing double quotes and backslashes
                    value = value.replace('\\', '\\\\').replace('"', '\\"')
                    line = f'{key}: "{value}"'
        processed.append(line)
    return "\n".join(processed)


def _load_page(filepath, slug, output_subdir="", url_prefix=""):
    with open(filepath, "r", encoding="utf-8") as f:
        raw = f.read()

    if raw.startswith("---"):
        parts = raw.split("---", 2)
        meta = yaml.safe_load(_safe_yaml_front_matter(parts[1])) or {}
        body = parts[2]
    else:
        meta = {}
        body = raw

    url = f"{url_prefix}{slug}.html"
    return {
        "filepath": filepath,
        "filename": os.path.basename(filepath),
        "slug": slug,
        "meta": meta,
        "body": body,
        "url": url,
        "output_subdir": output_subdir,
    }

def discover_pages():
    index_page = None
    flat_pages = []
    slug_to_url = {"home": "index.html", "index": "index.html"}

    dir_pages = OrderedDict()

    for dirpath, dirnames, filenames in os.walk(CONTENT_DIR):
        dirnames.sort()
        filenames.sort()

        rel_dir = os.path.relpath(dirpath, CONTENT_DIR).replace("\\", "/")
        if rel_dir == ".":
            rel_dir = ""

        md_files = [f for f in filenames if f.endswith(".md")]
        if not md_files:
            continue

        pages = []
        for fname in md_files:
            slug = clean_slug(fname)
            url_prefix = (rel_dir + "/") if rel_dir else ""
            page = _load_page(
                os.path.join(dirpath, fname),
                slug,
                output_subdir=rel_dir,
                url_prefix=url_prefix
            )
            pages.append(page)

            if fname == "index.md" and rel_dir == "":
                index_page = page
                continue

            slug_to_url[page["slug"]] = page["url"]
            flat_pages.append(page)

        if pages:
            dir_pages[rel_dir] = pages

    def insert_into_tree(tree, rel_dir, pages):
        if not rel_dir:
            return

        parts = rel_dir.split("/")
        node = tree
        for i, part in enumerate(parts):
            if part not in node:
                node[part] = {"pages": [], "children": OrderedDict()}
            if i == len(parts) - 1:
                node[part]["pages"] = pages
            else:
                node = node[part]["children"]

    tree = OrderedDict()
    for rel_dir, pages in dir_pages.items():
        insert_into_tree(tree, rel_dir, pages)

    def tree_to_nav(node):
        nav = []
        for name, data in node.items():
            label = folder_label(name)
            children = []

            for page in data.get("pages", []):
                children.append({
                    "type": "link",
                    "title": page["meta"].get("title", page["slug"].capitalize()),
                    "url": page["url"],
                    "slug": page["slug"],
                })

            if data.get("children"):
                children.extend(tree_to_nav(data["children"]))

            nav.append({
                "type": "group",
                "label": label,
                "folder": name,
                "children": children,
            })
        return nav

    nav_groups = tree_to_nav(tree)

    return index_page, nav_groups, slug_to_url, flat_pages


def build_navigation(nav_groups, active_url, output_subdir=""):

    def process_items(items):
        result = []
        for item in items:
            if item["type"] == "link":
                is_active = item.get("url") == active_url
                result.append({
                    "type": "link",
                    "title": item["title"],
                    "url": relative_url(output_subdir, item["url"]),
                    "active": is_active,
                })
            elif item["type"] == "group":
                processed_children = process_items(item["children"])
                child_active = any(
                    c.get("active", False) or c.get("open", False)
                    for c in processed_children
                )
                result.append({
                    "type": "group",
                    "label": item["label"],
                    "children": processed_children,
                    "open": child_active,
                })
        return result

    return process_items(nav_groups)


def build_breadcrumbs(meta, slug_to_url, output_subdir=""):
    raw_crumbs = meta.get("breadcrumbs", [])
    result = []

    for i, crumb in enumerate(raw_crumbs):
        is_last = (i == len(raw_crumbs) - 1)

        if isinstance(crumb, dict):
            result.append({
                "title": crumb.get("title", ""),
                "url": relative_url(output_subdir, crumb.get("url", "#")),
                "active": crumb.get("active", is_last),
            })
        else:
            label = str(crumb)
            lookup_key = label.lower().replace(" ", "-")
            docs_url = slug_to_url.get(lookup_key, "#")
            result.append({
                "title": label,
                "url": relative_url(output_subdir, docs_url),
                "active": is_last,
            })

    return result

def _normalize_pagination_url(raw_url):
    """Ensure pagination URL has .html extension and proper format."""
    if not raw_url or raw_url.startswith("#"):
        return raw_url
    # If the URL already has an extension, return as-is
    if "." in raw_url.split("/")[-1]:
        return raw_url
    # Append .html if no extension
    return raw_url.rstrip("/") + ".html"

def render_page(template, page, navigation, slug_to_url, prev_page=None, next_page=None):
    slug = page["slug"]
    meta = page["meta"]
    output_subdir = page.get("output_subdir", "")
    sections = parse_markdown_blocks(page["body"])
    breadcrumbs = build_breadcrumbs(meta, slug_to_url, output_subdir=output_subdir)

    meta_pagination = meta.get("pagination", {}) or {}

    if meta_pagination.get("prev_title"):
        raw_prev_url = _normalize_pagination_url(meta_pagination.get("prev_url", "#"))
        prev_page = {
            "title": meta_pagination["prev_title"],
            "url": relative_url(output_subdir, raw_prev_url),
        }
    elif "prev_title" in meta_pagination and meta_pagination["prev_title"] is None:
        prev_page = None

    if meta_pagination.get("next_title"):
        raw_next_url = _normalize_pagination_url(meta_pagination.get("next_url", "#"))
        next_page = {
            "title": meta_pagination["next_title"],
            "url": relative_url(output_subdir, raw_next_url),
        }
    elif "next_title" in meta_pagination and meta_pagination["next_title"] is None:
        next_page = None

    if prev_page and "url" in prev_page:
        prev_page = dict(prev_page, url=relative_url(output_subdir, prev_page["url"]))
    if next_page and "url" in next_page:
        next_page = dict(next_page, url=relative_url(output_subdir, next_page["url"]))

    pagination_ctx = {}
    if prev_page:
        pagination_ctx["previous"] = prev_page
    if next_page:
        pagination_ctx["next"] = next_page

    ctx = {
        "site_title": "Monolith",
        "page_title": meta.get("title", slug.capitalize()),
        "page_subtitle": meta.get("subtitle") or "",
        "doc_version": "v1.0.4",
        "language_tag": meta.get("language"),
        "updated_date": meta.get("date"),
        "breadcrumbs": breadcrumbs,
        "navigation": navigation,
        "sections": sections,
        "pagination": pagination_ctx if pagination_ctx else None,
        "current_year": "2026",
        "github_url": "https://github.com",
        "is_homepage": (slug == "index"),
    }

    return template.render(ctx)

def build():
    print("Initializing Monolith Static Site Generator...")

    if os.path.exists(OUTPUT_DIR):
        shutil.rmtree(OUTPUT_DIR)
    os.makedirs(OUTPUT_DIR)

    env = Environment(loader=FileSystemLoader(TEMPLATE_DIR), autoescape=False)
    template = env.get_template(TEMPLATE_FILE)

    index_page, nav_groups, slug_to_url, flat_pages = discover_pages()

    print(f"Discovered {len(flat_pages)} content pages (plus index).")
    print(f"Navigation groups: {len(nav_groups)} root-level group(s).")

    if index_page:
        navigation = build_navigation(nav_groups, active_url=index_page["url"], output_subdir="")
        html = render_page(template, index_page, navigation, slug_to_url)
        out_path = os.path.join(OUTPUT_DIR, "index.html")
        with open(out_path, "w", encoding="utf-8") as f:
            f.write(html)
        print(f"Generated: {out_path}")

    pages_by_dir = OrderedDict()
    for page in flat_pages:
        key = page.get("output_subdir", "")
        pages_by_dir.setdefault(key, []).append(page)

    for subdir, pages in pages_by_dir.items():
        for i, page in enumerate(pages):
            prev_page = None
            next_page = None
            if i > 0:
                pp = pages[i - 1]
                prev_page = {"title": pp["meta"].get("title", pp["slug"].capitalize()), "url": pp["url"]}
            if i < len(pages) - 1:
                np = pages[i + 1]
                next_page = {"title": np["meta"].get("title", np["slug"].capitalize()), "url": np["url"]}

            out_subdir = page.get("output_subdir", "")
            navigation = build_navigation(nav_groups, active_url=page["url"], output_subdir=out_subdir)
            html = render_page(template, page, navigation, slug_to_url, prev_page, next_page)
            out_path = os.path.join(OUTPUT_DIR, page["url"])
            os.makedirs(os.path.dirname(out_path), exist_ok=True)
            with open(out_path, "w", encoding="utf-8") as f:
                f.write(html)
            print(f"Generated: {out_path}")

    print("Build complete! Static documentation available in docs/ folder.")

if __name__ == "__main__":
    build()