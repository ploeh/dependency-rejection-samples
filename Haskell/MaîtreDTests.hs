{-# OPTIONS_GHC -fno-warn-orphans #-}

module MaîtreDTests
    ( tryAcceptBehavesCorrectlyWhenItCanAccept
    , tryAcceptBehavesCorrectlyWhenItCanNotAccept
    ) where

import           Control.Monad      (liftM2)
import           Data.Maybe         (isNothing)
import           Data.Time          (LocalTime (..), ZonedTime (..),
                                     defaultTimeLocale, iso8601DateFormat,
                                     midnight, parseTimeOrError, utc)
import           Data.Time.Calendar (fromGregorian, gregorianMonthLength)
import           MaîtreD
import           Test.QuickCheck
import           Text.Printf        (printf)

instance Arbitrary ZonedTime where
  arbitrary = do
    y <- choose (1, 9999)
    m <- choose (1, 12)
    d <- choose (1, gregorianMonthLength y m)
    return $ ZonedTime (LocalTime (fromGregorian y m d) midnight) utc

genReservation :: Gen Reservation
genReservation = do
  bookingDate <- arbitrary
  Positive qt <- arbitrary
  trueOrFalse <- arbitrary
  return Reservation
    { date       = bookingDate
    , quantity   = qt
    , isAccepted = trueOrFalse }

sumBy :: Num a => (b -> a) -> [b] -> a
sumBy x xs = sum $ map x xs

tryAcceptBehavesCorrectlyWhenItCanAccept :: NonNegative Int -> Property
tryAcceptBehavesCorrectlyWhenItCanAccept (NonNegative excessCapacity) =
  forAll
    (liftM2 (,) genReservation $ listOf genReservation)
    (\(reservation, reservations) ->
      let capacity =
            excessCapacity
            + sumBy quantity reservations
            + quantity reservation

          actual = tryAccept capacity reservations reservation

      in Just (reservation { isAccepted = True }) == actual)

tryAcceptBehavesCorrectlyWhenItCanNotAccept :: Positive Int -> Property
tryAcceptBehavesCorrectlyWhenItCanNotAccept (Positive lackingCapacity) =
  forAll
    (liftM2 (,) genReservation $ listOf genReservation)
    (\(reservation, reservations) ->
      let capacity = sumBy quantity reservations - lackingCapacity

          actual = tryAccept capacity reservations reservation

      in isNothing actual)
