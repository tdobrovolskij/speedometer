########################################################################
# speedometer - class to track, calculate and display upload speed from an application
# Copyright (c) 2013, Tadeus Dobrovolskij
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
########################################################################
# = Methods
# * new - accepts units in KB/MB/GB
# * display - displays upload speed
# * log(message) - you need to use this instead of puts
########################################################################
class Speedometer

  attr_accessor :uploaded, :refresh_time, :active

  def initialize(units="MB")
    @start_time = Time.now
    @active = true
    @refresh_time = 1000
    if ["KB","MB","GB"].include?(units)
      @units = units
    else
      @units = "MB"
    end
  end

  def clear
    length = `stty`
    length = length.split.last.to_i
    print "\r"
    print "#{' ' * length}"
    print "\r"
  end

  def display
    clear
    time = Time.now
    speed = (uploaded.to_f / (time - @start_time)) / 1024
    if @units == "MB" or @units == "GB"
      speed = speed / 1024
    end
    if @units == "GB"
      speed = speed / 1024
    end
    print "#{speed.round(2)}#{@units}/s"
    sleep @refresh_time.to_f / 1000
  end

  def log(msg)
    clear
    puts msg
    display
  end
end
