DebuffId = 11101
CtrlAttack = true

function OnLogin(username)
  LogDebug = false
	BuffDebug = false;
	SkillIDlist = {} ;
	RequestUse = GetTime();
	requesttimes = 0;
  candidateskill = GetSkillIdByName("Elemental Mass Burst");
end;

function OnCreate()
  ShowToClient("Nuker Combo","Loaded");
  candidateskill = GetSkillIdByName("Elemental Mass Burst");
  this:RegisterCommand("buffdebug", CommandChatType.CHAT_ALLY, CommandAccessLevel.ACCESS_ME);
  this:RegisterCommand("test", CommandChatType.CHAT_ALLY, CommandAccessLevel.ACCESS_ME);
  this:RegisterCommand("setdebuff", CommandChatType.CHAT_ALLY, CommandAccessLevel.ACCESS_ME);
end;

--Drecease Fire Resistance 11077
--Elementar Destruction Fire 11101

--Elemental Mass Burst 11107 11025


function OnMagicSkillLaunched(user, target, skillId, skillLvl)
	if (user:IsMe()) then
		local skilllaunched = skillId;
    dprint("Nuker Combo","Nuke Id " .. tostring(skilllaunched) .. " has been lauched.");
    if (target ~= nil) then
      if BuffDebug then
        local buffCount = target:GetBuffsCount();
        if (buffCount > 0) then
          ShowToClient("Nuker Combo","Buffs Log Start Count " .. tostring(buffCount));
          for buffId = 0,buffCount - 1 do
            ShowToClient("Nuker Combo","Last Buffs Id " .. tostring(target:GetBuffByIdx(buffId).skillId) .. " Index " .. tostring(target:GetBuffByIdx(buffId).index));
          end;
          ShowToClient("Nuker Combo","Buffs Log Ended ----------------- ");
        end;
      end;
      if (skillId == DebuffId) then
        dprint("Nuker Combo","Cast Elemental Mass Burst");
        CastSkill(candidateskill)
      end;
      local destructionBuff = target:GetBuff(DebuffId)
      dprint("Nuker Combo","Nuke Id " .. tostring(skillId) .. " has been used.");
      if (destructionBuff ~= nil and skillId ~= candidateskill) then
        dprint("Nuker Combo","Cast Elemental Mass Burst");
        CastSkill(candidateskill)
      end;
    end;
	end;
end;

-- function OnMagicSkillUse(user, target, skillId, skillvl, skillHitTime, skillReuse)
--   local destructionBuff = target:GetBuff(11101)
--   dprint("Nuker Combo","Nuke Id " .. tostring(skillId) .. " has been used.");
--   if (destructionBuff ~= nil and skillId ~= candidateskill) then
--     dprint("Nuker Combo","Cast Elemental Mass Burst");
--     CastSkill(candidateskill)
--   end;
-- end;

function OnCommand_buffdebug(vCommandChatType, vNick, vCommandParam)
  if BuffDebug then
    BuffDebug = false
    ShowToClient("Nuker Combo","Debug Buff OFF");
  else
    BuffDebug = true
    ShowToClient("Nuker Combo","Debug Buff ON");
  end;
end;

function OnCommand_test(vCommandChatType, vNick, vCommandParam)
  ShowToClient("Nuker Combo Debug","vNick " .. vNick);
  if (vCommandParam ~= nil) then
    ShowToClient("Nuker Combo Debug","vCommandParam Count " .. tostring(vCommandParam:GetCount()));
    if (vCommandParam:GetCount() > 0) then
      ShowToClient("Nuker Combo Debug","vCommandParam String " .. tostring(vCommandParam:GetParam(0):GetStr(true)) );

    end;
  end;
end;

function OnCommand_setdebuff(vCommandChatType, vNick, vCommandParam)
  if (vCommandParam ~= nil) then
    if (vCommandParam:GetCount() > 0) then
      local newDebuffId = vCommandParam:GetParam(0):GetInt()
      if newDebuffId ~= nil then
        ShowToClient("Nuker Combo Debug","Set Debuff ID " .. tostring(newDebuffId) );
        DebuffId = newDebuffId
      end;
    end;
  end;
end

function dprint(msg)
  if LogDebug then
    ShowToClient("DEBUG",msg);
  end
end

function eprint(msg)
  ShowToClient("ERROR",msg);
end

function CastSkill(id)
  dprint("Nuker Combo","Cast Skill " .. tostring(id));
  if nil == tonumber(id) then return dprint("CastSkill(id) - >> id not a number") end
  local castSkill = GetSkills():FindById(id)
  dprint("CastSkill(id) ->> skill ".. tostring(nil ~= castSkill).. " skill:CanBeUsed()" .. tostring(castSkill:CanBeUsed()))
  if castSkill and castSkill:CanBeUsed() then
          UseSkillRaw(id,CtrlAttack,false)
          return true
  end
  return false
end

function GetSkillIdByName(name)
	skills = GetSkills()
	for s in skills.list do
		if s.name == name then
			return s.skillId
		end
	end
	return nil
end
