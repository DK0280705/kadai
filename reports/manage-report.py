#!/usr/bin/env python3
"""manage-report.py — Create or delete LaTeX report scaffolding.

Usage:
  python3 manage-report.py create <folder-name> [title] [subject] [name] [dept] [num] [teacher]
  python3 manage-report.py delete <folder-name>
  python3 manage-report.py list

Examples:
  python3 manage-report.py create 数値経産2 "数値計算 後期" "数値経済・産業演習" "Deka Risman Permana" "人間情報システム工学科 4年" "4347" "小松一男 先生"
  python3 manage-report.py delete 数値経産2
"""

import json
import re
import shutil
import sys
from pathlib import Path

REPORTS_DIR    = Path(__file__).parent.resolve()
WORKSPACE_FILE = REPORTS_DIR / "reports.code-workspace"

# ── Workspace helpers (JSONC-safe: only touches the folders array) ────────────

def _load_workspace():
    """Return (folders, raw_content, re.Match) — only the folders array is parsed as JSON."""
    content = WORKSPACE_FILE.read_text(encoding="utf-8")
    m = re.search(r'"folders"\s*:\s*(\[.*?\])', content, re.DOTALL)
    if not m:
        raise RuntimeError("Could not locate 'folders' array in workspace file.")
    folders = json.loads(m.group(1))
    return folders, content, m


def _save_workspace(content: str, match: re.Match, folders: list) -> None:
    """Splice the modified folders list back into the raw content and save."""
    items = ['    {\n      "path": "' + f["path"] + '"\n    }' for f in folders]
    new_array = "[\n" + ",\n".join(items) + "\n  ]"
    new_content = content[: match.start(1)] + new_array + content[match.end(1) :]
    WORKSPACE_FILE.write_text(new_content, encoding="utf-8")


def workspace_add(folder_name: str) -> None:
    folders, content, match = _load_workspace()
    if any(f.get("path") == folder_name for f in folders):
        print(f"  Note: '{folder_name}' is already in the workspace file — skipping.")
        return
    folders.append({"path": folder_name})
    _save_workspace(content, match, folders)
    print(f"  Added '{folder_name}' to {WORKSPACE_FILE.name}")


def workspace_remove(folder_name: str) -> None:
    folders, content, match = _load_workspace()
    new_folders = [f for f in folders if f.get("path") != folder_name]
    if len(new_folders) == len(folders):
        print(f"  Note: '{folder_name}' was not found in the workspace file.")
        return
    _save_workspace(content, match, new_folders)
    print(f"  Removed '{folder_name}' from {WORKSPACE_FILE.name}")


# ── Commands ──────────────────────────────────────────────────────────────────

def cmd_create(args: list) -> None:
    if not args:
        print("Error: 'create' requires a folder name.", file=sys.stderr)
        sys.exit(1)

    folder_name  = args[0]
    report_title = args[1] if len(args) > 1 else "レポートタイトル"
    subject      = args[2] if len(args) > 2 else "プログラミング実験"
    student_name = args[3] if len(args) > 3 else "Deka Risman Permana"
    department   = args[4] if len(args) > 4 else "人間情報システム工学科 4年"
    attendance   = args[5] if len(args) > 5 else "4347"
    teacher      = args[6] if len(args) > 6 else "先生"

    dest = REPORTS_DIR / folder_name
    if dest.exists():
        print(f"Error: '{dest}' already exists.", file=sys.stderr)
        sys.exit(1)

    (dest / "code").mkdir(parents=True)
    (dest / "images").mkdir(parents=True)

    def w(path: Path, text: str) -> None:
        path.write_text(text, encoding="utf-8")

    w(dest / "main.tex", _main_tex(subject, report_title, student_name, department, attendance, teacher))
    w(dest / "Makefile", _MAKEFILE)
    w(dest / ".latexmkrc", _LATEXMKRC)
    w(dest / "images" / "README.md", _IMAGES_README)

    workspace_add(folder_name)

    print(f"\nReport scaffolded at: {dest}")
    print(f"\nNext steps:")
    print(f"  cd '{dest}'")
    print(f"  make          # build PDF")
    print(f"  make clean    # remove intermediate files")


