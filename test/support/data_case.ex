defmodule Checkboxed.DataCase do
  @moduledoc """
  This module defines the setup for tests.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      import Checkboxed.DataCase
    end
  end

  setup _tags do
    :ok
  end
end
