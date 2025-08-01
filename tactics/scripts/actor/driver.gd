class_name Driver extends Node

var normal: Drivers.Dri
var special: Drivers.Dri = Drivers.Dri.None

var current: Drivers.Dri:
	get():
		return special if special != Drivers.Dri.None else normal
