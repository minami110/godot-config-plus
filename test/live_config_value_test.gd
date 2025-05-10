extends GdUnitTestSuite


func test_standard0() -> void:
	# 生成のテスト
	var c1 := LiveConfigValue.new(10)
	assert_int(c1.get_default()).is_equal(10)
	assert_int(c1.get_current()).is_equal(10)

	# 代入のテスト
	c1.set_current(20)
	assert_int(c1.get_default()).is_equal(10)
	assert_int(c1.get_current()).is_equal(20)

	c1.reset_to_default()
	assert_int(c1.get_default()).is_equal(10)
	assert_int(c1.get_current()).is_equal(10)


func test_standad1() -> void:
	var result := []
	var callback := func(x: Variant) -> void:
		result.push_back(x)

	var c1 := LiveConfigValue.new(1)
	c1.current_changed.connect(callback)
	assert_array(result).is_equal([])

	c1.set_current(2)
	c1.set_current(3)
	c1.set_current(3)
	c1.reset_to_default()
	assert_array(result).is_equal([2, 3, 1])


func test_invalid0() -> void:
	return

	@warning_ignore("unreachable_code")
	await assert_error(func() -> void:
		var c1 := LiveConfigValue.new(1)
		c1.set_current("foo")
	) \
	.is_runtime_error("Assertion failed: Type mispatch. Expected 2, got 4")
