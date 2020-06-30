module Framework.Template.Html.Internal.TemplateComponents exposing
    ( TemplateComponents
    , empty
    , fromList
    , get
    , insert
    , remove
    , union
    )

import Dict exposing (Dict)
import Framework.Template.Html.Internal.TemplateComponent as TemplateComponent exposing (TemplateComponent)


type TemplateComponents appActors
    = TemplateComponents (Dict String (TemplateComponent appActors))


empty : TemplateComponents appActors
empty =
    fromDict Dict.empty


fromList : List (TemplateComponent appActors) -> TemplateComponents appActors
fromList =
    List.map
        (\templateComponent ->
            ( TemplateComponent.toNodeName templateComponent
            , templateComponent
            )
        )
        >> Dict.fromList
        >> fromDict


toDict :
    TemplateComponents appActors
    -> Dict String (TemplateComponent appActors)
toDict (TemplateComponents dict) =
    dict


fromDict :
    Dict String (TemplateComponent appActors)
    -> TemplateComponents appActors
fromDict =
    TemplateComponents


mapDict :
    (Dict String (TemplateComponent appActors)
     -> Dict String (TemplateComponent appActors)
    )
    -> TemplateComponents appActors
    -> TemplateComponents appActors
mapDict f =
    toDict >> f >> fromDict


insert :
    TemplateComponent appActors
    -> TemplateComponents appActors
    -> TemplateComponents appActors
insert templateComponent =
    mapDict (Dict.insert (TemplateComponent.toNodeName templateComponent) templateComponent)


remove :
    TemplateComponent appActors
    -> TemplateComponents appActors
    -> TemplateComponents appActors
remove =
    TemplateComponent.toNodeName >> Dict.remove >> mapDict


get : String -> TemplateComponents appActors -> Maybe (TemplateComponent appActors)
get query =
    toDict >> Dict.get query


union :
    TemplateComponents appActors
    -> TemplateComponents appActors
    -> TemplateComponents appActors
union a b =
    Dict.union (toDict a) (toDict b)
        |> fromDict
