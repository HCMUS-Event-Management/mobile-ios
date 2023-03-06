//
//  File.swift
//  mobile
//
//  Created by NguyenSon_MP on 23/02/2023.
//

import Foundation


class LoginFirstScreenViewModel {
   
    private var username = "nson@gmail.com"
    private var password = "123456"
    
//    var userCurrentInfo:GetUserInfor?
    
    var eventHandler: ((_ event: Event) -> Void)? // Data Binding Closure

    func setUsername(username: String) {
        self.username = username
    }
    
    func setPassword(password: String) {
        self.password = password
    }
    
    func handelLogin() {
        self.eventHandler?(.loading)
        if(username.isEmpty || password.isEmpty) {
            // Thong bao
        } else {

            let params = InfoLogin(email: username, password: password)
            let parameter = try? APIManager.shared.encodeBody(value: params)
            
            APIManager.shared.request(modelType: ReponseLogin.self, type: UserEndPoint.login(infoLogin: params), params: parameter, completion: {
                result in
                self.eventHandler?(.stopLoading)
                switch result {
                    case .success(let info):
                    Contanst.userdefault.set(info.data?.accessToken, forKey: "userToken")
                    Contanst.userdefault.set(info.data?.refreshToken, forKey: "refreshToken")
                    if let encodedUser = try? JSONEncoder().encode(info.data?.getUserInfor) {
                            Contanst.userdefault.set(encodedUser, forKey: "userInfo")
                        }
//                        self.userCurrentInfo = info.data?.getUserInfor
                        self.eventHandler?(.dataLoaded)
                    case .failure(let error):
                        self.eventHandler?(.error(error))
                    }
            })
        }
    }
    
    
    func handelLogout() {
//        APIManager.shared.request(modelType: ReponseLogin.self, type: UserEndPoint.login(infoLogin: params), params: parameter, completion: {
//            result in
//            self.eventHandler?(.stopLoading)
//            switch result {
//                case .success(let info):
//                Contanst.userdefault.set(info.data?.accessToken, forKey: "userToken")
//                Contanst.userdefault.set(info.data?.refreshToken, forKey: "refreshToken")
//                if let encodedUser = try? JSONEncoder().encode(info.data?.getUserInfor) {
//                        Contanst.userdefault.set(encodedUser, forKey: "userInfo")
//                    }
////                        self.userCurrentInfo = info.data?.getUserInfor
//                    self.eventHandler?(.dataLoaded)
//                case .failure(let error):
//                    self.eventHandler?(.error(error))
//                }
//        })
    }
    
    

    
}



extension LoginFirstScreenViewModel {

    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error(Error?)
//        case newProductAdded(product: AddProduct)
    }

}
