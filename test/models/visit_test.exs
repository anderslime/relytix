defmodule Relytix.VisitTest do
  use Relytix.ModelCase

  alias Relytix.Visit

  @valid_attrs %{ip: "some content", started_at: "2010-04-17 14:00:00", visitor_id: "7488a646-e31f-11e4-aace-600308960662"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Visit.changeset(%Visit{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Visit.changeset(%Visit{}, @invalid_attrs)
    refute changeset.valid?
  end
end
