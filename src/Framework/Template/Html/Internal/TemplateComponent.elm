module Framework.Template.Html.Internal.TemplateComponent exposing
    ( TemplateComponent
    , make
    , setDefaultAttributes
    , toActor
    , toDefaultAttributes
    , toNodeName
    )


type TemplateComponent appActors
    = TemplateComponent
        { nodeName : String
        , actor : appActors
        , defaultAttributes : List ( String, String )
        }


make :
    { nodeName : String
    , actor : appActors
    }
    -> TemplateComponent appActors
make { nodeName, actor } =
    TemplateComponent
        { nodeName = nodeName
        , actor = actor
        , defaultAttributes = []
        }


setDefaultAttributes :
    List ( String, String )
    -> TemplateComponent appActors
    -> TemplateComponent appActors
setDefaultAttributes defaultAttributes (TemplateComponent r) =
    TemplateComponent { r | defaultAttributes = defaultAttributes }


toActor : TemplateComponent appActors -> appActors
toActor (TemplateComponent { actor }) =
    actor


toNodeName : TemplateComponent appActors -> String
toNodeName (TemplateComponent { nodeName }) =
    nodeName


toDefaultAttributes : TemplateComponent appActors -> List ( String, String )
toDefaultAttributes (TemplateComponent { defaultAttributes }) =
    defaultAttributes
