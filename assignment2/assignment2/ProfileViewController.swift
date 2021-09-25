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
    //    let profileURL: String = memberUrl + "\(self.profileId)"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileLecturesTableView.delegate = self
        profileLecturesTableView.dataSource = self
        let nib = UINib(nibName: "LecturesTableViewCell", bundle: nil)
        profileLecturesTableView.register(nib, forCellReuseIdentifier: "lecturesTableViewCell")
        
//        guard let id: Int = profileId else { return }
//        let profileUrl = memberUrl + "\(id)"
//        WaffleNetwork.requestProfile(with: profileUrl) { (member) in
//            self.profileMember = member
//            print(self.profileMember)
//        } failure: {
//            print("error")
//        }


        
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.height/2
        self.profileImageView.layer.borderWidth = 1
        self.profileImageView.layer.borderColor = UIColor.clear.cgColor
        self.profileImageView.clipsToBounds = true
        
        setProfileMember()
//        setProfileImageView()
        // Do any additional setup after loading the view.
    }
    
    private func setProfileMember() {
        guard let id: Int = profileId else { return }
        let profileUrl = memberUrl + "\(id)"
        WaffleNetwork.requestProfile(with: profileUrl) { (member) in
            self.profileMember = member
            self.setProfileImageView()
            DispatchQueue.main.async {
                self.profileLecturesTableView.reloadData()
            }
        } failure: {
            print("error")
        }
    }
    
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
        if let lecture = profileMember?.lectures?[indexPath.row] {
            moveToLecture(lecture: lecture)
        }
    }
    
}
