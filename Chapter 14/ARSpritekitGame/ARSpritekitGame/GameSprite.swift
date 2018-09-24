import SpriteKit

protocol GameSprite {
    var textureAtlas:SKTextureAtlas { get set }
    var initialSize: CGSize { get set }
}
