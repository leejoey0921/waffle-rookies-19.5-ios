//
//  ViewController.swift
//  assignment2
//
//  Created by Joey Lee on 2021/09/22.
//

import UIKit

class MembersViewController: UIViewController {
    var membersViewList: [Member]?
    
    var teamsDict: [String: [Int]] = [:] // 팀: [팀원 id] 형태로 저장
    
    var membersViewListCount: Int {
        return membersViewList?.count ?? 0
    }
    
    @IBOutlet weak var membersTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMembersTableView()
        getMembersList()
    }
    
    // tableview 설정
    private func setMembersTableView() {
        let nib = UINib(nibName: "MembersTableViewCell", bundle: nil)
        membersTableView.register(nib, forCellReuseIdentifier: "membersTableViewCell")
        membersTableView.delegate = self
        membersTableView.dataSource = self
    }
    
    
    // API call 보내기
    private func getMembersList() {
        WaffleNetwork.requestMembers(with: memberUrl) { membersList in
            DispatchQueue.main.async {
                self.membersViewList = membersList
                for (index, member) in membersList.enumerated() {
                    self.teamsDict[member.team, default: []].append(index)
                }
                self.membersTableView.reloadData()
            }
        } failure: { NetworkError in
            let alert = UIAlertController(title: "Error", message: (NetworkError).getMessage(), preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .destructive, handler : nil)
            alert.addAction(defaultAction)
            self.present(alert, animated: false, completion: nil)
            return
        }
    }
    
    // 다음 뷰로 넘어가기
    func moveToProfile(id: Int) {
        guard let controller = storyboard?.instantiateViewController(identifier: "profileViewController") as? ProfileViewController else { return }
        controller.profileId = id
        
        navigationController?.pushViewController(controller, animated: true)
    }
}


extension MembersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return teamsDict.count
    }
    
    // team명으로 title 설정
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Array(teamsDict.keys)[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Array(teamsDict.values)[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index: Int = Array(teamsDict.values)[indexPath.section][indexPath.row] // 해당 member의 id 불러오기
        
        let cell = membersTableView.dequeueReusableCell(withIdentifier: "membersTableViewCell", for: indexPath)
        if let membersViewCell = cell as? MembersTableViewCell, let member = membersViewList?[index] {
            membersViewCell.name.text = member.name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let index: Int = Array(teamsDict.values)[indexPath.section][indexPath.row]
        guard let id = membersViewList?[index].id else { return }
        moveToProfile(id: id)
    }
    
}
