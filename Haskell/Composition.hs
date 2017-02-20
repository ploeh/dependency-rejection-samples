module Composition where

import Control.Monad.Trans (liftIO)
import Control.Monad.Trans.Maybe (MaybeT(..), runMaybeT)
import MaitreD
import DB

connectionString :: ConnectionString
connectionString = ""

tryAcceptComposition :: Reservation -> IO (Maybe Int)
tryAcceptComposition reservation = runMaybeT $
  liftIO (DB.readReservations connectionString $ date reservation)
  >>= MaybeT . return . flip (tryAccept 10) reservation
  >>= liftIO . DB.createReservation connectionString
