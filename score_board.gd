extends CanvasLayer

var score = 0

func _ready():
	# 遊戲開始時，顯示目前的最高分
	update_high_score_display()
	# 初始化分數文字 (抓取子節點 ScoreLabel)
	$ScoreLabel.text = "Score: 0"

func add_point():
	score += 1
	$ScoreLabel.text = "Score: " + str(score)

func update_high_score_display():
	# 抓取子節點 HighScoreLabel 並顯示 GameManager 裡的最高分
	if has_node("HighScoreLabel"):
		$HighScoreLabel.text = "Best: " + str(GameManager.high_score)

func reset_score():
	score = 0
	$ScoreLabel.text = "Score: 0"
