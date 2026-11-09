defmodule Gridspan.CLI do
  @moduledoc false

  @commands ["check", "size", "union", "overlap", "shift"]
  @option_values ~r/\A(?:0|-[1-9][0-9]*|[1-9][0-9]*)\z/

  def run([], _text), do: {2, "", Gridspan.Registry.usage()}
  def run([word | _], _text) when word in ["help", "-h", "--help"], do: {0, Gridspan.Registry.usage(), ""}
  def run(["--version" | _], _text), do: {0, Gridspan.Registry.version() <> "\n", ""}

  def run([command | args], text) do
    case Gridspan.Registry.find(command) do
      nil ->
        failure(Gridspan.Failure.new(2, "unknown command #{command}"))

      {_name, handler} ->
        with {:ok, options} <- parse_options(args),
             {:ok, items} <- Gridspan.Input.read_items(text) do
          case handler.(options, items) do
            {:ok, output} -> {0, output, ""}
            {:error, %Gridspan.Failure{} = error} -> failure(error)
          end
        else
          {:error, %Gridspan.Failure{} = error} -> failure(error)
        end
    end
  end

  def reads_stdin?([command | args]) when command in @commands do
    match?({:ok, _options}, parse_options(args))
  end

  def reads_stdin?(_args), do: false

  def parse_options(args), do: parse_options(args, %{rows: 0, cols: 0}, MapSet.new())

  defp parse_options([], options, _seen), do: {:ok, options}

  defp parse_options([word | rest], options, seen) do
    cond do
      word in ["--rows", "--cols"] ->
        parse_option(word, rest, options, seen)

      word == "" or word == "-" or not String.starts_with?(word, "-") ->
        {:error, Gridspan.Failure.new(2, "unexpected argument #{word}")}

      true ->
        {:error, Gridspan.Failure.new(2, "unknown option #{word}")}
    end
  end

  defp parse_option(option, rest, options, seen) do
    key = if option == "--rows", do: :rows, else: :cols

    cond do
      MapSet.member?(seen, option) ->
        {:error, Gridspan.Failure.new(2, "given twice: #{option}")}

      rest == [] ->
        {:error, Gridspan.Failure.new(2, "missing value for #{option}")}

      true ->
        [value | tail] = rest

        case parse_option_value(value) do
          {:ok, number} ->
            parse_options(tail, Map.put(options, key, number), MapSet.put(seen, option))

          :error ->
            {:error, Gridspan.Failure.new(2, "bad value for #{option}")}
        end
    end
  end

  defp parse_option_value(value) do
    limit = Gridspan.Registry.max_shift()

    if Regex.match?(@option_values, value) do
      case Integer.parse(value) do
        {number, ""} when number >= -limit and number <= limit ->
          {:ok, number}

        _ ->
          :error
      end
    else
      :error
    end
  end

  defp failure(%Gridspan.Failure{status: status, message: message}),
    do: {status, "", "gridspan: " <> message <> "\n"}
end
