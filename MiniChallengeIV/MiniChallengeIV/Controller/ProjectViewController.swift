//
//  ProjectViewController.swift
//  MiniChallengeIV
//
//  Created by Murilo Teixeira on 29/04/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import UIKit

class ProjectViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var focusedTimeLabel: UILabel!
    @IBOutlet weak var distractionTimeLabel: UILabel!
    @IBOutlet weak var breakTimeLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    let collectionLayout = CollectionViewFlowLayout()
    
    var selectedProjectId: Int?
    var projectBO = ProjectBO()
    var projects: [Project] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createStatistics()
        getCurrentStatistics()
        reloadList()
        
        collectionView.collectionViewLayout = collectionLayout
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
//        projectBO.create(name: "Work", color: UIColor(red: 0.77, green: 0.87, blue: 0.96, alpha: 1.00), completion: { results in
//            switch results {
//
//            case .success(let project):
//                print(project)
//
//
//                projectBO.retrieve(completion: { results in
//                    switch results {
//
//                    case .success(let projects):
//                        self.projects = projects
//                        self.selectedProjectId = 0
//                        performSegue(withIdentifier: "GoToTimer", sender: self)
//
//                    case .failure(let error):
//                        print(error.localizedDescription)
//                    }
//                })
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        })
        
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
        
        
        goToOnboardingViewController()
    }
    
    @IBAction func addProjectButtonAction(_ sender: Any) {
        goToNewProjectViewController()
    }
    
    @IBAction func showStatistics(_ sender: Any) {
        performSegue(withIdentifier: "statistics", sender: nil)
    }
    
    /// Go to Onboarding
    private func goToOnboardingViewController() {
        print(UserDefaults.standard.bool(forKey: "onboardingWasDisplayed"))
        guard !UserDefaults.standard.bool(forKey: "onboardingWasDisplayed") else { return }

        if let onboardingVC = UIStoryboard.loadView(from: .Onboarding, identifier: .VC) as? OnboardingPagerViewController {
            onboardingVC.modalTransitionStyle = .crossDissolve
            onboardingVC.modalPresentationStyle = .overCurrentContext
            
            self.present(onboardingVC, animated: true)
        }
    }
    
    /// Go to NewProjectViewController
    private func goToNewProjectViewController() {
        if let newProjectVC = UIStoryboard.loadView(from: .NewProject, identifier: .NewProjectID) as? NewProjectViewController {
            newProjectVC.modalTransitionStyle = .crossDissolve
            newProjectVC.modalPresentationStyle = .overCurrentContext
            newProjectVC.delegate = self
            
            if let selectedProjectId = selectedProjectId {
                newProjectVC.project = projects[selectedProjectId]
                self.selectedProjectId = nil
            }
            
            self.present(newProjectVC, animated: true)
        }
    }
    
    /// Description: Function to get Statistic Data per month and year to Show on Home screen
    private func getCurrentStatistics(){
        let currentDate = Date()
        let month = Calendar.current.component(.month, from: currentDate)
        let year = Calendar.current.component(.year, from: currentDate)
        
        StatisticBO().retrieveStatisticPerMonth(month: Int32(month), year: Int32(year)) { (results) in
            switch results {
            case .success(let statistic):
                
                self.focusedTimeLabel.text = convertTime(seconds: statistic?.focusTime ?? 0)
                self.distractionTimeLabel.text = convertTime(seconds: statistic?.lostFocusTime ?? 0)
                self.breakTimeLabel.text =  convertTime(seconds: statistic?.restTime ?? 0)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    /// Description:  Convert Time in seconds to show on label
    /// - Parameter seconds: time in seconds to convert
    /// - Returns: returns the time to present. Example:  01h30
    func convertTime(seconds: Int) -> String {
        let min = (seconds / 60) % 60
        let hour = seconds / 3600
        return String(format:"%2ih%02i", hour, min)
    }
    
    func createStatistics(){
        //get date
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.yyyy"
        let key = formatter.string(from: date)
        
        var startedNewMonth: Bool {
            get {
                return UserDefaults.standard.bool(forKey: key)
            }
            set {
                UserDefaults.standard.set(newValue, forKey: key)
            }
        }
        //Check if the date regard a new month
        if startedNewMonth {return}
        
        //Convert it to int
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)

        guard let year = components.year,
            let month = components.month else {return}
        //implement it in statistics
        let statisticsBO = StatisticBO()
        statisticsBO.createStatistic(id: UUID(), focusTime: 0, lostFocusTime: 0, restTime: 0, qtdLostFocus: 0, year: year, month: month) { (result) in
            switch result {
                
            case .success(_): break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        //set the month to checked
        startedNewMonth = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToTimer" {
            if let timerViewController = segue.destination as? TimerViewController {
                guard let index = selectedProjectId else {return}
                //pass projects id to timer
                timerViewController.timeTracker.projectUuid = projects[index].id
                timerViewController.id = projects[index].id
                
                selectedProjectId = nil
            }
        }
    }
    
    /// Description: Function to ensure that the user really wants to delete a project
    /// - Parameters:
    ///   - proj: The project thst the user wants to delete
    ///   - indexPath: The array reference index from projects
    func deleteProject(proj: Project, indexPath: IndexPath){
        let titleLocalized = NSLocalizedString("Delete Project", comment: "")
        let messageLocalized = NSLocalizedString("Delete Message", comment: "")
        let alert = UIAlertController(title: titleLocalized, message: messageLocalized, preferredStyle: .alert)
        
        let yesLocalized = NSLocalizedString("Yes", comment: "")
        let alertActionOK = UIAlertAction(title: yesLocalized, style: .default){ (action) in
            self.projectBO.delete(uuid: proj.id) { (result) in
                switch result {
                case .success():
                    
                    /// Add delete animation 
                    UIView.animate(withDuration: 0.5, animations: {
                        self.collectionView.cellForItem(at: indexPath)?.alpha = 0.0
                    }, completion: { (_) in
                        self.projects.remove(at: indexPath.row)
                        self.collectionView.reloadData()
                    })
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    break
                }
            }
        }
        
        let cancelLocalized = NSLocalizedString("Cancel", comment: "")
        let alertActionCancel = UIAlertAction(title: cancelLocalized, style: .cancel, handler: nil)
        
        alert.addAction(alertActionCancel)
        alert.addAction(alertActionOK)
        
        self.present(alert, animated: true)
    }
}

extension ProjectViewController: ReloadProjectListDelegate {
    func reloadList(){
        projectBO.retrieve(completion: { result in
            switch result {
            case .success(let projects):
                self.projects = projects
                
                print(projects)
                collectionView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
        
    }
}

extension ProjectViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedProjectId = indexPath.row
        performSegue(withIdentifier: "GoToTimer", sender: self)
    }

    
    /// Menu configuration
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let proj = self.projects[indexPath.row]
        
        let editLocalized = NSLocalizedString("Edit", comment: "")
        let edit = UIAction(title: editLocalized, image: UIImage(systemName: "square.and.pencil"), handler: { (edit) in
            self.selectedProjectId = indexPath.item
            self.goToNewProjectViewController()
        })
        
        let deleteLocalized = NSLocalizedString("Delete", comment: "")
        let delete = UIAction(title: deleteLocalized, image: UIImage(systemName: "trash"), attributes: .destructive ,handler: { (delete) in
            
            self.deleteProject(proj: proj, indexPath: indexPath)
        })
        let actionsLocalized = NSLocalizedString("Actions", comment: "")
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil) { _ in
                                            UIMenu(title: actionsLocalized, children: [edit, delete])
        }
    }
}


extension ProjectViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        /// When projects is empty show background Image
        if projects.count == 0 {
            UIView.animate(withDuration: 0.5) {
                self.backgroundImage.isHidden = false
                self.collectionView.isHidden = true
            }
        } else {
            UIView.animate(withDuration: 0.5) {
                self.backgroundImage.isHidden = true
                self.collectionView.isHidden = false
            }
        }
        
        //        return ProjectDAO.list.count
        return projects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ProjectCollectionViewCell else {
            return ProjectCollectionViewCell()
        }
        
        cell.projectNameLabel.text = projects[indexPath.row].name
        cell.backgroundColor = projects[indexPath.row].color
        
        return cell
    }
}

extension ProjectViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        return CGSize(width: collectionViewWidth * 0.47, height: collectionViewWidth * 0.47)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 14
    }
}
