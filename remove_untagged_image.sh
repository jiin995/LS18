temp=($(docker images|grep  "<none>" | awk '{print $3}'| tr -s '\n' ' '))
for (( i=0; i<${#temp[@]}; i++ ));
do
  docker rmi ${temp[i]}
  #./pull_image.sh im &
done


