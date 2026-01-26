extends Node

var data : Dictionary = {
  "Rat": {
	"enemy_name": "Rat",
	"hp": 2,
	"atk": 1,
	"atk_range": 1,
	"movement": 1,
	"range_type": "CARDINAL",
	"action_1_name": "",
	"action_1_context": "",
	"action_2_name": "",
	"action_2_context": "",
	"passive_1_name": "scavenge"
  },
  "Bat": {
	"enemy_name": "Bat",
	"hp": 4,
	"atk": 1,
	"atk_range": 2,
	"movement": 3,
	"range_type": "ALL",
	"action_1_name": "",
	"action_1_context": "",
	"action_2_name": "",
	"action_2_context": "",
	"passive_1_name": ""
  },
  "Bee": {
	"enemy_name": "Bee",
	"hp": 3,
	"atk": 3,
	"atk_range": 2,
	"movement": 3,
	"range_type": "ALL",
	"action_1_name": "heal_random_enemy",
	"action_1_context": {
	  "amount": 5
	},
	"action_2_name": "",
	"action_2_context": "",
	"passive_1_name": ""
  },
  "Boar": {
	"enemy_name": "Boar",
	"hp": 8,
	"atk": 3,
	"atk_range": 4,
	"movement": 3,
	"range_type": "CARDINAL",
	"action_1_name": "",
	"action_1_context": "",
	"action_2_name": "",
	"action_2_context": "",
	"passive_1_name": "enrage"
  },
  "Scorpion": {
	"enemy_name": "Scorpion",
	"hp": 5,
	"atk": 2,
	"atk_range": 3,
	"movement": 3,
	"range_type": "DIAG",
	"action_1_name": "increase_attack_self",
	"action_1_context": {
	  "amount": 2
	},
	"action_2_name": "",
	"action_2_context": "",
	"passive_1_name": ""
  },
  "Spider": {
	"enemy_name": "Spider",
	"hp": 4,
	"atk": 3,
	"atk_range": 3,
	"movement": 3,
	"range_type": "CARDINAL",
	"action_1_name": "",
	"action_1_context": "",
	"action_2_name": "",
	"action_2_context": "",
	"passive_1_name": ""
  },
  "Snake": {
	"enemy_name": "Snake",
	"hp": 5,
	"atk": 3,
	"atk_range": 3,
	"movement": 8,
	"range_type": "DIAG",
	"action_1_name": "",
	"action_1_context": "",
	"action_2_name": "",
	"action_2_context": "",
	"passive_1_name": ""
  }
}
