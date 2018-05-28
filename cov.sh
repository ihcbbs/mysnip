#!/usr/bin/bash

printf "hello" ;
#echo "$(ls -al .)"
#正则语法可选posix-awk,posix-basic, posix-egrep 和posix-extended.
#echo "$(find . -regextype posix-extended  \( -type f -iregex '.*\.(mp4|mkv|rmvb|avi|webm)$' \) -not \( -iregex '.*/_x256' \))"
#清除原文件
# find . -type f -name '*_vp9.*' -delete
rm -rf result.log
rm -rf temp.mkv vp9.txt ffmpeg.txt
#正式开始
#清除文件find . -type f -regextype posix-extended   -iregex '.*\.(mp4|mkv|rmvb|avi|webm)$'    -name '*_vp9.*'  -delete



mypath="."


coursemode=0;
force=0;

#i要在外面定义；for作用域无效
while [ $# -ge 1 ]; do
case $1 in
-s) mypath=$2
shift
shift

if  [ ! \( -d $mypath \) ];then 
echo "error3";
exit 1;
fi
despath=$(mypath)
#echo "$despath"
continue;;
-d) despath=$2
shift
shift
if  [ ! \( -d $despath \) ];then 
echo "error3";
exit 1;
fi
continue;;
-e) expath=$2
shift
shift
if  [ ! \( -d $expath \) ];then 
echo "error4";
exit 1;
fi
continue;;

-c) coursemode=1
shift
continue;;
-f) force=1
shift
continue;;
*) echo "error1";
exit 1;;
esac
done


exit 1




if  [ ! \( -d $mypath \) ];then 
echo "error2";
exit 1;
fi


echo "find in $mypath,despath is $despath ,exclude $expath"
if [ -n "$expath" ];then 
echo "exclude"
find $mypath ! -path $expath  -type f -regextype posix-extended   -iregex '.*\.(mp4|mkv|rmvb|avi|webm)$'  -not   -name '*_vp9.*'    >> vp9.txt
else 
find $mypath -type f -regextype posix-extended   -iregex '.*\.(mp4|mkv|rmvb|avi|webm)$'  -not   -name '*_vp9.*'    >> vp9.txt
fi


#清除文件find . -type f -regextype posix-extended   -iregex '.*\.(mp4|mkv|rmvb|avi|webm)$'    -name '*_vp9.*'  -delete
while read ifile; do 
#ffmpeg -i $(echo "$ifile");
#echo "$ifile"|xargs -n1 -I ffmpeg -i {} ;
#echo "adasd"
#echo "----ifile: $ifile  ----\n \n"
#ffmpeg -i $((ifile))
#echo "$((foo++))"
#echo "----$ifile[@]  ----"

if [[ $ifile =~ "_x265" ]]; then 
echo "$ifile"
echo  "It is a hevc file"
continue;
fi 



#voa=$(ffprobe  -hide_banner -show_streams -print_format json $ifile  |jq  '.streams[1].tags.handler_name')

width=0; 
probeOut=$(ffprobe  -hide_banner -show_streams -print_format json $ifile);





width=$(echo " ${probeOut} "|jq  '.streams[0].width');

height=$(echo " ${probeOut} "|jq  '.streams[0].height');
fps=$(echo " ${probeOut} "|jq  '.streams[0].avg_frame_rate');
#height=$(ffprobe  -hide_banner -show_streams -print_format json $ifile  |jq  '.streams[0].height');
echo "width : $width"
if [ $width = "null" ];then
width=$(echo " ${probeOut} "|jq  '.streams[1].width');
height=$(echo " ${probeOut} "|jq  '.streams[1].height');
fps=$(echo " ${probeOut} "|jq  '.streams[1].avg_frame_rate');
fi
if [ $width = "null" ];then
continue;
fi

#if [ -nwidth ]

#ffmpeg -i $ifile   2> ffmpeg.txt  < /dev/null
#if [ -n "$(grep -h ', [[:digit:]]*x[[:digit:]]* \[' ffmpeg.txt)" ]; then 
#reso=$(echo "width*height"| bc);
#else continue
#fi
reso=$(echo "sqrt ($width*$height)"| bc);
k=1

	echo "$k----------------------$height-----------------------$reso--------------------------$width----"
if [ $reso -gt 960 ];then 
#echo "$reso is greater than 960"
speed=2
if [ "$force" = "1" ];then
echo "Your scrren will to be diminish."
k=$(echo "scale=3;$reso/960"|bc)
width=$(echo "$width/$k"|bc)
height=$(echo "$height/$k"|bc)
reso=$(echo "$reso/$k"|bc)
fi
else speed=1
fi
echo "$k----------------------$height-----------------------$reso--------------------------$width----"

