#!/bin/bash

readonly wal_filename=$1
readonly wal_destination=$2

[[ -z $wal_filename || -z $wal_destination ]] && exit 1

readonly wal_dir=$(dirname $wal_destination)
readonly wal_fast_source=$(dirname $(dirname $(realpath $wal_dir)))/wal_fast/$wal_filename
readonly wale_prefetch_source=${wal_dir}/.wal-e/prefetch/${wal_filename}

if [[ -f $wal_fast_source ]]; then
    exec mv "${wal_fast_source}" "${wal_destination}"
elif [[ -f $wale_prefetch_source ]]; then
    exec mv "${wale_prefetch_source}" "${wal_destination}"
else
    exec wal-e --aws-instance-profile wal-fetch "${wal_filename}" "${wal_destination}"
fi
