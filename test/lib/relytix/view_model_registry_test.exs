defmodule Relytix.ViewModelRegistryTest do
  use ExUnit.Case, async: true
  alias Relytix.ViewModelRegistry

  @event_attributes %{
    name: "pageviews",
    properties: %{},
    visit_id: "e2971f8b-3c9f-4b87-9666-b641ac2c3dd1",
    id: "e2971f8b-3c9f-4b87-9666-b641ac2c3dd1",
    time: {{2015, 1, 1}, {0, 0, 0}}
  }

  test "it restarts a view model if it is killed" do
    key = "pageviews"
    {:ok, pid} = ViewModelRegistry.ensure_view_model(key)
    Process.exit(pid, :kill)
    :timer.sleep 1 # LOL, uncertaincy # lol speling
    assert :undefined != Relytix.ViewModelServer.whereis(key)
  end
end
