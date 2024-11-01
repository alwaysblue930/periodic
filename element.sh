
ARG=$1
PSQL="psql -X --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $ARG ]]
then
  echo "Please provide an element as an argument."
else
  RESULT=''
  if [[ $ARG =~ ^[0-9]+$ ]]
  then
    RESULT=$($PSQL "SELECT atomic_number, name, symbol FROM elements WHERE atomic_number=$ARG;")
    echo $RESULT | while IFS='|' read -r ATOMIC_NUMBER NAME SYMBOL
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL)."
    done
  elif [[ ${#ARG} -le 2 ]]
  then
    RESULT=$($PSQL "SELECT type, atomic_mass FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) 
    WHERE symbol='$ARG';")
    echo $RESULT | while IFS='|' read -r TYPE MASS
    do
      echo "It's a $TYPE, with a mass of $MASS amu."
    done
  else
    RESULT=$($PSQL "SELECT name, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) 
    WHERE name='$ARG';")
    echo $RESULT | while IFS='|' read -r NAME MELTING_P BOILING_P
    do
      echo "$NAME has a melting point of $MELTING_P celsius and a boiling point of $BOILING_P celsius."
    done
  fi
fi
