class_name BaseConfigValue extends RefCounted
##

# ----- Private -----
var __type: Variant.Type
var __default: Variant

# ----- Signals -----
@warning_ignore("unused_signal")
signal current_changed(new_value: Variant)


# Public
func _init(default_value: Variant) -> void:
	__assert_type(default_value)

	__type = typeof(default_value) as Variant.Type
	__default = default_value


## Get's the default value
func get_default() -> Variant:
	return __default

## Get the stored value Variant.Type
func get_type() -> Variant.Type:
	return __type

## Reset to default value
func reset_to_default() -> void:
	_on_revert_default(__default)


# Virtuals
## Get's the committed current value
func get_current() -> Variant:
	__assert_not_implemented()
	return null


@warning_ignore("unused_parameter")
func _on_revert_default(v: Variant) -> void:
	__assert_not_implemented()


# Helpers
static func __assert_type(v: Variant) -> void:
	var input_type := typeof(v)
	assert(input_type != TYPE_NIL, "Default value is null.")
	assert(input_type != TYPE_OBJECT, "Object is unsupported type.")
	assert(input_type != TYPE_CALLABLE, "Callable is unsupported type.")
	assert(input_type != TYPE_SIGNAL, "Signal is unsupported type.")
	assert(input_type < TYPE_MAX, "Unsupported type.")

static func __assert_not_implemented() -> void:
	assert(false, "Abstract mehod not implemented.")

func _validate(v: Variant) -> void:
	__assert_type(v)
	assert(typeof(v) == __type,
		"Type mispatch. Expected %s, got %s" % [__type, typeof(v)]
	)
