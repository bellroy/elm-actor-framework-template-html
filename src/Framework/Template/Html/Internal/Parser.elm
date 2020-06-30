module Framework.Template.Html.Internal.Parser exposing (parse)

import Dict
import Framework.Template as Template
import Framework.Template.Component as Component
import Framework.Template.Components as Components exposing (Components)
import Framework.Template.Html.Internal.HtmlTemplate as HtmlTemplate exposing (HtmlTemplate)
import Html.Parser as HtmlParser
import MD5
import Parser as Parser


parse :
    Components appActors
    -> String
    -> Result String (HtmlTemplate appActors)
parse components =
    HtmlParser.run
        >> Result.mapError Parser.deadEndsToString
        >> Result.map
            (parserNodesToTemplateNodes components >> HtmlTemplate.fromNodes)


parserNodesToTemplateNodes :
    Components appActors
    -> List HtmlParser.Node
    -> List (Template.Node appActors)
parserNodesToTemplateNodes components =
    List.filterMap (parserNodeToTemplateNode components)


parserNodeToTemplateNode :
    Components appActors
    -> HtmlParser.Node
    -> Maybe (Template.Node appActors)
parserNodeToTemplateNode components htmlParserNode =
    case htmlParserNode of
        HtmlParser.Comment _ ->
            Nothing

        HtmlParser.Text "" ->
            Nothing

        HtmlParser.Text a ->
            if String.trim a == "" then
                Nothing

            else
                Just <| Template.Text a

        HtmlParser.Element nodeName attributes children ->
            case Components.getByNodeName nodeName components of
                Nothing ->
                    parserNodesToTemplateNodes components children
                        |> Template.Element nodeName attributes
                        |> Just

                Just component ->
                    Template.ActorElement
                        (Component.toActor component)
                        nodeName
                        (HtmlParser.nodeToString htmlParserNode
                            |> MD5.hex
                        )
                        (Component.toDefaultAttributes component
                            |> mergeAttributes attributes
                        )
                        (parserNodesToTemplateNodes components children)
                        |> Template.Actor
                        |> Just


mergeAttributes :
    List ( String, String )
    -> List ( String, String )
    -> List ( String, String )
mergeAttributes a b =
    Dict.union (Dict.fromList a) (Dict.fromList b)
        |> Dict.toList
