defmodule Gridspan.OptionsTest do
  use Gridspan.RowCase

  rows([
    row(["check", "x"], "", 2, "", "gridspan: unexpected argument x\n"),
    row(["check", ""], "", 2, "", "gridspan: unexpected argument \n"),
    row(["size", "-"], "", 2, "", "gridspan: unexpected argument -\n"),
    row(["check", "--nope"], "", 2, "", "gridspan: unknown option --nope\n"),
    row(["shift", "--rows"], "", 2, "", "gridspan: missing value for --rows\n"),
    row(["shift", "--cols"], "", 2, "", "gridspan: missing value for --cols\n"),
    row(["shift", "--rows", "x"], "", 2, "", "gridspan: bad value for --rows\n"),
    row(["shift", "--rows", ""], "", 2, "", "gridspan: bad value for --rows\n"),
    row(["shift", "--rows", "+1"], "", 2, "", "gridspan: bad value for --rows\n"),
    row(["shift", "--rows", "-0"], "", 2, "", "gridspan: bad value for --rows\n"),
    row(["shift", "--rows", "00"], "", 2, "", "gridspan: bad value for --rows\n"),
    row(["shift", "--rows", "007"], "", 2, "", "gridspan: bad value for --rows\n"),
    row(["shift", "--rows", "1.5"], "", 2, "", "gridspan: bad value for --rows\n"),
    row(["shift", "--rows", "10000"], "", 2, "", "gridspan: bad value for --rows\n"),
    row(["shift", "--rows", "-10000"], "", 2, "", "gridspan: bad value for --rows\n"),
    row(["shift", "--rows", "1", "--rows", "2"], "", 2, "", "gridspan: given twice: --rows\n"),
    row(["shift", "--rows", "x", "--rows", "2"], "", 2, "", "gridspan: bad value for --rows\n"),
    row(["shift", "--rows", "--cols"], "", 2, "", "gridspan: bad value for --rows\n"),
    row(["shift", "--cols", "1", "extra"], "", 2, "", "gridspan: unexpected argument extra\n"),
    row(["check", "--rows", "3"], "a A1:C3\nb B2:D4\nc F6\n", 0, "ok 3 ranges\n", ""),
    row(["shift", "--rows=1"], "", 2, "", "gridspan: unknown option --rows=1\n"),
    row(["shift", "--bogus", "--rows"], "", 2, "", "gridspan: unknown option --bogus\n"),
    row(["size", "--cols", "-4", "--rows", "7"], "a A1:C3\nb B2:D4\nc F6\n", 0, "a A1:C3 3x3 9 cells\nb B2:D4 3x3 9 cells\nc F6 1x1 1 cell\ntotal 15 cells\n", ""),
    row(["shift", "--cols", "9999"], "only C3\n", 1, "", "gridspan: line 1: only moves outside the sheet\n"),
    row(["shift", "--rows", "-9999"], "", 0, "shifted 0 ranges\n", ""),
    row(["shift", "--rows", "-1", "--cols", "-1"], "a A1:C3\nb B2:D4\nc F6\n", 1, "", "gridspan: line 1: a moves outside the sheet\n")
  ])
end
