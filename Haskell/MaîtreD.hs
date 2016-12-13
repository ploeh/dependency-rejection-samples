module MaîtreD where

import Data.Time (ZonedTime)

data Reservation =
  Reservation { date :: ZonedTime, quantity :: Int, isAccepted :: Bool }
  deriving (Show)

tryAccept :: Int -> [Reservation] -> Reservation -> Maybe Reservation
tryAccept capacity reservations reservation =
  let reservedSeats = sum $ map quantity reservations
  in  if reservedSeats + quantity reservation <= capacity
      then Just $ reservation { isAccepted = True }
      else Nothing
