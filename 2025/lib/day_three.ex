defmodule AdventOfCode.DayThree do
  alias AdventOfCode.Helpers

  def start(example? \\ false) do
    file_name = "assets/3_input"

    file_name = if example?, do: file_name <> "_example.txt", else: file_name <> ".txt"

    batteries = Helpers.read_input(file_name)

    get_highest_joltage(batteries)
  end

  def get_highest_joltage(batteries, joltages \\ [])

  def get_highest_joltage([], joltages), do: Enum.sum(joltages)

  def get_highest_joltage([battery | rest], joltages) do
    # {value, index}
    {{last_battery_value, _last_battery_index}, indexed_battery} =
      battery
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)
      |> Enum.with_index()
      |> List.pop_at(-1)
      # |> IO.inspect()

    [{largest_battery_value, _largest_battery_index} = largest_battery | rest_sorted] = Enum.sort_by(indexed_battery, fn {value, _index} -> value end) |> Enum.reverse()

    next_largest_battery_value = find_next_largest(rest_sorted, largest_battery, last_battery_value)

    # IO.inspect("Largest battery: {#{largest_battery_value}, #{largest_battery_index}}, Next largest battery: #{next_largest_battery_value}")
    highest_joltage = "#{largest_battery_value}#{next_largest_battery_value}" |> String.to_integer()

    get_highest_joltage(rest, [highest_joltage | joltages])
  end

  def find_next_largest(sorted_batteries, largest_battery, last_battery, next_largest \\ nil)

  def find_next_largest(_sorted_batteries, _largest_battery, _last_battery, next_largest) when not is_nil(next_largest), do: next_largest

  def find_next_largest([], _largest_battery, last_battery, _next_largest), do: last_battery

  def find_next_largest([{value, index} | rest], {_largest_battery_value, largest_battery_index} = largest_battery, last_battery, next_largest) do
    if index > largest_battery_index and value >= last_battery do
      find_next_largest(rest, largest_battery, largest_battery, value)
    else
      find_next_largest(rest, largest_battery, last_battery, next_largest)
    end
  end
end
