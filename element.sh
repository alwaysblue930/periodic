
ARG=$1
PSQL = "psql -X --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $ARG ]]
then
  echo "Please provide an element as an argument."
else
  if [[ $ARG =~ ^[0-9]+$ ]]
  then
    echo "look for id"
  elif [[ ${#ARG} -le 2 ]]
  then
    echo "look for symbol"
  else
    echo "look for name"
  fi

fi
