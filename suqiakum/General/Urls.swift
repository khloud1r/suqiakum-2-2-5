//
//  Urls.swift
//  suqiakum
//
//  Created by hany karam on 3/2/20.
//  Copyright © 2020 hany karam All rights reserved.
//

import Foundation
     
    let baseUrl = "https://test.otc.net.sa/api/"
    let login                 = baseUrl + "users/login"
    let register              = baseUrl + "users/register"
    let resetPassword         = baseUrl + "reset_password"
    let activite              = baseUrl + "users/activate"
    let ResendActivation      = baseUrl + "users/resend_token"
    let cart                  = baseUrl + "users/cart"
    let emptyCart             = cart + "/empty"
    let decreaseCart          = baseUrl + "users/cart/decrease"
    let ORDER_URL             = baseUrl + "users/orders/store"
    let totalPrice            = baseUrl + "users/orders/get_total_price"
    let COPOUN_URL            = baseUrl + "users/copouns/check"
    let updateProfile         = baseUrl + "users/update"
    let Profile               = baseUrl + "users/profile"
    let getAddress            = baseUrl + "users/addresses?"
    let address               = baseUrl + "users/addresses"
    let support               = baseUrl + "supports"
    let AVAILABLE_TIMES       = baseUrl + "users/orders/create"
    let MAKE_DEFAULT          = address + "/make_default"
    let GET_COMPANIES         = baseUrl + "companies"
    let GET_PRODUCTS          = baseUrl + "companies/products/"
    let FORGET_PASSWORD       = baseUrl + "users/request_token"
    let GET_WHISHLIST         = baseUrl + "users/wishlist?"
    let WHISHLIST             = baseUrl + "users/wishlist"
    let COMPLETE_PROFILE      = baseUrl + "users/complete_profile"
    let SEARCH                = baseUrl + "products/search"
    let SLIDER                = baseUrl + "sliders"
    let authentication = ["Authorization": "Bearer\(NetworkHelper.getAccessToken() ?? "" )"]

