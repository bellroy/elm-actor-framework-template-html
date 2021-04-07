![Build Status](https://github.com/bellroy/elm-actor-framework-template-html/workflows/Continuous%20Integration/badge.svg) [![Elm package](https://img.shields.io/elm-package/v/bellroy/elm-actor-framework-template-html.svg)](https://package.elm-lang.org/packages/bellroy/elm-actor-framework-template-html/latest/)

# Elm Actor Framework - Template - Html

This package is as an extension of the [Elm Actor Framework](https://github.com/bellroy/elm-actor-framework) [Package](https://package.elm-lang.org/packages/bellroy/elm-actor-framework/latest).

[Demo](https://bellroy.github.io/elm-actor-framework-html)

## Templates

Actors make up ideal components that can be used on a template.

This module uses a shared type from the `Elm Actor Framework -Templates` package.
The goal of these packages is to be able to provide different parsers and renderers.

- [Elm Actor Framework - Templates](https://github.com/bellroy/elm-actor-framework-template)
  - [Demo](https://bellroy.github.io/elm-actor-framework)
- [Elm Actor Framework - Templates - Html](https://github.com/bellroy/elm-actor-framework-template-html)
  - [Demo](https://bellroy.github.io/elm-actor-framework-template-html)
  - **Parse** Html Template (Using [`hecrj/html-parser`](https://github.com/hecrj/html-parser))
  - **Render** Html (Using [`elm/html`](https://github.com/elm/html))
- [Elm Actor Framework - Templates - Markdown](https://github.com/bellroy/elm-actor-framework-template-markdown)
  - [Demo](https://bellroy.github.io/elm-actor-framework-template-markdown)
  - **Parse** Markdown (Using [dillonkearns/elm-markdown](https://github.com/dillonkearns/elm-markdown))

Without the listed additional template packages this module can still be used to
supply a (custom) template foundation.

The included `example` can be previewed online [here](https://bellroy.github.io/elm-actor-framework)
