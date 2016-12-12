module Ploeh.Samples.Composition

// Dirty, lying module that pretends to implement real SQL operations
module DB =
    let readReservations connectionString date = []
    let createReservation connectionString reservation = 0

open MaîtreD

// More pretension
let connectionString = ""

// Reservation -> int option
let tryAcceptComposition reservation =
    match tryAccept 10 (DB.readReservations connectionString) reservation with
    | None -> None
    | Some r -> (DB.createReservation connectionString) r |> Some
