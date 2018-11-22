module Main exposing (..)

import Html exposing (programWithFlags)
import Init exposing (init)
import Time exposing (Time, millisecond)
import Types exposing (..)
import Update exposing (update)
import View exposing (view)


-- TODO: fix erroring out on inability to parse Infinity from local storage


main : Program (Maybe Flags) Model Msg
main =
    programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Time.every (500 * millisecond) Tick
        , Time.every (12 * millisecond) TinyTick
        ]
