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
# * new - accepts hash with: units in KB/MB(default)/GB; progressbar - bool
# * start - start displaying upload speed
# * stop - stops displaying upload rate
# * done(bytesize) - increments uploaded byte counter for progressbar
# * log(message) - you need to use this instead of puts
########################################################################
class Speedometer

  attr_accessor :uploaded, :refresh_time, :active, :to_upload

  def initialize(**options)
    units = units.nil? ? 'MB' : options[:units]
    @progressbar = options[:progressbar] ? true : false
    @to_upload, @done = 0
    @cols = `tput cols`.split.last.to_i
    @active = true
    @work_to_do = false
    @refresh_time = 1000
    @msg_lock = Mutex.new
    if ["KB","MB","GB"].include?(units)
      @units = units
    else
      @units = "MB"
    end
  end

  def clear
    @msg_lock.synchronize do
      print "\r"
      STDOUT.flush
      print "#{' ' * @cols}"
      STDOUT.flush
      print "\r"
      STDOUT.flush
    end
  end

  def log(msg, **opts)
    clear
    @msg_lock.synchronize do
      if opts[:stderr]
	STDERR.puts msg
      else
        puts msg
      end
    end
    if @started
      display
    end
  end

  def start
    @start_time ||= Time.now
    unless @started
      @t = Thread.new {
        while @active || @work_to_do
          display
          sleep @refresh_time.to_f / 1000
        end
      }
      @started = true
    end
  end

  def stop
    @active = false
    @started = false
    @t.join
  end

  def done(size)
    abort "Upload size needs to be positive!" if size < 0
    @done += size
  end

  private

  def progress(taken)
    abort "Upload size needs to be positive!" if @to_upload < 0
    available = (@cols / 2).ceil - 2
    bar = ' ' * (@cols - available - taken - 2)
    done_pr = (@done.to_f / @to_upload.to_f).round(3)
    done_sc = (available * done_pr).ceil
    bar += '|'
    if done_sc < available - 1
      @work_to_do = true
      bar += '=' * done_sc + '>'
      bar += '.' * (@cols - bar.length - taken - 1)
    else
      bar += '=' * available
      @work_to_do = false
    end
    bar += '|'
  end

  def display
    clear
    time = Time.now
    speed = (uploaded.to_f / (time - @start_time)) / 1024
    if @units == "MB" or @units == "GB"
      speed /= 1024
    end
    if @units == "GB"
      speed = speed / 1024
    end
    @msg_lock.synchronize do
      print "#{speed.round(2)}#{@units}/s"
      print progress(speed.round(2).to_s.length + 4) if (@to_upload > 0) && @progressbar && (@done > 0)
      STDOUT.flush
    end
  end

end
