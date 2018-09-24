import SpriteKit

class Bat: SKSpriteNode, GameSprite {
    var initialSize = CGSize(width: 44, height: 24)
    var textureAtlas:SKTextureAtlas = SKTextureAtlas(named: "Enemies")
    var flyAnimation = SKAction()
    
    init() {
        super.init(texture: nil, color: UIColor.clear, size: initialSize)

        createAnimations()
        self.run(flyAnimation)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createAnimations() {
        let flyFrames:[SKTexture] = [
            textureAtlas.textureNamed("bat"),
            textureAtlas.textureNamed("bat-fly")
        ]
        let flyAction = SKAction.animate(with: flyFrames,
            timePerFrame: 0.12)
        flyAnimation = SKAction.repeatForever(flyAction)
    }
    

}
