module MaitreD where

import Data.Time (ZonedTime (..), TimeZone (..))

data Reservation =
  Reservation { date :: ZonedTime, quantity :: Int, isAccepted :: Bool }
  deriving (Show, Eq)

instance Eq ZonedTime where
  ZonedTime t (TimeZone z _ _) == ZonedTime t' (TimeZone z' _ _) =
    t == t' && z == z'

tryAccept :: Int -> [Reservation] -> Reservation -> Maybe Reservation
tryAccept capacity reservations reservation =
  let reservedSeats = sum $ map quantity reservations
  in  if reservedSeats + quantity reservation <= capacity
      then Just $ reservation { isAccepted = True }
      else Nothing
