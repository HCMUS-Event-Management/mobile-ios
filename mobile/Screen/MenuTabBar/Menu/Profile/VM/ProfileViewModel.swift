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
        if((Contanst.userdefault.object(forKey: "userInfoDetail") == nil)) {
            print(Contanst.userdefault.object(forKey: "userInfoDetail"))
            APIManager.shared.request(modelType: Json4Swift_Base.self, type: UserEndPoint.profile, params: nil, completion: {
                result in
                self.eventHandler?(.stopLoading)
                switch result {
                case .success(let profile):
                    self.userInfoDetail = profile.data?.userProfile
                    if let encodedUserDetail = try? JSONEncoder().encode(profile.data?.userProfile) {
                        Contanst.userdefault.set(encodedUserDetail, forKey: "userInfoDetail")
                    }
                    self.eventHandler?(.dataLoaded)
                case .failure(let error):
                    self.eventHandler?(.error(error))
                    
                }
            })
        } else {
            if let savedUserData = Contanst.userdefault.object(forKey: "userInfoDetail") as? Foundation.Data {
                let decoder = JSONDecoder()
                if let savedUser = try? decoder.decode(UserProfile.self, from: savedUserData) {
                    self.eventHandler?(.stopLoading)
                    self.userInfoDetail = savedUser
                    self.eventHandler?(.dataLoaded)
                    return
                }
            }
        }
        
        
    }
    
    func updateUserDetail() {
        self.eventHandler?(.loading)
        
        let params = UpdateProfile(fullname: "Nguyen Son", phone: "0779444111", birthday: "2001-11-18T04:05:06.000Z", identityCard: "0779444111", gender: "Nam", avatar: "url/web/jpg", address: "HCM City", isDeleted: true)
        let parameter = try? APIManager.shared.encodeBody(value: params)
        
        APIManager.shared.request(modelType: ReponseCommon.self, type: UserEndPoint.updateProfile, params: parameter, completion: {
            result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                self.eventHandler?(.error(error))
            }
            
        })
    }
    
    func logout() {
        self.eventHandler?(.loading)
        APIManager.shared.request(modelType: ReponseCommon.self, type: UserEndPoint.logout, params: nil, completion: {
            result in
            self.eventHandler?(.stopLoading)
            switch result {
            case .success(let data):
                self.eventHandler?(.logout)
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
        case logout
//        case newProductAdded(product: AddProduct)
    }

}
