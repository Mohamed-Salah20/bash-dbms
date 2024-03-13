#!/bin/bash

shopt -s extglob

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
    echo -e "\n"
    echo "***********"
    echo "Database Menu:"
    echo "1. create table"
    echo "2. list tables"
    echo "3. drop table"
    echo "4. exit"
    echo "************"
}



#####database_functions#####
create_database(){

read -p "Database name : " db_name
if valid_regex $db_name; then
    if db_exists $db_name; then
    echo "***Database  $db_name already exists***"
    else
    mkdir "./db/$db_name"
    cd "./db/$db_name"
    choice=3    #to connect to the database
    echo "***Database $db_name created succefully***"
    fi
else 
    echo "***Invalid Input, Enter a valid db name***"
fi

}

list_databases(){
echo "List of databases : "
ls "./db"
}

drop_database(){
    read -p "Database name :"  db_name
    if valid_regex "$db_name"
        then
            if db_exists $db_name
                then
                rm -rf "./db/$db_name"
                echo "database" $db_name "Deleted successfully"
            else
                echo "***Database $db_name does not exist***"
            fi
    fi

}

connect_database(){

read -p "Database name : " db_name
if db_exists $db_name; then
    cd "./db/$db_name"
    echo "connect database"
    else
    echo "***Database $db_name does not exist***"
    fi
}
########end of database_functions######


########database creation functions validations#####
#check db name regex 
valid_regex(){
local input=$1
regex='^[A-Za-z0-9_-]*$'
if [[ $input =~ "$regex" ]]; then
    return 1
else
    return 0 
fi
}

db_exists(){
local db_name=$1
if [ -d "./db/$db_name" ]
then
    echo "db already exists"
    return 0
else 
    return 1
fi
}
######################################



####database_table_functions#####

create_database_table(){
    read -p "Enter Table name : " table_name
    if [ -f "./$table_name" ]
    then
        echo "***Table $table_name already exists***"
    else
        touch ./$table_name
        echo "Table Created Successfully"
        
        choice=3 # to connect to database
        PS1="$db_name-$table_name: "
        set_table_schema
    fi

}

list_database_tables(){
ls 
}

drop_database_table(){
    read -p "Enter Table name : " table_name
    if [ -f "./$table_name" ]; then
    rm -rf ./$table_name
    echo "Table Deleted Successfully"
    else
    echo "***Table $table_name does not exist***"
    fi

}

set_table_schema() {
    read -p "Enter Number of Columns: " columns_count
    local array=()
    is_primary_key='n'
    for ((i = 0; i < ${columns_count}; i++));
    do
        echo "flage $is_primary_key"
        read -p "Enter column name : " column_name
        if [[ ${array[@]} =~ column_name  ]]; then
            (( i-- ))
            echo "***Column $column_name already exists***"
            continue
        else
        array[i]=$column_name
        fi      
        read -p "Enter column type : " column_type
        if [[ $is_primary_key != "y" && $is_primary_key != "Y" ]]; then
            read -p "is Primary key (y/n): " is_primary_key
        fi
    done
    echo "Column Names:" ${array[@]}
}

check_column_type() {
    read -p "Enter column type : " column_type
    if [ "$column_type" = "int" ]
    then
        return 1
    else
        return 0
    fi
}
#######end of database_table_functions##########

#################starting of the script################

while true; do
main_menu_display
read -p "enter your choice : " choice

case $choice in
1) create_database ;;
2) list_databases ;;
3) connect_database ;;
4) drop_database ;;
5) exit 0 ;;
*) echo "wrong input" ;;
esac
echo $choice
if [[ $choice == 3 ]] 
then
    while true; do
    database_menu_display
    read -p "enter your choice : " choice
    case $choice in
        1) create_database_table ;;
        2) list_database_tables ;;
        3) drop_database_table ;;
        4) break ;;
        *) echo "wrong input" ;;
    esac
    done
fi

done
