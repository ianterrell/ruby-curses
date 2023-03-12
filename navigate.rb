require "curses"

class Player
  MOVEMENT_KEYS = [Curses::Key::UP, Curses::Key::DOWN, Curses::Key::LEFT, Curses::Key::RIGHT].freeze
  attr_accessor :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def move(key)
    case key
    when Curses::Key::UP
      @y -= 1
      @y = Curses.lines - 1 if @y < 0
    when Curses::Key::DOWN
      @y += 1
      @y = 0 if @y >= Curses.lines
    when Curses::Key::LEFT
      @x -= 1
      @x = Curses.cols - 1 if @x < 0
    when Curses::Key::RIGHT
      @x += 1
      @x = 0 if @x >= Curses.cols
    end
  end

  def hide
    Curses.setpos(@y, @x)
    Curses.addstr(" ")
  end

  def render
    Curses.setpos(@y, @x)
    Curses.addstr("█")
  end

  def self.movement?(key)
    MOVEMENT_KEYS.include?(key)
  end
end

Curses.init_screen
Curses.curs_set 0
Curses.noecho

screen = Curses.stdscr
screen.keypad = true
screen.clear

center_x = Curses.cols / 2
center_y = Curses.lines / 2
player = Player.new(center_x, center_y)

loop do
  player.render
  screen.refresh

  key = screen.getch
  break if key == 'q'

  if Player.movement?(key)
    player.hide
    player.move(key)
  end
end

Curses.close_screen
