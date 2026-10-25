# showhanmengrid Package

**LaTeX: Show the hanmen grid of Japanese text and its overflow on every page**

The hanmen (kihon hanmen, the basic text block) of Japanese typesetting is built from the character size (1zw), the number of characters per line, the number of lines per page and the line feed. When `\textwidth` is a multiple of 1zw and `\textheight` is `\topskip` plus a multiple of `\baselineskip`, every character of the body text sits on a fixed grid: the text is *set solid* (beta-gumi).

The showhanmengrid package draws, in the background of every page,

1. **in cyan**, one square of 1zw × 1zw for each character position (characters per line × lines per page), and the frame of the whole grid;
2. **in magenta**, the *overflow*: the part of the text area that does not fit the grid.
   * Along the lines: `\textwidth` − characters × 1zw. It is distributed into inter-character spaces, i.e. the text is not set solid.
   * Across the lines: `\textheight` − `\topskip` − (lines − 1) × `\baselineskip`. The page is not filled by whole lines.
3. **in magenta**, when the character pitch is not 1zw, a note in the top margin (see below).

A text area with an overflow is common when only the four margins are given (as in word processors or with the geometry package). For example, the default layout of jbook, ujbook and ltjbook has `\textwidth` = 327pt, the value of the standard book class, which is 33.98zw at 10pt; their `\textheight` is also truncated to whole points by `\@settopoint`, so that one line is lost. jsbook and ltjsbook set `\textwidth` to a multiple of 1zw, and jlreq sets the text solid by itself.

Both horizontal (yoko) and vertical (tate) writing are supported.

* **Supported formats/engines:** pLaTeX, upLaTeX (+ dvipdfmx), LuaLaTeX + LuaTeX-ja (LaTeX2e 2025-06-01 or later)
* **Trim marks:** the `tombo` option of jclasses/jsclasses (`\iftombow` of pLaTeX), the gentombow package and jlreq-trimmarks are taken into account.
* **Not supported:** two-column layout; `\mag` other than 1000 (the package warns and draws nothing)

## Files

| File | Description |
|---|---|
| `showhanmengrid.sty` | The package |
| `showhanmengrid.tex` / `.pdf` | Documentation |
| `test-*.tex` | Test suite (see below) |
| `jfm-shgtest.lua` | A minimal JFM for `test-jfm.tex` |

## Requirements

* LaTeX2e 2025-06-01 or later (pLaTeX2e/upLaTeX2e built on it, or LuaLaTeX with LuaTeX-ja)
* `xcolor`

## Installation

Copy `showhanmengrid.sty` to your local TeX tree:
`$TEXMF/tex/latex/showhanmengrid/`

## Usage

```latex
\usepackage{showhanmengrid}
```

The number of characters per line and the number of lines per page are computed at `\begin{document}` from `\textwidth`, `\textheight` and `\topskip`, and from 1zw and `\baselineskip` of `\normalsize`. The writing direction is detected from the document (`\tate` of pTeX, `direction=3` of LuaTeX-ja).

Keys can be given as package options or with `\showhanmengridsetup` in the preamble:

```latex
\usepackage[color=blue!50, overflow=false]{showhanmengrid}
\showhanmengridsetup{rulewidth=0.2pt}
```

| Key | Default | Description |
|---|---|---|
| `color` | `cyan` | color of the grid |
| `overflowcolor` | `magenta` | color of the overflow |
| `rulewidth` | `0.1pt` | width of the grid lines |
| `frame` | `true` | draw the frame of the whole grid |
| `overflow` | `true` | draw the overflow |
| `chars` | (computed) | characters per line |
| `lines` | (computed) | lines per page |
| `ascent` | `0.88zw` | yoko: height of the character face above the baseline |
| `pitch` | `zw` | pitch of the squares along the line: `zw`, `natural` (the natural character pitch) or a length |
| `note` | `true` | draw the note on a character pitch other than 1zw |

The grid size and the overflow are also written to the log, e.g.

