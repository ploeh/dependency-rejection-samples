#r @"packages/FAKE/tools/FakeLib.dll"

open Fake

Target "Build" <| fun _ ->
    !! "**/BookingApi.sln"
    |> MSBuildRelease "" "Rebuild"
    |> ignore

"Build"

RunTargetOrDefault "Build"
