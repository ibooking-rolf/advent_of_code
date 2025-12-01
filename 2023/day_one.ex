defmodule Playground.AdventOfCode.TwentyTwentyThree.DayOne do
  @numbers_as_chars %{
    "one" => 1,
    "two" => 2,
    "three" => 3,
    "four" => 4,
    "five" => 5,
    "six" => 6,
    "seven" => 7,
    "eight" => 8,
    "nine" => 9
  }

  def part_one(input_filename) do
    File.read!(input_filename)
    |> String.split("\n")
    |> calibrate([])
    |> Enum.reduce(0, fn cal, acc ->
      acc + cal
    end)
  end

  def part_two(input_filename) do
    File.read!(input_filename)
    |> String.split("\n")
    |> calibrate_extended([])
    |> Enum.reduce(0, fn cal, acc ->
      acc + cal
    end)
  end

  defp calibrate([], result_list), do: result_list

  defp calibrate([line | rest], result_list) do
    numbers =
      line
      |> String.graphemes()
      |> Enum.filter(fn char -> Regex.match?(~r/[0-9]/, char) end)

    number =
      "#{List.first(numbers)}#{List.last(numbers)}"
      |> String.to_integer()

    calibrate(rest, [number | result_list])
  end

  defp calibrate_extended([], result_list), do: result_list

  defp calibrate_extended([line | rest], result_list) do
    numbers =
      Regex.scan(~r/([0-9]|one|two|three|four|five|six|seven|eight|nine)/, line)
      |> Enum.map(fn number ->
        case List.first(number) in Map.keys(@numbers_as_chars) do
          true -> @numbers_as_chars[List.first(number)]
          false -> List.first(number) |> String.to_integer()
        end
      end)

    number =
      "#{List.first(numbers)}#{List.last(numbers)}"
      |> String.to_integer()

    calibrate_extended(rest, [number | result_list])
  end
end
