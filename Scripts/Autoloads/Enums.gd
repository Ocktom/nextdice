extends Node

enum GameState {PLAYER_TURN, ENEMY_TURN, ROUND_END, SELECT_TARGET_UNIT, SELECT_TARGET_CELL, SHOP}
enum Direction {UP,DOWN,LEFT,RIGHT, UP_LEFT, UP_RIGHT, DOWN_LEFT, DOWN_RIGHT}
enum Anim{POP,SHAKE,SQUISH,FLASH, DART, LUNGE}

enum DamageType {ATTACK, POISON, BURN}

enum Status {STUN, ROOT, POISON, BURN, INVISIBLE, SHIELD, FOREFIELD, HASTE}

enum UnitType {HERO,ENEMY,TERRAIN}
enum Behavior {AGGRESSIVE,PROTECTIVE,EVASIVE,ERRATIC}

enum TargetType {SELECT_UNIT, SELF, SELECT_CELL, ADJACENT_FOE}
enum RangeType {CARDINAL, DIAG, ALL}

enum FaceType {NONE,MELEE,RANGED,DEFENSIVE}

enum ItemType {UPGRADE, SPELL, RELIC}
enum SpellType {LIGHTNING, FIREBALL, HEAL}
enum Trigger {HERO_MOVE, ENEMY_MOVE, HERO_DAMAGED, UNIT_ATTACKED, HERO_ATTACKED, ENEMY_DAMAGED, ENEMY_ATTACKED, ENEMY_DEATH, DICE_ROLlED, SUM_ROLLED}

enum CellEffect {NONE,FIRE,WEB,POISON,TRAP}

enum Stat{NONE, STR, DEX, INT, CRIT}
enum SkillTarget {ANY_CELL, EMPTY_CELL, ENEMY_UNIT, HERO_UNIT, ANY_UNIT}

# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
