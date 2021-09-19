defmodule BankingApi.AccountTransactionTest do
  use BankingApi.DataCase

  alias BankingApi.AccountTransaction

  describe "transactions" do
    alias BankingApi.AccountTransaction.Transaction

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def transaction_fixture(attrs \\ %{}) do
      {:ok, transaction} =
        attrs
        |> Enum.into(@valid_attrs)
        |> AccountTransaction.create_transaction()

      transaction
    end

    test "list_transactions/0 returns all transactions" do
      transaction = transaction_fixture()
      assert AccountTransaction.list_transactions() == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id" do
      transaction = transaction_fixture()
      assert AccountTransaction.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction" do
      assert {:ok, %Transaction{} = transaction} = AccountTransaction.create_transaction(@valid_attrs)
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = AccountTransaction.create_transaction(@invalid_attrs)
    end

    test "update_transaction/2 with valid data updates the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{} = transaction} = AccountTransaction.update_transaction(transaction, @update_attrs)
    end

    test "update_transaction/2 with invalid data returns error changeset" do
      transaction = transaction_fixture()
      assert {:error, %Ecto.Changeset{}} = AccountTransaction.update_transaction(transaction, @invalid_attrs)
      assert transaction == AccountTransaction.get_transaction!(transaction.id)
    end

    test "delete_transaction/1 deletes the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{}} = AccountTransaction.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> AccountTransaction.get_transaction!(transaction.id) end
    end

    test "change_transaction/1 returns a transaction changeset" do
      transaction = transaction_fixture()
      assert %Ecto.Changeset{} = AccountTransaction.change_transaction(transaction)
    end
  end
end
