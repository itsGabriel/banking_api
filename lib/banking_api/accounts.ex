defmodule BankingApi.Accounts do
  @moduledoc """
  The Accounts context.
  """
  import Ecto.Query, warn: false
  alias BankingApi.Repo

  alias BankingApi.Accounts.User
  alias BankingApi.UserAccount.Account
  alias BankingApi.UserAccount

  alias Ecto.Multi

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id) do
    {:ok, Repo.get!(User, id)}
  rescue
    Ecto.NoResultsError -> {:error, "Account not found"}
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    code = UserAccount.generate_account_code()
    Multi.new()
    |> Multi.insert(:create_user, User.changeset(%User{}, attrs))
    |> Multi.run(:create_account, fn repo, %{create_user: user} ->
      %Account{}
      |> Account.changeset(%{user_id: user.id, code: code, balance: 1000 * 100})
      |> repo.insert()
    end)
    |> Multi.run(:preload, fn repo, %{create_user: user} ->
      {:ok, repo.preload(user, :accounts)}
    end)
    |> BankingApi.Repo.transaction()
    |> case do
      {:ok, %{create_user: user, create_account: account}} -> {:ok, user, account}
      {:error, changeset} -> {:error, changeset}
      {:error, _name, changeset, _value} -> {:error, changeset}
    end
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  @spec auth_user(map) ::
          {:error, :invalid_credentials}
          | {:ok, atom | %{:password => binary, optional(any) => any}}
  def auth_user(%{"email" => email, "password" => password}) do
    case Repo.get_by(User, email: email) do
      nil ->
        Bcrypt.no_user_verify()
        {:error, :invalid_credentials}

      user ->
        if Bcrypt.verify_pass(password, user.password) do
          {:ok, user}
        else
          {:error, :invalid_credentials}
        end
    end
  end
end
