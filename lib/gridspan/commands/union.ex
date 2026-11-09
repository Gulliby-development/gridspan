defmodule Gridspan.Commands.Union do
  @moduledoc false

  def run(_options, items) do
    case Gridspan.Span.bounds(items) do
      nil ->
        {:ok, "bounds none\n"}

      bounds ->
        range = Gridspan.Report.item_range(bounds)
        covered = Gridspan.Span.distinct_cells(items)
        area = Gridspan.Cells.cells(bounds)

        {:ok, "bounds #{range}\ncovered #{covered} of #{area} cells\n"}
    end
  end
end
