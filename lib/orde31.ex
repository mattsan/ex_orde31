defmodule Orde31 do
  def solve(input) do
    [d_str, x_str, y_str] = String.split(input, ",")
    d = String.to_integer(d_str)
    x = String.to_integer(x_str, d)
    y = String.to_integer(y_str, d)

    gurugurus(x, y, d)
    |> Enum.count()
    |> inspect()
  end

  def gurugurus(x, y, d) do
    gs =
      if guruguru?(x, d) do
        [x]
      else
        []
      end
    gurugurus(x, y, d, gs)
  end

  def gurugurus(x, y, d, gs) do
    next_x = next_guruguru(x, d)
    if next_x <= y do
      gurugurus(next_x, y, d, [next_x | gs])
    else
      gs
    end
  end

  def next_guruguru(x, d) do
    x1 = x + 1
    if guruguru?(x1, d) do
      x1
    else
      next_guruguru(x1, d)
    end
  end

  def guruguru?(x, d) do
    [d0 | ds] = Integer.digits(x, d)
    ds
    |> Enum.reduce(d0, fn
      _, false ->
        false

      x1, x0 ->
        if (x0 == x1) || (rem(x0 + 1, d) == x1) do
          x1
        else
          false
        end
    end)
  end
end
