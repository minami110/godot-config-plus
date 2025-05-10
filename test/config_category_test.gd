extends GdUnitTestSuite


func test_standard0() -> void:
	var tmp_dir := OS.get_temp_dir()
	var config_path := tmp_dir.path_join("test_config_0.cfg")

	# すでに存在してる Config を空にする
	var cfg1 := ConfigFile.new()
	cfg1.save(config_path)


	# デフォルトの値の確認
	var global1 := GlobalCategory.new(cfg1)
	assert_bool(global1.is_development.get_current()).is_false()
	assert_int(global1.foo.get_current()).is_equal(2)

	# 値を書き込んで保存する
	global1.is_development.set_current(true)
	global1.foo.set_current(3)
	cfg1.save(config_path)

	# 新しく読み込む
	var cfg2 := ConfigFile.new()
	cfg2.load(config_path)
	var global2 := GlobalCategory.new(cfg2)
	assert_bool(global2.is_development.get_current()).is_true()
	assert_int(global2.foo.get_current()).is_equal(3)

	# 鯛を書き込んで保存する
	global2.foo.reset_to_default()
	cfg2.save(config_path)


class GlobalCategory extends BaseConfigCategory:
	func _init(config_file: ConfigFile) -> void:
		super._init(config_file, "global")


	var is_development: LiveConfigValue:
		get:
			return _get_live("is_development", false)

	var locale: LiveConfigValue:
		get:
			return _get_live("locale", "ja_JP")

	var foo: LiveConfigValue:
		get:
			return _get_live("foo", 2)
