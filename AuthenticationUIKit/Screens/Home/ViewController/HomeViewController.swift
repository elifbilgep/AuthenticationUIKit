//
//  HomeViewController.swift
//  AuthenticationUIKit
//
//  Created by Elif Parlak on 4.01.2025.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    //MARK: Section
    enum Section {
        case main
    }
    
    //MARK: Typealias
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, UserData>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, UserData>
    
    //MARK: Properties
    private var viewModel: HomeViewModel
    private var appManager = AppManager.shared
    private let homeView = HomeView()
    private var cancellables: Set<AnyCancellable> = []
    private var dataSource: DataSource!
    
    //MARK: View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDataSource()
        setupBindings()
        setupViewController()
        fetchUsers()
        
    }
    
    //MARK: Init
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI () {
        setupNavBar()
    }
    
    override func loadView() {
        super.loadView()
        view = homeView
    }
    
    //MARK: Setup View Controller
    private func setupViewController() {
        homeView.collectionView.register(HomeViewCollectionViewCell.self, forCellWithReuseIdentifier: HomeViewCollectionViewCell.identifier
        )
        homeView.collectionView.delegate = self
    }
    
    //MARK: Setup Bindings
    private func setupBindings() {
        viewModel
            .$users
            .sink { [weak self] users in
                guard let self else { return }
                self.updateSnapshot(with: users)
            }
            .store(in: &cancellables)
    }
    
    private func setupDataSource() {
        dataSource = DataSource(
            collectionView: homeView.collectionView,
            cellProvider: {  [weak self] collectionView, indexPath, userData in
                guard let self else { return nil }
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewCollectionViewCell.identifier, for: indexPath) as? HomeViewCollectionViewCell else { return nil }
                cell.configureCell(username: userData.userName, email: userData.email)
                return cell
            })
    }
    
    //MARK: Update Snapshot
    private func updateSnapshot(with users: [UserData], animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(users)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    //MARK: Fetch Users
    private func fetchUsers() {
        Task { [weak self] in
            guard let self else { return }
            let result = try await viewModel.fetchUsers()
            switch result {
            case .success(_):
                print("✅ Users fetched successfully! \(viewModel.users)")
            case .failure(let failure):
                self.presentAlert(title: "Something went wrong!", message: failure.localizedDescription, buttonTitle: "Ok")
            }
        }
    }
    
    //MARK: Setup Nav Bar
    private func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Users"
    
    }
    
    //MARK: Deinit
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

//MARK: UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    
}
