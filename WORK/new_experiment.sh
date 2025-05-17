#!/usr/bin/env bash
name="default"

while getopts ":n:" opt; do
  case $opt in
    n)
      name=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

mkdir $name
cp $FAST/template/submit.sh $name
cp $FAST/template/config.yml $name

cd $name

mkdir data/


