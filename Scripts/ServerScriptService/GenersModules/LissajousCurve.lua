
function part()
	local p = script.Part:Clone()
	p.Parent = workspace	
	return p
end


local curve = {}; curve.__index = curve
function curve.new()
	local self = setmetatable({}, curve)
	self.path = {} :: {Vector3}
	self.current = Vector3.new(0, 0, 0)
	return self
end

function curve:setX(x) self.current = Vector3.new(x, 0, self.current.Z)  end
function curve:setZ(z) self.current = Vector3.new(self.current.X, 0, z) end
function curve:addPoint() table.insert(self.path, self.current) end
function curve:reset() self.path = {Vector3} end
function curve:show() 	
	for i, v in self.path do
		part().Position = v
	end
end

--[[

class Curve {

  constructor() {
    this.path = [];
    this.current = createVector();
  }

   setX( x) {
    this.current.x = x;
  }

   setY( y) {
    this.current.y = y;
  }

   addPoint() {
    this.path.push(this.current);
  }
  
   reset() {
    this.path = []; 
  }

   show() {
    stroke(255);
    strokeWeight(1);
    noFill();
    beginShape();
    for (let v of this.path) {
      vertex(v.x, v.y);
    }
    endShape();

    strokeWeight(8);
    point(this.current.x, this.current.y);
    this.current = createVector();
  }
}

]]

local angle = 0
local w = 12
local cols
local rows
local curves = {}

local width = 100
local height = 100

--function setup()
--	cols = math.floor(width / w) - 1;
--	rows = math.floor(height / w) - 1;
	
--	for i = 1, rows do
--		curves[i] = {}
--		for j = 1, cols do
--			curves[i][j] = curve.new()
--		end
--	end
--end

function setup_()
	cols = math.floor(width / w) - 1;
	rows = math.floor(height / w) - 1;

	curves[1] = curve.new()
	--for i = 1, rows do
	--end
end

--function draw()
--	local d = w - 0.2 * w
--	local r = d / 2

--	for i = 1, cols do
--		local cx = w + i * w + w / 2
--		local cz = w / 2
--		local x = r * math.cos(angle * (i + 1) - (math.pi / 2))
--		local z = r * math.sin(angle * (i + 1) - (math.pi / 2))
--		--line(cx + x, 0, cx + x, height);

--		for j = 1, rows do
--			curves[j][i]:setX(cx + x)
--		end
--	end

--	for j = 1, rows do
--		local cx = w / 2
--		local cz = w + j * w + w / 2
--		local x = r * math.cos(angle * (j + 1) - (math.pi / 2))
--		local z = r * math.sin(angle * (j + 1) - (math.pi / 2))
--		--line(0, cy + y, width, cy + y);

--		for i = 1, cols do
--			curves[j][i]:setZ(cz + z)
--		end
--	end

--	for j = 1, rows do
--		for i = 1, cols do
--			curves[j][i]:addPoint()
--			curves[j][i]:show()
--		end
--	end

--	angle -= 0.01;

--	if (angle < -math.pi * 2) then
--		for j = 1, rows do
--			for i = 1, cols do
--				curves[j][i].reset();
--			end
--		end
--		angle = 0
--	end
--end

function draw_()
	local d = w - 0.2 * w
	local r = d / 2

	for i = 1, cols do
		local cx = w + i * w + w / 2
		local cz = w / 2
		local x = r * math.cos(angle * (i + 1) - (math.pi / 2))
		local z = r * math.sin(angle * (i + 1) - (math.pi / 2))
		--line(cx + x, 0, cx + x, height);

		for j = 1, rows do
			curves[1]:setX(cx + x)
		end
	end

	for j = 1, rows do
		local cx = w / 2
		local cz = w + j * w + w / 2
		local x = r * math.cos(angle * (j + 1) - (math.pi / 2))
		local z = r * math.sin(angle * (j + 1) - (math.pi / 2))
		--line(0, cy + y, width, cy + y);

		for i = 1, cols do
			curves[1]:setZ(cz + z)
		end
	end

	for j = 1, rows do
		curves[1]:addPoint()
		curves[1]:show()
	end

	angle -= 0.01;

	if (angle < -math.pi * 2) then
		for j = 1, rows do
			for i = 1, cols do
				curves[j][i].reset();
			end
		end
		angle = 0
	end
end

setup()

print(curves)

while wait() do
	draw()
end

--[[

function make2DArray(rows, cols) {
  var arr = new Array(rows); //like arr[]; but with number of columns hardcoded
  for (var i = 0; i < arr.length; i++) {
    arr[i] = new Array(cols);
  }
  return arr;
}

let angle = 0;
let w = 120;
let cols;
let rows;
let curves;

function setup() {
  createCanvas(windowWidth, windowHeight);
  cols = floor(width / w) - 1;
  rows = floor(height / w) - 1;
  curves = make2DArray(rows,cols);

  for (let j = 0; j < rows; j++) {
    for (let i = 0; i < cols; i++) {
      curves[j][i] = new Curve();
    }
  }
}

function draw() {
  background(0);
  let d = w - 0.2 * w;
  let r = d / 2;

  noFill();
  stroke(255);
  for (let i = 0; i < cols; i++) {
    let cx = w + i * w + w / 2;
    let cy = w / 2;
    strokeWeight(1);
    stroke(255);
    ellipse(cx, cy, d, d);
    let x = r * cos(angle * (i + 1) - HALF_PI);
    let y = r * sin(angle * (i + 1) - HALF_PI);
    strokeWeight(8);
    stroke(255);
    point(cx + x, cy + y);
    stroke(255, 150);
    strokeWeight(1);
    line(cx + x, 0, cx + x, height);

    for (let j = 0; j < rows; j++) {
      curves[j][i].setX(cx + x);
    }
  }

  noFill();
  stroke(255);
  for (let j = 0; j < rows; j++) {
    let cx = w / 2;
    let cy = w + j * w + w / 2;
    strokeWeight(1);
    stroke(255);
    ellipse(cx, cy, d, d);
    let x = r * cos(angle * (j + 1) - HALF_PI);
    let y = r * sin(angle * (j + 1) - HALF_PI);
    strokeWeight(8);
    stroke(255);
    point(cx + x, cy + y);
    stroke(255, 150);
    strokeWeight(1);
    line(0, cy + y, width, cy + y);

    for (let i = 0; i < cols; i++) {
      curves[j][i].setY(cy + y);
    }
  }

  for (let j = 0; j < rows; j++) {
    for (let i = 0; i < cols; i++) {
      curves[j][i].addPoint();
      curves[j][i].show();
    }
  }


  angle -= 0.01;

  if (angle < -TWO_PI) {
    for (let j = 0; j < rows; j++) {
      for (let i = 0; i < cols; i++) {
        curves[j][i].reset();
      }
    }
    // saveFrame("lissajous#####.png");
    angle = 0;
  }
}

]]