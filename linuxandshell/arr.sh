#declare your array
declare -a var

#split your line using tr
var=(`echo one,two,three,four | tr ',' ' '`)

#print the whole array
echo ${var[@]}

#iterate over the array
for s in ${var[@]}; do
    echo $s
done  
