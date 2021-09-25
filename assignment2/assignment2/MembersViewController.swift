//
//  ViewController.swift
//  assignment2
//
//  Created by Joey Lee on 2021/09/22.
//

import UIKit

class MembersViewController: UIViewController {
    var membersViewList: [Member]?
    
    var teamsDict: [String: [Int]] = [:]
    
    var membersViewListCount: Int {
        return membersViewList?.count ?? 0
    }
    
    @IBOutlet weak var membersTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMembersTableView()
        getMembersList()
        
        // Do any additional setup after loading the view.
    }
    
    private func setMembersTableView() {
        let nib = UINib(nibName: "MembersTableViewCell", bundle: nil)
        membersTableView.register(nib, forCellReuseIdentifier: "membersTableViewCell")
        membersTableView.delegate = self
        membersTableView.dataSource = self
    }
    
    
    private func getMembersList() {
        WaffleNetwork.request(with: memberUrl) { membersList in
            DispatchQueue.main.async {
                self.membersViewList = membersList
                for (index, member) in membersList.enumerated() {
                    self.teamsDict[member.team, default: []].append(index)
                }
                self.membersTableView.reloadData()
            }
        } failure: {
            print("오류발생")
        }

    }
    
    func moveToProfile(id: Int) {
        guard let controller = storyboard?.instantiateViewController(identifier: "profileViewController") as? ProfileViewController else { return }
        controller.profileId = id
//        let profileUrl = memberUrl + "\(id)"
//        WaffleNetwork.requestProfile(with: profileUrl) { (member) in
//            print(member)
//            controller.profileMember = member
//        } failure: {
//            print("error")
//        }
        
        navigationController?.pushViewController(controller, animated: true)
           
    }
    
}


extension MembersViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return teamsDict.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Array(teamsDict.keys)[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Array(teamsDict.values)[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index: Int = Array(teamsDict.values)[indexPath.section][indexPath.row]
        
        
        let cell = membersTableView.dequeueReusableCell(withIdentifier: "membersTableViewCell", for: indexPath)
        if let membersViewCell = cell as? MembersTableViewCell, let member = membersViewList?[index] {
            membersViewCell.name.text = member.name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index: Int = Array(teamsDict.values)[indexPath.section][indexPath.row]
        guard let id = membersViewList?[index].id else { return }
        moveToProfile(id: id)
    }
    
}
