defmodule Gridspan.InputTest do
  use Gridspan.RowCase

  rows([
    row(["check"], "", 0, "ok 0 ranges\n", ""),
    row(["check"], "a A1\n", 0, "ok 1 range\n", ""),
    row(["check"], "a A1:C3\nb B2:D4\nc F6\n", 0, "ok 3 ranges\n", ""),
    row(["check"], "# note\n\n  \na A1\n\t\n#b B2\n", 0, "ok 1 range\n", ""),
    row(["check"], "a A1\r\nb B2\r\n", 0, "ok 2 ranges\n", ""),
    row(["check"], "a A1", 0, "ok 1 range\n", ""),
    row(["check"], "\ta   A1:B2 \t\n", 0, "ok 1 range\n", ""),
    row(["check"], "a A1 # note\n", 1, "", "gridspan: line 1: expected NAME RANGE\n"),
    row(["check"], "a\n", 1, "", "gridspan: line 1: expected NAME RANGE\n"),
    row(["check"], "a A1 B2\n", 1, "", "gridspan: line 1: expected NAME RANGE\n"),
    row(["check"], "A a1\n", 1, "", "gridspan: line 1: bad name A\n"),
    row(["check"], "Ab A1\n", 1, "", "gridspan: line 1: bad name Ab\n"),
    row(["check"], "1a A1\n", 1, "", "gridspan: line 1: bad name 1a\n"),
    row(["check"], "a_b A1\n", 1, "", "gridspan: line 1: bad name a_b\n"),
    row(["check"], "-a A1\n", 1, "", "gridspan: line 1: bad name -a\n"),
    row(["check"], "a-b-2 A1\n", 0, "ok 1 range\n", "")
  ])
end
