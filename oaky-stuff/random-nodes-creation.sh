#!/bin/bash
set -e

AUTHORS=(mickey goofy minnie donald Woody BuzzLightyear SlinkyDog Hamm Rex MrPotatoHead MrsPotatoHead LittleGreenMen BoPeep Jessie Bullseye AndyDavis SidPhillips StinkyPete EmperorZurg Robot Wheezy LittleGreenMen LotsoHugginBear BigBaby Ken BonnieAnderson Barbie Flik Atta Dot Francis Heimlich Slim Manny Gypsy Hopper Queen Dim Rosie TuckandRoll PTFlea Molt Thumper JamesPSullivan MikeWazowski Boo Randall Fungus HenryJWaternooseIII Roz CDA CeliaMae NeedlemanandSmitty Yeti GeorgeSanderson)
ELEMS=${#AUTHORS[*]}
tot=10

if [ ! -z "$1" ] 
then
	tot=$1
fi

for i in `seq 1 $tot`
do
	dt=`date -j -f "%Y-%m-%d" "$((RANDOM%12+2010))-$((RANDOM%12+1))-$((RANDOM%28+1))" "+%Y-%m-%d %H:%M:%S"`
	ms=`date +%s`
	nodename="${ms}-${RANDOM}"
	pos=$((RANDOM%${ELEMS}))
	author=${AUTHORS[${pos}]}
	
    json="{\"jcr:primaryType\":\"oak:Unstructured\",\"jcr:lastModified\":\"${dt}\",\"author\":\"${author}\"}"
    echo "posting json: $json"
	curl -u admin:admin -H "Content-Type: application/json" -X POST -d "${json}" http://localhost:8080/content/$nodename
done
