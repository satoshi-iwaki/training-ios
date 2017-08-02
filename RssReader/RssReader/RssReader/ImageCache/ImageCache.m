/*!
 *@file		ImageCache.m
 *@brief	ImageCache実装ファイル
 *@author	Satoshi Iwaki
 *@date		2013/05/16
 */

#import "ImageCache.h"

@implementation ImageCache

@synthesize defaultImage;

//*********** Singleton pattern ***********

static id _sharedInstance = nil;

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

+ (void)deleteInstance
{
    _sharedInstance = nil;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

//*********** Singleton pattern ***********

/*!
 *@brief		初期化処理
 *@return       シングルトンインスタンス
 */
- (instancetype)init
{
    self = [super init];
    if (self) {
        cache = [[NSCache alloc] init];
        operationQueue = [[NSOperationQueue alloc] init];
        [operationQueue setMaxConcurrentOperationCount:1];
        defaultImage = [[UIImage imageNamed:@"no_image.png"] stretchableImageWithLeftCapWidth:16 topCapHeight:16];
    }
    return self;
}

/*!
 *@brief		メモリ解放処理
 */
- (void)dealloc
{
    cache = nil;
    [operationQueue cancelAllOperations];
    operationQueue = nil;
    defaultImage = nil;
}


#pragma mark - Public methods

- (void)clearQueue
{
    [operationQueue cancelAllOperations];
}

- (void)clearCache
{
    [cache removeAllObjects];
}

- (UIImage *)cachedImageForURL:(NSURL *)URL
{
    if (URL == nil) {
        return nil;
    }
    
    return [cache objectForKey:URL];
}

- (void)imageForURL:(NSURL *)URL target:(id)target selector:(SEL)aSelector
{
    if (URL == nil) {
        return;
    }
    
    UIImage *image = [cache objectForKey:URL];
    
    if (image) {
        if ([target respondsToSelector:aSelector]) {
            [target performSelector:aSelector
                         withObject:image];
        }
    } else {
        NSOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
            UIImage *image = [cache objectForKey:URL];
            
            if (image) {
                [target performSelectorOnMainThread:aSelector
                                         withObject:image
                                      waitUntilDone:NO];
            } else {
                NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL
                                                                            cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                                        timeoutInterval:60.0];
                
                // HTTP通信開始
                NSURLResponse *response = nil;
                NSError *error = nil;
                NSData *data = [NSURLConnection sendSynchronousRequest:request
                                                     returningResponse:&response
                                                                 error:&error];
                
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                NSInteger statusCode = [httpResponse statusCode];
                
                if (error) {
                    image = defaultImage;
                } else {
                    if (200 == statusCode) {
                        if (data) {
                            image = [UIImage imageWithData:data];
                        } else {
                            // データが空の場合
                            image = defaultImage;
                        }
                    } else {
                        // ステータスコードが正常(200)以外の場合
                        image = defaultImage;
                    }
                }
                
                if (image) {
                    [cache setObject:image forKey:URL];
                }
                
                if ([target respondsToSelector:aSelector]) {
                    [target performSelectorOnMainThread:aSelector
                                             withObject:image
                                          waitUntilDone:NO];
                }
            }
        }];
        [operationQueue addOperation:operation];
    }
}

+ (UIImage *)defaultImage
{
    return [[ImageCache sharedInstance] defaultImage];
}

@end
