module Framework.Template.Html.Internal.Parser exposing (parse)

import Dict
import Framework.Template as Template
import Framework.Template.Html.Internal.HtmlTemplate as HtmlTemplate exposing (HtmlTemplate)
import Framework.Template.Html.Internal.TemplateComponent as TemplateComponent
import Framework.Template.Html.Internal.TemplateComponents as TemplateComponents exposing (TemplateComponents)
import Html.Parser as HtmlParser
import MD5
import Parser as Parser


parse : TemplateComponents appActors -> String -> Result String (HtmlTemplate appActors)
parse templateComponents =
    HtmlParser.run
        >> Result.mapError Parser.deadEndsToString
        >> Result.map
            (parserNodesToTemplateNodes templateComponents >> HtmlTemplate.fromNodes)


parserNodesToTemplateNodes : TemplateComponents appActors -> List HtmlParser.Node -> List (Template.Node appActors)
parserNodesToTemplateNodes templateComponents =
    List.filterMap (parserNodeToTemplateNode templateComponents)


parserNodeToTemplateNode : TemplateComponents appActors -> HtmlParser.Node -> Maybe (Template.Node appActors)
parserNodeToTemplateNode templateComponents htmlParserNode =
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
            case TemplateComponents.get nodeName templateComponents of
                Nothing ->
                    parserNodesToTemplateNodes templateComponents children
                        |> Template.Element nodeName attributes
                        |> Just

                Just templateComponent ->
                    Template.ActorElement
                        (TemplateComponent.toActor templateComponent)
                        nodeName
                        (HtmlParser.nodeToString htmlParserNode
                            |> MD5.hex
                        )
                        (TemplateComponent.toDefaultAttributes templateComponent
                            |> mergeAttributes attributes
                        )
                        (parserNodesToTemplateNodes templateComponents children)
                        |> Template.Actor
                        |> Just


mergeAttributes :
    List ( String, String )
    -> List ( String, String )
    -> List ( String, String )
mergeAttributes a b =
    Dict.union (Dict.fromList a) (Dict.fromList b)
        |> Dict.toList
