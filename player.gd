extends Area2D

@onready var shield = $Shield  # 取得盾牌節點
var distance = 200         # 盾牌與玩家的距離

func _process(_delta):
	# 偵測輸入並移動盾牌位置 (不旋轉)
	if Input.is_action_pressed("move_up"):
		shield.position = Vector2(0, -distance)
		shield.rotation_degrees = 0
	elif Input.is_action_pressed("move_down"):
		shield.position = Vector2(0, distance)
		shield.rotation_degrees = 180
	elif Input.is_action_pressed("move_left"):
		shield.position = Vector2(-distance, 0)
		shield.rotation_degrees = 270
	elif Input.is_action_pressed("move_right"):
		shield.position = Vector2(distance, 0)
		shield.rotation_degrees = 90
