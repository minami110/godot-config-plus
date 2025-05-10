class_name LiveConfigValue extends BaseConfigValue
## 即時反映版

var __current: Variant

##
func _init(default_value: Variant) -> void:
	super._init(default_value)
	__current = default_value


func set_current(new_value: Variant) -> void:
	_validate(new_value)

	if __current != new_value:
		__current = new_value
		current_changed.emit(__current)

# Overrides
func get_current() -> Variant:
	return __current

func _on_revert_default(v: Variant) -> void:
	if __current != v:
		__current = v
		current_changed.emit(__current)


func _to_string() -> String:
	return "%s(Default:%s):<ConfigValue#%d>" % [__current, __default, get_instance_id()]
