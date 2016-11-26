local devuser = 'LV19';
local addonname = 'SPEEDRUN';

_G['ADDONS'] = _G['ADDONS'] or {};
_G['ADDONS'][devuser] = _G['ADDONS'][devuser] or {};
_G['ADDONS'][devuser][addonname] = _G['ADDONS'][devuser][addonname] or {};

function SPEEDRUN_ON_INIT(addon, frame)
	local g = _G['ADDONS'][devuser][addonname];
	local acutil = require("acutil");

	if not g.loaded then
		CHAT_SYSTEM(frame:GetName() .. " loaded!");
		g.BeforeTime = os.clock();
		g.BeforeMoney = _G.GET_TOTAL_MONEY();
		g.isEnable = true;
		g.loaded = true;
	end
	addon:RegisterMsg("FPS_UPDATE", "SPEEDRUN_UPDATE");
	acutil.slashCommand("/speedrun", SPEEDRUN_COMMAND);
end

function SPEEDRUN_UPDATE(frame, msg, argStr, argNum)
	local g = _G['ADDONS'][devuser][addonname];
	local t1 = _G.session.GetMapID();
	if t1 ~= g.BeforeMapID then
		--マップIDが現在のものと違う場合、時間と金を更新。有効でないときは更新だけ。
		local t2 = os.clock();
		local g1 = _G.GET_TOTAL_MONEY();
		local t3 = t2 - g.BeforeTime;
		local t4 = math.floor((t3 % 60));
		local t5 = math.floor(t3 / 60);
		local g2 = g1 - g.BeforeMoney;
		local g3 = "";
		if g2 >= 0 then
			g3 = "+";
		else
			g3 = "";
		end
		CHAT_SYSTEM("ClearTime:" .. t5 .. "min" .. t4 .. "sec Silver:" .. g3 .. g2);
		g.BeforeTime = t2;
		g.BeforeMoney = g1;
		g.BeforeMapID = t1;
	end
end

function SPEEDRUN_TIMECOUNT()
	CHAT_SYSTEM('test3');
	local g = _G['ADDONS'][devuser][addonname];
	local t2 = os.clock();
	local g1 = _G.GET_TOTAL_MONEY();
	local t3 = t2 - g.BeforeTime;
	local t4 = math.floor((t3 % 60));
	local t5 = math.floor(t3 / 60);
	local g2 = g1 - g.BeforeMoney;
	local g3 = "";
	if g2 >= 0 then
		g3 = "+";
	else
		g3 = "";
	end
	CHAT_SYSTEM("ClearTime:" .. t5 .. "min" .. t4 .. "sec Silver:" .. g3 .. g2);
	g.BeforeTime = t2;
	g.BeforeMoney = g1;
end


function SPEEDRUN_COMMAND()
	local g = _G['ADDONS'][devuser][addonname];
	local acutil = require('acutil');
	local g = _G['ADDONS'][devuser][addonname];
	local t2 = os.clock();
	local g1 = _G.GET_TOTAL_MONEY();
	local t3 = t2 - g.BeforeTime;
	local t4 = math.floor((t3 % 60));
	local t5 = math.floor(t3 / 60);
	local g2 = g1 - g.BeforeMoney;
	local g3 = "";
	if g2 >= 0 then
		g3 = "+";
	else
		g3 = "";
	end
	CHAT_SYSTEM("ClearTime:" .. t5 .. "min" .. t4 .. "sec Silver:" .. g3 .. g2);
	g.BeforeTime = t2;
	g.BeforeMoney = g1;
	_G.app.GameToBarrack();
end