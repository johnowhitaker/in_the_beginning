
#     ----- COLLISION -----      
#                                                
#         by J. Whitaker                
#						  

import pygame, sys, random, time
from pygame.locals import *

# set up pygame
pygame.init()
mainClock = pygame.time.Clock()

# set up the window
WINDOWWIDTH = 450
WINDOWHEIGHT = 450
windowSurface = pygame.display.set_mode((WINDOWWIDTH, WINDOWHEIGHT), 0, 32)
pygame.display.set_caption('Collide')

# set up the colors
BLACK = (0, 0, 0)
GREEN = (0, 255, 0)
WHITE = (255, 255, 255)
RED = (255, 0, 0)
BLUE = (0, 0, 255)

# set up the player and enemy data structure
lives = 3
score = 0
SIZE = 20
CHEAT = True #its inversed...

enemys = []
for i in range(7):
	xspeed = random.randint(3, 5)
	yspeed = random.randint(3, 5)
	enemys.append([(pygame.Rect(random.randint(0, WINDOWWIDTH - SIZE), random.randint((60), WINDOWHEIGHT - SIZE), 20, 20)), xspeed, yspeed])

screen = 'men'

player = pygame.Rect(300, 100, 50, 50)
MOVESPEED = 6
# set up music
try:
	pygame.mixer.music.load('closer.mp3')
	pygame.mixer.music.play(-1, 0.0)
	musicPlaying = True
except: musicPlaying = False

