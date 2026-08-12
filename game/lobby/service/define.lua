--Player status
PlayerState = {
    Normal = 1,     --leisure
    Matching = 2,   --"Match"
}

--Team status
TeamState = {
    Normal = 1,     --Normal
    Matching = 2,   --Matchmaking...
}

--Chat Channel = {
ChannelType = {
    Team = 4,       --Team chat
}

---@class CallInfo
---@field public call_id integer 'call id'
---@field public service_uuid integer  iservice uuid'
---@field public method_index integer 'method index'
---@field public request_data string 'request proto data'

---@class PlayerInfo
---@field public aid integer 'Player ID'
---@field public head_icon string 'Avatar'
---@field public name string 'Player Nickname'
---@field public state integer 'Player Status'
---@field public score integer 'Player score
---@field public map_id string 'Current Map version id'
---@field public in_game boolean 'Whether in the game'
---@field public state_change_reason? 0|1|2|3 # The reason for the state change, 0: none; 1: Matching successful; 2: Cancel match; 3: Start matching
---@field public game_play_id integer 'Map Fixed id'

---@class MatchInfo
---@field public map_id string 'Map version ID'
---@field public level_id string 'level id'
---@field public game_mode integer 'game mode'
---@field public game_play_id string 'Map Fixed id'

---@class ChatSender
---@field public aid integer 'Sender ID'
---@field nickname string 'Sender nickname'
---@field head_icon string 'Sender'







---@class Role
---@field public role_color string
---@field public role_name string
---@field public camp_id integer
---@field public role_type integer

---@class CampInfo
---@field public camp table
---@field public role table
---@field public camp_limit integer

---@class BattleMapInfo
---@field public map_id string
---@field public game_play_id string
---@field public map_type integer
---@field public logic_fps integer // Logical frame default 30
---@field public camp_info CampInfo // Camp information

---@class MultiBattleSlotField
---@field public aid integer
---@field public role_id integer
---@field public camp_id integer
---@field public nickname string
---@field public repo table
---@field public archives table


---Open multiple battlefield parameters locally
---@class MultiBattleField
---@field public owner_aid string // Local multi-open author aid
---@field public timestamp integer // Initiate request timestamp
---@field public region string // The author is region
---@field public game_mode integer // Game mode
---@field public token string // Token
---@field public slots table // Slot information
---@field public map_info BattleMapInfo // Map Information
---@field public stuff_templates table // Map Prop template

---"Cut copy
---@class DungeonSpaceField 'Copy Information'
---@field public game_map_id string 'Map version ID'
---@field public level_id string 'level id'
---@field public game_mode integer 'game mode'

---@class DungeonPlayerField 'Player Information'
---@field public aid string 'Player ID'
---@field public version string 'Client version; Multiplayer copy RPC required, currently fixed at 2.0'
