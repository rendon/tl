#Translate it!
[![Build Status](https://travis-ci.org/rendon/tli.svg?branch=master)](https://travis-ci.org/rendon/tli) [![Coverage Status](https://coveralls.io/repos/rendon/tli/badge.svg)](https://coveralls.io/r/rendon/tli)

**tli** is a  command line translator powered by Google Translate, so it's able to translate words, text and play the pronunciations. **tli** supports both, interactive and non-interactive modes.

Launch the interactive version if you need to translate many words or if you need the translator very often.

The non-interactive version is ideal for quick search or to translate words inside your editor (keep reading).

#Instalation
First off, check out the requirements at the end of this document.

The easiest way to use **tli** is installing the gem:

    $ gem install tli

Alternatively, clone this repo or download the zip file and execute the program like so:

    $ cd /path/to/tli_src/
    $ bin/tli

#Interactive version
Example 1:

    > brazen
    adjective
    ---------
    descarado, bronceado, de latón, lanzado, bronco, zafado

    >

Example 2:

    > A command line translator can be very useful to not to depend on the browser.
    Un traductor de línea de comandos puede ser muy útil para no depender del navegador.
    >

#Non-interactive version
The interactive version can be a bit cumbersome if all you want is to translate a single word or you want to pipe the output to another program.

Example 3:

    $ tli alibi
    noun
    ----
    excusa, coartada

    verb
    ----
    presentar una coartada

Example 4: Play the pronunciation.

    $ tli --play clincher
    ♬
    noun
    ----
    punto clave

Example 5: Specify the source and target language.

    $ tli --source en --target fr water
    noun
    ----
    marée, mer, eaux, eau

    verb
    ----
    moirer, pleurer, larmoyer, irriguer, arroser, couper d'eau

    adjective
    ---------
    qui contient d'eau

All parameters passed to **tli** are concatenated (except options and option values) and used as the text to translate.

#Tli application directory
**tli** uses the `~/.tli/` directory to store configurations, cached pronunciation and translations, etc.

#Configuration file
By default the source language is English (en) and the target language is Spanish (es). You can change this using the options `--source` and `--target`, or alternatively write this values in the file `~/.tli/tli.conf` as follows:

    {
        "settings": {
            "source": "en", 
            "target": "fr",
            "cache_results": true,
            "player": "mplayer"
        }
    }

Use `tli --info google` to get the list of supported languages Google and their corresponding codes.

You can put in the configuration file any option that is supported by **tli**, I think you get the idea :).

#Use it in Vim
I use `tli` in Vim to quickly translate words:

    set keywordprg=tli

Now press `K` to translate the word under the cursor or select your text in visual mode and press `K`.

#tli help
Type `tli --help` to obtain help, here an extract of it (it might be outdated).

    Usage: tli [options] [text]

    --version       Displays information about the current version.

    --source        Specify the language code of the text to translate, e.g. en, es,
                    fr, ja, etc.

    --target        Specify the we want to translate to, e.g. en, es, fr, ja, etc.

    --service       Specify the ID of the service we want to use as a translation
                    service, e.g. google, cambridge, etc.

    --info          Get information of a particular translation service, e.g.,
                    "--info google"

    --cache_results Enable caching of translation and pronunciations locally.

    --play          Plays the pronunciation of a text in the target language
                    (if the translation service provide pronunciations).

    --player        Specify the program that will be used to play the translation,
                    by default `mplayer` is used.

    --lts           List translation services.

    --help          Displays information about the usage of tli (this text).


    Examples:

    Translate "song" from English to French

      $ tli --source en --target fr song

    Translate and play the pronunciation of "Good bye" from English to Spanish:

      $ tli --source en --target es --play Good bye

    Start the interactive version if you want to translate multiple words:

      $ tli --source en --target es
      > 

#Requirements
- Ruby 1.9.3 or above
- `sqlite3` and `libsqlite3-dev`, in Debian or Ubuntu: `sudo apt-get install libsqlite3-dev`
- mplayer or any other media player for playing translations, ideally one that runs in the command line.

#Contributions
Of course!, contributions are welcome. Check out the wiki of the project for help.
