#!/usr/bin/bash
apt install -y jq ffmpeg bc
printf "hello" ;
#echo "$(ls -al .)"
#正则语法可选posix-awk,posix-basic, posix-egrep 和posix-extended.
#echo "$(find . -regextype posix-extended  \( -type f -iregex '.*\.(mp4|mkv|rmvb|avi|webm)$' \) -not \( -iregex '.*/_x256' \))"
#清除原文件
# find . -type f -name '*_vp9.*' -delete
rm -rf out.txt
rm -rf temp.mkv in.txt ffmpeg.txt
#正式开始
#清除文件find . -type f -regextype posix-extended   -iregex '.*\.(mp4|mkv|rmvb|avi|webm)$'    -name '*_vp9.*'  -delete

#fastmode是压缩分辨率和帧率。coursemode是调整压缩参数使内容更快也更小。

soupath="."
despath="."

coursemode=0;
fastmode=0;

#i要在外面定义；for作用域无效
while [ $# -ge 1 ]; do
case $1 in
-s) soupath=$2
if [ $# -lt 2 ];then 
echo "error4"
exit 1;
fi
shift
shift

if  [ ! \( -d $soupath \) ];then 
echo "error3";
exit 1;
fi
despath=$soupath
continue;;

-d) despath=$2
if [ $# -lt 2 ];then 
echo "error4"
exit 1;
fi
shift
shift
if  [ ! \( -d $despath \) ];then 
echo "error3";
exit 1;
fi
continue;;
-e) expath=$2
if [ $# -lt 2 ];then 
echo "error4"
exit 1;
fi
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
-f) fastmode=1
shift
continue;;
*) echo "error1";
exit 1;;
esac
done




if  [ ! \( -d $soupath \) ];then 
echo "error2";
exit 1;
fi


echo "find in $soupath,despath is $despath ,exclude $expath"
if [ -n "$expath" ];then 
echo "exclude"
find $soupath ! -path $expath  -type f -regextype posix-extended    -iregex '.*\.(mp4|mkv|rmvb|avi|webm)$'  -not   -name '*_vp9.*'  -not   -name '*荷官*' -not   -name '*xiapian*' -not   -name '*UU23*' -not   -name '*聊天*' -not   -name '*直播*' -not   -name '*Lena*'   -not   -name '*裸聊*' >> in.txt
else 
find $soupath -type f -regextype posix-extended   -iregex '.*\.(mp4|mkv|rmvb|avi|webm)$'  -not   -name '*_vp9.*'  -not   -name '*荷官*' -not   -name '*xiapian*' -not   -name '*UU23*' -not   -name '*聊天*' -not   -name '*直播*' -not   -name '*Lena*'   -not   -name '*裸聊*'   >> in.txt
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




width=0; 
probeOut=$(ffprobe -fflags discardcorrupt -fflags fastseek  -hide_banner -show_streams -print_format json $ifile);





width=$(echo " ${probeOut} "|jq  '.streams[0].width');

height=$(echo " ${probeOut} "|jq  '.streams[0].height');
fps=$(echo " ${probeOut} "|jq  '.streams[0].avg_frame_rate');
dura=$(echo " ${probeOut}  "|jq   '.streams[0].duration'); 
#height=$(ffprobe  -hide_banner -show_streams -print_format json $ifile  |jq  '.streams[0].height');
echo "width : $width"
if [ $width = "null" ];then
width=$(echo " ${probeOut} "|jq  '.streams[1].width');
height=$(echo " ${probeOut} "|jq  '.streams[1].height');
fps=$(echo " ${probeOut} "|jq  '.streams[1].avg_frame_rate');
dura=$(echo " ${probeOut}  "|jq   '.streams[1].duration'); 
fi

dsec=$(echo "$dura"|sed 's/\"//')
dsec=$(echo "$dsec"|sed 's/\"//')

dsec=$(echo "scale=0;$dsec/1"|bc);

dmin=$(echo "scale=0;$dsec/60"|bc);
dsec=$(echo "scale=0;$dsec%60"|bc);
dhour=$(echo "scale=0;$dmin/60"|bc);
dmin=$(echo "scale=0;$dmin%60"|bc);







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


