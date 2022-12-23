#!/bin/bash

mkdir -p verdi
DUMP=$PWD/sim/dump.fsdb
cd verdi && $VERDI_HOME/bin/verdi -ssf $DUMP 
