
ARG=$1
PSQL="psql -X --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $ARG ]]
then
  echo "Please provide an element as an argument."
else
  PREFIX_QUERY="SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties 
  INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id)"
  CONDITIONAL=""
  if [[ $ARG =~ ^[0-9]+$ ]]
  then
    CONDITIONAL="WHERE atomic_number=$ARG;"
  elif [[ ${#ARG} -le 2 ]]
  then
    CONDITIONAL="WHERE symbol='$ARG';"
    echo "look for symbol"
  else
    CONDITIONAL="WHERE name='$ARG';"
    echo "look for name"
  fi
  RESULT=$($PSQL "$PREFIX_QUERY $CONDITIONAL")
  if [[ -z $RESULT ]]
  then
    echo "I could not find that element in the database."
  else
    echo "$RESULT" | while IFS='|' read -r ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi
fi
