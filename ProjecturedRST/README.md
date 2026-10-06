# ProjecturedRST

reStructuredText as a tree of documents, with a parser and two presentations.

It is a package of [ProjecturEd](https://github.com/projectured/projectured-julia), a projectional editor:
the data is the source, and every view is computed from it.
[rst.md](https://github.com/projectured/projectured-julia/blob/main/documentation/package/domain/rst/rst.md)
says more.

## Install

The packages of ProjecturEd are in the registry
[`ProjecturedRegistry`](https://github.com/projectured/ProjecturedRegistry). Add
[General](https://github.com/JuliaRegistries/General) too, for the packages that they depend on. If
General is there already, the line does nothing.

```
pkg> registry add General
pkg> registry add https://github.com/projectured/ProjecturedRegistry
pkg> add ProjecturedRST
```

`using ProjecturedRST` loads it. [AutoIntegration](https://github.com/projectured/AutoIntegration.jl) also loads it by itself when `Projectured` is loaded, unless your environment sets it to `"manual"`.
[The front page](https://github.com/projectured/Projectured.jl) says how the packages install and load,
and [ProjecturEd in your own project](https://github.com/projectured/projectured-julia/blob/main/documentation/guide/own-project-guide.md)
says how to open a window from your code.

## Source and licence

The release of ProjecturEd writes this folder from
[projectured-julia](https://github.com/projectured/projectured-julia); a change belongs there. The licence is
the [Mozilla Public License 2.0](https://www.mozilla.org/en-US/MPL/2.0/), in [`LICENSE`](LICENSE).
