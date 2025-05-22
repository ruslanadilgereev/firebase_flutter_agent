import SwiftUI

struct ACRings: View {
    var percentMove: Double = 0.75
    var percentExercise: Double = 0.50
    var percentStand: Double = 0.75

        var body: some View {
                ZStack {
                    // background
                    Circle()
                        .stroke(.red.opacity(0.20), lineWidth: 20)
                        .frame(width: 200, height: 200)
                    Circle()
                        .stroke(.green.opacity(0.20), lineWidth: 20).frame(width: 150, height: 200)
                    Circle()
                        .stroke(.blue.opacity(0.20), lineWidth: 20).frame(width: 100, height: 200)
                    //colored
                    Circle()
                        .trim(from:0, to:percentMove)
                        .stroke(.red, lineWidth: 20).frame(width: 200, height: 200)

                    Circle()
                        .trim(from:0, to:percentExercise)
                        .stroke(.green, lineWidth: 20).frame(width: 150, height: 200)

                    Circle()
                        .trim(from:0, to:percentStand)
                        .stroke(.blue, lineWidth: 20).frame(width: 100, height: 200)


                }.rotationEffect(.degrees(-90))

            }
}
