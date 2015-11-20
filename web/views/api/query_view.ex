defmodule Relytix.Api.QueryView do
  use Relytix.Web, :view

  def render("index.json", %{events: events}) do
    sorted_stuff =
      Map.to_list(events)
      |> Enum.sort(fn({date1, _}, {date2, _}) -> date1 < date2 end)
    %{series: %{
        "views": Enum.map(sorted_stuff, fn({_, v}) -> v end)
      },
      columns: Enum.map(sorted_stuff, fn({k, _}) ->
        {:ok, datetime} = Ecto.DateTime.cast(k)
        datetime
      end)
    }
  end
end
