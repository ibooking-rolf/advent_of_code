defmodule Playground.AdventOfCode.TwentyTwentyTwo.DaySix do
  def part_one(input_filename) do
    File.read!(input_filename)
    |> String.graphemes()
    |> Enum.chunk_while({"", 1}, fn curr, {acc, count} ->
      check_list = "#{acc}#{curr}" |> String.graphemes()

      if length(check_list) == 4 do
        if length(Enum.uniq(check_list)) == 4 do
          acc = Enum.join(check_list, "")
          {:halt, {acc, count}}
        else
          {_, acc} = check_list |> List.pop_at(0)

          acc = Enum.join(acc, "")
          {:cont, {acc, count + 1}}
        end
      else
        acc = Enum.join(check_list, "")
        {:cont, {acc, count + 1}}
      end

    end, fn
      {_unique, number} -> number
      _ -> :error
    end)
  end

  def part_two(input_filename) do
    File.read!(input_filename)
    |> String.graphemes()
    |> Enum.chunk_while({"", 1}, fn curr, {acc, count} ->
      check_list = "#{acc}#{curr}" |> String.graphemes()

      if length(check_list) == 14 do
        if length(Enum.uniq(check_list)) == 14 do
          acc = Enum.join(check_list, "")
          {:halt, {acc, count}}
        else
          {_, acc} = check_list |> List.pop_at(0)

          acc = Enum.join(acc, "")
          {:cont, {acc, count + 1}}
        end
      else
        acc = Enum.join(check_list, "")
        {:cont, {acc, count + 1}}
      end

    end, fn
      {_unique, number} -> number
      _ -> :error
    end)
  end
end
