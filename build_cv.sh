#!/usr/bin/env bash
# Compiles cv_res/*.tex -> PDFs in the project root (run automatically by Quarto pre-render).
set -euo pipefail
cd "$(dirname "$0")"
# Make sure TinyTeX / MacTeX are on PATH (Quarto subprocesses may not inherit your shell PATH)
export PATH="$HOME/Library/TinyTeX/bin/universal-darwin:/Library/TeX/texbin:/usr/local/bin:/opt/homebrew/bin:$PATH"
command -v latexmk >/dev/null || { echo "latexmk not found; install TinyTeX (quarto install tinytex) or MacTeX" >&2; exit 1; }
BUILD=cv_res/.build
mkdir -p "$BUILD"
for f in zh_cv zh_resume; do
  latexmk -pdf -interaction=nonstopmode -halt-on-error -quiet \
    -output-directory="$BUILD" "cv_res/$f.tex" >"$BUILD/$f.log" 2>&1 \
    || { echo "LaTeX failed for $f; see $BUILD/$f.log" >&2; tail -30 "$BUILD/$f.log" >&2; exit 1; }
  cp "$BUILD/$f.pdf" "$f.pdf"
  echo "Built $f.pdf"
done
