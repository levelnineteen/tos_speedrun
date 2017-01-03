local devuser = 'LV19';
local addonname = 'SPEEDRUN';

_G['ADDONS'] = _G['ADDONS'] or {};
_G['ADDONS'][devuser] = _G['ADDONS'][devuser] or {};
_G['ADDONS'][devuser][addonname] = _G['ADDONS'][devuser][addonname] or {};

function SPEEDRUN_ON_INIT(addon, frame)
	local g = _G['ADDONS'][devuser][addonname];
	local acutil = require("acutil");

	if not g.loaded then
		CHAT_SYSTEM(frame:GetName() .. " v1.4.1 loaded!");
		g.BeforeTime = os.clock();
		g.BeforeMoney = _G.GET_TOTAL_MONEY();
		g.BeforeExp = _G.session.GetEXP();
		g.CurrentExp = _G.session.GetEXP();
		g.BeforeMaxExp = _G.session.GetMaxEXP();
		g.LevelupExp = g.BeforeMaxExp - g.CurrentExp;
		g.TotalExp = 0;
		g.TotalJobExp = 0;
		g.BeforeMapName = g.GetMapDisplayName();
		g.BeforeCharName = _G.GetMyName();
		g.FilePath = path.GetDataPath() .. "../addons/speedrun/record.csv";
		g.isEnable = true;
		g.FirstCheck = false;
		g.loaded = true;
	end
	addon:RegisterMsg("FPS_UPDATE", "SPEEDRUN_UPDATE");
	addon:RegisterMsg('EXP_UPDATE', 'SPEEDRUN_EXP_UPDATE');
	addon:RegisterMsg('JOB_EXP_UPDATE', 'SPEEDRUN_JOB_EXP_UPDATE');
	addon:RegisterMsg('JOB_EXP_ADD', 'SPEEDRUN_JOB_EXP_UPDATE');
	acutil.slashCommand("/speedrun", SPEEDRUN_COMMAND);
end

function SPEEDRUN_EXP_UPDATE(frame, msg, argStr, argNum)
	local g = _G['ADDONS'][devuser][addonname];
	if msg == 'EXP_UPDATE' then
		if g.BeforeMaxExp ~= _G.session.GetMaxEXP() then
			--レベルアップ後はMaxExpが変化している。TotalExpにレベルアップ分を足す必要がある。
			g.TotalExp = g.TotalExp + g.LevelupExp;
			g.LevelupExp = _G.session.GetMaxEXP();
			g.BeforeMaxExp = _G.session.GetMaxEXP();
		end
		g.CurrentExp = _G.session.GetEXP();
	end
end

function SPEEDRUN_JOB_EXP_UPDATE(frame, msg, str, exp, tableinfo)
	local g = _G['ADDONS'][devuser][addonname];
	g.CurrentJobExp = exp;
	g.CurrentJobLevel = tableinfo.level;
	if g.FirstCheck == false then
		g.BeforeJobExp = exp;
		g.BeforeMaxJobExp = tableinfo.endExp;
		g.LevelupJobExp = tableinfo.endExp - g.CurrentJobExp;
		g.FirstCheck = true;
	end
	if g.BeforeMaxJobExp ~= tableinfo.endExp then
		g.TotalJobExp = g.TotalJobExp + g.LevelupJobExp;
		g.BeforeMaxJobExp = tableinfo.endExp;
		g.LevelupJobExp = tableinfo.endExp;
	end
end

function SPEEDRUN_UPDATE(frame, msg, argStr, argNum)
	local g = _G['ADDONS'][devuser][addonname];
	local t1 = _G.session.GetMapID();
	if t1 ~= g.BeforeMapID or g.BeforeCharName ~= _G.GetMyName() then
		--マップIDが現在のものと違う場合、またはキャラ名が違う場合、時間と金と経験値を更新。有効でないときは更新だけ。
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
			--マイナスはそのまま表示できない
			g3 = "-";
			g2= math.abs(g2);
		end
		local e1 = g.CurrentExp + g.TotalExp - g.BeforeExp;
		local e2 = g.CurrentJobExp + g.TotalJobExp - g.BeforeJobExp;
		--前回キャラ名と今回キャラ名が違う場合、何も獲得していない場合、表示しない。
		if g.BeforeCharName == _G.GetMyName() then
			if g2+e1+e2 ~= 0 and g.isEnable then
				CHAT_SYSTEM("ClearTime:" .. t5 .. "min" .. t4 .. "sec Silver:" .. g3 .. GetCommaedText(g2) .. " Bexp:+" .. GetCommaedText(e1) .. " Jexp:+" .. GetCommaedText(e2));
				g.OUTPUT(g.BeforeCharName, g.BeforeMapName , t5 ,t4,g3,g2,e1,e2);
			end
		else
			--キャラが変わったのでキャラ名を更新
			g.BeforeCharName = _G.GetMyName();
		end
		g.BeforeTime = t2;
		g.BeforeMoney = g1;
		g.BeforeMapID = t1;
		g.BeforeMapName = g.GetMapDisplayName();
		g.BeforeExp = g.CurrentExp;
		g.BeforeJobExp = g.CurrentJobExp;
		g.TotalExp = 0;
		g.TotalJobExp = 0;
	end
