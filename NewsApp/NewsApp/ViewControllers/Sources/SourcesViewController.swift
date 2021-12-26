//
//  SourcesViewController.swift
//  NewsApp
//
//  Created by Emre on 24.12.2021.
//

import UIKit
import RxSwift
import RxCocoa

class SourcesViewController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!

    var sourcesViewModel = SourcesViewModel()
    let disposeBag = DisposeBag()
    var selectedCategories = [Category]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Kaynaklar"
        // Do any additional setup after loading the view.
        setupBindings()
        sourcesViewModel.requestData()
    }

    func setupBindings() {
        // Error Handling
        sourcesViewModel
            .error
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { error in
                self.alert.setMessage(error)
                self.alert.show()
            })
            .disposed(by: disposeBag)

        // Categories CollectionView
        Observable.from(optional: Category.allCases)
            .asObservable()
            .bind(to: collectionView
                    .rx
                    .items(cellIdentifier: "SourceCollectionViewCell", cellType: SourceCollectionViewCell.self)) { _, element, cell in
                cell.configure(with: element, self.selectedCategories.contains(element))
            }.disposed(by: disposeBag)

        var allSources = [Source]()
        sourcesViewModel.sources.subscribe(onNext: { sources in
            allSources = sources
          }).disposed(by: disposeBag)

        // Categories CollectionView Selections
        collectionView
            .rx
            .modelAndIndexSelected(Category.self)
            .subscribe(onNext: { [unowned self] model, indexPath in
                if let cell = self.collectionView.cellForItem(at: indexPath) as? SourceCollectionViewCell {
                    let isAlreadySelected = selectedCategories.contains(model)
                    cell.setSelected(!isAlreadySelected)
                    if !isAlreadySelected {
                        selectedCategories.append(model)
                    } else {
                        selectedCategories.removeAll { $0 == model }
                    }

                    sourcesViewModel.sources.onNext(allSources)
                }
            }).disposed(by: disposeBag)

        // For Categories CollectionView Animation
        collectionView
            .rx
            .willDisplayCell
            .subscribe(onNext: ({ cell, _ in
                cell.alpha = 0
                let transform = CATransform3DTranslate(CATransform3DIdentity, 0, -230, 0)
                cell.layer.transform = transform
                UIView.animate(withDuration: 0.9,
                               delay: 0,
                               usingSpringWithDamping: 0.7,
                               initialSpringVelocity: 0.5,
                               options: .curveEaseOut,
                               animations: {
                    cell.alpha = 1
                    cell.layer.transform = CATransform3DIdentity
                }, completion: nil)
            })).disposed(by: disposeBag)

        // Sources TableView
        sourcesViewModel
            .sources
            .map({ $0.filter { source in
                self.selectedCategories.isEmpty || self.selectedCategories.contains { $0 == source.category }
            }})
            .observe(on: MainScheduler.instance)
            .bind(to: tableView
                    .rx
                    .items(cellIdentifier: "SourceTableViewCell", cellType: SourceTableViewCell.self)) { _, element, cell in
                cell.configure(with: element)
            }
            .disposed(by: disposeBag)

        // Categories CollectionView Selections
        tableView
            .rx
            .modelSelected(Source.self)
            .subscribe(onNext: { [unowned self] model in
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                if let headlinesViewController = storyBoard.instantiateViewController(withIdentifier: "HeadlinesViewController")
                    as? HeadlinesViewController {
                    headlinesViewController.source = model
                    self.navigationController?.pushViewController(headlinesViewController, animated: true)
                }

                if let selectedRowIndexPath = self.tableView.indexPathForSelectedRow {
                    self.tableView.deselectRow(at: selectedRowIndexPath, animated: true)
                }
            }).disposed(by: disposeBag)
    }

}
