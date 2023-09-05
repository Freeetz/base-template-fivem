ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_basicneeds:removeItem')
AddEventHandler('esx_basicneeds:removeItem', function(item)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    xPlayer.removeInventoryItem(item, 1)

end)

RegisterServerEvent('esx_basicneeds:updateStatus')
AddEventHandler('esx_basicneeds:updateStatus', function(type, count)
	
	TriggerClientEvent('esx_status:add', source, type, count)

end)

-- Eating
ESX.RegisterUsableItem('bread', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('bread', 1)
	TriggerClientEvent('esx_basicneeds:onEat', source, 'v_res_fa_bread03', 'bread', 'hunger', 100000, 'กิน <strong class="green-text">ขนมปัง</strong> 1 ชิ้น')
end)

ESX.RegisterUsableItem('burger', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('burger', 1)
	TriggerClientEvent('esx_basicneeds:onEat', source, 'prop_cs_burger_01', 'burger', 'hunger', 165000, 'กิน <strong class="green-text">เบอเกอร์เนื้อดับเบิ้ลชีส</strong> 1 ชิ้น')
end)
--
ESX.RegisterUsableItem('hotdog', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('hotdog', 1)
	TriggerClientEvent('esx_basicneeds:onEat', source, 'prop_cs_hotdog_01', 'hotdog', 'hunger', 20000, 'กิน <strong class="green-text">ฮอทดอก</strong> 1 ชิ้น')
end)

ESX.RegisterUsableItem('taco', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('taco', 1)
	TriggerClientEvent('esx_basicneeds:onEat', source, 'prop_taco_01', 'taco', 'hunger', 10000, 'กิน <strong class="green-text">ทาโก้</strong> 1 ชิ้น')
end)

ESX.RegisterUsableItem('sandwich', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('sandwich', 1)
	TriggerClientEvent('esx_basicneeds:onEat', source, 'prop_sandwich_01', 'sanwich', 'hunger', 10000, 'กิน <strong class="green-text">แซนวิสปลา</strong> 1 ชิ้น')
end)

ESX.RegisterUsableItem('pie', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('pie', 1)
	TriggerClientEvent('esx_basicneeds:onEat', source, 'prop_food_bs_chips', 'pie', 'hunger', 10000, 'กิน <strong class="green-text">พายไก่</strong> 1 ชิ้น')
end)

ESX.RegisterUsableItem('mixapero', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('mixapero', 1)
	TriggerClientEvent('esx_basicneeds:onEat', source, 'prop_food_bs_burger2', 'bread', 'hunger', 10000, 'กิน <strong class="green-text">ขนมปัง</strong> 1 ชิ้น')
end)

-- Drink
ESX.RegisterUsableItem('water', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('water', 1)
	TriggerClientEvent('esx_basicneeds:onDrink', source, 'prop_ld_flow_bottle', 'water', 'thirst', 100000, 'ดื่ม <strong class="blue-text">น้ำ</strong> 1 ขวด')
end)

ESX.RegisterUsableItem('cola', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('cola', 1)
	TriggerClientEvent('esx_basicneeds:onDrink', source, 'prop_ecola_can', 'cola', 'thirst', 50000, 'ดื่ม <strong class="blue-text">น้ำโคล่า</strong> 1 กระป๋อง')
end)

ESX.RegisterUsableItem('coffee', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('coffee', 1)
	TriggerClientEvent('esx_basicneeds:onDrink2', source, 'p_amb_coffeecup_01', 'coffee', 'thirst', 300000, 'ดื่ม <strong class="brown-text">กาแฟ</strong> 1 แก้ว')
end)

ESX.RegisterUsableItem('juice', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('juice', 1)
	TriggerClientEvent('esx_basicneeds:onDrink', source, 'prop_ld_can_01', 'juice', 'thirst', 200000, 'ดื่ม <strong class="orange-text">น้ำผลไม้</strong> 1 กระป๋อง')
end)

ESX.RegisterUsableItem('jager', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('jager', 1)
	TriggerClientEvent('esx_basicneeds:onDrink', source, 'prop_ld_can_01', 'juice', 'thirst', 100000, 'ดื่ม <strong class="orange-text">น้ำผลไม้</strong> 1 กระป๋อง')
end)

ESX.RegisterUsableItem('jagerbomb', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('jagerbomb', 1)
	TriggerClientEvent('esx_basicneeds:onDrink', source, 'prop_ld_can_01', 'juice', 'thirst', 200000, 'ดื่ม <strong class="orange-text">น้ำผลไม้</strong> 1 กระป๋อง')
end)

--

