<p align="center"><img src="docs/logo.svg" width="96" alt="" /></p>

# gridspan

[![CI](https://github.com/Gulliby-development/gridspan/actions/workflows/ci.yml/badge.svg)](https://github.com/Gulliby-development/gridspan/actions/workflows/ci.yml) [![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

gridspan is a small, offline, standard-library-only Elixir command-line tool for checking and
working with named spreadsheet ranges such as `B2:D4`. It is intended for people using a
terminal, a script, or continuous integration (CI). It reads range descriptions from standard
input and supports validation, per-range sizing, combined coverage, intersections, and shifts.

## Build and run

The project requires Elixir `~> 1.15` and a compatible Erlang/OTP installation. The project
manifest does not pin a particular OTP release. No network connection or third-party dependency
is needed to build or run gridspan.

From the repository directory, build the escript:

```sh
mix escript.build
```

Then run a command, supplying range lines on standard input:

```sh
escript ./gridspan COMMAND
```

Replace `COMMAND` with one of the commands below. In the examples later in this guide,
`gridspan` is shorthand for the built escript invoked as `escript ./gridspan`; it is not a
separate command installed on the system.

The same Mix build and escript invocation are used on Windows, macOS, and Linux, provided
Elixir and Erlang/OTP are installed. In Windows PowerShell, pipe text to the escript or redirect
input from a file; in POSIX shells, the examples use `printf`. The escript path is relative to
the repository directory.

## Command line

The command synopsis is:

```text
usage: gridspan check [--rows N] [--cols N]
       gridspan size [--rows N] [--cols N]
       gridspan union [--rows N] [--cols N]
       gridspan overlap [--rows N] [--cols N]
       gridspan shift [--rows N] [--cols N]
```

The five command names are lowercase and case-sensitive. With no command, gridspan writes the
synopsis to standard error and exits with status 2. An unrecognized first word, including an
empty word or a differently capitalized command, reports `gridspan: unknown command WORD` and
also exits 2.

As the first word, `help`, `-h`, or `--help` prints the synopsis to standard output and exits
0. `--version` prints `gridspan 0.1.0` and exits 0. These help and version forms ignore any
words that follow them.

All five commands accept `--rows N` and `--cols N`. These options are validated for every
command, but only `shift` uses their values. The defaults are zero rows and zero columns. For
`shift`, positive row offsets move ranges down and negative offsets move them up; positive
column offsets move them right and negative offsets move them left.

Arguments after a command are checked from left to right, and the first problem is reported
without reading input. A word not beginning with a hyphen, including an empty word or exactly
`-`, is an unexpected argument. A hyphen-prefixed word other than `--rows` or `--cols` is an
unknown option. An option consumes the next word as its value even if that word looks like
another option. For each recognized option, checks are made in this order: whether that option
was already supplied, whether its value is missing, and whether the value is valid. Thus the
error templates are:

- `gridspan: unexpected argument WORD`
- `gridspan: unknown option WORD`
- `gridspan: given twice: OPTION`
- `gridspan: missing value for OPTION`
- `gridspan: bad value for OPTION`

An option value is a whole decimal number from `-9999` through `9999`. It may have a minus
sign but no plus sign; it cannot have leading zeroes, except that `0` itself is valid. Negative
zero is invalid. For example, `0`, `7`, and `-7` are valid values, while `007`, `+7`,
`-0`, and values outside the permitted range are not.

A valid invocation of one of the five commands reads standard input. Help, version, and invalid
command lines do not read it. A successful command exits 0, writes its result to standard output,
and writes nothing to standard error. A command-line error exits 2; an input error exits 1. On
failure, standard output is empty and standard error contains one line beginning with
`gridspan: `, followed by the message and a line feed. Text input and output use ASCII and LF
line endings.

## Input format

Each meaningful input line contains a name and a cell or range, separated by one or more spaces
or tabs:

```text
NAME RANGE
```

A name has 1 to 12 characters. It begins with a lowercase letter and is followed only by
lowercase letters, digits, or hyphens. Each name must be unique.

A cell consists of a column followed immediately by a row number. Columns use one or two
uppercase letters: `A` is column 1, `Z` is 26, `AA` is 27, and `ZZ` is 702, the final
column. Rows are decimal numbers from 1 through 9999, with no leading zero. For example,
`ZZ9999` is the last cell. Three-letter columns, lowercase letters, absent row numbers, zero,
leading-zero row numbers, and rows above 9999 are invalid.

A range is one cell or two cells separated by one colon, for example `B2:D4`. It covers all
cells between its start and end columns and rows, inclusive. The end must not be to the left of
the start or above it. A one-cell range can be written as `C3` or `C3:C3`.

Input is split at each LF. A final line without an LF still counts; empty input has no lines.
One CR at the end of each line is removed. Lines containing only spaces and tabs are ignored.
A line whose first word starts with `#` is a comment and is ignored; inline comments are not
supported. Ignored lines still count toward the maximum of 40 input lines. More than 40 lines
is reported before any other input error.

Leading and trailing spaces or tabs are ignored when separating the two words. Every other line
must have exactly two words. Input checks for each line occur in this order:

1. The line must have exactly two words.
2. The name must be valid.
3. The range syntax and its cells must be valid.
4. The range must not run backwards.
5. The name must not duplicate an earlier meaningful line.

Errors include the original 1-based line number, including skipped lines. The exact input error
templates are:

- `gridspan: input is too long (max 40 lines)`
- `gridspan: line N: expected NAME RANGE`
- `gridspan: line N: bad name WORD`
- `gridspan: line N: bad range WORD`
- `gridspan: line N: range runs backwards`
- `gridspan: line N: duplicate name NAME`

## Command outputs

All commands process ranges in input order. A range is printed canonically as `START:END`,
except that a one-cell range is printed as one cell such as `C3`, not `C3:C3`. Counts use a
singular noun only when the count is 1 (`1 range`, `0 ranges`, `1 cell`, `9 cells`).

- `check` prints `ok N ranges`, where N is the number of meaningful range lines. With no ranges,
  it prints `ok 0 ranges`.
- `size` prints one `NAME RANGE RxC N cells` line per range, in input order. R and C are the
  row and column counts for that range, and N is its cell count. It then prints `total T cells`,
  where T counts distinct covered cells, so a cell covered by multiple ranges is counted once.
  With no ranges, it prints `total 0 cells`.
- `union` prints `bounds none` when there are no ranges. Otherwise it prints `bounds RANGE`
  for the smallest rectangle containing all ranges, followed by `covered T of B cells`. T is
  the number of distinct covered cells, while B is the area of the bounding rectangle; T can
  be smaller than B. The word `cells` is always plural in this line.
- `overlap` prints each pair sharing at least one cell as `NAME1 NAME2 RANGE N cells`, followed
  by `overlaps K`. Pairs are ordered by input position: earlier first, then later partners in
  input order. The printed range is the inclusive intersection, and N is its cell count. A
  single shared cell is printed as that cell. Ranges that only meet along an edge without
  sharing a cell do not overlap. With no overlapping pairs, the only line is `overlaps 0`.
- `shift` prints `NAME OLD NEW` for every shifted range, in input order, then `shifted K ranges`.
  With no ranges, it prints `shifted 0 ranges`. The row and column offsets are signed, with
  positive values moving down/right and negative values moving up/left. Every shifted cell must
  stay within columns 1 through 702 and rows 1 through 9999. If any range would leave the
  sheet, the command reports the first such range in input order, using its original input line
  number, and produces no partial output: `gridspan: line N: NAME moves outside the sheet`.

## Examples

These examples use a POSIX shell in the repository directory, after building the escript with
`mix escript.build`. Here, `gridspan` stands for `escript ./gridspan`. The final example uses
`2>&1` to combine standard error with standard output so the error lines are visible.

```text
$ printf 'a A1:C3\nb B2:D4\n' | gridspan overlap
a b B2:C3 4 cells
overlaps 1
$ printf 'a A1:C3\nb B2:D4\nc F6\n' | gridspan size; printf 'a A1:C3\nb B2:D4\nc F6\n' | gridspan union
a A1:C3 3x3 9 cells
b B2:D4 3x3 9 cells
c F6 1x1 1 cell
total 15 cells
bounds A1:F6
covered 15 of 36 cells
$ printf 'a Z1:AA2\nb C3\n' | gridspan shift --cols 3 --rows 1
a Z1:AA2 AC2:AD3
b C3 F4
shifted 2 ranges
$ printf 'a B2:A1\n' | gridspan check 2>&1; printf 'a A1\n' | gridspan shift --rows -1 2>&1
gridspan: line 1: range runs backwards
gridspan: line 1: a moves outside the sheet
```

## Development

Run the project checks from the repository directory:

```sh
mix format --check-formatted
mix compile --warnings-as-errors
mix test
```

See [LICENSE](LICENSE) for the MIT license.

---

Built with [BAKED](https://github.com/Gulliby-development/baked), an open-source coding agent (bench round R97).
