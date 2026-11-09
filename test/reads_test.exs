defmodule Gridspan.ReadsTest do
  use Gridspan.RowCase

  rows([
    reads(["check"], true),
    reads(["size"], true),
    reads(["union"], true),
    reads(["overlap"], true),
    reads(["shift"], true),
    reads(["shift", "--rows", "-5"], true),
    reads(["shift", "--cols", "9999", "--rows", "-9999"], true),
    reads(["help"], false),
    reads(["-h"], false),
    reads(["--help"], false),
    reads(["--version"], false),
    reads([], false),
    reads(["frob"], false),
    reads([""], false),
    reads(["check", "x"], false),
    reads(["shift", "--rows"], false),
    reads(["shift", "--rows", "10000"], false),
    reads(["shift", "--rows", "-0"], false),
    reads(["shift", "--rows", "1", "--rows", "2"], false),
    reads(["shift", "--cols", "7", "--bogus"], false),
    reads(["Shift"], false),
    reads(["--rows", "5"], false),
    reads(["size", "-"], false),
    reads(["union", ""], false),
    reads(["overlap", "--cols", "-1", "--rows", "1"], true),
    reads(["check", "--cols", "00"], false),
    reads(["check", "--cols", "-1"], true),
    reads(["size", "--rows=1"], false)
  ])
end
