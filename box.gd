extends Area2D

var speed = 350
var direction = Vector2.ZERO

func _process(delta):
	position += direction * speed * delta

func _on_area_entered(area):
	if area.name == "Shield":
		# 1. 尋找 ScoreBoard (CanvasLayer) 並執行加分
		var scoreboard = get_tree().current_scene.find_child("ScoreBoard", true, false)
		if scoreboard:
			scoreboard.add_point()
		
		queue_free() # 方塊消失
		
	elif area.name == "Player":
		# 1. 更新最高分紀錄
		var scoreboard = get_tree().current_scene.find_child("ScoreBoard", true, false)
		if scoreboard:
			# 檢查當前分數是否打破紀錄
			if scoreboard.score > GameManager.high_score:
				GameManager.high_score = scoreboard.score
		
		# 2. 顯示 Game Over 文字
		var main_node = get_tree().current_scene
		var label = main_node.find_child("GameOverLabel", true, false)
		if label:
			label.visible = true
		
		# 3. 暫停遊戲
		get_tree().paused = true
		print("遊戲結束！最高分已紀錄：", GameManager.high_score)