fps=$(echo "$fps"|bc)
#必须要有两次，不是错误
fps=$(echo "$fps"|bc)
echo "------------------------------------------------------------------------------$fps"
if [ "$force" = "1" ];then
fps=25
fi






tile=$(echo "($reso+100)/1000+1"|bc)
crf=$(echo "34-($reso+100)/500"|bc)

#"1"似乎为特例
if [ "$coursemode" = "1" ];then
crf=$(echo "35-($reso+100)/500"|bc)
fi
thread=$(echo "($tile+1)^2"|bc)
echo "speed:$speed thread:$thread tile:$tile reso:$reso crf:$crf"

echo "\n ----------------输入文件 $ifile ----------------------------------------\n">>result.log

#（x265）课程等基本静态内容crf=$(echo "32-($reso+100)/250"|bc)
#echo "$ifile"|sed 's/\.mp4/\_x256.mp4/'

#当前格式一定在第一个，仅第一个为ifile
ofile=$(echo "$ifile"|sed 's/\.mkv/\_vp9.mkv/')
ofile=$(echo "$ofile"|sed 's/\.MKV/\_vp9.mkv/')
ofile=$(echo "$ofile"|sed 's/\.mp4/\_vp9.mkv/')
ofile=$(echo "$ofile"|sed 's/\.MP4/\_vp9.mkv/')
ofile=$(echo "$ofile"|sed 's/\.avi/\_vp9.mkv/')
ofile=$(echo "$ofile"|sed 's/\.AVI/\_vp9.mkv/')
ofile=$(echo "$ofile"|sed 's/\.webm/\_vp9.mkv/')
ofile=$(echo "$ofile"|sed 's/\.WEBM/\_vp9.mkv/')
#有变量的sed用双引号
ofile=$(echo "$ofile"|sed -e "s#${mypath}#${despath}/#")

if [ -f $ofile ]; then 
echo "$ofile is exist"
continue
fi 




echo "$ifile\t$ofile"
#关闭标准输入
#ffmpeg  -i  "$ifile" -c:v  hevc -crf $crf -c:a copy -preset slow 



#ffmpeg -i "$ifile"   -tile-columns $tile -threads $thread -quality good  -b:v 0 -crf $crf -c:v libvpx-vp9 -c:a libopus temp.mkv < /dev/null >>result.log
#204075kB time=00:48:00.81 bitrate= 580.3kbits/s speed=0.323x


ffmpeg   -y -hide_banner  -hwaccel auto  -i "$ifile" -c:v libvpx-vp9 -pass 1 -b:v 0 -crf $crf -threads $thread -quality good -speed  4 -tile-columns $tile -frame-parallel 1 -an -r $fps -vf scale=${width}:${height} -f webm /dev/null  < /dev/null >>result.log
ffmpeg   -hide_banner  -hwaccel auto    -i "$ifile"  -c:v libvpx-vp9 -pass 2 -b:v 0 -crf $crf -threads $thread  -quality good -speed  $speed -tile-columns $tile -frame-parallel 1 -auto-alt-ref 1   -c:a libopus -b:a 64k -r $fps  -vf scale=${width}:${height}   temp.mkv < /dev/null >>result.log

#ffmpeg -hwaccel vaapi -hwaccel_device /dev/dri/renderD128 -hwaccel_output_format vaapi -i input.mp4 -vf 'scale_vaapi=format=p010' -c:v hevc_vaapi -profile 2 -b:v 15M output.mp4


#sed 's/, //' reso.txt 


width=$(ffprobe  -hide_banner -show_streams -print_format json temp.mkv  |jq  '.streams[0].width');
if [ $width = "null" ];then
width=$(ffprobe  -hide_banner -show_streams -print_format json temp.mkv  |jq  '.streams[1].width');
fi
if [ $width = "null" ];then
continue;
fi
mv temp.mkv $ofile 
echo  "\n ----------------输出文件 $ofile ----------------------------------------\n">>result.log

#$(grep -oh ', [[:digit:]]*x[[:digit:]]* \[' ffmpeg.txt) > cut -d ' ' 

#不知为何无效grep -eh ', [[:digit:]]+x[[:digit:]+ \['  ffmpeg.txt
#echo " ${#foo}"

 #grep 2017 ffmpeg.txt
 #grep 2017 $(ffmpeg -i $ifile)
done <  vp9.txt

rm -rf temp.mkv vp9.txt ffmpeg.txt
exit 0