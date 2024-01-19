//
//  StringReader.swift
//  swift-proj
//
//  Created by Jaroslav Matějíček on 10/11/2020.
//
import Foundation
class StringReader {
	var s: String
	var i: Int = 0
	var m: Int = 0
	init(string: String) { s = string }
	func read() -> Character? {
		if i == s.count { return nil }
		// return s[i]
		i += 1
		return s[s.index(s.startIndex, offsetBy: i - 1)]
	}
	func mark() { m = i }
	func reset() { i = m }
}
