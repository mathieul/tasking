defmodule Wspubsub.Pubsub do
  defrecord Session, registrees: [], messages: [] do
    def add_registree(pid, session) do
      session.registrees([ pid | session.registrees ])
    end

    def del_registree(pid, session) do
      registrees = Enum.reject(session.registrees, &(&1 == pid))
      if length(registrees) == 0 do
        Session.new
      else
        session.registrees(registrees)
      end
    end

    def add_message(message, session) do
      remaining = Enum.take(session.messages, 9)
      session.messages([ message | remaining ])
    end
  end

  defmodule State do
    def blank, do: HashDict.new

    def add_registered(state, pid, sid) do
      session = fetch_session(state, sid)
      update_session(state, sid, session.add_registree(pid))
    end

    def del_registered(state, pid, sid) do
      session = fetch_session(state, sid)
      update_session(state, sid, session.del_registree(pid))
    end

    def add_message(state, message, sid) do
      session = fetch_session(state, sid)
      update_session(state, sid, session.add_message(message))
    end

    def last_messages(state, sid) do
      fetch_session(state, sid).messages
    end

    def fetch_session(state, sid) do
      case Dict.fetch(state, sid) do
        { :ok, session } -> session
        :error -> Session.new
      end
    end

    def session_ids(state) do
      Dict.keys(state)
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
  def register(sid, pid, send_messages // false) do
    :gen_server.call(:pubsub, { :register, sid, pid, send_messages })
  end
  def unregister(sid, pid), do: :gen_server.call(:pubsub, { :unregister, sid, pid })
  def session_ids, do: :gen_server.call(:pubsub, :session_ids)
  def publish(sid, message), do: :gen_server.cast(:pubsub, { :publish, sid, message })
  def register_list(sid), do: :gen_server.call(:pubsub, { :register_list, sid })
  def last_messages(sid), do: :gen_server.call(:pubsub, { :last_messages, sid })

  #####
  # GenServer implementation

  def init(_) do
    { :ok, State.blank }
  end

  def handle_cast(:clear_all, _state) do
    { :noreply, State.blank }
  end

  def handle_call({ :register, sid, pid, send_messages }, _from, state) do
    if send_messages do
      messages = Enum.reverse(State.last_messages(state, sid))
      Enum.each messages, fn message ->
        pid <- { :pubsub_message, message }
      end
    end
    { :reply, :registered, State.add_registered(state, pid, sid) }
  end

  def handle_call({ :unregister, sid, pid }, _from, state) do
    { :reply, :unregistered, State.del_registered(state, pid, sid) }
  end

  def handle_call(:session_ids, _from, state) do
    { :reply, State.session_ids(state) , state }
  end

  def handle_call({ :last_messages, sid }, _from, state) do
    { :reply, State.last_messages(state, sid), state }
  end

  def handle_call({ :register_list, sid }, _from, state) do
    session = State.fetch_session(state, sid)
    list = Enum.map(session.registrees, inspect(&1))
    { :reply, list, state }
  end

  def handle_cast({ :publish, sid, message }, state) do
    session = State.fetch_session(state, sid)
    Enum.each session.registrees, fn pid ->
      pid <- { :pubsub_message, message }
    end
    { :noreply, State.add_message(state, message, sid) }
  end
end
