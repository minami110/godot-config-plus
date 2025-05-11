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
	global1.is_development.set_staged(true)
	global1.foo.set_staged(3)

	global1.apply_all_staged()
	cfg1.save(config_path)

	# 新しく読み込む
	var cfg2 := ConfigFile.new()
	cfg2.load(config_path)
	var global2 := GlobalCategory.new(cfg2)
	assert_bool(global2.is_development.get_current()).is_true()
	assert_int(global2.foo.get_current()).is_equal(3)

	# 値を書き込んで保存する
	global2.foo.reset_to_default()
	global2.foo.apply_staged()
	cfg2.save(config_path)


class GlobalCategory extends BaseConfigCategory:
	func _init(config_file: ConfigFile) -> void:
		super._init(config_file, "global")


	var is_development: StagedConfigValue:
		get:
			return _get_staged("is_development", false)

	var locale: StagedConfigValue:
		get:
			return _get_staged("locale", "ja_JP")

	var foo: StagedConfigValue:
		get:
			return _get_staged("foo", 2)
