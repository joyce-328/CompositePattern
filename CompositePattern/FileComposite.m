//
//  FileComposite.m
//  CompositePattern
//
//  Created by Eveian on 2014/12/27.
//
//

#import "FileComposite.h"
#import "ComFilesBrowserMgr.h"

@interface FileComposite()
@property(strong, nonatomic) NSDictionary* attributesDic;
@end

@implementation FileComposite

-(FileComposite*) initWithPath:(NSString*)path{
    self = [super init];
    if (self) {
        self.file_path = path;
        self.file_name = [path lastPathComponent];
        
        NSString* full_path = [[[ComFilesBrowserMgr getInstance] getBaseURLString] stringByAppendingPathComponent:path];
        self.attributesDic =[[NSFileManager defaultManager] attributesOfItemAtPath:full_path error:nil];
        self.modification_date = [self.attributesDic fileModificationDate];
    }
    return self;
}

-(void) add:(FileComposite*)c{
//不实作
}

-(NSArray*) subItems{
    //不实作
    return nil;
}

@end

@implementation ComFile

-(FileComposite*) initWithPath:(NSString*)path{
    self = [super initWithPath:path];
    if (self) {
        self.entry_type = kEntryTypeGeneric;
        
        //将档案大小转换成文字KB、MB、GB之类的
        long long fileSize = [self.attributesDic fileSize];
        if (fileSize==0) {
            self.file_size= @"0 KB";
        }
        else{
            self.file_size=[NSByteCountFormatter stringFromByteCount:fileSize countStyle:NSByteCountFormatterCountStyleFile];
        }
    }
    return self;
}

-(void) add:(FileComposite*)c{
    //不实作
}

-(NSArray*) subItems{
    //不实作
    return nil;
}
@end

@interface ComDirectory ()
@property(strong, nonatomic) NSMutableArray* children;
@end
@implementation ComDirectory

-(FileComposite*) initWithPath:(NSString*)path{
    self = [super initWithPath:path];
    if (self) {
        self.entry_type = kEntryTypeDirectory;
    }
    return self;
}

-(NSMutableArray*) children{
    if (!_children) {
        _children = [@[]mutableCopy];
    }
    return _children;
}

-(void) add:(FileComposite*)c{
    //加入子项目
    [self.children addObject:c];
}

-(NSArray*) subItems{
    return self.children;
}
@end
