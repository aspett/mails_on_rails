# Credit to Codethought @ http://codethought.com/blog/?p=248

class TimeFormatter
  def format_time (timeElapsed)
    timeElapsed = timeElapsed.round
    @timeElapsed = timeElapsed

    #find the seconds
    seconds = @timeElapsed % 60

    #find the minutes
    minutes = (@timeElapsed / 60) % 60

    #find the hours
    hours = (@timeElapsed/3600)

    #format the time
    debugger

    return hours.to_s + ":" + format("%02d",minutes.to_s) + ":" + format("%02d",seconds.to_s)
  end
end

if __FILE__ == $0
  formatter = TimeFormatter.new

  puts formatter.format_time(43678)
end
