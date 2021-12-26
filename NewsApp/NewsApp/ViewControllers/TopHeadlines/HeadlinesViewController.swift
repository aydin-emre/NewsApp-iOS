//
//  HeadlinesViewController.swift
//  NewsApp
//
//  Created by Emre on 26.12.2021.
//

import UIKit
import RxSwift
import RxCocoa

class HeadlinesViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!

    var headlinesViewModel = HeadlinesViewModel()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupBindings()
        headlinesViewModel.requestData()
    }

    func setupBindings() {
        
    }

}
