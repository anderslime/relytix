defmodule Relytix.TimeSeriesTest do
  use ExUnit.Case, async: true

  test "something" do
    series = Relytix.TimeSeries.from_view_model(%{
      {{2015, 1, 1}, {0, 0, 0}} => 5,
      {{2015, 1, 4}, {0, 0, 0}} => 10
    })

    assert series == %{
      {{2015, 1, 1}, {0, 0, 0}} => 5,
      {{2015, 1, 2}, {0, 0, 0}} => 0,
      {{2015, 1, 3}, {0, 0, 0}} => 0,
      {{2015, 1, 4}, {0, 0, 0}} => 10
    }
  end
end
