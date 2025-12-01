defmodule Playground.AdventOfCode.TwentyTwentyTwo.DayFour do
  def part_one(input_filename) do
    File.read!(input_filename)
    |> String.split("\n")
    |> process_cleanup(0)
  end

  def part_two(input_filename) do
    File.read!(input_filename)
    |> String.split("\n")
    |> process_better_cleanup(0)
  end

  def process_cleanup([], points), do: points

  def process_cleanup([head | tail], points) do
    [elf_one, elf_two] = String.split(head, ",")

    elf_one = create_map_set(elf_one)
    elf_two = create_map_set(elf_two)

    case MapSet.subset?(elf_one, elf_two) do
      true -> process_cleanup(tail, points + 1)
      false ->
        case MapSet.subset?(elf_two, elf_one) do
          true -> process_cleanup(tail, points + 1)
          false -> process_cleanup(tail, points)
        end
    end
  end

  def process_better_cleanup([], points), do: points

  def process_better_cleanup([head | tail], points) do
    [elf_one, elf_two] = String.split(head, ",")

    elf_one = create_map_set(elf_one)
    elf_two = create_map_set(elf_two)

    case MapSet.disjoint?(elf_one, elf_two) do
      true -> process_better_cleanup(tail, points)
      false -> process_better_cleanup(tail, points + 1)
    end
  end

  def create_map_set(elf) do
    [from, to] = String.split(elf, "-")

    from = String.to_integer(from)
    to = String.to_integer(to)

    MapSet.new((for n <- from..to, do: n))
  end
end