ESX.RegisterUsableItem('whiskycoca', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('whiskycoca', 1)
	TriggerClientEvent('esx_basicneeds:onDrink', source, 'prop_cs_bs_cup', 'juice', 'thirst', 100000, 'ดื่ม <strong class="orange-text">น้ำผลไม้</strong> 1 กระป๋อง')
end)

ESX.RegisterUsableItem('vodkafruit', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('vodkafruit', 1)
	TriggerClientEvent('esx_basicneeds:onDrink', source, 'prop_plastic_cup_02', 'juice', 'thirst', 200000, 'ดื่ม <strong class="orange-text">น้ำผลไม้</strong> 1 กระป๋อง')
end)

ESX.RegisterUsableItem('rhumfruit', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('rhumfruit', 1)
	TriggerClientEvent('esx_basicneeds:onDrink', source, 'prop_plastic_cup_02', 'juice', 'thirst', 150000, 'ดื่ม <strong class="orange-text">น้ำผลไม้</strong> 1 กระป๋อง')
end)

ESX.RegisterUsableItem('rhumcoca', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('rhumcoca', 1)
	TriggerClientEvent('esx_basicneeds:onDrink', source, 'prop_cs_bs_cup', 'juice', 'thirst', 250000, 'ดื่ม <strong class="orange-text">น้ำผลไม้</strong> 1 กระป๋อง')
end)

ESX.RegisterUsableItem('mojito', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('mojito', 1)
	TriggerClientEvent('esx_basicneeds:onDrink', source, 'p_amb_coffeecup_01', 'juice', 'thirst', 100000, 'ดื่ม <strong class="orange-text">น้ำผลไม้</strong> 1 กระป๋อง')
end)

ESX.RegisterUsableItem('metreshooter', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('metreshooter', 1)
	TriggerClientEvent('esx_basicneeds:onDrink', source, 'prop_cs_bs_cup', 'juice', 'thirst', 100000, 'ดื่ม <strong class="orange-text">น้ำผลไม้</strong> 1 กระป๋อง')
end)

ESX.RegisterUsableItem('jagercerbere', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('jagercerbere', 1)
	TriggerClientEvent('esx_basicneeds:onDrink', source, 'prop_bottle_cognac', 'juice', 'thirst', 100000, 'ดื่ม <strong class="orange-text">น้ำผลไม้</strong> 1 กระป๋อง')
end)






-- BURGER SHOOOT

ESX.RegisterUsableItem('nuggets', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('nuggets', 1)
	TriggerClientEvent('esx_basicneeds:onEat', source, 'prop_int_cf_chick_01', 'bread', 'hunger', 200000, 'กิน <strong class="green-text">ขนมปัง</strong> 1 ชิ้น')
end)

ESX.RegisterUsableItem('cheeseburger', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('cheeseburger', 1)
	TriggerClientEvent('esx_basicneeds:onEat', source, 'prop_cs_burger_01', 'bread', 'hunger', 200000, 'กิน <strong class="green-text">ขนมปัง</strong> 1 ชิ้น')
end)

ESX.RegisterUsableItem('wrap', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('wrap', 1)
	TriggerClientEvent('esx_basicneeds:onEat', source, 'prop_food_bs_burger2', 'bread', 'hunger', 200000, 'กิน <strong class="green-text">ขนมปัง</strong> 1 ชิ้น')
end)

ESX.RegisterUsableItem('frite', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('frite', 1)
	TriggerClientEvent('esx_basicneeds:onEat', source, 'prop_food_bs_burger2', 'bread', 'hunger', 200000, 'กิน <strong class="green-text">ขนมปัง</strong> 1 ชิ้น')
end)


---


ESX.RegisterUsableItem('coca', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('coca', 1)
	TriggerClientEvent('esx_basicneeds:onDrink', source, 'prop_ld_can_01', 'juice', 'thirst', 200000, 'ดื่ม <strong class="orange-text">น้ำผลไม้</strong> 1 กระป๋อง')
end)

ESX.RegisterUsableItem('fanta', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('fanta', 1)
	TriggerClientEvent('esx_basicneeds:onDrink', source, 'prop_ld_can_01', 'juice', 'thirst', 200000, 'ดื่ม <strong class="orange-text">น้ำผลไม้</strong> 1 กระป๋อง')
end)

ESX.RegisterUsableItem('sprite', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('sprite', 1)
	TriggerClientEvent('esx_basicneeds:onDrink', source, 'prop_ld_can_01', 'juice', 'thirst', 200000, 'ดื่ม <strong class="orange-text">น้ำผลไม้</strong> 1 กระป๋อง')
end)