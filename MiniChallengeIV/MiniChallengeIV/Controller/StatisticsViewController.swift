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
    
    @IBOutlet weak var circleChart: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        circleChart.holeRadiusPercent = 0.6
        circleChart.transparentCircleColor = UIColor.clear
        circleChart.legend.enabled = false
        
        var entries = [PieChartDataEntry]()
        entries.append(PieChartDataEntry(value: 35.11))
        entries[0].label = "%"
        entries.append(PieChartDataEntry(value: 6.17))
        entries[1].label = "%"
        entries.append(PieChartDataEntry(value: 5.61))
        entries[2].label = "%"
        entries.append(PieChartDataEntry(value: 5.94))
        entries[3].label = "%"
        entries.append(PieChartDataEntry(value: 12.89))
        entries[4].label = "%"
        entries.append(PieChartDataEntry(value: 34.28))
        entries[5].label = "%"
        
        let colors = [
            UIColor(red: 0.81, green: 0.62, blue: 0.56, alpha: 1.00),
            UIColor(red: 0.50, green: 0.50, blue: 0.50, alpha: 1.00),
            UIColor(red: 0.44, green: 0.71, blue: 0.62, alpha: 1.00),
            UIColor(red: 0.39, green: 0.65, blue: 0.91, alpha: 1.00),
            UIColor(red: 0.69, green: 0.46, blue: 0.94, alpha: 1.00),
            UIColor(red: 0.72, green: 0.74, blue: 0.75, alpha: 1.00)
        ]
        
        let set  = PieChartDataSet(entries: entries)
        set.colors = colors as! [NSUIColor]
        set.label = ""
        let data = PieChartData(dataSet: set)
        circleChart.data = data
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
    }

}
