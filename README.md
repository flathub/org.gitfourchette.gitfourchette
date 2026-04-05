# GitFourchette Flatpak

This is the source for [GitFourchette](https://github.com/jorio/gitfourchette)'s Flatpak distribution.

If you stumbled here looking to install the Flatpak for GitFourchette, simply run:

```sh
flatpak install org.gitfourchette.gitfourchette
```

## Flatpak maintenance notes

### Build the Flatpak locally

Build and install the Flatpak locally (per [official instructions](https://docs.flathub.org/docs/for-app-authors/submission#build-and-install)):
```sh
flatpak run --command=flathub-build org.flatpak.Builder org.gitfourchette.gitfourchette.yml
```

Then [run the linter](https://docs.flathub.org/docs/for-app-authors/submission#run-the-linter) to make sure any new markup in the metainfo file is correct (e.g. in the changelog):
```sh
flatpak run --command=flatpak-builder-lint org.flatpak.Builder manifest org.gitfourchette.gitfourchette.yml
flatpak run --command=flatpak-builder-lint org.flatpak.Builder repo repo
```

### How to update the dependencies

1. Install the KDE Flatpak SDK corresponding to the newest runtime supported by PyQt.BaseApp.
    - Run `flatpak install org.kde.Sdk` and pick [the latest version supported by PyQt.BaseApp](https://github.com/flathub/com.riverbankcomputing.PyQt.BaseApp#branch-comparison).
    - This is not necessarily the latest available release of the KDE runtime.

2. In [org.gitfourchette.gitfourchette.yml](./org.gitfourchette.gitfourchette.yml), replace `runtime-version` and `base-version` with the version of the runtime you just installed.

3. Note the Python version that is included in the runtime:
    - `flatpak run --command=python3 org.kde.Sdk --version`

4. Collect the latest version numbers of the dependencies:
   - `virtualenv venv`
   - `source venv/bin/activate`
   - `pip install --ignore-installed pipdeptree req2flatpak setuptools pyyaml gitfourchette[pygments,mfusepy]@git+https://github.com/jorio/gitfourchette`
   - `pipdeptree -p gitfourchette`
   - In pipdeptree's output, note the installed versions of packages `pygments`, `pygit2`, `mfusepy`, `cffi`, `pycparser`.

5. Regenerate [python3-packages.yml](./python3-packages.yml):
    - In the command below, replace Python version number `313` with the Python version from the runtime (step 3), and replace the package versions with what you noted in step 4:
    - `req2flatpak --yaml --requirements pygments==2.20.0 pygit2==1.19.2 cffi==2.0.0 pycparser==3.0 mfusepy==3.1.1 -t 313-aarch64 313-x86_64 > python3-packages.yml`
    - In `python3-packages.yml`, make sure to restore the `--ignore-installed` argument, otherwise Pygments won't be built into the Flatpak!

6. You can now rebuild the Flatpak.
