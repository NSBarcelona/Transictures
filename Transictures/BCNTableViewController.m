//
//  BCNTableViewController.m
//  Transictures
//
//  Created by Hermes on 24/02/14.
//  Copyright (c) 2014 Hermes Pique. All rights reserved.
//

#import "BCNTableViewController.h"
#import "BCNPicture.h"
#import "BCNCoreDataManager.h"
#import "BCNDetailViewController.h"

static NSString *BCNTableViewControllerCellIdentifier = @"Cell";

@interface BCNTableViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation BCNTableViewController {
    NSArray *_pictures;
}

@synthesize selectedIndexPath = _selectedIndexPath;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Pictures", @"");
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBarButtonItem:)];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:BCNTableViewControllerCellIdentifier];
    
    {
        BCNCoreDataManager *manager = [BCNCoreDataManager sharedManager];
        _pictures = [manager fetchPictures];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(objectsDidChangeNotification:) name:BCNCoreDataManagerObjectsDidChangeNotification object:manager];
    }
}

- (void)dealloc
{
    BCNCoreDataManager *manager = [BCNCoreDataManager sharedManager];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BCNCoreDataManagerObjectsDidChangeNotification object:manager];
}

#pragma mark Actions

- (void)addBarButtonItem:(UIBarButtonItem*)barButtonItem
{
    UIImagePickerControllerSourceType sourceType = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentImagePickerControllerWithType:sourceType];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _pictures.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BCNTableViewControllerCellIdentifier forIndexPath:indexPath];
    BCNPicture *picture = _pictures[indexPath.row];
    UIImage *image = picture.image;
    cell.imageView.image = image;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    NSString *dateString = picture.dateString;
    cell.textLabel.text = dateString;
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedIndexPath = indexPath;
    BCNPicture *picture = _pictures[indexPath.row];
    UIViewController *vc = [[BCNDetailViewController alloc] initWithPicture:picture];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    [[BCNCoreDataManager sharedManager] insertPictureWithImage:image];
}

#pragma mark Notifications

- (void)objectsDidChangeNotification:(NSNotification*)notification
{
    _pictures = [[BCNCoreDataManager sharedManager] fetchPictures];
    [self.tableView reloadData];
}

#pragma mark Utils

- (void)presentImagePickerControllerWithType:(UIImagePickerControllerSourceType)type
{
    UIImagePickerController *controller = [UIImagePickerController new];
    controller.delegate = self;
    controller.sourceType = type;
    [self presentViewController:controller animated:YES completion:nil];
}

@end
