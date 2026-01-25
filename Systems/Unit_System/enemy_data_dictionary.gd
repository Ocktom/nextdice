extends Node

var data : Dictionary = {

  "Rat": {
	"enemy_name": "Rat",
	"hp": 3,
	"atk": 1,
	"atk_range": 1,
	"movement": 1,
	"range_type": "CARDINAL",
	"action_1": "",
	"action_2": ""
  },
  "Bat": {
	"enemy_name": "Bat",
	"hp": 3,
	"atk": 1,
	"atk_range": 1,
	"movement": 3,
	"range_type": "REACH",
	"action_1": "",
	"action_2": ""
  },
  "Bee": {
	"enemy_name": "Bee",
	"hp": 3,
	"atk": 3,
	"atk_range": 1,
	"movement": 3,
	"range_type": "REACH",
	"action_1": "HEAL_ADJACENT",
	"action_2": ""
  },
  "Boar": {
	"enemy_name": "Boar",
	"hp": 8,
	"atk": 3,
	"atk_range": 1,
	"movement": 3,
	"range_type": "CARDINAL",
	"action_1": "",
	"action_2": ""
  },
  "Scorpion": {
	"enemy_name": "Scorpion",
	"hp": 5,
	"atk": 3,
	"atk_range": 2,
	"movement": 3,
	"range_type": "CARDINAL",
	"action_1": "",
	"action_2": ""
  },
  "Spider": {
	"enemy_name": "Spider",
	"hp": 3,
	"atk": 2,
	"atk_range": 5,
	"movement": 3,
	"range_type": "SURROUND",
	"action_1": "EMPOWER_ADJACENT",
	"action_2": ""
  },
  "Snake": {
	"enemy_name": "Snake",
	"hp": 5,
	"atk": 2,
	"atk_range": 1,
	"movement": 5,
	"range_type": "SURROUND",
	"action_1": "",
	"action_2": ""
  }
}
