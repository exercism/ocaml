let leap_year year =
  (year mod 400 = 0) ||
    (year mod 4 = 0 && year mod 100 <> 0)
