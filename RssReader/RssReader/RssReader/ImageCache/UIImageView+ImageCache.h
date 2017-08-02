/*!
 *@file		UIImageView+ImageCache.h
 *@brief	UIImageView+ImageCacheヘッダファイル
 *@author	Satoshi Iwaki
 *@date		2013/05/16
 */

#import <UIKit/UIKit.h>

/*!
 *@brief	UIImageViewクラス
 *@note		ImageCache用の拡張を行うカテゴリ
 */
@interface UIImageView (ImageCache)

/*!
 *@brief		画像の設定
 *@param        URL     画像のURL
 */
- (void)setImageURL:(NSURL *)URL;

@end
