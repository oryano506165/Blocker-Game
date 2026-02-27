extends Area2D

var speed = 350 # 可以設快一點點，增加干擾效果
var direction = Vector2.ZERO

func _process(delta):
	position += direction * speed * delta

func _on_area_entered(area):
	# 只要碰到盾牌 (Shield) 或 玩家 (Player)
	if area.name == "Shield" or area.name == "Player":
		queue_free() # 單純消失，不執行任何加分或死亡邏輯
