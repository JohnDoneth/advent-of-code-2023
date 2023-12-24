defmodule AOC23.Day3 do
  defmodule Parser do
    import NimbleParsec

    digit =
      ascii_char([?0..?9])
      |> map({List, :wrap, []})
      |> map({List, :to_string, []})
      |> map({__MODULE__, :to_int, []})
      |> label("digit")

    defparsec(:empty, replace(ignore(string(".")), :empty))
    defparsec(:number, digit)
    defparsec(:eol, ignore(choice([string("\r\n"), string("\n"), eos()])) |> label("end of line"))

    defparsec(
      :symbol,
      replace(ascii_char(not: ?0..?9, not: ?., not: ?\n, not: ?\r), :symbol) |> label("symbol")
    )

    defparsec(
      :line,
      times(choice([parsec(:empty), parsec(:number), parsec(:symbol)]), min: 1) |> parsec(:eol)
    )

    defparsec(:parse, times(wrap(parsec(:line)), min: 1))

    def to_int(char) do
      case Integer.parse(char) do
        {int, ""} -> int
        _ -> raise "Could not parse int: #{char}"
      end
    end
  end

  defmodule PartNumber do
    defstruct part_number: nil, coords: nil

    def is_valid?(%PartNumber{coords: coords}, valid_coords) do
      coords
      |> Enum.map(fn {x, y} -> not valid_coord?(valid_coords, x, y) end)
      |> Enum.any?()
    end

    defp valid_coord?(valid_coords, x, y) do
      case Enum.at(valid_coords, y) do
        nil -> false
        row -> Enum.at(row, x)
      end
    end
  end

  defmodule GridInput do
    defstruct data: [[]], width: 0, height: 0

    def parse!(lines) do
      {:ok, data, _, _, _, _} = Parser.parse(lines)

      %GridInput{
        data: data,
        width: data |> Enum.at(0) |> length(),
        height: length(data)
      }
    end

    def get(%__MODULE__{data: data}, x, y) do
      if lower_bounds?(x, y) do
        nil
      else
        case Enum.at(data, y) do
          nil -> nil
          row -> Enum.at(row, x)
        end
      end
    end

    defp lower_bounds?(x, y) do
      x < 0 or y < 0
    end

    def neighbors(%__MODULE__{} = grid, x, y) do
      [
        [
          get(grid, x - 1, y - 1) || :empty,
          get(grid, x, y - 1) || :empty,
          get(grid, x + 1, y - 1) || :empty
        ],
        [get(grid, x - 1, y) || :empty, get(grid, x, y) || :empty, get(grid, x + 1, y) || :empty],
        [
          get(grid, x - 1, y + 1) || :empty,
          get(grid, x, y + 1) || :empty,
          get(grid, x + 1, y + 1) || :empty
        ]
      ]
    end

    def has_neighboring_symbol?(%__MODULE__{} = grid, x, y) do
      [
        [a1, a2, a3],
        [b1, b2, b3],
        [c1, c2, c3]
      ] = neighbors(grid, x, y)

      a1 == :symbol || a2 == :symbol || a3 == :symbol ||
        b1 == :symbol || b2 == :symbol || b3 == :symbol ||
        c1 == :symbol || c2 == :symbol || c3 == :symbol
    end

    def valid_coords(%__MODULE__{width: width, height: height} = grid) do
      Enum.map(0..(height - 1), fn y ->
        Enum.map(0..(width - 1), fn x ->
          not has_neighboring_symbol?(grid, x, y)
        end)
      end)
    end

    def part_numbers(%__MODULE__{width: width, height: height} = grid) do
      Enum.map(0..(height - 1), fn y ->
        Enum.reduce(0..(width - 1), [%PartNumber{part_number: "", coords: []}], fn x, acc ->
          cond do
            is_integer(get(grid, x, y)) ->
              List.update_at(acc, -1, fn current ->
                %PartNumber{
                  current
                  | part_number: current.part_number <> to_string(get(grid, x, y)),
                    coords: current.coords ++ [{x, y}]
                }
              end)

            true ->
              acc ++ [%PartNumber{part_number: "", coords: []}]
          end

          # if is_integer(get(grid, x, y)) do
          #   %PartNumber{acc | part_number: acc.part_number <> to_string(get(grid, x, y)), coords: acc.coords ++ [{x, y}]}
          # else
          #   %PartNumber{part_number: "", coords: []}
          # end
        end)
      end)
      |> Enum.flat_map(fn part_numbers ->
        part_numbers
        |> Enum.filter(fn %PartNumber{coords: coords} ->
          length(coords) > 0
        end)
      end)
    end

    def valid_part_numbers(grid_input) do
      part_numbers = part_numbers(grid_input)
      valid_coords = valid_coords(grid_input)

      part_numbers
      |> Enum.filter(fn part_number -> PartNumber.is_valid?(part_number, valid_coords) end)
      |> Enum.map(fn part_number -> part_number.part_number end)
    end
  end

  def to_int(char) do
    case Integer.parse(char) do
      {int, ""} -> int
      _ -> raise "Could not parse int: #{char}"
    end
  end

  def run(input) do
    find_sum(input)
  end

  def run do
    File.read!("./lib/day3/input.txt")
    |> find_sum()
    |> IO.puts()
  end

  def find_sum(input) do
    input
    |> GridInput.parse!()
    |> GridInput.valid_part_numbers()
    |> Enum.map(&to_int/1)
    |> Enum.sum()
  end
end
