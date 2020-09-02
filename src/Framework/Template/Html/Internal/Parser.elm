module Framework.Template.Html.Internal.Parser exposing
    ( node
    , nodeToString
    , parse
    )

import Dict
import Framework.Template exposing (ActorElement(..), Node(..))
import Framework.Template.Component as Component
import Framework.Template.Components as Components exposing (Components)
import Framework.Template.Html.Internal.HtmlTemplate as HtmlTemplate exposing (HtmlTemplate)
import Hex
import MD5
import Parser exposing ((|.), (|=), Parser)


parse : Components appActors -> String -> Result String (HtmlTemplate appActors)
parse components str =
    if String.isEmpty str then
        Ok HtmlTemplate.empty

    else
        Parser.run (oneOrMore "node" (node components)) str
            |> Result.map HtmlTemplate.fromNodes
            |> Result.mapError Parser.deadEndsToString


type alias Attribute =
    ( String, String )


node : Components appActors -> Parser (Maybe (Node appActors))
node components =
    Parser.oneOf
        [ text
        , comment
        , element components
        ]


nodeToString : Node appActors -> String
nodeToString node_ =
    case node_ of
        Text string ->
            string

        Element name attributes children ->
            elementToString name attributes children

        Actor (ActorElement _ name _ attributes children) ->
            elementToString name attributes children



-- Text


text : Parser (Maybe (Node appActors))
text =
    Parser.oneOf
        [ Parser.getChompedString
            (chompOneOrMore
                (\c ->
                    case c of
                        '<' ->
                            False

                        '&' ->
                            False

                        _ ->
                            True
                )
            )
        , characterReference
        ]
        |> Parser.map Just
        |> oneOrMore "text element"
        |> Parser.map
            (\rawStr ->
                case String.join "" rawStr |> String.trim of
                    "" ->
                        Nothing

                    str ->
                        Just <| Text str
            )


characterReference : Parser String
characterReference =
    Parser.succeed identity
        |. Parser.chompIf
            (\c ->
                case c of
                    '&' ->
                        True

                    _ ->
                        False
            )
        |= Parser.oneOf
            [ Parser.backtrackable namedCharacterReference
                |. chompSemicolon
            , Parser.backtrackable numericCharacterReference
                |. chompSemicolon
            , Parser.succeed "&"
            ]


namedCharacterReference : Parser String
namedCharacterReference =
    Parser.getChompedString (chompOneOrMore Char.isAlpha)
        |> Parser.map
            (\reference ->
                "&" ++ reference ++ ";"
            )


numericCharacterReference : Parser String
numericCharacterReference =
    let
        codepoint =
            Parser.oneOf
                [ Parser.succeed identity
                    |. Parser.chompIf
                        (\c ->
                            case c of
                                'x' ->
                                    True

                                'X' ->
                                    True

                                _ ->
                                    False
                        )
                    |= hexadecimal
                , Parser.succeed identity
                    |. Parser.chompWhile
                        (\c ->
                            case c of
                                '0' ->
                                    True

                                _ ->
                                    False
                        )
                    |= Parser.int
                ]
    in
    Parser.succeed identity
        |. Parser.chompIf
            (\c ->
                case c of
                    '#' ->
                        True

                    _ ->
                        False
            )
        |= Parser.map (Char.fromCode >> String.fromChar) codepoint



-- Element


elementOrActorElement : Components appActors -> String -> List Attribute -> List (Node appActors) -> Node appActors
elementOrActorElement components name attributes children =
    case Components.getByNodeName name components of
        Just component ->
            let
                actor =
                    Component.toActor component

                id =
                    nodeToString (Element name attributes children)
                        |> MD5.hex

                mergeAttributes a b =
                    Dict.union (Dict.fromList a) (Dict.fromList b)
                        |> Dict.toList

                mergedAttributes =
                    Component.toDefaultAttributes component
                        |> mergeAttributes attributes
            in
            Actor <| ActorElement actor name id mergedAttributes children

        Nothing ->
            Element name attributes children


