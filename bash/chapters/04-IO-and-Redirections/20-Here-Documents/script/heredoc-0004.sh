#!/usr/bin/env bash
#Script: heredoc-0004.sh
read -p "Introduce the radius of the circle: " RADIUS
echo "Radius: $RADIUS"
python <<EOF
		import math
		radius=$RADIUS
		area=math.pi*(radius**2)
		print("Area: ", area)
EOF
