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

Requirements
============
- libreadline 6.2+, in Debian ``sudo apt-get install libreadline6-dev``
- libcurl, in Debian ``sudo apt-get install libcurl3-gnutls``
- mplayer, to play the translations (optional)
