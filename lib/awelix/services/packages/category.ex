defmodule Awelix.Services.Packages.Category do
  @type t :: %__MODULE__{
          name: binary,
          items: list
        }

  defstruct [:name, :items]
end
