#  Space Defenders
#
# A simple game for the Shoes GUI toolkit by Why The Lucky Stiff (www.shoooes.net).
#
# Using the best programming language ever: Ruby (thanks Matz!)
#
# Written by Jonathan Whitaker (Yenrabbit)
#
# No license whatsoever, yet...
#
# Enjoy!!

module SpaceDefenders

	# The game's canvas
	class Canvas
		class << self
		# Get reference to Shoes canvas
		def get; @@canvas; end
		# Set reference to Shoes canvas
		def set(canvas); @@canvas = canvas; end
		# Pass block of Shoes code as argument
		def draw(&b); @@canvas.instance_eval(&b) if block_given?; end
		end
	end
	
	# Hold our stuff (avoids those nasty $ variables)
	class Holder
		attr_accessor :bullets, :asteroids, :ship, :hearts, :scorep, :score, :special
		def initialize
			@bullets, @asteroids = [], []
			@ship, @scorp = nil, nil
			@hearts = []
			@score, @special = 0, 0
		end
	end
	
	# The Ship
	class Ship
		attr_reader :x, :y, :life
		def initialize
			@x, @y = Canvas.get.width/2-25, (Canvas.get.height - 50)
			@life = 3
			# Draw the ship
			@shape = Canvas.draw do
				image 'ship.png'
			end
			@shape.move @x, @y
		end
		# Make the ship go to the mouses x position
		def moveto!(x)
			@x = x
			@shape.move @x, @y
		end
		#shoot a bullet 						<<<<<<add special bullets for n == 3 - right click
		def shoot(n)
			if n == 1
				return Bullet.new(@x+24)
			else n == 3
				if Canvas.get.special > 0
					Canvas.get.shootspecial
					return GreenBullet.new(@x + 24)
				else return Bullet.new(@x+24)
				end
			end
		end
		#give a life
		def heal
			if life < 3
				@life += 1
			end
			if @life == 3
				Canvas.get.hearts[2].show
			elsif @life == 2
				Canvas.get.hearts[1].show
			end
		end
		#give special bullets
		def arm
			Canvas.get.boostbullets
		end
		#destroy the ship 						<<<<<<add lives on ship
		def explode!
			if @life == 1
				@life -= 1
				Canvas.get.hearts[0].hide
				@x, @y = nil, nil
				@shape.remove
				@shape = Canvas.draw do
					image 'shipdead.jpg'
				end
				@shape.move @x, @y
				Canvas.get.timer(1) do
					@shape.remove
				end
				Canvas.get.gameover
			else @life -= 1
				if @life == 2
					Canvas.get.hearts[2].hide
				elsif @life == 1
					Canvas.get.hearts[1].hide
				end
			end
		end
	end
	
	# General class of falling things, contains simplest asteroid.
	class Asteroid
		attr_accessor :x, :y, :shape, :life
		def initialize(x, y)
			@x = x
			@life = 1
			@y = y
			@shape = Canvas.draw do
				image 'sast.jpg'
			end
			@shape.move @x, @y
			# destroys itself after 8 seconds - stops clutter!!
			Canvas.get.timer(15) do
				self.explode!
			end
		end
		# kill ships at a certain position, with the ships co-ords
		# passed in as first args...					<<<<<<finish killship
		def kill_ships_at_position(*xyship)
			# define the Arguments passed
			shipx, shipy = xyship[0], xyship[1]
			ship = xyship[2]
			# if the ships x means it touches the asteroids x at the same time as the y's, with extensions...
			if shipx and ((shipx >= (@x-40) and shipx <= (@x+20)) and ((shipy <= (@y+17)) and (shipy >= (@y - 50))))
				self.explode!
				ship.explode!
			end
		end
		#not stricktly in use, but it looks good...
		def killed_ships_at_position?(x, y)
			# looks familiar...
			shipx, shipy = x, y
			# if the ships x means it touches the asteroids x at the same time as the y's, with extensions...
			if ((shipx >= (@x-40) and shipx <= (@x+35)) and ((shipy <= (@y+35)) and (shipy >= (@y - 50))))
				return true
			else return false
			end
		end
		# Destroy itself
		def explode!
			@x, @y = nil, nil
			@shape.remove
		end
		#is hit by bullet
		def explodebybullet!
			@life -= 1
			if @life == 0
				self.explode!
				# increase score
				Canvas.get.add_to_score(100)
				#show the new score
				Canvas.get.scorep.replace "Score: #{(Canvas.get.score).to_i.to_s}"
			end
		end
		# Fall down a bit
		def move(x, *y)
			@y += 3
			@shape.move @x, @y
			kill_ships_at_position(x, y[0], y[1])
		end
	end
	
	#other asteroid classes...
	class TwistyAsteroid < Asteroid
		attr_accessor :x, :y, :shape, :life
		def initialize(x, y)
			@x = x
			@y = y
			@life = 5
			@shape = Canvas.draw do
				image 'asteroid.png'
			end
			@shape.move @x, @y
			# destroys itself after 8 seconds - stops clutter!!
			Canvas.get.timer(15) do
				self.explode!
			end
		end
		def kill_ships_at_position(*xyship)
			# define the Arguments passed
			shipx, shipy = xyship[0], xyship[1]
			ship = xyship[2]
			# if the ships x means it touches the asteroids x at the same time as the y's, with extensions...
			if ((shipx >= (@x-40) and shipx <= (@x+20)) and ((shipy <= (@y+17)) and (shipy >= (@y - 50))))
				self.explode!
				ship.explode!
			end
		end
		def explodebybullet!
			@life -= 1
			if life == 0
				self.explode!
				# increase score
				Canvas.get.add_to_score(300)
				#show the new score
				Canvas.get.scorep.replace "Score: #{(Canvas.get.score).to_i.to_s}"
			end
		end
		def move(x, *y)
			@y += 3
			if (@y/90)%2 == 0
				@x += 2
			else @x -= 2
			end
			@shape.move @x, @y
			kill_ships_at_position(x, y[0], y[1])
		end
	end
	
	# A life
	class Bonuslife
		attr_accessor :x, :y
		def initialize(x, y)
			@x = x
			@y = y
			@shape = Canvas.draw do
				image 'heart.png'
			end
			@shape.move @x, @y
			# destroys itself after 8 seconds - stops clutter!!
			Canvas.get.timer(15) do
				self.explode!
			end
		end
		def heal_ships_at_position(*xyship)
			# define the Arguments passed
			shipx, shipy = xyship[0], xyship[1]
			ship = xyship[2]
			# if the ships x means it touches the asteroids x at the same time as the y's, with extensions...
			if ((shipx >= (@x-40) and shipx <= (@x+10)) and ((shipy <= (@y+10)) and (shipy >= (@y - 50))))
				self.explode!
				ship.heal
			end
		end
		def move(x, *y)
			@y += 3
			@shape.move @x, @y
			heal_ships_at_position(x, y[0], y[1])
		end
		def explode!
			@x, @y = nil, nil
			@shape.remove
		end
	end
		
	# Fancy bullets
	class Bonusbullets
		attr_accessor :x, :y
		def initialize(x, y)
			@x = x
			@y = y
			@shape = Canvas.draw do
				image 'greenbullet.jpg'
			end
			@shape.move @x, @y
			# destroys itself after 15 seconds - stops clutter!!
			Canvas.get.timer(15) do
				self.explode!
			end
		end
		def recharge_ships_at_position(*xyship)
			# define the Arguments passed
			shipx, shipy = xyship[0], xyship[1]
			ship = xyship[2]
			# if the ships x means it touches the asteroids x at the same time as the y's, with extensions...
			if ((shipx >= (@x-40) and shipx <= (@x+10)) and ((shipy <= (@y+10)) and (shipy >= (@y - 50))))
				self.explode!
				ship.arm
			end
		end
		def move(x, *y)
			@y += 3
			@shape.move @x, @y
			recharge_ships_at_position(x, y[0], y[1])
		end
		def explode!
			@x, @y = nil, nil
			@shape.remove
		end
	end
	# Basic bullet class with standard bullets, 
	class Bullet
		attr_accessor :x, :y
		def initialize (x)
			@x = x
			@y = (Canvas.get.height - 50)
			@bullet = Canvas.draw do
				image 'bullet.png'
			end
			@bullet.move @x, @y
			Canvas.get.timer(5) do
				self.remove
			end
		end
		
		#get rid of asteroids
		def kill_asteroids_at_position(*args)
			# define the Arguments passed
			bulx, buly = args[0], args[1]
			asts = Canvas.get.asteroids
			asts.collect do |ast|
				if ast.x
					if ast.class == Asteroid
						if ((((ast.x + 20) > bulx) and (ast.x < (bulx + 5))) and (((ast.y + 20) > buly) and (ast.y < (buly +10))))
							self.remove
							ast.explodebybullet!
						end
					elsif ast.class == TwistyAsteroid
						if ((((ast.x + 40) > bulx) and (ast.x < (bulx + 5))) and (((ast.y + 40) > buly) and (ast.y < (buly +10))))
							self.remove
							ast.explodebybullet!
						end
					end
				else ast.explode!
				end
			end
		end
		
		#move up, change here for speed
		def move
			@y -= 10
			@bullet.move @x, @y
		end
		
		#destroy itself
		def remove
			@bullet.remove
			@x = nil
			@y = nil
			@isdead == true
		end
		def isdead?
			if @isdead == true
				return true
			else return false
			end
		end
	end
	#special, green bullets
	class GreenBullet < Bullet
		attr_accessor :x, :y
		def initialize (x)
			@x = x
			@y = (Canvas.get.height - 50)
			@bullet = Canvas.draw do
				image 'greenbullet.jpg'
			end
			@bullet.move @x, @y
			Canvas.get.timer(5) do
				self.remove
			end
		end
		def kill_asteroids_at_position(*args)
			# define the Arguments passed
			bulx, buly = args[0], args[1]
			asts = Canvas.get.asteroids
			asts.collect do |ast|
				if ast.x
					if ast.class == Asteroid
						if ((((ast.x + 20) > bulx) and (ast.x < (bulx + 12))) and (((ast.y + 20) > buly) and (ast.y < (buly +18))))
							self.remove
							if ast.life > 5
								5.times do
									ast.explodebybullet!
								end
							else
							ast.life = 1
							ast.explodebybullet!
						end
						end
					elsif ast.class == TwistyAsteroid
						if ((((ast.x + 40) > bulx) and (ast.x < (bulx + 12))) and (((ast.y + 40) > buly) and (ast.y < (buly +18))))
							self.remove
							if ast.life > 5
								5.times do
									ast.explodebybullet!
								end
							else
								ast.life = 1
								ast.explodebybullet!
							end
						end
					end
				else ast.explode!
				end
			end
		end
		#move up, change here for speed
		def move
			@y -= 10
			@bullet.move @x, @y
		end
		
		#destroy itself
		def remove
			@bullet.remove
			if @y and @y > 0
				@bullet = Canvas.draw do
					image 'bulexp.jpg'
				end
				@bullet.move @x, @y
				Canvas.get.timer(1) do
					@bullet.remove
				end
			end
			@x = nil
			@y = nil
			@isdead == true
		end
		def isdead?
			if @isdead == true
				return true
			else return false
			end
		end
	end
