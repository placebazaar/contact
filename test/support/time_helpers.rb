module TimeHelpers
  ##
  # Time Helper to freeze the time at die_wende for the duration of a block
  # stub goes away once the block is done
  def at_die_wende(&block)
    Time.stub :now, die_wende do
      yield block
    end
  end

  ##
  # Time Helper, returns a Time
  def die_wende
    Time.new(1989, 11, 9, 18, 57, 0, 0)
  end
end
