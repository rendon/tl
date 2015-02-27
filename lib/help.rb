# Provides help-related methods
module Help
  def help
    File.open(Application.strings_dir + '/help.txt').read
  end
end