element : Components appActors -> Parser (Maybe (Node appActors))
element components =
    Parser.succeed Tuple.pair
        |. Parser.chompIf
            (\c ->
                case c of
                    '<' ->
                        True

                    _ ->
                        False
            )
        |= tagName
        |. Parser.chompWhile isSpaceCharacter
        |= tagAttributes
        |> Parser.andThen
            (\( name, attributes ) ->
                if isSelfClosingElement name then
                    Parser.succeed (Just <| elementOrActorElement components name attributes [])
                        |. Parser.oneOf
                            [ Parser.chompIf
                                (\c ->
                                    case c of
                                        '/' ->
                                            True

                                        _ ->
                                            False
                                )
                            , Parser.succeed ()
                            ]
                        |. Parser.chompIf
                            (\c ->
                                case c of
                                    '>' ->
                                        True

                                    _ ->
                                        False
                            )

                else
                    Parser.succeed (Just << elementOrActorElement components name attributes)
                        |. Parser.chompIf
                            (\c ->
                                case c of
                                    '>' ->
                                        True

                                    _ ->
                                        False
                            )
                        |= many (Parser.backtrackable (node components))
                        |. closingTag name
            )


tagName : Parser String
tagName =
    Parser.getChompedString
        (Parser.chompIf Char.isAlphaNum
            |. Parser.chompWhile
                (\c ->
                    case c of
                        '-' ->
                            True

                        _ ->
                            Char.isAlphaNum c
                )
        )
        |> Parser.map String.toLower


tagAttributes : Parser (List Attribute)
tagAttributes =
    many (Parser.map Just tagAttribute)


tagAttribute : Parser Attribute
tagAttribute =
    Parser.succeed Tuple.pair
        |= tagAttributeName
        |. Parser.chompWhile isSpaceCharacter
        |= tagAttributeValue
        |. Parser.chompWhile isSpaceCharacter


tagAttributeName : Parser String
tagAttributeName =
    Parser.getChompedString (chompOneOrMore isTagAttributeCharacter)
        |> Parser.map String.toLower


tagAttributeValue : Parser String
tagAttributeValue =
    Parser.oneOf
        [ Parser.succeed identity
            |. Parser.chompIf
                (\c ->
                    case c of
                        '=' ->
                            True

                        _ ->
                            False
                )
            |. Parser.chompWhile isSpaceCharacter
            |= Parser.oneOf
                [ tagAttributeUnquotedValue
                , tagAttributeQuotedValue '"'
                , tagAttributeQuotedValue '\''
                ]
        , Parser.succeed ""
        ]


tagAttributeUnquotedValue : Parser String
tagAttributeUnquotedValue =
    let
        isUnquotedValueChar c =
            case c of
                '"' ->
                    False

                '\'' ->
                    False

                '=' ->
                    False

                '<' ->
                    False

                '>' ->
                    False

                '`' ->
                    False

                '&' ->
                    False

                _ ->
                    not <| isSpaceCharacter c
    in
    Parser.oneOf
        [ chompOneOrMore isUnquotedValueChar
            |> Parser.getChompedString
        , characterReference
        ]
        |> Parser.map Just
        |> oneOrMore "attribute value"
        |> Parser.map (String.join "")


tagAttributeQuotedValue : Char -> Parser String
tagAttributeQuotedValue quote =
    let
        isQuotedValueChar c =
            case c of
                '&' ->
                    False

                _ ->
                    c /= quote
    in
    Parser.succeed identity
        |. Parser.chompIf ((==) quote)
        |= (Parser.oneOf
                [ Parser.getChompedString (chompOneOrMore isQuotedValueChar)
                , characterReference
                ]
                |> Parser.map Just
                |> many
                |> Parser.map (String.join "")
           )
        |. Parser.chompIf ((==) quote)


