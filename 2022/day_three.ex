defmodule Playground.AdventOfCode.TwentyTwentyTwo.DayThree do
  # one line is items, devided exactly in two for each compartment
  @points "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
  def part_one(input_filename) do
    File.read!(input_filename)
    |> String.split("\n")
    |> process_rucksack(0)
  end

  def part_two(input_filename) do
    File.read!(input_filename)
    |> String.split("\n")
    |> Enum.chunk_every(3)
    |> process_rucksack_part_two(0)
  end

  def process_rucksack([], points), do: points

  def process_rucksack([head | tail], points) do
    halfway =
      String.length(head)
      |> Integer.floor_div(2)

    current_point =
      filter_compartments(String.split_at(head, halfway))
      |> Enum.reduce(0, fn character, acc ->
        @points
        |> String.graphemes()
        |> Enum.find_index(fn point ->
          point == character
        end)
        |> Kernel.+(1)
        |> Kernel.+(acc)
      end)

    process_rucksack(tail, points + current_point)
  end

  def filter_compartments({compartment_one, compartment_two}) do
    compartment_one
    |> String.graphemes()
    |> Enum.filter(fn comp_one_char ->
      String.contains?(compartment_two, comp_one_char)
    end)
    |> Enum.uniq()
  end

  def process_rucksack_part_two([], points), do: points

  def process_rucksack_part_two([head | tail], points) do
    common =
      process_rucksack_chuck(head)
      |> Enum.reduce(0, fn character, acc ->
        @points
        |> String.graphemes()
        |> Enum.find_index(fn point ->
          point == character
        end)
        |> Kernel.+(1)
        |> Kernel.+(acc)
      end)

    process_rucksack_part_two(tail, points + common)
  end

  def process_rucksack_chuck([elf_one, elf_two, elf_three]) do
    common =
      elf_one
      |> String.graphemes()
      |> Enum.filter(fn elf_char ->
        String.contains?(elf_two, elf_char)
      end)
      |> Enum.join("")

    elf_three
    |> String.graphemes()
    |> Enum.filter(fn elf_char ->
      String.contains?(common, elf_char)
    end)
    |> Enum.uniq()
  end
end
