//
//  VideoCollectionController.swift
//  snoogle
//
//  Created by Vincent Moore on 8/25/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import UIKit

class VideoCollectionController: ASViewController<CellNodeVideoPlayer> {
    init() {
        let videoURL = URL(string: "https://r6---sn-hp57kn6l.googlevideo.com/videoplayback?signature=CB1A7BBB612D33034B283F58D59D1DE9F5117673.0DE5F92DE90993090E93B93091A7BCD612B2C14E&ratebypass=yes&key=yt6&lmt=1502366353044529&itag=22&mm=31&mn=sn-hp57kn6l&id=o-AOuIY2DNzFbjqI0pmEKJoells1AQBK8ygqCS1DDJl81a&mime=video%2Fmp4&pl=52&gcr=us&ipbits=0&ip=2602%3A306%3A8065%3A2680%3A2853%3Af655%3A915a%3Ad822&requiressl=yes&mt=1503837760&mv=m&ms=au&dur=119.977&initcwndbps=1068750&ei=sr6iWdbvBYOTuwWzo6aIDg&expire=1503859474&sparams=dur%2Cei%2Cgcr%2Cid%2Cinitcwndbps%2Cip%2Cipbits%2Citag%2Clmt%2Cmime%2Cmm%2Cmn%2Cms%2Cmv%2Cpl%2Cratebypass%2Crequiressl%2Csource%2Cexpire&source=youtube")
        let posterURL = URL(string: "https://i.ytimg.com/vi/jKMES2-HDCQ/maxresdefault.jpg")
        let movie = Movie()
        movie.height = 720
        movie.width = 1280
        movie.url = videoURL
        movie.poster = posterURL
        let player = CellNodeVideoPlayer(media: movie, didLoad: nil)
        super.init(node: player)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
    }
}
