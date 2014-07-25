-- Function called when the game starts
function love.load()

	-- Window data
	Window = {}
	Window.width = love.window.getWidth()
	Window.height = love.window.getHeight()

	-- Program data
	Program = {}
	Program.state = "menu"

	-- Game data
	Game = {}
	Game.playing = true
	Game.stars= {}
	for i=0,30 do
		table.insert(Game.stars, {x = love.math.random(0,1280), y = love.math.random(0, 720)})
	end
	Game.tick = 0

	-- Menu data
	Menu = {}
	Menu.selected = 0

	-- Images
	Images = {}
	Images.game = {}
	Images.menu = {}
	Images.menu.title = love.graphics.newImage("menu_title.png")
	Images.menu.play_white = love.graphics.newImage("play_white.png")
	Images.menu.play_red = love.graphics.newImage("play_red.png")
	Images.menu.scores_white = love.graphics.newImage("scores_white.png")
	Images.menu.scores_red = love.graphics.newImage("scores_red.png")
	Images.menu.quit_white = love.graphics.newImage("quit_white.png")
	Images.menu.quit_red = love.graphics.newImage("quit_red.png")
	Images.game.one = love.graphics.newImage("one.gif")
	Images.game.two = love.graphics.newImage("two.gif")
	Images.game.three = love.graphics.newImage("three.gif")
	Images.game.four = love.graphics.newImage("four.gif")
	Images.game.five = love.graphics.newImage("five.gif")

	-- Player data
	Player = {}
	Player.x = Window.width * .1
	Player.y = Window.height * .5
	Player.bullets = {}
	Player.image = love.graphics.newImage("player.png")

	-- Enemy data
	EnemyArray = {}
end

-- Draw the game
function love.draw()

	-- Draw the menu options
	if Program.state == "menu" then
		love.graphics.draw(Images.menu.title, Window.width / 2 - 691 / 2, Window.height * .075)
		if Menu.selected == 0 then
			love.graphics.draw(Images.menu.play_red, Window.width / 2 - 107 / 2, Window.height * .6)
		else
			love.graphics.draw(Images.menu.play_white, Window.width / 2 - 107 / 2, Window.height * .6)
		end
		if Menu.selected == 1 then
			love.graphics.draw(Images.menu.scores_red, Window.width / 2 - 188 / 2, Window.height * .675)
		else
			love.graphics.draw(Images.menu.scores_white, Window.width / 2 - 186 / 2, Window.height * .675)
		end
		if Menu.selected == 2 then
			love.graphics.draw(Images.menu.quit_red, Window.width / 2 - 100 / 2, Window.height * .75)
		else
			love.graphics.draw(Images.menu.quit_white, Window.width / 2 - 100 / 2, Window.height * .75)
		end
	end

	-- Draw the game
	if Program.state == "play" then

		-- When the game is paused
		if not Game.playing then
			love.graphics.print("Quit (Q)", 50, 50)
			love.graphics.print("Resume(Esc)", 50, 75)
		end

		-- Draw enemies
		for index,Enemy in ipairs(EnemyArray) do
			love.graphics.draw(Enemy.image, Enemy.x, Enemy.y)
		end
		
		-- Draw player
		love.graphics.draw(Player.image, Player.x, Player.y)
		
		-- Draw bullets
		for index,Bullet in ipairs(Player.bullets) do
			love.graphics.circle("fill", Bullet.x, Bullet.y, 3, 100)
		end
		
		-- Draw stars
		love.graphics.setColor(255,248,153)
		for index,Star in ipairs(Game.stars) do
			love.graphics.circle("fill", Star.x, Star.y, 1)
		end
		love.graphics.setColor(255,255,255)
	end
end

-- Update the values
function love.update(dt)

	-- When the game is not paused
	if(Game.playing) then
		-- Move the player
		if(love.keyboard.isDown("w")) or (love.keyboard.isDown("up")) then
			if Player.y >= 0 then
				Player.y = Player.y - 3
			end
		end
		if(love.keyboard.isDown("s")) or (love.keyboard.isDown("down")) then
			if Player.y <= Window.height - 40 then
				Player.y = Player.y + 3
			end
		end

		-- Tick tracking
		Game.tick = Game.tick + 1
		if(Game.tick >= 120) then
			spawnEnemy()
			Game.tick = 0
		end

		-- Do the enemy stuff
		adjustImages()
		moveEnemies()
		
		-- Do bullet stuff
		moveBullets()
	end
end

-- Get the pressed keys
function love.keypressed(key, ispressed)

	-- When the user is at the menu
	if Program.state == "menu" then
		if key == "w" or key == "up" then
			if Menu.selected == 0 then
				Menu.selected = 2
			else
				Menu.selected = Menu.selected - 1
			end
		end
		if key == "s" or key == "down" then
			if Menu.selected == 2 then
				Menu.selected = 0
			else
				Menu.selected = Menu.selected + 1
			end
		end
		if key == "return" then
			if Menu.selected == 0 then
				Program.state = "play"
			elseif Menu.selected == 1 then
				Program.state = "scores"
			elseif Menu.selected == 2 then
				love.event.push("quit")
			end
		end
	end

	-- When the game is running
	if Program.state == "play" then
		if(key == " ") then
			fireBullet()
		end
		if(key == "escape") then
			Game.playing = not Game.playing
		end
		if not Game.playing and key == "q" then
			love.event.push("quit")
		end
	end
end

-- Add a new enemy to the game
function spawnEnemy()
	table.insert(EnemyArray,{x = 1280, y = love.math.random(0,680), health = love.math.random(1,5), image = nil})
end

-- Assign the images to the enemies
function adjustImages()
	if (EnemyArray ~= nil) then
		for index,Enemy in ipairs(EnemyArray) do
			if Enemy.health == 1 then Enemy.image = Images.game.one
			elseif Enemy.health == 2 then Enemy.image = Images.game.two
			elseif Enemy.health == 3 then Enemy.image = Images.game.three
			elseif Enemy.health == 4 then Enemy.image = Images.game.four
			elseif Enemy.health == 5 then Enemy.image = Images.game.five
			end
		end
	end
end

-- Move all of the enemies on the screen
function moveEnemies()
	for index,Enemy in ipairs(EnemyArray) do
		if(Enemy.x <= -32) then
			table.remove(EnemyArray,index)
		else
			Enemy.x = Enemy.x - 3
		end
	end
end

-- Fire a bullet
function fireBullet()
	table.insert(Player.bullets,{x = Player.x + 40, y = Player.y + 20})
end

-- Move bullets
function moveBullets()
	for index,Bullet in ipairs(Player.bullets) do
		if(Bullet.x >= 1280) then
			table.remove(Player.bullets,index)
		end
		Bullet.x = Bullet.x + 4
	end
end
