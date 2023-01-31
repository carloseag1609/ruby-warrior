class Player
  def initialize
    @direction = :forward
  end
  
  def play_turn(warrior)
    @warrior = warrior

    play

    @health = @warrior.health
  end

  def play
    if wall?
      swap_direction
    elsif nothing_ahead?
      if low_health?
        if wizard_ahead?
          @warrior.shoot!(@direction)
        elsif taking_damage? && archer_ahead?
            @warrior.walk!(opposite_direction)
        elsif archer_ahead?
          @warrior.walk!(@direction)
        else
          @warrior.rest!
        end
      elsif hurt?
        if wizard_ahead?
          @warrior.shoot!(@direction)
        elsif !taking_damage?
          @warrior.rest!
        else
          @warrior.walk!(@direction) 
        end
      elsif wizard_ahead? && !captive?
        @warrior.shoot!(@direction)
      else
        @warrior.walk!(@direction)
      end
    else 
      if captive?
        @warrior.rescue!(@direction)
      else
        if feel_enemy?
          @warrior.attack!(@direction)
        else
          @warrior.shoot!(@direction)
        end
      end
    end
  end

  def archer_ahead?
    @warrior.look.map(&:to_s).any?("Archer")
  end

  def swap_direction
    @direction = opposite_direction
    @warrior.pivot! @direction
  end

  def feel_enemy?
    @warrior.feel(@direction).enemy?
  end

  def nothing_ahead?
    @warrior.feel(@direction).empty?
  end
  
  def wall?
    @warrior.feel(@direction).wall? 
  end

  def wizard_ahead?
    @warrior.look.map(&:to_s).any?("Wizard")
  end

  def hurt?
    @warrior.health < 20
  end

  def taking_damage?
    @health ||= 20
    @warrior.health < @health
  end

  def captive?
    @warrior.feel(@direction).captive?
  end

  def healed?
    @warrior.health > @health 
  end

  def low_health?
    @warrior.health <= 15
  end

  def opposite_direction
    @direction == :forward ? :backward : :forward
  end
end
