defmodule Playground.AdventOfCode.TwentyTwentyTwo.DayFive do
  def part_one(input_filename) do
    [starting_board, moves] =
      File.read!(input_filename)
      |> String.split("\n\n") # Part 1 is the starting board, part 2 is the moves

    starting_board = process_starting_board(starting_board)

    end_board =
      moves
      |> String.split("\n")
      |> process_moves(starting_board)

    end_board
  end

  def part_two(input_filename) do
    [starting_board, moves] =
      File.read!(input_filename)
      |> String.split("\n\n") # Part 1 is the starting board, part 2 is the moves

    starting_board = process_starting_board(starting_board)

    end_board =
      moves
      |> String.split("\n")
      |> process_chunk_moves(starting_board)

    end_board
  end

  def process_starting_board(starting_board) do
    starting_board
    |> String.graphemes()
    |> Enum.chunk_every(4)
    |> Enum.chunk_every(9)
    |> Enum.reverse()
    |> build_starting_board(0, [])
  end

  def build_starting_board([], _column, columns) do
    columns
  end

  def build_starting_board([head | tail], column, columns) do
    columns = fetch_column_value(head, column, columns)

    build_starting_board(tail, 0, columns)
  end

  def fetch_column_value([], _column, columns) do
    columns
  end

  def fetch_column_value([head | tail], column, columns) do
    {current_column_value, _} = List.pop_at(head, 1)

    {current_column, columns} = List.pop_at(columns, column)

    new_column_value =
      case {is_nil(current_column), current_column_value == " "} do
        {true, false} -> [current_column_value]
        {true, true} -> []
        {false, false} -> [current_column_value | current_column]
        {false, true} -> current_column
      end

    columns = List.insert_at(columns, column, new_column_value)

    fetch_column_value(tail, column + 1, columns)
  end

  def process_moves([], result_board) do
    result_board
  end

  def process_moves([head | tail], current_board) do
    [_, number_to_move, _, from, _, to] = String.split(head, " ")

    number_to_move = String.to_integer(number_to_move)

    from =
      String.to_integer(from)
      |> Kernel.-(1)

    to =
      String.to_integer(to)
      |> Kernel.-(1)

    current_board =
      process_move(number_to_move, from, to, current_board)

    process_moves(tail, current_board)
  end

  def process_move(0, _from, _to, result_board) do
    result_board
  end

  def process_move(number_to_move, from, to, current_board) do
    {move_from_row, current_board} = List.pop_at(current_board, from)
    {item_to_move, move_from_row} = List.pop_at(move_from_row, 0)
    current_board = List.insert_at(current_board, from, move_from_row)

    {move_to_row, current_board} = List.pop_at(current_board, to)
    move_to_row = List.insert_at(move_to_row, 0, item_to_move)
    current_board = List.insert_at(current_board, to, move_to_row)

    process_move(number_to_move - 1, from, to, current_board)
  end

  def process_chunk_moves([], current_board) do
    current_board
  end

  def process_chunk_moves([head | tail], current_board) do
    [_, number_to_move, _, from, _, to] = String.split(head, " ")

    number_to_move =
      String.to_integer(number_to_move)
      |> Kernel.-(1)

    from =
      String.to_integer(from)
      |> Kernel.-(1)

    to =
      String.to_integer(to)
      |> Kernel.-(1)

    current_board =
      process_chunk_move(number_to_move, from, to, current_board)

    process_chunk_moves(tail, current_board)
  end

  def process_chunk_move(number_to_move, from, to, current_board) do
    {move_from_row, current_board} = List.pop_at(current_board, from)
    items_to_move = Enum.slice(move_from_row, 0..number_to_move)

    splice_from = number_to_move + 1
    move_from_row = Enum.slice(move_from_row, splice_from..length(move_from_row))
    current_board = List.insert_at(current_board, from, move_from_row)

    {move_to_row, current_board} = List.pop_at(current_board, to)
    move_to_row = [items_to_move | move_to_row] |> List.flatten()
    current_board = List.insert_at(current_board, to, move_to_row)

    current_board
  end
end
