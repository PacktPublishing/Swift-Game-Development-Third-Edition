import SpriteKit

class MadFly: SKSpriteNode, GameSprite {
    var initialSize = CGSize(width: 61, height: 29)
    var textureAtlas:SKTextureAtlas =
        SKTextureAtlas(named: "Enemies")
    var flyAnimation = SKAction()
    
    init() {
        super.init(texture: nil, color: UIColor.clear,
            size: initialSize)

        createAnimations()
        self.run(flyAnimation)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createAnimations() {
        let flyFrames:[SKTexture] = [
            textureAtlas.textureNamed("madfly"),
            textureAtlas.textureNamed("madfly-fly")
        ]
        
        let flyAction = SKAction.animate(with: flyFrames,
            timePerFrame: 0.14)
        flyAnimation = SKAction.repeatForever(flyAction)
    }

}
