#!/bin/bash

shopt -s extglob

# create db folder for the first script run in a certin path
if [ ! -d db ]; then
mkdir db
fi


#use this function for all name validation checks, note 0 return statues is success while 1 is failure 
valid_regex(){
local input=$1
regex='^[A-Za-z][A-Za-z0-9_-]*$'
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
    echo "3. drop database"
    echo "4. connect to databases"
    echo "0. exit"
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
    echo "4. CRUD operation on table"
    echo "0. exit"
    echo "************"
    echo -e "\n"
}
table_menu_display(){
    echo -e "\n"
    echo "***********"
    echo "Table Menu:"
    echo "1. select from $table_name"
    echo "2. insert into $table_name"
    echo "3. delete from $table_name"
    echo "4. update $table_name"
    echo "0. exit"
    echo "************"
    echo -e "\n"
}

select_menu_display(){
    echo -e "\n"
    echo "***********"
    echo "Select Menu:"
    echo "1. select * from $table_name"
    echo "2. select by primary key from $table_name"
    echo "0. exit"
    echo "************"
    echo -e "\n"
}
update_menu_display(){
    echo -e "\n"
    echo "***********"
    echo "Update Menu:"
    echo "1. Update $table_name by primary key"
    echo "0. exit"
    echo "************"
    echo -e "\n"
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
    if valid_regex "$db_name"; then
        if db_exists $db_name; then
            rm -rf "./db/$db_name"
            echo "database" $db_name "Deleted successfully"
        else
            echo "***Database $db_name does not exist***"
        fi
    else
        echo "***Invalid Input, Enter a valid db name***"    
    fi

}

connect_database(){

    read -p "Database name : " db_name
    if valid_regex "$db_name"; then

    if db_exists $db_name; then
        cd "./db/$db_name"
        echo "connected to database $db_name"
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
        # touch ./$table_name
        # # if [ ! -f "./Metadata.inf" ]
        # # then
        # #     touch ./Metadata.inf
        
        # # else
        # #     echo "$table_name: " >> Metadata.inf
        # # fi
        # echo "Table Created Successfully"
        
        # # choice=3 # to connect to database
        # # PS1="$db_name-$table_name: "
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

    if ! valid_regex "$table_name" ; then
        echo "***Invalid regex***"
        return 1
    fi

    if [ -f "./$table_name" ]; then
    rm -rf ./$table_name
    echo "Table $table_name Deleted Successfully"
    else
    echo "***Table $table_name does not exist***"
    fi

}


check_number_validate_type(){
    if [[ $1 =~ ^[1-9][0-9]*$ ]]; then
        return 0  # Valid number
    else
        return 1  # Invalid number
    fi
}

set_table_schema() {
    read -p "Enter Number of Columns: " columns_count
    
    if ! check_number_validate_type "$columns_count"; then
    echo "Invalid number of columns"
    return 1 #
    fi


    local array=()
    local data_Types_Array=()
    # local is_primary_key='n'
    local primary_key=""
    for ((i = 0; i < ${columns_count}; i++));
    do
        # 
        if [ $i -eq 0 ]; then
        echo "note first column will be primary key"
        fi

        read -p "Enter column $(($i + 1)) name : " column_name        
        
        if valid_regex "$column_name"; then
            if [[ ${array[@]} =~ "$column_name"  ]]; then
                echo "***Column $column_name already exists***"
                (( i-- ))
                continue
            # else
            #     array[i]=$column_name #store columns in array
            #     # 
            #     if [ $i -eq 0 ]; then
            #     primary_key=$column_name
            #     fi
            #     # 
            fi      

            read -p "Enter column $(( $i + 1 )) type, (string|digit) : " column_type
            if check_column_type "$column_type"; then
                data_Types_Array[i]=$column_type #store data types in array
                
                array[i]=$column_name #store columns names in array
                # 
                if [ $i -eq 0 ]; then
                primary_key=$column_name
                fi
                
                # if [[ $is_primary_key != "y" && $is_primary_key != "Y" ]]; then
                #     read -p "is Primary key (y/n): " is_primary_key
                #     if [[ $is_primary_key == "y" || $is_primary_key == "Y" ]]; then
                #         echo $column_name >> $table_name #store the primary key
                #     fi
                # fi
            else
                echo "***Invalid column type, must write "string" or "digit" ***"
                (( i-- ))
                continue
            fi    
        else
            echo "***Invalid Input, Enter a valid column name***"
            (( i-- ))
            continue
        fi
        echo     
    done
    
     # separate elements by delim :
    array_delimitar=$(printf ":%s" ${array[@]})
    data_Types_Array_Delimitar=$(printf ":%s" ${data_Types_Array[@]})
     #cut the first : delim before first element
    array_delimitar=${array_delimitar:1}
    data_Types_Array_Delimitar=${data_Types_Array_Delimitar:1}

    
    # create table file
    touch ./$table_name
    echo "Table Created Successfully"

    # save schema to table file
    echo $primary_key >> $table_name # store the primary key
    echo ${#array[@]} >> $table_name # store columns number in schema
    echo $array_delimitar
    echo $data_Types_Array_Delimitar

     #write to the file
    echo ${data_Types_Array_Delimitar} >> $table_name
    echo ${array_delimitar} >> $table_name
    echo "schema created successfully"
}

check_column_type() {
    case "$1" in
        string | digit )
            return 0 ;;  # Return 0 for success
        *) 
            return 1 ;;  # Return 1 for failure
    esac
}
#######end of database_table_functions##########

