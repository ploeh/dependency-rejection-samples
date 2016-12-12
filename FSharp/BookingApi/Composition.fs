module Ploeh.Samples.Composition

// Dirty, lying module that pretends to implement real SQL operations
module DB =
    let readReservations connectionString date = []
    let createReservation connectionString reservation = 0

open MaîtreD

// More pretension
let connectionString = ""

// ('a -> 'b -> 'c) -> 'b -> 'a -> 'c
let flip f x y = f y x

// Reservation -> int option
let tryAcceptComposition reservation =
    reservation.Date
    |> DB.readReservations connectionString
    |> flip (tryAccept 10) reservation
    |> Option.map (DB.createReservation connectionString)
