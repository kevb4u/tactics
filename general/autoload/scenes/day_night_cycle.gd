class_name DayNightCycle extends CanvasModulate

const MINUTES_PER_DAY: int = 1440
const MINUTES_PER_HOUR: int = 60
const INGAME_TO_REAL_MINUTE_DURATION: float = (2 * PI) / MINUTES_PER_DAY

signal time_tick(day: int, hour: int, minutes: int)

@export var gradient: GradientTexture1D
@export var INGAME_SPEED: float = 1.0 # TODO: ADD THIS INTO AI CLOCK SPEED
@export var INITIAL_HOUR: float = 5.75

var time: float = 0.0
var past_minute: float = -1.0

static var time_key: FastKey = FastKey.get_or_register_key("time")
var shared_blackboard: BlackboardManager.Blackboard

func _ready() -> void:
	shared_blackboard = BlackboardManager.get_shared_blackboard(time_key.hashed_key)
	time = INITIAL_HOUR * MINUTES_PER_HOUR * INGAME_TO_REAL_MINUTE_DURATION


func _process(delta: float) -> void:
	time += delta * INGAME_TO_REAL_MINUTE_DURATION / INGAME_SPEED
	var value: float = (sin(time - PI / 2) + 1.0) / 2.0
	self.color = gradient.gradient.sample(value)
	_recalculate_time()


func _recalculate_time() -> void:
	var total_minutes: int = int(time / INGAME_TO_REAL_MINUTE_DURATION)
	
	var day: int = int(total_minutes / MINUTES_PER_DAY)
	
	var current_day_minutes: int = total_minutes % MINUTES_PER_DAY
	
	var hour: int = int(current_day_minutes / MINUTES_PER_HOUR)
	var minutes: int = int(current_day_minutes % MINUTES_PER_HOUR)
	
	if past_minute != minutes:
		past_minute = minutes
		shared_blackboard.set_value(time_key, time)
		time_tick.emit(day, hour, minutes)
