//
//  ViewController.m
//  CompositePattern
//
//  Created by Eveian on 2014/12/26.
//
//

#import "ViewController.h"
#import "ComFilesBrowserMgr.h"

typedef NS_ENUM(NSInteger, kToolBarTag) {
    kToolBarTagHome = 100,
    kToolBarTagBack,
};

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(weak, nonatomic) IBOutlet UITableView* tableView;
@property(strong, nonatomic) NSMutableArray* dataSource;
@property(strong, nonatomic) NSString* currentPath;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.currentPath = @"/";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableArray*) dataSource{
    if (!_dataSource) {
        _dataSource = [@[]mutableCopy];
    }
    return _dataSource;
}

//当前路径被改变时,就重新载入列表
-(void) setCurrentPath:(NSString *)currentPath{
    BOOL isReloadList = NO;
    if (!_currentPath || ![_currentPath isEqualToString:currentPath]) {
        isReloadList = YES;
    }
    _currentPath = currentPath;

    if (isReloadList) {
        [self loadDataSource];
    }
}
// ---------------------------------------------------------------------------------------------------------------
#pragma mark - UITableViewDelegate,UITableViewDataSource
// ---------------------------------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* const kCellID = @"file_entry_cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellID];
    }
    
    FileComposite* entry = [self entryAtIndexPath:indexPath];
    cell.textLabel.text = entry.file_name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",entry.file_size?:@""];
    if (entry.entry_type != kEntryTypeDirectory) {
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        cell.userInteractionEnabled = NO;
        [cell.imageView setImage:[UIImage imageNamed:@"icon_documents"]];
    }
    else{
        cell.selectionStyle =UITableViewCellSelectionStyleDefault;
        cell.userInteractionEnabled = YES;
        [cell.imageView setImage:[UIImage imageNamed:@"icon_dir"]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FileComposite* entry = [self entryAtIndexPath:indexPath];
    self.currentPath = entry.file_path;
}

// ---------------------------------------------------------------------------------------------------------------
#pragma mark - DataSource
// ---------------------------------------------------------------------------------------------------------------
-(void) loadDataSource{
   FileComposite* entry= [[ComFilesBrowserMgr getInstance] loadFilesListAtDir:self.currentPath];
    [self.dataSource setArray:[entry subItems]];
    [self.tableView reloadData];
}

-(FileComposite*) entryAtIndexPath:(NSIndexPath*)indexPath{
    if (indexPath.row >= [self.dataSource count]) {
        return nil;
    }
    return self.dataSource[indexPath.row];
}

// ---------------------------------------------------------------------------------------------------------------
#pragma mark - IBAction
// ---------------------------------------------------------------------------------------------------------------
-(IBAction)barItemHandler:(UIBarButtonItem*)sender{
    switch (sender.tag) {
        case kToolBarTagHome:
            self.currentPath = @"/";
            break;
        case kToolBarTagBack:
            self.currentPath = [self.currentPath stringByDeletingLastPathComponent]?:@"/";
            break;
        default:
            break;
    }
}
@end
