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
	Images.game.one = love.graphics.newImage("one.png")
	Images.game.two = love.graphics.newImage("two.png")
	Images.game.three = love.graphics.newImage("three.png")
	Images.game.four = love.graphics.newImage("four.png")
	Images.game.five = love.graphics.newImage("five.png")

	-- Player data
	Player = {}
	Player.x = Window.width * .1
	Player.y = Window.height * .5
	Player.image = love.graphics.newImage("player.png")

	-- Enemy data
	EnemyArray = {}
end

function love.draw()
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
	if Program.state == "play" then
		if not Game.playing then
			love.graphics.print("Quit (Q)", 50, 50)
			love.graphics.print("Resume(Esc)", 50, 75)
		end
		for index,Enemy in ipairs(EnemyArray) do
			love.graphics.draw(Enemy.image, Enemy.x, Enemy.y)
		end
		love.graphics.draw(Player.image, Player.x, Player.y)
	end
end

function love.update(dt)
	if(Game.playing) then
		if(love.keyboard.isDown("w")) or (love.keyboard.isDown("up")) then
			Player.y = Player.y - 3
		end
		if(love.keyboard.isDown("s")) or (love.keyboard.isDown("down")) then
			Player.y = Player.y + 3
		end
		Game.tick = Game.tick + 1
		if(Game.tick >= 60) then
			spawnEnemy()
			Game.tick = 0
		end
		adjustImages()
		moveEnemies()
	end
end

function love.keypressed(key, ispressed)
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
	if Program.state == "play" then
		if(key == "escape") then
			Game.playing = not Game.playing
		end
		if not Game.playing and key == "q" then
			love.event.push("quit")
		end
	end
end

function spawnEnemy()
	table.insert(EnemyArray,{x = 1280, y = love.math.random(0,680), health = love.math.random(1,5), image = nil})
end

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

function moveEnemies()
	for index,Enemy in ipairs(EnemyArray) do
		if(Enemy.x <= -32) then
			table.remove(EnemyArray,index)
		else
			Enemy.x = Enemy.x - 3
		end
	end
end
