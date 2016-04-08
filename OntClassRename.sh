#!/bin/bash


######
# Look for highest class number from OPHPDD ontology

last_class_number=$(egrep -o 'OPHPDD_[0-9]{7}' OPHPDD_try.owl | egrep -o [0-9]{7} |sed 's/^0*//'| sort -nr | head -n 1)
new_class_number=$((last_class_number + 1))


############
#look for OPHPDD class define with #...

class_to_change=($(egrep -o 'OPHPDD.owl#(.*)' OPHPDD_try.owl | sed 's/^OPHPDD.owl#//' | sed -e 's:"/>$::' -e 's: -->$::' -e 's:">$::' | sort -u |tail -n +2))

########
#In OPHPDD.owl file, change each class define with #... by OPHPDD_number 


for item in ${class_to_change[*]}
do
      old_class_name=$(echo "#$item")
      new_class_name=$(printf "/OPHPDD_%07d\n" $new_class_number)

      #first add a proper label
      label_line="         <rdfs:label xml:lang=\"en\">$item</rdfs:label>"
      sed -i "s|^.*<owl:Class.*$item\">$|&\n$label_line|" OPHPDD_try.owl
      
      #then substitute
      sed -i "s|$old_class_name\">$|$new_class_name\">|" OPHPDD_try.owl
      sed -i "s|$old_class_name\"/>$|$new_class_name\"/>|" OPHPDD_try.owl
      sed -i "s|$old_class_name -->$|$new_class_name -->|" OPHPDD_try.owl

      #increase class number
      new_class_number=$((new_class_number + 1))

done

