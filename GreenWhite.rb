require 'green_shoes'
Shoes.app do
	background blue
	$h = 5
	$w = 40
	overall = []
	def reset
		cards1 = []
		cards2 = []
		cards3 = []
		cards4 = []
		cards5 = []
		stack do
			$h.times do |is|
				flow do
					fill green
					if is == 0
						colour = cards1
					elsif is == 1
						colour = cards2
					elsif is == 2
						colour = cards3
					elsif is == 3
						colour = cards4
					elsif is == 4
						colour = cards5
					end
					$w.times do |i|
						colour.push 'green'
						rect = rect((i*15), (is*20 + 30), 15, 20)
						rect.click do
							if colour[i] == 'green'
								colour[i] = 'white'
								fill white
								rect((i*15), (is*20+ 30), 15, 20)
							else 
								colour[i] = 'green'
								fill green
								rect((i*15), (is*20 + 30), 15, 20)
							end
						end
					end
				end
			end
		end
		return [cards1, cards2, cards3, cards4, cards5]
	end
	flow do
		@but = button "Next"
		@but.click do
			overall.push reset
		end
		@but2 = button "Play"
		@but2.click do
			Shoes.app do
				$h.times do |h|
					$w.times do |w|
						if overall[0][h][w] == 'green'
							fill green
							rect((w*15), (h*20), 40, 40)
						else 
							fill white
							rect((w*15), (h*20), 40, 40)
						end
					end
				end
			end
		end
		@but3 = button 'Show'
		@but3.click do
			Shoes.app do
			para overall
			end
		end
	end
	reset
end
				