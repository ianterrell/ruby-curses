require "curses"

Curses.init_screen
Curses.start_color
Curses.curs_set 0

ALL_BLANK = 100
START_COLOR = ALL_BLANK + 1
TRAIL_PROPORTION = 0.4
RAND_CHANCE = 0.025
SYMBOLS = ['!', '?', ';', ':', '+', '=', '*', '/', '\\', '|', '(', ')', '[', ']', '{', '}', '<', '>', '@', '#', '$', '%', '&', '~']
CHARS = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map(&:to_a).flatten + SYMBOLS
TRAIL_LENGTH = Curses.lines * TRAIL_PROPORTION

data = Array.new(Curses.lines) { Array.new(Curses.cols) { CHARS[rand(CHARS.length)] } }
drops = Array.new(Curses.cols) { rand(Curses.lines) }

Curses.init_pair(ALL_BLANK, Curses::COLOR_BLACK, Curses::COLOR_BLACK)
colors = Array.new(TRAIL_LENGTH) do |i|
  id = START_COLOR + i
  i = TRAIL_LENGTH - i
  Curses.init_color(id, 0, i * 1000 / TRAIL_LENGTH, 0)
  Curses.init_pair(id, id, Curses::COLOR_BLACK)
  id
end
colors.push(ALL_BLANK) while colors.length < Curses.lines

screen = Curses.stdscr
screen.nodelay = true
screen.clear

while true
  for col in 0...Curses.cols
    for row in 0...Curses.lines
      screen.setpos(row, col)
      pair = colors[(drops[col] - row - 1) % colors.length]
      Curses.attron(Curses.color_pair(pair))
      data[row][col] = CHARS[rand(CHARS.length)] if rand < RAND_CHANCE
      screen.addch(data[row][col])
    end

    drops[col] += 1
  end

  screen.refresh
  break if screen.getch == 'q'
  sleep 0.09
end

Curses.close_screen
