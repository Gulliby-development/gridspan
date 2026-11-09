defmodule Gridspan.Input do
  @moduledoc false

  def read_items(text) when is_binary(text) do
    lines = physical_lines(text)

    if length(lines) > Gridspan.Registry.max_lines() do
      failure("input is too long (max #{Gridspan.Registry.max_lines()} lines)")
    else
      parse_lines(lines)
    end
  end

  defp physical_lines(""), do: []

  defp physical_lines(text) do
    lines = String.split(text, "\n", trim: false)
    if String.ends_with?(text, "\n"), do: Enum.drop(lines, -1), else: lines
  end

  defp parse_lines(lines) do
    lines
    |> Enum.with_index(1)
    |> Enum.reduce_while({:ok, [], MapSet.new()}, fn {line, number}, {:ok, items, names} ->
      line
      |> remove_terminal_cr()
      |> words()
      |> parse_line(number, items, names)
    end)
    |> case do
      {:ok, items, _names} -> {:ok, Enum.reverse(items)}
      error -> error
    end
  end

  defp remove_terminal_cr(line) do
    if String.ends_with?(line, "\r"), do: binary_part(line, 0, byte_size(line) - 1), else: line
  end

  defp words(line), do: Regex.split(~r/[ \t]+/, line, trim: true)

  defp parse_line([], _number, items, names), do: {:cont, {:ok, items, names}}
  defp parse_line([first | _], _number, items, names) when binary_part(first, 0, 1) == "#", do: {:cont, {:ok, items, names}}

  defp parse_line(words, number, items, names) do
    case words do
      [name, range] ->
        with :ok <- validate_name(name),
             {:ok, corners} <- parse_range(range),
             :ok <- validate_direction(corners),
             :ok <- validate_unique(name, names) do
          item = Map.merge(%{name: name, line: number}, corners)
          {:cont, {:ok, [item | items], MapSet.put(names, name)}}
        else
          {:error, reason} -> line_failure(number, reason)
        end

      _ ->
        line_failure(number, "expected NAME RANGE")
    end
  end

  defp validate_name(name) do
    if byte_size(name) <= Gridspan.Registry.max_name() and Regex.match?(~r/\A[a-z][a-z0-9-]*\z/, name),
      do: :ok,
      else: {:error, "bad name #{name}"}
  end

  defp parse_range(range) do
    case Gridspan.Cells.parse_range(range) do
      {:ok, corners} -> {:ok, corners}
      :error -> {:error, "bad range #{range}"}
    end
  end

  defp validate_direction(%{c1: c1, r1: r1, c2: c2, r2: r2}) do
    if c2 < c1 or r2 < r1, do: {:error, "range runs backwards"}, else: :ok
  end

  defp validate_unique(name, names) do
    if MapSet.member?(names, name), do: {:error, "duplicate name #{name}"}, else: :ok
  end

  defp line_failure(number, reason), do: {:halt, failure("line #{number}: #{reason}")}
  defp failure(message), do: {:error, Gridspan.Failure.new(1, message)}
end
