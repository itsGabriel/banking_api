defmodule BankingApi.UserAccount.Transfer do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :account_origin, :string
    field :account_destination, :string
    field :amount, :integer
  end

  def changeset(account, attrs) do
    account
    |> cast(attrs, [:account_origin, :account_destination, :amount])
    |> validate_required([:account_origin, :account_destination, :amount])
    |> validate_number(:amount, greater_than_or_equal_to: 0)
  end
end
