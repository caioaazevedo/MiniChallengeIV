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
    var dataChartBO = DataChartBO()
    
//MARK:- Life Cicle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        chartConfig()
        
        /// Load the pie chart with projects data
        dataChartBO.loadChartData { (chartData) in
            self.circleChart.data = chartData
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
        return String(format:"%02ih%02i", hour, min)
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
