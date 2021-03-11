defmodule HbCustomToolchain.MixProject do
  use Mix.Project

  @app :hb_custom_toolchain
  @version Path.join(__DIR__, "VERSION")
           |> File.read!()
           |> String.trim()

  def project do
    [
      app: @app,
      version: @version,
      elixir: "~> 1.6",
      compilers: [:nerves_package | Mix.compilers()],
      nerves_package: nerves_package(),
      description: description(),
      package: package(),
      deps: deps(),
      aliases: [loadconfig: [&bootstrap/1]]
    ]
  end

  def application do
    []
  end

  defp bootstrap(args) do
    set_target()
    Application.start(:nerves_bootstrap)
    Mix.Task.run("loadconfig", args)
  end

  defp nerves_package do
    [
      type: :toolchain,
      platform: Nerves.Toolchain.CTNG,
      platform_config: [
        defconfig: "defconfig"
      ],
      target_tuple: :armv7_nerves_linux_gnueabihf,
      artifact_sites: [
        {:github_releases, "westartwithlove/hb_custom_toolchain"}
      ],
      checksum: package_files()
    ]
  end

  defp deps do
    [
      {:nerves, "~> 1.7.3", runtime: false},
      {:nerves_toolchain_ctng, "~> 1.8.1", runtime: false}
    ]
  end

  defp description do
    """
    Nerves Toolchain - hb_custom_toolchain
    """
  end

  defp package do
    [
      files: package_files(),
      licenses: ["Apache 2.0"],
      links: %{
        "Github" => "https://github.com/westartwithlove/hb_custom_toolchain"
      }
    ]
  end

  defp package_files do
    [
      "mingw32_x86_64_defconfig",
      "defconfig",
      "README.md",
      "LICENSE",
      "mix.exs",
      "VERSION"
    ]
  end

  defp set_target() do
    if function_exported?(Mix, :target, 1) do
      apply(Mix, :target, [:target])
    else
      System.put_env("MIX_TARGET", "target")
    end
  end
end
