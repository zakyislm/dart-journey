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
        return docs_root_url

    clean_url = docs_root_url.replace("\\", "/")
    target_parts = clean_url.split("/")
    from_parts   = from_subdir.replace("\\", "/").split("/")

    if len(target_parts) == 1:
        return clean_url

    if target_parts[:-1] == from_parts:
        return target_parts[-1]

    ups = "../" * len(from_parts)
    return ups + clean_url

def parse_markdown_blocks(body_text):
    raw_blocks = body_text.split("\n\n")
    sections = []
    pending_title = None

    for block in raw_blocks:
        block = block.strip()
        if not block:
            continue

        if block.startswith("```"):
            lines = block.split("\n")
            header_line = lines[0].strip("` ")
            if ":" in header_line:
                lang, filename = header_line.split(":", 1)
            else:
                lang = header_line
                filename = f"code.{lang}" if lang else "code"

            code_lines = lines[1:-1] if lines[-1].startswith("```") else lines[1:]
            code_content = "\n".join(code_lines)

            if lang in ["cpp", "c++", "c"]:
                code_content = re.sub(
                    r'\b(int|return|void|char|float|double|if|else|for|while|class|struct|public|private)\b',
                    r'<span class="text-blue-400">\1</span>', code_content)
                code_content = re.sub(
                    r'(?<!-)\b(\d+)\b(?![^<]*>)',
                    r'<span class="text-orange-400">\1</span>', code_content)

            sections.append({"type": "code", "language": lang.upper() if lang else "TEXT",
                              "filename": filename, "code": code_content})
            pending_title = None
            continue

        if block.startswith("### "):
            pending_title = block[4:].strip()
            continue

        img_match = re.match(r'^!\[(.*?)\]\((.*?)\)$', block)
        if img_match:
            alt, src = img_match.groups()
            sections.append({"type": "image", "title": pending_title, "src": src, "alt": alt})
            pending_title = None
            continue

        content = block
        content = re.sub(r'`([^`]+)`',
                         lambda m: f'<code class="font-code-block bg-black text-white px-1 py-0.5 brutalist-border">{html.escape(m.group(1))}</code>',
                         content)

        code_blocks = []
        def _protect_code(m):
            code_blocks.append(m.group(0))
            return f'\x00CODE{len(code_blocks)-1}\x00'
        content = re.sub(r'<code[^>]*>.*?</code>', _protect_code, content)

        content = re.sub(r'\*\*([^*]+)\*\*', r'<strong>\1</strong>', content)
        content = re.sub(r'\*([^*]+)\*',    r'<em>\1</em>', content)

        for i, block in enumerate(code_blocks):
            content = content.replace(f'\x00CODE{i}\x00', block)

        if pending_title:
            sections.append({
                "type": "prose",
                "content": f'<h3 class="font-headline-md text-headline-md mb-stack-md border-l-4 border-primary dark:border-zinc-700 pl-4 uppercase text-primary dark:text-zinc-100">{pending_title}</h3>'
            })
            pending_title = None

        sections.append({"type": "prose", "content": content})

    return sections

def _load_page(filepath, slug, output_subdir="", url_prefix=""):
    with open(filepath, "r", encoding="utf-8") as f:
        raw = f.read()

    if raw.startswith("---"):
        parts = raw.split("---", 2)
        meta = yaml.safe_load(parts[1]) or {}
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

def render_page(template, page, navigation, slug_to_url, prev_page=None, next_page=None):
    slug = page["slug"]
    meta = page["meta"]
    output_subdir = page.get("output_subdir", "")
    sections = parse_markdown_blocks(page["body"])
    breadcrumbs = build_breadcrumbs(meta, slug_to_url, output_subdir=output_subdir)

    meta_pagination = meta.get("pagination", {}) or {}

    if meta_pagination.get("prev_title"):
        raw_prev_url = meta_pagination.get("prev_url", "#")
        prev_page = {
            "title": meta_pagination["prev_title"],
            "url": relative_url(output_subdir, raw_prev_url),
        }
    elif "prev_title" in meta_pagination and meta_pagination["prev_title"] is None:
        prev_page = None

    if meta_pagination.get("next_title"):
        raw_next_url = meta_pagination.get("next_url", "#")
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
