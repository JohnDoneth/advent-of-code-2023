defmodule AOC23.Day2Test do
  use ExUnit.Case, async: true

  alias AOC23.Day2

  @tag timeout: 1000
  test "LineParser.line" do

    assert {:ok,
      [
        %{red: 4, blue: 3}
      ],
      _,
      _,
      _,_
    } = Day2.LineParser.set("3 blue, 4 red")

    assert {:ok,
    [
      %{red: 20, green: 8, blue: 6}
    ],
    _,
    _,
    _,_
  } = Day2.LineParser.set("8 green, 6 blue, 20 red")

    assert [
      game_id: 1,
      sets: [
        %{red: 4, blue: 3}, %{green: 2, red: 1, blue: 6}, %{green: 2}
      ]
     ] == Day2.line_value("Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green")

     assert [
      game_id: 3,
      sets: [
        %{green: 8, blue: 6, red: 20}, %{blue: 5, red: 4, green: 13}, %{green: 5, red: 1}
      ]
     ] == Day2.line_value("Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red")


    assert Day2.is_valid?([%{red: 4, blue: 3}], 12, 13, 14)

    refute Day2.is_valid?([%{red: 20, blue: 3}], 12, 13, 14)

  end
end
