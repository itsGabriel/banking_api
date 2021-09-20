defmodule BankingApiWeb.TransactionControllerTest do
  use BankingApiWeb.ConnCase
  alias BankingApi.Repo
  alias BankingApi.Accounts.User
  alias BankingApi.UserAccount.Account
  alias BankingApi.Guardian

  @valid_attrs_user %{email: "testmail.com", password: "some password", username: "some username"}
  @valid_attrs_user2 %{
    email: "testmail2.com",
    password: "some password",
    username: "some username"
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "withdraw" do
    setup [:auth_user]

    test "user withdraw with valid data render user account", %{conn: conn, account: account} do
      data = %{account: account.code, amount: 1000}

      conn = post(conn, Routes.transaction_path(conn, :withdraw), data)

      assert %{
               "id" => _,
               "balance" => _,
               "code" => _
             } = json_response(conn, 200)["data"]
    end

    test "user withdraw with invalid data renders error changeset", %{
      conn: conn
    } do
      data = %{account: nil, amount: nil}

      conn = post(conn, Routes.transaction_path(conn, :withdraw), data)

      assert %{
               "account" => ["can't be blank"],
               "amount" => ["can't be blank"]
             } = json_response(conn, 400)["errors"]
    end

    test "user withdraw with invalid account code renders error changeset", %{
      conn: conn
    } do
      data = %{account: "0", amount: 1000}

      conn = post(conn, Routes.transaction_path(conn, :withdraw), data)

      assert %{
               "message" => "Account not found"
             } = json_response(conn, 400)
    end

    test "user withdraw with invalid balance render error changeset", %{
      conn: conn,
      account: account
    } do
      data = %{account: account.code, amount: 100_000_000}

      conn = post(conn, Routes.transaction_path(conn, :withdraw), data)

      assert %{
               "balance" => ["Insufficient funds"]
             } = json_response(conn, 400)["errors"]
    end
  end

  describe "transfer" do
    setup [:auth_user, :create_user2]

    test "user transfer with valid data render user account", %{
      conn: conn,
      account: account,
      account2: account2
    } do
      data = %{account_origin: account.code, amount: 1000}

      conn = post(conn, Routes.transaction_path(conn, :transfer, account2.code), data)

      assert %{
               "id" => _,
               "balance" => _,
               "code" => _
             } = json_response(conn, 200)["data"]
    end

    test "user transfer with invalid data renders error changeset", %{
      conn: conn,
      account2: account2
    } do
      data = %{account_origin: nil, amount: nil}

      conn = post(conn, Routes.transaction_path(conn, :transfer, account2.code), data)

      assert %{
               "account_origin" => ["can't be blank"],
               "amount" => ["can't be blank"]
             } = json_response(conn, 400)["errors"]
    end

    test "user transfer with invalid balance render error changeset", %{
      conn: conn,
      account: account,
      account2: account2
    } do
      data = %{account_origin: account.code, amount: 100_000_000}

      conn = post(conn, Routes.transaction_path(conn, :transfer, account2.code), data)

      assert %{
               "balance" => ["Insufficient funds"]
             } = json_response(conn, 400)["errors"]
    end

    test "user transfer with invalid account code render error", %{
      conn: conn,
      account2: account2
    } do
      data = %{account_origin: "0", amount: 1000}

      conn = post(conn, Routes.transaction_path(conn, :transfer, account2.code), data)

      assert %{
               "message" => "Account not found"
             } = json_response(conn, 400)
    end
  end

  defp create_user() do
    {:ok, user} = User.changeset(%User{}, @valid_attrs_user) |> Repo.insert()

    {:ok, account} =
      Account.changeset(%Account{}, %{code: "1000", balance: 10000, user_id: user.id})
      |> Repo.insert()

    {user, account}
  end

  defp create_user2(_) do
    {:ok, user2} = User.changeset(%User{}, @valid_attrs_user2) |> Repo.insert()

    {:ok, account2} =
      Account.changeset(%Account{}, %{code: "1001", balance: 10000, user_id: user2.id})
      |> Repo.insert()

    {:ok, account2: account2}
  end

  def auth_user(%{conn: conn, user: user}) do
    # {:ok, user} = create_user(:user)
    {:ok, token, _} = Guardian.encode_and_sign(user)
    conn = put_req_header(conn, "authorization", "Bearer #{token}")
    %{conn: conn, user: user}
  end

  def auth_user(%{conn: conn}) do
    {user, account} = create_user()
    {:ok, token, _} = Guardian.encode_and_sign(user)
    conn = put_req_header(conn, "authorization", "Bearer #{token}")
    %{conn: conn, user: user, account: account}
  end
end
