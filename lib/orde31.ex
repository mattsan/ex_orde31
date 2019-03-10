defmodule Orde31 do
  @moduledoc """
  [オフラインリアルタイムどう書くE31「ぐるぐる数」](http://nabetani.sakura.ne.jp/hena/orde31rotnum/) を Elixir で解いた。
  """

  @doc """
  解答を返す

  ## Examples

      iex> Orde31.solve("4,1313,3012")
      "12"

      iex>  Orde31.solve("10,100,110")
      "0"
  """
  @spec solve(String.t()) :: String.t()
  def solve(input) do
    [base_str, x_str, y_str] = String.split(input, ",")

    base = String.to_integer(base_str)
    x = String.to_integer(x_str, base)
    y = String.to_integer(y_str, base)

    calc(x, y, base)
    |> Integer.to_string()
  end

  @doc """
  `base` 進数で `x` 以上 `y` 以下のぐるぐる数の数を数える

  - `x` 対象の下限
  - `y` 対象の上限
  - `base` 基数
  """
  @spec calc(integer, integer, integer) :: integer
  # 2 進数の場合は全部ぐるぐる数
  def calc(x, y, 2), do: y - x + 1

  # y 以下のぐるぐる数から x 以下のぐるぐる数の数を引く
  # x もぐるぐる数の場合は x も数に加える
  def calc(x, y, base) do
    d = if guruguru?(x, base), do: 1, else: 0
    count(y, base) - count(x, base) + d
  end

  @doc """
  `max` 以下の `base` 進数のぐるぐる数を数える

  - `max` ぐるぐる数の上限
  - `base` 基数
  """
  @spec count(integer, integer) :: integer
  def count(max, base) do
    count(max, base, [1], 1)
  end

  @doc """
  `digits` 以降で `max` 以下の `base` 進数のぐるぐる数を数える

  - `max` ぐるぐる数の上限
  - `base` 基数
  - `digits` ぐるぐる数を `base` 進数で表した時の各桁の数値のリスト（先頭が最下位桁、末尾が最上位桁の順）
  - `c` 元になるカウント
  """
  @spec count(integer, integer, [integer], integer) :: integer
  def count(max, base, digits, c) do
    n = digits |> Enum.reverse() |> Integer.undigits(base)

    if n <= max do
      count(max, base, next(digits, base), c + 1)
    else
      c
    end
  end

  @doc """
  次のぐるぐる数を取得する

  - `digits` ぐるぐる数を `base` 進数で表した時の各桁の数値のリスト（先頭が最下位桁、末尾が最上位桁の順）
  - `base` 基数
  """
  @spec next([integer], integer) :: [integer]
  def next(digits, base)
  def next([1], 2),                                     do: [0, 1]
  def next([digit], base) when digit == base - 1,       do: [1, 1]
  def next([digit], _),                                 do: [digit + 1]

  def next([d0, d0 | digits], base) when d0 < base - 1, do: [d0 + 1, d0 | digits]
  def next([0, d1 | digits], _),                        do: [d1, d1 | digits]

  def next([_, d1 | digits], base) do
    [d | _] = ds = next([d1 | digits], base)

    if d == base - 1 do
      [0 | ds]
    else
      [d | ds]
    end
  end

  @doc """
  `n` が `base` 進数のぐるぐる数か否かを返す
  """
  @spec guruguru?(integer, integer) :: boolean
  def guruguru?(n, base) do
    [first_digit | digits] = Integer.digits(n, base)

    !!Enum.reduce_while(digits, first_digit, fn
      digit, digit -> {:cont, digit}
      digit, prev when rem(prev + 1, base) == digit -> {:cont, digit}
      _, _ -> {:halt, false}
    end)
  end
end
