import SwiftUI
import HealthKit

struct StatsView: View {
    @State var buttonEnable: Bool = true
    
    @State var timeCount: TimeInterval
    @State var isTimerRunning = false
    //@State var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    @EnvironmentObject var workoutManager: WorkoutManager
    
    var body: some View {
        TimelineView(MetricsTimelineSchedule(from: workoutManager.builder?.startDate ?? Date())) { context in
            GeometryReader { geometry in
                VStack(alignment: .leading) {
                    ElapsedTimeView(
                        elapsedTime: workoutManager.builder?.elapsedTime ?? 0,
                        showSubseconds: context.cadence == .live
                    )
                    .foregroundColor(Color.yellow)
                    .font(.system(size: 30, design: .rounded))
                    
                    Text(
                        Measurement(
                            value: workoutManager.activeEnergy,
                            unit: UnitEnergy.kilocalories
                        ).formatted(
                            .measurement(
                                width: .abbreviated,
                                usage: .workout,
                                numberFormatStyle: .number.precision(.fractionLength(0))
                            )
                        )
                    )
                    
                    Text(
                        workoutManager.heartRate.formatted(.number.precision(.fractionLength(0))) + " bpm"
                    )
                    
                    Text(
                        Measurement(
                            value: workoutManager.distance,
                            unit: UnitLength.meters
                        ).formatted(
                            .measurement(
                                width: .abbreviated,
                                usage: .road
                            )
                        )
                    )
                }
                .font(.system(.title, design: .rounded)
                        .monospacedDigit()
                        .lowercaseSmallCaps()
                )
                .frame(maxWidth: geometry.size.width * 0.9, alignment: .leading)
                .ignoresSafeArea(edges: .bottom)
                .scenePadding()
            }
        }
        .onAppear {
            print(workoutManager.builder)
        }
    }
        
}

private struct MetricsTimelineSchedule: TimelineSchedule {
    var startDate: Date

    init(from startDate: Date) {
        self.startDate = startDate
    }

    func entries(from startDate: Date, mode: TimelineScheduleMode) -> PeriodicTimelineSchedule.Entries {
        PeriodicTimelineSchedule(
            from: self.startDate,
            by: (mode == .lowFrequency ? 1.0 : 1.0 / 30.0)
        ).entries(from: startDate, mode: mode)
    }
}
