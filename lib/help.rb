module Help
  def self.help
    %{Usage: tli [options] --source <lang code> --target <lang code> --service <service id> [text]

    --source      Specify the language code of the text to translate, e.g. en, es, fr, ja, etc.
    --target      Specify the we want to translate to, e.g. en, es, fr, ja, etc.
    --service     Specify the ID of the service we want to use as a translation service, e.g. google, yandex, oxford, etc.
    --help        Displays information about the usage of tli (this text).
    }
  end
end
