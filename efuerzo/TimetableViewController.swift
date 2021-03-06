//
//  TimetableViewController.swift
//  efuerzo
//
//  Created by Nouman Mehmood on 06/02/2017.
//  Copyright © 2017 Nouman Mehmood. All rights reserved.
//

import UIKit
import JTAppleCalendar

class TimetableViewController: UIViewController {
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    let white = UIColor(colorWithHexValue: 0xECEAED)
    let darkPurple = UIColor(colorWithHexValue: 0x3A284C)
    let dimPurple = UIColor(colorWithHexValue: 0x455B77)
    let dateFormatter = DateFormatter()
    let formatter = DateFormatter()
    var todayDate = Date()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarView.register(UINib(nibName: "PinkSectionHeaderView", bundle: Bundle.main),
                              forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                              withReuseIdentifier: "PinkSectionHeaderView")
        
        
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        calendarView.calendarDelegate = self
        calendarView.calendarDataSource = self
        
        let doubleTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didDoubleTapCollectionView(gesture:)))
        doubleTapGesture.numberOfTapsRequired = 2  // add double tap
        
        calendarView.addGestureRecognizer(doubleTapGesture)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.calendarView.scrollToDate(Date())
            self.calendarView.selectDates([Date()])
        }
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        todayDate = Date.createDateWith(year: calendar.component(.year, from: Date()) , month: calendar.component(.month, from: Date()), day: calendar.component(.day, from: Date()), hour: 0, minute: 0, second: 0, timeZone: TimeZone(abbreviation: "BST")!)!
        
        formatter.dateFormat = "yyyy-MM-dd"
    }

    func didDoubleTapCollectionView(gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: gesture.view!)
        let cellState = calendarView.cellStatus(at: point)
        if (cellState != nil){
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let passingValue = dateFormatter.string(from: cellState!.date)
    
            performSegue(withIdentifier: "viewEvents", sender: passingValue)
        }
    }

    
    // This sets the height of your header
    func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
        return MonthSize(defaultSize: 130)
    }
    // This setups the display of your header
    func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "PinkSectionHeaderView", for: indexPath) as! PinkSectionHeaderView
        
        dateFormatter.dateFormat = "yyyy"
        header.year.text = dateFormatter.string(from: range.start)
        
        dateFormatter.dateFormat = "MMMM"
        header.month.text = dateFormatter.string(from: range.start)
        
        return header
    }

    
    // Function to handle the text color of the calendar
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState, todayDate: Date) {
        guard let myCustomCell = view as? CellView  else {
            return
        }
        
        if cellState.isSelected {
            myCustomCell.dayLabel.textColor = darkPurple
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                myCustomCell.dayLabel.textColor = white
                
            } else {
                myCustomCell.dayLabel.textColor = dimPurple
            }
        }
        
        if formatter.string(from: todayDate) == formatter.string(from: cellState.date) {
            myCustomCell.dayLabel.textColor = UIColor.red
        }
        
        
        
    }
    
    // Function to handle the calendar selection
    func handleCellSelection(view: JTAppleCell?, cellState: CellState) {
        guard let myCustomCell = view as? CellView  else {
            return
        }
        if cellState.isSelected {
            myCustomCell.selectedView.layer.cornerRadius =  25
            myCustomCell.selectedView.isHidden = false
        } else {
            myCustomCell.selectedView.isHidden = true
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if (segue.identifier == "viewEvents") {
            let secondViewController = segue.destination as! CurrentEventsViewController
            let passingValue = sender as! String
            secondViewController.passingValue = passingValue
        }
    }

}
  


extension TimetableViewController: JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MM yyyy"
        
        let startDate = formatter.date(from: "01 09 2016")! // You can use date generated from a formatter
        let endDate = formatter.date(from: "01 01 2019")!   // You can also use dates created from this function
        let calendar = Calendar.current                     // Make sure you set this up to your time zone. We'll just use default here
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: 5,
                                                 calendar: calendar,
                                                 generateInDates: .forAllMonths,
                                                 generateOutDates: .tillEndOfGrid,
                                                 firstDayOfWeek: .sunday)
        return parameters
    }
    
    
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let myCustomCell = calendarView.dequeueReusableJTAppleCell(withReuseIdentifier: "CellView", for: indexPath) as! CellView
        
        // Setup Cell text
        myCustomCell.dayLabel.text = cellState.text
        
        handleCellTextColor(view: myCustomCell, cellState: cellState, todayDate: todayDate)
        handleCellSelection(view: myCustomCell, cellState: cellState)
        return myCustomCell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelection(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState, todayDate: todayDate)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelection(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState, todayDate: todayDate)
    }
    

    
}

extension Date {
    /**
     Creates Date from components.
     - Parameter year: Year value.a
     - Parameter month: Month value.
     - Parameter day: Day value.
     - Parameter hour: Hour value.
     - Parameter minute: Minute value.
     - Parameter second: Second value.
     - Parameter timeZone: Time Zone value.
     - Returns: A Date created from parameters or nil if there was a problem creating Date.
     */
    static func createDateWith(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int, timeZone: TimeZone) -> Date? {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        components.second = second
        components.timeZone = timeZone
        
        let gregorian = Calendar(identifier: Calendar.Identifier.gregorian)
        
        let date = gregorian.date(from: components)
        
        return date
    }
}

extension UIColor {
    convenience init(colorWithHexValue value: Int, alpha:CGFloat = 1.0){
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}

