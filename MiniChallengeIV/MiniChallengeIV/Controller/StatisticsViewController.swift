//
//  StatisticsViewController.swift
//  MiniChallengeIV
//
//  Created by Caio Azevedo on 06/05/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import UIKit
import Charts

class StatisticsViewController: UIViewController {

//MARK:- Atributes
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var circleChart: PieChartView!
    @IBOutlet weak var labelMonth: UILabel!
    @IBOutlet weak var totalFocusedLabel: UILabel!
    @IBOutlet weak var totalDistractionsLabel: UILabel!
    @IBOutlet weak var totalBreaksLabel: UILabel!
    @IBOutlet weak var chartBackgroundImage: UIImageView!
    
    var dataChartBO = DataChartBO()
    var statistics: [Statistic]?
    
    var currentMonth = Int()
    var currentYear = Int()
    var month = Int()
    var year = Int()
    
//MARK:- Life Cicle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        let currentDate = Date()
        self.currentMonth = Calendar.current.component(.month, from: currentDate)
        self.currentYear = Calendar.current.component(.year, from: currentDate)
        
        self.month = self.currentMonth
        self.year = self.currentYear
        
        let currentStatistic = self.filterByMonth(month: self.currentMonth, year: self.currentYear)
        
        self.showStatistics(statistic: currentStatistic)
        
        chartConfig()
        
        /// Load the pie chart with projects data
        dataChartBO.loadChartData { (chartData) in
            self.circleChart.data = chartData
            
            self.circleChart.isHidden = self.dataChartBO.isHidden
            self.chartBackgroundImage.isHidden = !self.circleChart.isHidden
        }
    }

//MARK:- Functions
    
    /// Description:  Chart appearance configuration
    func chartConfig(){
        circleChart.holeRadiusPercent = 0.7
        circleChart.transparentCircleColor = UIColor.clear
        circleChart.legend.enabled = false
        circleChart.highlightPerTapEnabled = false
        circleChart.holeColor = UIColor.clear
        circleChart.entryLabelColor = UIColor(red: 0.20, green: 0.20, blue: 0.20, alpha: 1.00)
    }
    
    func convetTime(seconds: Int) -> String {
        print("Time -->> \(seconds)")
        let min = (seconds / 60) % 60
        let hour = seconds / 3600
        return String(format:"%2ih%02i", hour, min)
    }
    
    func getStatistics(){
        StatisticBO().retrieveStatistic { (results) in
            switch results {
            case .success(let statisticsRetrieved):
                self.statistics = statisticsRetrieved
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func filterByMonth(month: Int, year: Int) -> Statistic? {
        self.getStatistics()
        
        guard let statisticsArray = self.statistics else {
            return nil
        }

        for statistic in statisticsArray {
            if statistic.month == month && statistic.year == year {
                return statistic
            }
        }
        
        self.month = self.currentMonth
        self.year = self.currentYear
        
        return filterByMonth(month: self.currentMonth, year: self.currentYear)
    }
    
    func showStatistics(statistic: Statistic?) {
        self.labelMonth.text = self.getMonthString(monthNum: statistic?.month ?? self.currentMonth)
        
        self.totalBreaksLabel.text = convetTime(seconds: statistic?.restTime ?? 0)
        self.totalFocusedLabel.text = convetTime(seconds: statistic?.focusTime ?? 0)
        self.totalDistractionsLabel.text = convetTime(seconds: statistic?.lostFocusTime ?? 0)
    }
    
    func dateValidation(month: Int, year: Int){
        if self.month > 12 {
            self.month = 1
            self.year += 1
        } else if self.month < 1 {
            self.month = 12
            self.year -= 1
        }
    }
    
    @IBAction func advanceMonth(_ sender: Any) {
        self.month += 1
        
        dateValidation(month: self.month, year: self.year)
        
        let statistic = filterByMonth(month: self.month, year: self.year)
        
        self.showStatistics(statistic: statistic)
        
    }
    
    @IBAction func backMonth(_ sender: Any) {
        self.month -= 1
        
        dateValidation(month: self.month, year: self.year)
        
        let statistic = filterByMonth(month: self.month, year: self.year)
        
        self.showStatistics(statistic: statistic)
    }
    
    func getMonthString(monthNum: Int) -> String {
        switch monthNum {
            case 01:
                return NSLocalizedString("January", comment: "")
            case 02:
                return NSLocalizedString("February", comment: "")
            case 03:
                return NSLocalizedString("March", comment: "")
            case 04:
                return NSLocalizedString("April", comment: "")
            case 05:
                return NSLocalizedString("May", comment: "")
            case 06:
                return NSLocalizedString("June", comment: "")
            case 07:
                return NSLocalizedString("July", comment: "")
            case 08:
                return NSLocalizedString("August", comment: "")
            case 09:
                return NSLocalizedString("September", comment: "")
            case 10:
                return NSLocalizedString("October", comment: "")
            case 11:
                return NSLocalizedString("November", comment: "")
            case 12:
                return NSLocalizedString("December", comment: "")
            default:
                return "Month"
        }
    }
    
}

extension StatisticsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataChartBO.projects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "projectStatisticsCell") as! ProjectStatisticsCell
        cell.colorView.backgroundColor = dataChartBO.projectColors[indexPath.row] as UIColor
        cell.projectNameLabel.text = dataChartBO.projects[indexPath.row].name
        cell.projectTimeLabel.text = convetTime(seconds: dataChartBO.timeProjects[indexPath.row])
        
        return cell
    }
    
    
}
