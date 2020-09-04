module Framework.Template.Html.Internal.ParserTest exposing (suite)

import Expect
import Framework.Template exposing (ActorElement(..), Node(..))
import Framework.Template.Component as Component
import Framework.Template.Components as Components
import Framework.Template.Html.Internal.HtmlTemplate as HtmlTemplate
import Framework.Template.Html.Internal.Parser as Parser
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "Parser"
        [ test_parse
        ]


test_parse : Test
test_parse =
    describe "Parse"
        [ test "template  1" <|
            \_ ->
                let
                    components =
                        Components.fromList
                            [ Component.make { nodeName = "some-actor", actor = "someActor" }
                                |> Component.setDefaultAttributes [ ( "class", "ClassName" ) ]
                            ]

                    input =
                        """<!-- template example -->
                    <span class="welcome">Hello World ></span>
                    <some-actor data-foo="bar"></some-actor>
                    """

                    output =
                        [ Element "span"
                            [ ( "class", "welcome" ) ]
                            [ Text "Hello World >"
                            ]
                        , ActorElement "someActor"
                            "some-actor"
                            "b3c97430cb9046cd8613e305af9b3d93"
                            [ ( "class", "ClassName" )
                            , ( "data-foo", "bar" )
                            ]
                            []
                            |> Actor
                        ]
                            |> HtmlTemplate.fromNodes
                in
                Expect.equal (Parser.parse components input)
                    (Ok output)
        ]
