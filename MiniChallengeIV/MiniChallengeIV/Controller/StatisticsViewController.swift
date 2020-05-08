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
    @IBOutlet weak var circleChart: PieChartView!
    var dataChartBO = DataChartBO()
    
//MARK:- Life Cicle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        chartConfig()
        
        /// Load the pie chart with projects data
        dataChartBO.loadChartData { (chartData) in
            self.circleChart.data = chartData
        }
    }

//MARK:- Functions
    
    /// Description:  Chart appearance configuration
    func chartConfig(){
        circleChart.holeRadiusPercent = 0.6
        circleChart.transparentCircleColor = UIColor.clear
        circleChart.legend.enabled = false
    }
    
    

}
