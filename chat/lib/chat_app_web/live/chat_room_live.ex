defmodule ChatAppWeb.ChatRoomLive do
  use Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok, assign(socket, current_user: socket.assigns.current_user)}
  end
  def render(assigns) do
    ~L"""
    <div>
      <h1>Welcome to the Chat Room, <%= @current_user.username %></h1>
      <div id="chat-box">
        <%= for message <- @messages do %>
          <p><strong><%= message["username"] %>:</strong> <%= message["content"] %></p>
        <% end %>
      </div>
      <form phx-submit="new_message" phx-change="disableButton">
        <input type="text" name="content" placeholder="Type your message here..." />
        <button id="send-button" disabled="disabled">Send</button>
      </form>
    </div>
    """
  end

  defp message(%{"username" => username, "content" => content}) do
    %{"username" => username, "content" => content}
  end

def handle_event("new_message", %{"content" => content}, socket) do
  new_message = %{
    "username" => socket.assigns.current_user.username,
    "content" => content
  }

  ChatAppWeb.Endpoint.broadcast("chat_room:lobby", "new_message", new_message)

  {:noreply, assign(socket, messages: [new_message | socket.assigns.messages])}
end


end