def cmd_delete(args: list) -> None:
    if not args:
        print("Error: 'delete' requires a folder name.", file=sys.stderr)
        sys.exit(1)

    folder_name = args[0]
    dest = REPORTS_DIR / folder_name

    if not dest.exists():
        print(f"Error: '{dest}' does not exist.", file=sys.stderr)
        sys.exit(1)

    try:
        answer = input(f"Delete '{dest}' and remove from workspace? [y/N] ").strip().lower()
    except (EOFError, KeyboardInterrupt):
        print("\nAborted.")
        sys.exit(0)

    if answer != "y":
        print("Aborted.")
        sys.exit(0)

    shutil.rmtree(dest)
    print(f"  Deleted '{dest}'")

    workspace_remove(folder_name)


def cmd_list(_args: list) -> None:
    folders, _, _ = _load_workspace()
    print("Reports in workspace:")
    for f in folders:
        path = f.get("path", "")
        exists = "✓" if (REPORTS_DIR / path).exists() else "✗ (missing)"
        print(f"  {path}  {exists}")


# ── Templates ─────────────────────────────────────────────────────────────────

def _main_tex(subject, report_title, student_name, department, attendance, teacher) -> str:
    # Use simple replacement to avoid conflicts with LaTeX's heavy use of { } and %
    template = (
        r"% !TEX root = main.tex"                                                    "\n"
        r"\documentclass[12pt,a4paper]{ltjsreport}"                                  "\n"
        "\n"
        r"%% Fonts"                                                                   "\n"
        r"\usepackage{lmodern}"                                                       "\n"
        r"\usepackage{luatexja-preset}"                                               "\n"
        "\n"
        r"%% Layout"                                                                  "\n"
        r"\usepackage[top=30mm, bottom=25mm, left=25mm, right=25mm]{geometry}"       "\n"
        "\n"
        r"%% Color / graphics"                                                        "\n"
        r"\usepackage[svgnames,table]{xcolor}"                                        "\n"
        r"\usepackage{graphicx}"                                                      "\n"
        "\n"
        r"%% Diagrams / charts"                                                       "\n"
        r"\usepackage{tikz}"                                                          "\n"
        r"\usepackage{pgfplots}"                                                      "\n"
        r"\pgfplotsset{compat=1.18}"                                                  "\n"
        "\n"
        r"%% Source code listings"                                                    "\n"
        r"\usepackage{listings}"                                                      "\n"
        "\n"
        r"%% Hyperlinks (load near last)"                                             "\n"
        r"\usepackage{hyperref}"                                                      "\n"
        "\n"
        r"%% Header / footer"                                                         "\n"
        r"\usepackage{fancyhdr}"                                                      "\n"
        "\n"
        r"%% Captions"                                                                "\n"
        r"\usepackage[format=hang, font=small, labelfont=bf]{caption}"               "\n"
        r"\usepackage{subcaption}"                                                    "\n"
        "\n"
        r"%% Mathematics"                                                             "\n"
        r"\usepackage{amsmath}"                                                       "\n"
        r"\usepackage{amssymb}"                                                       "\n"
        "\n"
        r"%% Professional table rules"                                                "\n"
        r"\usepackage{booktabs}"                                                      "\n"
        "\n"
        r"%% URL"                                                                     "\n"
        r"\usepackage{url}"                                                           "\n"
        "\n"
        r"%% List customization"                                                      "\n"
        r"\usepackage{enumitem}"                                                      "\n"
        "\n"
        r"%% ── Source Code Appearance ───────────────────────────────────"           "\n"
        r"\definecolor{codebg}{RGB}{248,248,248}"                                     "\n"
        r"\definecolor{codeframe}{RGB}{180,180,180}"                                  "\n"
        r"\definecolor{kwcolor}{RGB}{0,0,180}"                                        "\n"
        r"\definecolor{cmcolor}{RGB}{100,100,100}"                                    "\n"
        r"\definecolor{stcolor}{RGB}{160,0,0}"                                        "\n"
        "\n"
        r"\lstset{"                                                                    "\n"
        r"  backgroundcolor  = \color{codebg},"                                       "\n"
        r"  basicstyle       = \ttfamily\small,"                                      "\n"
        r"  keywordstyle     = \color{kwcolor}\bfseries,"                             "\n"
        r"  commentstyle     = \color{cmcolor}\itshape,"                              "\n"
        r"  stringstyle      = \color{stcolor},"                                      "\n"
        r"  numbers          = left,"                                                  "\n"
        r"  numberstyle      = \tiny\color{gray},"                                    "\n"
        r"  numbersep        = 8pt,"                                                   "\n"
        r"  frame            = single,"                                                "\n"
        r"  rulecolor        = \color{codeframe},"                                    "\n"
        r"  breaklines       = true,"                                                  "\n"
        r"  breakatwhitespace= false,"                                                 "\n"
        r"  showstringspaces = false,"                                                 "\n"
        r"  tabsize          = 4,"                                                     "\n"
        r"  captionpos       = b,"                                                     "\n"
        r"  xleftmargin      = 2em,"                                                   "\n"
        r"  framexleftmargin = 1.5em,"                                                 "\n"
        r"}"                                                                           "\n"
        "\n"
        r"%% ── Page Style ───────────────────────────────────────────────"           "\n"
        r"\pagestyle{fancy}"                                                           "\n"
        r"\fancyhf{}"                                                                  "\n"
        r"\rhead{\small <<SUBJECT>>}"                                                  "\n"
        r"\lhead{\small \nouppercase{\leftmark}}"                                      "\n"
        r"\cfoot{\thepage}"                                                            "\n"
        r"\renewcommand{\headrulewidth}{0.4pt}"                                        "\n"
        "\n"
        r"\fancypagestyle{titlepage}{"                                                 "\n"
        r"  \fancyhf{}"                                                                "\n"
        r"  \renewcommand{\headrulewidth}{0pt}"                                        "\n"
        r"}"                                                                           "\n"
        r"\fancypagestyle{frontmatter}{"                                               "\n"
        r"  \fancyhf{}"                                                                "\n"
        r"  \cfoot{\thepage}"                                                          "\n"
        r"  \renewcommand{\headrulewidth}{0pt}"                                        "\n"
        r"}"                                                                           "\n"
        "\n"
        r"%% ── Hyperlink / PDF metadata ─────────────────────────────────"           "\n"
        r"\hypersetup{"                                                                "\n"
        r"  colorlinks = true,"                                                        "\n"
        r"  linkcolor  = NavyBlue,"                                                    "\n"
        r"  citecolor  = NavyBlue,"                                                    "\n"
        r"  urlcolor   = NavyBlue,"                                                    "\n"
        r"  pdftitle   = {<<REPORT_TITLE>>},"                                          "\n"
        r"  pdfauthor  = {<<STUDENT_NAME>>},"                                          "\n"
        r"  pdfsubject = {<<SUBJECT>>},"                                               "\n"
        r"  pdfkeywords= {<<DEPARTMENT>>},"                                            "\n"
        r"}"                                                                           "\n"
        "\n"
        r"\newcommand{\HRule}{\rule{\linewidth}{0.5mm}}"                               "\n"
        "\n"
        r"\title{}"                                                                    "\n"
        r"\date{}"                                                                     "\n"
        r"\author{}"                                                                   "\n"
        "\n"
        r"%% ============================================================"            "\n"
        r"\begin{document}"                                                            "\n"
        r"%% ============================================================"            "\n"
        "\n"
        r"%% ── Title Page ───────────────────────────────────────────────"           "\n"
        r"\begin{titlepage}"                                                           "\n"
        r"  \thispagestyle{titlepage}"                                                 "\n"
        r"  \centering"                                                                "\n"
        r"  \vspace*{2cm}"                                                             "\n"
        "\n"
        r"  {\large <<SUBJECT>>}\\[0.5em]"                                             "\n"
        r"  {\large レポート}\\[2em]"                                                  "\n"
        "\n"
        r"  \HRule{}\\[1em]"                                                           "\n"
        r"  {\LARGE \textbf{<<REPORT_TITLE>>}}\\[0.5em]"                               "\n"
        r"  \HRule{}"                                                                  "\n"
        "\n"
        r"  \vspace{3cm}"                                                              "\n"
        "\n"
        r"  \begin{tabular}{rl}"                                                       "\n"
        r"    \textbf{氏　　名} & ：<<STUDENT_NAME>> \\[0.4em]"                        "\n"
        r"    \textbf{学　　科} & ：<<DEPARTMENT>> \\[0.4em]"                           "\n"
        r"    \textbf{出席番号} & ：<<ATTENDANCE>> \\[0.4em]"                           "\n"
        r"    \textbf{担当教員} & ：<<TEACHER>> \\"                                     "\n"
        r"  \end{tabular}"                                                             "\n"
        "\n"
        r"  \vfill"                                                                    "\n"
        "\n"
        r"  \textbf{提出日：}\today"                                                   "\n"
        "\n"
        r"\end{titlepage}"                                                             "\n"
        "\n"
        r"%% ── Table of Contents ────────────────────────────────────────"           "\n"
        r"\newpage"                                                                    "\n"
        r"\thispagestyle{frontmatter}"                                                 "\n"
        r"\pagenumbering{roman}"                                                       "\n"
        r"\tableofcontents"                                                            "\n"
        "\n"
        r"\newpage"                                                                    "\n"
        r"\pagenumbering{arabic}"                                                      "\n"
        r"\setcounter{page}{1}"                                                        "\n"
        "\n"
        r"%% ── Sections ─────────────────────────────────────────────────"           "\n"
        "\n"
        r"\section{はじめに}\label{sec:intro}"                                         "\n"
        "\n"
        r"% TODO: 背景・目的・レポートの構成を記述する"                                   "\n"
        "\n"
        r"\section{実験環境}\label{sec:env}"                                            "\n"
        "\n"
        r"% TODO: ハードウェア・ソフトウェア環境を記述する"                               "\n"
        "\n"
        r"\section{実験方法}\label{sec:method}"                                         "\n"
        "\n"
        r"% TODO: 実装方法・手順を記述する"                                               "\n"
        "\n"
        r"\section{実験結果}\label{sec:result}"                                         "\n"
        "\n"
        r"% TODO: 実験結果を記述する"                                                    "\n"
        "\n"
        r"\section{考察}\label{sec:discussion}"                                         "\n"
        "\n"
        r"% TODO: 結果に対する考察を記述する"                                             "\n"
        "\n"
        r"\section{まとめ}\label{sec:summary}"                                          "\n"
        "\n"
        r"% TODO: まとめを記述する"                                                      "\n"
        "\n"
        r"\end{document}"                                                              "\n"
    )
    return (
        template
        .replace("<<SUBJECT>>",      subject)
        .replace("<<REPORT_TITLE>>", report_title)
        .replace("<<STUDENT_NAME>>", student_name)
        .replace("<<DEPARTMENT>>",   department)
        .replace("<<ATTENDANCE>>",   attendance)
        .replace("<<TEACHER>>",      teacher)
    )


