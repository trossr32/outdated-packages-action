# outdated-packages-action
Github action for reporting on outdated dotnet packages in a solution or project, or npm packages in a project directory.

## Overview

This action will run either or both of:

- <a href="https://github.com/dotnet-outdated/dotnet-outdated">dotnet-outdated</a> against a supplied dotnet solution or project
- <a href="https://docs.npmjs.com/cli/commands/npm-outdated">npm outdated</a> against a supplied npm project directory

> [!NOTE]
> The intention of this action is purely to notify of any outdated packages and _not_ to perform any kind of update action.
>
> Reports for any outdated packages found are added as a comment to the pull request used to run this action.
>
> If the action is re-run against a pull request that has already been commented on, the existing comment will be updated.
>
> `v1.7.0`, `v2.0.0` and `v3.x.x` of this action are functionally identical, except `v1.7.0` defaults to using dotnet `8.*.*`, `v2.0.0` defaults to using dotnet `9.*.*` and `v3.x.x` defaults to using dotnet `10.*.*`.
> `v3.x.x` also updates action dependencies to latest major versions (npm update check now uses node 20).

> [!WARNING]
> This action is designed to be actioned only within the context of a pull request, no other scenarios are catered for.

## Inputs

#### `use-dotnet-outdated`

**Optional** - Whether to run dotnet-outdated. Default `false`.

#### `dotnet-solution-or-project-path`

**Optional** - The path to the dotnet solution or project file. Required if `use-dotnet-outdated` is `true`.

#### `dotnet-exclude-packages`

**Optional** - Names of packages to exclude from the check. Optional if `use-dotnet-outdated` is `true`. Space delimited string of package names, e.g. "Microsoft.Extensions.Logging Microsoft.Extensions.Logging.Abstractions"

#### `dotnet-version`

**Optional** - The version of dotnet to use. Default `10.*.*`.

#### `use-npm-outdated`

**Optional** - Whether to run `npm outdated`. Default `false`.

#### `npm-project-directory`

**Optional** - The path to the npm project directory. Default `.`.

#### `hide-successful-checks`

**Optional** - When true, don't add a success comment to the PR when checks are successful. Default `false`.

#### `comment-label`

**Optional** - A label used to distinguish this run's PR comment, e.g. a matrix variant name. It is included in the comment's hidden identifier so parallel matrix jobs each update their own comment instead of overwriting one another, and is shown at the top of the comment. If omitted, the npm project directory / dotnet solution path is used to differentiate comments. Default `''`.

## Example github action

outdated.yml
```yaml
name: Outdated package checks

# Run workflow on pull request to the main branch
on:
  pull_request:
    types: [opened, synchronize, reopened]
    branches: [ main ]

env:
  SOLUTION_PATH: 'src/RobGreenEngineering.sln'
  PROJECT_DIR: 'src/RobGreenEngineering'
  EXCLUDE_PACKAGES: 'Microsoft.Extensions.Logging Microsoft.Extensions.Logging.Abstractions'

jobs:
  outdated-packages-check:
    runs-on: ubuntu-latest
    # grant pull request write permission if 'Read and write permissions' is not active for actions in the repository
    permissions:
      pull-requests: write

    steps:
      - uses: trossr32/outdated-packages-action@v4
        with:
          # Whether to run dotnet-outdated. Default is false if not supplied.
          use-dotnet-outdated: true

          # The path to the dotnet solution or project file. Required if use-dotnet-outdated is true.
          dotnet-solution-or-project-path: ${{ env.SOLUTION_PATH }}

          # Names of packages to exclude from the check. Optional if use-dotnet-outdated is true.
          # Space delimited string of package names, e.g. "Microsoft.Extensions.Logging Microsoft.Extensions.Logging.Abstractions"
          dotnet-exclude-packages: ${{ env.EXCLUDE_PACKAGES }}

          # The version of dotnet to use. Default is 10.*.*.
          dotnet-version: '10.*.*'

          # Whether to run npm-update-check-action. Default is false if not supplied.
          use-npm-outdated: true

          # The path to the npm project directory.
          # Default is '.', so only required if the npm project is not the root of the repository.
          npm-project-directory: ${{ env.PROJECT_DIR }}

          # When true, don't add a success comment to the PR when checks are successful. Default is false if not supplied.
          hide-successful-checks: false
```

