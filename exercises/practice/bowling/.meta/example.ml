open Base

type t = (int * int list)

let numberOfFrames = 10
let maximumFrameScore = 10
let minimumFrameScore = 0

let new_game = (0, [])

let validatePins pins = match pins with
| _ when pins < minimumFrameScore -> Error "Negative roll is invalid"
| _ when pins > maximumFrameScore -> Error "Pin count exceeds pins on the lane"
| _ -> Ok pins

let isStrike pins = pins = maximumFrameScore
let isSpare pins1 pins2 = pins1 + pins2 = maximumFrameScore

let rec scoreRolls (totalScore: int) (frame: int) (rolls: int list): (int * ((int, string) Result.t)) = 
  let isLastFrame = frame = numberOfFrames in
  let gameFinished = frame = numberOfFrames + 1 in
  let scoreStrike remainder = 
    match remainder with
    | x::y::zs when isLastFrame ->
      if x + y > 10 && x <> 10 then (frame, Error "Should have a test for this error!")
      else scoreRolls (totalScore + 10 + x + y) (frame + 1) zs
    | x::y::zs -> scoreRolls (totalScore + 10 + x + y) (frame + 1) (x::y::zs)
    | _ -> (frame, Error "Score cannot be taken until the end of the game") in
  let scoreSpare x y remainder = 
      match remainder with 
      | z::zs -> scoreRolls (totalScore + x + y + z) (frame + 1) (if isLastFrame then zs else z::zs)
      | _ -> (frame, Error "Score cannot be taken until the end of the game") in
  let scoreNormal x y remainder =
      match validatePins (x + y) with
      | Ok z -> scoreRolls (totalScore + z) (frame + 1) remainder
      | Error e -> (frame, Error e) in
  match rolls with
  | [] -> (frame, if gameFinished then Ok totalScore else Error "Score cannot be taken until the end of the game")
  | x::xs when isStrike x -> scoreStrike xs        
  | x::y::ys when isSpare x y -> scoreSpare x y ys        
  | x::y::zs -> scoreNormal x y zs       
  | _ -> (frame, Error "Score cannot be taken until the end of the game")
    
let roll pins (frames, rolls) =
  if frames >= 10
  then Error "Cannot roll after game is over"
  else  
    match validatePins pins with
    | Error e -> Error e
    | Ok _ -> 
        let rolls = rolls @ [pins] in
        match scoreRolls 0 0 rolls with
        | (frames', Error "Score cannot be taken until the end of the game") -> Ok (frames', rolls)
        | (_, Error e) -> Error e
        | (frames', Ok _) -> Ok (frames', rolls)

let score (_, frames) = 
  let (_, score) = scoreRolls 0 1 frames
  in score