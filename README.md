translator
==========
Command line translator (uses Google traslation service).

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

Text snapshot 3: precede letter `p` to play pronunciation, a single `p` play the last translation.

    >> p says
    dice
    >> 

Non interactive version
=======================
The interactive version of the translator can be a little cumbersome if what
you want is to translate only a single word. From now on you can make your 
translations passing the text as arguments, e.g.

    $ tl alibi
    verb:
    -----
    presentar una coartada

    noun:
    -----
    coartada, excusa


Or

    $ tl p clincher
    noun:
    -----
    punto clave


Or

    $ tl p And here is the clincher.
    Y aquí es el factor decisivo.
 

The concatenation of all arguments will be taken as the input text.

Use it in Vim
=============
I use `tl` in Vim to quickly translate words:

    set keywordprg=tl



WARNING: gnome-keyring...
=========================
If a message like the following shows up every time you launch `tl`:

    WARNING: gnome-keyring:: couldn't connect to: /home/rafa/.cache/keyring-oHS6Sb/pkcs11: No such file or directory

Then put this line in your `~/.bashrc`:

    unset GNOME_KEYRING_CONTROL

Follow the next link for more info: http://askubuntu.com/questions/243210/why-do-i-get-this-warning-from-gnome-keyring-in-xubuntu

Requirements
============
- libreadline 6.2+, in Debian ``sudo apt-get install libreadline6-dev``
- libcurl, in Debian ``sudo apt-get install libcurl3-gnutls``
- mplayer, to play the translations (optional)
