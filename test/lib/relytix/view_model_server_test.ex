defmodule Relytix.ViewModelServerTest do
  use ExUnit.Case, async: true
  alias Relytix.ViewModelServer

  def datetime_in_minute(minute) do
    {:ok, date} = Ecto.DateTime.cast({{2015, 5, 10}, {12, minute, 40}})
    date
  end

  def event_factory(version, date) do
    %{version: version, inserted_at: date}
  end

  test "starting and processing event" do
    key = "pageviews"
    event1 = event_factory(1, datetime_in_minute(20))
    {:ok, pid} = ViewModelServer.start_link(key)
    ViewModelServer.process_event(key, event1)
    assert ViewModelServer.version(key) == 1
  end

  test "starting and processing event on already started view model" do
    key = "pageviews"
    event1 = event_factory(1, datetime_in_minute(20))
    {:ok, _} = ViewModelServer.start_link(key)
    ViewModelServer.process_event(key, event1)
    assert ViewModelServer.version(key) == 1
  end

  #
  # test "processes two events in same minute" do
  #   {:ok, server} = Relytix.ViewModelServer.start_link(name: :hello)
  #   event1 = event_factory(1, datetime_in_minute(20))
  #   event2 = event_factory(2, datetime_in_minute(20))
  #   ViewModelServer.process_event(server, event1)
  #   ViewModelServer.process_event(server, event2)
  #   assert ViewModelServer.get(server) == %{
  #     "2015-5-10-12-20" => 2
  #   }
  # end
  #
  # test "processes two events in different minutes" do
  #   {:ok, server} = Relytix.ViewModelServer.start_link(name: :hello)
  #   event1 = event_factory(1, datetime_in_minute(20))
  #   event2 = event_factory(2, datetime_in_minute(25))
  #   ViewModelServer.process_event(server, event1)
  #   ViewModelServer.process_event(server, event2)
  #   assert ViewModelServer.get(server) == %{
  #     "2015-5-10-12-20" => 1,
  #     "2015-5-10-12-25" => 1
  #   }
  # end
  #
  # test "counts as one when same event is processed twice" do
  #   {:ok, server} = Relytix.ViewModelServer.start_link(name: :hello)
  #   event = event_factory(1, datetime_in_minute(20))
  #   ViewModelServer.process_event(server, event)
  #   ViewModelServer.process_event(server, event)
  #   assert ViewModelServer.get(server) == %{
  #     "2015-5-10-12-20" => 1
  #   }
  # end
  #
  # test "processes multiple events" do
  #   {:ok, server} = Relytix.ViewModelServer.start_link(name: :hello)
  #   event1 = event_factory(1, datetime_in_minute(20))
  #   event2 = event_factory(2, datetime_in_minute(20))
  #   ViewModelServer.process_events(server, [event1, event2])
  #   assert ViewModelServer.get(server) == %{
  #     "2015-5-10-12-20" => 2
  #   }
  #   assert ViewModelServer.version(server) == 2
  # end
end
