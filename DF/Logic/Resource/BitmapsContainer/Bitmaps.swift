//
//  Bitmaps.swift
//  Bitmaps
//
//  Created by Wilhelm Oks on 27.08.21.
//

import Foundation

public final class Bitmaps: IResourceContainer {
    public private(set) var tiles: Tiles!
    public private(set) var hud: HudBitmaps!
    public private(set) var treesTest: SpriteSheet!
    public private(set) var entities: EntityBitmaps!
    public private(set) var items: ItemBitmaps!
    public private(set) var effects: EffectBitmaps!
    public private(set) var markers: MarkerBitmaps!
    
    public init() {}
    
    public func load(resourceCreator: IResourceCreator, fileSystem: IFileSystem) async {
        let path = fileSystem.graphicsDirectory()
        
        async let treesTestBitmap = resourceCreator.createBitmap(from: "\(path)/trees_test.png")
        let treesTestRegions: [SpriteSheet.Region] = [
            SpriteSheet.Region(0,0,127,145,63,125),
            SpriteSheet.Region(127,0,127+123,145,185,125),
            SpriteSheet.Region(127+123,0,127+123+102,145,300,125),
            SpriteSheet.Region(5,148,117,277,59,252),
            SpriteSheet.Region(137,146,232,276,186,258),
            SpriteSheet.Region(255,155,342,277,294,259),
        ]
        
        (
            tiles,
            hud,
            treesTest,
            entities,
            items,
            effects,
            markers
        ) = await (
            .load(resourceCreator: resourceCreator, fileSystem: fileSystem),
            .load(resourceCreator: resourceCreator, fileSystem: fileSystem),
            SpriteSheet(bitmap: treesTestBitmap, regions: treesTestRegions),
            .load(resourceCreator: resourceCreator, fileSystem: fileSystem),
            .load(resourceCreator: resourceCreator, fileSystem: fileSystem),
            .load(resourceCreator: resourceCreator, fileSystem: fileSystem),
            .load(resourceCreator: resourceCreator, fileSystem: fileSystem)
        )
    }
}
