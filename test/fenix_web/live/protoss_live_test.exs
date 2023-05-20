defmodule FenixWeb.ProtossLiveTest do
  use FenixWeb.ConnCase

  import Phoenix.LiveViewTest
  import Fenix.SharedFixtures

  @create_attrs %{deleted: true, faction: 1}
  @update_attrs %{deleted: false, faction: 2}
  @invalid_attrs %{deleted: false, faction: nil}

  defp create_protoss(_) do
    protoss = protoss_fixture()
    %{protoss: protoss}
  end

  describe "Index" do
    setup [:create_protoss]

    test "lists all protoss", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.protoss_index_path(conn, :index))

      assert html =~ "Listing Protoss"
    end

    test "saves new protoss", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.protoss_index_path(conn, :index))

      assert index_live |> element("a", "New Protoss") |> render_click() =~
               "New Protoss"

      assert_patch(index_live, Routes.protoss_index_path(conn, :new))

      assert index_live
             |> form("#protoss-form", protoss: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#protoss-form", protoss: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.protoss_index_path(conn, :index))

      assert html =~ "Protoss created successfully"
    end

    test "updates protoss in listing", %{conn: conn, protoss: protoss} do
      {:ok, index_live, _html} = live(conn, Routes.protoss_index_path(conn, :index))

      assert index_live |> element("#protoss-#{protoss.id} a", "Edit") |> render_click() =~
               "Edit Protoss"

      assert_patch(index_live, Routes.protoss_index_path(conn, :edit, protoss))

      assert index_live
             |> form("#protoss-form", protoss: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#protoss-form", protoss: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.protoss_index_path(conn, :index))

      assert html =~ "Protoss updated successfully"
    end

    test "deletes protoss in listing", %{conn: conn, protoss: protoss} do
      {:ok, index_live, _html} = live(conn, Routes.protoss_index_path(conn, :index))

      assert index_live |> element("#protoss-#{protoss.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#protoss-#{protoss.id}")
    end
  end

  describe "Show" do
    setup [:create_protoss]

    test "displays protoss", %{conn: conn, protoss: protoss} do
      {:ok, _show_live, html} = live(conn, Routes.protoss_show_path(conn, :show, protoss))

      assert html =~ "Show Protoss"
    end

    test "updates protoss within modal", %{conn: conn, protoss: protoss} do
      {:ok, show_live, _html} = live(conn, Routes.protoss_show_path(conn, :show, protoss))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Protoss"

      assert_patch(show_live, Routes.protoss_show_path(conn, :edit, protoss))

      assert show_live
             |> form("#protoss-form", protoss: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#protoss-form", protoss: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.protoss_show_path(conn, :show, protoss))

      assert html =~ "Protoss updated successfully"
    end
  end
end
