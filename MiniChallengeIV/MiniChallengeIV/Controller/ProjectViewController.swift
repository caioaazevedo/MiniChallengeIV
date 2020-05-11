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
    var selectedProjectId: Int?
    var projectBO = ProjectBO()
    var projects: [Project] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadList()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
    }
    
    @IBAction func addProjectButtonAction(_ sender: Any) {
        goToNewProjectViewController()
    }
    
    @IBAction func showStatistics(_ sender: Any) {
        performSegue(withIdentifier: "statistics", sender: nil)
    }
    
    /// Go to NewProjectViewController
    private func goToNewProjectViewController() {
        if let newProjectVC = UIStoryboard.loadView(from: .NewProject, identifier: .NewProjectID) as? NewProjectViewController {
            newProjectVC.modalTransitionStyle = .crossDissolve
            newProjectVC.modalPresentationStyle = .overCurrentContext
            newProjectVC.delegate = self
            
            self.present(newProjectVC, animated: true)
        }
    }
    
    /// Go to UpdateProjectViewController
    private func goToUpdateProjectViewController(project: Project) {
        if let updateProjectVC = UIStoryboard.loadView(from: .UpdateProject, identifier: .UpdateProjectID) as? UpdateProjectViewController {
            updateProjectVC.modalTransitionStyle = .crossDissolve
            updateProjectVC.modalPresentationStyle = .overCurrentContext
            
            updateProjectVC.project = project
            
            self.present(updateProjectVC, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToTimer" {
            if let timerViewController = segue.destination as? TimerViewController {
                guard let index = selectedProjectId else {return}
                //pass projects id to timer
                timerViewController.timeTracker.projectUuid = projects[index].id
            }
        }
    }
    
    func deleteAlert(){
        let alert = UIAlertController(title: "Delete", message: "Project has deleted!", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(alertAction)
        
        self.present(alert, animated: true)
    }
}

extension ProjectViewController: ReloadProjectListDelegate {
    func reloadList(){
        projectBO.retrieve(completion: { result in
            switch result {
            case .success(let projects):
                self.projects = projects
                collectionView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
            
        }
    }
    
extension ProjectViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedProjectId = indexPath.item
        //        goToNewProjectViewController()
        performSegue(withIdentifier: "GoToTimer", sender: self)
    }
    
    /// Menu configuration
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let proj = self.projects[indexPath.row]
        
        let edit = UIAction(title: "Edit", image: UIImage(systemName: "square.and.pencil"), handler: { (edit) in
            self.goToUpdateProjectViewController(project: proj)
        })
        
        let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive ,handler: { (delete) in
                
            
            self.projectBO.delete(uuid: proj.id) { (result) in
                    switch result {
                        case .success():
                            self.deleteAlert()
                            self.projects.remove(at: indexPath.row)
                            collectionView.reloadData()
                            break
                        case .failure(let error):
                            print(error.localizedDescription)
                            break
                    }
                }
            })

        return UIContextMenuConfiguration(identifier: nil,
          previewProvider: nil) { _ in
          UIMenu(title: "Actions", children: [edit, delete])
        }
    }
}
    
extension ProjectViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
        return UIEdgeInsets(top: 20, left: 8, bottom: 10, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        return CGSize(width: collectionViewWidth * 0.475, height: collectionViewWidth * 0.45)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
