defmodule Advent.Day4 do
  @moduledoc """
  Say we have 1, 5, 3 then we want to align
  all of them into a common value in the fewest number
  of steps. Let's say we want to align all of them to 1,
  it would cost (5 - 4 = 1), (3 - 2 = 1) so total steps used
  are 6. Let's try aligning to 3, for example:
  (1 + 2 = 3), (5 - 2 = 3), so we get a total cost of 4.
  If we want to align to 5, we do (1 + 4 = 5), (3 + 2 = 5), so
  a total cost of 6. The best option is to align to 3 with a total
  fuel cost of 4.

  The problem gives us the following fixture:

  16,1,2,0,4,2,7,1,2,14

  with the answer of 37 fuel. This is the cheapest possible outcome; 
  more expensive outcomes include aligning at position 1 (41 fuel), 
  position 3 (39 fuel), or position 10 (71 fuel).

  First, we'll try to arrive at the same results as the fixture
  with a brute force solution, computing the min for every
  possible alignment value in the list.
  """
  def compute_best_alignment(data) do
    nums =
      data
      |> String.trim
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
    potential_alignments = nums |> Enum.uniq()
    total_cost_by_aligment =
      potential_alignments
      |> Enum.map(fn alignment -> 
        nums
        |> Enum.reduce(0, fn (elem, acc) -> 
          acc + Kernel.abs(elem - alignment)
        end)
      end)
    Enum.zip(
      potential_alignments,
      total_cost_by_aligment
    )
    |> Enum.min_by(fn ({_, cost}) -> cost end)
  end
end

{_, data} = File.read("/tmp/input.txt")
data |> Advent.Day4.compute_best_alignment |> IO.inspect
