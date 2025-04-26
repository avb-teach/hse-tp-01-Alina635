#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Использование: $0 /path/to/input_dir /path/to/output_dir"
    exit 1
fi

input_dir="$1"
output_dir="$2"

if [ ! -d "$input_dir" ]; then
    echo "Ошибка: Входная директория '$input_dir' не существует."
    exit 1
fi

mkdir -p "$output_dir"
file_count=()

copy_files() {
    local dir="$1"
    
    for item in "$dir"/*; do
        if [ -d "$item" ]; then
            copy_files "$item"
        elif [ -f "$item" ]; then
            filename="${item##*/}"
            extension="${filename##*.}"
            name="${filename%.*}" 
            index=-1
            
            for i in "${!file_count[@]}"; do
                if [[ "${file_count[$i]}" == "$name" ]]; then
                    index=$i
                    break
                fi
            done
            
            if [[ $index -eq -1 ]]; then
                file_count+=("$name")
                index=$((${#file_count[@]} - 1))
                count=0
            else
                count=$((index + 1))
            fi
            
            if [[ -e "$output_dir/$filename" ]]; then
                new_filename="${name}${count}.$extension"
                cp "$item" "$output_dir/$new_filename"
            else
                cp "$item" "$output_dir/$filename"
            fi
            
        fi
    done
}
copy_files "$input_dir"
echo "END"
