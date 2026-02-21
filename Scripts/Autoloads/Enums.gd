extends Node

enum GameState {PLAYER_TURN, ENEMY_TURN, ROUND_END, 
SELECT_TARGET_UNIT, SELECT_TARGET_CELL, SHOP, REWARD}

enum Status {STUN, ROOT, POISON, BURN, INVISIBLE, SHIELD, FOREFIELD, HASTE, FROST, FREEZE, SPIKES}

enum Trigger {HERO_MOVE, ENEMY_MOVE, HERO_DAMAGED, 
UNIT_ATTACKED, HERO_ATTACKED, ENEMY_DAMAGED, 
ENEMY_ATTACKED, ENEMY_DEATH, DICE_ROLlED, 
SUM_ROLLED}

enum Direction {UP,DOWN,LEFT,RIGHT, UP_LEFT, UP_RIGHT, DOWN_LEFT, DOWN_RIGHT, NONE}

enum Anim{POP,SHAKE,SQUISH,FLASH, DART, LUNGE}

enum UnitType {HERO,ENEMY,TERRAIN}

enum TargetType {SELECT_UNIT, SELF, SELECT_CELL, ADJACENT_FOE}

enum RangeType {CARDINAL, DIAG, ALL}

enum ItemType {UPGRADE, SPELL, RELIC}

enum CellEffect {NONE,FIRE,WEB,POISON,TRAP,GRASS,SNOW}

enum SkillTarget {ANY_CELL, LOS_ANY_CELL, STRAIGHT_ANY_CELL, EMPTY_CELL, LOS_EMPTY_CELL, STRAIGHT_EMPTY_CELL, ENEMY_UNIT, LOS_ENEMY_UNIT, STRAIGHT_ENEMY_UNIT, ANY_UNIT, LOS_ANY_UNIT, STRAIGHT_ANY_UNIT, SELF}

enum SkillType {MOVEMENT, ATTACK, MAGIC}

# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
