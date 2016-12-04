//
//  WakeUpEditViewController.swift
//  Ambiance
//
//  Created by Matthew Carroll on 11/19/16.
//  Copyright © 2016 ambiance.com. All rights reserved.
//

import UIKit

class WakeUpEditViewController: UIViewController, ClearNavBar {

    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var globalIsEnabledSwitch: UISwitch!
    @IBOutlet var mondayCheckbox: DayCheckmarkView!
    @IBOutlet var tuesdayCheckbox: DayCheckmarkView!
    @IBOutlet var wednesdayCheckbox: DayCheckmarkView!
    @IBOutlet var thursdayCheckbox: DayCheckmarkView!
    @IBOutlet var fridayCheckbox: DayCheckmarkView!
    @IBOutlet var saturdayCheckbox: DayCheckmarkView!
    @IBOutlet var sundayCheckbox: DayCheckmarkView!
    @IBOutlet var timePicker: UIDatePicker!
    
    public var delegate: WakeUpEditViewControllerDelegate?
    public var initialSelectedDay: String?
    public var initialDayAlarm: DayAlarm?
    
    private var dayToCheckboxMap: [String : DayCheckmarkView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dayToCheckboxMap = [
            "monday" : mondayCheckbox,
            "tuesday" : tuesdayCheckbox,
            "wednesday" : wednesdayCheckbox,
            "thursday" : thursdayCheckbox,
            "friday" : fridayCheckbox,
            "saturday" : saturdayCheckbox,
            "sunday" : sundayCheckbox
        ]
        
        clearBackground(forNavBar: navBar)
        makeTimePickerGray()
        restrictTimeSelectionTo5Mins()
        
        if let initialSelectedDay = initialSelectedDay {
            dayToCheckboxMap[initialSelectedDay]?.isChecked = true
        }
        
        globalIsEnabledSwitch.isOn = nil != initialDayAlarm
        
        if let initialDayAlarm = initialDayAlarm {
            var timeComponents = Calendar.current.dateComponents([Calendar.Component.hour, Calendar.Component.minute], from: Date())
            timeComponents.hour = initialDayAlarm.alarmTimeHours
            timeComponents.minute = initialDayAlarm.alarmTimeMinutes
            timePicker.setDate(Calendar.current.date(from: timeComponents)!, animated: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onDoneTap(_ sender: AnyObject) {
        let wakeUpSchedule = createWakeUpSchedule()
        
        delegate?.saveEdit(wakeUpSchedule: wakeUpSchedule)
    }
    
    @IBAction func onCancelTap(_ sender: AnyObject) {
        delegate?.cancelEdit()
    }
    
    @IBAction func onEnabledToggle(_ sender: AnyObject) {
        timePicker.isEnabled = globalIsEnabledSwitch.isOn
    }
    
    private func makeTimePickerGray() {
        timePicker.setValue(Palette.grayLight, forKey: "textColor")
    }
    
    private func restrictTimeSelectionTo5Mins() {
        timePicker.minuteInterval = 5
    }
    
    private func createWakeUpSchedule() -> WakeUpSchedule {
        var daySchedules : [String : WakeUpDaySchedule] = [:]
        
        let hours = getHoursFromTimePicker()
        let minutes = getMinutesFromTimePicker()
        for (day, checkbox) in dayToCheckboxMap {
            if (checkbox.isChecked) {
                if (globalIsEnabledSwitch.isOn) {
                    let wakeUpDaySchedule = WakeUpDaySchedule(hours: hours, minutes: minutes)
                    daySchedules[day] = wakeUpDaySchedule
                } else {
                    daySchedules[day] = WakeUpDaySchedule()
                }
            }
        }
        
        return WakeUpSchedule(daySchedules: daySchedules)
    }
    
    private func getHoursFromTimePicker() -> Int {
        return Calendar.current.component(.hour, from: timePicker.date)
    }
    
    private func getMinutesFromTimePicker() -> Int {
        return Calendar.current.component(.minute, from: timePicker.date)
    }
}

protocol WakeUpEditViewControllerDelegate {
    
    func saveEdit(wakeUpSchedule: WakeUpSchedule)
    
    func cancelEdit()
    
}

struct WakeUpSchedule {
    // Key is day of week: "monday", "tuesday", etc.
    public let daySchedules: [String : WakeUpDaySchedule]
    
    public var description: String {
        get {
            var _description = ""
            for (day, schedule) in daySchedules {
                _description += "\(day): \(schedule)\n"
            }
            return _description
        }
    }
}

struct WakeUpDaySchedule {
    public let isEnabled: Bool
    public let hours: Int // 24 hour format so we can avoid AM/PM explicitly
    public let minutes: Int
    
    init(hours: Int, minutes: Int) {
        self.hours = hours
        self.minutes = minutes
        self.isEnabled = true
    }
    
    init() {
        self.isEnabled = false
        self.hours = 0
        self.minutes = 0
    }
    
    public var description: String {
        get {
            return "\(hours):\(minutes)"
        }
    }
}
