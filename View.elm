module View exposing (view)

import Types exposing (..)
import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (style, src, id)


view : Model -> Html Msg
view model =
    div
        [ style
            [ ( "padding", "20px" )
            , ( "font-size", "14px" )
            , ( "font-family", "Helvetica, sans-serif" )
            ]
        ]
        ([ h1 [] [ text "Haskell Clicker" ]
         , p [] [ text "You are a Haskell programmer. This means that while your intentions are pure, you're also lazy. Luckily your boss is non-strict, so won't notice your shenanigans, but it still seems like you have an infinite list of code to write. Your goal is to create an Artificial Intelligence that can do your tasks for you. Good luck!" ]
         , p [] [ text (formatNum model.linesOfCode ++ pluralize model.linesOfCode " line" ++ " of code") ]
         , p [] [ text (formatNum model.growth ++ pluralize model.growth " line" ++ " per workday") ]
         , button
            [ onClick Click
            , id "use_this_id_to_cheat_and_click_automatically_with_JS"
            , style [ ( "background", "#ffddff" ), ( "padding", "20px" ) ]
            ]
            [ text "Write Code" ]
         , p
            []
            [ text
                ("Each programmer you hire increases the amount of code you can write by hand. The current cost of a programmer is "
                    ++ formatNum model.programmerCost
                    ++ ". You currently have "
                    ++ formatNum model.programmers
                    ++ pluralize model.programmers " programmer"
                    ++ " working for you, generating "
                    ++ formatNum (model.programmers * round (1.05 ^ toFloat model.programmers))
                    ++ pluralize (model.programmers * round (1.05 ^ toFloat model.programmers)) " line"
                    ++ " every time you write code."
                )
            ]
         , button
            [ onClick HireProgrammer
            , style
                [ ( "background"
                  , if model.programmerCost <= model.linesOfCode then
                        "#ffddff"
                    else
                        "white"
                  )
                , ( "padding", "20px" )
                ]
            ]
            [ text "Hire a Programmer" ]
         , p [] [ text model.message ]
         , p [] [ text " " ]
         , div
            [ style
                [ ( "display", "flex" )
                , ( "flex-wrap", "wrap" )
                ]
            ]
            (List.map (viewUpgrade model) model.upgrades)
         , p
            [ style [ ( "font-weight", "800" ) ] ]
            [ text "Statistics" ]
         , p [] [ text ("Times you wrote code by hand: " ++ formatNum model.manualClicks) ]
         , p [] [ text ("Total lines of code written: " ++ formatNum model.totalLines) ]
         , p [] [ text ("Two-week sprints that have passed: " ++ formatNum (model.workdays // 10)) ]
         , div [ style [ ( "height", "20px" ) ] ] []
         , p [ style [ ( "font-weight", "800" ) ] ] [ text "Danger Zone" ]
         , button [ onClick ClearSaveFile, style [ ( "color", "red" ), ( "border", "1px solid red" ) ] ] [ text "Delete Saved Data" ]
         ]
        )


viewUpgrade : Model -> Upgrade -> Html Msg
viewUpgrade model upgrade =
    div
        [ style
            [ ( "background"
              , if upgrade.cost <= model.linesOfCode then
                    "#ffddff"
                else
                    "#eeeeee"
              )
            , ( "border", "1px solid #aa33aa" )
            , ( "display", "inline-block" )
              -- , ( "width", "20%" )
            , ( "padding", "20px" )
            , ( "margin", "1px" )
            , ( "flex", "0 0 300px" )
            , ( "box-sizing", "border-box" )
            , ( "cursor"
              , if upgrade.cost <= model.linesOfCode then
                    "pointer"
                else
                    "default"
              )
            , ( "user-select", "none" )
            ]
        , onClick (BuyUpgrade upgrade)
        ]
        [ div [ style [ ( "font-weight", "800" ) ] ] [ text upgrade.name ]
        , div [] [ text ("Cost: " ++ formatNum upgrade.cost) ]
        , div []
            [ text
                ("Code per workday: "
                    ++ if upgrade.codePerTick > 0 then
                        formatNum upgrade.codePerTick
                       else
                        "?"
                )
            ]
        ]


formatNum : Int -> String
formatNum n =
    if
        String.contains "e" (toString n)
            || String.contains "f" (toString n)
    then
        toString n
    else
        String.join "," <| chunksOfRight 3 <| toString n


chunksOfRight : Int -> String -> List String
chunksOfRight chunkSize str =
    str
        |> String.reverse
        |> chunksOfLeft chunkSize
        |> List.map String.reverse
        |> List.reverse


chunksOfLeft : Int -> String -> List String
chunksOfLeft chunkSize str =
    if String.length str > chunkSize then
        String.left chunkSize str :: chunksOfLeft chunkSize (String.dropLeft chunkSize str)
    else
        [ str ]


pluralize : Int -> String -> String
pluralize n s =
    if n == 1 then
        s
    else
        s ++ "s"


button attrs elts =
    Html.button
        ([ style
            [ ( "color", "#992299" )
            , ( "border", "1px solid #aa33aa" )
            , ( "background", "white" )
            , ( "padding-left", "8px" )
            , ( "padding-right", "8px" )
            , ( "border-radius", "4px" )
            , ( "outline", "none" )
            , ( "margin-top", "4px" )
            , ( "cursor", "pointer" )
            ]
         ]
            ++ attrs
        )
        elts
