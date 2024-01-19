/// Creates coordinate transformations.
public class CoordinateTransformationFactory: ICoordinateTransformationFactory {
    public init() {
    }
    
	private class func geog2Geoc(source: IGeographicCoordinateSystem, _ target: IGeocentricCoordinateSystem) -> ICoordinateTransformation {
		let geocMathTransform: IMathTransform = createCoordinateOperation(geo: target)
		if source.getPrimeMeridian().equalParams(obj: target.getPrimeMeridian()) {
			return CoordinateTransformation(source, target, TransformType.Conversion, geocMathTransform, "", "", -1, "", "")
		} else {
			let ct: ConcatenatedTransform = ConcatenatedTransform()
			ct.appendTransformationToList(tr: CoordinateTransformation(source, target, TransformType.Transformation, PrimeMeridianTransform(source.getPrimeMeridian(), target.getPrimeMeridian()), "", "", -1, "", ""))
			ct.appendTransformationToList(tr: CoordinateTransformation(source, target, TransformType.Conversion, geocMathTransform, "", "", -1, "", ""))
			return CoordinateTransformation(source, target, TransformType.Conversion, ct, "", "", -1, "", "")
		}
	}
	// if (trans.MathTransform is ConcatenatedTransform) {
	//    List<ICoordinateTransformation> MTs = new List<ICoordinateTransformation>();
	//    SimplifyTrans(trans.MathTransform as ConcatenatedTransform, ref MTs);
	//    return new CoordinateTransformation(sourceCS,
	//        targetCS, TransformType.Transformation, new ConcatenatedTransform(MTs),
	//        "", "", -1, "", "");
	// }
	/*  private static void simplifyTrans(ConcatenatedTransform mtrans, RefSupport<List<ICoordinateTransformation>> MTs) throws Exception {
        for (Object __dummyForeachVar0 : mtrans.getCoordinateTransformationList())
        {
            ICoordinateTransformation t = (ICoordinateTransformation)__dummyForeachVar0;
            if (t instanceof ConcatenatedTransform)
            {
                RefSupport<List<ICoordinateTransformation>> refVar___0 = new RefSupport<List<ICoordinateTransformation>>(MTs.getValue());
                SimplifyTrans(t instanceof ConcatenatedTransform ? (ConcatenatedTransform)t : (ConcatenatedTransform)null, refVar___0);
                MTs.setValue(refVar___0.getValue());
            }
            else
                MTs.getValue().Add(t); 
        }
    }*/
	private class func geoc2Geog(source: IGeocentricCoordinateSystem, _ target: IGeographicCoordinateSystem) -> ICoordinateTransformation {
		let geocMathTransform: IMathTransform = createCoordinateOperation(geo: source).inverse()!
		if source.getPrimeMeridian().equalParams(obj: target.getPrimeMeridian()) {
			return CoordinateTransformation(source, target, TransformType.Conversion, geocMathTransform, "", "", -1, "", "")
		} else {
			let ct: ConcatenatedTransform = ConcatenatedTransform()
			ct.appendTransformationToList(tr: CoordinateTransformation(source, target, TransformType.Conversion, geocMathTransform, "", "", -1, "", ""))
			ct.appendTransformationToList(tr: CoordinateTransformation(source, target, TransformType.Transformation, PrimeMeridianTransform(source.getPrimeMeridian(), target.getPrimeMeridian()), "", "", -1, "", ""))
			return CoordinateTransformation(source, target, TransformType.Conversion, ct, "", "", -1, "", "")
		}
	}
	private class func proj2Proj(source: IProjectedCoordinateSystem, _ target: IProjectedCoordinateSystem) -> ICoordinateTransformation {
		let ct: ConcatenatedTransform = ConcatenatedTransform()
		let ctFac: CoordinateTransformationFactory = CoordinateTransformationFactory()
		// First transform from projection to geographic
		ct.appendTransformationToList(tr: ctFac.createFromCoordinateSystems(sourceCS: source, source.getGeographicCoordinateSystem())!)
		// Transform geographic to geographic:
		let geogToGeog: ICoordinateTransformation? = ctFac.createFromCoordinateSystems(sourceCS: source.getGeographicCoordinateSystem(), target.getGeographicCoordinateSystem())
		if geogToGeog != nil { ct.appendTransformationToList(tr: geogToGeog!) }
		// Transform to new projection
		ct.appendTransformationToList(tr: ctFac.createFromCoordinateSystems(sourceCS: target.getGeographicCoordinateSystem(), target)!)
		return CoordinateTransformation(source, target, TransformType.Transformation, ct, "", "", -1, "", "")
	}
	private class func geog2Proj(source: IGeographicCoordinateSystem, _ target: IProjectedCoordinateSystem) -> ICoordinateTransformation {
		if source.equalParams(obj: target.getGeographicCoordinateSystem()) {
			let mathTransform: IMathTransform = createCoordinateOperation(projection: target.getProjection(), target.getGeographicCoordinateSystem().getHorizontalDatum()!.getEllipsoid(), target.getLinearUnit())!
			return CoordinateTransformation(source, target, TransformType.Transformation, mathTransform, "", "", -1, "", "")
		} else {
			// Geographic coordinatesystems differ - Create concatenated transform
			let ct: ConcatenatedTransform = ConcatenatedTransform()
			let ctFac: CoordinateTransformationFactory = CoordinateTransformationFactory()
			ct.appendTransformationToList(tr: ctFac.createFromCoordinateSystems(sourceCS: source, target.getGeographicCoordinateSystem())!)
			ct.appendTransformationToList(tr: ctFac.createFromCoordinateSystems(sourceCS: target.getGeographicCoordinateSystem(), target)!)
			return CoordinateTransformation(source, target, TransformType.Transformation, ct, "", "", -1, "", "")
		}
	}
	private class func proj2Geog(source: IProjectedCoordinateSystem, _ target: IGeographicCoordinateSystem) -> ICoordinateTransformation {
		if source.getGeographicCoordinateSystem().equalParams(obj: target) {
			let mathTransform: IMathTransform = createCoordinateOperation(projection: source.getProjection(), source.getGeographicCoordinateSystem().getHorizontalDatum()!.getEllipsoid(), source.getLinearUnit())!.inverse()!
			return CoordinateTransformation(source, target, TransformType.Transformation, mathTransform, "", "", -1, "", "")
		} else {
			// Geographic coordinatesystems differ - Create concatenated transform
			let ct: ConcatenatedTransform = ConcatenatedTransform()
			let ctFac: CoordinateTransformationFactory = CoordinateTransformationFactory()
			ct.appendTransformationToList(tr: ctFac.createFromCoordinateSystems(sourceCS: source, source.getGeographicCoordinateSystem())!)
			ct.appendTransformationToList(tr: ctFac.createFromCoordinateSystems(sourceCS: source.getGeographicCoordinateSystem(), target)!)
			return CoordinateTransformation(source, target, TransformType.Transformation, ct, "", "", -1, "", "")
		}
	}
	/**
     * Geographic to geographic transformation
     * Adds a datum shift if nessesary
     *
     * @param source
     * @param target
     * @return
     */
	private class func createGeog2Geog(source: IGeographicCoordinateSystem, _ target: IGeographicCoordinateSystem) -> ICoordinateTransformation {
		if source.getHorizontalDatum()!.equalParams(obj: target.getHorizontalDatum()!) {
			return CoordinateTransformation(source, target, TransformType.Conversion, GeographicTransform(source, target), "", "", -1, "", "")
		} else {
			// No datum shift needed
			// Create datum shift
			// Convert to geocentric, perform shift and return to geographic
			let ctFac: CoordinateTransformationFactory = CoordinateTransformationFactory()
			let cFac: CoordinateSystemFactory = CoordinateSystemFactory()
			let sourceCentric: IGeocentricCoordinateSystem = cFac.createGeocentricCoordinateSystem(name: source.getHorizontalDatum()!.getName() + " Geocentric", source.getHorizontalDatum()!, LinearUnit.getMetre(), source.getPrimeMeridian())!
			let targetCentric: IGeocentricCoordinateSystem = cFac.createGeocentricCoordinateSystem(name: target.getHorizontalDatum()!.getName() + " Geocentric", target.getHorizontalDatum()!, LinearUnit.getMetre(), source.getPrimeMeridian())!
			let ct: ConcatenatedTransform = ConcatenatedTransform()
			addIfNotNull(concatTrans: ct, ctFac.createFromCoordinateSystems(sourceCS: source, sourceCentric))
			addIfNotNull(concatTrans: ct, ctFac.createFromCoordinateSystems(sourceCS: sourceCentric, targetCentric))
			addIfNotNull(concatTrans: ct, ctFac.createFromCoordinateSystems(sourceCS: targetCentric, target))
			return CoordinateTransformation(source, target, TransformType.Transformation, ct, "", "", -1, "", "")
		}
    }
    