_MAKEFILE = """\
MAIN       := main
LATEX      := lualatex
LATEXFLAGS := -interaction=nonstopmode -halt-on-error -synctex=1
LATEXMK    := latexmk

.PHONY: all pdf images clean distclean

all:
\t@if command -v $(LATEXMK) > /dev/null 2>&1; then \\
\t    $(MAKE) pdf-latexmk; \\
\telse \\
\t    $(MAKE) pdf-manual; \\
\tfi

pdf-latexmk:
\t$(LATEXMK) $(MAIN).tex

pdf-manual:
\t$(LATEX) $(LATEXFLAGS) $(MAIN).tex
\t$(LATEX) $(LATEXFLAGS) $(MAIN).tex
\t@echo "---"
\t@echo "PDF generated: $(MAIN).pdf"

images:
\tpython3 code/analysis.py

clean:
\trm -f $(MAIN).aux  $(MAIN).log  $(MAIN).toc  $(MAIN).out  \\
\t       $(MAIN).synctex.gz $(MAIN).fls $(MAIN).fdb_latexmk \\
\t       $(MAIN).nav $(MAIN).snm $(MAIN).vrb

distclean: clean
\trm -f $(MAIN).pdf
"""

_LATEXMKRC = """\
$lualatex = 'lualatex -interaction=nonstopmode -halt-on-error -synctex=1 %O %S';
$pdf_mode = 4;
$pdf_previewer = 'evince';
$preview_continuous_mode = 0;
@default_files = ('main.tex');
"""

_IMAGES_README = """\
# images/

Place generated figures here (PNG, PDF, etc.).

Run `make images` to generate figures from `code/analysis.py`.
"""

# ── Entry point ───────────────────────────────────────────────────────────────

_COMMANDS = {"create": cmd_create, "delete": cmd_delete, "list": cmd_list}


def main() -> None:
    if len(sys.argv) < 2 or sys.argv[1] in ("-h", "--help"):
        print(__doc__)
        sys.exit(0)

    command = sys.argv[1]
    rest    = sys.argv[2:]

    handler = _COMMANDS.get(command)
    if handler is None:
        print(f"Unknown command '{command}'. Use: {', '.join(_COMMANDS)}.", file=sys.stderr)
        sys.exit(1)

    handler(rest)


if __name__ == "__main__":
    main()
