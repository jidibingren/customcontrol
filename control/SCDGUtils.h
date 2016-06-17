//
//  SCDGUtils.h
//  deigo
//
//  Created by SC on 16/5/11.
//  Copyright © 2016年 SC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCDGUtils : NSObject
// 方便的创建一个NSError
+ (NSError*) makeError: (NSString*)localizedDescription;

// 显示一个AlertView
+ (void) alert :(NSString*)msg;

// 只获取一个alertView,不显示
+ (UIAlertView*) alertView :(NSString*)msg;

+ (void) alert:(NSString *)msg delegate:(id)delegate;

// return YES if object is nil or [NSNull null]
+ (BOOL) isNilOrNSNull: (id)object;

+ (BOOL) isNonnull:(id)object;

+ (BOOL) isValidStr:(NSString *)str;

+ (BOOL) isValidData:(NSData *)data;

+ (BOOL) isValidArray:(NSArray *)array;

+ (BOOL) isValidDictionary:(NSDictionary *)dict;

// 显示当前显示的最外层viewController，（慎用，实验性的)
+ (UIViewController *)topViewController;

// 显示一个全局的UIWindow(也是一个UIView)
+ (UIWindow*) getDefaultWindow;

// 显示一个在Documents中完整path, 用法: [Utils pathInDocuments:@"config.plist"]
+ (NSString*) pathInDocuments: (NSString*)subpath;
+ (NSString*) pathInCaches: (NSString*)subpath;
// 显示一个在bundle resource中的完整path, 用法: [Utils resourcePathInBundle:@"config.plist"]
+ (NSString*) resourcePathInBundle:(NSString *)subpath;
// 显示一个用bundle resource中的完整path生成的URL的absoluteString, 用法: [Utils fileURLAbsoluteString:@"config.plist"]
+ (NSString*) fileURLAbsoluteString:(NSString*)subpath;
// 让iClound不备份某个目录
+ (NSError*) dontBackup:(NSString*)path;

// 把某个文件从bundle中copy到caches目录中
+ (BOOL) deployResourceFromBundleToCachesIfNeeded: (NSString*)subpath;

// return CFBundleShortVersionString
+ (NSString*) getCurrentVersionShort;
// return CFBundleVersion
+ (NSString*) getCurrentVersionFull;
// return the first preferred language
+ (NSString*) getCurrentAppLanguage;

// 比较两个版本号
+ (int) compareVersion:(NSString*)version1 withVersion:(NSString*)version2;

// 设置系统默认的User-Agent字段，http请求时用到
+ (void) setupUserAgent;

// 异步的执行某段代码，delay可以是０（也是异步的）
+ (NSTimer *) asyncRunDelayed:(NSTimeInterval)delay block: (void (^)())block;

// 让iClound不备份某些已知的第三库生成的文件
+ (void) dontBackupGeneratedFiles;


+ (NSString*) groupText:(NSString*)text seperator:(NSString*)seperator groupLength:(int)groupLength;
+ (void)showLoginView;
+ (NSString *)formatStr:(NSString *)str replacement:(NSString *)replacement range:(NSRange)range;
/**
 *  格式化银行卡，默认显示后4位
 *
 *  @param bankNum     银行卡卡号
 *  @param replacement 替换的符号
 *
 *  @return 替换完的卡号
 */
+ (NSString *)formatBankCardNum:(NSString *)bankNum replacement:(NSString *)replacement;

+ (NSString *)getLoginToken;

+ (void)setLoginToken:(NSString *)token;

+ (NSString *)encodeURLParameter:(NSString *)str;

// methods for KeyChain
+ (NSString *)keyChainStringForKey:(NSString *)key;

+ (void)setKeyChainString:(NSString *)string forKey:(NSString *)key;

+ (NSData *)keyChainDataForKey:(NSString *)key;

+ (void)setKeyChainData:(NSData *)data forKey:(NSString *)key;

+ (NSArray *)keyChainArrayForKey:(NSString *)key;

+ (void)setKeyChainArray:(NSArray *)array forKey:(NSString *)key;

+ (void)addObjectToKeyChainArrayByKey:(NSString*)key objects:(id)firstObj, ... NS_REQUIRES_NIL_TERMINATION;

+ (NSDictionary *)keyChainDictionaryForKey:(NSString *)key;

+ (void)setKeyChainDictionary:(NSDictionary *)dict forKey:(NSString *)key;

+ (void)removeKeyChainItemForKey:(NSString *)key;

+ (void)removeKeyChainAllItems;

+ (UIFont *)fontWithSize:(CGFloat)size;

+ (UIFont *)boldFontWithSize:(CGFloat)size;

+ (CGSize)sizeForString:(NSString *)string font:(UIFont *)font constrainedToSize:(CGSize)constrainedSize lineBreakMode:(NSLineBreakMode)lineBreakMode;

+ (NSString *)getUUID;

+ (void)setUUID:(NSString *)uuidStr;

+ (int)getRandomNumber:(int)from to:(int)to;

+ (NSString*)getRandomStr:(int)length;

+ (NSString*)getNonce;

+ (UIColor *)getColor:(NSString *)hexColor;

+ (NSString*) remoteControlNotifactionNameWith:(uint32_t)acceptorId;

// 申明一个静态方法sharedInstance，同时屏蔽init方法，使这个类成为单例
#define SCDG_DECLARE_SINGLETON() +(instancetype)sharedInstance; \
    -(instancetype) init __attribute__((unavailable("init not available")));

// 实现单例所需要的方法: sharedInstance
#define SCDG_IMPLEMENT_SINGLETON()                         \
    +(instancetype)sharedInstance {                                    \
        static id instance = nil;                   \
        static dispatch_once_t onceToken;                   \
        dispatch_once(&onceToken, ^{                        \
            instance = [[self alloc] init];            \
        });                                                 \
        return instance;                                    \
    }

@end
