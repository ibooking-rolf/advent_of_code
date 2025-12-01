defmodule AdventOfCode.DayOne do
  alias AdventOfCode.Helpers

  def start(start_dail \\ 50, include_all \\ false) do
    Helpers.read_input("assets/1_input.txt")
    |> turn_dail(start_dail, 0, include_all)
  end

  def turn_dail([], _current_dail, passes, _include_all), do: passes

  def turn_dail([<<"R", to_turn::binary>> | rest], current_dail, passes, include_all) do
    to_turn = String.to_integer(to_turn)

    {passes, new_dail} = calculate_turn(current_dail, to_turn, passes, include_all)

    turn_dail(rest, new_dail, passes, include_all)
  end

  def turn_dail([<<"L", to_turn::binary>> | rest], current_dail, passes, include_all) do
    to_turn = (String.to_integer(to_turn) * -1)

    {passes, new_dail} = calculate_turn(current_dail, to_turn, passes, include_all)

    turn_dail(rest, new_dail, passes, include_all)
  end

  def calculate_turn(current_dail, to_turn, passes \\ 0, include_all \\ false)

  def calculate_turn(current_dail, to_turn, passes, true) when to_turn < -99 do
    calculate_turn(current_dail - 100, to_turn + 100, passes + 1, true)
  end

  def calculate_turn(current_dail, to_turn, passes, true) when to_turn > 99 do
    calculate_turn(current_dail + 100, to_turn - 100, passes + 1, true)
  end

  def calculate_turn(current_dail, to_turn, passes, include_all) do
    new_dail = current_dail + to_turn

    last_digs_current_dail = Integer.to_string(current_dail) |> String.slice(-2, 2) |> String.to_integer()

    last_digs_current_dail =
      case Integer.to_string(current_dail) do
        <<"-", _num::binary>> when last_digs_current_dail > 0 -> last_digs_current_dail * -1
        _ -> last_digs_current_dail
      end

    if rem(new_dail, 100) == 0 or new_dail == 0 do
      {passes + 1, new_dail}
    else
      passes =
        case {include_all, last_digs_current_dail, last_digs_current_dail + to_turn} do
          {true, x, y} when x in 1..99 and y not in 1..99 -> passes + 1
          {true, x, y} when x in -99..-1 and y not in -99..-1 -> passes + 1
          _ -> passes
        end
      {passes, new_dail}
    end
  end
end
