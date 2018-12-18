#!/bin/bash

create_kernel_tags(){

	#WARNNING: $1 here is NULL, so don't use "cd $ANDROID_BUILD_TOP/$1"
	#cd $ANDROID_BUILD_TOP/$1
	
	rm -f cscope.out cscope.po.out  cscope.in.out  cscope.files tags 
	
	OBJ_KERNEL_DIR=$ANDROID_PRODUCT_OUT/obj/KERNEL
	
	if [ ! -d $OBJ_KERNEL_DIR ]
	then
		echo "$OBJ_KERNEL_DIR is not exist ! Please build your kernel first !"
		exit
	fi
	
	DEP_FILES=$(find $OBJ_KERNEL_DIR -name "*.o.cmd" | sed '/built-in/d')
	#echo "$DEP_FILES" > dep.files
	
	cat /dev/null > tmp.files
	
	for file in $DEP_FILES
	do 
		cat $file | sed '1d;2d;4d;/deps_/d;/wildcard/d;s/:=/\n/g' | sed '/\.o/d;s/ \\//g;/^$/d;s/^ *//g' >> tmp.files
	done
	
	SRC_FILES=$(cat tmp.files | sort | uniq | sed '/^\/usr/d')
	#echo "$SRC_FILES" > cscope.files
	
	#使用readlink命令将所有文件转换为绝对路径
	cat /dev/null > tmp.files
	
	for file in $SRC_FILES
	do
		if [ -f $file ]
		then
			readlink -f $file >> tmp.files
		fi
	done
	
	#重新排序并删除重复的文件，并最终全部转换为相对路径
	cat tmp.files | sort | uniq | sed "s#$PWD/##g" > cscope.files
	
	#创建cscope标签和ctags标签
	cscope -bkq -i cscope.files
	ctags -L cscope.files
	
	rm -f tmp.files
}

create_uboot_tags(){

	#cd $ANDROID_BUILD_TOP/u-boot15
	
	rm -f cscope.out cscope.po.out  cscope.in.out  cscope.files   
	
	OBJ_UBOOT_DIR=$ANDROID_PRODUCT_OUT/obj/u-boot15
	
	if [ ! -d $OBJ_UBOOT_DIR ]
	then
		echo "$OBJ_UBOOT_DIR is not exist ! Please build your uboot first !"
		exit
	fi
	
	OBJ_FILES=$(find $OBJ_UBOOT_DIR -name "*.o" | sed "s#$OBJ_UBOOT_DIR/##g")
	
	C_FILES=$(echo $OBJ_FILES | sed 's/\.o/\.c/g')
	S_FILES=$(echo $OBJ_FILES | sed 's/\.o/\.S/g')
	#echo $C_FILES
	#echo $S_FILES
	
	cat /dev/null > src.files
	cat /dev/null > h.files
	cat /dev/null > tmp.files
	
	for file in $C_FILES $S_FILES
	do 
		if [ -f $file ]
		then
			echo $file >> tmp.files
		fi
	done
	
	cat tmp.files | sort > src.files
	
	H_FILES=$(cat src.files)
	
	
	
	cat /dev/null > tmp.files
	
	for file in $H_FILES
	do
		gcc -MM -DCONFIG_ARM -D__ARM__ -I$OBJ_UBOOT_DIR/include  -I$PWD/include  -I$PWD/arch/arm/include -MQ target.o $file >> tmp.files
	done
	
	#删除行尾' \'
	sed -i 's/ \\//g' tmp.files
	
	#删除行首空格
	sed -i 's/^ //g' tmp.files
	
	#删除包含“target.o”字符串的行
	sed -i '/target\.o/d' tmp.files
	
	#同一行有多个文件的，需要拆分成多行
	sed -i 's/ /\n/g' tmp.files
	
	#使用readlink命令将所有文件转换为绝对路径
	TMP_FILES=$(cat tmp.files | sort | uniq)
	
	cat /dev/null > tmp.files
	
	for file in $TMP_FILES
	do
		readlink -f $file >> tmp.files
	done
	
	#重新排序并删除重复的头文件
	cat tmp.files | sort | uniq > h.files
	
	#将h.files和src.files合并到cscope.files中，并转换成相对路径
	cat src.files h.files | sort | uniq | sed "s#$PWD/##g" > cscope.files 
	
	#创建cscope标签和ctags标签
	cscope -bkq -i cscope.files
	ctags -L cscope.files
	
	rm -f src.files h.files tmp.files
}


if [ -z $ANDROID_PRODUCT_OUT ]
then
	echo Please source Android environment path first !
	exit
fi

if [ $# = 0 ]
then
	echo Please input parameter use following format:
	echo 'maketags source_directory'
	exit
fi 


if [ ! -d $1 ]
then
	echo "error: $1 directory was not found!"
	exit
fi

# enter into subdirectory
cd $1

# then make tags
if [[ $1 = kernel* ]];then
	create_kernel_tags
elif [[ $1 = uboot* ]];then
	create_uboot_tags
else
	echo not support parameter: $1
	exit
fi
exit




