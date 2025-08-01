class_name FixedAbilityPicker extends BaseAbilityPicker

@export var target: Targets.Target
@export var ability: String

func pick(plan: PlanOfAttack) -> void:
	plan.target = target
	plan.ability = find(ability)
	
	if plan.ability == null:
		plan.ability = default()
		plan.target = Targets.Target.Foe
