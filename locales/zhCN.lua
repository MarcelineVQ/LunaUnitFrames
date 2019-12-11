if( GetLocale() ~= "zhCN" ) then return end
local L = {
    ["Changed profile to %s."] = "更换档案至 %s",
    ["Cannot find any profiles named \"%s\"."] = "找不到名为 \"%s\" 的档案。",
    ["player"] = "玩家",
    ["pet"] = "宠物",
    ["Pet"] = "宠物",
    ["pettarget"] = "宠物目标",
    ["target"] = "目标",
    ["targettarget"] = "目标的目标",
    ["targettargettarget"] = "目标的目标的目标",
    ["party"] = "小队",
    ["partytarget"] = "小队成员的目标",
    ["partypet"] = "小队成员的宠物",
    ["raid"] = "团队",
    ["raidpet"] = "团队成员的宠物",
    ["maintank"] = "主坦克",
    ["maintanktarget"] = "主坦克的目标",
    ["mainassist"] = "主辅助",
    ["mainassisttarget"] = "主辅助的目标",
    ["Hide Blizzard"] = "隐藏暴雪默认框架",
    ["Cast Bar"] = "施法条",
    ["Buffs"] = "增益光环",
    ["Debuffs"] = "减益光环",
    ["Hides the default %s frame"] = "隐藏默认%s框架",
    ["General"] = "综合",
    ["Colors"] = "颜色",
    ["Units"] = "单位",
    ["Enable"] = "启用",
    ["Enable the %s frame(s)"] = "启用 %s 框架",
    ["Class Colors"] = "职业颜色",
    ["Hunter"] = "猎人",
    ["Warlock"] = "术士",
    ["Priest"] = "牧师",
    ["Paladin"] = "圣骑士",
    ["Mage"] = "法师",
    ["Rogue"] = "潜行者",
    ["Druid"] = "德鲁伊",
    ["Shaman"] = "萨满",
    ["Warrior"] = "战士",
    ["Power Colors"] = "能量条颜色",
    ["Reaction Colors"] = "敌对类型颜色",
    ["Cast Colors"] = "施法颜色",
    ["XP Colors"] = "经验颜色",
    ["Aura Colors"] = "光环颜色",
    ["Normal"] = "普通",
    ["Rested"] = "充分休息",
    ["Removable"] = "可移除的",
    ["Mana"] = "法力值",
    ["Rage"] = "怒气值",
    ["Focus"] = "集中值",
    ["Energy"] = "能量值",
    ["Combopoints"] = "连击点",
    ["Tapped"] = "点击",
    ["Red"] = "红色",
    ["Green"] = "绿色",
    ["Static"] = "静态",
    ["Yellow"] = "黄色",
    ["Inc Heal"] = "受到治疗",
    ["Enemy unattackable"] = "不可攻击的敌人",
    ["Enemy civilian"] = "敌方平民",
    ["Hostile"] = "敌对",
    ["Aggro"] = "获得仇恨",
    ["Friendly"] = "友方",
    ["Neutral"] = "中立",
    ["Offline"] = "离线",
    ["Channel"] = "引导",
    ["Cast"] = "施法",
    ["Hint"] = "提示",
    ["You will need to do a /console reloadui before a hidden frame becomes visible again."] = "隐藏的框体启用后需要 /reload 重载界面后才会再度显示。",
    ["Health bar"] = "生命条",
    ["Portrait"] = "头像",
    ["Power bar"] = "能量条",
    ["Cast bar"] = "施法条",
    ["Lock"] = "锁定",
    ["Lock the frames"] = "锁定框架",
    ["Tooltip in Combat"] = "战斗中显示鼠标提示",
    ["Show unitframe tooltips in combat"] = "战斗中指向单位框架时，显示鼠标提示",
    ["Bar texture"] = "计量条材质",
    ["Global Settings"] = "全局设置",
    ["Global Unit Settings"] = "全局单位设置",
    ["Test Aura"] = "测试光环",
    ["Test spell"] = "测试法术",
    ["Combo points"] = "连击点",
    ["Auras"] = "光环",
    ["Incoming heals"] = "预估治疗",
    ["Empty bar"] = "空白条",
    ["Reckoning Stacks"] = "清算（天赋）层数",
    ["Reckoning"] = "清算",
    ["XP/Rep bar"] = "经验声望条",
    ["%s (%s): %s/%s (%.2f%% done)"] = "%s (%s): %s/%s (%.2f%% )",
    ["Level %s - %s: %s/%s (%.2f%% done), %s rested."] = "等级 %s - %s: %s/%s (%.2f%% ), %s 休息充分。",
    ["Level %s - %s: %s/%s (%.2f%% done)"] = "等级 %s - %s: %s/%s (%.2f%% )",
    ["Scale"] = "比例",
    ["Set the scale of the frame."] = "设置框体缩放比例。",
    ["Height"] = "高度",
    ["Set the height of the frame."] = "设置框体高度。",
    ["Width"] = "宽度",
    ["Set the width of the frame."] = "设置框体宽度。",
    ["X Position"] = "X 轴位置",
    ["Y Position"] = "Y 轴位置",
    ["Set the position of the frame."] = "设置框体位置。",
    ["Anchor To"] = "锚点",
    ["Anchor to another frame."] = "用其他框体作锚点。",
    ["Not a valid number."] = "数值不正确。",
    ["Enable or disable the %s."] = "启用或禁用%s。",
    ["Background"] = "背景",
    ["Background alpha"] = "背景透明度",
    ["Set the background alpha."] = "设置背景透明度。",
    ["Color by type"] = "类别颜色",
    ["Color by reaction"] = "敌对类型颜色",
    ["Set the height."] = "设置高度。",
    ["Order"] = "排序",
    ["Set the order priority."] = "设置该元素在框架中的排序优先级。",
    ["Class"] = "职业",
    ["Health percent"] = "生命值百分比",
    ["Never (Disabled)"] = "从不（关闭）",
    ["Players only"] = "只限玩家",
    ["NPCs only"] = "只限NPC",
    ["Both"] = "两者皆有",
    ["Power Type"] = "能量类型",
    ["Alpha"] = "透明度",
    ["Set the alpha."] = "设置透明度。",
    ["Color by class."] = "职业颜色。",
    ["Range"] = "范围",
    ["Range Frequency"] = "检查频率",
    ["Set the interval of range checking."] = "设置距离检查的频率。",
    ["Distance"] = "距离检查",
    ["Distance to measure"] = "距离检查",
    ["10y"] = "10码",
    ["30y"] = "30码",
    ["Spell based"] = "基于法术",
    ["Is Visible"] = "可见的",
    ["Tags"] = "标签（tags）",
    ["#invalidTag#"] = "#不规范标签#",
    ["Size"] = "图标大小",
    ["Set the size."] = "设置你施放的光环尺寸加大的幅度。",
    ["Limit"] = "限制",
    ["Set after wich percentage of the bar to cut off."] = "设置文本占据框架的百分比。",
    ["Top right"] = "顶部偏右",
    ["Right"] = "靠右",
    ["Bottom right"] = "底部偏右",
    ["Left Center"] = "中央偏左",
    ["Center"] = "中央",
    ["Right Center"] = "中央偏右",
    ["Top left"] = "顶部偏左",
    ["Left"] = "左侧",
    ["Bottom left"] = "底部偏左",
    ["Top"] = "顶部",
    ["Bottom"] = "底部",
    ["Inside"] = "Inside",
    ["Inside Center"] = "Inside Center",
    ["Set the tags."] = "设置标签（tags）。",
    ["Font Size"] = "字号",
    ["Set the font size."] = "设置字号。",
    ["Set the height when in bar mode."] = "在条形模式里的高度。",
    ["full Before"] = "填满之前",
    ["full After"] = "填满之后",
    ["Set the width of the portrait."] = "设置头像宽度。",
    ["Portrait type"] = "头像类型",
    ["Alignment"] = "对齐",
    ["Portrait alignment"] = "头像对齐",
    ["Type"] = "类型",
    ["3D"] = "3D",
    ["2D"] = "2D",
    ["Inc Heal Cap"] = "最大预估比例",
    ["Let the prediction overgrow the bar."] = "预估治疗量超出生命值边界的最大比例。",
    ["Filter %s"] = "Filter %s",
    ["Show only buffs that you or everyone of your class can apply"] = "Show only buffs that you or everyone of your class can apply",
    ["Show only debuffs that you can dispel"] = "Show only debuffs that you can dispel",
    ["Set the buffsize."] = "设置光环大小。",
    ["Set the debuffsize."] = "设置光环大小。",
    ["Make your own %s bigger."] = "增大你施放的%s 。",
    ["Weaponbuffs"] = "武器增益",
    ["Bordercolor"] = "边框颜色",
    ["Padding"] = "间距",
    ["Distance between aura icons."] = "光环图标之间的距离。",
    ["Timers"] = "计时",
    ["Limit timers to..."] = "光环计时。",
    ["Position of the %s."] = "%s的位置。",
    ["Bigger buffs"] = "加大自身施放",
    ["Bigger buff size"] = "加大尺寸",
    ["Bigger debuffs"] = "加大自身施放",
    ["Bigger debuff size"] = "加大尺寸",
    ["All"] = "全部",
    ["Own"] = "自己的",
    ["None"] = "无",
    ["Position"] = "位置",
    ["Up"] = "上",
    ["Down"] = "下",
    ["Growth direction"] = "增长方向",
    ["The direction in which new frames are added."] = "新框体的增长方向。",
    ["This is set through party options."] = "通过小队选项进行设置。",
    ["This is set through raid options."] = "通过团队选项进行设置。",
    ["Hide in raid"] = "在团队中隐藏",
    ["Hide while in a raid group."] = "处于一个团队时隐藏。",
    ["Never"] = "从不",
    ["Raid > 5 man"] = "团队规模大於五人",
    ["Any Raid"] = "任意团队",
    ["Sort by"] = "角色排列",
    ["Sort by name or index"] = "通过姓名或索引排列角色",
    ["Name"] = "姓名",
    ["Index"] = "索引",
    ["Sort order"] = "排序方式",
    ["Sort ascending or descending"] = "升序或者降序排序",
    ["Ascending"] = "升序",
    ["Descending"] = "降序",
    ["Units per column"] = "每列单位数量",
    ["The amount of units until a new column is started"] = "每列最大单位数量",
    ["Max columns"] = "最多几列",
    ["The maximum amount of columns"] = "列的最大数量值",
    ["Column spacing"] = "每列间距",
    ["The space between each column"] = "列与列之间的间隔",
    ["Column Growth direction"] = "列的增长方向",
    ["Where a new column is started"] = "新的一列将从哪边开始",
    ["Borders"] = "边框",
    ["Highlight the frames borders when the unit is targeted"] = "选中目标时高亮单位边框",
    ["Highlight the frames borders when the unit is moused over"] = "鼠标指向时高亮单位边框",
    ["Highlight the frames borders when the unit has aggro"] = "单位获得仇恨时高亮边框",
    ["Highlight the frames borders when the unit has a debuff you or someone can remove"] = "Highlight the frames borders when the unit has a debuff you or someone can remove",
    ["Highlight"] = "高亮",
    ["On target"] = "目标",
    ["Highlight the frame when the unit is targeted"] = "选中目标时高亮框体",
    ["On mouseover"] = "鼠标指向",
    ["Highlight the frame when the unit is moused over"] = "鼠标指向时高亮框体",
    ["On aggro"] = "获得仇恨",
    ["Highlight the frame when the unit has aggro"] = "获得仇恨时高亮框体",
    ["On debuff"] = "有减益debuff",
    ["Highlight the frame when the unit has a debuff you or someone can remove"] = "Highlight the frame when the unit has a debuff you or someone can remove",
    ["Off"] = "Off",
    ["Your own"] = "Your own",
    ["Hide"] = "隐藏",
    ["Auto hide"] = "自动隐藏",
    ["Hide when inactive"] = "没有这项元素时隐藏",
    ["Cast icon"] = "施法图标",
    ["Set the behaviour of the cast icon"] = "设置施法图标的动作",
    ["Bars with lower order priority than this will be above."] = "排序低于此数值的计量条会显示在头像上方。",
    ["Bars with higher order priority than this will be below."] = "排序高于此数值的计量条会显示在头像下方。",
    ["Combat fader"] = "战斗淡出",
    ["Combat alpha"] = "战斗中透明度",
    ["Inactive alpha"] = "战斗外透明度",
    ["Speedy fade"] = "快速战斗",
    ["Druid bar"] = "德鲁伊法力条",
    ["Reckoning stacks"] = "清算（天赋）层数",
    ["Xp bar"] = "经验条",
    ["Combat text"] = "战斗文字",
    ["Font"] = "字体",
    ["Set the font"] = "设置字体",
    ["Aura border"] = "Aura border",
    ["Light"] = "Light",
    ["Dark"] = "Dark",
    ["Black"] = "Black",
    ["Heal prediction timeframe"] = "Heal prediction timeframe",
    ["Set how long into the future heals are predicted."] = "Set how long into the future heals are predicted.",
    ["Disable hots"] = "Disable hots",
    ["Disable hots in heal prediction"] = "Disable hots in heal prediction",
    ["Disable OmniCC"] = "Disable OmniCC",
    ["Prevent OmniCC from putting numbers on cooldown animations (Requires UI reload)"] = "Prevent OmniCC from putting numbers on cooldown animations (Requires UI reload)",
    ["Disable Blizzard cooldown count"] = "Disable Blizzard cooldown count",
    ["Prevent the default UI from putting numbers on cooldown animations"] = "Prevent the default UI from putting numbers on cooldown animations",
    ["Mouse interaction"] = "鼠标互动",
    ["This enables xp tooltips but disables clicks or vice versa"] = "启用经验提示但禁用点击，或者反之",
    ["Indicators"] = "指示器",
    ["Raid target"] = "团队目标",
    ["Masterloot"] = "队长分配",
    ["Leader"] = "队长",
    ["PvP flag"] = "PvP",
    ["PvP Rank"] = "PvP等级",
    ["Readycheck"] = "就位确认",
    ["Combat status"] = "战斗状态",
    ["Resurrection"] = "复活状态",
    ["Happiness"] = "快乐度",
    ["Elite"] = "精英",
    ["Set the X coordinate."] = "设置X轴坐标。",
    ["Set the Y coordinate."] = "设置Y轴坐标。",
    ["Side"] = "侧边",
    ["Elite indicator alignment"] = "精英对齐",
    ["Point"] = "锚点",
    ["Anchor point"] = "复活状态锚点",
    ["WARNING! This will set ALL bars to this texture."] = "警告：这将使所有条形材质设置为该材质。",
    ["WARNING! This will set ALL texts to this font."] = "警告：这将使所有文字设置为该字体。",
    ["Dead"] = "死亡",
    ["Feigned"] = "假死",
    ["Ghost"] = "灵魂",
    ["(i)"] = "屏蔽",
    ["rare"] = "稀有",
    ["elite"] = "精英",
    ["rareelite"] = "稀有精英",
    ["(civ)"] = "平民",
    ["unhappy"] = "不高兴",
    ["content"] = "普通",
    ["happy"] = "高兴",
    ["(c)"] = "战斗",
    ["male"] = "男",
    ["female"] = "女",
    ["Ticker"] = "每跳计时",
    ["Since mana/energy regenerate in ticks, show a timer for it"] = "显示法力、能量回复的每跳计时",
    ["Autohide ticker"] = "自动隐藏",
    ["Hide the ticker when it's not needed"] = "没有能量条时隐藏",
    ["Five second rule"] = "5秒原则计时器",
    ["Show a timer for the five second rule"] = "显示法力值回复的5秒原则计时器",
    ["Totem bar"] = "图腾条",
    ["Note: This bar only works with 5/5 Reckoning and at least 1/5 Redoubt talents."] = "只在学习5点清算天赋并且至少学习了1点盾牌壁垒天赋时生效。",
    ["Enable this group"] = "启用本组",
    ["Offset"] = "偏移",
    ["Set the space between units."] = "设置单位间隔。",
    ["Show when"] = "何时显示",
    ["Show even smaler groups than a raid in the raidframe"] = "使用团队框架显示队伍",
    ["Always"] = "总是",
    ["Squares"] = "自定义指示器",
    ["What the indicator should display."] = "指示器要显示什么。",
    ["Name (exact) or ID"] = "正确法术全名 或者 ID",
    ["Name (exact) or ID of the effect to track. Can have multiple entries seperated by ;"] = "追踪效果的准确名字 或者 ID。",
    ["Buff/Debuff"] = "光环图标",
    ["Own buff/debuff"] = "你施放的光环",
    ["Dispel"] = "驱散",
    ["Timer"] = "计时",
    ["Texture"] = "材质",
    ["Show the spell texture instead of its type color."] = "显示法术材质，而非类型颜色。",
    ["Fontsize"] = "字体大小",
    ["Groupnumbers"] = "小队编号",
    ["Show Groupnumbers next to the group"] = "在小队旁显示编号",
    ["Groupnumberfont"] = "小队编号字体",
    ["Set the size of the group number."] = "设置小队编号大小。",
    ["Group"] = "小队",
    ["Group by"] = "队伍排列",
    ["Group by class or group"] = "按职业或小队编队",
    ["Tag Help"] = "标签使用帮助",
    ["Tags - Help"] = "标签 - 帮助",
    ["You can use tags to change the text information displayed on each frame. Just go to the tag section of the frame you want to change and put in some tags."] = "你可以使用标签（tags）来更改每个框体上显示的文字，只要在对应框体的标签下输入你想替换的标签（tags）即可。",
    ["Profiles"] = "档案",
    ["Show player"] = "显示玩家",
    ["Show player in the party frame."] = "在小队框体中显示玩家。",
    ["Show player in the party frame when solo."] = "单人时，在小队框体中显示玩家。",
    ["Vertical"] = "垂直",
    ["Set the bar vertical."] = "垂直条计量。",
    ["numtargeting"] = "你队伍中以该单位为目标的人数",
    ["cnumtargeting"] = "使用颜色来表示选中目标人数",
    ["br"] = "换行",
    ["name"] = "显示名字",
    ["shortname:x"] = "显示名字的前x位，x=1-12",
    ["abbrev:name"] = "显示名字的简写（Damon Albarn = D. Albarn）",
    ["guild"] = "公会名字",
    ["guildrank"] = "公会会阶",
    ["level"] = "显示等级：如果该单位是首领或是比你高10级以上的玩家，则显示\"??\"",
    ["smartlevel"] = "智慧等级：如果该单位是首领或是比你高10级以上的玩家，显示示Boss",
    ["class"] = "显示职业",
    ["smartclass"] = "显示玩家的职业或NPC的类型",
    ["raredesc"] = "如果是稀有或者稀有精英，显示\"稀有\"",
    ["elitedesc"] = "如果是精英或者稀有精英，显示\"精英\"",
    ["classification"] = "显示分类，如精英、稀有、Boss等等",
    ["shortclassification"] = "分类的简写，精英\"E\"、稀有\"R\"，稀有精英\"RE\"",
    ["race"] = "种族",
    ["smartrace"] = "显示玩家的种族或NPC的类型",
    ["creature"] = "生物类型（蝙蝠、狼、等等）",
    ["sex"] = "性别",
    ["druidform"] = "友方德鲁伊形态",
    ["civilian"] = "显示平民",
    ["pvp"] = "显示 PvP 状态",
    ["rank"] = "PVP军衔",
    ["numrank"] = "PVP军衔等级数字",
    ["faction"] = "阵营",
    ["ignore"] = "如果玩家被你屏蔽，显示\"屏蔽\"",
    ["server"] = "服务器名",
    ["status"] = "状态：\"死亡\"、\"灵魂\"或\"离线\"",
    ["happiness"] = "宠物快乐度，如\"不高兴\"、\"普通\"或\"高兴\"",
    ["group"] = "组队状态",
    ["combat"] = "战斗状态",
    ["loyalty"] = "宠物忠诚度",
    ["namehealerhealth"] = "与 [healerhealth] 显示相同， 但在满血时显示名字",
    ["healerhealth"] = "在友方单位上，与[smart:healmishp]显示相同；在敌对单位上，显示\"当前生命值/最大生命值\"",
    ["smart:healmishp"] = "为治疗显示损失的生命值. 需要时会显示状态：\"死亡\"、\"灵魂\"或\"离线\"",
    ["cpoints"] = "连击点数",
    ["smarthealth"] = "显示\"生命值/最大生命值\"，死亡时显示\"死亡\")",
    ["ssmarthealth"] = "[smarthealth]的简写版本，超过10k时简写",
    ["healhp"] = "当前生命值与治疗整合，将被治疗显示为绿色",
    ["hp"] = "当前生命值",
    ["shp"] = "当前生命值简写版本，超过10k时简写",
    ["sshp"] = "当前生命值但不显示最大生命值，超过10k时简写",
    ["maxhp"] = "最大生命值",
    ["smaxhp"] = "最大生命值，超过10k时简写",
    ["missinghp"] = "当前损失生命",
    ["healmishp"] = "算上预估治疗的损失生命值，将被治疗显示为绿色",
    ["perhp"] = "生命值百分比",
    ["pp"] = "当前能量（怒气/能量/法力）值",
    ["spp"] = "当前能量（怒气/能量/法力）值，超过10k时简写",
    ["maxpp"] = "最大能量值",
    ["smaxpp"] = "最大能量值，超过10k时简写",
    ["missingpp"] = "损失能量值",
    ["perpp"] = "能量值百分比",
    ["druid:pp"] = "德鲁伊变身形态下显示法力值",
    ["druid:maxpp"] = "德鲁伊变身形态下显示最大法力值",
    ["druid:missingpp"] = "德鲁伊变身形态下显示损失法力值",
    ["druid:perpp"] = "德鲁伊变身形态下显示法力值百分比",
    ["incheal"] = "预估治疗的数值",
    --["numheals"] = "Number of incoming heals",
    ["combatcolor"] = "战斗中红色",
    ["pvpcolor"] = "关闭PVP时白色, 开启PVP的友方绿色，敌方红色",
    ["reactcolor"] = "敌对红色，中立黄色，友方绿色",
    ["levelcolor"] = "根据你与目标的等级对比显示颜色：灰、绿、黄或红",
    ["aggrocolor"] = "获得仇恨时红色",
    ["classcolor"] = "职业颜色",
    ["healthcolor"] = "基于血量百分比的颜色，死亡时红色",
    ["color:xxxxxx"] = "自定义颜色（六位rrggbb代码）",
    ["nocolor"] = "重置为白色",
    ["castname"] = "法术名字",
    ["casttime"] = "施法时间",
    ["xp"] = "当前经验等级",
    ["percxp"] = "当前经验百分比",
    ["rep"] = "当前追踪的声望",
    ["Info tags"] = "信息标签",
    ["Health and power tags"] = "数值标签",
    ["Color tags"] = "颜色标签",
    ["Targeting sound"] = "Targeting sound",
    ["Enable the sound when switching target"] = "Enable the sound when switching target",
}
    
    local LunaUF = select(2, ...)
    LunaUF.L = setmetatable(L, {__index = LunaUF.L})