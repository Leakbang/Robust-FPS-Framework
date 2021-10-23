extends Terminal

export (NodePath) var Target
export (String) var accepted_code

onready var code_mask = $"Viewport/GUI/Panel/keypad_menu/code"

var entered_code = ""

func _ready():
	#Main menu
	var _keycard = $"Viewport/GUI/Panel/main_menu/keycard"
	var _keypad = $"Viewport/GUI/Panel/main_menu/keypad"
	var _back = $"Viewport/GUI/Panel/back"
	
	_keycard.connect("pressed", self, "_main_menu_button", [_keycard])
	_keypad.connect("pressed", self, "_main_menu_button", [_keypad])
	_back.connect("pressed", self, "_main_menu_button", [_back])
	
	
	# Keypad menu
	var _1 = $"Viewport/GUI/Panel/keypad_menu/1"
	var _2 = $"Viewport/GUI/Panel/keypad_menu/2"
	var _3 = $"Viewport/GUI/Panel/keypad_menu/3"
	var _4 = $"Viewport/GUI/Panel/keypad_menu/4"
	var _5 = $"Viewport/GUI/Panel/keypad_menu/5"
	var _6 = $"Viewport/GUI/Panel/keypad_menu/6"
	var _7 = $"Viewport/GUI/Panel/keypad_menu/7"
	var _8 = $"Viewport/GUI/Panel/keypad_menu/8"
	var _9 = $"Viewport/GUI/Panel/keypad_menu/9"
	var _0 = $"Viewport/GUI/Panel/keypad_menu/0"
	var _star = $"Viewport/GUI/Panel/keypad_menu/*"
	var _square = $"Viewport/GUI/Panel/keypad_menu/#"
	
	_1.connect("pressed", self, "_enter_code", [_1])
	_2.connect("pressed", self, "_enter_code", [_2])
	_3.connect("pressed", self, "_enter_code", [_3])
	_4.connect("pressed", self, "_enter_code", [_4])
	_5.connect("pressed", self, "_enter_code", [_5])
	_6.connect("pressed", self, "_enter_code", [_6])
	_7.connect("pressed", self, "_enter_code", [_7])
	_8.connect("pressed", self, "_enter_code", [_8])
	_9.connect("pressed", self, "_enter_code", [_9])
	_0.connect("pressed", self, "_enter_code", [_0])
	_star.connect("pressed", self, "_clear_code")
	_square.connect("pressed", self, "_submit_code")
	
	
func _main_menu_button(button):
	if button.name == "keycard":
		$AnimationPlayer.play("")
	if button.name == "keypad":
		$AnimationPlayer.play("open_key_menu")
	if button.name == "back":
		$AnimationPlayer.play_backwards("open_key_menu")
	
	
	
	

func open():
	var node = get_node(Target)
	node.activate()
	
func _clear_code():
	entered_code = ""
	code_mask.text = ""

func _enter_code(code):
	entered_code += code.name
	code_mask.text += "*"
	
func _submit_code():
	if entered_code == accepted_code:
		print("Yay!")
		$AnimationPlayer.play("Success")
	else:
		print("Nay")
