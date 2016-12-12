module Ploeh.Samples.MaîtreDTests

open Ploeh.Samples.MaîtreD
open FsCheck
open FsCheck.Xunit
open Swensen.Unquote

// 'Guard' composition. Returns the return value if ``assert`` doesn't throw.
let (>>!) ``assert`` returnValue x =
    ``assert`` x
    returnValue

module Tuple2 =
    let curry f x y = f (x, y)

module Gen =
    let reservation = gen {
        let! PositiveInt quantity = Arb.generate
        let! reservation = Arb.generate
        return { reservation with Quantity = quantity } }

[<Property(QuietOnSuccess = true)>]
let ``tryAccept behaves correctly when it can accept``
    (NonNegativeInt excessCapacity) =
    Tuple2.curry id
    <!> Gen.reservation
    <*> Gen.listOf Gen.reservation
    |>  Arb.fromGen |> Prop.forAll <| fun (reservation, reservations) ->
    let capacity =
        excessCapacity
        + (reservations |> List.sumBy (fun x -> x.Quantity))
        + reservation.Quantity
    let readReservations = ((=!) reservation.Date) >>! reservations

    let actual = tryAccept capacity readReservations reservation

    Some { reservation with IsAccepted = true } =! actual

[<Property(QuietOnSuccess = true)>]
let ``tryAccept behaves correctly when it can't accept``
    (PositiveInt lackingCapacity) =
    Tuple2.curry id
    <!> Gen.reservation
    <*> Gen.listOf Gen.reservation
    |>  Arb.fromGen |> Prop.forAll <| fun (reservation, reservations) ->
    let capacity =
        (reservations |> List.sumBy (fun x -> x.Quantity)) - lackingCapacity
    let readReservations _ = reservations

    let actual = tryAccept capacity readReservations reservation

    None =! actual
