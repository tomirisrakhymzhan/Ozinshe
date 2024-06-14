//
//  Urls.swift
//  Ozinshe
//
//  Created by Томирис Рахымжан on 13/06/2024.
//

import Foundation
class Urls {
    static let BASE_URL = "http://api.ozinshe.com/core/V1/"
    
    static let SIGN_IN_URL = "http://api.ozinshe.com/auth/V1/signin"
    static let FAVORITE_URL = BASE_URL + "favorite/"
    static let SIGN_UP_URL = "http://api.ozinshe.com/auth/V1/signup"
    static let CATEGORY_URL = BASE_URL + "categories"
    static let MOVIE_BY_CATEGORY_URL = BASE_URL + "movies/page"
    static let SEARCH_MOVIE_URL = BASE_URL + "movies/search"
    static let MOVIE_MAIN_URL = BASE_URL + "movies/main"
    static let MAIN_BANNER_URL = BASE_URL + "movies_main"
    static let USER_HISTORY_URL = BASE_URL + "history/userHistory"
    static let AGE_CATEGORY_URL = BASE_URL + "category-ages"
    static let GENRE_CATEGORY_URL = BASE_URL + "genres"
    static let GET_SIMILAR = BASE_URL + "movies/similar/"
    static let GET_SEASONS = BASE_URL + "seasons/"
    static let CHANGE_PASSWORD = BASE_URL + "user/profile/changePassword"
    static let UPDATE_PROFILE = BASE_URL + "user/profile/"
    static let GET_PROFILE = BASE_URL + "user/profile"
}
