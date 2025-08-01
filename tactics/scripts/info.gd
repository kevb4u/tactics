class_name Info

class Info1:
	var arg0
	
	func _init(_arg0) -> void:
		arg0 = _arg0


class Info2 extends Info1:
	var arg1
	
	func _init(_arg0, _arg1) -> void:
		super(_arg0)
		arg1 = _arg1


class Info3 extends Info2:
	var arg2
	
	func _init(_arg0, _arg1, _arg2) -> void:
		super(_arg0, _arg1)
		arg2 = _arg2
