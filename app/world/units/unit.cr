require "crsfml/graphics"
require "../../state/cache"
require "../../state/game"

struct UnitTemplate
  property type : Unit::Type
  property acceleration : SF::Vector2f
  property max_velocity : SF::Vector2f
  property max_health : Int32
  property texture : SF::Texture
  property texture_rect : SF::IntRect?

  def initialize(
    @type, 
    @acceleration,
    @max_velocity,
    @max_health,
    @texture,
    @texture_rect = nil) 
  end
end

enum Direction
  Up
  Right
  Down
  Left
end

class Unit < SF::Sprite
  @[Flags]
  enum Type
    Background
    EnemyWeapon
    PlayerWeapon
    Enemy
    Player
    Environment
  end

  getter type, alive, acceleration, health, max_health, children
  property velocity, max_velocity

  @type : Unit::Type
  @alive = true
  @velocity : SF::Vector2f
  @max_velocity : SF::Vector2f
  @acceleration : SF::Vector2f
  @health : Int32
  @max_health : Int32

  def initialize(template : UnitTemplate)
    if template.texture_rect == nil
      super(template.texture)
    else
      super(template.texture, template.texture_rect)
    end

    @type = template.type
    @acceleration = template.acceleration
    @velocity = SF.vector2f(0.0, 0.0)
    @max_velocity = template.max_velocity
    @health = @max_health = template.max_health

    @children = [] of Unit

    center_origin
    set_scale(0.5, 0.5)
  end

  def update(dt : SF::Time) : Nil
    @children.select! { |child| child.alive }
    @velocity.x = @velocity.x.clamp(-@max_velocity.x, @max_velocity.x)
    @velocity.y = @velocity.y.clamp(-@max_velocity.y, @max_velocity.y)
    move(@velocity * dt.as_seconds)
  end

  def add_child(unit : Unit) : Nil
    if !@children.find { |child| child == unit }
      @children.push(unit)
    end
  end

  def accelerate(direction : Direction, dt : SF::Time) : Nil
    case direction
    when .up?
      @velocity.y -= @acceleration.y * dt.as_seconds
    when .down?
      @velocity.y += @acceleration.y * dt.as_seconds
    when .right?
      @velocity.x += @acceleration.x * dt.as_seconds
    when .left?
      @velocity.x -= @acceleration.x * dt.as_seconds
    else
      raise "Invalid Direction value: #{direction}"
    end
  end

  def damage(value : Int32) : Nil
    if @health > value
      @health -= value
    else
      kill
    end
  end

  def heal(value : Int32) : Nil
    @health += value
    if @health > @max_health
      @health = @max_health
    end
  end

  def kill : Nil
    @health = 0
    @alive = false
    on_death
  end

  def on_collision(other : self) : Nil
  end

  def on_death : Nil
  end

  # TODO: Simplify this in the nearest future.
  def hostile?(other : self) : Bool
    case @type
    when Type::Player
      case other.type
      when Type::Player
        return false
      when Type::PlayerWeapon
        return false
      when Type::Enemy
        return true
      when Type::EnemyWeapon
        return true
      when Type::Environment
        return true
      end
    when Type::PlayerWeapon
      case other.type
      when Type::Player
        return false
      when Type::PlayerWeapon
        return false
      when Type::Enemy
        return true
      when Type::EnemyWeapon
        return true
      when Type::Environment
        return true
      end
    when Type::Enemy
      case other.type
      when Type::Player
        return true
      when Type::PlayerWeapon
        return true
      when Type::Enemy
        return false
      when Type::EnemyWeapon
        return false
      when Type::Environment
        return true
      end
    when Type::EnemyWeapon
      case other.type
      when Type::Player
        return true
      when Type::PlayerWeapon
        return true
      when Type::Enemy
        return false
      when Type::EnemyWeapon
        return false
      when Type::Environment
        return true
      end
    when Type::Environment
      case other.type
      when Type::Player
        return true
      when Type::PlayerWeapon
        return true
      when Type::Enemy
        return true
      when Type::EnemyWeapon
        return true
      when Type::Environment
        return false
      end
    end

    return false
  end

  def close?(other : self)
    bounds_a = global_bounds
    bounds_b = other.global_bounds
    bounds_a.intersects?(bounds_b)
  end

  def default_transform : Nil
    set_position(0.0, 0.0)
    set_origin(0.0, 0.0)
    set_scale(1.0, 1.0)
  end

  def center_origin : Nil
    set_origin(global_bounds.width / 2.0, global_bounds.height / 2.0)
  end

  def position_left : Float32
    global_bounds.left
  end

  def position_right : Float32
    global_bounds.left + global_bounds.width
  end

  def position_top : Float32
    global_bounds.top
  end

  def position_bottom : Float32
    global_bounds.top + global_bounds.height
  end

  def <(other : self) : Bool
    @type.value < other.type.value
  end

  def <=(other : self) : Bool
    @type.value <= other.type.value
  end

  def world : World
    App.cache[State::Type::Game].as(Game).world
  end
end