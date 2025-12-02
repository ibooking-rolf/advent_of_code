defmodule AdventOfCode.DayTwo do
  alias AdventOfCode.Helpers

  def start(example? \\ false) do
    file_name = "assets/2_input"

    file_name = if example?, do: file_name <> "_example.txt", else: file_name <> ".txt"

    ranges =
      Helpers.read_input(file_name)
      |> parse_file()
      |> IO.inspect()

    highest_lookback = get_highest_lookback(ranges)

    invalid_ids = check(ranges, [], highest_lookback) |> IO.inspect(label: "Invalid IDs", limit: :infinity)

    invalid_ids = invalid_ids |> Enum.uniq() |> IO.inspect(label: "Unique Invalid IDs", limit: :infinity)

    Enum.sum(invalid_ids)
  end

  def parse_file([input]) do
    input
    |> String.split(",")
    |> Enum.map(&String.split(&1, "-"))
  end

  def get_highest_lookback(ranges, result \\ 0)

  def get_highest_lookback([], result), do: Integer.floor_div(result, 2)

  def get_highest_lookback([[_from, to] | rest], highest_lookback) do
    current_lookback = String.length(to)

    if current_lookback > highest_lookback do
      get_highest_lookback(rest, current_lookback)
    else
      get_highest_lookback(rest, highest_lookback)
    end
  end

  def check(ranges, to_be_checked \\ [], highest_lookback \\ 0, invalid_ids \\ [])

  def check(_ranges, _to_be_checked, highest_lookback, invalid_ids) when highest_lookback == 0, do: invalid_ids

  def check([], to_be_checked, highest_lookback, invalid_ids) do
    check(to_be_checked, [], highest_lookback - 1, invalid_ids)
  end

  def check([[from, to] | rest], to_be_checked, highest_lookback, invalid_ids) do
    # highest_lookback = Integer.floor_div(String.length(to), 2)
    regex = ~r/^(.{#{highest_lookback}}).*\1$/

    checked_ids =
      for id <- String.to_integer(from)..String.to_integer(to) do
        id_str = Integer.to_string(id)

        add? =
          cond do
            Regex.match?(regex, id_str) and rem(String.length(id_str), 2) != 0 and highest_lookback == 1 ->
              [_, match] = Regex.run(regex, id_str)

              IO.inspect(String.count(id_str, match), label: "Count of #{match} in #{id_str}")
              String.count(id_str, match) == String.length(id_str)

            Regex.match?(regex, id_str) and highest_lookback == 1 ->
              [_, match] = Regex.run(regex, id_str)

              String.count(id_str, match) == String.length(id_str)

            Regex.match?(regex, id_str) and rem(highest_lookback, 2) != 0 ->
              [_, match] = Regex.run(regex, id_str)

              IO.inspect(String.count(id_str, match), label: "Count of #{match} in #{id_str}")
              String.count(id_str, match) == String.length(id_str)

            Regex.match?(regex, id_str) and rem(String.length(id_str), 2) == 0 -> true

            true -> false
          end

        {add?, id}
      end
      |> IO.inspect(label: "Checked IDs for range #{from}-#{to}, lookback #{highest_lookback}", limit: :infinity)

    {new_invalid_ids, to_be_checked} =
      Enum.reduce(checked_ids, {[], to_be_checked}, fn
        {true, id}, {invalid_acc, to_be_checked_acc} ->
          {[id | invalid_acc], to_be_checked_acc}

        {false, id}, {invalid_acc, to_be_checked_acc} ->
          {invalid_acc, [[Integer.to_string(id), Integer.to_string(id)] | to_be_checked_acc]}
      end)

    check(rest, to_be_checked, highest_lookback, invalid_ids ++ new_invalid_ids)
  end
end
