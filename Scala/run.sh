#!/bin/bash

rm -rf eu/
scalac src/*.scala -feature
scala -J-Xmx2g -J-Xms2g eu.dral.relevantie.app
