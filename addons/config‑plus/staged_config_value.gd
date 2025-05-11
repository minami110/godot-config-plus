class_name StagedConfigValue extends BaseConfigValue
## ステージング版

# ----- Signals -----
signal staged_changed(new_value: Variant)

# ----- Private -----
var __current: Variant
var __staged: Variant

# ----- Public -----
func _init(in_default_value: Variant) -> void:
	super._init(in_default_value)
	__current = in_default_value
	__staged = in_default_value

func is_staging() -> bool: return __staged != __current

## Get's the staged value
func get_staged() -> Variant: return __staged

## Set the staged value, INeeds apply_staged
func set_staged(v: Variant) -> void:
	_validate(v)

	if __staged != v:
		__staged = v
		staged_changed.emit(__staged)


## Apply the staged to commited
func apply_staged() -> void:
	if is_staging():
		__current = __staged
		current_changed.emit(__current)


## Revert staged to commited
func revert_staged() -> void:
	if is_staging():
		__staged = __current
		staged_changed.emit(__current)

## Subscribes callable to the **current_changed** signal and immediately
## invokes it once with the current commited value
func subscribe_current(callable: Callable) -> void:
	if current_changed.is_connected(callable) == false:
		current_changed.connect(callable)
		callable.call(get_current())

## Disconnect callable from the **current_changed** signal
func unsubscribe_current(callable: Callable) -> void:
	if current_changed.is_connected(callable):
		current_changed.disconnect(callable)


# Overrides
func get_current() -> Variant: return __current
func _on_revert_default(v: Variant) -> void:
	set_staged(v)


# ----- Private -----
func _to_string() -> String:
	return "%s(Staged:%s/Default:%s):<StagedConfigValue#%d>" % [__current, __staged, __default, get_instance_id()]
