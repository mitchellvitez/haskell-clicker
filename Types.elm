module Types exposing (..)

import Time exposing (Time, millisecond)


type alias Model =
    { linesOfCode : Int
    , growth : Int
    , upgrades : List Upgrade
    , message : String
    , op : Int -> Int -> Int
    , workdays : Int
    , manualClicks : Int
    , totalLines : Int
    , programmers : Int
    , programmerCost : Int
    , canClick : Bool
    }


type alias Flags =
    { linesOfCode : Int
    , growth : Int
    , message : String
    , workdays : Int
    , manualClicks : Int
    , totalLines : Int
    , programmers : Int
    , programmerCost : Int
    , upgrades : List Upgrade
    }


type alias Upgrade =
    { name : String
    , codePerTick : Int
    , cost : Int
    }


type Msg
    = Click
    | BuyUpgrade Upgrade
    | Tick Time
    | TinyTick Time
    | HireProgrammer
    | ClearSaveFile
