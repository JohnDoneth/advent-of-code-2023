defmodule AOC23.Day3Test do
  use ExUnit.Case, async: true

  alias AOC23.Day3
  alias AOC23.Day3.PartNumber

  @tag timeout: 1000
  test "LineParser.line" do
    assert {:ok,
            [
              :empty,
              :empty,
              :empty,
              :empty,
              1,
              :empty,
              :empty,
              :empty,
              :empty,
              3
            ], _, _, _, _} = Day3.Parser.line("....1....3\n")

    assert {:ok,
            [
              [:empty, :empty, :empty, :empty, 1, :empty, :empty, :empty, :empty, 3],
              [
                :empty,
                :empty,
                :empty,
                :symbol,
                :empty,
                :empty,
                :empty,
                :symbol,
                :empty,
                :empty,
                :empty
              ]
            ], _, _, _, _} = Day3.Parser.parse("....1....3\n...*...!...")

    assert {:ok,
            [
              [:empty, :empty, :empty, :empty, 1, :empty, :empty, :empty, :empty, 3],
              [
                :empty,
                :empty,
                :empty,
                :symbol,
                :empty,
                :empty,
                :empty,
                :symbol,
                :empty,
                :empty,
                :empty
              ]
            ], _, _, _, _} = Day3.Parser.parse("....1....3\r\n...*...!...")

    assert Day3.GridInput.parse!("1\n") |> Day3.GridInput.get(0, 0) == 1
    assert Day3.GridInput.parse!(".\n") |> Day3.GridInput.get(0, 0) == :empty
    assert Day3.GridInput.parse!("*\n") |> Day3.GridInput.get(0, 0) == :symbol

    assert Day3.GridInput.parse!("...\n.*.\n...\n") |> Day3.GridInput.neighbors(1, 1) == [
             [:empty, :empty, :empty],
             [:empty, :symbol, :empty],
             [:empty, :empty, :empty]
           ]

    assert Day3.GridInput.parse!("*\n") |> Day3.GridInput.neighbors(0, 0) == [
             [:empty, :empty, :empty],
             [:empty, :symbol, :empty],
             [:empty, :empty, :empty]
           ]

    assert Day3.GridInput.parse!("...\n.*.\n...\n") |> Day3.GridInput.valid_coords() == [
             [false, false, false],
             [false, false, false],
             [false, false, false]
           ]

    assert Day3.GridInput.parse!("*..\n...\n...\n") |> Day3.GridInput.valid_coords() == [
             [false, false, true],
             [false, false, true],
             [true, true, true]
           ]

    assert Day3.GridInput.parse!("123\n...\n.42\n") |> Day3.GridInput.part_numbers() == [
             %PartNumber{coords: [{0, 0}, {1, 0}, {2, 0}], part_number: "123"},
             %PartNumber{coords: [{1, 2}, {2, 2}], part_number: "42"}
           ]

    assert Day3.GridInput.parse!("*123..*456..*789") |> Day3.GridInput.valid_part_numbers() == [
             "123",
             "456",
             "789"
           ]

    assert Day3.GridInput.parse!("123\n.*.\n.42\n") |> Day3.GridInput.valid_part_numbers() == [
             "123",
             "42"
           ]

    assert Day3.GridInput.parse!("123\n.*.\n.42\n") |> Day3.GridInput.valid_part_numbers() == [
             "123",
             "42"
           ]
  end

  test "example input" do
    assert Day3.run("""
           467..114..
           ...*......
           ..35..633.
           ......#...
           617*......
           .....+.58.
           ..592.....
           ......755.
           ...$.*....
           .664.598..
           """) == 4361
  end
end
