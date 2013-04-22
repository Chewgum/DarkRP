/*---------------------------------------------------------------------------
Create a shipment from a spawned_weapon
---------------------------------------------------------------------------*/
local function createShipment(ply, args)
	local id = tonumber(args) or -1
	local ent = Entity(id)

	ent = IsValid(ent) and ent or ply:GetEyeTrace().Entity

	if not IsValid(ent) or ent:GetClass() ~= "spawned_weapon" then return end

	local shipID
	for k,v in pairs(CustomShipments) do
		if v.entity == ent.weaponclass then
			shipID = k
			break
		end
	end

	if not shipID then return end

	local crate = ents.Create("spawned_shipment")
	crate.SID = ply.SID
	crate:SetPos(ent:GetPos())
	crate.nodupe = true
	crate:SetContents(shipID, ent.dt.amount)
	crate:Spawn()
	crate:SetPlayer(ply)
	crate.clip1 = ent.clip1
	crate.clip2 = ent.clip2
	crate.ammoadd = ent.ammoadd or 0

	SafeRemoveEntity(ent)

	local phys = crate:GetPhysicsObject()
	phys:Wake()
end
DarkRP.AddChatCommand("/makeshipment", createShipment)

/*---------------------------------------------------------------------------
Split a shipment in two
---------------------------------------------------------------------------*/
local function splitShipment(ply, args)
	local id = tonumber(args) or -1
	local ent = Entity(id)

	ent = IsValid(ent) and ent or ply:GetEyeTrace().Entity

	if not IsValid(ent) or ent:GetClass() ~= "spawned_shipment" or ent:Getcount() < 2 then return end

	local count = math.floor(ent:Getcount() / 2)
	ent:Setcount(ent:Getcount() - count)

	local crate = ents.Create("spawned_shipment")
	crate.SID = ply.SID
	crate:SetPos(ent:GetPos())
	crate.nodupe = true
	crate:SetContents(ent:Getcontents(), count)
	crate:SetPlayer(ply)

	crate.clip1 = ent.clip1
	crate.clip2 = ent.clip2
	crate.ammoadd = ent.ammoadd

	crate:Spawn()

	local phys = crate:GetPhysicsObject()
	phys:Wake()
end
DarkRP.AddChatCommand("/splitshipment", splitShipment)