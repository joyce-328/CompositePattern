//
//  ComFilesBrowserMgr.m
//  CompositePattern
//
//  Created by Eveian on 2014/12/27.
//
//

#import "ComFilesBrowserMgr.h"

@interface ComFilesBrowserMgr()
@property(strong, nonatomic) NSFileManager* filesMgr;
@property(strong, nonatomic) NSString* rootPath;
@end

@implementation ComFilesBrowserMgr

+ (instancetype)getInstance {
    static ComFilesBrowserMgr *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (NSBundle *)resourceBundle{
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"FileSourceTree" ofType:@"bundle"];
    return [NSBundle bundleWithPath:bundlePath];
}

-(NSString*) rootPath{
    if (!_rootPath) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        _rootPath =[paths objectAtIndex:0];
    }
    return _rootPath;
}

-(NSFileManager*) filesMgr{
    return [NSFileManager defaultManager];
}

-(NSString*) getBaseURLString{
    return self.rootPath;
}
// -----------------------------------------------------------------------------------------------------------------
//将Bundle里面的档案复制到Directory
-(void) setupResource{
    NSString* bundlePath =[[self resourceBundle] bundlePath];
    
    //找出resourceBundle的目录结构
    NSDirectoryEnumerator* enumerator = [self.filesMgr enumeratorAtPath:bundlePath];
    NSString* resourcePath;
    while (resourcePath = [enumerator nextObject]){
        NSString* fromURLString = [bundlePath stringByAppendingPathComponent:resourcePath];
        NSString* toURLString = [self.rootPath stringByAppendingPathComponent:resourcePath];
 
        //判断是资料夹且目录不存在的话，在self.rootPath 建立相对路径
        if ([self isDirectoryAtURLString:fromURLString]) {
            if (![self.filesMgr fileExistsAtPath:toURLString]) {
                [self.filesMgr createDirectoryAtPath:toURLString withIntermediateDirectories:YES attributes:nil error:nil];
            }
        }
        else{
            //是档案的话,就复制到self.rootPath 相对路径
            [self.filesMgr copyItemAtPath:fromURLString toPath:toURLString error:nil];
        }
    }
}

-(FileComposite*) loadFilesListAtDir:(NSString*)dir{

    //找出指定目录的档案结构
    NSString* search_full_path = [self.rootPath stringByAppendingPathComponent:dir];
    NSArray* contents = [self.filesMgr contentsOfDirectoryAtPath:search_full_path error:nil];
    
    //去掉档头,找出相对路径
    NSRange r = [dir rangeOfString:self.rootPath];
    NSString *relativePath = dir;
    if (r.length != 0){
        relativePath = [dir substringFromIndex:r.location+r.length];
        if ([relativePath length]==0) {
            relativePath = @"/";
        }
    }
    
    ComDirectory* parentCom = [[ComDirectory alloc] initWithPath:relativePath];
    for (NSString* path in contents){
        NSString* source_path = [relativePath stringByAppendingPathComponent:path];
        NSString* full_path = [self.rootPath stringByAppendingPathComponent:source_path];
        if ([self isDirectoryAtURLString:full_path]){
            //将directory加入parent里
            ComDirectory* directory=[[ComDirectory alloc] initWithPath:source_path];
            [parentCom add:directory];
        }
        else{
            //将file加入parent里
            ComFile* file=[[ComFile alloc] initWithPath:source_path];
            [parentCom add:file];
        }
    }
    return parentCom;
}
// ---------------------------------------------------------------------------------------------------------------
#pragma mark - Check
// ---------------------------------------------------------------------------------------------------------------
-(BOOL) isDirectoryAtURLString:(NSString*)URLString{
    NSError* error;
    //找出档案属性来判断是不是资料夹
    NSDictionary* attDic= [[NSFileManager defaultManager] attributesOfItemAtPath:URLString error:&error];
    return [[attDic fileType] isEqualToString:NSFileTypeDirectory];
}
@end
