defmodule KazipWeb.AccountLoginLive do
  use KazipWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        アカウントにログイン
        <:subtitle>
          アカウントをお持ちでないですか？今すぐ
          <.link navigate={~p"/accounts/register"} class="font-semibold text-sky-600 hover:underline">
            アカウント登録
          </.link>
          できます。
        </:subtitle>
      </.header>

      <.simple_form for={@form} id="login_form" action={~p"/accounts/log_in"} phx-update="ignore">
        <.input field={@form[:email]} type="email" label="メールアドレス" required />
        <.input field={@form[:password]} type="password" label="パスワード" required />

        <:actions>
          <.input field={@form[:remember_me]} type="checkbox" label="ログインしたままにする" />
          <.link href={~p"/accounts/reset_password"} class="text-sm font-semibold">
            パスワードを忘れた場合
          </.link>
        </:actions>
        <:actions>
          <.button phx-disable-with="Signing in..." class="w-full">
            ログインする <span aria-hidden="true">→</span>
          </.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    email = live_flash(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "account")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end
end
