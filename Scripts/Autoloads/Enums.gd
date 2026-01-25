extends Node

enum GameState {PLAYER_TURN, ENEMY_TURN, ROUND_END, SELECT_TARGET_UNIT, SELECT_TARGET_CELL}
enum Direction {UP,DOWN,LEFT,RIGHT}
enum Anim{POP,SHAKE,SQUISH,FLASH}
enum DiceColor{RED,BLUE,GREEN}
enum SlotType {FACE, SUM, NONE, ODD, EVEN}
enum UnitType {HERO,ENEMY,TERRAIN}
enum SpellType {LIGHTNING, FIREBALL, HEAL}
enum TargetType {SELECT_UNIT, SELF, SELECT_CELL}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
