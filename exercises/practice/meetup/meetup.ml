open Base
open CalendarLib

type schedule = First | Second | Third | Fourth | Teenth | Last

type weekday = Monday | Tuesday | Wednesday | Thursday
             | Friday | Saturday | Sunday

(* result type (year, month, day_of_month) *)
type date = (int * int * int)

let meetup_day schedule weekday ~year ~month =
  failwith "'meetup_day' is missing"
