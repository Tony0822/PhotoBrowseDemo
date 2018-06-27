//
//  Photo.m
//  PhotoBrowse
//
//  Created by gaochongyang on 2018/6/25.
//  Copyright © 2018年 gaochongyang. All rights reserved.
//

#import "Photo.h"
#import "PYPhotoBrowserConst.h"

@implementation Photo

- (instancetype)init {
    self = [super init];
    if (self) {
        self.progress = 0.0;
        self.verticalWidth = PYScreenW;
    }
    return self;
}

+ (instancetype)photoWithThumbnailURL:(NSString *)thumbnailURL {
    Photo *photo = [[Photo alloc] init];
    photo.thumbnailURL = thumbnailURL;
    return photo;
}

+ (instancetype)photoWithOriginalURL:(NSString *)OriginalURL {
    Photo *photo = [[Photo alloc] init];
    photo.originalURL = OriginalURL;
    return photo;
}

@end
