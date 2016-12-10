module Ploeh.Samples.MaîtreD

open System

type Reservation = {
    Date : DateTimeOffset
    Quantity : int
    IsAccepted : bool
}

// int -> (DateTimeOffset -> Reservation list) -> (Reservation -> int) -> Reservation
// -> int option
let tryAccept capacity readReservations createReservation reservation =
    let reservedSeats =
        readReservations reservation.Date |> List.sumBy (fun x -> x.Quantity)
    if reservedSeats + reservation.Quantity <= capacity
    then createReservation { reservation with IsAccepted = true } |> Some
    else None
