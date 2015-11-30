defmodule Relytix.ViewModelServerTest do
  use ExUnit.Case, async: true
  alias Relytix.Event

  @event_attributes %{
    name: "pageviews",
    properties: %{},
    visit_id: "e2971f8b-3c9f-4b87-9666-b641ac2c3dd1",
    id: "e2971f8b-3c9f-4b87-9666-b641ac2c3dd1",
    time: {{2015, 1, 1}, {0, 0, 0}}
  }

  test "it works" do
    changeset = Event.changeset(%Event{}, @event_attributes)
    Relytix.Repo.insert!(changeset)
    pageviews = Relytix.EventQueries.by_name("pageviews")
    assert Enum.count(pageviews) == 1
  end
end
