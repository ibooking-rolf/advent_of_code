defmodule Playground.AdventOfCode.TwentyTwentyTwo.DayOne do
  alias Playground.Helpers

  def part_one(input_filename) do
    File.read!(input_filename)
    |> String.split("\n\n")
    |> process_calories_for_elf([])
    |> Enum.max()
  end

  def part_two(input_filename) do
    File.read!(input_filename)
    |> String.split("\n\n")
    |> process_calories_for_elf([])
    |> Helpers.pick_top_from_list(3)
    |> Enum.reduce(0, fn cals, acc -> cals + acc end)
  end

  def process_calories_for_elf([], result_list) do
    result_list
  end

  def process_calories_for_elf([head | tail], result_list) do
    elf_calories =
      head
      |> String.split("\n")
      |> Enum.reduce(0, fn calories, acc -> Helpers.coerce_type!(calories, :integer) + acc end)

    process_calories_for_elf(tail, [elf_calories | result_list])
  end
end
