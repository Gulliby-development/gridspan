defmodule Gridspan.Span do
  @moduledoc false

  def bounds([]), do: nil

  def bounds([first | rest]) do
    Enum.reduce(rest, %{c1: first.c1, r1: first.r1, c2: first.c2, r2: first.r2}, fn item, result ->
      %{
        c1: min(result.c1, item.c1),
        r1: min(result.r1, item.r1),
        c2: max(result.c2, item.c2),
        r2: max(result.r2, item.r2)
      }
    end)
  end

  def distinct_cells([]), do: 0

  def distinct_cells(items) do
    boundaries =
      items
      |> Enum.flat_map(fn item -> [item.c1, item.c2 + 1] end)
      |> Enum.uniq()
      |> Enum.sort()

    boundaries
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.reduce(0, fn [left, right], total ->
      intervals =
        items
        |> Enum.filter(fn item -> item.c1 < right and item.c2 + 1 > left end)
        |> Enum.map(fn item -> {item.r1, item.r2} end)

      total + (right - left) * covered_rows(intervals)
    end)
  end

  defp covered_rows(intervals) do
    intervals
    |> Enum.sort()
    |> Enum.reduce({0, nil}, fn {first, last}, {total, current} ->
      case current do
        nil ->
          {total, {first, last}}

        {current_first, current_last} when first <= current_last + 1 ->
          {total, {current_first, max(current_last, last)}}

        {current_first, current_last} ->
          {total + current_last - current_first + 1, {first, last}}
      end
    end)
    |> case do
      {total, nil} -> total
      {total, {first, last}} -> total + last - first + 1
    end
  end
end
