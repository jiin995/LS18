temp=($(docker ps -a |grep  "months ago" | awk '{print $1}'| tr -s '\n' ' '))
for (( i=0; i<${#temp[@]}; i++ ));
do
  #echo ${temp[i]}
  docker rm ${temp[i]}
  #./pull_image.sh im &
done


