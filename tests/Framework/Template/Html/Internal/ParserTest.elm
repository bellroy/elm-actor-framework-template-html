module Framework.Template.Html.Internal.ParserTest exposing (suite)

import Expect
import Framework.Template exposing (ActorElement(..), Node(..))
import Framework.Template.Html.Internal.HtmlTemplate as HtmlTemplate
import Framework.Template.Html.Internal.Parser as Parser
import Framework.Template.Html.Internal.TemplateComponent as TemplateComponent
import Framework.Template.Html.Internal.TemplateComponents as TemplateComponents
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
                    templateComponents =
                        TemplateComponents.fromList
                            [ TemplateComponent.make { nodeName = "some-actor", actor = "someActor" }
                                |> TemplateComponent.setDefaultAttributes [ ( "class", "ClassName" ) ]
                            ]

                    input =
                        """<!-- template example -->
                    <span class="welcome">Hello World</span>
                    <some-actor data-foo="bar"></some-actor>
                    """

                    output =
                        [ Element "span"
                            [ ( "class", "welcome" ) ]
                            [ Text "Hello World"
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
                Expect.equal (Parser.parse templateComponents input)
                    (Ok output)
        ]
