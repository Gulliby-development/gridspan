defmodule Gridspan.Commands.Shift do
  @moduledoc false

  def run(options, items) do
    shifted =
      Enum.map(items, fn item ->
        %{
          item: item,
          c1: item.c1 + options.cols,
          r1: item.r1 + options.rows,
          c2: item.c2 + options.cols,
          r2: item.r2 + options.rows
        }
      end)

    case Enum.find(shifted, &outside_sheet?/1) do
      %{item: item} ->
        {:error, Gridspan.Failure.new(1, "line #{item.line}: #{item.name} moves outside the sheet")}

      nil ->
        lines =
          Enum.map(shifted, fn shifted_item ->
            item = shifted_item.item
            new_range = Gridspan.Cells.range_text(shifted_item.c1, shifted_item.r1, shifted_item.c2, shifted_item.r2)
            "#{item.name} #{Gridspan.Report.item_range(item)} #{new_range}\n"
          end)

        count = length(items)
        noun = Gridspan.Report.plural(count, "range", "ranges")
        {:ok, Enum.join(lines) <> "shifted #{count} #{noun}\n"}
    end
  end

  defp outside_sheet?(item) do
    item.c1 < 1 or item.c2 > Gridspan.Registry.max_col() or item.r1 < 1 or
      item.r2 > Gridspan.Registry.max_row()
  end
end