```
Package showhanmengrid Info: yoko: 33 chars x 39 lines,
(showhanmengrid)             1zw=9.6222pt, line feed=15.0pt,
(showhanmengrid)             grid=317.53235pt x 579.6222pt on input line 3.
Package showhanmengrid Info: overflow along the line: 9.46765pt
(showhanmengrid)             (0.98zw); the text is not set solid
(showhanmengrid)             and inter-character spaces will be stretched on input line 3.
```

## Character pitch other than 1zw

The text may be set with space between ideographs, e.g. *shibu-aki* (0.25zw, common in tate), either with `\kanjiskip` or, more properly, with the glue of the JFM (TFM). The package measures the natural character pitch of `\normalsize` as the width of 「漢漢漢」 minus that of 「漢」, divided by 2, which includes both kinds of space. When it is not 1zw, a one-line note is drawn in the top margin of every page and written to the log, e.g.

```
showhanmengrid: character pitch = 1.25zw, not 1zw (\kanjiskip = 0zw, JFM +0.25zw); squares at pitch=zw
```

By default (`pitch=zw`) the squares are those of the hanmen design (1zw each, side by side), so that you can see the characters drift away from them. With `pitch=natural` the squares (still 1zw) are placed at the measured character pitch: the number of characters per line is ⌊(`\textwidth` − 1zw) / pitch⌋ + 1, and the rest is the overflow. `pitch=<length>` gives the pitch directly (e.g. `pitch=1.25zw`).

```latex
\usepackage[pitch=natural]{showhanmengrid}
```

## Testing

`make test` compiles every test with pLaTeX, upLaTeX (+ dvipdfmx) and LuaLaTeX, and checks the log:

* `SHG-EXPECT OK`: the writing direction, the number of characters and lines, and the overflow are as expected.
* `SHG-POS OK`: the first character of a page sits in the top left square of the grid as drawn, on odd and even pages (measured with `\pdfsavepos`/`\savepos`); some tests also check the end of the last square of a line.
* `SHG-NOTE OK`: the note on the character pitch is as expected (or absent). With LuaTeX-ja in tate, the check is skipped (`SHG-POS SKIP`): LuaTeX-ja typesets tate text in a rotated box whose `\savepos` coordinates are not those of the page; check the PDF instead.

| Test | Engines | What it covers |
|---|---|---|
| `test-ptex.tex` | platex, uplatex | yoko book design, 13Q, 42 chars × 33 lines |
| `test-ptex-tate.tex` | platex, uplatex | tate book design, 15Q, 38 chars × 14 lines |
| `test-luatexja.tex` | lualatex | the design of `test-ptex.tex` on ltjbook |
| `test-luatexja-tate.tex` | lualatex | the design of `test-ptex-tate.tex` on ltjtbook |
| `test-jlreq.tex` | platex, uplatex, lualatex | jlreq, yoko and tate (`\def\TATE{1}`) |
| `test-overflow.tex` | platex, uplatex, lualatex | default layouts of jbook/ujbook/ltjbook (overflow) and jsbook/ltjsbook |
| `test-keys.tex` | uplatex, lualatex | the keys |
| `test-kanjiskip.tex` | platex, uplatex, lualatex | shibu-aki by `\kanjiskip=.25zw`, `pitch=zw` and `pitch=natural` (`\def\PITCH{natural}`) |
| `test-jfm.tex` | lualatex | shibu-aki by the JFM `jfm-shgtest.lua`, `pitch=zw` and `pitch=natural` |
| `test-tombo.tex` | platex, uplatex, lualatex | trim marks: jbook/jsbook/utbook `tombo`, gentombow, jlreq-trimmarks |
| `test-mag.tex` | platex, lualatex | warning with `\mag=1200`, nothing drawn |
| `test-nojapanese.tex` | pdflatex | warning without pTeX or LuaTeX-ja |

`test-common.tex` holds the helpers shared by the tests.

## Repository

* <https://github.com/munepi/showhanmengrid>
* Bug reports: <https://github.com/munepi/showhanmengrid/issues>

## License

This package is licensed under the conditions of the [LaTeX Project Public License](https://www.latex-project.org/lppl.txt), either version 1.3c of this license or any later version.

Copyright (c) 2026 Munehiro Yamamoto
