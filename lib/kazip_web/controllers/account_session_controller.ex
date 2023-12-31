defmodule KazipWeb.AccountSessionController do
  use KazipWeb, :controller

  alias Kazip.Accounts
  alias KazipWeb.AccountAuth

  def create(conn, %{"_action" => "registered"} = params) do
    create(conn, params, "アカウントは正常に作成されました。")
  end

  def create(conn, %{"_action" => "password_updated"} = params) do
    conn
    |> put_session(:account_return_to, ~p"/accounts/settings")
    |> create(params, "パスワードは正常に更新されました。")
  end

  def create(conn, params) do
    create(conn, params, "お帰りなさい！")
  end

  defp create(conn, %{"account" => account_params}, info) do
    %{"email" => email, "password" => password} = account_params

    if account = Accounts.get_account_by_email_and_password(email, password) do
      conn
      |> put_flash(:info, info)
      |> AccountAuth.log_in_account(account, account_params)
    else
      # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
      conn
      |> put_flash(:error, "Invalid email or password")
      |> put_flash(:email, String.slice(email, 0, 160))
      |> redirect(to: ~p"/accounts/log_in")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "正常にログアウトしました。")
    |> AccountAuth.log_out_account()
  end
end
