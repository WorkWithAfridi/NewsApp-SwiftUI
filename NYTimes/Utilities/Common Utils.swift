import Foundation
import UIKit

// Phantom type placeholder for undefined methods
func undefined<T>(_ message:String="",file:String=#file,function:String=#function,line: Int=#line) -> T {
    fatalError("[File: \(file),Line: \(line),Function: \(function),]: Undefined: \(message)")
}
