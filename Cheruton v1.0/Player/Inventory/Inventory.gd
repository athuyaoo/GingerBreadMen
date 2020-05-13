extends Control

var count = 0
var active_tab
var active_tab_items
var active_tab_inspector

signal tab_changed(next_tab)

onready var active_tab_image = preload("res://Player/Inventory/Icons/Button_Bg/inventory_bg_keypress.png")
onready var default_tab_image = preload("res://Player/Inventory/Icons/Button_Bg/inventory_bg.png")

onready var tab = "BorderBackground/InnerBackground/VBoxContainer/MElements/Tabs"
onready var list = "BorderBackground/InnerBackground/VBoxContainer/MElements"

func _ready():
	DataResource.dict_settings.game_on = false
	$BorderBackground/InnerBackground/VBoxContainer/MElements/Tabs/Coins/CoinsVal.text = str(DataResource.temp_dict_player["coins"])
	load_data()

	connect("tab_changed", self, "change_tab_state")
	emit_signal("tab_changed", "Weapons")

	# Hide initbar() to view inventory directly
	$BorderBackground/InnerBackground/VBoxContainer/MElements/Tabs/ExpBar.initbar()
	$BorderBackground/InnerBackground/VBoxContainer/MElements/Tabs/HealthBar.initbar()

func load_data():
	# Get data according to relevant sections
	#Weapons
	
	pass

func item_inspector_default():
	#show stats of current item - only for weapon/apparel
	#show description of current item - rest
	pass

func item_inspector_new():
	#show description of item hovered upon
	pass
#
func change_active_tab(new_tab, items_list, insp_panel):
	# Set current tab to default colour and hide its items
	if(active_tab):
		active_tab.set_normal_texture(default_tab_image)
		active_tab_items.hide()
		active_tab_inspector.hide()

	# Set new active tab and its colour and show its items
	active_tab = new_tab
	active_tab_items = items_list
	active_tab_inspector = insp_panel
	
	active_tab.set_normal_texture(active_tab_image)
	active_tab_items.show()
	active_tab_inspector.show()

func change_tab_state(next_tab):
	if(next_tab == "Weapons"):
		change_active_tab(get_node(tab + "/Weapons/Weapons"), get_node(list + "/Weapons"), get_node(list + "/InspWeapons")) 
	elif(next_tab == "Apparel"):
		change_active_tab(get_node(tab + "/Apparel/Apparel"), get_node(list + "/Apparel"), get_node(list + "/InspApparel"))

	elif(next_tab == "Consum"):
		change_active_tab(get_node(tab + "/Consum/Consum"), get_node(list + "/Consum"), get_node(list + "/InspConsum"))

	elif(next_tab == "Misc"):
		change_active_tab(get_node(tab + "/Misc/Misc"), get_node(list + "/Misc"), get_node(list + "/InspMisc"))

	elif(next_tab == "Key Items"):
		change_active_tab(get_node(tab + "/KeyItems/KeyItems"), get_node(list + "/KeyItems"), get_node(list + "/InspKeyItems"))
	
	if(next_tab):
		print("Current Tab: ")
		print(next_tab)

func _on_Weapons_pressed():
	emit_signal("tab_changed", "Weapons")

func _on_Apparel_pressed():
	emit_signal("tab_changed", "Apparel")

func _on_Consum_pressed():
	emit_signal("tab_changed", "Consum")

func _on_Misc_pressed():
	emit_signal("tab_changed", "Misc")

func _on_KeyItems_pressed():
	emit_signal("tab_changed", "Key Items")


func _on_Exit_pressed():
	free_the_inventory()

func free_the_inventory():
	DataResource.dict_settings.game_on = true
	var scene_to_free = DataResource.current_scene.get_child(DataResource.current_scene.get_child_count() - 1)
	scene_to_free.queue_free()
#func _on_Test_pressed(): # creates a double click signal and activates tooltips
#	if(count == 0):
#		$CountDown.start()
#	count += 1
#	if (count == 2):
#		count = 0
#
#func tooltips(texture):
#	$Tooltips/CurrItem.set_texture(texture)
#
#func _on_CountDown_timeout():
#	count = 0
