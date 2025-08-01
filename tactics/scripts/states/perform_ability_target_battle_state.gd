extends BattleState

@export var cutSceneState: BattleState
@export var selectUnitState: BattleState
@export var endFacingState: BattleState
@export var commandSelectionState: BattleState

func enter() -> void:
	super()
	var ap: BaseAbilityPower = turn.ability.get_node("AbilityPower")
	ap.on_enable()
	
	turn.has_unit_acted = true
	if(turn.has_unit_moved):
		turn.lock_move = true
	
	await animate()


func exit() -> void:
	super()
	var ap: BaseAbilityPower = turn.ability.get_node("AbilityPower")
	ap.on_disable()


func animate() -> void:
	#TODO: PLAY ANIMATION
	ApplyAbility()
	
	if is_battle_over():
		_owner.state_machine.change_state(cutSceneState)
	## Change units if accidently kill themselves
	elif not unit_has_control():
		_owner.state_machine.change_state(selectUnitState)
	elif(turn.has_unit_moved):
		_owner.state_machine.change_state(endFacingState)
	else:
		_owner.state_machine.change_state(commandSelectionState)


func ApplyAbility() -> void:
	turn.ability.perform(turn.targets)


func unit_has_control() -> bool:
	for c in turn.actor.status.get_children():
		for e in c.get_children():
			if e is KnockOutStatusEffect:
				return false
	return true
