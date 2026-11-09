defmodule Gridspan.Commands.Check do
  @moduledoc false

  def run(_options, items) do
    count = length(items)
    noun = Gridspan.Report.plural(count, "range", "ranges")

    {:ok, "ok #{count} #{noun}\n"}
  end
end
