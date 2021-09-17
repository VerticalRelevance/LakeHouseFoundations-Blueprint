"""

Assume we have 100 patients with hourly vital sign data. ~ 2400 data points.
This number could scale by 10x or whatever is needed.

Perhaps just a patient number.

Most of them have normal vital signs, but some have problems like:

 - Rising BP or heart rate
 - Rising Temp
 - Falling O2


    For each fake_patient:
    BP - Blood Pressure
    BT - Body Temperature
    HR - Heart Rate
    RR - Respiration Rate
    O2 = Oxygen Saturation (95 - 100 is normal. Below 90 => Low)
    Latitude & Longitude

"""