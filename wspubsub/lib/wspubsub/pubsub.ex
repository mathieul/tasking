defmodule Wspubsub.Pubsub do

  defmodule State do
    def blank, do: { _registered = [], _last_messages = []}

    def add_registered(state, pid) do
      { registered, last_messages } = state
      { [ pid | registered ], last_messages }
    end

    def del_registered(state, pid) do
      { registered, last_messages } = state
      { Enum.reject(registered, &1 == pid), last_messages }
    end

    def last_messages(state) do
      { _r, last_messages } = state
      last_messages
    end

    def registered(state) do
      { registered, _l } = state
      registered
    end

    def add_message(state, message) do
      { registered, last_messages } = state
      remaining = Enum.take(last_messages, 9)
      { registered, [message | remaining] }
    end
  end

  use GenServer.Behaviour

  #####
  # External API

  def start_link(_) do
    :gen_server.start_link({ :local, :pubsub }, __MODULE__, nil, [])
  end

  def register(pid, send_last // false), do: :gen_server.call(:pubsub, { :register, pid, send_last })
  def unregister(pid), do: :gen_server.call(:pubsub, { :unregister, pid })
  def publish(message), do: :gen_server.cast(:pubsub, { :publish, message })
  def last_messages, do: :gen_server.call(:pubsub, :last_messages)
  def register_list, do: :gen_server.call(:pubsub, :register_list)

  #####
  # GenServer implementation

  def init(_) do
    { :ok, State.blank }
  end

  def handle_call({ :register, pid, send_last }, _from, state) do
    if send_last do
      messages = Enum.reverse(State.last_messages(state))
      Enum.each messages, fn message ->
        pid <- { :pubsub_message, message }
      end
    end
    { :reply, :registered, State.add_registered(state, pid) }
  end

  def handle_call({ :unregister, pid }, _from, state) do
    { :reply, :unregistered, State.del_registered(state, pid) }
  end

  def handle_call(:last_messages, _from, state) do
    { :reply, State.last_messages(state), state }
  end

  def handle_call(:register_list, _from, state) do
    list = Enum.map(State.registered(state), inspect(&1))
    { :reply, list, state }
  end

  def handle_cast({ :publish, message }, state) do
    Enum.each State.registered(state), fn pid ->
      pid <- { :pubsub_message, message }
    end
    { :noreply, State.add_message(state, message) }
  end
end
