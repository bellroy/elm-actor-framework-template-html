module Main exposing (main)

import Benchmark exposing (Benchmark)
import Benchmark.Runner exposing (BenchmarkProgram, program)
import Framework.Template.Component as Component
import Framework.Template.Components as Components exposing (Components)
import Framework.Template.Html as HtmlTemplate


main : BenchmarkProgram
main =
    program <|
        Benchmark.describe "Html Parsing"
            [ parse
            ]


parse : Benchmark
parse =
    Benchmark.describe "parse"
        [ Benchmark.benchmark "simple template"
            (\_ -> HtmlTemplate.parse components simpleTemplate)
        ]


simpleTemplate : String
simpleTemplate =
    """
    Foo
    <span>Bar</span>
    <div><ul><li>Item</li></ul></div>
    <some-component class="ClassName">
        <strong>Foo</strong>
        <some-component-z class="ClassName">
            <strong>Foo</strong>
        </some-component-z>
    </some-component>
"""


type Actors
    = SomeComponent
    | SomeComponentB
    | SomeComponentC
    | SomeComponentD
    | SomeComponentE
    | SomeComponentF
    | SomeComponentG
    | SomeComponentH
    | SomeComponentI
    | SomeComponentJ
    | SomeComponentK
    | SomeComponentL
    | SomeComponentM
    | SomeComponentN
    | SomeComponentO
    | SomeComponentP
    | SomeComponentQ
    | SomeComponentR
    | SomeComponentS
    | SomeComponentT
    | SomeComponentU
    | SomeComponentV
    | SomeComponentW
    | SomeComponentX
    | SomeComponentY
    | SomeComponentZ


components : Components Actors
components =
    Components.fromList
        [ { nodeName = "some-component"
          , actor = SomeComponent
          }
            |> Component.make
            |> Component.setDefaultAttributes [ ( "data-foo", "bar" ) ]
        , { nodeName = "some-component-b"
          , actor = SomeComponentB
          }
            |> Component.make
            |> Component.setDefaultAttributes [ ( "data-bar", "foo" ) ]
        , { nodeName = "some-component-c"
          , actor = SomeComponentC
          }
            |> Component.make
            |> Component.setDefaultAttributes [ ( "data-bar", "foo" ) ]
        , { nodeName = "some-component-d"
          , actor = SomeComponentD
          }
            |> Component.make
            |> Component.setDefaultAttributes [ ( "data-bar", "foo" ) ]
        , { nodeName = "some-component-e"
          , actor = SomeComponentE
          }
            |> Component.make
            |> Component.setDefaultAttributes [ ( "data-bar", "foo" ) ]
        , { nodeName = "some-component-f"
          , actor = SomeComponentF
          }
            |> Component.make
            |> Component.setDefaultAttributes [ ( "data-bar", "foo" ) ]
        , { nodeName = "some-component-g"
          , actor = SomeComponentG
          }
            |> Component.make
            |> Component.setDefaultAttributes [ ( "data-bar", "foo" ) ]
        , { nodeName = "some-component-H"
          , actor = SomeComponentH
          }
            |> Component.make
            |> Component.setDefaultAttributes [ ( "data-bar", "foo" ) ]
        , { nodeName = "some-component-i"
          , actor = SomeComponentI
          }
            |> Component.make
            |> Component.setDefaultAttributes [ ( "data-bar", "foo" ) ]
        , { nodeName = "some-component-j"
          , actor = SomeComponentJ
          }
            |> Component.make
            |> Component.setDefaultAttributes [ ( "data-bar", "foo" ) ]
        , { nodeName = "some-component-k"
          , actor = SomeComponentK
          }
            |> Component.make
            |> Component.setDefaultAttributes [ ( "data-bar", "foo" ) ]
        , { nodeName = "some-component-l"
          , actor = SomeComponentL
          }
            |> Component.make
            |> Component.setDefaultAttributes [ ( "data-bar", "foo" ) ]
        , { nodeName = "some-component-m"
          , actor = SomeComponentM
          }
            |> Component.make
            |> Component.setDefaultAttributes [ ( "data-bar", "foo" ) ]
        , { nodeName = "some-component-n"
          , actor = SomeComponentN
          }
            |> Component.make
            |> Component.setDefaultAttributes [ ( "data-bar", "foo" ) ]
        , { nodeName = "some-component-o"
          , actor = SomeComponentO
          }
            |> Component.make
            |> Component.setDefaultAttributes [ ( "data-bar", "foo" ) ]
        , { nodeName = "some-component-p"
          , actor = SomeComponentP
          }
            |> Component.make
            |> Component.setDefaultAttributes [ ( "data-bar", "foo" ) ]
        , { nodeName = "some-component-q"
          , actor = SomeComponentQ
          }
            |> Component.make
            |> Component.setDefaultAttributes [ ( "data-bar", "foo" ) ]
        , { nodeName = "some-component-r"
          , actor = SomeComponentR
          }
            |> Component.make
            |> Component.setDefaultAttributes [ ( "data-bar", "foo" ) ]
        , { nodeName = "some-component-S"
          , actor = SomeComponentS
          }
            |> Component.make
            |> Component.setDefaultAttributes [ ( "data-bar", "foo" ) ]
        , { nodeName = "some-component-t"
          , actor = SomeComponentT
          }
            |> Component.make
            |> Component.setDefaultAttributes [ ( "data-bar", "foo" ) ]
        , { nodeName = "some-component-u"
          , actor = SomeComponentU
          }
            |> Component.make
            |> Component.setDefaultAttributes [ ( "data-bar", "foo" ) ]
        , { nodeName = "some-component-v"
          , actor = SomeComponentV
          }
            |> Component.make
            |> Component.setDefaultAttributes [ ( "data-bar", "foo" ) ]
        , { nodeName = "some-component-W"
          , actor = SomeComponentW
          }
            |> Component.make
            |> Component.setDefaultAttributes [ ( "data-bar", "foo" ) ]
        , { nodeName = "some-component-x"
          , actor = SomeComponentX
          }
            |> Component.make
            |> Component.setDefaultAttributes [ ( "data-bar", "foo" ) ]
        , { nodeName = "some-component-y"
          , actor = SomeComponentY
          }
            |> Component.make
            |> Component.setDefaultAttributes [ ( "data-bar", "foo" ) ]
        , { nodeName = "some-component-z"
          , actor = SomeComponentZ
          }
            |> Component.make
            |> Component.setDefaultAttributes [ ( "data-bar", "foo" ) ]
        ]
