#!/bin/bash


PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
# $($PSQL "truncate table customers,appointments")
MAIN_MENU() {
echo -e '\n~~~~~ MY SALON ~~~~~'
  if [[ $1 ]] 
  then
   echo -e "\n$1"
  fi

  LIST=$($PSQL "select * from services")

  if [[ -z $LIST ]]
  then
   echo "error getting services"
  else
      echo -e '\nWelcome to My Salon, how can I help you?'
      # echo "$LIST"
      echo "$LIST" | while  read SERVICE_ID  BAR NAME
      do
        echo "$SERVICE_ID) $NAME"
      done

     read SERVICE_ID_SELECTED

  #CHECKING ENTERED SERVICE
  if [[  ! $SERVICE_ID_SELECTED =~ ^[1-3]+$ ]]
  then
    MAIN_MENU "I could not find that service. What would you like today?"
  else
    SERVICE=$($PSQL "select name from services where service_id=$SERVICE_ID_SELECTED")
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE

    #check phone number exists
    CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")
    
    if [[ -z $CUSTOMER_ID ]]
    then
       echo -e "\nI don't have a record for that phone number, what's your name?"
       read CUSTOMER_NAME
       R=$($PSQL "insert into customers(phone,name) values('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
       CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")
     else
        CUSTOMER_NAME=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE'")

    fi

     
   
 
    echo -e "\nWhat time would you like your $SERVICE, $CUSTOMER_NAME?"
    read SERVICE_TIME

    RESULT=$($PSQL "insert into appointments(customer_id,service_id,time) values($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME');")
    # echo "$RESULT"
   
   if [[ $RESULT == "INSERT 0 1" ]]
   then
      echo -e "\nI have put you down for a $SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
      
   fi

    
  fi
 
  fi

 
}

MAIN_MENU