
local x = {}
local y = {}
local fourierX
local fourierY
local t = 0
local path = {}
local drawing = {}
local state = -1


local width = 100
local height = 100

function part(pos)
	local p = script.Part:Clone()
	p.Parent = workspace
	p.Position = pos
end

function dft(vals)
	local X = {}
	local N = #vals

	for k = 1, N do
		local re = 0
		local im = 0
		for n = 1, N do
			local phi = ((math.pi * 2) * (k - 1) * (n - 1)) / N
			re += vals[n] * math.cos(phi)
			im -= vals[n] * math.sin(phi)
		end

		re /= N
		im /= N

		local freq = k - 1
		local amp = math.sqrt(re ^ 2 + im ^ 2)
		local phase = math.atan2(im, re)

		X[k] = {
			re = re,
			im = im,
			freq = freq,
			amp = amp,
			phase = phase,
		}

	end

	return X
end

function input(d)
	
	print(d)
	
	state = 'INPUT'
	drawing = d	
end

function output()
	state = 'OUTPUT'
	local skip = 1

	for i = 1, #drawing, skip do
		table.insert(x, drawing[i].X)
		table.insert(y, drawing[i].Y)
	end

	fourierX = dft(x)
	fourierY = dft(y)

	print(fourierY)
	print(fourierX)

	table.sort(fourierX, function(a, b) return b.amp < a.amp end)
	table.sort(fourierY, function(a, b) return b.amp < a.amp end)
end

function epiCycles(x, y, rotation, fourier)
	for i = 1, #fourier do
		local prevx = x
		local prevy = y
		local freq = fourier[i].freq
		local radius = fourier[i].amp
		local phase = fourier[i].phase
		x += radius * math.cos(freq * t + phase + rotation)
		y += radius * math.sin(freq * t + phase + rotation)

		--line(prevx, prevy, x, y);
	end

	return Vector3.new(x, 5, y)

end

function draw() 

	if (state == 'OUTPUT') then
		local vx = epiCycles(width / 2, 100, 0, fourierX)
		local vy = epiCycles(100, height / 2, (math.pi / 2), fourierY)
		local v = Vector3.new(vx.X, 5, vy.Z);
		table.insert(path, 1, v)

		for i = 1, #path do
			part(path[i])
		end

		local dt = (math.pi * 2) / #fourierY
		t += dt

		if (t > (math.pi * 2)) then
			t = 0
			path = {}
		end
	end
end

local a

a = game.ReplicatedStorage.RemoteEvent.OnServerEvent:Connect(function(p, d)
	input(d)
	
	a:Disconnect()
	
	wait(3)
	
	output()

	for i = 1, 100 do draw() end	
end)

