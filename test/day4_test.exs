defmodule AOC23.Day4Test do
  use ExUnit.Case, async: true

  alias AOC23.Day4
  alias AOC23.Day4.Parser
  alias AOC23.Day4.Card

  test "parses one card of the example input" do
    input = """
    Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
    """

    {:ok,
     [
       %Card{
         id: 1,
         winning_numbers: [41, 48, 83, 86, 17],
         numbers: [83, 86, 6, 31, 17, 9, 48, 53]
       }
     ], _, _, _, _} = Parser.card(input)
  end

  test "parses the example input" do
    input = """
    Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
    Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
    Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
    Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
    Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
    Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
    """

    {:ok,
     [
       %AOC23.Day4.Card{
         id: 1,
         numbers: [83, 86, 6, 31, 17, 9, 48, 53],
         winning_numbers: [41, 48, 83, 86, 17]
       },
       %AOC23.Day4.Card{
         id: 2,
         numbers: [61, 30, 68, 82, 17, 32, 24, 19],
         winning_numbers: [13, 32, 20, 16, 61]
       },
       %AOC23.Day4.Card{
         id: 3,
         numbers: [69, 82, 63, 72, 16, 21, 14, 1],
         winning_numbers: [1, 21, 53, 59, 44]
       },
       %AOC23.Day4.Card{
         id: 4,
         numbers: [59, 84, 76, 51, 58, 5, 54, 83],
         winning_numbers: [41, 92, 73, 84, 69]
       },
       %AOC23.Day4.Card{
         id: 5,
         numbers: [88, 30, 70, 12, 93, 22, 82, 36],
         winning_numbers: [87, 83, 26, 28, 32]
       },
       %AOC23.Day4.Card{
         id: 6,
         numbers: [74, 77, 10, 23, 35, 67, 36, 11],
         winning_numbers: [31, 18, 13, 56, 72]
       }
     ], _, _, _, _} = Parser.cards(input)
  end

  test "card values" do

    assert Card.value(%Card{
      id: 1,
      winning_numbers: [41, 48, 83, 86, 17],
      numbers: [83, 86, 6, 31, 17, 9, 48, 53]
    }) == 8

    assert Card.value(%Card{
      id: 1,
      winning_numbers: [41, 48, 84, 86, 17],
      numbers: [83, 86, 6, 31, 17, 9, 48, 53]
    }) == 4

    assert Card.value(%Card{
      id: 1,
      winning_numbers: [1],
      numbers: [1]
    }) == 1

    assert Card.value(%Card{
      id: 1,
      winning_numbers: [1, 2],
      numbers: [1, 2]
    }) == 2

    assert Card.value(%Card{
      id: 1,
      winning_numbers: [1, 2, 3],
      numbers: [1, 2, 3]
    }) == 4

    assert Card.value(%Card{
      id: 1,
      winning_numbers: [1, 2, 3, 4],
      numbers: [1, 2, 3, 4]
    }) == 8
  end

  test "run - finds sum of example" do
    input = """
    Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
    Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
    Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
    Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
    Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
    Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
    """

    assert Day4.run(input) == 13
  end

end
