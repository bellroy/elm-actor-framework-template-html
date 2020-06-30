module Components.Counter exposing (Model, MsgIn, component)

import Framework.Actor exposing (Component)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


type alias Model =
    { value : Int
    , steps : Int
    }


type alias Flags =
    Model


type MsgIn
    = Increment
    | Decrement


component : Component Flags Model MsgIn () (Html msg) msg
component =
    { init = init
    , update = update
    , subscriptions = always Sub.none
    , view = view
    }


init : ( a, Flags ) -> ( Model, List (), Cmd MsgIn )
init ( _, model ) =
    ( model, [], Cmd.none )


update : MsgIn -> Model -> ( Model, List (), Cmd MsgIn )
update msgIn model =
    let
        newValue =
            case msgIn of
                Increment ->
                    model.value + model.steps

                Decrement ->
                    model.value - model.steps
    in
    ( { model | value = newValue }, [], Cmd.none )


view : (MsgIn -> msg) -> Model -> a -> Html msg
view toSelf model _ =
    div [ class "Counter input-group" ]
        [ div [ class "input-group-prepend" ]
            [ button
                [ class "btn btn-danger"
                , type_ "button"
                , onClick Decrement
                ]
                [ text ("- " ++ String.fromInt model.steps) ]
            ]
        , span
            [ class "form-control"
            , style "text-align" "center"
            , readonly True
            ]
            [ String.fromInt model.value |> Html.text
            ]
        , div [ class "input-group-append" ]
            [ button
                [ class "btn btn-success"
                , type_ "button"
                , onClick Increment
                ]
                [ text ("+ " ++ String.fromInt model.steps) ]
            ]
        ]
        |> Html.map toSelf
