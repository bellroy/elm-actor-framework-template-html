module Framework.Template.Html exposing
    ( HtmlTemplate, blank, parse, fromNodes, toNodes, getActorsToSpawn, render, renderAndInterpolate
    , TemplateComponent, make, setDefaultAttributes
    , TemplateComponents, empty, fromList, insert, remove, union
    )

{-|

@docs HtmlTemplate, blank, parse, fromNodes, toNodes, getActorsToSpawn, render, renderAndInterpolate

@docs TemplateComponent, make, setDefaultAttributes

@docs TemplateComponents, empty, fromList, insert, remove, union

-}

import Dict exposing (Dict)
import Framework.Actor exposing (Pid)
import Framework.Template exposing (ActorElement, Node)
import Framework.Template.Html.Internal.HtmlTemplate as HtmlTemplate
import Framework.Template.Html.Internal.Parser as Parser
import Framework.Template.Html.Internal.Render as Render
import Framework.Template.Html.Internal.TemplateComponent as TemplateComponent exposing (TemplateComponent)
import Framework.Template.Html.Internal.TemplateComponents as TemplateComponents exposing (TemplateComponents)
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

Add TemplateComponents to replace Html Elements with your Actors based on their
nodeNames. (e.g. `<my-actor></my-actor>`)

-}
parse :
    TemplateComponents appActors
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


{-| Render your template and interpolate any string matching your interpolation
dictionary
-}
renderAndInterpolate :
    Dict String Pid
    -> Dict String String
    -> (Pid -> Maybe (Html msg))
    -> HtmlTemplate appActors
    -> List (Html msg)
renderAndInterpolate =
    Render.renderAndInterpolate



----------------------------------------------------------------


{-| A TemplateComponent binds your Actor to an Html Element based on its
nodename.
-}
type alias TemplateComponent appActors =
    TemplateComponent.TemplateComponent appActors


{-| Create a new TemplateComponent

Note that W3C requires a `-` in the name for web component definitions.
Using the web component definition for your Actors is probably the most elegant
and means you can set up a fallback easily.

-}
make : { nodeName : String, actor : appActors } -> TemplateComponent appActors
make =
    TemplateComponent.make


{-| Set default attributes on your TemplateComponents.

These will be overwritten by attributes defined on the actual found element.

-}
setDefaultAttributes :
    List ( String, String )
    -> TemplateComponent appActors
    -> TemplateComponent appActors
setDefaultAttributes =
    TemplateComponent.setDefaultAttributes



----------------------------------------------------------------


{-| A collection of template components
-}
type alias TemplateComponents appActors =
    TemplateComponents.TemplateComponents appActors


{-| Create an empty set of template components
-}
empty : TemplateComponents appActors
empty =
    TemplateComponents.empty


{-| Create a collection of template components from a list of template components
-}
fromList :
    List (TemplateComponent appActors)
    -> TemplateComponents appActors
fromList =
    TemplateComponents.fromList


{-| Add a template component to a collection of template components
-}
insert :
    TemplateComponent appActors
    -> TemplateComponents appActors
    -> TemplateComponents appActors
insert =
    TemplateComponents.insert


{-| Remove a template component from a collection of template components
-}
remove :
    TemplateComponent appActors
    -> TemplateComponents appActors
    -> TemplateComponents appActors
remove =
    TemplateComponents.remove


{-| Combine two sets of template components
If there is a collision, preference is given to the first set of template
components.
-}
union :
    TemplateComponents appActors
    -> TemplateComponents appActors
    -> TemplateComponents appActors
union =
    TemplateComponents.union
