$fn=100;

thickness = 2.5;
holeX = 15.5;
holeY = 21.5;
nemaFace=42.3;
faceAdditionalHeight = 10;
faceHeight=nemaFace + faceAdditionalHeight;
faceAdditionalWidth = thickness * 2;
faceWidth = nemaFace + faceAdditionalWidth * 2;
extraBaseWidth=14;
extraBaseHeight = 10;
baseWidth = nemaFace + extraBaseWidth + thickness + faceAdditionalWidth;
baseHeight = nemaFace + faceAdditionalHeight + extraBaseHeight + thickness;

difference() {
    union() {
        translate([-thickness, thickness + faceAdditionalHeight, 0]) Nema17MountingPlate(thickness, faceAdditionalWidth * 2);
        translate([-thickness, thickness, 0]) cube([faceWidth, faceAdditionalHeight, thickness]);
        rotate([0, 90, 0]) {
            translate([-faceHeight -thickness, thickness, -thickness])
                    triangle(nemaFace + faceAdditionalHeight, thickness=thickness);
            translate([-faceHeight - thickness, thickness, faceWidth - thickness * 2])
                    triangle(nemaFace + faceAdditionalHeight, thickness=thickness);
        }
        color("blue", 1.0)
            translate([-extraBaseWidth, 0, -extraBaseHeight])
                difference() {
                    cube([baseWidth, thickness, baseHeight]);
                    translate([baseWidth - subtractHeightOffset(extraBaseHeight * 2), subtractHeightOffset(0), subtractHeightOffset(0)])
                        cube([extraBaseHeight * 2 - subtractOffset, addSubtractHeight(thickness), extraBaseHeight - subtractOffset]);
                }
        
    };

    rotate([-90, 0, 0]) {
        translate([-8, -10, -1]) {
            translate([holeX, 0, 0]) cylinder(d=3.2, h=5);
            translate([0, -holeY, 0]) cylinder(d=3.2, h=5);
        }
    };
}

module Nema17MountingPlate(thickness, widthExtension=0, heightExtension=0) {
    width = nemaFace + widthExtension;
    height = nemaFace + heightExtension;
    holeSpacing=31;

    faceCenterWidth = width/2;
    holeSpaceFromCenter = holeSpacing/2;

    center = [width/2, height/2, subtractHeightOffset(0)];
    offset = [holeSpaceFromCenter, holeSpaceFromCenter, 0];

    corners = [
        [-1, -1, 1],
        [-1, 1, 1],
        [1, 1, 1],
        [1, -1, 1]
    ];

    difference() {
        cube([width, height, thickness]);

        for (corner = corners) {
            translation = center + [offset.x * corner.x, offset.y * corner.y, offset.z * corner.z];
            translate(translation) cylinder(d=3.2, h=addSubtractHeight(thickness));
        }
        
        translate(center) cylinder(d=24, h=addSubtractHeight(thickness));
    }
}

module triangle(width, height=undef, thickness) {
    height = height == undef ? width : height;
    linear_extrude(height=thickness) polygon(points=[[0, 0], [width, 0], [width, height]]);
}

subtractOffset = -0.1;
subtractHeightAddition = subtractOffset * -2;

function subtractHeightOffset(distance) = distance + subtractOffset;
function addSubtractHeight(distance) = distance + subtractHeightAddition;