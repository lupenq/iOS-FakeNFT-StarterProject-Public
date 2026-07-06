final class ServicesAssembly {

    private let networkClient: NetworkClient
    private let nftStorage: NftStorage

    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
    }

    var nftService: NftService {
        NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage
        )
    }

    var collectionService: CollectionService {
        CollectionServiceImpl(
            networkClient: networkClient,
            nftService: nftService
        )
    }

    var orderService: OrderService {
        OrderServiceImpl(networkClient: networkClient)
    }

    var profileService: ProfileService {
        ProfileServiceImpl(networkClient: networkClient)
    }

    var userService: UserService {
        UserServiceImpl(networkClient: networkClient)
    }
}
