module Ploeh.Samples.MaîtreD

open System

type Reservation = {
    Date : DateTimeOffset
    Quantity : int
    IsAccepted : bool
}

// int -> Reservation list -> Reservation -> Reservation option
let tryAccept capacity reservations reservation =
    let reservedSeats =
        reservations |> List.sumBy (fun x -> x.Quantity)
    if reservedSeats + reservation.Quantity <= capacity
    then { reservation with IsAccepted = true } |> Some
    else None