## Example github action (matrix)

When checking multiple projects/directories in parallel with a matrix, each job posts its own PR comment. Comments are differentiated automatically by `npm-project-directory` / `dotnet-solution-or-project-path`; set `comment-label` to give each comment a friendlier title.

outdated.yml
```yaml
name: Outdated package checks

on:
  pull_request:
    types: [opened, synchronize, reopened]
    branches: [ main ]

jobs:
  outdated-packages-check:
    runs-on: ubuntu-latest
    name: Check outdated packages (${{ matrix.name }})
    permissions:
      pull-requests: write

    strategy:
      fail-fast: false
      matrix:
        include:
          - name: project root
            directory: '.'
          - name: playwright tests
            directory: 'tests/playwright'

    steps:
      - uses: trossr32/outdated-packages-action@v4
        with:
          use-npm-outdated: true
          npm-project-directory: ${{ matrix.directory }}
          # Optional: titles the comment and keeps each variant's comment separate
          comment-label: ${{ matrix.name }}
```

## Example output

The action posts a comment on the pull request (and updates it in place on re-runs). The examples below are rendered exactly as the comments appear on a PR.

### npm — outdated packages found

#### Outdated npm packages — `playwright tests`

_Reported by [this workflow run](https://github.com/trossr32/outdated-packages-action/actions/runs/123456789)._

> [!WARNING]
> Outdated npm packages found, update if possible. Run `npm outdated` in the terminal to view locally (with colour).

| Package | Current | Wanted | Latest | Update |
| --- | --- | --- | --- | --- |
| 🔴 left-pad | 1.0.0 | 1.0.5 | 2.1.0 | major |
| 🟠 chalk | 5.2.0 | 5.3.0 | 5.3.0 | minor |
| 🟢 lodash | 4.17.20 | 4.17.21 | 4.17.21 | patch |

### npm — all packages up to date

#### Outdated npm packages — `project root`

_Reported by [this workflow run](https://github.com/trossr32/outdated-packages-action/actions/runs/123456789)._

**No outdated npm packages found** 🚀

### dotnet — outdated packages found

> The nuget table (headings, columns and the colour-coded version) is produced by [dotnet-outdated](https://github.com/dotnet-outdated/dotnet-outdated); the action wraps it with the scope heading and warning below.

#### Outdated nuget packages — `src/RobGreenEngineering.sln`

_Reported by [this workflow run](https://github.com/trossr32/outdated-packages-action/actions/runs/123456789)._

> [!WARNING]
> Outdated nuget packages found, update if possible

# Outdated Packages

## RobGreenEngineering

### Target:net10.0

|Package|Transitive|Current|Last|Severity|
|-|-|-:|-:|-:|
|Microsoft.Extensions.Logging|False|8.0.0|$\textcolor{red}{\textsf{10.0.0}}$|Major|
|Serilog|False|3.1.1|${\textsf{3.}}\textcolor{yellow}{\textsf{2.0}}$|Minor|
|Newtonsoft.Json|False|13.0.2|${\textsf{13.0.}}\textcolor{green}{\textsf{3}}$|Patch|

> __Note__
>
> 🔴: Major version update or pre-release version. Possible breaking changes.
>
> 🟡: Minor version update. Backwards-compatible features added.
>
> 🟢: Patch version update. Backwards-compatible bug fixes.

### dotnet — all up to date

#### Outdated nuget packages — `src/RobGreenEngineering.sln`

_Reported by [this workflow run](https://github.com/trossr32/outdated-packages-action/actions/runs/123456789)._

**No outdated nuget packages found** 🚀

## Credit

This action leverages these projects:

- <a href="https://github.com/dotnet-outdated/dotnet-outdated">dotnet-outdated</a>
- <a href="https://docs.npmjs.com/cli/commands/npm-outdated">npm outdated</a>
- <a href="https://github.com/actions/setup-dotnet">setup-dotnet</a>

## Contribute
Please [create a pull request](https://github.com/trossr32/outdated-packages-action/compare) and get in touch. Alternatively feel free to [raise an issue](https://github.com/trossr32/outdated-packages-action/issues/new/choose) if you've found a bug or want to suggest a new feature.