#############################################
####################CRUD OPERATIONS##########

validate_value_primary_key() {

local value=$1

# check if the primary key value is unique
if ! grep -q "^$value:" "$table_name"; then # --quiet from man page: Quiet;   do   not  write  anything  to  standard  output.   Exit immediately with zero status if any match is found
    return 0  # unique primary key
else
    echo "Primary key '$value' already exists."
    return 1  # duplicate primary key
fi

}


# validate_value_type(){
#     #check whether the value type is valid for the value type of the column type
#     local value=$1
#     local index=$2
#     # mo note: please refrain from using global variables ex. isValid
#     # isValid=false #flag to check if value is valid for this column type
#     if [[ $value =~ ^[0-9]+$ && ${columns_types_arr[$index]} == 'digit' ]]; then
#         echo "Integer"
#         # isValid=true
#         return 0
#     #mo note:why float? if so we should add another column type in schema  
#     elif [[ $value =~ ^[0-9]+\.[0-9]+$ && ${columns_types_arr[$index]} == 'digit' ]]; then
#         echo "Float"
#         # isValid=true
#         return 0
#     #mo note:string old regex used is not working ^(?![0-9]*$)[a-zA-Z0-9]+$, also storing only digits as strings should be acceptable, the same goes for - and _
#     elif [[ $value =~ ^[a-zA-Z0-9_-]+$ && ${columns_types_arr[$index]} == 'string' ]]; then
#         echo "String"
#         # isValid=true
#         return 0
#     else
#         echo "Invalid Input"
#         # isValid=false
#         return 1
#     fi
# }

check_digit_validate_type(){
    if [[ $1 =~ ^[0-9]+$ ]]; then
        return 0  # Valid digit
    else
        echo "***Invalid digit input***"
        return 1  # Invalid digit
    fi
}

check_string_validate_type(){
  if [[ $1 =~ ^[a-zA-Z0-9_@.-]*$ ]]; then # handle accepted characters later
    return 0  # Valid string
  else
    echo "***Invalid string input***"
    return 1  # Invalid string
  fi
}


insert() {
    # Get table name and validate
    # read -p "Enter Table name: " table_name
    # if ! valid_regex "$table_name"; then
    # echo "Invalid table name"
    # return 1
    # fi

    # Check if table exists
    if [ ! -f "$table_name" ]; then
    echo "Table '$table_name' does not exist"
    return 1
    fi

    # Read schema details
    columns_count=$(awk 'NR==2 {print}' "$table_name")
    columns_names_arr=($(awk 'NR==4 {print}' "$table_name" | tr ":" " "))
    columns_types_arr=($(awk 'NR==3 {print}' "$table_name" | tr ":" " "))
    column_type_primary_key=$(awk 'NR==1 {print}' "$table_name")


    # testing
    # echo "columns_count : $columns_count"
    # echo "columns_name : ${columns_names_arr[@]}"
    # echo "column_types_arr : ${columns_types_arr[@]}"
    # echo "column_names_index : ${columns_names_arr[0]}"

    # Prompt for data for each column
    data_values=""
    for ((i = 0; i < columns_count; i++)); do
        read -p "Enter value for '${columns_names_arr[$i]}' of data type '${columns_types_arr[$i]}': " data

        # # Validate the entered value
        # if ! validate_value_type "$data" "${columns_types_arr[$i]}"; then
        #     (( i-- ))
        #     continue
        # fi


        if [[ ${columns_types_arr[$i]} == "digit" ]]; then
            if ! check_digit_validate_type "$data"; then
                (( i-- ))
                continue  # Retry if invalid input
            fi
        elif [[ ${columns_types_arr[$i]} == "string" ]]; then
            if ! check_string_validate_type "$data"; then
                (( i-- ))
                continue
            fi
        fi

        if [[ "${columns_names_arr[$i]}" == "$column_type_primary_key" ]]; then
            if grep -q "^$data:" "$table_name"; then
                echo "Value '$data' is not unique in the primary key column '${columns_names_arr[$i]}'"
                (( i-- ))
                continue
            fi
        fi

    data_values+="$data:"
    done

    # Remove the trailing colon from data_values
    data_values=${data_values::-1}

    # Append data to the table file
    echo "$data_values" >> "$table_name"

  echo "Data inserted successfully!"
}

