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
		g.BeforeExp = _G.session.GetEXP();
		g.CurrentExp = _G.session.GetEXP();
		g.BeforeMapName = _G.session.GetMapName();
		g.isEnable = true;
		g.FirstCheck = false;
		g.loaded = true;
	end
	addon:RegisterMsg("FPS_UPDATE", "SPEEDRUN_UPDATE");
	addon:RegisterMsg('EXP_UPDATE', 'SPEEDRUN_EXP_UPDATE');
	addon:RegisterMsg('JOB_EXP_UPDATE', 'SPEEDRUN_JOB_EXP_UPDATE');
	acutil.slashCommand("/speedrun", SPEEDRUN_COMMAND);
end

function SPEEDRUN_EXP_UPDATE(frame, msg, argStr, argNum)
	local g = _G['ADDONS'][devuser][addonname];
	if msg == 'EXP_UPDATE' then
		g.CurrentExp = _G.session.GetEXP();
	end
end

function SPEEDRUN_JOB_EXP_UPDATE(frame, msg, str, exp, tableinfo)
	local g = _G['ADDONS'][devuser][addonname];
	if g.FirstCheck == false then
		g.BeforeJobExp = exp;
		g.FirstCheck = true;
	end
	g.CurrentJobExp = exp;
end

function SPEEDRUN_UPDATE(frame, msg, argStr, argNum)
	local g = _G['ADDONS'][devuser][addonname];
	local t1 = _G.session.GetMapID();
	if t1 ~= g.BeforeMapID then
		--マップIDが現在のものと違う場合、時間と金と経験値を更新。有効でないときは更新だけ。
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
		local e1 = g.CurrentExp - g.BeforeExp;
		local e2 = g.CurrentJobExp - g.BeforeJobExp;
		CHAT_SYSTEM("ClearTime:" .. t5 .. "min" .. t4 .. "sec Silver:" .. g3 .. g2 .. " Bexp:+" .. e1 .. " Jexp:+" .. e2);
		g.BeforeTime = t2;
		g.BeforeMoney = g1;
		g.BeforeMapID = t1;
		g.BeforeExp = g.CurrentExp;
		g.BeforeJobExp = g.CurrentJobExp;
	end
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
	local e1 = g.CurrentExp - g.BeforeExp;
	local e2 = g.CurrentJobExp - g.BeforeJobExp;
	CHAT_SYSTEM("ClearTime:" .. t5 .. "min" .. t4 .. "sec Silver:" .. g3 .. g2 .. " Bexp:+" .. e1 .. " Jexp:+" .. e2);
	g.BeforeTime = t2;
	g.BeforeMoney = g1;
	g.BeforeExp = g.CurrentExp;
	g.BeforeJobExp = g.CurrentJobExp;
	--バラックに戻る方法が最新のアップデートで変わってこれで戻ると不具合があるため外す
--_G.app.GameToBarrack();
end