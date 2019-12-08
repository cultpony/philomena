defmodule PhilomenaWeb.Filter.SpoilerController do
  use PhilomenaWeb, :controller

  alias Philomena.Filters
  alias Philomena.Tags.Tag
  alias Philomena.Repo

  plug PhilomenaWeb.FilterBannedUsersPlug
  plug :authorize_filter
  plug :load_resource, model: Tag, id_field: "slug", id_name: "tag_id", persisted: true

  def create(conn, _params) do
    case Filters.spoiler_tag(conn.assigns.current_filter, conn.assigns.tag) do
      {:ok, _filter} ->
        conn
        |> put_status(:ok)
        |> text("")

      {:error, _changeset} ->
        conn
        |> put_status(:internal_server_error)
        |> text("")
    end
  end

  def delete(conn, _params) do
    case Filters.unspoiler_tag(conn.assigns.current_filter, conn.assigns.tag) do
      {:ok, _filter} ->
        conn
        |> put_status(:ok)
        |> text("")

      {:error, _changeset} ->
        conn
        |> put_status(:internal_server_error)
        |> text("")
    end
  end

  defp authorize_filter(conn, _opts) do
    case Canada.Can.can?(conn.assigns.current_user, :edit, conn.assigns.current_filter) do
      true ->
        conn

      false ->
        conn
        |> put_status(:forbidden)
        |> text("")
    end
  end
end