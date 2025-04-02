# Dash Demos

This repo is for code that supports talks, blogs, and experiments. **This code is unmaintained.**

## Contributing

If you're on the Dash team at Google, this repo is appropriate for **any** demo, sample, experiment, etc that you don't want to commit to maintaining. For example:

- Demos for talks, events, workshops, or tied to a timeline in some way.
- Sample apps that are in-progress.
- Sample apps that are tied to experimental features.
- Sample apps in which the running demo app is more important that the code itself.
- Code that just doesn't belong anywhere else.
- **Any code that shouldn't be advertised as having best practices or being up to date.**

## CI

This repository has CI in the case that you want to test your demo code against the three Flutter channels. **CI is not required to merge code,** it's simply here as a convenience. It's run every night at midnight, and when you make a PR.

To add your code to CI:
1. For each Flutter channel, you'll find a CI file in the `/tool` dir called `flutter_ci_script_stable`, `flutter_ci_script_beta`, and `flutter_ci_script_master`. Open the file(s) that correspond to the channel you want to test your code against.

2. Add the directory name of your project to this array:
```bash
declare -ar PROJECT_NAMES=(
  # add projects here
)
```

## `_archive`

Projects can be moved here when they're no longer useful. This is purely cosmetic, and really only signals to readers that we no longer care about this code.
