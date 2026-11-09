defmodule Gridspan.Cells do
  @moduledoc false

  @cell_pattern ~r/\A([A-Z]{1,2})([1-9][0-9]{0,3})\z/
  @range_pattern ~r/\A([^:]+):([^:]+)\z/

  def col_name(n) when is_integer(n) and n >= 1 and n <= 702 do
    letters(n, []) |> IO.iodata_to_binary()
  end

  defp letters(0, result), do: result

  defp letters(n, result) do
    digit = rem(n - 1, 26)
    letters(div(n - 1, 26), [<<digit + ?A>> | result])
  end

  def cell_text(col, row), do: col_name(col) <> Integer.to_string(row)

  def range_text(c1, r1, c2, r2) do
    start_cell = cell_text(c1, r1)
    if c1 == c2 and r1 == r2, do: start_cell, else: start_cell <> ":" <> cell_text(c2, r2)
  end

  def parse_cell(word) when is_binary(word) do
    case Regex.run(@cell_pattern, word) do
      [_, letters, row] ->
        with {:ok, col} <- parse_column(letters),
             {row_number, ""} <- Integer.parse(row),
             true <- row_number <= Gridspan.Registry.max_row() do
          {:ok, {col, row_number}}
        else
          _ -> :error
        end

      _ ->
        :error
    end
  end

  def parse_cell(_word), do: :error

  defp parse_column(letters) do
    col =
      letters
      |> String.to_charlist()
      |> Enum.reduce(0, fn letter, value -> value * 26 + letter - ?A + 1 end)

    if col <= Gridspan.Registry.max_col(), do: {:ok, col}, else: :error
  end

  def parse_range(word) when is_binary(word) do
    case Regex.run(@range_pattern, word) do
      [_, first, last] ->
        with {:ok, {c1, r1}} <- parse_cell(first),
             {:ok, {c2, r2}} <- parse_cell(last) do
          {:ok, %{c1: c1, r1: r1, c2: c2, r2: r2}}
        else
          _ -> :error
        end

      _ ->
        case parse_cell(word) do
          {:ok, {col, row}} -> {:ok, %{c1: col, r1: row, c2: col, r2: row}}
          :error -> :error
        end
    end
  end

  def parse_range(_word), do: :error

  def rows(item), do: item.r2 - item.r1 + 1
  def cols(item), do: item.c2 - item.c1 + 1
  def cells(item), do: rows(item) * cols(item)
end
