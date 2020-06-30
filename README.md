# Elm Actor Framework - Template - Html

This package is as an extension of the [Elm Actor Framework](https://github.com/tricycle/elm-actor-framework) [Package](https://package.elm-lang.org/packages/tricycle/elm-actor-framework/latest).

[Demo](https://tricycle.github.io/elm-actor-framework-html)

## Templates

Actors make up ideal components that can be used on a template.

This module uses a shared type from the `Elm Actor Framework -Templates` package.
The goal of these packages is to be able to provide different parsers and renderers.

- [Elm Actor Framework - Templates](https://github.com/tricycle/elm-actor-framework-template)
  - [Demo](https://tricycle.github.io/elm-actor-framework)
- [Elm Actor Framework - Templates - Html](https://github.com/tricycle/elm-actor-framework-template-html)
  - [Demo](https://tricycle.github.io/elm-actor-framework-template-html)
  - **Parse** Html Template (Using [`hecrj/html-parser`](https://github.com/hecrj/html-parser))
  - **Render** Html (Using [`elm/html`](https://github.com/elm/html))
- [Elm Actor Framework - Templates - Markdown](https://github.com/tricycle/elm-actor-framework-template-markdown)
  - [Demo](https://tricycle.github.io/elm-actor-framework-template-markdown)
  - **Parse** Markdown (Using [dillonkearns/elm-markdown](https://github.com/dillonkearns/elm-markdown))

Without the listed additional template packages this module can still be used to
supply a (custom) template foundation.

The included `example` can be previewed online [here](https://tricycle.github.io/elm-actor-framework)
