# outdated-packages-action

## 4.0.0

### Major Changes

- Remove the archived `MeilCli/npm-update-check-action` dependency; npm outdated checks now run locally via `npm outdated`
- Remove the `thollander/actions-comment-pull-request` dependency; PR comments are now created/updated locally via the GitHub CLI (`gh`)
- These changes drop the last Node 20 based actions, removing the upcoming Node 20 deprecation warnings (GitHub requires Node 24 from June 16th 2026)

## 3.1.0

### Minor Changes

- Install dotnet-outdated-tool as a local tool instead of global to fix compatibility with ubuntu-slim runners

## 3.0.0

### Major Changes

- Change default dotnet version to 10.0.0
- Update action dependencies to latest major versions (npm update check now uses node 20)

## 2.0.0

### Major Changes

- Change default dotnet version to 9.0.0

## 1.7.0

### Minor Changes

- Add dotnet version option

## 1.6.0

### Minor Changes

- New release version with bugs fixed

## 1.5.3

### Patch Changes

- Testing

## 1.5.2

### Patch Changes

- Testing

## 1.5.1

### Patch Changes

- Fix syntax error

## 1.5.0

### Minor Changes

- Convert dotnet-exclude-packages to string
- Add hide-successful-checks option

## 1.4.2

### Patch Changes

- Fix failure on empty array

## 1.4.1

### Patch Changes

- Fix missing outdated path

## 1.4.0

### Minor Changes

- Add dotnet exclude packages option

## 1.3.0

### Minor Changes

- Bump version to 1.3.0

## 1.2.0

### Minor Changes

- Bug fixes and refactor

## 1.1.0

### Minor Changes

- Deploy to github marketplace

## 1.0.0

### Major Changes

- Ready to be used as a composite action