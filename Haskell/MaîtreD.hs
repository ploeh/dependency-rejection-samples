module MaîtreD where

import Data.Time (ZonedTime)

data Reservation =
  Reservation { date :: ZonedTime, quantity :: Int, isAccepted :: Bool }
  deriving (Show)

tryAccept :: Int -> (ZonedTime -> [Reservation]) -> (Reservation -> Int) -> Reservation
             -> Maybe Int
tryAccept capacity readReservations createReservation reservation =
  let reservedSeats = sum $ map quantity $ readReservations $ date reservation
  in  if reservedSeats + quantity reservation <= capacity
      then Just $ createReservation $ reservation { isAccepted = True }
      else Nothing
