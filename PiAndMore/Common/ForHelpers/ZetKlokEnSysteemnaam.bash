#!/bin/bash

echo "Geef een nieuwe datum en tijd op deze manier: Nov 14 13:45"
read NieuweDatumTijd

sudo date -s "$NieuweDatumTijd"
date


echo "Wat is de systeemnaam (staat op een sticker op de onderkant)"
read SysteemNaam

echo "$SysteemNaam" > /home/pi/Weekendschool/SysteemNaam
