defmodule Gridspan.Registry do
  @moduledoc false

  # The version, the limits, the usage text, the shapes of the options and the items, and the
  # command table.
  #
  # Options are a map `%{rows: integer, cols: integer}` (0 when the option is absent).
  # An item is one meaningful line of the input, a map `%{name: String.t(), line: pos_integer,
  # c1: integer, r1: integer, c2: integer, r2: integer}`: the name, the line number (counted
  # from 1, skipped lines included) and the corners of the range, top left first.
  # A command is a function `run(options, items)` that returns `{:ok, output}` with the whole
  # standard output text or `{:error, %Gridspan.Failure{}}`.

  @type options :: %{rows: integer, cols: integer}
  @type item :: %{
          name: String.t(),
          line: pos_integer,
          c1: pos_integer,
          r1: pos_integer,
          c2: pos_integer,
          r2: pos_integer
        }
  @type command_result :: {:ok, String.t()} | {:error, Gridspan.Failure.t()}

  def version, do: "gridspan 0.1.0"
  def max_lines, do: 40
  def max_name, do: 12
  def max_col, do: 702
  def max_row, do: 9999
  def max_shift, do: 9999

  def usage do
    "usage: gridspan check [--rows N] [--cols N]\n" <>
      "       gridspan size [--rows N] [--cols N]\n" <>
      "       gridspan union [--rows N] [--cols N]\n" <>
      "       gridspan overlap [--rows N] [--cols N]\n" <>
      "       gridspan shift [--rows N] [--cols N]\n"
  end

  def commands do
    [
      {"check", &Gridspan.Commands.Check.run/2},
      {"size", &Gridspan.Commands.Size.run/2},
      {"union", &Gridspan.Commands.Union.run/2},
      {"overlap", &Gridspan.Commands.Overlap.run/2},
      {"shift", &Gridspan.Commands.Shift.run/2}
    ]
  end

  def find(name), do: List.keyfind(commands(), name, 0)
end
