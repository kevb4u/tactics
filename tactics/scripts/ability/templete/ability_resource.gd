class_name AbilityResource extends Resource

@export var ability_name: String
@export var ability_range: Script
@export var ability_area: Script
@export var ability_cost: int
@export_enum("Physical", "Magic") var ability_power_type
@export var ability_power: int

@export_category("Ability Components")
@export var ability_components: Array[AbilityComponentResource]
