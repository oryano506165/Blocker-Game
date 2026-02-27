extends Area2D

var speed = 350
var direction = Vector2.ZERO

func _process(delta):
	position += direction * speed * delta

func _on_area_entered(area):
	if area.name == "Shield":
		# --- 撞到盾牌死亡：要在這裡存最高分 ---
		var scoreboard = get_tree().current_scene.find_child("ScoreBoard", true, false)
		if scoreboard:
			if scoreboard.score > GameManager.high_score:
				GameManager.high_score = scoreboard.score
		
		# 顯示 Game Over
		var main_node = get_tree().current_scene
		var label = main_node.find_child("GameOverLabel", true, false)
		if label:
			label.visible = true
		get_tree().paused = true
		
	elif area.name == "Player":
		# --- 撞到玩家得分 ---
		var scoreboard = get_tree().current_scene.find_child("ScoreBoard", true, false)
		if scoreboard:
			scoreboard.add_point()
		queue_free()