# run the game loop
while True:
	
    #menu screen, to be coded.....
    if screen == 'men':
	pygame.event.set_grab(False)
	pygame.mouse.set_visible(True)
	for event in pygame.event.get():
		if event.type == QUIT:
			pygame.quit()
			sys.exit()   # ##### make an are you sure screen
		if event.type == KEYUP:
			if event.key == ord('m'):
				if musicPlaying:
					pygame.mixer.music.pause()
				else:
					pygame.mixer.music.unpause()
				musicPlaying = not musicPlaying
			if event.key == K_ESCAPE:
				pygame.quit()
				sys.exit()

		if event.type == MOUSEBUTTONUP:
			if (event.pos[0]>(WINDOWWIDTH/2 - textR.width/2)) and (event.pos[0]<WINDOWWIDTH-(WINDOWWIDTH/2 - textR.width/2)) and (event.pos[1]>80) and (event.pos[1]<115):
				screen = 'collide'
				score = 0
				lives = 3
				enemys = []
				pygame.event.set_grab(True)
			if (event.pos[0]>(WINDOWWIDTH/2 - text2R.width/2)) and (event.pos[0]<WINDOWWIDTH-(WINDOWWIDTH/2 - text2R.width/2)) and (event.pos[1]>120) and (event.pos[1]<155):
				screen = 'credits'
				pygame.event.set_grab(False)
			if (event.pos[0]>(WINDOWWIDTH/2 - text3R.width/2)) and (event.pos[0]<WINDOWWIDTH-(WINDOWWIDTH/2 - text3R.width/2)) and (event.pos[1]>160) and (event.pos[1]<195):
				pygame.quit()
				sys.exit()
			if (event.pos[0]>(WINDOWWIDTH/2 - textmR.width/2)) and (event.pos[0]<WINDOWWIDTH-(WINDOWWIDTH/2 - textmR.width/2)) and (event.pos[1]>200) and (event.pos[1]<235):
				if musicPlaying:
					pygame.mixer.music.pause()
				else:
					pygame.mixer.music.unpause()
				musicPlaying = not musicPlaying


	# draw the black background onto the surface
	windowSurface.fill(BLACK)
	
	#highlight text <+ will be a menu
	pos = pygame.mouse.get_pos()
	basicFont = pygame.font.SysFont(None, 35)
	headingFont = pygame.font.SysFont(None, 48)
	heading = headingFont.render('COLLIDE', True, RED, BLACK)
	headingR = heading.get_rect()
	headingR.y = 20
	headingR.x = (WINDOWWIDTH/2 - headingR.width/2)
	windowSurface.blit(heading, headingR)
	text = basicFont.render('Play', True, RED, BLACK)
	textR = text.get_rect()
	textR.x = (WINDOWWIDTH/2 - textR.width/2)
	textR.y = 80
	if pos[0]>(WINDOWWIDTH/2 - textR.width/2) and pos[0]<WINDOWWIDTH-(WINDOWWIDTH/2 - textR.width/2) and pos[1] > 80 and pos[1]<115:
		pygame.draw.rect(windowSurface, RED, ((WINDOWWIDTH/2 - textR.width/2 - 5), 75, (textR.width + 10), (textR.height + 10)))
	windowSurface.blit(text, textR)
	text2 = basicFont.render('Credits', True, RED, BLACK)
	text2R = text2.get_rect()
	text2R.x = (WINDOWWIDTH/2 - text2R.width/2)
	text2R.y = 120
	if pos[0]>(WINDOWWIDTH/2 - text2R.width/2) and pos[0]<WINDOWWIDTH-(WINDOWWIDTH/2 - text2R.width/2) and pos[1] > 120 and pos[1]<155:
		pygame.draw.rect(windowSurface, RED, ((WINDOWWIDTH/2 - text2R.width/2 - 5), 115, (text2R.width + 10), (text2R.height + 10)))
	windowSurface.blit(text2, text2R)
	text3 = basicFont.render('Quit', True, RED, BLACK)
	text3R = text3.get_rect()
	text3R.x = (WINDOWWIDTH/2 - text3R.width/2)
	text3R.y = 160
	if pos[0]>(WINDOWWIDTH/2 - text3R.width/2) and pos[0]<WINDOWWIDTH-(WINDOWWIDTH/2 - text3R.width/2) and pos[1] > 160 and pos[1]<195:
		pygame.draw.rect(windowSurface, RED, ((WINDOWWIDTH/2 - text3R.width/2 - 5), 155, (text3R.width + 10), (text3R.height + 10)))
	windowSurface.blit(text3, text3R)
	textm = basicFont.render('Toggle Sound (\'m\')', True, RED, BLACK)
	textmR = textm.get_rect()
	textmR.x = (WINDOWWIDTH/2 - textmR.width/2)
	textmR.y = 200
	if pos[0]>(WINDOWWIDTH/2 - textmR.width/2) and pos[0]<WINDOWWIDTH-(WINDOWWIDTH/2 - textmR.width/2) and pos[1] > 200 and pos[1]<235:
		pygame.draw.rect(windowSurface, RED, ((WINDOWWIDTH/2 - textmR.width/2 - 5), 195, (textmR.width + 10), (textmR.height + 10)))
	windowSurface.blit(textm, textmR)
	

	# draw the window onto the screen
	pygame.display.update()
	mainClock.tick(20)
	
    #First game - collide
    elif screen == 'collide':
	
	#~ if pygame.mouse.get_pos()[1] > 30:
	pygame.mouse.set_visible(False)
	#~ else:
	

		#~ pygame.mouse.set_visible(True)
	for event in pygame.event.get():
		if event.type == QUIT:
			pygame.quit()
			sys.exit()
		if event.type == KEYUP:
			if event.key == ord('m'):
				if musicPlaying:
					pygame.mixer.music.pause()
				else:
					pygame.mixer.music.unpause()
				musicPlaying = not musicPlaying
			elif event.key == K_ESCAPE:
				screen = 'men'
			elif event.key == ord('c'):      # enable hiding in the TLC, its an actual Cheat Code!!!!!! This game is now complete :)
				if CHEAT:
					CHEAT = False
				else: 
					CHEAT = True
			
	# draw the black background onto the surface
	windowSurface.fill(BLACK)
	
	#show top seperate line thingee
	pygame.draw.rect(windowSurface, (50, 50, 50), (0, 30,WINDOWWIDTH, 2))
	
	
	pos = pygame.mouse.get_pos()
	
	# move the enemy
	for enemy in enemys:
		if (enemy[0].y+ enemy[2] + SIZE) > WINDOWHEIGHT:
			enemy[2] = (0-enemy[2])
		if enemy[0].y < 30:
			enemy[2] = (0-enemy[2])
			enemy[0].y += 5
		if (enemy[0].x+ enemy[1]+SIZE) > WINDOWWIDTH:
			enemy[1] = (0-enemy[1])
		if enemy[0].x < 0:
			enemy[1] = (0-enemy[1])	
		enemy[0].y += enemy[2]
		enemy[0].x += enemy[1]

	# draw the player onto the surface
	pygame.draw.rect(windowSurface, WHITE, player)

	# check if the player has intersected with any enemy squares.
	for enemy in enemys[:]:
		if player.colliderect(enemy[0]):
		    enemys.remove(enemy)
		    lives -= 1
		    score += 50

	#draw the enemy
	for i in range(len(enemys)):
		pygame.draw.rect(windowSurface, GREEN, enemys[i][0])
	
	
	if (pos[0]>SIZE) and (pos[0] < (WINDOWWIDTH-SIZE+1)) and (pos[1]>(SIZE+35) and (pos[1]<(WINDOWHEIGHT-SIZE))):
		player.centerx = pos[0]
		player.centery = pos[1]
	elif pos[0]>=WINDOWWIDTH-SIZE and pos[1]<=WINDOWHEIGHT-SIZE:
		player.centerx = WINDOWWIDTH-SIZE
		player.centery = pos[1]
	elif pos[0]<=WINDOWWIDTH-SIZE and pos[1]>=WINDOWHEIGHT-SIZE:
		player.centerx = pos[0]
		player.centery = WINDOWHEIGHT-SIZE
	elif pos[0]<=SIZE and pos[1]>(35+SIZE):
		player.centerx = SIZE
		player.centery = pos[1]
	elif pos[0]>=SIZE and pos[1]<=(35+SIZE):
		player.centerx = pos[0]
		player.centery = (35 + SIZE)
	if CHEAT:
		if pos[0] >= WINDOWWIDTH-SIZE and pos[1]<(SIZE + 35):
			player.centerx = WINDOWWIDTH-(SIZE)
			player.centery = SIZE+35
		elif pos[0]<SIZE and pos[1]>=WINDOWHEIGHT-SIZE:
			player.centerx = SIZE
			player.centery = WINDOWHEIGHT-SIZE
		
	
	for i in range(lives+1):
		pygame.draw.rect(windowSurface, RED, ((WINDOWWIDTH - i*20), 10, 15, 15))
		
	if lives <= 0:
		screen = 'sorry(collide)'
		GREEN = (0, 255, 0) #a hack to make changing the colour easier :)
		
	# draw the score
	basicFont = pygame.font.SysFont(None, 28)
	text = basicFont.render("Score : %i" % score, False, RED, BLACK)
	textRect = text.get_rect()
	textRect.x = 150
	textRect.y = 5
	windowSurface.blit(text, textRect)
	pygame.display.update()
	
	#add enemys the first frame
	if score == 0:
		score = 1
		for i in range(7):
			xspeed = random.randint(3, 5)
			yspeed = random.randint(3, 5)
			if pygame.mouse.get_pos()[0] > 200:
				enemys.append([(pygame.Rect(random.randint(0, 100), random.randint((60), WINDOWHEIGHT - SIZE), 20, 20)), xspeed+1, yspeed+1])
			else:
				enemys.append([(pygame.Rect(random.randint(300, (WINDOWWIDTH-SIZE)), random.randint((60), WINDOWHEIGHT - SIZE), 20, 20)), xspeed+1, yspeed+1])
	score += 1
	
	#add a new enemy, away from the player
	if score%500 == 0:
		if pygame.mouse.get_pos()[0] > 200:
			enemys.append([(pygame.Rect(random.randint(0, 100), random.randint((60), WINDOWHEIGHT - SIZE), 20, 20)), xspeed+1, yspeed+1])
		else:
			enemys.append([(pygame.Rect(random.randint(300, (WINDOWWIDTH-SIZE)), random.randint((60), WINDOWHEIGHT - SIZE), 20, 20)), xspeed+1, yspeed+1])
		GREEN = (random.randint(0, 255), random.randint(0, 255), random.randint(0, 255))
	
	
	mainClock.tick(50)
	
	#2716 <= developer high score...
	
    elif screen == 'sorry(collide)':
	pygame.mouse.set_visible(True)
	pygame.event.set_grab(False)
	windowSurface.fill(BLACK)
	
	#text stuff...
	basicFont = pygame.font.SysFont(None, 48)
	text = basicFont.render("Score : %i" % score, True, RED, BLUE) 
	textRect = text.get_rect()
	textRect.x = (WINDOWWIDTH/2 - textRect.width/2)
	textRect.y = 100
	windowSurface.blit(text, textRect)
	paraFont = pygame.font.SysFont(None, 24)
	para = paraFont.render("Push Esc for menu, Enter to replay", True, RED, BLACK) 
	paraRect = para.get_rect()
	paraRect.x = (WINDOWWIDTH/2 - paraRect.width/2)
	paraRect.y = 180
	windowSurface.blit(para, paraRect)
	pygame.display.update()
	
	for event in pygame.event.get():
		if event.type == QUIT:
			pygame.quit()
			sys.exit()
		if event.type == MOUSEBUTTONUP:
			enemys = []
			lives = 3
			score = 0
			screen = 'collide'
			pygame.mouse.set_visible(False)
			pygame.event.set_grab(True)
			
		elif event.type == KEYUP:
			if event.key == K_ESCAPE:
				screen = 'men'
			else:
				enemys = []
				lives = 3
				score = 0
				screen = 'collide'
				pygame.mouse.set_visible(False)
				pygame.event.set_grab(True)
	
    elif screen == 'credits':
	pygame.mouse.set_visible(True)
	pygame.event.set_grab(False)
	windowSurface.fill(BLACK)
	
	#text stuff...
	basicFont = pygame.font.SysFont(None, 48)
	text = basicFont.render("Collide, by J. Whitaker", True, RED, BLACK) 
	textRect = text.get_rect()
	textRect.x = (WINDOWWIDTH/2 - textRect.width/2)
	textRect.y = 100
	windowSurface.blit(text, textRect)
	paraFont = pygame.font.SysFont(None, 24)
	para = paraFont.render("Still in development,", True, RED, BLACK) 
	paraRect = para.get_rect()
	paraRect.x = (WINDOWWIDTH/2 - paraRect.width/2)
	paraRect.y = 180
	windowSurface.blit(para, paraRect)
	para2 = paraFont.render("but really addictive...", True, RED, BLACK) 
	para2Rect = para2.get_rect()
	para2Rect.x = (WINDOWWIDTH/2 - para2Rect.width/2)
	para2Rect.y = 210
	windowSurface.blit(para2, para2Rect)
	para3 = paraFont.render("Developer highscore: 2716", True, RED, BLACK) 
	para3Rect = para3.get_rect()
	para3Rect.x = (WINDOWWIDTH/2 - para3Rect.width/2)
	para3Rect.y = 240
	windowSurface.blit(para3, para3Rect)
	para4 = paraFont.render("Esc to go back", True, RED, BLACK) 
	para4Rect = para4.get_rect()
	para4Rect.x = (WINDOWWIDTH/2 - para4Rect.width/2)
	para4Rect.y = 270
	windowSurface.blit(para4, para4Rect)
	
	for event in pygame.event.get():
		if event.type == QUIT:
			pygame.quit()
			sys.exit()

		elif event.type == KEYUP:
			if event.key == K_ESCAPE:
				screen = 'men'
				pygame.event.set_grab(False)
			
	
	pygame.display.update()
	mainClock.tick(20)
    
