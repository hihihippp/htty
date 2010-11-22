require File.expand_path("#{File.dirname __FILE__}/../command")
require File.expand_path("#{File.dirname __FILE__}/../url_escaping")
require File.expand_path("#{File.dirname __FILE__}/address")
require File.expand_path("#{File.dirname __FILE__}/query_add")
require File.expand_path("#{File.dirname __FILE__}/query_remove")
require File.expand_path("#{File.dirname __FILE__}/query_unset")
require File.expand_path("#{File.dirname __FILE__}/query_unset_all")

module HTTY; end

class HTTY::CLI; end

module HTTY::CLI::Commands; end

# Encapsulates the _query-set_ command.
class HTTY::CLI::Commands::QuerySet < HTTY::CLI::Command

  include HTTY::CLI::Display
  include HTTY::CLI::UrlEscaping

  # Returns the name of a category under which help for the _query-set_ command
  # should appear.
  def self.category
    'Navigation'
  end

  # Returns the arguments for the command-line usage of the _query-set_ command.
  def self.command_line_arguments
    'name [value [name [value ...]]]'
  end

  # Returns the help text for the _query-set_ command.
  def self.help
    "Sets query-string parameters in the request's address"
  end

  # Returns the extended help text for the _query-set_ command.
  def self.help_extended
    'Sets one or more query-string parameters used for the request. Does not ' +
    "communicate with the host.\n"                                             +
    "\n"                                                                       +
    'The difference between this command and '                                 +
    "#{strong HTTY::CLI::Commands::QueryAdd.command_line} is that this "       +
    "command replaces any duplicate parameters instead of adding more.\n"      +
    "\n"                                                                       +
    'The name(s) and value(s) of the query-string parameter(s) will be URL-'   +
    "encoded if necessary.\n"                                                  +
    "\n"                                                                       +
    'The console prompt shows the address for the current request.'
  end

  # Returns related command classes for the _query-set_ command.
  def self.see_also_commands
    [HTTY::CLI::Commands::QueryUnset,
     HTTY::CLI::Commands::QueryUnsetAll,
     HTTY::CLI::Commands::QueryAdd,
     HTTY::CLI::Commands::QueryRemove,
     HTTY::CLI::Commands::Address]
  end

  # Performs the _query-set_ command.
  def perform
    add_request_if_has_response do |request|
      self.class.notify_if_cookies_cleared request do
        escaped_arguments = escape_or_warn_of_escape_sequences(arguments)
        escaped_arguments.each_slice 2 do |name, value|
          request.query_set name, value
        end
        request
      end
    end
  end

end
