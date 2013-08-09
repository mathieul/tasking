defmodule Wspubsub.Pubsub do

  defmodule State do
    def blank, do: { _sessions = HashDict.new, _last_messages = []}

    def add_registered(state, pid, sid) do
      { sessions, last_messages } = state
      session = fetch_session(sessions, sid)
      { update_session(sessions, sid, [ pid | session ]), last_messages }
    end

    def del_registered(state, pid, sid) do
      { sessions, last_messages } = state
      session = fetch_session(sessions, sid)
      session = Enum.reject(session, &(&1 == pid))
      { session, last_messages }
    end

    # def last_messages(state) do
    #   { _r, last_messages } = state
    #   last_messages
    # end

    def session(state, sid) do
      fetch_session(sessions(state), sid)
    end

    def sessions(state) do
      { sessions, _l } = state
      sessions
    end

    def session_ids(state) do
      Dict.keys(sessions(state))
    end    

    def add_message(state, message) do
      { sessions, last_messages } = state
      remaining = Enum.take(last_messages, 9)
      { sessions, [message | remaining] }
    end

    defp fetch_session(sessions, sid) do
      case Dict.fetch(sessions, sid) do
        { :ok, session } -> session
        :error -> []
      end
    end

    defp update_session(sessions, sid, session), do: Dict.put(sessions, sid, session)
  end

  use GenServer.Behaviour

  #####
  # External API

  def start_link(_) do
    :gen_server.start_link({ :local, :pubsub }, __MODULE__, nil, [])
  end

  def clear_all, do: :gen_server.cast(:pubsub, :clear_all)
  def register(pid, sid, send_last // false) do
    :gen_server.call(:pubsub, { :register, pid, sid, send_last })
  end
  def unregister(pid, sid), do: :gen_server.call(:pubsub, { :unregister, pid, sid })
  def session_ids, do: :gen_server.call(:pubsub, :session_ids)
  def publish(message, sid), do: :gen_server.cast(:pubsub, { :publish, message, sid })
  # def last_messages, do: :gen_server.call(:pubsub, :last_messages)
  def register_list(sid), do: :gen_server.call(:pubsub, { :register_list, sid })

  #####
  # GenServer implementation

  def init(_) do
    { :ok, State.blank }
  end

  def handle_cast(:clear_all, state) do
    { :noreply, State.blank }
  end

  def handle_call({ :register, pid, sid, send_last }, _from, state) do
    if send_last do
      messages = Enum.reverse(State.last_messages(state))
      Enum.each messages, fn message ->
        pid <- { :pubsub_message, message }
      end
    end
    { :reply, :registered, State.add_registered(state, pid, sid) }
  end

  def handle_call({ :unregister, pid, sid }, _from, state) do
    { :reply, :unregistered, State.del_registered(state, pid, sid) }
  end

  def handle_call(:session_ids, _from, state) do
    { :reply, State.session_ids(state) , state }
  end

  # def handle_call(:last_messages, _from, state) do
  #   { :reply, State.last_messages(state), state }
  # end

  def handle_call({ :register_list, sid }, _from, state) do
    list = Enum.map(State.session(state, sid), inspect(&1))
    { :reply, list, state }
  end

  def handle_cast({ :publish, message, sid }, state) do
    Enum.each State.session(state, sid), fn pid ->
      pid <- { :pubsub_message, message }
    end
    { :noreply, State.add_message(state, message) }
  end
end
