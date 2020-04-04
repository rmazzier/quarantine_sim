extends Node

var _Minute
var _Day
var _Year

var hr
var mi
var da
var mo

var days_per_month = {"0":0,
	"1":31, "2":59, "3":90,"4":120,
	"5":151, "6":181, "7":212, "8":243,
	"9":273, "10":304, "11":334, "12":365}

func hour_to_Minute(hour, minute):
	return hour * 60 + minute
	pass

func date_to_Day(day, month):
	return days_per_month[str(month-1)] + day
	pass

func _Day_to_date(day):
	var day_out
	var month_out
	for i in range(12):
		if day > days_per_month[str(i)] and day <= days_per_month[str(i+1)]:
			month_out = i+1
	
	day_out = day - days_per_month[str(month_out -1)]
	
	return {"day":day_out, "month":month_out}
	
func _Minute_to_hour(_mins):
	return {"hour":_mins/60, "minute": _mins%60}
	pass

func update_datetime():
	"""updates the 'public' variables (mi, hr, da, mo) according to the 'private ones'
	which are 'Minute and _Day'. _Year is independent."""
	
	hr = _Minute_to_hour(_Minute)["hour"]
	mi = _Minute_to_hour(_Minute)["minute"]
	mo = _Day_to_date(_Day)["month"]
	da = _Day_to_date(_Day)["day"]
	pass

func add_minutes(amount):
	if _Minute + amount < 1440:
		_Minute += amount
	else:
		_Minute = (_Minute + amount)%1440
		add_days(1)
	update_datetime()
	#print_datetime()

func add_days(amount):
	if _Day + amount <= 365:
		_Day += amount
	else:
		_Day = (_Day + amount) % 365
		_Year += 1

func print_datetime():
	print("Hour: %d:%d, D-M-Y: %d-%d-%d"%[hr, mi, da, mo, _Year])
	print("_Minute: %d, _Day: %d"%[_Minute, _Day])
	pass

func equals(other_datetime):
	if (other_datetime._Minute == self._Minute and other_datetime._Day == self._Day and other_datetime._Year == self._Year):
		return true 
	else:
		return false

func set_datetime_implicit(_min, _day, _year):
	""" Sets the datetime passing the private (implicit) values"""
	_Minute = _min
	_Day = _day
	_Year = _year
	
	update_datetime()
	pass

func set_datetime_explicit(hour, minute, day, month, year):
	""" Sets the datetime passing the public (explicit) values """
	assert(hour <= 23 and hour >= 0)
	assert(minute <= 59 and minute >= 0)
	assert(month <= 12 and month >= 1)
	assert(day <= days_per_month[str(month)] - days_per_month[str(month-1)] and day >= 1)
	
	# directly set the "public variables"
	_Year = year
	hr = hour
	mi = minute
	da = day
	mo = month
	
	#convert the "private" variables in terms of the "public" ones
	_Minute = hour_to_Minute(hour, minute)
	_Day = date_to_Day(day, month)

	print_datetime()

func distance_between(other_datetime):
	""" Returns the distance in minutes between 2 datetimes"""
	if self._Year == other_datetime._Year:
		if self._Day == other_datetime._Day:
			return abs(self._Minute - other_datetime._Minute)
		else:
			var max_datetime = self._max(other_datetime)
			var min_datetime = self._min(other_datetime)
			return (
				1440-min_datetime._Minute +  #tempo rimasto per finire il giorno minore
				max_datetime._Minute + # tempo attuale del giorno maggiore
				(max_datetime._Day - min_datetime._Day - 1)*1440) # i minuti in tutti i giorni in mezzo
	else:
		var max_datetime = self._max(other_datetime)
		var min_datetime = self._min(other_datetime)
		return (
				525600-min_datetime._Day*1440 +  #minuti per finire l'anno minore
				max_datetime._Day*1440 + # tempo attuale del giorno maggiore
				(max_datetime._Year - min_datetime._Year - 1)*525600) # i minuti in tutti gli anni in mezzo
	

func _min(other_datetime):
	""" Returns the smaller datetime between self and other_datetime
		If they are equal, the function returns the instance on which the method
		is called."""
	if other_datetime._Year != self._Year:
		return (self if (self._Year < other_datetime._Year) else other_datetime)
	elif other_datetime._Day != self._Day:
		return (self if (self._Day < other_datetime._Day) else other_datetime)
	elif other_datetime._Minute != self._Minute:
		return (self if (self._Minute < other_datetime._Minute) else other_datetime)
	else:
		return self
	pass

func _max(other_datetime):
	""" Returns the bigger datetime between self and other_datetime
		If they are equal, the function returns the instance on which the method
		is called."""
	if other_datetime._Year != self._Year:
		return (self if (self._Year > other_datetime._Year) else other_datetime)
	elif other_datetime._Day != self._Day:
		return (self if (self._Day > other_datetime._Day) else other_datetime)
	elif other_datetime._Minute != self._Minute:
		return (self if (self._Minute > other_datetime._Minute) else other_datetime)
	else:
		return self
	pass
