extends Node2D

# 1. 宣告與預載
var box_scene = preload("res://box.tscn")
var box2_scene = preload("res://box_2.tscn")
var box_3_scene = preload("res://box_3.tscn")

# 2. 偵測按鍵
func _process(_delta):
	if get_tree().paused and Input.is_key_pressed(KEY_R):
		get_tree().paused = false
		get_tree().reload_current_scene()

var flash_20_done = false
var flash_50_done = false
# 3. 計時器觸發 (你剛才問的那段從這裡開始)
func _on_timer_timeout():
	if get_tree().paused:
		return
	
	var scoreboard = find_child("ScoreBoard", true, false)
	var current_score = 0
	if scoreboard:
		current_score = scoreboard.score

	# --- 閃光特效判斷 ---
	# 20分閃紅光
	if current_score == 20 and not flash_20_done:
		flash_screen(Color.RED)
		flash_20_done = true
	
	# 50分閃藍光
	if current_score == 50 and not flash_50_done:
		flash_screen(Color.BLUE)
		flash_50_done = true
	# -------------------

	# --- 難度生成判斷 ---
	if current_score >= 50:
		spawn_chaos_mode()
	elif current_score >= 20:
		spawn_two_boxes()
	else:
		spawn_single_box()
		
func spawn_chaos_mode():
	# 準備四個方向 index: [0, 1, 2, 3] (上, 下, 左, 右)
	var indices = [0, 1, 2, 3]
	indices.shuffle() # 洗牌，讓出現位置隨機
	
	var player_pos = $Player.position
	
	# 生成 1 個 Box1
	var b1 = box_scene.instantiate()
	setup_box_at_index(b1, indices[0], player_pos)
	
	# 生成 1 個 Box2
	var b2 = box2_scene.instantiate()
	setup_box_at_index(b2, indices[1], player_pos)
	
	# 生成 2 個 Box3 (干擾項)
	var b3_a = box_3_scene.instantiate()
	setup_box_at_index(b3_a, indices[2], player_pos)
	
	var b3_b = box_3_scene.instantiate()
	setup_box_at_index(b3_b, indices[3], player_pos)

# 通用的全螢幕閃光函式
func flash_screen(target_color: Color):
	# 1. 讓全螢幕閃爍 (CanvasModulate)
	var filter = find_child("CanvasModulate", true, false)
	if filter:
		var tween = create_tween()
		tween.tween_property(filter, "color", target_color, 0.1)
		tween.tween_property(filter, "color", Color.WHITE, 0.2)
	
	# 2. 讓文字也變色 (新增在這裡！)
	var label = find_child("ScoreLabel", true, false)
	if label:
		label.modulate = target_color # 讓文字顏色變紅或變藍
		print("文字顏色已更改為：", target_color)

func spawn_single_box():
	var box
	if randf() > 0.3:
		box = box_scene.instantiate()
	else:
		box = box2_scene.instantiate()
	setup_box(box)

func spawn_two_boxes():
	var b1 = box_scene.instantiate()
	var b2 = box2_scene.instantiate()
	
	var target_pos = $Player.position 
	var indices = [0, 1, 2, 3]
	indices.shuffle() 
	
	setup_box_at_index(b1, indices[0], target_pos)
	setup_box_at_index(b2, indices[1], target_pos)

func setup_box(box):
	var target_pos = $Player.position
	var index = randi() % 4
	setup_box_at_index(box, index, target_pos)

func setup_box_at_index(box, index, target_pos):
	box.process_mode = Node.PROCESS_MODE_PAUSABLE
	
	# 這裡的數值要根據你的新視窗大小調整
	# 建議距離中心 500 像素，這樣方塊會在螢幕外一點點生成
	var spawn_points = [
		target_pos + Vector2(0, -600), # 上
		target_pos + Vector2(0, 600),  # 下
		target_pos + Vector2(-600, 0), # 左
		target_pos + Vector2(600, 0)   # 右
	]
	
	box.position = spawn_points[index]
	box.direction = (target_pos - box.position).normalized()
	add_child(box)
