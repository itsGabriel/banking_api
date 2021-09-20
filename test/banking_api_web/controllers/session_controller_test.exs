defmodule BankingApiWeb.SessionControllerTest do
  use BankingApiWeb.ConnCase
  alias BankingApi.Accounts

  @valid_attrs %{email: "testmail.com", password: "some password", username: "some username"}
  @invalid_attrs %{email: nil, password: nil, username: nil}

  test "create an user with valid data", %{conn: conn} do
    conn = post(conn, Routes.session_path(conn, :create), @valid_attrs)

    assert %{
             "id" => _,
             "name" => "some username",
             "account" => %{"balance" => _, "code" => _, "id" => _},
             "token" => _
           } = json_response(conn, 200)["data"]
  end

  test "cannot create an user with invalid data", %{conn: conn} do
    conn = post(conn, Routes.session_path(conn, :create), @invalid_attrs)

    assert %{
             "errors" => %{"email" => ["can't be blank"], "password" => ["can't be blank"]}
           } = json_response(conn, 400)
  end

  test "cannot create an user with existing email", %{conn: conn} do
    Accounts.create_user(@valid_attrs)

    conn = post(conn, Routes.session_path(conn, :create), @valid_attrs)

    assert %{
             "errors" => %{"email" => ["has already been taken"]}
           } = json_response(conn, 409)
  end
end
