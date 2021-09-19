defmodule BankingApi.UserAccountTest do
  use BankingApi.DataCase

  alias BankingApi.UserAccount

  describe "accounts" do
    alias BankingApi.UserAccount.Account

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def account_fixture(attrs \\ %{}) do
      {:ok, account} =
        attrs
        |> Enum.into(@valid_attrs)
        |> UserAccount.create_account()

      account
    end

    test "list_accounts/0 returns all accounts" do
      account = account_fixture()
      assert UserAccount.list_accounts() == [account]
    end

    test "get_account!/1 returns the account with given id" do
      account = account_fixture()
      assert UserAccount.get_account!(account.id) == account
    end

    test "create_account/1 with valid data creates a account" do
      assert {:ok, %Account{} = account} = UserAccount.create_account(@valid_attrs)
    end

    test "create_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UserAccount.create_account(@invalid_attrs)
    end

    test "update_account/2 with valid data updates the account" do
      account = account_fixture()
      assert {:ok, %Account{} = account} = UserAccount.update_account(account, @update_attrs)
    end

    test "update_account/2 with invalid data returns error changeset" do
      account = account_fixture()
      assert {:error, %Ecto.Changeset{}} = UserAccount.update_account(account, @invalid_attrs)
      assert account == UserAccount.get_account!(account.id)
    end

    test "delete_account/1 deletes the account" do
      account = account_fixture()
      assert {:ok, %Account{}} = UserAccount.delete_account(account)
      assert_raise Ecto.NoResultsError, fn -> UserAccount.get_account!(account.id) end
    end

    test "change_account/1 returns a account changeset" do
      account = account_fixture()
      assert %Ecto.Changeset{} = UserAccount.change_account(account)
    end
  end
end
