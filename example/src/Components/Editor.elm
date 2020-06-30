module Components.Editor exposing (Model, MsgIn(..), MsgOut(..), component)

import Framework.Actor exposing (Component, Pid)
import Framework.Template.Html as HtmlTemplate exposing (HtmlTemplate)
import Framework.Template.Components exposing (Components)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)


type alias Model =
    { input : String
    , error : Maybe String
    }


type MsgIn
    = OnInput String


type MsgOut appActors
    = UpdateHtmlTemplate (HtmlTemplate appActors)


component : Components appActors -> Component String Model MsgIn (MsgOut appActors) (Html msg) msg
component components =
    { init = init components
    , update = update components
    , subscriptions = always Sub.none
    , view = view
    }


init : Components appActors -> ( a, String ) -> ( Model, List (MsgOut appActors), Cmd MsgIn )
init components ( _, defaultInput ) =
    update
        components
        (OnInput defaultInput)
        { input = ""
        , error = Nothing
        }


update : Components appActors -> MsgIn -> Model -> ( Model, List (MsgOut appActors), Cmd MsgIn )
update components msgIn model =
    case msgIn of
        OnInput input ->
            case HtmlTemplate.parse components input of
                Err error ->
                    ( { model | input = input, error = Just error }
                    , []
                    , Cmd.none
                    )

                Ok htmlTemplate ->
                    ( { model | input = input, error = Nothing }
                    , [ UpdateHtmlTemplate htmlTemplate ]
                    , Cmd.none
                    )


view : (MsgIn -> msg) -> Model -> (Pid -> Maybe (Html msg)) -> Html msg
view toSelf model _ =
    div [ class "Editor" ]
        [ div [ class "form-group" ]
            [ label [ for "editor_input" ]
                [ text "Html Template" ]
            , textarea
                [ class "form-control"
                , classList [ ( " is-invalid", model.error /= Nothing ) ]
                , id "editor_input"
                , rows 30
                , OnInput >> toSelf |> onInput
                ]
                [ Html.text model.input
                ]
            ]
        ]
