item_buccaneer_armor_1 = class({})

function item_buccaneer_armor_1:GetIntrinsicModifierName()
	return "modifier_item_buccaneer_armor"
end

item_buccaneer_armor_2 = class(item_buccaneer_armor_1)
item_buccaneer_armor_3 = class(item_buccaneer_armor_1)
item_buccaneer_armor_4 = class(item_buccaneer_armor_1)
item_buccaneer_armor_5 = class(item_buccaneer_armor_1)

modifier_item_buccaneer_armor = class({})
LinkLuaModifier("modifier_item_buccaneer_armor", "items/buccaneer/item_buccaneer_armor.lua", 0)

function modifier_item_buccaneer_armor:OnCreated()
	self.bonus_hp = self:GetSpecialValueFor("bonus_hp")
	self.armor = self:GetSpecialValueFor("bonus_armor")
	self.evasion = self:GetSpecialValueFor("evasion")
	-- if IsServer() then
		-- self:GetCaster():SetEquippedArmor( self:GetAbility():GetAttachmentName() )
	-- end
end

function modifier_item_buccaneer_armor:OnRefresh()
	self.bonus_hp = self:GetSpecialValueFor("bonus_hp")
	self.armor = self:GetSpecialValueFor("bonus_armor")
	self.evasion = self:GetSpecialValueFor("evasion")
end

function modifier_item_buccaneer_armor:DeclareFunctions()
	return {MODIFIER_PROPERTY_HEALTH_BONUS, MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, MODIFIER_PROPERTY_EVASION_CONSTANT}
end

function modifier_item_buccaneer_armor:GetModifierHealthBonus()
	return self.bonus_hp
end

function modifier_item_buccaneer_armor:GetModifierPhysicalArmorBonus()
	return self.armor
end

function modifier_item_buccaneer_armor:GetModifierEvasion_Constant()
	return self.evasion
end

function modifier_item_buccaneer_armor:IsHidden()
	return true
end