#!/usr/bin/env bash
#Script: sphere.sh
#!/usr/bin/env bash
PI=314
NUM_DECIMALS=2
RADIUS=2
printf "The volume of a sphere with radius $RADIUS is %.3f\n" "$((10**$NUM_DECIMALS * $PI * $RADIUS**3 * 4 / 3))e-$(($NUM_DECIMALS*2))"

