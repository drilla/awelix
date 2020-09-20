defmodule Awelix.Services.Packages.Package do
  @type t :: %__MODULE__{
          name: binary,
          desc: binary,
          category: binary,
          category_desc: binary,
          owner: binary,
          repo: binary,
          url: binary,
          stars: integer,
          last_commit_date: DateTime.t()
        }

  defstruct [:name, :desc, :category, :category_desc, :owner, :repo, :url, :stars, :last_commit_date]
end
