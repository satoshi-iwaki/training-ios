/*!
 *@file		ImageCache.h
 *@brief	ImageCacheヘッダファイル
 *@author	Satoshi Iwaki
 *@date		2013/05/16
 */

#import <Foundation/Foundation.h>

#import "UIImageView+ImageCache.h"

/*!
 *@brief	ImageCacheクラス
 *@note		画像のダウンロードとキャッシュを行う
 */
@interface ImageCache : NSObject <NSURLConnectionDelegate>
{
@private
    //! キャッシュ
    NSCache *cache;
    //! ダウンロードOperation用キュー
    NSOperationQueue *operationQueue;
    //! デフォルトの画像
    UIImage *defaultImage;
}

@property (nonatomic,strong,readonly) UIImage *defaultImage;

/*!
 *@brief		キューのクリア取得処理
 *@note			ダウンロードキューのクリアを行う
 */
- (void)clearQueue;

/*!
 *@brief		キャッシュのクリア取得処理
 *@note			キャッシュのクリアを行う
 */
- (void)clearCache;

/*!
 *@brief		シングルトンのインスタンス取得処理
 *@note			シングルトンのインスタンス取得を行う
 *@return       シングルトンのインスタンス
 */
+ (instancetype)sharedInstance;

/*!
 *@brief		シングルトンのインスタンス削除処理
 *@note			シングルトンのインスタンス削除を行う
 */
+ (void)deleteInstance;


/*!
 *@brief		画像のダウンロードとキャッシュ処理
 *@note			画像のダウンロードとキャッシュを行う
 *@param		URL         画像のURL
 *@param		target      画像のダウンロード完了時のCallback先オブジェクト
 *@param		aSelector   画像のダウンロード完了時のCallback先メソッド
 */
- (void)imageForURL:(NSURL *)URL target:(id)target selector:(SEL)aSelector;

/*!
 *@brief		デフォルトの画像取得処理
 *@note			デフォルトの画像取得を行う
 *@return       デフォルトの画像
 */
+ (UIImage *)defaultImage;

@end
