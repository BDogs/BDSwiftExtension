import Foundation

let num = "123abc"
num.components(separatedBy: .alphanumerics)
if let range = num.rangeOfCharacter(from: .decimalDigits, options: .numeric, range: nil) {
    range.description
    range as? ClosedRange<String.Index>
    range.lowerBound.encodedOffset
    range.upperBound.encodedOffset
    num.startIndex.encodedOffset
    num.endIndex.encodedOffset
    num.distance(from: range.lowerBound, to: range.upperBound)
    num[range]
//    num.enumerateSubstrings(in: Range(0..<num.count, options: String.EnumerationOptions.substringNotRequired) { (temp, r1, r2, flag) in
//        
//    }
}
