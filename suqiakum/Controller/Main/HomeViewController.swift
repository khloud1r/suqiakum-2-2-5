 
 import UIKit
 
 protocol ProductDetailDelegate {
    func goToDetails(company: Company)
 }
 
 class HomeViewController: BaseViewController, ProductDetailDelegate {
    
    // MARK :- Instance
    static func instance () -> HomeViewController {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
    }
    
    // MARK :- Outlets
    @IBOutlet weak var sliderCV: UICollectionView!
    @IBOutlet weak var homeTV: UITableView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    // MARK :- Instance Variables
    var companyArray = [Company]()
    var specialCompanyArray = [Company]()
    var sliderArray = [Slider]()
    
    var timer = Timer()
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCompanies()
        loadImages()
    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        timer
//    }
//
    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
    }
    
    func goToDetails(company: Company) {
        let detailsVC = DetailsViewController.instance()
        detailsVC.item = company
        present(detailsVC, animated: true, completion: nil)
    }
    
    func loadImages(){
        NetworkApi.sendRequest(method: .get, url: SLIDER, completion: {(err,status,response: SliderResponse?) in
            if err == nil{
                if status!{
                    guard let data = response?.data else{return}
                    self.pageControl.numberOfPages = data.count
                    self.sliderArray = data
                    DispatchQueue.main.async {
                        self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
                    }
                    self.sliderCV.reloadData()
                }
            }
        })
    }
    
    func loadCompanies(){
        self.showLoadingIndicator()
        NetworkApi.sendRequest(method: .get, url: GET_COMPANIES, completion: {(err,status,response: CompainesResponse?) in
            self.hideLoadingIndicator()
            if err == nil{
                if status!{
                    guard let data = response?.data else{return}
                    self.companyArray = data.companies
                    self.specialCompanyArray = data.specail_companies
                    self.homeTV.reloadData()
                }
            }
        })
    }
    
    @objc func changeImage() {
        print(counter)
        if counter < sliderArray.count {
            self.pageControl.currentPage = counter
            let index = IndexPath.init(item: counter, section: 0)
            self.sliderCV.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            counter += 1
        } else {
            counter = 0
            self.pageControl.currentPage = counter
            let index = IndexPath.init(item: counter, section: 0)
            self.sliderCV.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            counter = 1
        }
        
    }
    
 }
 
 extension HomeViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sliderArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = sliderCV.dequeueReusableCell(withReuseIdentifier: "cellslider", for: indexPath)
        if let vc = cell.viewWithTag(111) as? UIImageView {
            if let img = self.sliderArray[indexPath.row].image {
                vc.setImage(imageUrl: img)
            }
        }
        return cell
    }
    
 }
 
 extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = sliderCV.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
 }
 
 extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = homeTV.dequeueReusableCell(withIdentifier: "SpecialCompanyTVC", for: indexPath) as! SpecialCompanyTVC
            cell.specialCompaniesCV.registerCellNib(cellClass: CompanyCVC.self)
            cell.specialCompanyArray = self.specialCompanyArray
            cell.specialCompaniesCV.reloadData()
            return cell
        }else {
            let cell = homeTV.dequeueReusableCell(withIdentifier: "CompanyTVC", for: indexPath) as! CompanyTVC
            cell.companiesCV.registerCellNib(cellClass: CompanyCVC.self)
            cell.companyArray = self.companyArray
            cell.delegate = self
            cell.companiesCV.reloadData()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 145
        }else{
            let rowCount = Double(self.companyArray.count / 3)
            return CGFloat(round(rowCount + 1) * 155)
        }
    }
    
 }
