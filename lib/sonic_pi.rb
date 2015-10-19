require 'socket'
require 'rubygems'
require 'osc-ruby'
require 'securerandom'

class SonicPi
  RUN_COMMAND = "/run-code"
  STOP_COMMAND = "/stop-all-jobs"
  BUFFER_COMMAND = "/save-and-run-buffer"
  SERVER = 'localhost'
  PORT = 4557
  GUI_ID = 'SONIC_PI_CLI'

  def run(command)
    client.send(run_command(command))
  end
  
  def buffer(command)
    client.send(buffer_command(command))
  end

  def stop
    client.send(stop_command)
  end

  def test_connection!
    begin
      OSC::Server.new(PORT)
      abort("ERROR: Sonic Pi is not listening on #{PORT} - is it running?")

    rescue
      # everything is good
    end
  end

  private

  def client
    client ||= OSC::Client.new(SERVER, PORT)
  end

  def run_command(command)
    OSC::Message.new(RUN_COMMAND, GUI_ID, "#{command}")
  end
  
  #https://github.com/samaaron/sonic-pi/wiki/Sonic-Pi-Internals----GUI-Ruby-API#save-and-run-buffer-filename-code-workspace
  def buffer_command(command)
    filename = "file_#{GUI_ID}"
    workspace = "workspace_zero"
    OSC::Message.new(BUFFER_COMMAND, GUI_ID, filename, "#{command}", workspace)
  end

  def stop_command
    OSC::Message.new(STOP_COMMAND, GUI_ID)
  end
end

