-- Dirty, lying module that pretends to implement real SQL operations
module DB where

import Data.Time (ZonedTime)
import MaîtreD

type ConnectionString = String

readReservations :: ConnectionString -> ZonedTime -> IO [Reservation]
readReservations _ _ = return []

createReservation :: ConnectionString -> Reservation -> IO Int
createReservation _ _ = return 0
