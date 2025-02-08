import UIKit
import AVFoundation

class TimerViewController: UIViewController {

    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .countDownTimer
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()

    private let clockLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let timerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 30, weight: .bold)
        label.textAlignment = .center
        label.text = "00:00:00"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let beginTimer: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start Timer", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.addTarget(self, action: #selector(startTimer(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var countdownTimer: Timer?
    private var totalTime: Int = 0
    private var audioPlayer: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateClock), userInfo: nil, repeats: true)
    }

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(backgroundImage)
        view.addSubview(clockLabel)
        view.addSubview(datePicker)
        view.addSubview(timerLabel)
        view.addSubview(beginTimer)

        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            clockLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            clockLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            datePicker.topAnchor.constraint(equalTo: clockLabel.bottomAnchor, constant: 20),
            datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            timerLabel.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 40),
            timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            beginTimer.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 20),
            beginTimer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            beginTimer.widthAnchor.constraint(equalToConstant: 150),
            beginTimer.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func updateClock() {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss"
        clockLabel.text = formatter.string(from: Date())

        let hour = Calendar.current.component(.hour, from: Date())
        let imageName = hour >= 12 ? "pm_background" : "am_background"
        backgroundImage.image = UIImage(named: imageName)
    }

    @objc private func startTimer(_ sender: UIButton) {
        if sender.title(for: .normal) == "Stop Music" {
            stopMusic()
            return
        }

        totalTime = Int(datePicker.countDownDuration)
        countdownTimer?.invalidate()

        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }

    @objc private func updateTimer() {
        if totalTime > 0 {
            totalTime -= 1
            let hours = totalTime / 3600
            let minutes = (totalTime % 3600) / 60
            let seconds = totalTime % 60
            timerLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            countdownTimer?.invalidate()
            playMusic()
            beginTimer.setTitle("Stop Music", for: .normal)
        }
    }

    private func playMusic() {
        if let soundURL = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.play()
            } catch {
                print("Error playing sound: \(error.localizedDescription)")
            }
        }
    }

    private func stopMusic() {
        audioPlayer?.stop()
        beginTimer.setTitle("Start Timer", for: .normal)
        timerLabel.text = "00:00:00"
    }
}

