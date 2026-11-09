defmodule Gridspan.SheetTest do
  use Gridspan.RowCase

  rows([
    row(["check"], "abcdefghijkl A1\n", 0, "ok 1 range\n", ""),
    row(["check"], "abcdefghijklm A1\n", 1, "", "gridspan: line 1: bad name abcdefghijklm\n"),
    row(["check"], "a ZZ9999\n", 0, "ok 1 range\n", ""),
    row(["check"], "a AAA1\n", 1, "", "gridspan: line 1: bad range AAA1\n"),
    row(["check"], "a A10000\n", 1, "", "gridspan: line 1: bad range A10000\n"),
    row(["check"], "a ZZ9999:ZZ9999\n", 0, "ok 1 range\n", ""),
    row(["check"], "a A9999:ZZ9999\n", 0, "ok 1 range\n", ""),
    row(["shift", "--rows", "10000"], "a A1\n", 2, "", "gridspan: bad value for --rows\n"),
    row(["union"], "a A1:ZZ9999\n", 0, "bounds A1:ZZ9999\ncovered 7019298 of 7019298 cells\n", ""),
    row(["size"], "a A1:ZZ9999\n", 0, "a A1:ZZ9999 9999x702 7019298 cells\ntotal 7019298 cells\n", ""),
    row(["shift", "--rows", "9999"], "a A1\n", 1, "", "gridspan: line 1: a moves outside the sheet\n"),
    row(["shift", "--cols", "9999"], "a A1\n", 1, "", "gridspan: line 1: a moves outside the sheet\n"),
    row(["shift", "--cols", "-9999"], "a ZZ1\n", 1, "", "gridspan: line 1: a moves outside the sheet\n"),
    row(["overlap"], "a A1:ZZ9999\nb ZZ9999\n", 0, "a b ZZ9999 1 cell\noverlaps 1\n", "")
  ])
end
