#!/bin/bash
FILE_TXT=/tmp/translate.tmp

pronunciation=0

while getopts ":p:" opt
do
    case $opt in
        \?)
            echo "tl: Invalid option -- '$OPTARG'";
            exit 1;
            ;;
        :)
            echo "Missing word of phrase.";
            exit 1;
            ;;
        p)
            pronunciation=1;
            word=$OPTARG
            ;;
    esac
done

if [ $pronunciation == 0 ]
then
    word=$1
fi

if [ $pronunciation == 1 ]
then
  FILE_MP3="/home/data/pronunciations/$word.mp3";

  if [ ! -e "$FILE_MP3" ]
  then
    wget -q -U Mozilla -O "$FILE_MP3" "http://translate.google.com/translate_tts?ie=UTF-8&tl=en&q=$word";
  fi

  mplayer "$FILE_MP3" &> /dev/null;

fi

text=$(tr ' ' '+' <<< "$word");
wget -U "Mozilla/5.0" -qO - "http://translate.google.com/translate_a/t?client=t&text=$text&sl=en&tl=es" > $FILE_TXT;
#echo "http://translate.google.com/translate_a/t?client=t&text=$text&sl=en&tl=es"

echo -e "\t\t== $word ==";

declare -i found=0;
grep -E '*[^a-z]verb...([^]]+).*' $FILE_TXT > /dev/null;
if [ $? -eq 0 ]
then
echo "verb:";
echo -e -n "-----\n  ";
sed 's/^.*[^a-z]verb...\([^]]\+\).*/\1/g' $FILE_TXT | sed 's/"\([^"]\+\)"/ \1/g'
found=1;
fi


  grep -E '*[^a-z]adverb...([^]]+).*' $FILE_TXT > /dev/null;
  if [ $? -eq 0 ]
  then
    if [ $found -eq 1 ]; then echo -e -n "\n\n"; fi

    echo "adverb:";
    echo -e -n "-----__\n  ";
    sed 's/^.*[^a-z]adverb...\([^]]\+\).*/\1/g' $FILE_TXT | sed 's/"\([^"]\+\)"/ \1/g'

    found=1;
  fi

  grep -E '*[^a-z]noun...([^]]+).*' $FILE_TXT > /dev/null;
  if [ $? -eq 0 ]
  then
    if [ $found -eq 1 ]; then echo -e -n "\n\n"; fi

    echo "noun:";
    echo -e -n "-----\n  ";
    sed 's/^.*[^a-z]noun...\([^]]\+\).*/\1/g' $FILE_TXT | sed 's/"\([^"]\+\)"/ \1/g'
    found=1;
  fi

grep -E '*[^a-z]adjective...([^]]+).*' $FILE_TXT > /dev/null;
if [ $? -eq 0 ]
then
  if [ $found -eq 1 ]; then echo -e -n "\n\n"; fi

  echo "adjective:";
  echo -e -n "----------\n  ";
  sed 's/^.*[^a-z]adjective...\([^]]\+\).*/\1/g' $FILE_TXT | sed 's/"\([^"]\+\)"/ \1/g'
  found=1;
fi

if [ $found = 0 ]
then
  echo -e -n "=> ";
  sed 's/^[^"]\+"\([^"]\+\)".*/\1/g'  $FILE_TXT;
fi

echo;

rm $FILE_TXT
exit 0;

