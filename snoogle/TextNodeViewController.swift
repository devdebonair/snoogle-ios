//
//  ViewController.swift
//  CardTransition
//
//  Created by Vincent Moore on 2/19/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//

import UIKit
import IGListKit
import AsyncDisplayKit

class TextNodeViewController: ASViewController<ASCollectionNode> {

    let flowLayout: UICollectionViewFlowLayout
    
    let models = [
        "An example for attention capturing is a video game called Journey. I saw someone play this game a couple of years back and figured this would be a great example for attentional capture. I remembered the beautiful scenery and how the character in the game stood out from the backgrounds. In relation to the concept, this game most definitely had moments where it captured my attention",
        "Attentional capture occurs when stimulus salience causes an involuntary shift in attention. Salients such as these include sudden movements, alarms, unexpected ads and colors, etc. As long as it can capture your attention, it is a candidate for attentional capturing. A technical definition can be found in chapter six on page 126.",
        "Journey is a indie game developed by thatgamecompany. In the game the player controls a robed figure in a vast desert, traveling towards a mountain in the distance. The visual appearance of this game has won a plethora of awards. The visuals in this game are a form of attention capturing. The game does not direct the player in the direction he or she needs to go",
        "The picture above is a screenshot of one of the levels in the game. Your attention can’t help but focus on the player. The color of the character usually stands out against the background, drawing the player in and complimenting the immersion of the game",
        "The Flash is a popular TV series on The CW. It’s a show based on a superhero comic book character, The Flash, by DC Comics. The story follows Allen, a crime scene investigator that was given the power to run at super-human speed to fight villains",
        "Simply put, if you perceive motion and there is none, that is a case of illusory motion.",
        "During a famous scene in the critically rated movie Saving Private Ryan, Captain Miller undergoes brief hearing loss from a bomb that detonated in his vicinity. Grenades are loud enough for someone to experience noise-induced hearing loss. During the scene, Captain Miller cannot hear any of the artillery, bombs, or voices flaring throughout the battlefield. He is mildly disoriented and suffers from a constant ring in his ear.",
        "We experience sound every day in our lives. We hear these sounds from radio, television, traffic, crowds, etc. Consistent noise at 85 decibels are enough to cause hearing loss. For reference, a concert in a small auditorium, given enough exposure, can cause slight hearing loss. The example above illustrates this phenomenon. More details on this subject can be found on page 282 in chapter eleven of our textbook.",
        "In relation to our example, a grenade emits a loud bang upon detonation. This bang can reach noise levels between 170 to 180 decibels. As stated before, the human ear can only receive 85 decibels before damage comes into affect. These values vary based on length and range. In the case of Captain Miller, the grenade detonated in his vicinity. Once the grenade went off, he briefly lost his ability to hear.",
        "He could only hear the muffled noise of the atmosphere as the artillery fired and other bombs detonated around him. He could only hear a ring in his ear as his comrades mouthed orders and briefings on the current situation. This example is slightly erroneous. Grenades vary greatly based on make and model.",
        "In my recent video, when I was proposing potential solutions for the game's slow development, I mentioned the possibility of working with a company. During this part of the video, I portrayed companies as evil entities that would steal my profits, take full possession of Yandere Sim, and censor the game. This really wasn't fair, because not every company is like that.",
        "Some companies have a lot of bad stories associated with them, but other companies have a good reputation for being fair to developers and never screwing anyone over. Some companies don't want to do any more work than necessary, but other companies are known for providing lots of support to their partners, and for genuinely helping out in every way they can.",
        "Over the past week, I've spent a lot of time speaking with a developer/publisher that has experience developing games and also has experience working together with indie devs to help them finish their games. This company has a very good reputation, and their name has come up numerous times when I ask other developers to reccomend a good company to work with. We've been discussing the idea of becoming partners; they would develop the game and publish it, while I remain the lead designer / director / creative influence. We've spent hours talking over the phone and have exchanged a lot of e-mails, ironing out a fair contract. They're asking for a reasonable amount of profit share, they're not trying to take away my ownership of the game's intellectual property, and they have zero interest in censoring the game, as long as we don't get an Adults-Only rating, which I also want to avoid. They're involved with another game project that you have DEFINITELY heard of, which has a big overlap with Yandere Simulator's fanbase. On top of everything else, I get along really well with the CEO.",
        "Because of all of these factors, it is extremely likely that I will sign a contract and begin a partnership with this company. In the event that this happens, it simply won't be necessary for me to rely on volunteer programmer assistance, because the company will be hiring a full-time programmer to take care of that. Between asking you for assistance, or partnering with a company, letting them go through a hiring process to find the best programmer for the job, and paying that programmer to work full-time, I think I should go with the second option.",
        "Greetings. I hope you have recieved my email about me changing addresses. Now, let me get to the point: I\'d love to get to work as a programmer for the game.",
        "Now, let me get this straight: I am on a Raspberry Pi right now. It is my backup PC and my original had fried. So, I have ordered new parts for a rig, but I won't be able to get full steam in before April 17. As of now, I can do one thing: Start porting the game from Js to CSharp. I hope we can figure something out."
    ]
    
    init() {
        self.flowLayout = UICollectionViewFlowLayout()
        super.init(node: ASCollectionNode(collectionViewLayout: flowLayout))

        node.delegate = self
        node.dataSource = self
        node.registerSupplementaryNode(ofKind: UICollectionElementKindSectionHeader)
        
        flowLayout.sectionHeadersPinToVisibleBounds = true
        flowLayout.headerReferenceSize = CGSize(width: node.bounds.width, height: 62)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        let width: CGFloat = node.frame.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right
        let max = CGSize(width: width, height: CGFloat(FLT_MAX))
        let min = CGSize(width: width, height: 0.0)
        return ASSizeRange(min: min, max: max)
    }
    
    override func viewDidLoad() {
        node.frame.size.height = 500
        print(node.frame.size.height)
        super.viewDidLoad()
        node.backgroundColor = .white
        node.view.bounces = false
        print(node.frame.size)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .white
        print(navigationController)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension TextNodeViewController: ASCollectionDelegate, ASCollectionDataSource {
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 1
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        let text = models[indexPath.row]
        return { _ -> ASCellNode in
            let cell = TextCell(text: text)
            if indexPath.row == 0 {
                cell.inset.top = 10
            }
            return cell
        }
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> ASCellNode {
        let header = Header(text: "Boku No Hero Academia")
        header.backgroundColor = .white
        return header
    }
}

extension TextNodeViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return node.view.contentOffset.y == 0 ? true : false
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

