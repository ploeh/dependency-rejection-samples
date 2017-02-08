module MaîtreD where

import Data.Time (ZonedTime (zonedTimeToLocalTime, zonedTimeZone))

data Reservation =
  Reservation { date :: ZonedTime, quantity :: Int, isAccepted :: Bool }
  deriving (Show)

instance Eq Reservation where
  x == y =
       zonedTimeZone        (date x) == zonedTimeZone        (date y)
    && zonedTimeToLocalTime (date x) == zonedTimeToLocalTime (date y)
    && quantity                   x  ==  quantity                  y
    && isAccepted                 x  == isAccepted                 y


tryAccept :: Int -> [Reservation] -> Reservation -> Maybe Reservation
tryAccept capacity reservations reservation =
  let reservedSeats = sum $ map quantity reservations
  in  if reservedSeats + quantity reservation <= capacity
      then Just $ reservation { isAccepted = True }
      else Nothing
