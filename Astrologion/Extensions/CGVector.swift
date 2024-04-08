import UIKit

extension CGVector {
    func normalized() -> CGVector {
        let length = sqrt(dx*dx + dy*dy)
        guard length != 0 else { return self }
        return CGVector(dx: dx / length, dy: dy / length)
    }
}
