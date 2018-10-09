require "./unit"
require "../ai/*"

class EnemyFighter < Unit
  @ai : AI?

  def initialize
    definition = UnitDefinition.new
    definition.type = Unit::Type::Enemy
    definition.acceleration = SF.vector2f(150.0, 200.0)
    definition.max_velocity = SF.vector2f(150.0, 300.0)
    definition.texture = App.resources[Textures::ENEMY_FIGHTER]
    super(definition)

    @ai = AIFighter.new(self)
  end

  def update(dt)
    if ai = @ai
      ai.update(dt)
    end
    super
  end

  def on_collision(other)
    other.damage(1)
  end

  def fire_laser
    if @children.size < 5
      laser = Laser.new(WeaponType::Enemy, 1)
      laser.position = self.position
      laser.set_scale(self.scale.x * 0.8f32, self.scale.y * 0.8f32)
      add_child(laser)
      world.add(laser)
    end
  end
end

class EnemyCarrier < Unit
  @ai : AI?

  def initialize
    definition = UnitDefinition.new
    definition.type = Unit::Type::Enemy
    definition.acceleration = SF.vector2f(25.0, 25.0)
    definition.max_velocity = SF.vector2f(50.0, 50.0)
    definition.max_health = 25
    definition.texture = App.resources[Textures::ENEMY_CARRIER]
    super(definition)

    @ai = AICarrier.new(self)
    set_scale(0.8, 0.8)
  end

  def update(dt)
    if ai = @ai
      ai.update(dt)
    end
    super
  end

  def on_collision(other)
    other.damage(1)
  end
end

class EnemyInterceptor < Unit
  SCALE = 0.17
  @ai : AI?

  def initialize
    definition = UnitDefinition.new
    definition.type = Unit::Type::Enemy
    definition.acceleration = SF.vector2f(100.0, 100.0)
    definition.max_velocity = SF.vector2f(200.0, 200.0)
    definition.texture = App.resources[Textures::ENEMY_INTERCEPTOR]
    super(definition)

    @ai = AIInterceptor.new(self)
    set_scale(SCALE, SCALE)
  end

  def update(dt)
    if ai = @ai
      ai.update(dt)
    end
    super
  end

  def on_collision(other)
    other.damage(1)
  end

  def fire_laser
    if @children.size < 3
      laser = Laser.new(WeaponType::Enemy, 1)
      laser.position = self.position
      laser.set_scale(SCALE, SCALE)
      add_child(laser)
      world.add(laser)
    end
  end
end