    private class func addIfNotNull(concatTrans: ConcatenatedTransform, _ trans: ICoordinateTransformation?) {
        if trans != nil {
            concatTrans.appendTransformationToList(tr: trans!)
        }
    }
	/**
     * Geocentric to Geocentric transformation
     *
     * @param source
     * @param target
     * @return
     */
	private class func createGeoc2Geoc(source: IGeocentricCoordinateSystem, _ target: IGeocentricCoordinateSystem) -> ICoordinateTransformation? {
		let ct: ConcatenatedTransform = ConcatenatedTransform()
		// Does source has a datum different from WGS84 and is there a shift specified?
		if source.getHorizontalDatum().getWgs84Parameters() != nil && !source.getHorizontalDatum().getWgs84Parameters()!.getHasZeroValuesOnly() { ct.appendTransformationToList(tr: CoordinateTransformation(((target.getHorizontalDatum().getWgs84Parameters() == nil || target.getHorizontalDatum().getWgs84Parameters()!.getHasZeroValuesOnly()) ? target : GeocentricCoordinateSystem.getWGS84()), source, TransformType.Transformation, DatumTransform(source.getHorizontalDatum().getWgs84Parameters()!), "", "", -1, "", "")) }
		// Does target has a datum different from WGS84 and is there a shift specified?
		if target.getHorizontalDatum().getWgs84Parameters() != nil && !target.getHorizontalDatum().getWgs84Parameters()!.getHasZeroValuesOnly() { ct.appendTransformationToList(tr: CoordinateTransformation(((source.getHorizontalDatum().getWgs84Parameters() == nil || source.getHorizontalDatum().getWgs84Parameters()!.getHasZeroValuesOnly()) ? source : GeocentricCoordinateSystem.getWGS84()), target, TransformType.Transformation, (DatumTransform(target.getHorizontalDatum().getWgs84Parameters()!)).inverse(), "", "", -1, "", "")) }
		// If we don't have a transformation in this list, return null
		if ct.getCoordinateTransformationList().isEmpty { return nil }
		// If we only have one shift, lets just return the datumshift from/to wgs84
		if ct.getCoordinateTransformationList().count == 1 { return CoordinateTransformation(source, target, TransformType.ConversionAndTransformation, ct.getCoordinateTransformationList()[0].getMathTransform(), "", "", -1, "", "") }
		return CoordinateTransformation(source, target, TransformType.ConversionAndTransformation, ct, "", "", -1, "", "")
	}
	/**
     * Creates transformation from fitted coordinate system to the target one
     *
     * @param source
     * @param target
     * @return
     */
	private class func fitt2Any(source: IFittedCoordinateSystem, _ target: ICoordinateSystem) -> ICoordinateTransformation {
		// transform from fitted to base system of fitted (which is equal to target)
		let mt: IMathTransform = createFittedTransform(fittedSystem: source)!
		// case when target system is equal to base system of the fitted
		if source.getBaseCoordinateSystem().equalParams(obj: target) { return createTransform(sourceCS: source, target, TransformType.Transformation, mt) }
		// Transform form base system of fitted to target coordinate system
		// Transform form base system of fitted to target coordinate system
		let ct: ConcatenatedTransform = ConcatenatedTransform()
		ct.appendTransformationToList(tr: createTransform(sourceCS: source, source.getBaseCoordinateSystem(), TransformType.Transformation, mt))
		// Transform form base system of fitted to target coordinate system
		let ctFac: CoordinateTransformationFactory = CoordinateTransformationFactory()
		ct.appendTransformationToList(tr: ctFac.createFromCoordinateSystems(sourceCS: source.getBaseCoordinateSystem(), target)!)
		return createTransform(sourceCS: source, target, TransformType.Transformation, ct)
	}
	/**
     * Creates transformation from source coordinate system to specified target system which is the fitted one
     *
     * @param source
     * @param target
     * @return
     */
	private class func any2Fitt(source: ICoordinateSystem, _ target: IFittedCoordinateSystem) -> ICoordinateTransformation {
		// Transform form base system of fitted to target coordinate system - use invered math transform
        let invMt: IMathTransform = createFittedTransform(fittedSystem: target)!.inverse()!
		// case when source system is equal to base system of the fitted
		if target.getBaseCoordinateSystem().equalParams(obj: source) { return createTransform(sourceCS: source, target, TransformType.Transformation, invMt) }
		// Transform form base system of fitted to target coordinate system
        let ct: ConcatenatedTransform = ConcatenatedTransform()
		// First transform from source to base system of fitted
        let ctFac: CoordinateTransformationFactory = CoordinateTransformationFactory()
		ct.appendTransformationToList(tr: ctFac.createFromCoordinateSystems(sourceCS: source, target.getBaseCoordinateSystem())!)
		// Transform form base system of fitted to target coordinate system - use invered math transform
		ct.appendTransformationToList(tr: createTransform(sourceCS: target.getBaseCoordinateSystem(), target, TransformType.Transformation, invMt))
		return createTransform(sourceCS: source, target, TransformType.Transformation, ct)
	}
	private class func createFittedTransform(fittedSystem: IFittedCoordinateSystem) -> IMathTransform? {
		// create transform From fitted to base and inverts it
		if fittedSystem is FittedCoordinateSystem { return (fittedSystem as! FittedCoordinateSystem).getToBaseTransform() }
		return nil
	}
	/**
     * Creates an instance of CoordinateTransformation as an anonymous transformation without neither autohority nor code defined.
     *
     * @param sourceCS      Source coordinate system
     * @param targetCS      Target coordinate system
     * @param transformType Transformation type
     * @param mathTransform Math transform
     */
	private class func createTransform(sourceCS: ICoordinateSystem, _ targetCS: ICoordinateSystem, _ transformType: TransformType, _ mathTransform: IMathTransform) -> CoordinateTransformation { return CoordinateTransformation(sourceCS, targetCS, transformType, mathTransform, "", "", -1, "", "") }
	// MathTransformFactory mtFac = new MathTransformFactory ();
	/**
     * /create transform From fitted to base and inverts it
     */
	private class func createCoordinateOperation(geo: IGeocentricCoordinateSystem) -> IMathTransform {
		var parameterList: [ProjectionParameter] = [ProjectionParameter]()
		let ellipsoid: IEllipsoid = geo.getHorizontalDatum().getEllipsoid()
		// var toMeter = ellipsoid.AxisUnit.MetersPerUnit;
		/*
             if (parameterList.Find((p) => p.Name.ToLowerInvariant().Replace(' ', '_').Equals("semi_major")) == null)
                parameterList.Add(new ProjectionParameter("semi_major", ellipsoid.SemiMajorAxis));
        if (parameterList.Find((p) => p.Name.ToLowerInvariant().Replace(' ', '_').Equals("semi_minor")) == null)
        parameterList.Add(new ProjectionParameter("semi_minor", ellipsoid.SemiMinorAxis));
         */
		var found: Bool = false
		for p: ProjectionParameter in parameterList {
			if p.getName().lowercased().replacingOccurrences(of: " ", with: "_") == "semi_major" {
				found = true
				break
			}
		}
		if !found { parameterList.append(ProjectionParameter("semi_major", ellipsoid.getSemiMajorAxis())) }
		found = false
		for p: ProjectionParameter in parameterList {
			if p.getName().lowercased().replacingOccurrences(of: " ", with: "_") == "semi_minor" {
				found = true
				break
			}
		}
		if !found { parameterList.append(ProjectionParameter("semi_minor", ellipsoid.getSemiMinorAxis())) }
		return GeocentricTransform(parameterList)
	}
	private class func createCoordinateOperation(projection: IProjection, _ ellipsoid: IEllipsoid, _ unit: ILinearUnit) -> IMathTransform? {
		var parameterList: [ProjectionParameter] = [ProjectionParameter]()
		// for  var i : Int = 0; i < projection.getNumParameters(); i++
        for i in 0..<projection.getNumParameters() {
            if let param = projection.getParameter(index: i) {
                parameterList.append(param)
            }
//            parameterList.append(projection.getParameter(index: i)!)
        }
		var found: Bool = false
		for p: ProjectionParameter in parameterList {
			if p.getName().lowercased().replacingOccurrences(of: " ", with: "_") == "semi_major" {
				found = true
				break
			}
		}
		if !found { parameterList.append(ProjectionParameter("semi_major", ellipsoid.getSemiMajorAxis())) }
		found = false
		for p: ProjectionParameter in parameterList {
			if p.getName().lowercased().replacingOccurrences(of: " ", with: "_") == "semi_minor" {
				found = true
				break
			}
		}
		if !found { parameterList.append(ProjectionParameter("semi_minor", ellipsoid.getSemiMinorAxis())) }
		found = false
		for p: ProjectionParameter in parameterList {
			if p.getName().lowercased() == "unit" {
				found = true
				break
			}
		}
		if !found { parameterList.append(ProjectionParameter("unit", unit.getMetersPerUnit())) }
		var transform: IMathTransform? = nil
        switch projection.getClassName().lowercased().replacingOccurrences(of: " ", with: "_") {
            case "mercator":
                transform = Mercator(parameterList, nil)
            case "mercator_1sp":
                transform = Mercator(parameterList, nil)
            case "mercator_2sp":
                // 1SP
                transform = Mercator(parameterList, nil)
            case "pseudo-mercator":
                transform = PseudoMercator(parameterList, nil)
            case "popular_visualisation pseudo-mercator":
                transform = PseudoMercator(parameterList, nil)
            case "google_mercator":
                transform = PseudoMercator(parameterList, nil)
            case "transverse_mercator":
                transform = TransverseMercator(parameterList, nil)
            case "albers":
                transform = AlbersProjection(parameterList, nil)
            case "albers_conic_equal_area":
                transform = AlbersProjection(parameterList, nil)
            case "krovak":
                transform = KrovakProjection(parameterList, nil)
            case "polyconic":
                transform = PolyconicProjection(parameterList, nil)
            case "lambert_conformal_conic":
                transform = LambertConformalConic2SP(parameterList, nil)
            case "lambert_conformal_conic_2sp":
                transform = LambertConformalConic2SP(parameterList, nil)
            case "lambert_conic_conformal_(2sp)":
                transform = LambertConformalConic2SP(parameterList, nil)
            case "cassini_soldner":
                transform = CassiniSoldnerProjection(parameterList, nil)
            case "hotine_oblique_mercator":
                transform = HotineObliqueMercatorProjection(parameterList, nil)
            case "oblique_mercator":
                transform = ObliqueMercatorProjection(parameterList, nil)
            case "oblique_stereographic":
                transform = ObliqueStereographicProjection(parameterList, nil)
            default:
                transform = nil
        }
		return transform
	}

