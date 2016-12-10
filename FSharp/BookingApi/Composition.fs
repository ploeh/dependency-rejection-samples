﻿module Ploeh.Samples.Composition

// Dirty, lying module that pretends to implement real SQL operations
module DB =
    let readReservations connectionString date = []
    let createReservation connectionString reservation = 0

open MaîtreD

// More pretension
let connectionString = ""

// Reservation -> int option
let tryAcceptComposition reservation =
    let read = DB.readReservations connectionString
    let create = DB.createReservation connectionString
    tryAccept 10 read create reservation