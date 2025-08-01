class_name ExperienceManager extends Resource

const min_level_bonus: float = 1.5
const max_level_bonus: float = 0.5

static func award_experience(amount: int, party: Array[Node]):
	# Grab a list of all of the rank components from our hero party
	var ranks: Array[Rank] = []
	for unit in party:
		var r:Rank = unit.get_node("Rank")
		if(r != null):
			ranks.append(r)
	
	# Step 1: determine the range in actor level stats
	var min: int = 999999 
	var max: int = -999999
	
	for rank in ranks:
		min = min(rank.LVL, min)
		max = max(rank.LVL, max)
		
	# Step 2: weight the amount to award per actor based on their level
	var weights: Array[float] = []
	weights.resize(ranks.size())
	var summed_weights: float = 0
	
	for i in ranks.size():
		var percent: float = (float)(ranks[i].LVL - min + 1) / (float)(max - min + 1)
		weights[i] = lerp(min_level_bonus, max_level_bonus, percent)
		summed_weights += weights[i]
		
	# Step 3: hand out the weighted award
	# TODO: Fix lost experience
	var total :int = 0
	for i in ranks.size():
		var sub_amount: int = floori((weights[i] / summed_weights) * amount)
		ranks[i].EXP += sub_amount
		total += sub_amount
	#print(amount)
	#print(total)
