@tool
extends Button
var path = "res://tactics/data/jobs/"

func _on_pressed() -> void:
	var error = DirAccess.make_dir_recursive_absolute(path)
	if error != 0:
		print("Error Creating Directory. Error Code: " + str(error))
	parse_starting_stats(get_data("res://tactics/scripts/stats/jobs/job_starting_stats.csv"))
	parse_growth_stats(get_data("res://tactics/scripts/stats/jobs/job_growth_stats.csv"))


## will break up our .csv file into a dictionary that we can use in our functions.
## Each line is broken down into a single dictionary entry with 
## with an array of each item on the line.
func get_data(path: String) -> Dictionary:
	var maindata = {}
	var file = FileAccess.open(path,FileAccess.READ)
	while !file.eof_reached():
		var data_set = Array(file.get_csv_line())
		maindata[maindata.size()] = data_set
	file.close()
	return maindata


func parse_starting_stats(data) -> void:
	for item in data.keys():
		## we skip key “0” because that column in our spreadsheet
		## is just the labels of the stat types.
		if item == 0:
			continue
		
		## just the single line in our spreadsheet for the current job we are looping on
		var elements: Array = data[item]
		
		## Index “0” on our array is the string representing our Job name
		var scene: PackedScene = get_or_create(elements[0])
		var job = scene.instantiate()

		for i in job.stat_order.size():
			if elements[i+1].is_empty():
				continue
			job.base_stats[i] = int(elements[i+1])
		
		var evade: StatModifierFeature = get_feature(job, StatTypes.Stat.EVD)
		evade.amount = int(elements[8])
		evade.name = "SMF_EVD"
		
		var res: StatModifierFeature = get_feature(job, StatTypes.Stat.RES)
		res.amount = int(elements[9])
		res.name = "SMF_RES"
		
		var move: StatModifierFeature = get_feature(job, StatTypes.Stat.MOV)
		move.amount = int(elements[10])
		move.name = "SMF_MOV"
		
		var jump: StatModifierFeature = get_feature(job, StatTypes.Stat.JMP)
		jump.amount = int(elements[11])
		jump.name = "SMF_JMP"
		
		scene.pack(job)
		ResourceSaver.save(scene, path + elements[0] + ".tscn")


func parse_growth_stats(data) -> void:
	for item in data.keys():
		if item == 0:
			continue
		var elements: Array = data[item]
		
		var scene: PackedScene = get_or_create(elements[0])
		var job = scene.instantiate()

		for i in job.stat_order.size():
			job.grow_stats[i] = float(elements[i+1])
		
		scene.pack(job)
		ResourceSaver.save(scene, path + elements[0] + ".tscn")


func get_or_create(job_name: String):
	var full_path: String = path + job_name + ".tscn"
	if ResourceLoader.exists(full_path):
		return load(full_path)
	else:
		return create(full_path)


func create(full_path: String):
	var job:Job = Job.new()
	job.name = "Job"
	var scene:PackedScene = PackedScene.new()
	scene.pack(job)
	ResourceSaver.save(scene, full_path)
	return scene


func get_feature(job: Job, type: StatTypes.Stat):
	var node_array:Array[Node] = job.get_children()
	var filtered_array = node_array.filter(func(node):return node is Feature)
	
	for smf in filtered_array:
		if smf.type == type:
			return smf
	
	var feature: StatModifierFeature = StatModifierFeature.new()
	feature.type = type
	job.add_child(feature)
	feature.set_owner(job)
	return feature
