#!/bin/bash
protofiles=`ls | grep [.]proto`
rm -rf *.pb
for f in ${protofiles[*]}
do
	chmod u+x ./protoc
	./protoc $f -o ${f/".proto"/".pb"}
	echo " generate" ${f/".proto"/".pb"} done !
done
