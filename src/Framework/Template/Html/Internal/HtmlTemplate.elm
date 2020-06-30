module Framework.Template.Html.Internal.HtmlTemplate exposing
    ( HtmlTemplate
    , empty
    , fromNodes
    , getActorsToSpawn
    , toNodes
    )

import Framework.Template as Template exposing (ActorElement(..), Node(..))


type HtmlTemplate appActors
    = HtmlTemplate (List (Node appActors))


empty : HtmlTemplate appActors
empty =
    fromNodes []


fromNodes : List (Node appActors) -> HtmlTemplate appActors
fromNodes =
    HtmlTemplate


toNodes : HtmlTemplate appActors -> List (Node appActors)
toNodes (HtmlTemplate nodes) =
    nodes


getActorsToSpawn :
    HtmlTemplate appActors
    ->
        List
            { actor : appActors
            , reference : String
            , actorElement : ActorElement appActors
            }
getActorsToSpawn =
    toNodes
        >> Template.getActorElementDescendants
        >> List.map
            (\((ActorElement actor _ id _ _) as actorElement) ->
                { actor = actor
                , reference = id
                , actorElement = actorElement
                }
            )
        >> List.foldl
            (\tuple result ->
                if List.member tuple result then
                    result

                else
                    tuple :: result
            )
            []
