#!/bin/bash

[ $# -lt 3 ] && echo Parametros insuficientes && exit 1

currentLocation=$(pwd)
[ -d $1 ] && destinationPath=$1 || { echo La ruta $1 no es valida; exit 1; }
[ -f $2 ] && dataBase=$(cat $2) || { echo El archivo en la ruta $2 no existe; exit 1; }
years=${@:3}

cd $destinationPath
for year in $years; do
	[[ $year -le $(date +%Y) ]] && { cd $1; mkdir $year; } || { echo Fecha sin formato AAAA o mayor a la fecha actual; exit 1; }
	cd $year
	yearDirectory=${year:2:2}

	for numAccount in $dataBase; do
		numAccountYear=${numAccount:1:2}
		[ ! ${numAccount:0:1} -eq 3 ] && middleSchool=$((numAccountYear + 3)) 

		if [[ (($numAccountYear -eq $yearDirectory) && (${numAccount:0:1} -eq 3)) || ($middleSchool -eq $yearDirectory) ]]; then 
			touch $numAccount.log
		fi

		middleSchool=
	done
	cd ..
	[ -z "$(ls -A $year)" ] && rm -R $year
done 
cd $currentLocation
