
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
  else
    CONDITIONAL="WHERE name='$ARG';"
  fi
  RESULT=$($PSQL "$PREFIX_QUERY $CONDITIONAL")
  if [[ -z $RESULT ]]
  then
    echo "I could not find that element in the database."
  else
    echo "$RESULT" | IFS='|' read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MPC BPC
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MPC celsius and a boiling point of $BPC celsius."
  fi
fi
