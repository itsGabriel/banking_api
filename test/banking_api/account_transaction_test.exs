defmodule BankingApi.AccountTransactionTest do
  use BankingApi.DataCase

  alias BankingApi.Accounts.User
  alias BankingApi.Accounts
  alias BankingApi.UserAccount
  alias BankingApi.UserAccount.{Account, Withdraw, Transfer}

  describe "transactions" do
    @usr_attrs %{email: "testmail.com", password: "some password", username: "some username"}
    @usr2_attrs %{email: "testmail2.com", password: "some password", username: "some username"}

    setup do
      {:ok, %User{} = user1, %Account{} = account1} = Accounts.create_user(@usr_attrs)

      {:ok, %User{} = user2, %Account{} = account2} = Accounts.create_user(@usr2_attrs)

      {:ok,
       accounts: %{account1: account1.code, account2: account2.code},
       users: %{user1: user1.id, user2: user2.id}}
    end

    test "user withdraw with valid data", state do
      %{user1: user1} = state[:users]
      %{account1: account1} = state[:accounts]

      data = %{account: account1, amount: 1000}

      changeset = Withdraw.changeset(%Withdraw{}, data)

      assert {:ok, %Account{}} = UserAccount.withdraw(user1, changeset)
    end

    test "user withdraw with invalid balance returns error changeset", state do
      %{user1: user1} = state[:users]
      %{account1: account1} = state[:accounts]

      data = %{account: account1, amount: 100_000_000}

      changeset = Withdraw.changeset(%Withdraw{}, data)

      assert {:error, %Ecto.Changeset{}} = UserAccount.withdraw(user1, changeset)
    end

    test "user transfer balance to valid account code", state do
      %{user1: user1} = state[:users]
      %{account1: account1, account2: account2} = state[:accounts]

      data = %{account_origin: account1, account_destination: account2, amount: 2000}

      changeset = Transfer.changeset(%Transfer{}, data)

      assert {:ok, %Account{}} = UserAccount.transfer(user1, changeset)
    end

    test "user transfer balance with the same account code return error", state do
      %{user1: user1} = state[:users]
      %{account1: account1} = state[:accounts]
      data = %{account_origin: account1, account_destination: account1, amount: 2000}

      changeset = Transfer.changeset(%Transfer{}, data)

      assert {:error, msg} = UserAccount.transfer(user1, changeset)
    end

    test "user transfer invadili balance returns error changeset", state do
      %{user1: user1} = state[:users]
      %{account1: account1, account2: account2} = state[:accounts]

      data = %{account_origin: account1, account_destination: account2, amount: 100_000_000}

      changeset = Transfer.changeset(%Transfer{}, data)

      assert {:error, %Ecto.Changeset{}} = UserAccount.transfer(user1, changeset)
    end
  end
end
