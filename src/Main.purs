module Main where

import Control.Monad.Eff
import Data.Either
import Data.Foreign
import Data.Foreign.Class
import DOM
import qualified Control.Monad.JQuery as J

import Lib

foreign import data Popup :: !

foreign import myAlert
  """
  function myAlert(msg) {
    return function() {
      alert(msg)
    }
  }
  """ :: forall eff. String -> Eff (popup :: Popup | eff) Unit

find :: forall eff. String -> Eff (dom :: DOM | eff) J.JQuery 
find sel = J.body >>= J.find sel

getTextValue :: forall eff. J.JQuery -> Eff (dom :: DOM | eff) String
getTextValue el = J.getValue el >>= return <<< either (const "") id <<< read

main = J.ready do
  nameField <- find "input[name=name]"
  submit <- find "input[type=submit]"

  J.on "click" (\_ _ -> getTextValue nameField >>= myAlert <<< calculateFPName) submit
