#sudo su -
#sg_scan -i
start=`date +%s`
date
sg_format --format --size=512 -v "/dev/sg$1"
date
end=`date +%s`
runtime=$((end-start))

echo "Runtime $runtime"