echo "原k:$k---------------长$height----------------解析度$reso----------------宽$width"
if [ $reso -gt 960 ];then 
#echo "$reso is greater than 960"
speed=2
if [ "$fastmode" = "1" ];then
echo "Your scrren will to be diminish."
k=$(echo "scale=3;$reso/960"|bc)
width=$(echo "$width/$k"|bc)
height=$(echo "$height/$k"|bc)
reso=$(echo "$reso/$k"|bc)
fi
else speed=1
fi

fps=$(echo "$fps"|bc)
#必须要有两次，不是错误
fps=$(echo "$fps"|bc)
if [ "$fastmode" = "1" ];then
fps=25
fi






tile=$(echo "($reso+100)/1000+1"|bc)
crf=$(echo "34-($reso+100)/500"|bc)
quality=good

#"1"似乎为特例
if [ "$coursemode" = "1" ];then
crf=$(echo "35-($reso+100)/500"|bc)
quality=realtime
fi
thread=$(echo "($tile+1)^2"|bc)


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
ofile=$(echo "$ofile"|sed -e "s#${soupath}#${despath}#")

isize=$(ls -lha "$ifile" | awk '{ print $5 }')

echo "$(date) 输入文件：$ifile \n 大小:$isize speed:$speed thread:$thread tile:$tile reso:$reso crf:$crf \n 预计输出文件:  $ofile：时长$dhour:$dmin:$dsec； 长$height；  解析度$reso；  宽：$width "|tee -a out.txt

if [ -f $ofile ]; then 
osize=$(ls -lha "$ofile" | awk '{ print $5 }')
#tee自动换行
echo "$ofile 文件已存在，大小 $osize 。跳过。 \n\n "|tee -a out.txt
continue
fi 

#关闭标准输入
#ffmpeg  -i  "$ifile" -c:v  hevc -crf $crf -c:a copy -preset slow 



#ffmpeg -i "$ifile"   -tile-columns $tile -threads $thread -quality good  -b:v 0 -crf $crf -c:v libvpx-vp9 -c:a libopus temp.mkv < /dev/null >>out.txt
#204075kB time=00:48:00.81 bitrate= 580.3kbits/s speed=0.323x


ffmpeg -fflags discardcorrupt   -fflags fastseek     -err_detect bitstream   -y -hide_banner -hwaccel auto  -i "$ifile" -c:v libvpx-vp9 -pass 1 -b:v 0  -async 1 -vsync 1 -crf $crf -threads $thread  -quality $quality  -speed  4 -tile-columns $tile -frame-parallel 1 -an -r $fps -vf scale=${width}:${height} -f webm /dev/null  < /dev/null 
ffmpeg -fflags discardcorrupt   -fflags fastseek     -err_detect bitstream   -y -hide_banner  -hwaccel auto    -i "$ifile"  -c:v libvpx-vp9 -pass 2 -b:v 0  -async 1 -vsync 1 -crf $crf -threads $thread  -quality $quality -speed  $speed -tile-columns $tile -frame-parallel 1 -auto-alt-ref 1   -c:a libopus -b:a 64k -r $fps  -vf scale=${width}:${height}   temp.mkv < /dev/null



#sed 's/, //' reso.txt 





width=$(ffprobe  -hide_banner -show_streams -print_format json temp.mkv  |jq  '.streams[0].width');
if [ $width = "null" ];then
width=$(ffprobe  -hide_banner -show_streams -print_format json temp.mkv  |jq  '.streams[1].width');
fi
if [ $width = "null" ];then
echo " $ifile 文件已损坏 。跳过。 \n\n "|tee -a out.txt
continue;
fi
mv temp.mkv $ofile 
osize=$(ls -lha "$ofile" | awk '{ print $5 }')

echo  "$(date) $ifile 转换完成。 $ofile 已输出,大小 $osize 。\n\n "|tee -a out.txt

#$(grep -oh ', [[:digit:]]*x[[:digit:]]* \[' ffmpeg.txt) > cut -d ' ' 

#不知为何无效grep -eh ', [[:digit:]]+x[[:digit:]+ \['  ffmpeg.txt
#echo " ${#foo}"

 #grep 2017 ffmpeg.txt
 #grep 2017 $(ffmpeg -i $ifile)
done <  in.txt

rm -rf temp.mkv ffmpeg.txt
exit 0