defmodule Gridspan.Commands.Overlap do
  @moduledoc false

  def run(_options, items) do
    pairs =
      items
      |> Enum.with_index()
      |> Enum.flat_map(fn {first, index} ->
        items
        |> Enum.drop(index + 1)
        |> Enum.flat_map(fn second ->
          case Gridspan.Pairs.meet(first, second) do
            nil ->
              []

            intersection ->
              cells = Gridspan.Cells.cells(intersection)
              noun = Gridspan.Report.plural(cells, "cell", "cells")

              range =
                Gridspan.Cells.range_text(
                  intersection.c1,
                  intersection.r1,
                  intersection.c2,
                  intersection.r2
                )

              ["#{first.name} #{second.name} #{range} #{cells} #{noun}\n"]
          end
        end)
      end)

    count = length(pairs)
    {:ok, Enum.join(pairs) <> "overlaps #{count}\n"}
  end
end
