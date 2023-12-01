#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e '\n~~~~~ My Salon ~~~~~\n'

SERVICES_MENU () {
  if [[ $1 ]]
  then
    echo -e "\n$1\n"
  else
    echo -e "Welcome to the salon, how can I help you?"
  fi
  
  AVAILABLE_SERVICES=$($PSQL "SELECT * FROM services")
  echo "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR SERVICE
do
  echo "$SERVICE_ID) $SERVICE" 
done

read SERVICE_ID_SELECTED

SERVICE_ID=$($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED")

if [[ -z $SERVICE_ID ]]
then
SERVICES_MENU 'That service does not exist, please try again:'

else

echo -e "\nPlease provide your phone number:"
#PROVIDE PHONE NUMBER
read CUSTOMER_PHONE

CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
#IF NOT CUSTOMER
if [[ -z $CUSTOMER_NAME ]]
then
#PROVIDE NAME
echo -e "\nPlease provide your name:"
read CUSTOMER_NAME
INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
fi

CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

echo -e '\nPlease enter a time:'
read SERVICE_TIME
INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(service_id, customer_id, time) VALUES($SERVICE_ID, $CUSTOMER_ID, '$SERVICE_TIME')")

SERVICE_SELECTED=$($PSQL "SELECT name FROM services WHERE service_id='$SERVICE_ID'")

echo "I have put you down for a $(echo $SERVICE_SELECTED | sed -r 's/^ *| *$//g') at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')."
fi
}

SERVICES_MENU

