/// Builds up complex objects from simpler objects or values.
/// ICoordinateSystemFactory allows applications to make coordinate systems that
/// cannot be created by a
/// {ICoordinateSystemAuthorityFactory}
/// . This factory is very
/// flexible, whereas the authority factory is easier to use.So
/// {ICoordinateSystemAuthorityFactory}
/// can be used to make 'standard' coordinate
/// systems, and
/// {@link #CoordinateSystemFactory}
/// can be used to make 'special'
/// coordinate systems.For example, the EPSG authority has codes for USA state plane coordinate systems
/// using the NAD83 datum, but these coordinate systems always use meters. EPSG does not
/// have codes for NAD83 state plane coordinate systems that use feet units. This factory
/// lets an application create such a hybrid coordinate system.
public class CoordinateSystemFactory: ICoordinateSystemFactory {
    //  private Encoding __Encoding = new Encoding();
    // public Encoding getEncoding() {
    //    return __Encoding;
    // }
    // public void setEncoding(Encoding value) {
    //    __Encoding = value;
    // }
    /**
     * Instantiates a new Coordinate system factory.
     *
     * @throws Exception the exception
     */
    public init() {
    }
    /*public CoordinateSystemFactory(Encoding encoding) throws Exception {
     if (encoding == null)
     throw new ArgumentNullException("encoding");

     setEncoding(encoding);
     }*/
    /**
     * Creates a spatial reference object given its Well-known text representation.
     * The output object may be either a
     * IGeographicCoordinateSystem
     * or
     * a
     * IProjectedCoordinateSystem
     * .
     *
     * @param WKT The Well-known text representation for the spatial reference
     * @return The resulting spatial reference object
     */
    public func createFromWkt(WKT: String) -> ICoordinateSystem? {
        guard let info: IInfo = CoordinateSystemWktReader.parse(wkt: WKT) else { return nil }
        return info as? ICoordinateSystem
    }
    /**
     * Creates a
     * {ICompoundCoordinateSystem}
     * [NOT IMPLEMENTED].
     *
     * @param name Name of compound coordinate system.
     * @param head Head coordinate system
     * @param tail Tail coordinate system
     * @return Compound coordinate system
     */
    public func createCompoundCoordinateSystem(name: String, _ head: ICoordinateSystem, _ tail: ICoordinateSystem) -> ICompoundCoordinateSystem? { return nil }
    /**
     * Creates a
     * {IFittedCoordinateSystem}
     * .
     * The units of the axes in the fitted coordinate system will be
     * inferred from the units of the base coordinate system. If the affine map
     * performs a rotation, then any mixed axes must have identical units. For
     * example, a (lat_deg,lon_deg,height_feet) system can be rotated in the
     * (lat,lon) plane, since both affected axes are in degrees. But you
     * should not rotate this coordinate system in any other plane.
     *
     * @param name                 Name of coordinate system
     * @param baseCoordinateSystem Base coordinate system
     * @param toBaseWkt
     * @param arAxes
     * @return Fitted coordinate system
     */
    public func createFittedCoordinateSystem(name: String, _ baseCoordinateSystem: ICoordinateSystem, _ toBaseWkt: String, _ arAxes: [AxisInfo]) -> IFittedCoordinateSystem? { return nil }
    /**
     * Creates a
     * {ILocalCoordinateSystem}
     * .
     *
     * The dimension of the local coordinate system is determined by the size of
     * the axis array. All the axes will have the same units. If you want to make
     * a coordinate system with mixed units, then you can make a compound
     * coordinate system from different local coordinate systems.
     *
     * @param name  Name of local coordinate system
     * @param datum Local datum
     * @param unit  Units
     * @param axes  Axis info
     * @return Local coordinate system
     */
    public func createLocalCoordinateSystem(name: String, _ datum: ILocalDatum, _ unit: IUnit, _ axes: [AxisInfo]) -> ILocalCoordinateSystem? { return nil }
    /**
     * Creates an
     * {Ellipsoid}
     * from radius values.
     *
     * CreateFlattenedSphere
     *
     * @param name          Name of ellipsoid
     * @param semiMajorAxis
     * @param semiMinorAxis
     * @param linearUnit
     * @return Ellipsoid
     */
    public func createEllipsoid(name: String, _ semiMajorAxis: Double, _ semiMinorAxis: Double, _ linearUnit: ILinearUnit) -> IEllipsoid? {
        var ivf: Double = 0
        if semiMajorAxis != semiMinorAxis { ivf = semiMajorAxis / (semiMajorAxis - semiMinorAxis) }
        return Ellipsoid(semiMajorAxis, semiMinorAxis, ivf, false, linearUnit, name, "", -1, "", "", "")
    }
    /**
     * Creates an
     * {Ellipsoid}
     * from an major radius, and inverse flattening.
     *
     * CreateEllipsoid
     *
     * @param name              Name of ellipsoid
     * @param semiMajorAxis     Semi major-axis
     * @param inverseFlattening Inverse flattening
     * @param linearUnit        Linear unit
     * @return Ellipsoid
     */
    public func createFlattenedSphere(name: String, _ semiMajorAxis: Double, _ inverseFlattening: Double, _ linearUnit: ILinearUnit) -> IEllipsoid? {
        if name.isEmpty { return nil }
        return Ellipsoid(semiMajorAxis, -1, inverseFlattening, true, linearUnit, name, "", -1, "", "", "")
    }
    /**
     * Creates a
     * {ProjectedCoordinateSystem}
     * using a projection object.
     *
     * @param name       Name of projected coordinate system
     * @param gcs        Geographic coordinate system
     * @param projection Projection
     * @param linearUnit Linear unit
     * @param axis0      Primary axis
     * @param axis1      Secondary axis
     * @return Projected coordinate system
     */
    public func createProjectedCoordinateSystem(name: String, _ gcs: IGeographicCoordinateSystem, _ projection: IProjection, _ linearUnit: ILinearUnit, _ axis0: AxisInfo, _ axis1: AxisInfo) -> IProjectedCoordinateSystem? {
        if name.isEmpty { return nil }
        var info: [AxisInfo] = [AxisInfo]()
        info.append(axis0)
        info.append(axis1)
        return ProjectedCoordinateSystem(nil, gcs, linearUnit, projection, info, name, "", -1, "", "", "")
    }
    /**
     * Creates a
     * {Projection}
     * .
     *
     * @param name               Name of projection
     * @param wktProjectionClass Projection class
     * @param parameters         Projection parameters
     * @return Projection
     */
    public func createProjection(name: String, _ wktProjectionClass: String, _ parameters: [ProjectionParameter]) -> IProjection? {
        if name.isEmpty {
            return nil
        }
        if parameters.isEmpty { return nil }
        return Projection(wktProjectionClass, parameters, name, "", -1, "", "", "")
    }
    /**
     * Creates
     * HorizontalDatum
     * from ellipsoid and Bursa-World parameters.
     *
     * since this method contains a set of Bursa-Wolf parameters, the created
     * datum will always have a relationship to WGS84. If you wish to create a
     * horizontal datum that has no relationship with WGS84, then you can
     * either specify a
     * {DatumType}
     * of
     * {DatumType.HD_Other}
     * , or create it via WKT.
     *
     * @param name      Name of ellipsoid
     * @param datumType Type of datum
     * @param ellipsoid Ellipsoid
     * @param toWgs84   Wgs84 conversion parameters
     * @return Horizontal datum
     */
    public func createHorizontalDatum(name: String, _ datumType: DatumType, _ ellipsoid: IEllipsoid, _ toWgs84: Wgs84ConversionInfo) -> IHorizontalDatum? {
        if name.isEmpty { return nil }
        return HorizontalDatum(ellipsoid, toWgs84, datumType, name, "", -1, "", "", "")
    }
    /**
     * Creates a
     * {PrimeMeridian}
     * , relative to Greenwich.
     *
     * @param name        Name of prime meridian
     * @param angularUnit Angular unit
     * @param longitude   Longitude
     * @return Prime meridian
     */
    public func createPrimeMeridian(name: String, _ angularUnit: IAngularUnit, _ longitude: Double) -> IPrimeMeridian? {
        if name.isEmpty {
            return nil
        }
        return PrimeMeridian(longitude, angularUnit, name, "", -1, "", "", "")
    }
    /**
     * Creates a
     * {GeographicCoordinateSystem}
     * , which could be Lat/Lon or Lon/Lat.
     *
     * @param name          Name of geographical coordinate system
     * @param angularUnit   Angular units
     * @param datum         Horizontal datum
     * @param primeMeridian Prime meridian
     * @param axis0         First axis
     * @param axis1         Second axis
     * @return Geographic coordinate system
     */
    public func createGeographicCoordinateSystem(name: String, _ angularUnit: IAngularUnit, _ datum: IHorizontalDatum, _ primeMeridian: IPrimeMeridian, _ axis0: AxisInfo, _ axis1: AxisInfo) -> IGeographicCoordinateSystem? {
        if name.isEmpty { return nil }
        var info: [AxisInfo] = [AxisInfo]()
        info.append(axis0)
        info.append(axis1)
        return GeographicCoordinateSystem(angularUnit, datum, primeMeridian, info, name, "", -1, "", "", "")
    }
    /**
     * Creates a
     * {ILocalDatum}
     * .
     *
     * @param name      Name of datum
     * @param datumType Datum type
     * @return
     */
    public func createLocalDatum(name: String, _ datumType: DatumType) -> ILocalDatum? { return nil }
    /**
     * Creates a
     * {IVerticalDatum}
     * from an enumerated type value.
     *
     * @param name      Name of datum
     * @param datumType Type of datum
     * @return Vertical datum
     */
    public func createVerticalDatum(name: String, _ datumType: DatumType) -> IVerticalDatum? { return nil }
    /**
     * Creates a
     * {IVerticalCoordinateSystem}
     * from a
     * {IVerticalDatum}
     * and
     * {LinearUnit}
     * .
     *
     * @param name         Name of vertical coordinate system
     * @param datum Vertical datum
     * @param verticalUnit Unit
     * @param axis         Axis info
     * @return Vertical coordinate system
     */
    public func createVerticalCoordinateSystem(name: String, _ datum: IVerticalDatum, _ verticalUnit: ILinearUnit, _ axis: AxisInfo) -> IVerticalCoordinateSystem? { return nil }
    /**
     * Creates a
     * {CreateGeocentricCoordinateSystem}
     * from a
     * {IHorizontalDatum}
     * ,
     * <p>
     * {ILinearUnit}
     * and
     * {IPrimeMeridian}
     * .
     *
     * @param name          Name of geocentric coordinate system
     * @param datum         Horizontal datum
     * @param linearUnit    Linear unit
     * @param primeMeridian Prime meridian
     * @return Geocentric Coordinate System
     * @throws Exception the exception
     */
    public func createGeocentricCoordinateSystem(name: String, _ datum: IHorizontalDatum, _ linearUnit: ILinearUnit, _ primeMeridian: IPrimeMeridian) -> IGeocentricCoordinateSystem? {
        if name == "" { return nil }
        var info: [AxisInfo] = [AxisInfo]()
        info.append(AxisInfo("X", AxisOrientationEnum.Other))
        info.append(AxisInfo("Y", AxisOrientationEnum.Other))
        info.append(AxisInfo("Z", AxisOrientationEnum.Other))
        return GeocentricCoordinateSystem(datum, linearUnit, primeMeridian, info, name, "", -1, "", "", "")
    }
}
