class_name BaseConfigCategory extends RefCounted

var __file: ConfigFile
var __section: String
var __map: Dictionary[String, BaseConfigValue] = {}


func _init(config_file: ConfigFile, section: String) -> void:
	__file = config_file
	__section = section

# ----- Public -----

func reset_all_to_default() -> void:
	for v: BaseConfigValue in __map.values():
		v.reset_to_default()

func apply_all_staged() -> void:
	for v: BaseConfigValue in __map.values():
		if v is StagedConfigValue:
			v.apply_staged()

func revert_all_staged() -> void:
	for v: BaseConfigValue in __map.values():
		if v is StagedConfigValue:
			v.revert_staged()


# ----- Protected -----

##
func _get_live(key: String, default: Variant) -> LiveConfigValue:
	return __get_config_value(key, default, &"live")

##
func _get_staged(key: String, default: Variant) -> StagedConfigValue:
	return __get_config_value(key, default, &"staged")


# ----- Private -----

# ConfigValue の Current が変更された
# NOTE: Staged のばあいは Apply が呼ばれた
func __changed_current_value(new_value: Variant, key: String) -> void:
	# デフォルトから変更されている場合は書き込む
	var config_value := __map[key]
	if config_value.is_modified():
		__file.set_value(__section, key, new_value)
		return

	# デフォルトの場合は書き込まないで良いので消す
	if __file.has_section_key(__section, key):
		__file.erase_section_key(__section, key)
		return

	# そもそも存在していない場合はなにもしない


func __get_config_value(key: String, default: Variant, cls: StringName) -> BaseConfigValue:
	if __map.has(key):
		return __map[key]

	var new_config_value: BaseConfigValue
	if cls == &"live":
		new_config_value = LiveConfigValue.new(default)
	elif cls == &"staged":
		new_config_value = StagedConfigValue.new(default)
	else:
		assert(false, "Invalid program. missing class: %s" % cls)

	__map[key] = new_config_value

	# すでに保存されている値があればもらう
	if __file.has_section_key(__section, key):
		var raw: Variant = __file.get_value(__section, key)

		if new_config_value is LiveConfigValue:
			new_config_value.set_current(raw)

		elif new_config_value is StagedConfigValue:
			new_config_value.set_staged(raw)
			new_config_value.apply_staged()

	# 値の変更を検知する
	new_config_value.current_changed.connect(__changed_current_value.bind(key))
	return new_config_value
