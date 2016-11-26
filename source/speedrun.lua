local devuser = 'LV19';
local addonname = 'SPEEDRUN';

_G['ADDONS'] = _G['ADDONS'] or {};
_G['ADDONS'][devuser] = _G['ADDONS'][devuser] or {};
_G['ADDONS'][devuser][addonname] = _G['ADDONS'][devuser][addonname] or {};

function SPEEDRUN_ON_INIT(addon, frame)
	local g = _G['ADDONS'][devuser][addonname];
	local acutil = require("acutil");

	if not g.loaded then
		CHAT_SYSTEM(frame:GetName() .. " v1.2.1 loaded!");
		g.BeforeTime = os.clock();
		g.BeforeMoney = _G.GET_TOTAL_MONEY();
		g.BeforeExp = _G.session.GetEXP();
		g.CurrentExp = _G.session.GetEXP();
		g.BeforeMapName = _G.session.GetMapName();
		g.BeforeCharName = _G.GetMyName();
		g.FilePath = path.GetDataPath() .. "../addons/speedrun/record.csv";
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
		--前回キャラ名と今回キャラ名が違う場合、何も獲得していない場合、表示しない。
		if g.BeforeCharName == _G.GetMyName() then
			if g2+e1+e2 ~= 0 then
				CHAT_SYSTEM("ClearTime:" .. t5 .. "min" .. t4 .. "sec Silver:" .. g3 .. GetCommaedText(g2) .. " Bexp:+" .. GetCommaedText(e1) .. " Jexp:+" .. GetCommaedText(e2));
				g.OUTPUT(g.BeforeCharName, g.BeforeMapName , t5 ,t4,g2,e1,e2);
			end
		else
			g.BeforeCharName = _G.GetMyName();
		end
		g.BeforeTime = t2;
		g.BeforeMoney = g1;
		g.BeforeMapID = t1;
		g.BeforeMapName = _G.session.GetMapName();
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
	CHAT_SYSTEM("ClearTime:" .. t5 .. "min" .. t4 .. "sec Silver:" .. g3 .. GetCommaedText(g2) .. " Bexp:+" .. GetCommaedText(e1) .. " Jexp:+" .. GetCommaedText(e2));
	g.OUTPUT(g.BeforeCharName, _G.session.GetMapName() , t5 ,t4,g2,e1,e2);
	g.BeforeTime = t2;
	g.BeforeMoney = g1;
	g.BeforeExp = g.CurrentExp;
	g.BeforeJobExp = g.CurrentJobExp;
	--バラックに戻る
	_G.RUN_GAMEEXIT_TIMER("Barrack");
end

function ADDONS.LV19.SPEEDRUN.OUTPUT(name,map,min,sec,silver,bexp,jexp)
	local g = _G['ADDONS'][devuser][addonname];
	local f = io.open(g.FilePath, "a");
	f:write(_G.GetLocalTimeString() .. "," .. name .. "," .. map .. "," .. min .. ":" .. sec .. "," .. silver .. "," .. bexp .. "," .. jexp .. "\n");
	f:close();
end