end

function SPEEDRUN_COMMAND(words)
	local g = _G['ADDONS'][devuser][addonname];
	local cmd = table.remove(words,1);
	local temp = _G.GetMyPCObject();
	if not cmd then
		g.MANUAL();
	elseif cmd == "exit" then
		g.MANUAL();
		_G.control.RequesDungeonLeave();
	elseif cmd == "out" then
		--バラックに戻る
		g.MANUAL();
		_G.RUN_GAMEEXIT_TIMER("Barrack");
	elseif cmd == "on" then
		g.isEnable = true;
		CHAT_SYSTEM("speedrun enabled");
	elseif cmd == "off" then
		g.isEnable = false;
		CHAT_SYSTEM("speedrun disabled");
	elseif cmd == "help" then
		CHAT_SYSTEM("/speedrun  ..record{nl}/speedrun on ..enable(default){nl}/speedrun off ..disable{nl}/speedrun out ..record & go to barrack{nl}/speedrun exit ..record & dungeon exit");
	end
end

function ADDONS.LV19.SPEEDRUN.MANUAL()
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
		--マイナスはそのまま表示できない
		g3 = "-";
		g2= math.abs(g2);
	end
	local e1 = g.CurrentExp + g.TotalExp - g.BeforeExp;
	local e2 = g.CurrentJobExp + g.TotalJobExp - g.BeforeJobExp;
	CHAT_SYSTEM("ClearTime:" .. t5 .. "min" .. t4 .. "sec Silver:" .. g3 .. GetCommaedText(g2) .. " Bexp:+" .. GetCommaedText(e1) .. " Jexp:+" .. GetCommaedText(e2));
	g.OUTPUT(g.BeforeCharName, g.GetMapDisplayName() , t5 ,t4,g3,g2,e1,e2);
	g.BeforeTime = t2;
	g.BeforeMoney = g1;
	g.BeforeExp = g.CurrentExp;
	g.BeforeJobExp = g.CurrentJobExp;
	g.TotalExp = 0;
	g.TotalJobExp = 0;
end

function ADDONS.LV19.SPEEDRUN.OUTPUT(name,map,min,sec,sign,silver,bexp,jexp)
	local g = _G['ADDONS'][devuser][addonname];
	local f = io.open(g.FilePath, "a");
	--ディレクトリがなければ終わる。
	if f == nil then return; end
	if name == nil then name = "N/A"; end;
	if map == nil then map = "N/A"; end;
	if min == nil then min = "N/A"; end;
	if sec == nil then sec = "N/A"; end;
	if sign == "+" then sign = ""; end;
	if silver == nil then silver = "N/A"; end;
	if bexp == nil then bexp = "N/A"; end;
	if jexp == nil then jexp = "N/A"; end;
	local pcobj = _G.GetMyPCObject();
	local rank = _G.session.GetPcTotalJobGrade();
	f:write(_G.GetLocalTimeString() .. "," .. name .. "," .. map .. "," .. min .. ":" .. sec .. "," .. sign .. silver .. "," .. bexp .. "," .. jexp .. "," .. pcobj.Lv .. "," .. rank .. "," .. g.CurrentJobLevel ..  "\n");
	f:close();
end

function ADDONS.LV19.SPEEDRUN.GetMapDisplayName()
	local g = _G['ADDONS'][devuser][addonname];
	local mapClassName = _G.session.GetMapName();
	local mapprop = _G.geMapTable.GetMapProp(mapClassName);
	local mapName = _G.dictionary.ReplaceDicIDInCompStr(mapprop:GetName());
	return mapName;
end