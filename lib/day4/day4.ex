defmodule AOC23.Day4 do
  defmodule Card do
    defstruct id: nil,
              winning_numbers: [],
              numbers: []

    defp match_count(%Card{} = card) do
      card.numbers
      |> Enum.filter(fn number -> number in card.winning_numbers end)
      |> Enum.count()
    end

    def value(card) do
      matches = match_count(card)

      if matches > 0 do
        :math.pow(2, matches - 1)
      else
        0
      end
    end
  end

  defmodule Parser do
    import NimbleParsec

    defcombinatorp(:digit, integer(min: 1))

    # defparsec(:empty, replace(ignore(string(".")), :empty))
    # defparsec(:number, digit)
    # defparsec(:symbol, replace(ascii_char([not: ?0..?9, not: ?., not: ?\n, not: ?\r]), :symbol) |> label("symbol"))

    defparsec(:eol, ignore(choice([string("\r\n"), string("\n"), eos()])) |> label("end of line"))

    defparsec(:whitespace, ignore(repeat(string(" "))))

    defparsec(
      :many_digits,
      times(parsec(:whitespace) |> parsec(:digit) |> parsec(:whitespace), min: 1)
    )

    defparsec(:card_id, parsec(:digit) |> unwrap_and_tag(:id))

    defparsec(
      :card,
      string("Card")
      |> ignore()
      |> parsec(:whitespace)
      |> parsec(:card_id)
      |> ignore(string(":"))
      |> tag(parsec(:many_digits), :winning_numbers)
      |> string("|")
      |> tag(parsec(:many_digits), :numbers)
      |> optional(parsec(:eol))
      # |> wrap()
      |> reduce({__MODULE__, :into_card, []})
    )

    defparsec(:cards, times(parsec(:card), min: 1))

    def into_card(input) do
      %Card{
        id: Keyword.fetch!(input, :id),
        winning_numbers: Keyword.fetch!(input, :winning_numbers),
        numbers: Keyword.fetch!(input, :numbers)
      }
    end

    def to_int(char) do
      case Integer.parse(char) do
        {int, ""} -> int
        _ -> raise "Could not parse int: #{char}"
      end
    end
  end

  def find_sum(input) do
    {:ok, cards, _, _, _, _} = Parser.cards(input)

    cards
    |> Enum.map(&Card.value/1)
    |> Enum.sum()
  end

  def run(input) do
    find_sum(input)
  end

  def run do
    File.read!("./lib/day4/input.txt")
    |> find_sum()
    |> IO.puts()
  end
end
