module Actors.Editor exposing (actor)

import Actors exposing (Actors(..), components)
import Address exposing (Address(..))
import AppFlags exposing (AppFlags(..))
import Components.Editor as Editor exposing (MsgIn(..), MsgOut(..))
import Components.Layout as Layout
import Framework.Actor as Actor exposing (Actor)
import Framework.Message as Message
import Framework.Template.Html as HtmlTemplate
import Html exposing (Html)
import Model exposing (Model(..))
import Msg exposing (AppMsg(..), Msg)


actor : Actor AppFlags Editor.Model Model (Html Msg) Msg
actor =
    Editor.component components
        |> Actor.altInit
            (\init ( pid, appFlags ) ->
                case appFlags of
                    EditorFlags input ->
                        init ( pid, input )

                    _ ->
                        init ( pid, "" )
            )
        |> Actor.fromComponent
            { toAppModel = EditorModel
            , toAppMsg = EditorMsg
            , fromAppMsg =
                \msg ->
                    case msg of
                        EditorMsg msgIn ->
                            Just msgIn

                        _ ->
                            Nothing
            , onMsgOut =
                \{ self, msgOut } ->
                    case msgOut of
                        UpdateHtmlTemplate htmlTemplate ->
                            Layout.UpdateHtmlTemplate htmlTemplate
                                |> LayoutMsg
                                |> Message.sendToAddress BaseLayoutAddress
            }
