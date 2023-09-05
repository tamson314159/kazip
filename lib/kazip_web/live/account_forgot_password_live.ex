defmodule KazipWeb.AccountForgotPasswordLive do
  use KazipWeb, :live_view

  alias Kazip.Accounts

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        パスワードをお忘れですか？
        <:subtitle>受信トレイにパスワード再設定リンクをお送りします。</:subtitle>
      </.header>

      <.simple_form for={@form} id="reset_password_form" phx-submit="send_email">
        <.input field={@form[:email]} type="email" placeholder="メールアドレス" required />
        <:actions>
          <.button phx-disable-with="Sending..." class="w-full">
            パスワードのリセット方法を送信する
          </.button>
        </:actions>
      </.simple_form>
      <p class="text-center text-sm mt-4">
        <.link href={~p"/accounts/register"}>アカウント登録</.link>
        | <.link href={~p"/accounts/log_in"}>ログイン</.link>
      </p>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, form: to_form(%{}, as: "account"))}
  end

  def handle_event("send_email", %{"account" => %{"email" => email}}, socket) do
    if account = Accounts.get_account_by_email(email) do
      Accounts.deliver_account_reset_password_instructions(
        account,
        &url(~p"/accounts/reset_password/#{&1}")
      )
    end

    info =
      "メールアドレスが弊社システム内にあり、まだ確認されていない場合は、まもなくご案内メールをお送りいたします。"

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> redirect(to: ~p"/")}
  end
end
