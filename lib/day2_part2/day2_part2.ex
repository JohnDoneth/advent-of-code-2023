defmodule AOC23.Day2Part2 do
  defmodule LineParser do
    import NimbleParsec

    defcombinatorp(
      :digit,
      integer(min: 1)
    )

    prefix =
      ignore(string("Game "))
      |> parsec(:whitespace)
      |> unwrap_and_tag(integer(min: 1), :game_id)
      |> ignore(string(": "))

    blue =
      parsec(:digit)
      |> parsec(:whitespace)
      |> ignore(string("blue"))
      |> unwrap_and_tag(:blue)

    red =
      parsec(:digit)
      |> parsec(:whitespace)
      |> ignore(string("red"))
      |> unwrap_and_tag(:red)

    green =
      parsec(:digit)
      |> parsec(:whitespace)
      |> ignore(string("green"))
      |> unwrap_and_tag(:green)

    defparsec(:comma, ignore(optional(string(","))))
    defparsec(:whitespace, ignore(repeat(string(" "))))

    defcombinatorp(
      :color_value,
      parsec(:whitespace) |> choice([blue, red, green]) |> parsec(:comma)
    )

    defparsec(
      :set,
      parsec(:color_value)
      |> times(min: 1)
      |> wrap()
      |> map({Enum, :into, [%{}]})
    )

    defparsec(:line, prefix |> tag(repeat(parsec(:set) |> ignore(optional(string("; ")))), :sets))

    def to_int(char) do
      case Integer.parse(char) do
        {int, ""} -> int
        _ -> raise "Could not parse int: #{char}"
      end
    end
  end

  def line_value(line) do
    {:ok, values, _, _, _, _} = LineParser.line(line)
    values
  end

  def record_highest(sets) do
    Enum.reduce(sets, %{red: 0, blue: 0, green: 0}, fn set, acc ->
      red = set[:red] || 0
      green = set[:green] || 0
      blue = set[:blue] || 0

      acc = if acc[:red] < red, do: Map.put(acc, :red, red), else: acc
      acc = if acc[:green] < green, do: Map.put(acc, :green, green), else: acc
      acc = if acc[:blue] < blue, do: Map.put(acc, :blue, blue), else: acc

      acc
    end)
  end

  def power_of_highests(%{red: red, green: green, blue: blue}) do
    red * green * blue
  end

  def run do
    File.stream!("./lib/day2/input.txt")
    |> Stream.map(&line_value/1)
    |> Stream.map(&record_highest(&1[:sets]))
    |> Stream.map(&power_of_highests/1)
    |> Enum.sum()
    |> IO.puts()
  end
end
