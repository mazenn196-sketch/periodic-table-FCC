#!/bin/bash

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align --field-separator='|' -c"

RESULT=$($PSQL "
  SELECT e.atomic_number, e.symbol, e.name, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius, t.type
  FROM elements e
  JOIN properties p ON e.atomic_number = p.atomic_number
  JOIN types t ON p.type_id = t.type_id
  WHERE e.atomic_number::TEXT = '$1'
     OR e.symbol = '$1'
     OR e.name = '$1';
")

if [[ -z $RESULT ]]
then
  echo "I could not find that element in the database."
else
  echo "$RESULT" | while IFS='|' read -r ATOMIC_NUMBER SYMBOL NAME MASS MELT BOIL TYPE
  do
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
  done
fi