module Composition where

import MaîtreD
import DB

connectionString :: ConnectionString
connectionString = ""

-- Doesn't compile; that's the whole point!
tryAcceptComposition :: Reservation -> IO (Maybe Int)
tryAcceptComposition reservation =
  let read = DB.readReservations connectionString
      create = DB.createReservation connectionString
  in tryAccept 10 read create reservation
