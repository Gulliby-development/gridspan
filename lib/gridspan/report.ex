defmodule Gridspan.Report do
  @moduledoc false

  def plural(1, one, _many), do: one
  def plural(_count, _one, many), do: many

  def item_range(item) do
    Gridspan.Cells.range_text(item.c1, item.r1, item.c2, item.r2)
  end
end
