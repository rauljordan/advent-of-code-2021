defmodule Advent.Day3 do
  @moduledoc """
  Day 3 of advent of code wants us to look at a collection
  of byte strings and find the most common and least common
  bit in each column.

  For example,
  110011
  001010
  101100

  (Part A): Most common bit by column:
  1 is the most common in the 0th column, 0 in the 1st column,
  1 in the 3rd column, 0 in the 4th, 1 in the 5th, and 0 in the 6th.
  We want to then create a bytestring from these frequencies, so we
  end up with 101010 as a result for the example above.

  (Part B): Least common bit by column:
  The problem wants us to repeat the same procedure as above,
  but instead consider the least common bit in each column

  The answer to the problem is found by multiplying the decimal
  representation of the bitstrings from parts A and B. The problem
  refers to the numbers from parts A and B as gamma and epsilon,
  respectively.
  """
  def compute_answer(data) do
    rows =
      data
      |> String.split("\n", trim: true)
    
    {gamma_result, _} = 
      rows
      |> transform(&gamma/2)
    {epsilon_result, _} = 
      rows
      |> transform(&epsilon/2)
    gamma_result * epsilon_result
  end

  def gamma(num_ones, threshold) do
    if num_ones > threshold, do: 1, else: 0
  end

  def epsilon(num_ones, threshold) do
    if num_ones > threshold, do: 0, else: 1
  end

  # The key to the problem is we want to transform the collection
  # of bits
  #
  #  110011
  #  001010
  #  101100
  #  001100
  #
  # into a single bytestring depending on whether we are doing the
  # gamma or epsilon calculations. We take advantage of a simple trick
  # here to make our life easier. We ask, "In a given column, are there more 
  # ones or zeros?". We count the number of rows. In this example, we have
  # 4 rows, so to determine the most common bit, we check
  # if the sum of bits is > half the number of rows. For example, if there
  # are 4 rows and 3 elements in the column are 1s, then the most common
  # bit in the column is a 1.
  def transform(rows, comparator) do
    # If the sum of a column is > threshold for gamma, 
    # or < threshold for epsilon, then we act differently.
    threshold = Kernel.length(rows) / 2
    rows
    # We turn each string into a list of characters, and convert
    # each into each "1" or "0" into an integer. We end up with a matrix.
    |> Enum.map(fn str -> 
        str |> String.graphemes |> Enum.map(&String.to_integer/1) 
      end)
    # We transpose the matrix to make it easier to sum the columns.
    # When transposing, the columns, become the rows, so we can &Enum.sum/1.
    |> transpose
    |> Enum.map(&Enum.sum/1)
    # Use the comparator func to determine whether we want a 0 or a 1.
    |> Enum.map(fn count -> comparator.(count, threshold) end)
    # Join into a string and parse into a decimal representation.
    |> Enum.join("")
    |> Integer.parse(2)
  end

  # Transpose a matrix (switch its rows with its columns).
  def transpose([[] | _]), do: []
  def transpose(m) do
    [Enum.map(m, &hd/1) | transpose(Enum.map(m, &tl/1))]
  end
end

{_, data} = File.read("/tmp/input.txt")
data |> Advent.Day3.compute_answer |> IO.inspect
