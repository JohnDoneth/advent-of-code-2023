defmodule AOC23.Day2 do
  defmodule LineParser do
    import NimbleParsec

    defcombinatorp(:digit,
            integer(min: 1))

    prefix = ignore(string("Game "))
             |> parsec(:whitespace)
             |> unwrap_and_tag(integer(min: 1), :game_id)
             |> ignore(string(": "))

    blue = parsec(:digit)
           |> parsec(:whitespace)
           |> ignore(string("blue"))
           |> unwrap_and_tag(:blue)

    red = parsec(:digit)
          |> parsec(:whitespace)
          |> ignore(string("red"))
          |> unwrap_and_tag(:red)

    green = parsec(:digit)
            |> parsec(:whitespace)
            |> ignore(string("green"))
            |> unwrap_and_tag(:green)

    defparsec(:comma, ignore(optional(string(","))))
    defparsec(:whitespace, ignore(repeat(string(" "))))

    defcombinatorp(:color_value, parsec(:whitespace) |> choice([blue, red, green]) |> parsec(:comma))

    defparsec(:set, parsec(:color_value)
                    |> times(min: 1)
                    |> wrap()
                    |> map({Enum, :into, [%{}]}))

    defparsec(:line, prefix |> tag(repeat(parsec(:set) |> ignore(optional(string("; ")))), :sets))

    def to_int(char) do
      case Integer.parse(char) do
        {int, ""} -> int
        _ -> raise "Could not parse int: #{char}"
      end
    end
  end

  def line_value(line) do
    {:ok, values, _, _, _, _} = LineParser.line(line);
    values
  end

  def is_valid?(set, max_red, max_green, max_blue) when is_list(set) do
    set
    |> Enum.map(&is_valid?(&1, max_red, max_green, max_blue))
    |> Enum.all?()
  end

  def is_valid?(set, max_red, max_green, max_blue) when is_map(set) do
    red = set[:red] || 0
    green = set[:green] || 0
    blue = set[:blue] || 0

    red <= max_red and green <= max_green and blue <= max_blue
  end

  def run do
    File.stream!("./lib/day2/input.txt")
    |> Stream.map(&line_value/1)
    |> Stream.map(fn item ->
      IO.inspect({item, is_valid?(item[:sets], 12, 13, 14)})
      item
    end)
    |> Stream.filter(&is_valid?(&1[:sets], 12, 13, 14))
    |> Stream.map(fn result -> result[:game_id] end)
    |> Enum.sum()
    |> IO.puts()
  end
end
