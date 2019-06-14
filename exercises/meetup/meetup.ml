type schedule = First | Second | Third | Fourth | Teenth | Last

type weekday = Monday | Tuesday | Wednesday | Thursday | Friday | Saturday | Sunday

type date = (int * int * int)

let meetup_day _ _ ~year ~month =
    failwith "'meetup_day' is missing"
