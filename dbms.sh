#!/bin/bash

shopt -s extglob

# create db folder for the first script run in a certin path
if [ ! -d db ]; then
mkdir db
fi


#use this function for all name validation checks, note 0 return statues is success while 1 is failure 
valid_regex(){
local input=$1
regex='^[A-Za-z0-9_-]*$'
if [[ $input =~ $regex ]]; then
    return 0 #return successful
else
    return 1 #return failed
fi
}


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
table_menu_display(){
    echo "***********"
    echo "Table Menu:"
    echo "1. select from $table_name"
    echo "2. insert into $table_name"
    echo "3. delete from $table_name"
    echo "4. update $table_name"
    echo "5. exit"

}
#####database_functions#####
create_database(){

    read -p "Database name : " db_name
    if valid_regex "$db_name"; then
        if db_exists $db_name; then
        echo "***Database  $db_name already exists***"
        else
        mkdir "./db/$db_name"
        # cd "./db/$db_name"
        # choice=3    #to connect to the database
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
    if valid_regex "$db_name"; then

    if db_exists $db_name; then
        cd "./db/$db_name"
        echo "connect to database $db_name"
        database_menu
    else
        echo "***Database $db_name does not exist***"
    fi
else 
    echo "***Invalid Input, Enter a valid db name***"
fi
}
########end of database_functions######


########database creation functions validations#####
db_exists(){
local db_name=$1
if [ -d "./db/$db_name" ]
then
    return 0
else 
    return 1
fi
}
######################################



####database_table_functions#####

create_database_table(){
    read -p "Enter Table name : " table_name
    if valid_regex "$table_name"; then
    if [ -f "./$table_name" ]
    then
        echo "***Table $table_name already exists***"
    else
        touch ./$table_name
        # if [ ! -f "./Metadata.inf" ]
        # then
        #     touch ./Metadata.inf
        
        # else
        #     echo "$table_name: " >> Metadata.inf
        # fi
        echo "Table Created Successfully"
        
        # choice=3 # to connect to database
        # PS1="$db_name-$table_name: "
        set_table_schema
    fi
    else
        echo "***Invalid Input, Enter a valid name***"
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
    local data_Types_Array=()
    local is_primary_key='n'
    for ((i = 0; i < ${columns_count}; i++));
    do
        read -p "Enter column name : " column_name
        if valid_regex "$column_name"; then
            if [[ ${array[@]} =~ "$column_name"  ]]; then
                (( i-- ))
                echo "***Column $column_name already exists***"
                continue
            else
                array[i]=$column_name #store columns in array
            fi      

            read -p "Enter column type : " column_type
            if check_column_type "$column_type"; then
                data_Types_Array[i]=$column_type #store data types in array
                if [[ $is_primary_key != "y" && $is_primary_key != "Y" ]]; then
                    read -p "is Primary key (y/n): " is_primary_key
                    if [[ $is_primary_key == "y" || $is_primary_key == "Y" ]]; then
                        echo $column_name >> $table_name #store the primary key
                    fi
                fi
            else
                echo "***Invalid column type***"
                (( i-- ))
                continue
            fi    
        else
            echo "***Invalid Input, Enter a valid column name***"
        fi    
    done
    # save schema to table file
    echo ${#array[@]} >> $table_name # store columns number in schema
    
     # separate elements by delim :
    array_delimitar=$(printf ":%s" ${array[@]})
    data_Types_Array_Delimitar=$(printf ":%s" ${data_Types_Array[@]})
     #cut the first : delim before first element
    array_delimitar=${array_delimitar:1}
    data_Types_Array_Delimitar=${data_Types_Array_Delimitar:1}

    echo $array_delimitar
    echo $data_Types_Array_Delimitar

     #write to the file
    echo ${data_Types_Array_Delimitar} >> $table_name
    echo ${array_delimitar} >> $table_name
    echo "schema created successfully"
}

check_column_type() {
    case "$1" in
        string | int )
            return 0 ;;  # Return 0 for success
        *) 
            return 1 ;;  # Return 1 for failure
    esac
}
#######end of database_table_functions##########

#############################################
####################CRUD OPERATIONS##########

insert() {
  # Get table name and validate
  read -p "Enter Table name: " table_name
  if ! valid_regex "$table_name"; then
    echo "Invalid table name"
    return 1
  fi

  # Check if table exists
  if [ ! -f "$table_name" ]; then
    echo "Table '$table_name' does not exist"
    return 1
  fi

  # Read schema details
  columns_count=$(awk 'NR==2 {print}' "$table_name")
  columns_names_arr=($(awk 'NR==4 {print}' "$table_name" | tr ":" " "))

  # Prompt for data for each column
  data_values=""
  for ((i = 0; i < columns_count; i++)); do
    read -p "Enter value for '${columns_names_arr[$i]}': " data
    data_values+="$data:"
  done

  # Remove the trailing colon from data_values
  data_values=${data_values::-1}

  # Append data to the table file
  echo "$data_values" >> "$table_name"

  echo "Data inserted successfully!"
}

selectt(){
    echo "SELECT"
}

delete(){
    echo "DELETE"
}

update(){
    echo "UPDATE"
}

##################END OF CRUD############
############################################

#######CRUD Operations##########
insert_into_table() {
    echo "insert into table"
}

delete_from_table() {
    echo "delete from table"
}

update_into_table() {
    echo "update into table"
}
connect_to_table() {
    read -p "opent table: " table_name
    if [ -f "./$table_name" ]; then
        echo "connected"
    else
        echo "***Table $table_name does not exist***"
    fi
    clear
    table_menu

}
select_from_table() {
    #Select * from Table
    # read -p "Enter Query: " QueryString
    awk 'BEGIN{FS=": ";} {if(NR> 3){gsub(/:/, "\t|\t", $0);print;}}' ./$table_name

}
#################starting of the script################

main_menu(){

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
done

}

database_menu(){
    
    while true; do
    database_menu_display
    read -p "enter your choice : " choice
    case $choice in
        1) create_database_table ;;
        2) list_database_tables ;;
        3) drop_database_table ;;
        4) cd ..
            main_menu ;;
        *) echo "wrong input" ;;
    esac
    done
}

table_menu() {
    while true; do
    table_menu_display
    read -p "enter your choice : " choice
    case $choice in
        1) select_from_table ;;
        2) insert_into_table ;;
        3) delete_from_table ;;
        4) update_into_table ;;
        5) exit 0 ;;
    esac
    done
}

main_menu