	/**
     * Creates a transformation between two coordinate systems.
     *
     * This method will examine the coordinate systems in order to construct
     * a transformation between them. This method may fail if no path between
     * the coordinate systems is found, using the normal failing behavior of
     * the DCP (e.g. throwing an exception).
     *
     * @param sourceCS Source coordinate system
     * @param targetCS Target coordinate system
     * @return
     */
	public func createFromCoordinateSystems(sourceCS: ICoordinateSystem, _ targetCS: ICoordinateSystem) -> ICoordinateTransformation? {
		var trans: ICoordinateTransformation
		if sourceCS is IProjectedCoordinateSystem && targetCS is IGeographicCoordinateSystem {
			// Projected -> Geographic
			trans = CoordinateTransformationFactory.proj2Geog(source: sourceCS as! IProjectedCoordinateSystem, targetCS as! IGeographicCoordinateSystem)
		} else if sourceCS is IGeographicCoordinateSystem && targetCS is IProjectedCoordinateSystem {
			// Geographic -> Projected
			trans = CoordinateTransformationFactory.geog2Proj(source: sourceCS as! IGeographicCoordinateSystem, targetCS as! IProjectedCoordinateSystem)
		} else if sourceCS is IGeographicCoordinateSystem && targetCS is IGeocentricCoordinateSystem {
			// Geocentric -> Geographic
			trans = CoordinateTransformationFactory.geog2Geoc(source: sourceCS as! IGeographicCoordinateSystem, targetCS as! IGeocentricCoordinateSystem)
		} else if sourceCS is IGeocentricCoordinateSystem && targetCS is IGeographicCoordinateSystem {
			// Geocentric -> Geographic
			trans = CoordinateTransformationFactory.geoc2Geog(source: sourceCS as! IGeocentricCoordinateSystem, targetCS as! IGeographicCoordinateSystem)
		} else if sourceCS is IProjectedCoordinateSystem && targetCS is IProjectedCoordinateSystem {
			// Projected -> Projected
			trans = CoordinateTransformationFactory.proj2Proj(source: sourceCS as! IProjectedCoordinateSystem, targetCS as! IProjectedCoordinateSystem)
		} else if sourceCS is IGeocentricCoordinateSystem && targetCS is IGeocentricCoordinateSystem {
			// Geocentric -> Geocentric
            if let tr = CoordinateTransformationFactory.createGeoc2Geoc(source: sourceCS as! IGeocentricCoordinateSystem, targetCS as! IGeocentricCoordinateSystem) {
                trans = tr
            } else {
                return nil
            }
			// trans = CoordinateTransformationFactory.createGeoc2Geoc(source: sourceCS as! IGeocentricCoordinateSystem, targetCS as! IGeocentricCoordinateSystem)
		} else if sourceCS is IGeographicCoordinateSystem && targetCS is IGeographicCoordinateSystem {
			// Geographic -> Geographic
			trans = CoordinateTransformationFactory.createGeog2Geog(source: sourceCS as! IGeographicCoordinateSystem, targetCS as! IGeographicCoordinateSystem)
		} else if sourceCS is IFittedCoordinateSystem {
			// Fitted -> Any
			trans = CoordinateTransformationFactory.fitt2Any(source: sourceCS as! IFittedCoordinateSystem, targetCS)
		} else if targetCS is IFittedCoordinateSystem {
			// Any -> Fitted
			trans = CoordinateTransformationFactory.any2Fitt(source: sourceCS, targetCS as! IFittedCoordinateSystem)
		} else {
			return nil
		}
		return trans
	}
}
