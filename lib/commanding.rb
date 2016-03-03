require "commanding/version"
require "claide"

module Commanding
  class Commanding <  CLAide::Command
    self.abstract_command = true
    self.command = 'commanding'
    self.summary = 'Manage a command line tool or .sh to make it run any directory.'
    self.description = <<-DESC
      With this tool, any command line tool or *.sh can run anywhere, not just its
      root directory, or must remember its absolute path. **shell_file_path** should
      be relative path to current directory.
    DESC

    def shell_config_path
      if !@shell_config_path
        shell_name = File.basename(`echo $SHELL`)
        shell_config_name = '.' + shell_name.strip + 'rc'
        @shell_config_path = File.expand_path("~/"+shell_config_name)
      end
     @shell_config_path
    end

  end

  class Install < Commanding
    self.summary = 'Make a command line tool or *.sh run any directory.'

    self.arguments = [CLAide::Argument.new('new_command_name', true),
                      CLAide::Argument.new('shell_file_path', true)]

    def initialize(argv)
      @new_command_name = argv.shift_argument
      @shell_relative_path = argv.shift_argument
      super
    end

    def validate!
      super
      help! 'Please make sure new_command_name needed!' unless @new_command_name
      help! 'A shell_file_path is required.' unless @shell_relative_path
      help! "The #{@shell_relative_path} is invalid!!" unless File.exists?(shell_path)
    end

    def run
      `cd ~`

      file = nil
      if File.exists?(shell_config_path)
        file = File.open(shell_config_path, 'a+')
      else
        file = File.new(shell_config_path, 'w')
      end
      file.write("\n")
      file.write("alias #{@new_command_name}=\"#{@shell_path}\"")
      file.close
    end

    def shell_path
      if !@shell_path
        @shell_path = File.expand_path(@shell_relative_path, Dir.pwd)
      end
      @shell_path
    end

  end

  class Uninstall < Commanding
    self.summary = 'Disable a command line tool or *.sh run any directory.'

    self.arguments = [CLAide::Argument.new('installed_command_name', true)]

    def initialize(argv)
      @installed_command_name = argv.shift_argument
      super
    end

    def validate!
    super
    help! 'Please make sure installed_command_name needed!' unless @installed_command_name

    end

    def run
      `cd ~`
      if File.exists?(shell_config_path)
        file = File.open(shell_config_path, 'r+')
        file.each do |line|
          if line.start_with?("alias " + @installed_command_name)
            file.seek(-line.length, IO::SEEK_CUR)
            file.write(' ' * (line.length - 1))
            file.write("\n")
          end
        end

        file.close
      else
        help! 'No #{@installed_command_name}, nothing to remove.'
      end

  end

  end
end
