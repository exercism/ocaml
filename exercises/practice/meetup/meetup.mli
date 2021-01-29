type schedule = First | Second | Third | Fourth | Teenth | Last

type weekday = Monday | Tuesday | Wednesday | Thursday | Friday | Saturday | Sunday

type date = (int * int * int)

val meetup_day : schedule -> weekday -> year:int -> month:int -> date
