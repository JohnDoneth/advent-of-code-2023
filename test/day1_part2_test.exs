defmodule AOC23.Day1Part2Test do
  use ExUnit.Case, async: true

  alias AOC23.Day1Part2

  @tag timeout: 1000
  test "LineParser.line" do
    assert 22 == Day1Part2.line_value("2")

    assert 11 == Day1Part2.line_value("1")

    assert 14 == Day1Part2.line_value("1two3four")

    assert 14 == Day1Part2.line_value("1junktwo3fourothertext")

    assert 19 == Day1Part2.line_value("onetwothreefourfivesixseveneightnine")

    assert 83 == Day1Part2.line_value("eighthree")

    assert 79 == Day1Part2.line_value("sevenine")

    assert 81 == Day1Part2.line_value("eightwone")
  end
end
