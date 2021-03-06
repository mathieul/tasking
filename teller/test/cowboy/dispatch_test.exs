Code.require_file "../test_helper.exs", __DIR__

defmodule Teller.Cowboy.DispatchTest do
  use ExUnit.Case, async: true

  defmodule NoRoutes do
    use Teller.Cowboy.Dispatch
  end

  test "no routes defaults to the application router" do
    assert NoRoutes.dispatch == [{ :_, [{ :_, Dynamo.Cowboy.Handler, ApplicationRouter }] }]
  end

  defmodule Handler1 do; end
  defmodule Handler2 do; end
  defmodule TwoRoutes do
    use Teller.Cowboy.Dispatch
    match "/one", to: Handler1
    match "/two", to: Handler2
  end

  test "#match inserts a dispatch route" do
    assert TwoRoutes.dispatch == [{ :_, [
      { "/one", Handler1, [] },
      { "/two", Handler2, [] },
      { :_, Dynamo.Cowboy.Handler, ApplicationRouter }
    ] }]
  end

  defmodule RootRoute do
    use Teller.Cowboy.Dispatch
    root to: Handler1
  end

  test "#root inserts a dispatch route to '/'" do
    assert RootRoute.dispatch == [{ :_, [
      { "/", Handler1, [] },
      { :_, Dynamo.Cowboy.Handler, ApplicationRouter }
    ] }]
  end

  defmodule IntConstraintRoute do
    use Teller.Cowboy.Dispatch
    match "/:version", to: Handler1, constraints: [ version: :int ]
  end

  test "#match with an 'int' constraint" do
    assert IntConstraintRoute.dispatch == [{ :_, [
      { "/:version", [ { :version, :int } ], Handler1, [] },
      { :_, Dynamo.Cowboy.Handler, ApplicationRouter }
    ] }]
  end

  defmodule FunConstraintRoute do
    use Teller.Cowboy.Dispatch
    match "/:name", to: Handler1, constraints: [ name: &__MODULE__.fun_test/1 ]
    def fun_test(_value), do: true
  end

  test "#match with a 'function' constraint" do
    assert FunConstraintRoute.dispatch == [{ :_, [
      { "/:name", [ { :name, &FunConstraintRoute.fun_test/1 } ], Handler1, [] },
      { :_, Dynamo.Cowboy.Handler, ApplicationRouter }
    ] }]
  end

  defmodule DefaultRoute do
    use Teller.Cowboy.Dispatch
    default to: Handler2, with: OtherRouter
  end

  test "use a different default handler" do
    assert DefaultRoute.dispatch == [{ :_, [{ :_, Handler2, OtherRouter }] }]
  end
end
