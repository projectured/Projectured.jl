# Projectured.jl

The released packages of [ProjecturEd](https://github.com/projectured/projectured-julia), a projectional
editor: the data is the source, and every view is computed from it. Each folder
is one package. The release of ProjecturEd writes this repository from
[projectured-julia](https://github.com/projectured/projectured-julia), so a change belongs there.

## Install

The packages are in the registry [`ProjecturedRegistry`](https://github.com/projectured/ProjecturedRegistry).
Add [General](https://github.com/JuliaRegistries/General) too, for the packages that they depend on.
If General is there already, the line does nothing.

```
pkg> registry add General
pkg> registry add https://github.com/projectured/ProjecturedRegistry
```

Each package installs only what it needs. Add each package that you use by its
name. A `using` line reaches only the packages that you added, so add the
packages of other authors that you load too.

## Use

To install and to load are two different steps. You can load in two ways.

### Let `Projectured` load the integrations

```
pkg> add Projectured ProjecturedSDL ProjecturedDataFrames DataFrames SimpleDirectMediaLayer

julia> using Projectured, DataFrames, SimpleDirectMediaLayer
julia> display_in_editor(DataFrame(n = 1:100_000, square = (1:100_000) .^ 2))
```

> The first `display_in_editor` of a session can take a long time before the
> window opens. Julia compiles the code of the editor the first time that it
> runs. The next calls in the same session do not compile it again, so the
> window opens fast.

`using Projectured` loads [the kernel](ProjecturedKernel),
[the platform](ProjecturedPlatform) and [AutoIntegration](https://github.com/projectured/AutoIntegration.jl).
AutoIntegration loads a package that you installed when all its triggers are
loaded. The order of the `using` lines does not matter. Each domain, the
console, PDF and the model adapters load when `Projectured` is loaded. An
integration loads when the package that it joins is loaded too:

| Integration | It joins | It loads when these are loaded |
| --- | --- | --- |
| [`ProjecturedDataFrames`](ProjecturedDataFrames) | [DataFrames](https://github.com/JuliaData/DataFrames.jl) | Projectured and DataFrames |
| [`ProjecturedMCP`](ProjecturedMCP) | [ModelContextProtocol](https://github.com/JuliaSMLM/ModelContextProtocol.jl) | Projectured and ModelContextProtocol |
| [`ProjecturedODBC`](ProjecturedODBC) | [ODBC](https://github.com/JuliaDatabases/ODBC.jl) | Projectured and ODBC |
| [`ProjecturedSDL`](ProjecturedSDL) | [SimpleDirectMediaLayer](https://github.com/JuliaMultimedia/SimpleDirectMediaLayer.jl) | Projectured and SimpleDirectMediaLayer |
| [`ProjecturedTulip`](ProjecturedTulip) | [Tulip](https://github.com/ds4dm/Tulip.jl) | Projectured and Tulip |
| [`ProjecturedVideo`](ProjecturedVideo) | [FFMPEG](https://github.com/JuliaIO/FFMPEG.jl) | Projectured and FFMPEG |

A package that loads in this way puts no name into `Main`. To write
`SdlBackend()`, add `using ProjecturedSDL`.

### Name each package

```
pkg> add ProjecturedSDL ProjecturedDataFrames DataFrames

julia> using DataFrames, ProjecturedSDL, ProjecturedDataFrames
julia> display_in_editor(DataFrame(n = 1:100_000, square = (1:100_000) .^ 2))
```

The session loads the packages that you name and the packages that they depend
on. Nothing else loads. `ProjecturedDataFrames` brings DataFrames as its own
dependency, but a `using` line reaches only a package that you added by name,
so the `add` line names DataFrames too: without it, `using DataFrames` fails
with "Package DataFrames not found in current path".

### Choose for each package

Each package says if it loads by itself. You can change it for each package in
the file `LocalPreferences.toml` beside the `Project.toml` of your environment:

```toml
[AutoIntegration]
ProjecturedSDL = "auto"
ProjecturedDataFrames = "manual"
```

`"auto"` loads the package when its triggers are loaded. `"manual"` loads it
only when you name it. A package with no line keeps its own default. This call
writes the same line, after you add AutoIntegration by name:

```
pkg> add AutoIntegration

julia> using AutoIntegration
julia> set_auto_integration!("ProjecturedDataFrames", :manual)
```

### Load all integrations

```
pkg> add ProjecturedIntegrations DataFrames SimpleDirectMediaLayer

julia> using ProjecturedIntegrations, DataFrames, SimpleDirectMediaLayer
```

[`ProjecturedIntegrations`](ProjecturedIntegrations) installs every integration and every package that
they join. It loads an integration when the package that it joins is loaded,
whatever `LocalPreferences.toml` says. Use it when you want all of them and do
not want to choose.

### Why there are so many packages

ProjecturEd joins many packages of other authors, and each join is one small
package. Pkg installs all dependencies of a package and has no optional ones.
So each integration is its own package, and you install only the ones that you
add. Some users want the integrations to load by themselves, and some users
name each package. The setting for each package lets you choose.

## Faster sessions

A Julia session compiles the code that it runs, and it keeps that code only
until it ends. So each new session that shows a data frame compiles the editor
again. [AutoPrecompile](https://github.com/projectured/AutoPrecompile.jl) keeps that code for the next session:

```
pkg> add AutoPrecompile

julia> using AutoPrecompile, Projectured, DataFrames, SimpleDirectMediaLayer
julia> display_in_editor(DataFrame(n = 1:100_000, square = (1:100_000) .^ 2))
```

Each package of ProjecturEd ships the precompile statements that its
recordings compiled, in its folder `precompile/`. In the first session,
AutoPrecompile builds one package image for the packages that you loaded, in
the background, and logs that it does. A later session that loads the same
packages loads that image, so it compiles almost nothing of what the
recordings hold. The images take at most 2048 MB together; the entry
`disk_limit_mb` of the table `[AutoPrecompile]` in `LocalPreferences.toml`
sets another limit.

## Which repository is which

| Repository | What it is |
| --- | --- |
| [projectured-julia](https://github.com/projectured/projectured-julia) | The source: the application, the examples, the tests and the guides. A change belongs there. |
| [Projectured.jl](https://github.com/projectured/Projectured.jl) | This repository: the released packages, which the release writes from projectured-julia. |
| [ProjecturedRegistry](https://github.com/projectured/ProjecturedRegistry) | The Julia registry that names each version of these packages. |
| [AutoIntegration.jl](https://github.com/projectured/AutoIntegration.jl) | The package that loads an installed package when its triggers are loaded. `Projectured` depends on it. |
| [AutoPrecompile.jl](https://github.com/projectured/AutoPrecompile.jl) | The package that builds one package image for the packages that a session loads, from recorded precompile statements. |

## The packages

| Package | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Tests&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | What it holds or does |
| --- | :---: | --- |
| [Projectured](Projectured) | [![tests](https://github.com/projectured/Projectured.jl/actions/workflows/Projectured.yml/badge.svg)](https://github.com/projectured/Projectured.jl/actions/workflows/Projectured.yml) | The umbrella package of ProjecturEd: it loads the kernel, the platform and AutoIntegration, and gives the names that most users call. |
| [ProjecturedKernel](ProjecturedKernel) | [![tests](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedKernel.yml/badge.svg)](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedKernel.yml) | The core of ProjecturEd: reactive cells, documents, references, operations, projections and the editor loop, with no concrete kind of data. |
| [ProjecturedPlatform](ProjecturedPlatform) | [![tests](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedPlatform.yml/badge.svg)](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedPlatform.yml) | What every kind of data shares: text, syntax, graphics, layout, widgets, panes, windows, the generic views and the application. |
| [ProjecturedIntegrations](ProjecturedIntegrations) |  | Installs every integration of ProjecturEd and the packages that they join, and loads each integration when the package that it joins is loaded. |
| [ProjecturedAll](ProjecturedAll) |  | Every package of ProjecturEd that needs no package of another author, with all their names in one namespace. It loads much more than most programs need. |
| [ProjecturedAnthropic](ProjecturedAnthropic) | [![tests](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedAnthropic.yml/badge.svg)](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedAnthropic.yml) | Runs the AI assistant of ProjecturEd with a Claude model, through the Anthropic API. |
| [ProjecturedBook](ProjecturedBook) | [![tests](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedBook.yml/badge.svg)](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedBook.yml) | Structured prose: a book, its chapters, paragraphs of styled text, lists and pictures. |
| [ProjecturedChart](ProjecturedChart) | [![tests](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedChart.yml/badge.svg)](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedChart.yml) | Line, scatter, bar, histogram and strip charts as documents, drawn with no plotting library. |
| [ProjecturedConsole](ProjecturedConsole) | [![tests](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedConsole.yml/badge.svg)](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedConsole.yml) | Shows the editor in a terminal with ANSI colours, and reads the keys of the terminal. |
| [ProjecturedDBCatalog](ProjecturedDBCatalog) | [![tests](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedDBCatalog.yml/badge.svg)](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedDBCatalog.yml) | The catalog of a database as a tree of documents: its tables and their columns. |
| [ProjecturedDataFrames](ProjecturedDataFrames) | [![tests](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedDataFrames.yml/badge.svg)](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedDataFrames.yml) | Shows a `DataFrame` of DataFrames.jl as a table that you can scroll, sort, filter and edit, while the data stays in the data frame. |
| [ProjecturedDatabase](ProjecturedDatabase) | [![tests](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedDatabase.yml/badge.svg)](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedDatabase.yml) | The interface of a database adapter, and the documents of a database connection. |
| [ProjecturedFSM](ProjecturedFSM) | [![tests](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedFSM.yml/badge.svg)](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedFSM.yml) | Extended state machines: states, transitions on events, timers or conditions, and variables. A machine draws as a live diagram and generates a Julia module. |
| [ProjecturedFormula](ProjecturedFormula) | [![tests](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedFormula.yml/badge.svg)](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedFormula.yml) | Named formulas that refer to each other and compute a value, as the cells of a spreadsheet do. |
| [ProjecturedGraph](ProjecturedGraph) | [![tests](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedGraph.yml/badge.svg)](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedGraph.yml) | Node-and-edge diagrams in which each vertex holds a document of any kind. |
| [ProjecturedJSON](ProjecturedJSON) | [![tests](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedJSON.yml/badge.svg)](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedJSON.yml) | JSON data as a tree of documents that you edit in the JSON notation. |
| [ProjecturedJulia](ProjecturedJulia) | [![tests](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedJulia.yml/badge.svg)](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedJulia.yml) | Julia source code as a tree of documents that you edit in the Julia notation. |
| [ProjecturedMCP](ProjecturedMCP) | [![tests](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedMCP.yml/badge.svg)](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedMCP.yml) | Lets a client outside the process, such as an AI assistant, drive a running editor over the Model Context Protocol (MCP). |
| [ProjecturedMarkdown](ProjecturedMarkdown) | [![tests](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedMarkdown.yml/badge.svg)](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedMarkdown.yml) | A Markdown page as a tree of blocks and inlines. |
| [ProjecturedMath](ProjecturedMath) | [![tests](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedMath.yml/badge.svg)](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedMath.yml) | A math formula as a tree of documents: its structure, not its picture and not its value. |
| [ProjecturedODBC](ProjecturedODBC) | [![tests](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedODBC.yml/badge.svg)](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedODBC.yml) | Connects the database documents to a live database through ODBC.jl, and runs its queries. |
| [ProjecturedOllama](ProjecturedOllama) | [![tests](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedOllama.yml/badge.svg)](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedOllama.yml) | Runs the AI assistant of ProjecturEd with a model on your own machine, through a local Ollama server. |
| [ProjecturedOpenRouter](ProjecturedOpenRouter) | [![tests](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedOpenRouter.yml/badge.svg)](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedOpenRouter.yml) | A relevance model for the search of the AI assistant, which asks a model through the API of OpenRouter. |
| [ProjecturedPDF](ProjecturedPDF) | [![tests](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedPDF.yml/badge.svg)](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedPDF.yml) | Writes a view as a vector PDF with selectable text, with no third-party package. |
| [ProjecturedProcess](ProjecturedProcess) | [![tests](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedProcess.yml/badge.svg)](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedProcess.yml) | An algorithm as a structured flowchart: steps, decisions, loops and jumps. It runs with breakpoints and a live trace. |
| [ProjecturedRST](ProjecturedRST) | [![tests](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedRST.yml/badge.svg)](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedRST.yml) | reStructuredText as a tree of documents, with a parser and two presentations. |
| [ProjecturedSDL](ProjecturedSDL) | [![tests](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedSDL.yml/badge.svg)](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedSDL.yml) | Shows the editor in native windows with SDL2, and writes images of a view. |
| [ProjecturedSQL](ProjecturedSQL) | [![tests](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedSQL.yml/badge.svg)](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedSQL.yml) | A SQL statement as a tree of clause and expression documents, with a parser. |
| [ProjecturedSequenceChart](ProjecturedSequenceChart) | [![tests](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedSequenceChart.yml/badge.svg)](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedSequenceChart.yml) | Sequence charts: lanes of occurrences with arrows between them, which show what happened where, in which order, and what caused what. |
| [ProjecturedTulip](ProjecturedTulip) | [![tests](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedTulip.yml/badge.svg)](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedTulip.yml) | Solves the relations of a constraint layout with the linear-programming solver Tulip.jl. |
| [ProjecturedVideo](ProjecturedVideo) | [![tests](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedVideo.yml/badge.svg)](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedVideo.yml) | Records a scripted editing session as an `.mp4` file, with no window. |
| [ProjecturedWeb](ProjecturedWeb) | [![tests](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedWeb.yml/badge.svg)](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedWeb.yml) | Shows the editor in a web browser, through an HTTP and WebSocket server. |
| [ProjecturedXML](ProjecturedXML) | [![tests](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedXML.yml/badge.svg)](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedXML.yml) | An XML document as a tree of elements, text nodes and attributes. |
| [ProjecturedYAML](ProjecturedYAML) | [![tests](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedYAML.yml/badge.svg)](https://github.com/projectured/Projectured.jl/actions/workflows/ProjecturedYAML.yml) | YAML data as the tree of scalars, sequences and mappings that the JSON domain uses. |

## Tests

Each package holds its tests in `test/`. Each package with tests has a workflow
of its own in [`.github/workflows`](.github/workflows), `<Package>.yml`, which
runs them on every push, on Julia 1.12; its badge is in the
table above.

## Licence

The [Mozilla Public License 2.0](https://www.mozilla.org/en-US/MPL/2.0/), in [`LICENSE`](LICENSE).
