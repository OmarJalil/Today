//
//  PriorityContentView.swift
//  Today
//
//  Created by Jalil Fierro on 07/01/23.
//

import UIKit

class PriorityContentView: UIView, UIContentView {
    var configuration: UIContentConfiguration {
        didSet {
            configure(configuration: configuration)
        }
    }

    let priorityLabel = UILabel()
    let prioritySlider = UISlider()
    var priorityStack = UIStackView()

    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        // apply style to the user interface
        priorityStack = UIStackView(arrangedSubviews: [priorityLabel, prioritySlider])
        priorityStack.axis = .vertical
        addSubview(priorityStack)

        priorityLabel.textAlignment = .center
        priorityLabel.textColor = .white

        prioritySlider.maximumValue = 10.0
        prioritySlider.minimumValue = 0.0
        prioritySlider.addTarget(self, action: #selector(self.sliderValueDidChange(_:)), for: .valueChanged)
        configure(configuration: configuration)
    }

    func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? ReminderContentConfiguration else { return }
        self.priorityLabel.text = configuration.reminder.title + " (priority: \(configuration.reminder.currentPriority))"
        self.prioritySlider.value = Float(configuration.reminder.currentPriority)
    }

    @objc func sliderValueDidChange(_ sender: UISlider!) {
        sender.value = round(sender.value)
        guard var configuration = configuration as? ReminderContentConfiguration else { return }
        configuration.updatePriority(to: Int(sender.value))
        self.configure(configuration: configuration)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct ReminderContentConfiguration: UIContentConfiguration {
    var reminder: Reminder

    func makeContentView() -> UIView & UIContentView {
        return PriorityContentView(self)
    }
    func updated(for state: UIConfigurationState) -> ReminderContentConfiguration {
        return self
    }
    mutating func updatePriority(to newPriority: Int) {
        reminder.currentPriority = newPriority
    }
}
