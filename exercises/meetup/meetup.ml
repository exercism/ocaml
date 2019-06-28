open Base
open CalendarLib

type schedule = First | Second | Third | Fourth | Teenth | Last

type weekday = Monday | Tuesday | Wednesday | Thursday
             | Friday | Saturday | Sunday

type date = (int * int * int)

let diff_days (d1: weekday) (d2: weekday): int =
  let weekday_to_int = function
    | Monday -> 0
    | Tuesday -> 1
    | Wednesday -> 2
    | Thursday -> 3
    | Friday -> 4
    | Saturday -> 5
    | Sunday -> 6 in
  (weekday_to_int d1 - weekday_to_int d2) % 7

let day_of_week (d: Date.t): weekday =
  match Date.day_of_week d with
  | Sun -> Sunday
  | Mon -> Monday
  | Tue -> Tuesday
  | Wed -> Wednesday
  | Thu -> Thursday
  | Fri -> Friday
  | Sat -> Saturday

let schedule_to_int = function
  | First -> 0
  | Second -> 1
  | Third -> 2
  | Fourth -> 3
  | Teenth -> 4
  | Last -> 5

let add_days base days =
  Date.Period.day days |> Date.add base 

let meetup_day schedule weekday ~year ~month =
  let base = Date.make year month 1 in
  let calc_offset start = start + diff_days weekday (add_days base start |> day_of_week) in
  let day = calc_offset @@ match schedule with
    | Teenth -> 12
    | Last -> 21 + max 0 (Date.days_in_month base - 28)
    | _ -> 7 * schedule_to_int schedule in
  let core_date = add_days base day
  in (Date.year core_date,
      Date.month core_date |> Date.int_of_month,
      Date.day_of_month core_date)
