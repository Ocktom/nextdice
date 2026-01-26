extends Node

var data : Dictionary = {
  "Rat": {
	"enemy_name": "Rat",
	"hp": 3,
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
	"hp": 3,
	"atk": 1,
	"atk_range": 1,
	"movement": 3,
	"range_type": "REACH",
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
	"atk_range": 1,
	"movement": 3,
	"range_type": "REACH",
	"action_1_name": "heal_self",
	"action_1_context": {
	  "amount": 1
	},
	"action_2_name": "",
	"action_2_context": "",
	"passive_1_name": "spikes"
  },
  "Boar": {
	"enemy_name": "Boar",
	"hp": 8,
	"atk": 3,
	"atk_range": 1,
	"movement": 3,
	"range_type": "CARDINAL",
	"action_1_name": "increase_attack_self",
	"action_1_context": {
	  "amount": 2
	},
	"action_2_name": "",
	"action_2_context": "",
	"passive_1_name": ""
  },
  "Scorpion": {
	"enemy_name": "Scorpion",
	"hp": 5,
	"atk": 3,
	"atk_range": 2,
	"movement": 3,
	"range_type": "CARDINAL",
	"action_1_name": "heal_self",
	"action_1_context": {
	  "amount": 3
	},
	"action_2_name": "",
	"action_2_context": "",
	"passive_1_name": "spikes"
  },
  "Spider": {
	"enemy_name": "Spider",
	"hp": 3,
	"atk": 2,
	"atk_range": 5,
	"movement": 3,
	"range_type": "SURROUND",
	"action_1_name": "",
	"action_1_context": "",
	"action_2_name": "",
	"action_2_context": "",
	"passive_1_name": ""
  },
  "Snake": {
	"enemy_name": "Snake",
	"hp": 5,
	"atk": 2,
	"atk_range": 1,
	"movement": 5,
	"range_type": "SURROUND",
	"action_1_name": "",
	"action_1_context": "",
	"action_2_name": "",
	"action_2_context": "",
	"passive_1_name": "enrage"
  }
}
