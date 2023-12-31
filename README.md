# outdated-packages-action
Github action for outdated dotnet and npm packages

## Overview

This action will run either or both of: 

- <a href="https://github.com/dotnet-outdated/dotnet-outdated">dotnet-outdated</a> against a supplied dotnet solution
- <a href="https://github.com/MeilCli/npm-update-check-action">npm-update-check-action</a> against a supplied npm project directory

> [!NOTE]
> The intention of this action is purely to report on any outdated packages and not to perform any kind of update action. Reports for any outdated packages found are added as a comment to the pull request used to run this action.

> [!WARNING]
> This action is designed to be actioned only within the context of a pull request, no other scenarios are catered for.

## Inputs

#### `use-dotnet-outdated`

**Optional** - Whether to run dotnet-outdated. Default `false`.

#### `dotnet-solution-path`

**Optional** - The path to the dotnet solution file. Required if `use-dotnet-outdated` is `true`.

#### `use-npm-outdated`

**Optional** - Whether to run npm-update-check-action. Default `false`.

#### `npm-project-directory`

**Optional** - The path to the npm project directory. Default `.`.

## Example github action 

outdated.yml
```
name: Outdated package checks

# Run workflow on pull request to the main branch
on:
  pull_request:
    types: [opened, synchronize, reopened]
    branches: [ main ]
  
  workflow_dispatch:

env:
  SOLUTION_PATH: 'src/RobGreenEngineering.sln'
  PROJECT_DIR: 'src/RobGreenEngineering'

jobs:
  outdated-packages-check:
    runs-on: ubuntu-latest

    steps:
      - uses: trossr32/outdated-packages-action@v0.0.8
        with:
          use-dotnet-outdated: true
          dotnet-solution-path: ${{ env.SOLUTION_PATH }}
          use-npm-outdated: true
          npm-project-directory: ${{ env.PROJECT_DIR }}
```

## Credit

This action leverages these projects:

- <a href="https://github.com/dotnet-outdated/dotnet-outdated">dotnet-outdated</a>
- <a href="https://github.com/MeilCli/npm-update-check-action">npm-update-check-action</a>
- <a href="https://github.com/thollander/actions-comment-pull-request">actions-comment-pull-request</a>
