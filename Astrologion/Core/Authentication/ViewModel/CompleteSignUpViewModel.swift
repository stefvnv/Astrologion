import Foundation
import SwiftUI

class CompleteSignUpViewModel: ObservableObject {
    @Published var showSunSign = false
    @Published var showMoonSign = false
    @Published var showAscendant = false
    @Published var showButton = false

    func performSequentialReveals() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation {
                self.showSunSign = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    self.showMoonSign = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        self.showAscendant = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation {
                            self.showButton = true
                        }
                    }
                }
            }
        }
    }
}
