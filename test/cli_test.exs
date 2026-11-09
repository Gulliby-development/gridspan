defmodule Gridspan.CliTest do
  use Gridspan.RowCase

  rows([
    row([], "", 2, "", "usage: gridspan check [--rows N] [--cols N]\n       gridspan size [--rows N] [--cols N]\n       gridspan union [--rows N] [--cols N]\n       gridspan overlap [--rows N] [--cols N]\n       gridspan shift [--rows N] [--cols N]\n"),
    row(["help"], "", 0, "usage: gridspan check [--rows N] [--cols N]\n       gridspan size [--rows N] [--cols N]\n       gridspan union [--rows N] [--cols N]\n       gridspan overlap [--rows N] [--cols N]\n       gridspan shift [--rows N] [--cols N]\n", ""),
    row(["-h", "extra"], "", 0, "usage: gridspan check [--rows N] [--cols N]\n       gridspan size [--rows N] [--cols N]\n       gridspan union [--rows N] [--cols N]\n       gridspan overlap [--rows N] [--cols N]\n       gridspan shift [--rows N] [--cols N]\n", ""),
    row(["--help", "--bogus"], "", 0, "usage: gridspan check [--rows N] [--cols N]\n       gridspan size [--rows N] [--cols N]\n       gridspan union [--rows N] [--cols N]\n       gridspan overlap [--rows N] [--cols N]\n       gridspan shift [--rows N] [--cols N]\n", ""),
    row(["--version"], "", 0, "gridspan 0.1.0\n", ""),
    row(["--version", "x"], "", 0, "gridspan 0.1.0\n", ""),
    row(["frob"], "", 2, "", "gridspan: unknown command frob\n"),
    row([""], "", 2, "", "gridspan: unknown command \n"),
    row(["Check"], "", 2, "", "gridspan: unknown command Check\n"),
    row(["--rows"], "", 2, "", "gridspan: unknown command --rows\n"),
    row(["--rows", "5"], "", 2, "", "gridspan: unknown command --rows\n"),
    row(["help", "shift"], "", 0, "usage: gridspan check [--rows N] [--cols N]\n       gridspan size [--rows N] [--cols N]\n       gridspan union [--rows N] [--cols N]\n       gridspan overlap [--rows N] [--cols N]\n       gridspan shift [--rows N] [--cols N]\n", ""),
    row(["check"], "a A1:C3\nb B2:D4\nc F6\n", 0, "ok 3 ranges\n", ""),
    row(["size"], "a A1:C3\nb B2:D4\nc F6\n", 0, "a A1:C3 3x3 9 cells\nb B2:D4 3x3 9 cells\nc F6 1x1 1 cell\ntotal 15 cells\n", ""),
    row(["union"], "", 0, "bounds none\n", ""),
    row(["overlap"], "a A1:C3\nb B2:D4\nc F6\n", 0, "a b B2:C3 4 cells\noverlaps 1\n", ""),
    row(["shift", "--cols", "2"], "only C3\n", 0, "only C3 E3\nshifted 1 range\n", "")
  ])
end
