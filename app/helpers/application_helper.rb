module ApplicationHelper
  def format_time (timeElapsed)
    @timeElapsed = timeElapsed.round

    #find the seconds
    seconds = @timeElapsed % 60

    #find the minutes
    minutes = (@timeElapsed / 60) % 60

    #find the hours
    hours = (@timeElapsed/3600)

    #format the time
    return hours.to_s + ":" + format("%02d",minutes.to_s) + ":" + format("%02d",seconds.to_s)
  end
end
