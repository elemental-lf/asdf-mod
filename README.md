<div align="center">

# asdf-mod [![Build](https://github.com/elemental-lf/asdf-mod/actions/workflows/build.yml/badge.svg)](https://github.com/elemental-lf/asdf-mod/actions/workflows/build.yml) [![Lint](https://github.com/elemental-lf/asdf-mod/actions/workflows/lint.yml/badge.svg)](https://github.com/elemental-lf/asdf-mod/actions/workflows/lint.yml)

[mod](https://github.com/variantdev/mod/blob/master/README.md) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

**TODO: adapt this section**

- `bash`, `curl`, `tar`, and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).
- `SOME_ENV_VAR`: set this environment variable in your shell config to load the correct version of tool x.

# Install

Plugin:

```shell
asdf plugin add mod
# or
asdf plugin add mod https://github.com/elemental-lf/asdf-mod.git
```

mod:

```shell
# Show all installable versions
asdf list-all mod

# Install specific version
asdf install mod latest

# Set a version globally (on your ~/.tool-versions file)
asdf global mod latest

# Now mod commands are available
mod help
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/elemental-lf/asdf-mod/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Lars Fenneberg](https://github.com/elemental-lf/)
