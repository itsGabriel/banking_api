defmodule BankingApi.Guardian.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :banking_api,
    error_handler: BankingApi.Guardian.ErrorHandler,
    module: BankingApi.Guardian

  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}

  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}

  plug Guardian.Plug.LoadResource, allow_blank: true
end
