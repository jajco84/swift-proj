//
// Translated by CS2J (http://www.cs2j.com): 27.5.2016 10:26:32
//
// package com.asseco.android.proj;
// Copyright 2005, 2006 - Morten Nielsen (www.iter.dk)
//
// This file is part of SharpMap.
// SharpMap is free software; you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// SharpMap is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
// You should have received a copy of the GNU Lesser General Public License
// along with SharpMap; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
/// The IAngularUnit interface defines methods on angular units.
public protocol IAngularUnit: IUnit {
	/**
     * Gets or sets the number of radians per angular unit.
     *
     * @return the radians per unit
     * @throws Exception the exception
     */
	func getRadiansPerUnit() -> Double
	/**
     * Sets radians per unit.
     *
     * @param value the value
     * @throws Exception the exception
     */
	func setRadiansPerUnit(value: Double)
}
