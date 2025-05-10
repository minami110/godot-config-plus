extends GdUnitTestSuite


func test_standard0() -> void:
	# 生成のテスト
	var c1 := StagedConfigValue.new(10)
	assert_int(c1.get_default()).is_equal(10)
	assert_int(c1.get_staged()).is_equal(10)
	assert_int(c1.get_current()).is_equal(10)
	assert_bool(c1.is_staging()).is_false()

	c1.set_staged(20)
	assert_int(c1.get_default()).is_equal(10)
	assert_int(c1.get_staged()).is_equal(20)
	assert_int(c1.get_current()).is_equal(10)
	assert_bool(c1.is_staging()).is_true()

	c1.apply_staged()
	assert_int(c1.get_default()).is_equal(10)
	assert_int(c1.get_staged()).is_equal(20)
	assert_int(c1.get_current()).is_equal(20)
	assert_bool(c1.is_staging()).is_false()

	c1.set_staged(30)
	c1.set_staged(40)
	assert_int(c1.get_default()).is_equal(10)
	assert_int(c1.get_staged()).is_equal(40)
	assert_int(c1.get_current()).is_equal(20)
	assert_bool(c1.is_staging()).is_true()

func test_revert_staged() -> void:
	var c1 := StagedConfigValue.new(10)

	c1.set_staged(20)
	c1.apply_staged()

	c1.set_staged(30)
	c1.revert_staged()

	assert_int(c1.get_default()).is_equal(10)
	assert_int(c1.get_staged()).is_equal(20)
	assert_int(c1.get_current()).is_equal(20)
	assert_bool(c1.is_staging()).is_false()

func test_reset_to_default() -> void:
	var c1 := StagedConfigValue.new(10)

	c1.set_staged(20)
	c1.apply_staged()
	c1.reset_to_default()

	assert_int(c1.get_default()).is_equal(10)
	assert_int(c1.get_staged()).is_equal(10)
	assert_int(c1.get_current()).is_equal(20)
	assert_bool(c1.is_staging()).is_true()

func test_signal_staged_changed() -> void:
	var result := []
	var callback := func(x: Variant) -> void:
		result.push_back(x)

	var c1 := StagedConfigValue.new(10)
	c1.staged_changed.connect(callback)

	c1.set_staged(20)
	c1.set_staged(20)
	c1.set_staged(30)
	c1.apply_staged()

	c1.set_staged(40)
	c1.reset_to_default()

	assert_array(result).is_equal([20, 30, 40, 10])

func test_current_changed() -> void:
	var result := []
	var callback := func(x: Variant) -> void:
		result.push_back(x)

	var c1 := StagedConfigValue.new(10)
	c1.current_changed.connect(callback)

	c1.set_staged(20)
	c1.set_staged(20)
	c1.set_staged(30)
	c1.apply_staged()

	c1.set_staged(40)
	c1.reset_to_default()
	c1.apply_staged()

	assert_array(result).is_equal([30, 10])
