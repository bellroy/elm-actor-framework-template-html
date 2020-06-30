module Components.Layout exposing (Model, MsgIn(..), MsgOut(..), component)

import Dict exposing (Dict)
import Framework.Actor exposing (Component, Pid)
import Framework.Template exposing (ActorElement)
import Framework.Template.Html as HtmlTemplate exposing (HtmlTemplate)
import Html exposing (Html)


type alias Model appActors =
    { instances : Dict String Pid
    , htmlTemplate : HtmlTemplate appActors
    }


type MsgIn appActors
    = OnSpawnedActor String Pid
    | UpdateHtmlTemplate (HtmlTemplate appActors)


type MsgOut appActors
    = StopProcesses (List Pid)
    | SpawnActors (List ( appActors, String, ActorElement appActors ))


component : Component (HtmlTemplate appActors) (Model appActors) (MsgIn appActors) (MsgOut appActors) (Html msg) msg
component =
    { init = init
    , update = update
    , subscriptions = always Sub.none
    , view = view
    }


init : ( a, HtmlTemplate appActors ) -> ( Model appActors, List (MsgOut appActors), Cmd (MsgIn appActors) )
init ( _, htmlTemplate ) =
    { instances = Dict.empty
    , htmlTemplate = HtmlTemplate.blank
    }
        |> update (UpdateHtmlTemplate htmlTemplate)


update : MsgIn appActors -> Model appActors -> ( Model appActors, List (MsgOut appActors), Cmd (MsgIn appActors) )
update msgIn model =
    case msgIn of
        UpdateHtmlTemplate htmlTemplate ->
            ( { instances = Dict.empty
              , htmlTemplate = htmlTemplate
              }
            , [ model.instances
                    |> Dict.toList
                    |> List.map Tuple.second
                    |> StopProcesses
              , HtmlTemplate.getActorsToSpawn
                    htmlTemplate
                    |> List.map
                        (\{ actor, reference, actorElement } ->
                            ( actor, reference, actorElement )
                        )
                    |> SpawnActors
              ]
            , Cmd.none
            )

        OnSpawnedActor id pid ->
            ( { model
                | instances = Dict.insert id pid model.instances
              }
            , []
            , Cmd.none
            )


view : a -> Model appActors -> (Pid -> Maybe (Html msg)) -> Html msg
view _ { instances, htmlTemplate } renderPid =
    HtmlTemplate.render instances renderPid htmlTemplate
        |> Html.div []
