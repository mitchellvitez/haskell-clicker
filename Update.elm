port module Update exposing (update)

import Init exposing (initialModel)
import Json.Encode as E
import Types exposing (..)


port setStorage : E.Value -> Cmd msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        HireProgrammer ->
            if model.linesOfCode >= model.programmerCost then
                { model
                    | programmers = model.programmers + 1
                    , programmerCost = round (1.1 * toFloat model.programmerCost)
                    , linesOfCode = model.linesOfCode - model.programmerCost
                }
                    ! []
            else
                model ! []

        Click ->
            if model.canClick then
                { model
                    | linesOfCode = model.linesOfCode + model.programmers * round (1.05 ^ toFloat model.programmers)
                    , manualClicks = model.manualClicks + 1
                    , totalLines = model.totalLines + model.programmers * round (1.05 ^ toFloat model.programmers)
                    , canClick = False
                }
                    ! []
            else
                model ! []

        BuyUpgrade upgrade ->
            if
                upgrade.name
                    == "General Artificial Intelligence"
                    && model.linesOfCode
                    >= upgrade.cost
            then
                { model
                    | message = "You've created an intelligence that can write code in only " ++ toString (model.workdays // 10) ++ " sprints! All of your upgrades now multiply the growth instead of merely adding to it. You'll achieve your dream of infinite code in no time!"
                    , op = (*)
                }
                    ! []
            else
                (if model.linesOfCode >= upgrade.cost then
                    { model
                        | linesOfCode = model.linesOfCode - upgrade.cost
                        , growth = model.op model.growth upgrade.codePerTick
                        , upgrades = List.map (updateUpgrade upgrade.name) model.upgrades
                    }
                        ! []
                 else
                    model ! []
                )

        Tick time ->
            let
                newModel =
                    { model
                        | linesOfCode = model.linesOfCode + model.growth
                        , workdays = model.workdays + 1
                        , totalLines = model.totalLines + model.growth
                    }
            in
                newModel ! [ setStorage (encodeModel newModel) ]

        TinyTick time ->
            { model | canClick = True } ! []

        ClearSaveFile ->
            initialModel ! [ setStorage (encodeModel initialModel) ]


updateUpgrade : String -> Upgrade -> Upgrade
updateUpgrade name upgrade =
    if upgrade.name == name then
        { upgrade | cost = upgrade.cost * 2 }
    else
        upgrade


encodeModel : Model -> E.Value
encodeModel m =
    E.object
        [ ( "linesOfCode", E.int m.linesOfCode )
        , ( "growth", E.int m.growth )
        , ( "upgrades", E.list (List.map encodeUpgrade m.upgrades) )
        , ( "message", E.string m.message )
        , ( "manualClicks", E.int m.manualClicks )
        , ( "workdays", E.int m.workdays )
        , ( "totalLines", E.int m.totalLines )
        , ( "programmers", E.int m.programmers )
        , ( "programmerCost", E.int m.programmerCost )
        ]


encodeUpgrade : Upgrade -> E.Value
encodeUpgrade u =
    E.object
        [ ( "name", E.string u.name )
        , ( "codePerTick", E.int u.codePerTick )
        , ( "cost", E.int u.cost )
        ]
