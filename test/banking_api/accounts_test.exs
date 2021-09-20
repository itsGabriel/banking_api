defmodule BankingApi.AccountsTest do
  use BankingApi.DataCase
  alias Bcrypt

  alias BankingApi.Accounts
  alias BankingApi.Accounts.User
  alias BankingApi.UserAccount.Account

  describe "users" do
    alias BankingApi.Accounts.User

    @valid_attrs %{email: "testmail.com", password: "some password", username: "some username"}
    @invalid_attrs %{email: nil, password: nil, username: nil}

    test "create_user with valid data creates a user" do
      assert {:ok, %User{} = user, %Account{} = account} = Accounts.create_user(@valid_attrs)
      assert {:ok, user} == Bcrypt.check_pass(user, "some password", hash_key: :password)
    end

    test "create_user with existing email" do
      Accounts.create_user(@valid_attrs)
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@valid_attrs)
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end
  end
end
