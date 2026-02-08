extends Item
class_name Level_Up

var stat_name : String
var stat_amount : int

func buy():
	var old_stat_value = PlayerStats.get(stat_name)
	PlayerStats.set(stat_name, old_stat_value + stat_amount)
	
