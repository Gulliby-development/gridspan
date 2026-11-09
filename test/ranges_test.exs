defmodule Gridspan.RangesTest do
  use Gridspan.RowCase

  rows([
    row(["check"], "a a1\n", 1, "", "gridspan: line 1: bad range a1\n"),
    row(["check"], "a A\n", 1, "", "gridspan: line 1: bad range A\n"),
    row(["check"], "a 1\n", 1, "", "gridspan: line 1: bad range 1\n"),
    row(["check"], "a A0\n", 1, "", "gridspan: line 1: bad range A0\n"),
    row(["check"], "a A01\n", 1, "", "gridspan: line 1: bad range A01\n"),
    row(["check"], "a AAA1\n", 1, "", "gridspan: line 1: bad range AAA1\n"),
    row(["check"], "a A1:\n", 1, "", "gridspan: line 1: bad range A1:\n"),
    row(["check"], " a :A1\n", 1, "", "gridspan: line 1: bad range :A1\n"),
    row(["check"], "a A1:B2:C3\n", 1, "", "gridspan: line 1: bad range A1:B2:C3\n"),
    row(["check"], "a A1-B2\n", 1, "", "gridspan: line 1: bad range A1-B2\n"),
    row(["check"], "a B2:A1\n", 1, "", "gridspan: line 1: range runs backwards\n"),
    row(["check"], "a A2:B1\n", 1, "", "gridspan: line 1: range runs backwards\n"),
    row(["check"], "a A1:A1\n", 0, "ok 1 range\n", ""),
    row(["check"], "a A1\na B2\n", 1, "", "gridspan: line 2: duplicate name a\n"),
    row(["check"], "a A1\nb a1\nc\n", 1, "", "gridspan: line 2: bad range a1\n"),
    row(["check"], "a A1\n\nb C3:A1\na Z1\n", 1, "", "gridspan: line 3: range runs backwards\n"),
    row(["check"], "a A1\n\n\nb B2\n", 0, "ok 2 ranges\n", ""),
    row(["check"], "a A1\rb B2\n", 1, "", "gridspan: line 1: expected NAME RANGE\n"),
    row(["check"], "a A1\n#\nb\n", 1, "", "gridspan: line 3: expected NAME RANGE\n"),
    row(["check"], "a A1\r\r\n", 1, "", "gridspan: line 1: bad range A1\r\n"),
    row(["check"], "# only\n", 0, "ok 0 ranges\n", ""),
    row(["check"], "\n", 0, "ok 0 ranges\n", "")
  ])
end
