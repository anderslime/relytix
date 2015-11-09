defmodule Relytix.EventTest do
  use Relytix.ModelCase

  alias Relytix.Event

  @valid_attrs %{name: "some content", properties: %{}, time: "2010-04-17 14:00:00", visit_id: "7488a646-e31f-11e4-aace-600308960662"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Event.changeset(%Event{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Event.changeset(%Event{}, @invalid_attrs)
    refute changeset.valid?
  end
end
