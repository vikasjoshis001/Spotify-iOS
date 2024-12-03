//
//  AlbumViewController.swift
//  Spotify-Clone
//
//  Created by Vikas Joshi on 28/11/24.
//

import UIKit

// MARK: - AlbumViewController

class AlbumViewController: UIViewController {
    private var collectionView: UICollectionView = .init(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout { _, _ -> NSCollectionLayoutSection? in
            AlbumViewController.createSectionLayout()
        })
            
    private let album: Album
    
    private var viewModel: [RecommendedTracksCellViewModel] = []
    
    init(album: Album) {
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = album.name
        view.addSubview(collectionView)
        collectionView.register(RecommendedTrackCollectionViewCell.self, forCellWithReuseIdentifier: Constants.RECOMMENDED_TRACK)
        collectionView.register(PlaylistHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Constants.PLAYLIST_HEADER)
        collectionView.backgroundColor = UIColor.black
        collectionView.delegate = self
        collectionView.dataSource = self
        fetchAlbums()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func fetchAlbums() {
        APICaller.shared.getAlbums(albumId: album.id) { [weak self] response in
            switch response {
                case .success(let model):
                    DispatchQueue.main.async {
                        self?.viewModel = model.tracks.items.compactMap {
                            RecommendedTracksCellViewModel(name: $0.name,
                                                           artistName: $0.artists.first?.name ?? "-",
                                                           artworkURL: URL(string: $0.album?.images.first?.url ?? ""))
                        }
                        self?.collectionView.reloadData()
                    }
                case .failure(let error):
                    debugPrint(error.localizedDescription)
            }
        }
    }
            
    private static func createSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 2, bottom: 1, trailing: 2)
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(60)),
            subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalWidth(1)),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
        ]
        return section
    }
}

// MARK: UICollectionViewDataSource, UICollectionViewDelegate

extension AlbumViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Constants.RECOMMENDED_TRACK,
            for: indexPath) as? RecommendedTrackCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        cell.backgroundColor = .lightGray
        cell.configure(with: viewModel[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.PLAYLIST_HEADER, for: indexPath) as? PlaylistHeaderCollectionReusableView, kind == UICollectionView.elementKindSectionHeader
        else {
            return UICollectionReusableView()
        }
        
        let headerViewModel = PlaylistHeaderViewModel(name: album.name,
                                                      ownerName: album.artists.first?.name ?? "-",
                                                      description: "Release Date: \(String.formattedDate(string: album.release_date))",
                                                      artworkURL: URL(string: album.images.first?.url ?? ""))
        header.configure(with: headerViewModel)
        header.delegate = self
        return header
    }
}

// MARK: PlaylistHeaderCollectionReusableViewDelegate

extension AlbumViewController: PlaylistHeaderCollectionReusableViewDelegate {
    func PlaylistHeaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView) {
        debugPrint("Playing all tracks in album")
    }
}
