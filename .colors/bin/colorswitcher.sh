#!/bin/bash

####
# Show Listing of installed themefiles
####

schemes="${HOME}/.colors/schemes"
template="${HOME}/.colors/template"
template_file='.Xdefaults'

if [[ $1 != "" ]] ; then
	template_file=$1
fi

cls=`ls ${schemes} | grep ".cls" | tr -d "\n" | sed "s/cls/cls /g" | sed "s/s $/s/g"`

inidex="0"

for colors in `echo $cls` ; do
	let index=$index+1
	colorname=`head -n1 ${schemes}/${colors} | cut -c 3-`
	echo -e "${index}\t\t${colorname}"
done

####
# Abfrage, welches Theme eingesetzt werden soll
####
echo  "Chose the desired colourscheme [1]:"
schemecount=`echo ${cls} | wc -w`
while read -r -e  answer ; do
	if [[ $answer == "" ]] ; then
		answer=1
	fi
	if [[ $answer -gt ${schemecount} ]] ; then
		echo "Please chose an available colourscheme."
	else
		chosen=`echo ${cls} | cut -f${answer} -d" "`
		break
	fi
done

####
# .Xdefaults-File creation
####

cat ${template}/${template_file} ${schemes}/${chosen} > /tmp/${template_file}
sed -i 's/^#?.*$//g' /tmp/${template_file}

####
# Filecopy
####
cp /tmp/${template_file} ${HOME}

####
# xrdb merge
####

xrdb ${HOME}/.Xdefaults