update_table_by_primary_key() {
    read -p "Enter the value of the primary key to update the corresponding row: " primary_key_value

    # Check if the primary key value exists in the table
    if grep -q "^$primary_key_value:" "$table_name"; then
        # Read my schema details
        columns_count=$(awk 'NR==2 {print}' "$table_name")
        columns_names_arr=($(awk 'NR==4 {print}' "$table_name" | tr ":" " "))
        columns_types_arr=($(awk 'NR==3 {print}' "$table_name" | tr ":" " "))
        column_type_primary_key=$(awk 'NR==1 {print}' "$table_name")

        new_values=""
        for ((i = 0; i < columns_count; i++)); do
            if [ $i -eq 0 ]; then
                # Skip updating the primary key column and keep its value unchanged
                new_value=$primary_key_value
            else
                read -p "Enter new value for '${columns_names_arr[$i]}' (${columns_types_arr[$i]}): " new_value

                # Validate the entered value based on its data type
                if [[ ${columns_types_arr[$i]} == "digit" ]]; then
                    if ! check_digit_validate_type "$new_value"; then
                        (( i-- ))
                        continue  # Retry if invalid input
                    fi
                elif [[ ${columns_types_arr[$i]} == "string" ]]; then
                    if ! check_string_validate_type "$new_value"; then
                        (( i-- ))
                        continue
                    fi
                fi
            fi

            # Construct the new row values
            new_values+="$new_value:"
        done

        # Remove the trailing colon from new_values
        new_values=${new_values::-1}

        # Temporarily store contents of the table excluding the row with the specified primary key
        awk -v key="$primary_key_value" -v new_row="$new_values" -F ":" '$1 != key {print} $1 == key {print new_row}' "$table_name" > temp_table

        # Overwrite the original table file with the temporary file (including the updated row)
        mv temp_table "$table_name"

        echo "Row with primary key '$primary_key_value' updated successfully."
    else
        echo "Row with primary key '$primary_key_value' not found in the table."
    fi
}


delete_from_table() {
    
    echo "delete from table"
    read -p "Enter the value of the primary key to delete the corresponding row: " primary_key_value

    # Check if the primary key value exists in the table
    if grep -q "^$primary_key_value:" "$table_name"; then
        # Temporarily store contents of the table excluding the row with the specified primary key
        awk -v key="$primary_key_value" -F ":" '$1 != key {print}' "$table_name" > temp_table

        # Overwrite the original table file with the temporary file (excluding the deleted row)
        mv temp_table "$table_name"

        echo "Row with primary key '$primary_key_value' deleted successfully."
    else
        echo "Row with primary key '$primary_key_value' not found in the table."
    fi

}

connect_to_table() {
    read -p "table name: " table_name
    if valid_regex "$table_name"; then
        if [ -f "$table_name" ]; then
            echo "table : " "$table_name"
            # clear
            table_menu
        else
            echo "***Table $table_name does not exist***"
        fi
    else
        echo "***Invalid regex: $table_name***"
    fi
}

select_from_table_all() {
    awk 'BEGIN{FS=": ";} {if(NR> 3){gsub(/:/, "\t\t|\t\t", $0);print;}}' ./$table_name
}

select_from_table_by_primary_key() {
    read -p "Enter the value of the primary key to select the corresponding row: " primary_key_value

    # Check if the primary key value exists in the table
    if grep -q "^$primary_key_value:" "$table_name"; then
        
        column_names=$(awk 'NR==4 {print}' "$table_name" | sed 's/:/\t\t|\t\t/g')
        
        # Output the column names first separated by sed command
        echo "$column_names"
        # Filter the table to display only the row with the specified primary key
        awk -v key="$primary_key_value" -F ":" 'NR>4 && $1 == key {print $0}' "$table_name" | sed 's/:/\t\t|\t\t/g'
    else
        echo "Row with primary key '$primary_key_value' not found in the table."
    fi
}

################# END OF CRUD #################

#################starting of the script################

main_menu(){

while true; do
main_menu_display
read -p "enter your choice : " choice

case $choice in
1) create_database ;;
2) list_databases ;;
3) drop_database ;;
4) connect_database ;;
0) exit 0 ;;
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
        4) connect_to_table ;;
        0) cd ../..
            main_menu ;;
        *) echo "wrong input" ;;
    esac
    done
}

# why?
table_menu() {
    while true; do
    table_menu_display
    read -p "enter your choice : " choice
    case $choice in
        1) select_from_table_menu ;;
        2) insert ;;
        3) delete_from_table ;;
        4) update_menu ;;
        0) database_menu ;;
    esac
    done
}

select_from_table_menu() {
    select_menu_display
    read -p "choice : " choice_select
    case "$choice_select" in
    1) 
    #Select * from Table    
    select_from_table_all
    ;;
    2)
    select_from_table_by_primary_key    
    ;;
    0)
    table_menu    
    ;;
    *) 
    echo "invalid input" ;;
    esac
}

update_menu(){
    update_menu_display
    read -p "choice : " choice_update
    case "$choice_update" in
    1)     
    update_table_by_primary_key
    ;;
    0)
    table_menu    
    ;;
    *) echo "invalid input" ;;
    esac    
}
main_menu

