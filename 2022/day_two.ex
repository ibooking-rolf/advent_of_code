defmodule Playground.AdventOfCode.TwentyTwentyTwo.DayTwo do
  # A plays rock
  # B plays paper
  # C plays scissors

  # X should play rock
  # Y should play paper
  # Z should play scissors

  # Rock is 1 point
  # Paper is 2 points
  # Scissors is 3 points

  # 0 points if loss
  # 3 points if draw
  # 6 points if won
  def part_one(input_filename) do
    File.read!(input_filename)
    |> String.split("\n")
    |> calculate_score(0)
  end

  def part_two(input_filename) do
    File.read!(input_filename)
    |> String.split("\n")
    |> change_hand([])
    |> calculate_score(0)
  end

  def calculate_score([], result), do: result

  def calculate_score([head | tail], result) do
    [opponent, player] = String.split(head, " ")

    score = calculate_score(opponent, player)

    calculate_score(tail, result + score)
  end

  def calculate_score("A", "X"), do: 1 + 3
  def calculate_score("A", "Y"), do: 2 + 6
  def calculate_score("A", "Z"), do: 3 + 0

  def calculate_score("B", "X"), do: 1 + 0
  def calculate_score("B", "Y"), do: 2 + 3
  def calculate_score("B", "Z"), do: 3 + 6

  def calculate_score("C", "X"), do: 1 + 6
  def calculate_score("C", "Y"), do: 2 + 0
  def calculate_score("C", "Z"), do: 3 + 3

  def change_hand([], result_list), do: result_list

  def change_hand([head | tail], result_list) do
    [opponent, player] = String.split(head, " ")

    player = change_hand(opponent, player)

    change_hand(tail, [Enum.join([opponent, player], " ") | result_list])
  end

  def change_hand("A", "X"), do: "Z"
  def change_hand("A", "Y"), do: "X"
  def change_hand("A", "Z"), do: "Y"

  def change_hand("B", "X"), do: "X"
  def change_hand("B", "Y"), do: "Y"
  def change_hand("B", "Z"), do: "Z"

  def change_hand("C", "X"), do: "Y"
  def change_hand("C", "Y"), do: "Z"
  def change_hand("C", "Z"), do: "X"
end
