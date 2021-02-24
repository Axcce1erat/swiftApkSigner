#!/bin/zsh
#Axel Schwarz, Deutsche Telekom AG, IHUP, ver. 1.1

# Definition of subfolder for signing assets
sigPath="./keystore/"

nameKeystore=$1
passFile=$2
valueSigningScheme=$3
nameApk=$4

sumStartVar=4

startArguments="keystore, pass.txt, Signing Scheme, apk"

##check for starting parameters
if [ $# -eq $sumStartVar ]
	then
		echo -e
  		echo -e "> execution of $(basename $0) with $startArguments\n"
  	else
  		echo "How to use this script scriptName.sh [keystore][pass.txt][signing Scheme digit][apk]"
  		exit
fi
##check if start files are present
if [ -e "$sigPath"$nameKeystore ]
	then
  		echo -e "> keystore $1 found.\n"
	else
  		echo -e "keystore $1 not found!\n"
  		exit
fi
if [ -e "$sigPath"$passFile ]
	then
  		echo -e "> keystore password $2 found.\n"
	else
  		echo -e "keystore password $2 not found!\n"
  		exit
fi
if [ $valueSigningScheme -le 4 -a $valueSigningScheme -ge 1 ]
	then
  		echo -e "> signing scheme till v$3.\n"
	else
  		echo -e "please use the correct signing scheme digit V1-4!\n"
  		exit
fi
if [ -e $nameApk ]
	then
  		echo -e "> Apk file $4 found.\n"
	else
  		echo -e "Apk File $4 not found!\n"
  		exit
fi

baseNameApk="$(basename "$nameApk" | sed 's/\(.*\)\..*/\1/')"

echo "> zipalin_start"
echo -e

zipalign -v -p 4 $nameApk $baseNameApk"_aligned.apk" > /dev/null

if [ $? -eq 0 ]
	then
  		echo "> zipalin_end"
		echo -e
	else
  		echo "> zipalin_FAILED"
  		echo -e
  		echo "> zipalin_start_again"
		mv $baseNameApk"_aligned.apk" temp.apk
		zipalign -v -p 4 temp.apk $baseNameApk"_aligned.apk" > /dev/null
		rm temp.apk
		echo -e
		echo "> zipalin_successful"
		echo -e
fi

nameApkAligned=$baseNameApk"_aligned.apk"
baseNameApkAligned="$(basename "$nameApkAligned" | sed 's/\(.*\)\..*/\1/')"

#setting the value for the singing scheme for apksinger
[ $valueSigningScheme -eq 1 ] && v1="true" && v2="false" && v3="false" && v4="false"
[ $valueSigningScheme -eq 2 ] && v1="true" && v2="true" && v3="false" && v4="false"
[ $valueSigningScheme -eq 3 ] && v1="true" && v2="true" && v3="true" && v4="false"
[ $valueSigningScheme -eq 4 ] && v1="true" && v2="true" && v3="true" && v4="true"
	
echo "> apksigner_start"
echo -e

apksigner sign -v --out $baseNameApkAligned"_signed.apk" --ks "$sigPath"$nameKeystore --ks-pass file:"$sigPath"$passFile --v1-signing-enabled $v1 --v2-signing-enabled $v2 --v3-signing-enabled $v3 --v4-signing-enabled $v4 $nameApkAligned

if [ $? -eq 0 ]
	then
		echo -e
		echo "> apk Signed"
		echo -e
	else
		echo "> keystore password was incorrect, please check it!"
		rm $nameApkAligned
		exit
fi

nameApkAlignedSigned=$baseNameApkAligned"_signed.apk"

echo "---------------------signature_start-------------------------"
echo -e

apksigner verify --verbose --print-certs $nameApkAlignedSigned | grep -i -v "Warning"

echo "--------------------------signature_end------------------------------"
echo -e

echo "--------------------------details_adroid_manifest_start------------------------------"
echo -e

aapt dump badging $nameApkAlignedSigned | grep 'package\|sdkVersion\|targetSdkVersion\|uses-implied-permission: name='android.permission.READ_EXTERNAL_STORAGE'\|feature-group\|uses-gl-es\|uses-feature-not-required\|uses-feature\|uses-implied-feature' | sed 's/\(^.*\) compileSdkVersionCodename.*/\1/'

#In text datei apk_parameter.txt
aapt dump badging $nameApkAlignedSigned | grep 'package\|sdkVersion\|targetSdkVersion' | sed 's/\(^.*\) compileSdkVersionCodename.*/\1/' > apk_parameter.txt

echo "--------------------------details_adroid_manifest_end------------------------------"
echo -e
echo "----------------all_Done--------------------"