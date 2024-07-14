extends Control

@onready var numberCoinsText = $NumberCoinsLabel
@onready var numberHPText = $HPlabel

func _process(_delta):
	numberCoinsText.text = str(Global.coins)
	numberHPText.text = str(Global.player.HP)
	
