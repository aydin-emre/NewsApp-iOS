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

    var source: Source?
    var headlinesViewModel = HeadlinesViewModel()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = source?.name
        // Do any additional setup after loading the view.
        setupBindings()
        if let sourceId = source?.id {
            headlinesViewModel.requestData(with: sourceId)
        }
    }

    func setupBindings() {
        // Error Handling
        headlinesViewModel
            .error
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { error in
                self.alert.setMessage(error)
                self.alert.show()
            })
            .disposed(by: disposeBag)

        // Sources TableView
        headlinesViewModel
            .articles
            .observe(on: MainScheduler.instance)
            .bind(to: tableView
                    .rx
                    .items(cellIdentifier: "HeadlinesTableViewCell", cellType: HeadlinesTableViewCell.self)) { _, element, cell in
                cell.configure(with: element)
            }
            .disposed(by: disposeBag)
    }

    func setHeaderView() {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 500, height: 200))
        headerView.backgroundColor = .red
        tableView.tableHeaderView = headerView
    }
}

