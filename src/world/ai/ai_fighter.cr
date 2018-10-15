require "../ai"

class AIFighter < AI
  MAX_HEIGHT = 0.4

  def initialize(unit : Unit)
    @unit = WeakRef(Unit).new(unit)
    @scale_callback = TimeCallback.new
    @shoot_callback = TimeCallback.new

    @scale_callback.add(SF.seconds(1.0 / 60.0), 20) do
      if u = unit
        u.set_scale(u.scale.x - 0.5 / 20, u.scale.y + 0.5 / 20)
      end
    end

    @scale_callback.add_ending do
      if u = unit
        u.kill
      end
    end

    @shoot_callback.add(SF.seconds(rand(0.4..0.6))) do
      if u = unit
        u.fire_laser
      end
    end
  end

  def on_update(dt : SF::Time) : Nil
    if u = @unit.value
      if u.position_bottom > Game::WORLD_HEIGHT * MAX_HEIGHT
        @scale_callback.update(dt)
      else
        if Game.player.position.x > u.position.x
          u.accelerate(Direction::Right, dt)
        else
          u.accelerate(Direction::Left, dt)
        end
  
        if Game.player.position.y > u.position.y
          u.accelerate(Direction::Down, dt)
        else
          u.accelerate(Direction::Up, dt)
        end

        @shoot_callback.update(dt)
      end
    end
  end
end