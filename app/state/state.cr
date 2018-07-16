require "crsfml/graphics"

abstract class State
  enum Type
    Game
    Loading
    Menu
    Title
  end

  abstract def initialize
  abstract def draw(target : SF::RenderTarget)
  abstract def handle_input(event : SF::Event)
  abstract def update(dt : SF::Time)

  # If true, only this state will be drawn
  abstract def isolate_drawing : Bool
  # If true, only this state will handle input
  abstract def isolate_input : Bool
end