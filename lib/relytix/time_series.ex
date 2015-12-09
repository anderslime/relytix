defmodule Relytix.TimeSeries do
  use Timex
  alias TimexInterval.DateTimeInterval, as: Interval

  # def from_view_model(%{}), do: %{}
  def from_view_model(view_model) do
    dates = Dict.keys(view_model)
    first_date = dates |> Enum.min
    last_date  = :calendar.universal_time
    all_datetimes =
      Interval.new(from: Date.from(first_date), until: Date.from(last_date))
      |> Interval.with_step(secs: 1)
      |> Enum.map(fn (v) -> {{v.year, v.month, v.day}, {0, 0, 0}} end)
      |> Enum.into HashSet.new
    view_model_date_set = Enum.into(dates, HashSet.new)
    Enum.reduce(Set.difference(all_datetimes, view_model_date_set), view_model, fn(date, old_view_model) ->
      Map.put(old_view_model, date, 0)
    end)
  end
end
