//
//  ProfileViewController.swift
//  assignment2
//
//  Created by Joey Lee on 2021/09/22.
//

import UIKit

class ProfileViewController: UIViewController {
    var profileMember: Member?
    var profileId: Int?
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileTeam: UILabel!
    @IBOutlet weak var profileLecturesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileLecturesTableView.delegate = self
        profileLecturesTableView.dataSource = self
        let nib = UINib(nibName: "LecturesTableViewCell", bundle: nil)
        profileLecturesTableView.register(nib, forCellReuseIdentifier: "lecturesTableViewCell")

        // profileImage 동그랗게 만들기
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.height/2
        self.profileImageView.layer.borderWidth = 1
        self.profileImageView.layer.borderColor = UIColor.clear.cgColor
        self.profileImageView.clipsToBounds = true
        
        setProfileMember()

    }
    
    private func setProfileMember() {
        guard let id: Int = profileId else { return }
        let profileUrl = memberUrl + "\(id)"
        WaffleNetwork.requestProfile(with: profileUrl) { (member) in
            self.profileMember = member
            
            // request가 완료될 때까지 기다리게끔하는 방법을 못 찾아서 viewDidLoad에 넣는 대신 여기에 우겨넣었습니다...
            self.setProfileImageView()
            DispatchQueue.main.async {
                self.profileName.text = member.name
                self.profileTeam.text = member.team
                self.profileLecturesTableView.reloadData()
            }
        } failure: { NetworkError in
            let alert = UIAlertController(title: "Error", message: (NetworkError).getMessage(), preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .destructive, handler : nil)
            alert.addAction(defaultAction)
            self.present(alert, animated: false, completion: nil)
            return
        }
    }
    
    // set profile image
    private func setProfileImageView() {
        var data: Data?
        guard let member: Member = self.profileMember else { print("fuck!"); return }
        let url = URL(string: member.profile_image ?? "")
        do {
            data = try Data(contentsOf: url!)
        }
        catch { print("oops") }
        DispatchQueue.main.async {
            
            self.profileImageView.image = UIImage(data: data!)
        }
    }
    
    // 다음 뷰로 넘어가기
    func moveToLecture(lecture: Lecture) {
        guard let controller = storyboard?.instantiateViewController(identifier: "lectureViewController") as? LectureViewController else { return }
        controller.lecture = lecture
        
        navigationController?.pushViewController(controller, animated: true)
           
    }
}


extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileMember?.lectures?.count ?? 0
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = profileLecturesTableView.dequeueReusableCell(withIdentifier: "lecturesTableViewCell", for: indexPath)
        
        if let lectureCell = cell as? LecturesTableViewCell, let lecture = profileMember?.lectures?[indexPath.row] {
            lectureCell.name.text = lecture.course_title
            lectureCell.credit.text = String(lecture.credit) + "학점"
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let lecture = profileMember?.lectures?[indexPath.row] {
            moveToLecture(lecture: lecture)
        }
    }
    
}