closingTag : String -> Parser ()
closingTag name =
    let
        chompName =
            chompOneOrMore
                (\c ->
                    case c of
                        '>' ->
                            False

                        _ ->
                            not <| isSpaceCharacter c
                )
                |> Parser.getChompedString
                |> Parser.andThen
                    (\closingName ->
                        if String.toLower closingName == name then
                            Parser.succeed ()

                        else
                            Parser.problem ("closing tag does not match opening tag: " ++ name)
                    )
    in
    Parser.chompIf
        (\c ->
            case c of
                '<' ->
                    True

                _ ->
                    False
        )
        |. Parser.chompIf
            (\c ->
                case c of
                    '/' ->
                        True

                    _ ->
                        False
            )
        |. chompName
        |. Parser.chompWhile isSpaceCharacter
        |. Parser.chompIf
            (\c ->
                case c of
                    '>' ->
                        True

                    _ ->
                        False
            )


elementToString : String -> List Attribute -> List (Node appActors) -> String
elementToString name attributes children =
    let
        attributeToString ( attr, value ) =
            attr ++ "=\"" ++ value ++ "\""

        maybeAttributes =
            case attributes of
                [] ->
                    ""

                _ ->
                    " " ++ String.join " " (List.map attributeToString attributes)
    in
    if isSelfClosingElement name then
        String.concat
            [ "<"
            , name
            , maybeAttributes
            , ">"
            ]

    else
        String.concat
            [ "<"
            , name
            , maybeAttributes
            , ">"
            , String.join "" (List.map nodeToString children)
            , "</"
            , name
            , ">"
            ]



-- Comment


comment : Parser (Maybe a)
comment =
    Parser.map (always Nothing) commentString


commentString : Parser String
commentString =
    Parser.succeed Basics.identity
        |. Parser.token "<!"
        |. Parser.token "--"
        |= Parser.getChompedString (Parser.chompUntil "-->")
        |. Parser.token "-->"


isSelfClosingElement : String -> Bool
isSelfClosingElement name =
    case name of
        "img" ->
            True

        "br" ->
            True

        "hr" ->
            True

        "input" ->
            True

        "link" ->
            True

        "meta" ->
            True

        _ ->
            False



-- Character validators


isTagAttributeCharacter : Char -> Bool
isTagAttributeCharacter c =
    case c of
        '"' ->
            False

        '\'' ->
            False

        '>' ->
            False

        '/' ->
            False

        '=' ->
            False

        _ ->
            not <| isSpaceCharacter c


isSpaceCharacter : Char -> Bool
isSpaceCharacter c =
    case c of
        ' ' ->
            True

        '\t' ->
            True

        '\n' ->
            True

        _ ->
            False



-- Chomp


chompSemicolon : Parser ()
chompSemicolon =
    Parser.chompIf
        (\c ->
            case c of
                ';' ->
                    True

                _ ->
                    False
        )


chompOneOrMore : (Char -> Bool) -> Parser ()
chompOneOrMore fn =
    Parser.chompIf fn
        |. Parser.chompWhile fn



-- Types


hexadecimal : Parser Int
hexadecimal =
    chompOneOrMore Char.isHexDigit
        |> Parser.getChompedString
        |> Parser.andThen
            (\hex ->
                case Hex.fromString (String.toLower hex) of
                    Ok value ->
                        Parser.succeed value

                    Err error ->
                        Parser.problem error
            )



-- Loops


many : Parser (Maybe a) -> Parser (List a)
many parser_ =
    Parser.loop []
        (\list ->
            Parser.oneOf
                [ parser_ |> Parser.map (\new -> Parser.Loop (new :: list))
                , Parser.succeed (Parser.Done (List.reverse list |> List.filterMap identity))
                ]
        )


oneOrMore : String -> Parser (Maybe a) -> Parser (List a)
oneOrMore type_ parser_ =
    Parser.loop []
        (\list ->
            Parser.oneOf
                [ parser_ |> Parser.map (\new -> Parser.Loop (new :: list))
                , if List.isEmpty list then
                    Parser.problem ("expecting at least one " ++ type_)

                  else
                    Parser.succeed (Parser.Done (List.reverse list |> List.filterMap identity))
                ]
        )
