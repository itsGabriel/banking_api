defmodule BankingApi.UserAccountTest do
  use BankingApi.DataCase

  alias BankingApi.UserAccount
  alias BankingApi.Accounts.User
  alias BankingApi.UserAccount.Account

  describe "accounts" do
    @usr_attrs %{email: "testmail.com", password: "some password", username: "some username"}
    @invalid_attrs %{balance: nil, code: nil, user_id: nil}

    setup do
      {:ok, user} = User.changeset(%User{}, @usr_attrs) |> Repo.insert()
      {:ok, user: user.id}
    end

    test "create_account with valid data", state do
      data = %{code: "2000", balance: 10000, user_id: state[:user]}

      assert {:ok, %Account{} = account} = UserAccount.create_account(data)
    end

    test "create_account with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UserAccount.create_account(@invalid_attrs)
    end

    test "create_account with invalid balance return error changeset", state do
      data = %{code: "2000", balance: -1, user_id: state[:user]}

      assert {:error, %Ecto.Changeset{}} = UserAccount.create_account(data)
    end
  end
end
