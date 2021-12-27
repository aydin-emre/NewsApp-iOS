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
            .map({ Array($0.suffix($0.count-3)) })
            .observe(on: MainScheduler.instance)
            .bind(to: tableView
                    .rx
                    .items(cellIdentifier: "HeadlinesTableViewCell", cellType: HeadlinesTableViewCell.self)) { _, element, cell in
                cell.configure(with: element)
            }
            .disposed(by: disposeBag)

        tableView
            .rx
            .willDisplayCell
            .subscribe(onNext: ({ cell, _ in
                (cell as? HeadlinesTableViewCell)?.checkArticles()
            })).disposed(by: disposeBag)

        // TableView HeaderView
        headlinesViewModel
            .articles
            .map({ Array($0.prefix(3)) })
            .subscribe(onNext: { articles in
                self.setHeaderView(with: articles)
            })
            .disposed(by: disposeBag)
    }

    func setHeaderView(with articles: [Article]) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let headlinesPageViewController = storyBoard.instantiateViewController(withIdentifier: "HeadlinesPageViewController")
            as? HeadlinesPageViewController {
            headlinesPageViewController.articles = articles

            let containerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 380))

            headlinesPageViewController.view.translatesAutoresizingMaskIntoConstraints = false
            addChild(headlinesPageViewController)
            containerView.addSubview(headlinesPageViewController.view)

            NSLayoutConstraint.activate([
                headlinesPageViewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                headlinesPageViewController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                headlinesPageViewController.view.topAnchor.constraint(equalTo: containerView.topAnchor),
                headlinesPageViewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
                ])

            headlinesPageViewController.didMove(toParent: self)

            tableView.tableHeaderView = containerView
        }
    }

}
