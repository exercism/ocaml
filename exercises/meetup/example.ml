open Core_kernel

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

let day_of_week (d: Date.t): weekday = let open Day_of_week in
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

let is_leap_year y =
  let divides n = y % n = 0 in
  divides 4 && (not @@ divides 100 || divides 400)

let month_length y = let open Month in function
  | Feb -> if is_leap_year y then 29 else 28
  | Apr -> 30
  | Jun -> 30
  | Sep -> 30
  | Nov -> 30
  | _ -> 31

let meetup_day schedule weekday ~year ~month =
  let month = Month.of_int_exn month in
  let base = Date.create_exn ~y:year ~m:month ~d:1 in
  let calc_offset start = start + diff_days weekday
        (Date.add_days base start |> day_of_week) in
  let day = calc_offset @@ match schedule with
    | Teenth -> 12
    | Last -> 21 + max 0 (month_length year month - 28)
    | _ -> 7 * schedule_to_int schedule in
  let core_date = Date.add_days base day
  in (Date.year core_date,
      Date.month core_date |> Month.to_int,
      Date.day core_date)
