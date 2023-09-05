-- CORE --
local Group = setmetatable({}, Group)
Group.__index = Group
Group.__call = function() return "Group" end

function Group.New(Name, Inherits)
	local _Group = {
		Name = tostring(Name),
		Inherits = tostring(Inherits)
	}

	return setmetatable(_Group, Group)
end

function Group:canTarget(target)
	if (self.Name == Config.DefaultGroup) then
		return false
	else
		if (self.Name == target.Name) then
			return true
		elseif (self.Inherits == target.Name) then
			return true
		else
			return ESX.Groups[self.Inherits]:canTarget(target)
		end
	end
end

-- SCRIPT --

ESX.AddGroup = function(name, inherits)
	if (type(name) ~= 'string') then
		print("ES_ERROR: There seems to be an issue while creating a new group, please make sure that you entered a correct 'group' as 'string'")
	end

	if (type(inherits) ~= 'string') then
		print("ES_ERROR: There seems to be an issue while creating a new group, please make sure that you entered a correct 'inherit' as 'string'")
	end

	ExecuteCommand('add_principal group.' .. name .. ' group.' .. inherits)
	ESX.Groups[name] = Group.New(name, inherits)
end

ESX.GroupCanTarget = function(targetGroup1, targetGroup2, cb)
	if ESX.Groups[targetGroup1] and ESX.Groups[targetGroup2] then
		if cb then
			cb(ESX.Groups[targetGroup1]:canTarget(ESX.Groups[targetGroup2]))
		else
			return ESX.Groups[targetGroup1]:canTarget(ESX.Groups[targetGroup2])
		end
	else
		if cb then
			cb(false)
		else
			return false
		end
	end
end

-- Default groups
ESX.AddGroup(Config.DefaultGroup, '')
ESX.AddGroup('support', Config.DefaultGroup)
ESX.AddGroup('helpt', 'support')
ESX.AddGroup('help', 'helpt')
ESX.AddGroup('mod', 'help')
ESX.AddGroup('gm', 'mod')
ESX.AddGroup('gerantl', 'gm')
ESX.AddGroup('geranti', 'gerantl')
ESX.AddGroup('gerants', 'geranti')
ESX.AddGroup('mainteam', 'gerants')
ESX.AddGroup('admin', 'mainteam')
ESX.AddGroup('superadmin', 'admin')
ESX.AddGroup('owner', 'superadmin')
ESX.AddGroup('gerantglo', 'owner')
ESX.AddGroup('cofonda', 'gerantglo')
ESX.AddGroup('_dev', 'cofonda')

-- support → support
-- helpt → Helper Test
-- helpt → Helper
-- mod → Modérateur
-- gerantl → Gérant Légal
-- geranti → Gérant Illégal
-- admin → Administrateur
-- superadmin → Super Admin
-- owner → Gérant Staff
-- cofonda → Co Fondateur
-- _dev → Fondateur

--[[

ESX.AddGroup(Config.DefaultGroup, '')
ESX.AddGroup('support', Config.DefaultGroup)
ESX.AddGroup('helpt', 'support')
ESX.AddGroup('help', 'helpt')
ESX.AddGroup('mod', 'help')
ESX.AddGroup('gm', 'mod')
ESX.AddGroup('gerantl', 'gm')
ESX.AddGroup('geranti', 'gerantl')
ESX.AddGroup('gerants', 'geranti')
ESX.AddGroup('admin', 'gerants')
ESX.AddGroup('superadmin', 'admin')
ESX.AddGroup('owner', 'superadmin')
ESX.AddGroup('cofonda', 'owner')
ESX.AddGroup('_dev', 'cofonda')

--]]