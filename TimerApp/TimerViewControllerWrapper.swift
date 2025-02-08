import SwiftUI

struct TimerViewControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> TimerViewController {
        return TimerViewController()
    }

    func updateUIViewController(_ uiViewController: TimerViewController, context: Context) {}
}