end

#  The Shoes application
Shoes.app :title => 'Space Defenders', :width => 600, :height => 650 do
	SpaceDefenders::Canvas.set( self )
	# Make a holder to store asteroids and bullets
	H = SpaceDefenders::Holder.new
	def restart #<< called for a new game.
		background black
		#make the Ship
		s = SpaceDefenders::Ship.new
		#store the ship
		H.ship = s
		#show the ships life
		h1 = image 'heart.png'
		h2 = image 'heart.png'
		h3 = image 'heart.png'
		#special green bullets and counter...
		H.special = 5
		H.score = 0
		@s1 = image 'greenbullet.jpg'
		@s1.move 0, 20
		@sp1 = para ": #{H.special.to_s}", :stroke => lawngreen
		@sp1.move 18, 23
		H.scorep =  para 'Score :', :stroke => red
		H.scorep.move(0, 0)
		h1.move(575, 2)
		h2.move(558, 2)
		h3.move(541, 2)
		H.hearts.push h1
		H.hearts.push h2
		H.hearts.push h3
		#pass mouse pos. to ship
		motion do
			s.moveto!(mouse[1])
		end
		#send clicks to ship
		click do
				H.bullets.push s.shoot(mouse[0])
				@sp1.replace ": #{H.special.to_s}"
				if H.special == 0
					@sp1.hide
					@s1.hide
				end
		end
		@a = animate 20 do |count|
			if count%20 == 0 and count != 0
				#make a new asteroid
				ast = SpaceDefenders::Asteroid.new(rand(580), 0)
				H.asteroids.push ast
			end
			if count%50 == 0 and count != 0
				#make a new twisty asteroid
				ast = SpaceDefenders::TwistyAsteroid.new((rand(500) + 40), 0)
				H.asteroids.push ast
			end
			if count%700 == 0 and count != 0
				lif = SpaceDefenders::Bonuslife.new((rand(500) + 40), 0)
				H.asteroids.push lif
			end
			if count%200 == 0 and count != 0
				lif = SpaceDefenders::Bonusbullets.new((rand(500) + 40), 0)
				H.asteroids.push lif
			end
			#iterate through the asteroids
			H.asteroids.length.times do |i|
				if H.asteroids[i].y
					#move the ones that aren't exploded
					#killing ships at the same time (sneaky)
					H.asteroids[i].move(s.x, s.y, s)
				else H.asteroids[i].explode!
				end
			end
			#same for bullets
			H.bullets.length.times do |i|
				if H.bullets[i].y
					H.bullets[i].move
				else H.bullets[i].remove
				end
				if H.bullets[i].y
					H.bullets[i].kill_asteroids_at_position(H.bullets[i].x, H.bullets[i].y)
				else H.bullets[i].remove
				end
			end
			#get rid of expired bullets and asteroids otherwise game freezes as it loops through larger and larger arrays...
			# btw this took like 8 hours and 1000 lines of code to fix, so say thanks!!
			H.bullets.length.times do |i|
				if H.bullets[i] == nil
					H.bullets.delete_at(i)
				elsif H.bullets[i].y == nil
					H.bullets.delete_at(i)
				end
			end
			H.asteroids.length.times do |i|
				if H.asteroids[i]
					if H.asteroids[i].y == nil
						H.asteroids.delete_at(i)
					end
				else H.asteroids.delete_at(i)
				end
			end
		end
	end
	restart
	def gameover
		@a.stop
		H.asteroids.collect do |ast|
			ast.explode!
			H.asteroids.delete ast
		end
		clear() do
			$a = 'y'
			keypress do
				if $a == 'y'
					restart
					$a = 'n'
				end
				$a = 'n'
			end
		end
		background black
		image 'endofgamescreen.jpg'
	end
	def special
		return H.special
	end
	def shootspecial
		H.special -= 1
	end
	def asteroids
		return H.asteroids
	end
	def hearts
		return H.hearts
	end
	# Give some new special bullets
	def boostbullets
		@sp1.show
		@s1.show
		if H.special < 79
			H.special += 20
		else H.special = 99
		end
		@sp1.replace "#{H.special.to_s}"
	end
	# send the score
	def score
		return H.score
	end
	# send the score PARAGRAPH
	def scorep
		return H.scorep
	end
	# CHANGE the score (i know its the long way, so what.)
	def add_to_score(num)
		H.score += num
	end
end

