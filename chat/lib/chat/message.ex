defmodule Chat.Message do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  # cria um schema da mensagem para o banco de dados
  schema "messages" do
    field :message, :string
    field :name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:name, :message])
    |> validate_required([:name, :message])
  end

  # função chamada quando o usuário loga no chat.
  # Perceba que retornamos no máximo as últimas 20
  # mensagens.
  def get_messages(limit \\ 20) do
    Chat.Message
    |> limit(^limit)
    |> order_by(desc: :inserted_at)
    |> Chat.Repo.all()
  end

end
