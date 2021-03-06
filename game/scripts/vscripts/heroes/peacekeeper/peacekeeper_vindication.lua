peacekeeper_vindication = class({})
LinkLuaModifier( "modifier_vindication", "heroes/peacekeeper/peacekeeper_vindication.lua" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_vindication_ally", "heroes/peacekeeper/peacekeeper_vindication.lua" ,LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
function peacekeeper_vindication:OnSpellStart()
	local caster = self:GetCaster()
	local cursorTar = self:GetCursorTarget()

	local duration = self:GetSpecialValueFor("duration")

	local launch = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_psi_blade.vpcf", PATTACH_POINT, caster)
	ParticleManager:SetParticleControlEnt(launch, 0, caster, PATTACH_POINT, "attach_attack1", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(launch, 1, cursorTar, PATTACH_POINT, "attach_hitloc", cursorTar:GetAbsOrigin(), true)

	if cursorTar:GetTeam() ~= caster:GetTeam() and not cursorTar:IsMagicImmune() then
		local units = caster:FindEnemyUnitsInRadius(caster:GetAbsOrigin(), FIND_UNITS_EVERYWHERE, {})
		for _,unit in pairs(units) do
			unit:RemoveModifierByName("modifier_vindication")
		end
		cursorTar:AddNewModifier(caster,self,"modifier_vindication",{Duration = duration})
		EmitSoundOn("Hero_TemplarAssassin.Meld",cursorTar)
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
modifier_vindication_ally = class({})

function modifier_vindication_ally:OnCreated(table)
	self.caster = self:GetCaster()

	self.move_speed = self:GetSpecialValueFor("move_speed")
end

function modifier_vindication_ally:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

function modifier_vindication_ally:GetModifierMoveSpeedBonus_Percentage( params )
	return self.move_speed
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
modifier_vindication = class({})

function modifier_vindication:OnCreated(table)
	if IsServer() then
		self.caster = self:GetCaster()
		self.mainBaddie = self:GetParent()

		local units = FindUnitsInRadius(self.caster:GetTeam(),self.mainBaddie:GetAbsOrigin(),nil,FIND_UNITS_EVERYWHERE,DOTA_UNIT_TARGET_TEAM_FRIENDLY,DOTA_UNIT_TARGET_ALL,DOTA_UNIT_TARGET_FLAG_NONE,FIND_ANY_ORDER,false)
		for _,unit in pairs(units) do
			if unit == self.caster then
				unit:AddNewModifier(self.caster,self:GetAbility(),"modifier_vindication_ally",{Duration = self:GetAbility().duration})
			end
		end
	end
end

function modifier_vindication:GetEffectName()
	return "particles/heroes/peacekeeper/peacekeeper_vindication_debuff.vpcf"
end

function modifier_vindication:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_vindication:IsDebuff()
	return true
end

function modifier_vindication:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
	return funcs
end

function modifier_vindication:OnTakeDamage( params )
	if IsServer() then
		if params.unit == self.mainBaddie then
			local damage = params.damage
			local attacker = params.attacker

			if attacker:GetTeam() == self.caster:GetTeam() then
				attacker:Lifesteal(self:GetAbility(), self:GetSpecialValueFor("lifesteal"), damage)
			end
		end
	end
end

function modifier_vindication:OnDestroy()
	if IsServer() then
		local units = FindUnitsInRadius(self.caster:GetTeam(),self.mainBaddie:GetAbsOrigin(),nil,FIND_UNITS_EVERYWHERE,DOTA_UNIT_TARGET_TEAM_FRIENDLY,DOTA_UNIT_TARGET_ALL,DOTA_UNIT_TARGET_FLAG_NONE,FIND_ANY_ORDER,false)
		for _,unit in pairs(units) do
			if unit:HasModifier("modifier_vindication_ally") then
				unit:RemoveModifierByName("modifier_vindication_ally")
			end
		end
	end
end
