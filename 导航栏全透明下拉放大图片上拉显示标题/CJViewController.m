//
//  CJViewController.m
//  导航栏全透明下拉放大图片上拉显示标题
//
//  Created by xunli on 2018/3/8.
//  Copyright © 2018年 caoji. All rights reserved.
//

#import "CJViewController.h"

@interface CJViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) UIImageView *image;
@property (nonatomic,assign) CGFloat offset;
@property(nonatomic,strong)UILabel* titleLabel;

@end

@implementation CJViewController
static NSString *const reuseId = @"cell";
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =[UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height / 3)];
    self.image.image = [UIImage imageNamed:@"image.jpeg"];
    [self.view addSubview:self.image];
    
    
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    self.table.dataSource = self;
    self.table.delegate = self;
    self.table.backgroundColor = [UIColor clearColor];
    self.table.contentInset = UIEdgeInsetsMake(self.view.frame.size.height/3 - 64, 0, 0, 0);
    [self.view addSubview: self.table];
    self.offset = self.table.contentOffset.y;
    
    
    [self.table registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseId];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
}

#pragma mark ~~~~~~~~~~ TableViewDataSource ~~~~~~~~~~
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    cell.textLabel.text = [NSString stringWithFormat:@"第%zdrow",indexPath.row];
    return cell;
}

#pragma mark ~~~~~~~~~~ ScrollViewDelegate ~~~~~~~~~~
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat y = scrollView.contentOffset.y;
    NSLog(@"%f---%f",y,self.offset);
    CGRect frame = self.image.frame;
    if (y > self.offset) {
        NSLog(@"向上");
        self.title = @"";
        frame.origin.y = self.offset-y;
        if (y>=0) {
            frame.origin.y = self.offset;
            //标题
            [self creatViewTitle];
        }else{
            [self removeViewTitle];
        }
        self.image.frame = frame;
    }
    // tableView设置偏移时不能立马获取他的偏移量，所以一开始获取的offset值为0
    else if (self.offset == 0) return;
    else {
        NSLog(@"向下");
        CGFloat x = self.offset - y;
        frame = CGRectMake(-x/2, -x/2, self.view.frame.size.width + x, self.view.frame.size.height/3+x);
        self.image.frame = frame;
    }
}

//创建标题
-(void)creatViewTitle{
    if (self.titleLabel==nil) {
        self.titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 44)];
    }
    self.titleLabel.tag =1000;
    [self.view addSubview:self.titleLabel];
    self.titleLabel.textColor =[UIColor redColor];
    self.titleLabel.text =@"标题";
    self.titleLabel.textAlignment =NSTextAlignmentCenter;
    self.titleLabel.font =[UIFont systemFontOfSize:18];
}
//移除标题
-(void)removeViewTitle{
    for (id tmpview in self.view.subviews) {
        if ([tmpview isKindOfClass:[UILabel class]]) {
            UILabel* vc =(UILabel*)tmpview;
            if (vc.tag==1000) {
                [tmpview removeFromSuperview];
                break;
            }
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
