#!/bin/bash


# create db folder for the first script run in a certin path
if [ ! -d db ]; then
mkdir db
fi


# Display main menu
main_menu_display(){
    echo -e "\n"
    echo "***********"
    echo "Main Menu:"
    echo "1. create database"
    echo "2. list databases"
    echo "3. connect to databases"
    echo "4. drop database"
    echo "5. exit"
    echo "************"
    echo -e "\n"
}

# Display Database menu
database_menu_display(){
echo "database_menu_display"
}

#####database_functions#####
create_database(){

read -p "Database name : " db_name
if db_exists $db_name; then
echo "Database $db_name already exists"
else
mkdir "db/$db_name"
echo "Database $db_name created"
fi
}

list_databases(){
echo "list databases"
}

drop_database(){
echo "drop database"
}

connect_database(){
echo "connect database"
}
########end of database_functions######


########database creation functions validations #####
valid_db_name(){
echo "valid db name"
}

db_exists(){
local db_name=$1
if [ -d "db/$db_name" ]; then
return 0
else 
return 1
fi
}
######################################



####database_table_functions#####

create_database_table(){
echo "create table"
}

list_database_tables(){
echo "list tables"
}

drop_database_table(){
echo "drop table"
}

#######end of database_table_functions##########

#################starting of the script################

while true; do
main_menu_display
read -p "enter your choice : " choice
case $choice in

1) create_database ;;
5) exit 0 ;;
*) echo "wrong input" ;;

esac
done