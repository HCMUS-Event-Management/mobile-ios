//
//  ProfileAccountViewModel.swift
//  mobile
//
//  Created by NguyenSon_MP on 04/03/2023.
//

import Foundation


final class ProfileViewModel {
    var userInfo: GetUserInfor?
    var userInfoDetail: UserProfile?

    var eventHandler: ((_ event: Event) -> Void)? // Data Binding Closure
    
    func getUser() {
            if let savedUserData = Contanst.userdefault.object(forKey: "userInfo") as? Foundation.Data {
                let decoder = JSONDecoder()
                if let savedUser = try? decoder.decode(GetUserInfor.self, from: savedUserData) {
                    self.eventHandler?(.stopLoading)
                    userInfo = savedUser
                    self.eventHandler?(.dataLoaded)
                    return
                }
            }
    }
    
    func fetchUserDetail() {
        self.eventHandler?(.loading)

        APIManager.shared.request(modelType: Json4Swift_Base.self, type: UserEndPoint.profile, params: nil, completion: {
            result in
            self.eventHandler?(.stopLoading)
            switch result {
            case .success(let profile):
                self.userInfoDetail = profile.data?.userProfile
                self.eventHandler?(.dataLoaded)
            case .failure(let error):
                self.eventHandler?(.error(error))
                
            }
        })
        
    }
    
    
}

extension ProfileViewModel {

    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error(Error?)
//        case newProductAdded(product: AddProduct)
    }

}
