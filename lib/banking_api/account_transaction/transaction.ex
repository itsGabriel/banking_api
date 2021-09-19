defmodule BankingApi.AccountTransaction.Transaction do
  use Ecto.Schema
  import Ecto.Changeset
  alias BankingApi.UserAccount.Account

  schema "transactions" do
    field :amount, :integer
    field :type, :string

    belongs_to :account_origin, Account,
      foreign_key: :account_origin_id,
      references: :id

    belongs_to :account_destination, Account,
      foreign_key: :account_destination_id,
      references: :id

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:account_destination_id, :account_origin_id, :amount, :type])
    |> validate_required([])
  end
end
