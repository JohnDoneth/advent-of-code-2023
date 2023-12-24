defmodule AOC23.Day1 do
  def sum_lines(lines) do
    lines
    |> Stream.map(&line_value/1)
    |> Enum.sum()
  end

  def line_value(value) do
    graphemes = String.graphemes(value)

    first_digit = graphemes |> Enum.find(&is_int?/1)

    last_digit = graphemes |> Enum.reverse() |> Enum.find(&is_int?/1)

    {int, _} = Integer.parse("#{first_digit}#{last_digit}")

    int
  end

  def is_int?(char) do
    case Integer.parse(char) do
      {_, ""} -> true
      _ -> false
    end
  end
end

# AOC23.Day1.line_value("1abc2")
# |> IO.puts()

# ["1abc2", "pqr3stu8vwx", "a1b2c3d4e5f", "treb7uchet"]
# |> AOC23.Day1.sum_lines()
# |> IO.puts()

# File.stream!("./lib/day1/input.txt")
# |> AOC23.Day1.sum_lines()
# |> IO.puts()
