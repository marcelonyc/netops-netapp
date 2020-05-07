#! /bin/bash
export NOTINSTALLED=0
for mod in mlrun v3io-generator pyarrow  pandas pytimeparse  
do
	pip list | grep $mod > /dev/null 2>&1
	if [ $? -ne 0 ]
	then
		echo  $mod
		export NOTINSTALLED=1
        fi
done
if [ ${NOTINSTALLED} -ne 0 ]
then
	pip install pyarrow
	pip install pyyaml --upgrade
	pip install pandas
	pip install pytimeparse
	
	# Igz DB
	pip install v3io_frames --upgrade
	
	# Function
	pip install -i https://test.pypi.org/simple/ v3io-generator
	pip install faker
fi
