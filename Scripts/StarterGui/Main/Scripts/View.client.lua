local player = game.Players.LocalPlayer
local cash: IntValue = player:WaitForChild('Cash')

local scripts = script.Parent

-- items

local ui = scripts.Parent
local shop = ui.Shop
local notification = ui.Notification
local balance = ui.Balance

local scroll = shop.Center
local close = shop.Close

-- modules

presenter = require(scripts.Presenter)

function showNotification(text: string)
	notification.Visible = true
	notification.Text = text
	task.wait(1)
	notification.Visible = false
end

function closeActivated() shop.Visible = false end
function cashChanged(value) balance.Text = '$ ' .. value end

balance.Text = '$ ' .. cash.Value

cash.Changed:Connect(cashChanged)
close.Activated:Connect(closeActivated)

presenter.constructor({		
	shop = shop,
	showNotification = showNotification,
})

presenter.createShop(scroll)

