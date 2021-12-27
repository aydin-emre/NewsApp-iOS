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

    public var articles = [Article]()
    private var slideViewWidth: CGFloat!
    private var slideViewHeight: CGFloat!
    private var slides = [UIView]()
    let newsViewHeight: CGFloat = 350
    var timer: Timer?
    var currentPage = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        slideViewWidth = self.view.frame.width
        slideViewHeight = self.view.frame.height

        scrollView.delegate = self

        setupViews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(updatePager), userInfo: nil, repeats: true)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer?.invalidate()
        timer = nil
    }

    func setupViews() {
        createSlides()

        setupSlideScrollView(slides: slides)

        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        view.bringSubviewToFront(pageControl)
    }

    func createSlides() {
        for article in articles {
            let newsView = NewsView(frame: CGRect(x: 0, y: 0, width: slideViewWidth, height: newsViewHeight))
            newsView.article = article
            slides.append(newsView)
        }
    }

    func setupSlideScrollView(slides: [UIView]) {
        scrollView.frame = CGRect(x: 0, y: 0, width: slideViewWidth, height: newsViewHeight)
        scrollView.contentSize = CGSize(width: slideViewWidth * CGFloat(slides.count), height: newsViewHeight)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.contentSize.height = 1.0

        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: (slideViewWidth * CGFloat(i)) + 20, y: 0, width: slideViewWidth - 40, height: newsViewHeight)
            scrollView.addSubview(slides[i])
        }
    }

    @objc func updatePager() {
        (currentPage == slides.count - 1) ? (currentPage = 0) : (currentPage += 1)
        var frame = scrollView.frame
        frame.origin.x = frame.size.width * CGFloat(currentPage)
        scrollView.scrollRectToVisible(frame, animated: true)
        pageControl.currentPage = currentPage
    }

}

// MARK: - UIScrollViewDelegate

extension HeadlinesPageViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = Int(round(scrollView.contentOffset.x/view.frame.width))
        pageControl.currentPage = pageIndex
    }

}
