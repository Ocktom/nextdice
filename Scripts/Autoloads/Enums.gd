extends Node

enum GameState {PLAYER_TURN, ENEMY_TURN, ROUND_END, SELECT_TARGET_UNIT, SELECT_TARGET_CELL, SHOP}
enum Direction {UP,DOWN,LEFT,RIGHT, UP_LEFT, UP_RIGHT, DOWN_LEFT, DOWN_RIGHT}
enum Anim{POP,SHAKE,SQUISH,FLASH, DART}
enum DiceColor{RED,BLUE,GREEN}
enum UnitType {HERO,ENEMY,TERRAIN}
enum ItemType {FACE_UPGRADE, ONE_TIME, RELIC}
enum SpellType {LIGHTNING, FIREBALL, HEAL}
enum TargetType {SELECT_UNIT, SELF, SELECT_CELL}
enum Behavior {AGGRESSIVE,PROTECTIVE,EVASIVE,ERRATIC}
enum RangeType {CARDINAL, SURROUND, DIAGONAL, REACH}
enum EnemyAction {NONE, HEAL_ADJACENT, EMPOWER_ADJACENT}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
