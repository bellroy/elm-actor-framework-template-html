module Main exposing (factory, main)

import Actors exposing (Actors(..))
import Actors.Counter as Counter
import Actors.Editor as Editor
import Actors.Layout as Layout
import Address exposing (Address(..))
import AppFlags exposing (AppFlags(..))
import Framework.Actor exposing (Pid, Process)
import Framework.Browser as Browser exposing (Program)
import Framework.Message as Message exposing (FrameworkMessage)
import Framework.Template.Html as HtmlTemplate
import Html exposing (Html)
import Html.Attributes as HtmlA
import Model exposing (Model(..))
import Msg exposing (AppMsg(..), Msg)


main : Program () AppFlags Address Actors Model AppMsg
main =
    Browser.element
        { init = init
        , factory = factory
        , apply = apply
        , view = view
        }


init : flags -> FrameworkMessage AppFlags Address Actors Model AppMsg
init _ =
    Message.batch
        [ Message.spawn
            (LayoutFlags HtmlTemplate.blank)
            Layout
            (\pid ->
                [ Message.populateAddress BaseLayoutAddress pid
                , Message.addToView pid
                ]
                    |> Message.batch
            )
        , Message.spawn
            (EditorFlags defaultTemplate)
            Editor
            Message.addToView
        ]


factory : Actors -> ( Pid, AppFlags ) -> ( Model, Msg )
factory actorName =
    case actorName of
        Counter ->
            Counter.actor.init

        Editor ->
            Editor.actor.init

        Layout ->
            Layout.actor.init


apply : Model -> Process Model (Html Msg) Msg
apply appModel =
    case appModel of
        CounterModel counterModel ->
            Counter.actor.apply counterModel

        EditorModel editorModel ->
            Editor.actor.apply editorModel

        LayoutModel layoutModel ->
            Layout.actor.apply layoutModel


view : List (Html Msg) -> Html Msg
view output =
    Html.section []
        [ Html.node "link"
            [ HtmlA.rel "stylesheet"
            , HtmlA.href "https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css"
            ]
            []
        , Html.node "style"
            []
            [ Html.text """
            .Columns {
                display: flex;
                flex-direction: row-reverse;
            }
            .Columns > div {
                display: block;
                flex: 1 1 50%;
                padding: 20px;
            }
            .Editor textarea {
                font-family: monospace;
                font-size: 12px;
            }
            [data-x-name="layout-component"] {
                display: block;
                margin: 20px;
                padding: 20px;
                border: 1px dotted #ddd;
            }
            [data-x-name="counter-component"] {
                display: block;
                margin: 20px auto;
                width: 200px;
            }
            """
            ]
        , Html.div [ HtmlA.class "Columns" ] output
        ]


defaultTemplate : String
defaultTemplate =
    """
<h1>An Html Template</h1>
<counter-component></counter-component>
<counter-component value="2" steps="2"></counter-component>
<layout-component>
    <h2>A Layout inside a Layout</h2>
    <counter-component value="100"></counter-component>
</layout-component>
   """
