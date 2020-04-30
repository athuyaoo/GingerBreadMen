extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	DataResource.load_player()
	DataResource.load_settings()



func _on_Button_pressed():
	DataFunctions.lose_health(10)


func _on_Button2_pressed():
	DataResource.save_player()
	DataResource.save_settings()
	get_tree().quit()


func _on_Button3_pressed():
	DataFunctions.add_health(10)
