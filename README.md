TransLator
==========
**tl** is a simple command line translator that uses the Google translation
service to translate words, text and play the pronunciations. **tl** has two
modes, interactive and one-time translation.

Launch the interactive version if you need to translate many words or if you need the translator very often.

The one-time version is ideal for quick search or to translate words inside your editor (keep reading).

The supported languages (by Google) are the same available at [translate.google.com](https://translate.google.com/).

Interactive version
===================
Text snapshot 1:

    >> brazen
    adjective:
    ----------
    descarado, de latón, bronceado, bronco, lanzado

    >> 

Text snapshot 2:

    >> A command line translator can be very useful to not to depend on the browser.
    Un traductor de línea de comandos puede ser muy útil para no depender del navegador.
    >> 

Text snapshot 3: Use `-p` option, followed by a space, and then your text to play pronunciation.

    >> -p says
    dice
    >> 

One-time translation
=======================
The interactive version of the translator can be a little cumbersome if all you
want is to translate a single word.

Example 1:

    $ tl alibi
    verb:
    -----
    presentar una coartada

    noun:
    -----
    coartada, excusa


Example 2: Retrieve and play the pronunciation.

    $ tl -p clincher
    noun:
    -----
    punto clave


Example 3: Specify the source and target language.

    $ tl --source es --target fr agua
    eau
 

The text to translate is the concatenation of the parameters starting at the first non-option.

Configuration file
==================
By default the source language is English (en) and the target language is
Spanish (es). You can change this using the options `-s, --source` and `-t,
--target` or alternatively write this values in the file `~/.tlrc` as follows:

    source_language = fr
    target_language = en

Use `tl --langs` to get the list of supported languages (by Google) and their corresponding codes.

Use it in Vim
=============
I use `tl` in Vim to quickly translate words:

    set keywordprg=tl

Now press `K` to translate the word under the cursor or select your text in visual mode and press `K`.

WARNING: gnome-keyring...
=========================
If a message like the following shows up every time you launch `tl`:

    WARNING: gnome-keyring:: couldn't connect to: /home/rafa/.cache/keyring-oHS6Sb/pkcs11: No such file or directory

Then put this line in your `~/.bashrc`:

    unset GNOME_KEYRING_CONTROL

Follow the next link for more info: [Why do I get this warning from Gnome keyring in Xubuntu?](http://askubuntu.com/questions/243210/why-do-i-get-this-warning-from-gnome-keyring-in-xubuntu).

tl help
=======

    -v, --version   Displays the current version of tl.

    -h, --help      Displays this text.

    -s, --source    Use it to indicate the source language using the
                    language code. Use this option to override the source
                    language in the config file (~/.tlrc), both in the
                    interactive version as in the one-time translation.

    -t, --target    Use it to indicate the target language using the
                    language code. Use this option to override the source
                    language in the config file (~/.tlrc), both in the
                    interactive version as in the one-time translation.

    -p, --play      Retrieve and play the pronunciation. If this option
                    is passed in the interactive version ALL translations
                    will play the pronunciation.

    -l, --langs     Display the list of supported languages and their
                    codes. This language codes are what --source and
                    --target receives.


Requirements
============
- libreadline 6.2+, in Debian ``sudo apt-get install libreadline6-dev``
- libcurl, in Debian ``sudo apt-get install libcurl3-gnutls``
- mplayer, to play the translations (optional)
