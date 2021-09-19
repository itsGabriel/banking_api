defmodule BankingApi.UserAccount do
  @moduledoc """
  The UserAccount context.
  """

  import Ecto.Query, warn: false
  alias BankingApi.Repo

  alias BankingApi.UserAccount
  alias BankingApi.UserAccount.Account
  alias BankingApi.AccountTransaction
  alias Ecto.Multi

  @doc """
  Returns the list of accounts.

  ## Examples

      iex> list_accounts()
      [%Account{}, ...]

  """
  def list_accounts do
    Repo.all(Account)
  end

  @doc """
  Gets a single account.

  Raises `Ecto.NoResultsError` if the Account does not exist.

  ## Examples

      iex> get_account!(123)
      %Account{}

      iex> get_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_account!(id), do: Repo.get!(Account, id)

  def get_account_code!(code) do
    {:ok, Repo.get_by!(Account, code: code)}
  rescue
    Ecto.NoResultsError -> {:error, "Account not found"}
  end

  def get_account_by_user(user_id, code) do
    {:ok, Repo.get_by!(Account, user_id: user_id, code: code)}
  rescue
    Ecto.NoResultsError -> {:error, "Account not found"}
  end

  @doc """
  Creates a account.

  ## Examples

      iex> create_account(%{field: value})
      {:ok, %Account{}}

      iex> create_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_account(attrs \\ %{}) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a account.

  ## Examples

      iex> update_account(account, %{field: new_value})
      {:ok, %Account{}}

      iex> update_account(account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_account(%Account{} = account, attrs) do
    account
    |> Account.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a account.

  ## Examples

      iex> delete_account(account)
      {:ok, %Account{}}

      iex> delete_account(account)
      {:error, %Ecto.Changeset{}}

  """
  def delete_account(%Account{} = account) do
    Repo.delete(account)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking account changes.

  ## Examples

      iex> change_account(account)
      %Ecto.Changeset{data: %Account{}}

  """
  def change_account(%Account{} = account, attrs \\ %{}) do
    Account.changeset(account, attrs)
  end

  @spec withdraw(any, Ecto.Changeset.t()) :: {:error, any} | {:ok, any}
  def withdraw(user, params) do
    params = Ecto.Changeset.apply_changes(params)

    Multi.new()
    |> Multi.run(:user_origin, fn _repo, _changes ->
      UserAccount.get_account_by_user(user, params.account)
    end)
    |> Multi.run(:withdraw, fn repo, %{user_origin: account} ->
      account
      |> Account.changeset(%{balance: account.balance - params.amount})
      |> repo.update()
    end)
    |> Multi.run(
      :transaction,
      fn _repo,
         %{
           user_origin: user_origin
         } ->
        UserAccount.create_transaction(
          params.amount,
          user_origin.id,
          nil,
          "withdraw"
        )
      end
    )
    |> BankingApi.Repo.transaction()
    |> case do
      {:ok, %{withdraw: widraw}} -> {:ok, widraw}
      {:error, _name, changeset, _value} -> {:error, changeset}
      {:error, msg} -> {:error, msg}
    end
  end

  def transfer(user, params) do
    params = Ecto.Changeset.apply_changes(params)

    if params.account_origin != params.account_destination do
      Multi.new()
      |> Multi.run(:user_origin, fn _repo, _changes ->
        UserAccount.get_account_by_user(user, params.account_origin)
      end)
      |> Multi.run(:user_destination, fn _repo, _changes ->
        UserAccount.get_account_code!(params.account_destination)
      end)
      |> Multi.run(:withdraw, fn repo, %{user_origin: account} ->
        account
        |> Account.changeset(%{balance: account.balance - params.amount})
        |> repo.update()
      end)
      |> Multi.run(:transfer, fn repo, %{user_destination: user_destination} ->
        user_destination
        |> Account.changeset(%{balance: user_destination.balance + params.amount})
        |> repo.update()
      end)
      |> Multi.run(
        :transaction,
        fn _repo,
           %{
             user_origin: user_origin,
             user_destination: user_destination
           } ->
          UserAccount.create_transaction(
            params.amount,
            user_origin.id,
            user_destination.id,
            "transfer"
          )
        end
      )
      |> BankingApi.Repo.transaction()
      |> case do
        {:ok, %{withdraw: widraw}} -> {:ok, widraw}
        {:error, _name, changeset, _value} -> {:error, changeset}
        {:error, msg} -> {:error, msg}
      end
    else
      {:error, "The origin account code and destination can't be the same"}
    end
  end

  def create_transaction(amount, account_origin, account_destination, type) do
    AccountTransaction.create_transaction(%{
      amount: amount,
      account_origin_id: account_origin,
      type: type,
      account_destination_id: account_destination
    })
  end
end
