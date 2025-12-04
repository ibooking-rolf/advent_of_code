defmodule AdventOfCode.DayFour do
  alias AdventOfCode.Helpers

  # {row, col}
  @directions [
    {0, 1},
    {1, 0},
    {0, -1},
    {-1, 0},
    {1, 1},
    {1, -1},
    {-1, 1},
    {-1, -1}
  ]

  def test() do
    RustNifs.check_adjacents("Hello")
  end

  def start(example? \\ false, max_neighbours \\ 3) do
    file_name = "assets/4_input"

    file_name = if example?, do: file_name <> "_example.txt", else: file_name <> ".txt"

    paper_rolls =
      Helpers.read_input(file_name)
      |> Enum.join("\n")

    RustNifs.check_adjacents(paper_rolls)
  end

  def build_map(lines, map \\ [])

  def build_map([], map), do: map |> Enum.reverse()

  def build_map([line | rest], map) do
    current_line =
      line
      |> String.graphemes()
      |> Enum.map(&determine_cell_value/1)

    build_map(rest, [current_line | map])
  end

  def determine_cell_value("."), do: 0

  def determine_cell_value("@"), do: 1

  def check_adjacents(rows, max_neighbours, result \\ 0)

  def check_adjacents([], _max_neighbours, result), do: result

  def check_adjacents([row | rest_rows], max_neighbours, result) do

  end
end
