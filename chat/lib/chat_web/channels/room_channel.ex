defmodule ChatWeb.RoomChannel do
  use ChatWeb, :channel

  # Função chamada quando o usuário tenta entrar na sala.
  # O usuário apenas entra se ele tiver autorização ( no
  # caso, o usuário sempre tem autorização
  def join("room:lobby", payload, socket) do
    if authorized?(payload) do
      send(self(), :after_join)
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # Função chamada quando o usuário envia uma mensagem
  # para o chat da sala. "Shout" é um parÂmetro indicador
  # de que todos os usuários na sala podem visualizar a
  # mensagem.
  @impl true
  def handle_in("shout", payload, socket) do
    Chat.Message.changeset(%Chat.Message{}, payload) |> Chat.Repo.insert
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end

  defp authorized?(_payload) do
    true
  end

  # Função chamada quando o usuário entra no chat.
  # O objetivo dela é organizar as últimas mensagens
  # que sejam visíveis para o usuário e mandar para ele
  @impl true
  def handle_info(:after_join, socket) do
    Chat.Message.get_messages()
    |> Enum.reverse()
    |> Enum.each(fn msg -> push(socket, "shout", %{
        name: msg.name,
        message: msg.message,
        inserted_at: msg.inserted_at,
      }) end)
    {:noreply, socket}
  end



end
