module Init exposing (init, initialModel)

import Types exposing (..)


init : Maybe Flags -> ( Model, Cmd Msg )
init flags =
    modelFromFlags flags ! []


modelFromFlags : Maybe Flags -> Model
modelFromFlags flags =
    case flags of
        Nothing ->
            initialModel

        Just f ->
            { initialModel
                | linesOfCode = f.linesOfCode
                , totalLines = f.totalLines
                , growth = f.growth
                , upgrades = f.upgrades
                , programmers = f.programmers
                , programmerCost = f.programmerCost
                , message = f.message
                , workdays = f.workdays
                , manualClicks = f.manualClicks
            }


initialModel : Model
initialModel =
    { linesOfCode = 0
    , totalLines = 0
    , growth = 0
    , programmers = 1
    , programmerCost = 1000
    , message = ""
    , workdays = 0
    , canClick = True
    , op = (+)
    , manualClicks = 0
    , upgrades =
        [ { name = "Function Application"
          , cost = 10
          , codePerTick = 1
          }
        , { name = "Pattern Matching"
          , cost = 100
          , codePerTick = 2
          }
        , { name = "Currying"
          , cost = 10000
          , codePerTick = 100
          }
        , { name = "Functor"
          , cost = 50000
          , codePerTick = 500
          }
        , { name = "Applicative"
          , cost = 1000000
          , codePerTick = 20000
          }
        , { name = "Monad"
          , cost = 10000000
          , codePerTick = 300000
          }
        , { name = "Monoid"
          , cost = 50000000
          , codePerTick = 5000000
          }
        , { name = "Lens"
          , cost = 1000000000
          , codePerTick = 10000000
          }
        , { name = "Recursion"
          , cost = 10000000000
          , codePerTick = 1000000000
          }
        , { name = "Purity"
          , cost = 1000000000000
          , codePerTick = 1000000000000
          }
        , { name = "Laziness"
          , cost = 1000000000000000
          , codePerTick = 1000000000000000
          }
        , { name = "Algebraic Data Types"
          , cost = 2000000000000000
          , codePerTick = 10000000000000000
          }
        , { name = "Lambda Calculus"
          , cost = 3000000000000000000
          , codePerTick = 1000000000000000000
          }
        , { name = "General Artificial Intelligence"
          , cost = 1000000000000000000 * 100
          , codePerTick = 0
          }
        ]
    }
