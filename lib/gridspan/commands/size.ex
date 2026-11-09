defmodule Gridspan.Commands.Size do
  @moduledoc false

  def run(_options, items) do
    item_lines =
      Enum.map(items, fn item ->
        rows = Gridspan.Cells.rows(item)
        cols = Gridspan.Cells.cols(item)
        cells = Gridspan.Cells.cells(item)
        noun = Gridspan.Report.plural(cells, "cell", "cells")

        "#{item.name} #{Gridspan.Report.item_range(item)} #{rows}x#{cols} #{cells} #{noun}\n"
      end)

    total = Gridspan.Span.distinct_cells(items)
    total_noun = Gridspan.Report.plural(total, "cell", "cells")

    {:ok, Enum.join(item_lines) <> "total #{total} #{total_noun}\n"}
  end
end
