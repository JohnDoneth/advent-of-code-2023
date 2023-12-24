defmodule AOC23.Day1Part2.LineParser do
  import NimbleParsec

  defparsec(:one_t, string("one"))
  defparsec(:two_t, string("two"))
  defparsec(:three_t, string("three"))
  defparsec(:four_t, string("four"))
  defparsec(:five_t, string("five"))
  defparsec(:six_t, string("six"))
  defparsec(:seven_t, string("seven"))
  defparsec(:eight_t, string("eight"))
  defparsec(:nine_t, string("nine"))

  digit =
    ascii_char([?0..?9])
    |> map({List, :wrap, []})
    |> map({List, :to_string, []})
    |> map({__MODULE__, :to_int, []})

  alpha_char = ascii_char([?a..?z])

  defparsec(:line, repeat(choice([digit, ignore(alpha_char)])), debug: true)

  def to_int(char) do
    case Integer.parse(char) do
      {int, ""} -> int
      _ -> raise "Could not parse int: #{char}"
    end
  end
end

defmodule AOC23.Day1Part2 do
  alias AOC23.Day1Part2.LineParser

  def sum_lines(lines) do
    lines
    |> Stream.map(&line_value/1)
    |> Enum.sum()
  end

  def line_value(value) do
    value =
      value
      |> String.replace("one", "o1e")
      |> String.replace("two", "t2o")
      |> String.replace("three", "t3e")
      |> String.replace("four", "f4r")
      |> String.replace("five", "f5e")
      |> String.replace("six", "s6x")
      |> String.replace("seven", "s7n")
      |> String.replace("eight", "e8t")
      |> String.replace("nine", "n9e")

    {:ok, digits, _, _, _, _} = LineParser.line(value)

    first_digit = digits |> List.first()

    last_digit = digits |> Enum.reverse() |> List.first()

    {int, _} = Integer.parse("#{first_digit}#{last_digit}")

    int
  end

  def run do
    File.stream!("./lib/day1/input.txt")
    |> AOC23.Day1Part2.sum_lines()
    |> IO.puts()
  end
end
