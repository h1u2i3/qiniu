defmodule Qiniu.Mixfile do
  use Mix.Project

  @version "0.4.0"

  def project do
    [app: :qiniu,
     version: @version,
     elixir: "~> 1.2",
     deps: deps(),
     test_coverage: [tool: ExCoveralls],
     preferred_cli_env: preferred_cli_env(),

     # Hex
     description: description(),
     package: package()
    ]
  end

  def application do
    [applications: [:logger, :httpoison]]
  end

  defp deps do
    [{:jason, "~> 1.1"},
     {:httpoison, "~> 1.5"},
     {:ex_doc, "~> 0.19.3", only: :docs},
     {:excoveralls, "~> 0.10.6", only: :test},
     {:earmark, "~> 1.3", only: :docs},
     {:inch_ex, "~> 2.0", only: :docs},
     {:mock, "~> 0.3.3", only: :test}
    ]
  end

  defp description do
    "Qiniu Resource (Cloud) Storage SDK for Elixir"
  end

  defp package do
    [maintainers: ["Tony Han"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/tony612/qiniu"},
     files: ~w(mix.exs README.md CHANGELOG.md lib config)]
  end

  defp preferred_cli_env do
    [coveralls: :test, "coveralls.travis": :test, "coveralls.html": :test]
  end

end
