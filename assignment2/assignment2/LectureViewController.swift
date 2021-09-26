//
//  LectureViewController.swift
//  assignment2
//
//  Created by Joey Lee on 2021/09/24.
//

import UIKit

class LectureViewController: UIViewController {
    
    var lecture: Lecture?

    @IBOutlet weak var course_title: UILabel!
    @IBOutlet weak var department: UILabel!
    @IBOutlet weak var credit: UILabel!
    @IBOutlet weak var classification: UILabel!
    @IBOutlet weak var course_number: UILabel!
    @IBOutlet weak var academic_year: UILabel!
    @IBOutlet weak var instructor: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let unwrappedLecture: Lecture = lecture else { return }
        self.course_title.text = unwrappedLecture.course_title
        self.department.text = unwrappedLecture.department
        self.credit.text = String(unwrappedLecture.credit) + "학점"
        self.classification.text = unwrappedLecture.classification
        self.course_number.text = unwrappedLecture.course_number
        self.academic_year.text = unwrappedLecture.academic_year
        self.instructor.text = unwrappedLecture.instructor

        

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
