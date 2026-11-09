defmodule Gridspan.Pairs do
  @moduledoc false

  def meet(first, second) do
    intersection = %{
      c1: max(first.c1, second.c1),
      r1: max(first.r1, second.r1),
      c2: min(first.c2, second.c2),
      r2: min(first.r2, second.r2)
    }

    if intersection.c1 <= intersection.c2 and intersection.r1 <= intersection.r2 do
      intersection
    else
      nil
    end
  end
end
