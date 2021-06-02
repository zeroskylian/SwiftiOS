//
//  MainVC.swift
//  SwiftiOS
//
//  Created by lian on 2021/4/9.
//

import UIKit
import CalendarKit

class MainVC: UIViewController {
    
    var generatedEvents = [EventDescriptor]()
    var alreadyGeneratedSet = Set<Date>()
    
    var current: EventDescriptor?
    
    public let calendar: Calendar = Calendar.autoupdatingCurrent
    
    private var style: CalendarStyle = {
        var style = CalendarStyle()
        style.timeline.dateStyle = DateStyle.twentyFourHour
        var allDatStyle = AllDayViewStyle()
        allDatStyle.backgroundColor = .red
        style.timeline.allDayStyle = allDatStyle
        return style
    }()
    
    public lazy var dayView = DayView(calendar: calendar)
    
    private var observer: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "主页"
        view.backgroundColor = .white
        view.addSubview(dayView)
        dayView.translatesAutoresizingMaskIntoConstraints  = false
        dayView.isHeaderViewVisible = false
        dayView.updateStyle(style)
        dayView.dataSource = self
        dayView.delegate = self
        observer = dayView.observe(\.frame, options: [.new], changeHandler: { _, v in
            print(v)
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dayView.frame = view.bounds
        dayView.scrollToFirstEventIfNeeded()
    }
    deinit {
        print("sssss")
    }
    
    private func generateEventNearDate(_ date: Date) -> EventDescriptor {
        let workingDate = Calendar.current.date(byAdding: .hour, value: Int.random(in: 1...15), to: date)!
        let duration = Int(arc4random_uniform(160) + 60)
        let startDate = Calendar.current.date(byAdding: .minute, value: -Int(CGFloat(duration) / 2), to: date)!
        
        let event = Event()
        event.endDate = Calendar.current.date(byAdding: .minute, value: duration, to: workingDate)!
        event.startDate = startDate
        event.endDate = Calendar.current.date(byAdding: .minute, value: duration, to: startDate)!
        event.text = "廉鑫博" + String(date.timeIntervalSinceNow)
        event.color = .cyan
        event.editedEvent = event
        event.userInfo = "sdsd"
        if #available(iOS 12.0, *) {
            if traitCollection.userInterfaceStyle == .dark {
                event.textColor = .red
                event.backgroundColor = event.color.withAlphaComponent(0.6)
            }
        }
        return event
    }
}

extension MainVC: NavigatorRouterProtocol {
    
    public func setParameter(json: [String: Any]?) {
        HLLog(message: json, type: .database)
    }
    
    public func setParameter(interact: Any?) {
        HLLog(message: interact, type: .database)
    }
    
    public func setParameter(object: Any?) {
        HLLog(message: object, type: .database)
        if let title = object as? String {
            self.title = title
        }
    }
    
    public func setParameter(list: [Any]?) {
        HLLog(message: list, type: .database)
    }
}

extension MainVC: DayViewDelegate {
    func dayViewDidSelectEventView(_ eventView: EventView) {
        
    }
    
    func dayViewDidLongPressEventView(_ eventView: EventView) {
        guard let descriptor = eventView.descriptor as? Event else {
          return
        }
        dayView.endEventEditing()
        print("Event has been longPressed: \(descriptor) \(String(describing: descriptor.userInfo))")
        dayView.beginEditing(event: descriptor, animated: true)
        print(Date())
    }
    
    func dayView(dayView: DayView, didTapTimelineAt date: Date) {
        dayView.endEventEditing()
    }
    
    func dayView(dayView: DayView, didLongPressTimelineAt date: Date) {
        print("Did long press timeline at date \(date)")
        // Cancel editing current event and start creating a new one
        dayView.endEventEditing()
        let event = generateEventNearDate(date)
        print("Creating a new event")
        dayView.create(event: event, animated: true)
        current = event
    }
    
    func dayViewDidBeginDragging(dayView: DayView) {
        dayView.endEventEditing()
    }
    
    func dayViewDidTransitionCancel(dayView: DayView) {
        
    }
    
    func dayView(dayView: DayView, willMoveTo date: Date) {
        
    }
    
    func dayView(dayView: DayView, didMoveTo date: Date) {
        
    }
    
    func dayView(dayView: DayView, didUpdate event: EventDescriptor) {
        print("did finish editing \(event)")
        print("new startDate: \(event.startDate) new endDate: \(event.endDate)")
        
        if let _ = event.editedEvent {
            event.commitEditing()
        }
        
        if let createdEvent = current {
            createdEvent.editedEvent = nil
            generatedEvents.append(createdEvent)
            self.current = nil
            dayView.endEventEditing()
        }
        
        dayView.reloadData()
    }
    
    
}

extension MainVC: EventDataSource {
    func eventsForDate(_ date: Date) -> [EventDescriptor] {
        return generatedEvents
    }
}
 
