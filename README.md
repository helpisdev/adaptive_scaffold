# Adaptive Scaffold

This is a re-work and modularization of the original [Adaptive Scaffold](https://github.com/flutter/packages/tree/main/packages/flutter_adaptive_scaffold) package maintained by the official Flutter team.

## What is the purpose of the rework?

I originally forked the package because certain underlying features I wanted to use weren't provided as configuration options. I started playing around and changed the codebase massively, mainly adding many missing configuration options and modularizing it, in my personal taste, so that I can keep maintaining it. The re-work did not happen with a specific goal in mind, so there wasn't any valid reason for a pull request. Apart from that, the official package is a part of a monorepo that does not use submodules, and since I didn't want the overhead of the rest of the packages, I removed them from my fork, making a pull request impossible from that part onwards. I do occasionally check out the commit history of the original package, and when I find any relevant commit with a scope `[flutter_adaptive_scaffold]`, I integrate any changes if they haven't been implemented here already.

I plan on re-working the library (again) since Dart 3.0 is now stable and it offers many great ways to simplify the code structure.

## How is it different?

This version gives much more control on the underlying functionality so it can be greatly customized to your use case. The options of the underlying components used are almost all provided as configuration objects. Notable changes include but not limited to configuration, breakpoints, use of custom `Drawer` widgets.

## License

The package maintains the original Copyright notice of the original fork.

## Other packages included to make this package more useful

- For the bottom bar, the option is provided to use the [Salomon Bottom Bar](https://github.com/lukepighetti/salomon_bottom_bar) by Luke Pighetti, and it maintains the author's copyright notice.

- As a scrollbar for small desktop screens, a fork of the [adaptive_scrollbar](https://pub.dev/packages/adaptive_scrollbar) is used. The original package is licensed under MIT.

- For the appbar, a fork of the [gtk_window](https://pub.dev/packages/gtk_window) is used. The original package is licensed under Mozilla Public License Version 2.0.

## License Notice

***I'm no lawyer, and I do not hold any special knowledge about copyrights. If an author of the packages used feels that their copyright is infringed, please contact me to resolve the issue by either making any suitable license changes or removing the package alltogether.***
