# Homebrew Packages

This directory tracks the packages that are intentionally installed through
Homebrew as part of a new-machine setup.

## Install Modes

- `Brewfile`: the default baseline. Keep this list small and focused on tools
  that are broadly useful on a fresh machine.
- `Brewfile.extra`: optional packages for specialized workflows that are not
  required on every machine.

The bootstrap scripts install `Brewfile` by default. To also install the
optional package set, run:

```sh
DOTFILES_INSTALL_EXTRAS=1 script/bootstrap
```

## Package Groups

The Brewfiles use lightweight comments to group formulas by purpose.

- Infrastructure and CLI tools: direct tools used from the shell, cloud, or
  infra workflows.
- Language and build support: compilers, interpreters, and libraries commonly
  needed to build runtimes or native extensions.
- Media and image tooling: codecs, transcoders, OCR, and related libraries.
- Scientific and computer-vision tooling: linear algebra, data formats,
  visualization, and vision stacks.
- GUI and rendering support: Qt, OpenGL, fonts, and rendering libraries.
- Networking and crypto support: TLS, HTTP, DNS, and transport libraries.
- Low-level libraries: compression, parsing, and support libraries that are
  only worth keeping if they still support an active workflow.

## How To Decide What Stays

- Keep packages that are top-level tools you run directly.
- Keep packages that are required to build a runtime you still use, such as
  Ruby or Python with native extensions.
- Move workflow-specific packages to `Brewfile.extra`.
- Remove packages if you no longer recognize the workflow they support and no
  current tool depends on them.

Examples:

- If you no longer do Kubernetes work, remove any related tooling that appears
  in the Brewfiles, such as `helm` or `kubectl`.
- If you no longer do video transcoding, review `ffmpeg`, `handbrake`, and the
  codec libraries around them.
- If you no longer do computer-vision or scientific work, review `opencv`,
  `vtk`, `hdf5`, `netcdf`, and related math libraries.

## Maintenance Rule

When adding a package:

- Prefer adding the top-level tool you intentionally use instead of listing
  every dependency by hand.
- Place it under the closest matching group comment.
- Add or update this README if a new workflow category appears.

When removing a workflow:

- Remove the obvious top-level packages first.
- Then review adjacent support libraries in the same group before keeping them.
