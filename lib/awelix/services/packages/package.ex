defmodule Awelix.Services.Packages.Package do
  @type t :: %__MODULE__{
          title: binary,
          desc: binary,
          category: binary,
          category_desc: binary,
          owner: binary,
          name: binary,
          branch: binary,
          url: binary,
          stars: integer,
          last_commit_date: DateTime.t()
        }

  defstruct [:title, :desc, :category, :category_desc, :owner, :name, :branch, :url, :stars, :last_commit_date]
end
