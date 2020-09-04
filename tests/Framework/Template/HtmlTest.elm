module Framework.Template.HtmlTest exposing (suite)

import Dict
import Expect
import Framework.Template exposing (ActorElement(..), Node(..))
import Framework.Template.Html as TemplateHtml
import Html
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector exposing (text)


suite : Test
suite =
    describe "Framework.Template.Html"
        [ test_toString
        , test_getActorsToSpawn
        , test_renderAndInterpolate
        ]


actorElement : ActorElement String
actorElement =
    ActorElement
        actor
        "some-actor"
        actorElementRef
        [ ( "class", "ClassName" )
        , ( "foo", "#[foo]" )
        ]
        []


actor : String
actor =
    "someActor"


actorElementRef : String
actorElementRef =
    "b3c97430cb9046cd8613e305af9b3d93"


template : TemplateHtml.HtmlTemplate String
template =
    [ Element "span"
        [ ( "class", "welcome" ) ]
        [ Text "Hello &amp; World &gt; "
        , Element "span" [] [ Text "child" ]
        ]
    , Text "#[foo]"
    , Actor actorElement
    ]
        |> TemplateHtml.fromNodes


test_toString : Test
test_toString =
    describe "toString"
        [ test "template 1" <|
            \_ ->
                TemplateHtml.toString template
                    |> Expect.equal "<span class=\"welcome\">Hello &amp; World &gt; <span>child</span></span>\n#[foo]\n<some-actor class=\"ClassName\" foo=\"#[foo]\"></some-actor>"
        ]


test_getActorsToSpawn : Test
test_getActorsToSpawn =
    describe "getActorsToSpawn"
        [ test "template 1" <|
            \_ ->
                TemplateHtml.getActorsToSpawn template
                    |> Expect.equal
                        [ { actor = actor
                          , actorElement = actorElement
                          , reference = actorElementRef
                          }
                        ]
        ]


test_renderAndInterpolate : Test
test_renderAndInterpolate =
    describe "renderAndInterpolate"
        [ test "template 1" <|
            \_ ->
                TemplateHtml.renderAndInterpolate
                    Dict.empty
                    (Dict.fromList [ ( "foo", "bar" ) ])
                    (\_ -> Nothing)
                    template
                    |> Html.div []
                    |> Query.fromHtml
                    |> Query.has [ text "bar" ]
        ]
