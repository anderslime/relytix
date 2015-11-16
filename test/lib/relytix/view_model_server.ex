defmodule Relytix.ViewModelServerTest do
  use ExUnit.Case, async: true
  alias Relytix.ViewModelServer

  test "it starts the server" do
    {:ok, server} = Relytix.ViewModelServer.start_link(name: :hello)
    assert ViewModelServer.get(server) == %{}
  end

  test "it processes a single event" do
    {:ok, server} = Relytix.ViewModelServer.start_link(name: :hello)
    {:ok, date} = Ecto.DateTime.cast({{2015, 5, 10}, {12, 20, 40}})
    event = %{date: date}
    ViewModelServer.process_event(server, event)
    assert ViewModelServer.get(server) == %{
      "2015-5-10-12-20" => 1
    }
  end

  test "it processes two events in same minute" do
    {:ok, server} = Relytix.ViewModelServer.start_link(name: :hello)
    {:ok, date1} = Ecto.DateTime.cast({{2015, 5, 10}, {12, 20, 40}})
    event1 = %{date: date1}
    {:ok, date2} = Ecto.DateTime.cast({{2015, 5, 10}, {12, 20, 50}})
    event2 = %{date: date2}
    ViewModelServer.process_event(server, event1)
    ViewModelServer.process_event(server, event2)
    assert ViewModelServer.get(server) == %{
      "2015-5-10-12-20" => 2
    }
  end

  test "it processes two events in different minutes" do
    {:ok, server} = Relytix.ViewModelServer.start_link(name: :hello)
    {:ok, date1} = Ecto.DateTime.cast({{2015, 5, 10}, {12, 25, 40}})
    event1 = %{date: date1}
    {:ok, date2} = Ecto.DateTime.cast({{2015, 5, 10}, {12, 20, 50}})
    event2 = %{date: date2}
    ViewModelServer.process_event(server, event1)
    ViewModelServer.process_event(server, event2)
    assert ViewModelServer.get(server) == %{
      "2015-5-10-12-25" => 1,
      "2015-5-10-12-20" => 1
    }
  end
end
