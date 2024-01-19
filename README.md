# swift-proj
Swift library for coordinate systems transformations

port of https://github.com/NetTopologySuite/ProjNet4GeoAPI

## Installation

### Swift Package Manager
The Swift Package Manager is a dependency manager integrated with the Swift build system. To learn how to use the Swift Package Manager for your project, please read the [official documentation](https://github.com/apple/swift-package-manager/blob/master/Documentation/Usage.md).  
To add swift-proj as a dependency, you have to add it to the `dependencies` of your `Package.swift` file and refer to that dependency in your `target`.

```swift
// swift-tools-version:5.9
import PackageDescription
let package = Package(
    name: "<Your Product Name>",
    dependencies: [
		.package(url: "https://github.com/jajco84/swift-proj.git", from: "0.1.0"))
    ],
    targets: [
        .target(
		name: "<Your Target Name>",
		dependencies: ["SwiftProjection"]),
    ]
)
```

## Usage

```swift
import SwiftProjection

private let csWGS84Definition = "GEOGCS[\"WGS 84\",DATUM[\"WGS_1984\",SPHEROID[\"WGS 84\",6378137,298.257223563,AUTHORITY[\"EPSG\",\"7030\"]],AUTHORITY[\"EPSG\",\"6326\"]],PRIMEM[\"Greenwich\",0,AUTHORITY[\"EPSG\",\"8901\"]],UNIT[\"degree\",0.01745329251994328,AUTHORITY[\"EPSG\",\"9122\"]],AUTHORITY[\"EPSG\",\"4326\"]]"

private let csKrovakDefinition = "PROJCS[\"S-JTSK (Greenwich) / Krovak\",GEOGCS[\"S-JTSK (Greenwich)\",DATUM[\"S_JTSK_Greenwich\",SPHEROID[\"Bessel 1841\",6377397.155,299.1528128,AUTHORITY[\"EPSG\",\"7004\"]],TOWGS84[570.8,85.7,462.8,4.998,1.587,5.261,3.56],AUTHORITY[\"EPSG\",\"6818\"]],PRIMEM[\"Greenwich\",0,AUTHORITY[\"EPSG\",\"8901\"]],UNIT[\"degree\",0.0174532925199432958,AUTHORITY[\"EPSG\",\"9122\"]],AUTHORITY[\"EPSG\",\"4818\"]],PROJECTION[\"Krovak\"],PARAMETER[\"latitude_of_center\",49.5],PARAMETER[\"longitude_of_center\",24.83333333333333],PARAMETER[\"X_Scale\",-1],PARAMETER[\"Y_Scale\",1],PARAMETER[\"XY_Plane_Rotation\",90],PARAMETER[\"azimuth\",30.28813975277778],PARAMETER[\"pseudo_standard_parallel_1\",78.5],PARAMETER[\"scale_factor\",0.9999],PARAMETER[\"false_easting\",0],PARAMETER[\"false_northing\",0],UNIT[\"metre\",1,AUTHORITY[\"EPSG\",\"9001\"]],AUTHORITY[\"EPSG\",\"102067\"]]"
    
// Brno, Czech Republic, location
private let pointBrnoLatitude = 49.195061
private let pointBrnoLongitude = 16.606836

guard let csWGS84 = CoordinateSystemWktReader.parse(wkt: csWGS84Definition) as? ICoordinateSystem,
      let csKrovak = CoordinateSystemWktReader.parse(wkt: csKrovakDefinition) as? ICoordinateSystem
else {
    fatalError("Failed to create test coordinate systems!")
}

let ctf: CoordinateTransformationFactory = CoordinateTransformationFactory()
guard let transformation = ctf.createFromCoordinateSystems(sourceCS: csWGS84, csKrovak) else {
    fatalError("Failed to create transformation from coordinate systems!")
}

let transformedPoints = transformation.getMathTransform().transform(point: [pointBrnoLatitude, pointBrnoLongitude])
```
