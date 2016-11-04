//
//  Post.swift
//  pi-chan2
//
//  Created by Kensuke Hoshikawa on 2016/11/04.
//  Copyright © 2016年 star__hoshi. All rights reserved.
//

import Foundation
import ObjectMapper

class Post: Mappable {
    var number: Int = 0
    var name: String = ""
    var fullName: String = ""
    var wip: Bool = false
    var bodyMd: String = ""
    var bodyHtml: String = ""
    var createdAt: String = ""
    var message: String = ""
    var url: URL = URL.defaultUrl()
    var updatedAt: String = ""
    var tags: [String]?
    var category: String?
    var revisionNumber: Int = 0
    // var createdBy: CreatedBy =
    // var updatedBy: UpdatedBy
    // var kind: Kind
    var commentsCount: Int = 0
    var tasksCount: Int = 0
    var doneTasksCount: Int = 0
    var stargazersCount: Int = 0
    var watchersCount: Int = 0
    var star: Bool = false
    var watch: Bool = false
    // var sharingUrls: SharingUrls?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        number <- map["number"]
        name <- map["name"]
        fullName <- map["full_name"]
        wip <- map["wip"]
        bodyMd <- map["body_md"]
        bodyHtml <- map["body_html"]
        createdAt <- map["created_at"]
        message <- map["message"]
        url <- map["url"]
        updatedAt <- map["updated_at"]
        tags <- map["tags"]
        category <- map["category"]
        revisionNumber <- map["revision_number"]
        // createdBy <- map["id"]
        // updatedBy <- map["id"]
        // kind <- map["id"]
        commentsCount <- map["comments_count"]
        tasksCount <- map["tasks_count"]
        doneTasksCount <- map["done_tasks_count"]
        stargazersCount <- map["stargazers_count"]
        watchersCount <- map["watchers_count"]
        star <- map["star"]
        watch <- map["watch"]
    }
}