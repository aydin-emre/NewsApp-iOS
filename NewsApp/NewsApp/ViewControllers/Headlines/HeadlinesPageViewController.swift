//
//  HeadlinesPageViewController.swift
//  NewsApp
//
//  Created by Emre on 26.12.2021.
//

import UIKit

class HeadlinesPageViewController: BaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!

    var slideViewWidth: CGFloat!
    var slideViewHeight: CGFloat!
    var slides: [UIView] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        slideViewWidth = self.view.frame.width
        slideViewHeight = self.view.frame.height

        scrollView.delegate = self

        setupViews()
    }

    func setupViews() {
        createSlides()

        setupSlideScrollView(slides: slides)

        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        view.bringSubviewToFront(pageControl)
    }

    func createSlides() {
//        if let newsView = Bundle.main.loadNibNamed("NewsView", owner: self, options: nil)?.first as? NewsView {
//            views.append(newsView)
//            views.append(newsView)
//        }
        slides.append(NewsView.fromNib())

        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 500, height: 200))
        headerView.backgroundColor = .red
        
        slides.append(headerView)
//        for image in images {
//            let tutorialView = Bundle.main.loadNibNamed("TutorialView", owner: self, options: nil)?.first as! TutorialView
//            tutorialView.imageView.image = image
//            views.append(tutorialView)
//        }
    }

    func setupSlideScrollView(slides: [UIView]) {
        scrollView.frame = CGRect(x: 0, y: 0, width: slideViewWidth, height: slideViewHeight)
        scrollView.contentSize = CGSize(width: slideViewWidth * CGFloat(slides.count), height: slideViewHeight)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.contentSize.height = 1.0

        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: slideViewWidth * CGFloat(i), y: 0, width: slideViewWidth, height: slideViewHeight)
            scrollView.addSubview(slides[i])
        }
    }

}

// MARK: - UIScrollViewDelegate

extension HeadlinesPageViewController: UIScrollViewDelegate {

    /*
     * default function called when view is scolled. In order to enable callback
     * when scrollview is scrolled, the below code needs to be called:
     * scrollView.delegate = self
     */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = Int(round(scrollView.contentOffset.x/view.frame.width))
        pageControl.currentPage = pageIndex
    }

}

extension UIView {
    class func fromNib(named: String? = nil) -> Self {
        let name = named ?? "\(Self.self)"
        guard
            let nib = Bundle.main.loadNibNamed(name, owner: nil, options: nil)
            else { fatalError("missing expected nib named: \(name)") }
        guard
            /// we're using `first` here because compact map chokes compiler on
            /// optimized release, so you can't use two views in one nib if you wanted to
            /// and are now looking at this
            let view = nib.first as? Self
            else { fatalError("view of type \(Self.self) not found in \(nib)") }
        return view
    }
}
