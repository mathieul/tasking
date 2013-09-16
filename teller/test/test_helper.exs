Dynamo.under_test(Teller.Dynamo)
Dynamo.Loader.enable
ExUnit.start

defmodule Teller.TestCase do
  use ExUnit.CaseTemplate

  # Enable code reloading on test cases
  setup do
    Dynamo.Loader.enable
    :ok
  end
end
