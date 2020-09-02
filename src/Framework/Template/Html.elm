module Framework.Template.Html exposing
    ( HtmlTemplate
    , blank, parse, fromNodes
    , toNodes, render, renderAndInterpolate, toString
    , getActorsToSpawn
    )

{-|

@docs HtmlTemplate


# Creation

@docs blank, parse, fromNodes


# Rendering

@docs toNodes, render, renderAndInterpolate, toString


# Utility

@docs getActorsToSpawn

-}

import Dict exposing (Dict)
import Framework.Actor exposing (Pid)
import Framework.Template exposing (ActorElement, Node)
import Framework.Template.Components exposing (Components)
import Framework.Template.Html.Internal.HtmlTemplate as HtmlTemplate
import Framework.Template.Html.Internal.Parser as Parser
import Framework.Template.Html.Internal.Render as Render
import Html exposing (Html)


{-| Your parsed template that originated from a string containing valid Html
-}
type alias HtmlTemplate appActors =
    HtmlTemplate.HtmlTemplate appActors


{-| An empty, blank HtmlTemplate
-}
blank : HtmlTemplate appActors
blank =
    HtmlTemplate.empty


{-| Parse a string containing valid Html into an HtmlTemplate

Add Components to replace Html Elements with your Actors based on their
nodeNames. (e.g. `<my-actor></my-actor>`)

-}
parse :
    Components appActors
    -> String
    -> Result String (HtmlTemplate appActors)
parse =
    Parser.parse


{-| Turn a list of Nodes into an HtmlTemplate

This could be useful for when you use your own Html Parser.

-}
fromNodes : List (Node appActors) -> HtmlTemplate appActors
fromNodes =
    HtmlTemplate.fromNodes


{-| Turn a HtmlTemplate into a list of Nodes

This could be useful for when you want to write or use another method of
rendering the template in question.

-}
toNodes : HtmlTemplate appActors -> List (Node appActors)
toNodes =
    HtmlTemplate.toNodes


{-| Turn a HtmlTemplate into a string
-}
toString : HtmlTemplate appActors -> String
toString =
    HtmlTemplate.toNodes
        >> List.map Parser.nodeToString
        >> String.join "\n"


{-| Get the actor, reference and original complete node from a template that
are meant to be spawned.

The String is a reference that can be used on the render function in combination
with a Pid to render the Actors output.

-}
getActorsToSpawn :
    HtmlTemplate appActors
    ->
        List
            { actor : appActors
            , reference : String
            , actorElement : ActorElement appActors
            }
getActorsToSpawn =
    HtmlTemplate.getActorsToSpawn


{-| Render your template
-}
render :
    Dict String Pid
    -> (Pid -> Maybe (Html msg))
    -> HtmlTemplate appActors
    -> List (Html msg)
render =
    Render.render


{-| Render your template and interpolate any string matching your interpolation dictionary.

    renderAndInterpolate
        Dict.empty
        (Dict.fromList [ ( "foo", "bar" ) ])
        (fromNodes [ Text "<p>#[foo]</p>" ])
        temmplate

-}
renderAndInterpolate :
    Dict String Pid
    -> Dict String String
    -> (Pid -> Maybe (Html msg))
    -> HtmlTemplate appActors
    -> List (Html msg)
renderAndInterpolate =
    Render.renderAndInterpolate
