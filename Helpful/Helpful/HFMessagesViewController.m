//
//  HFMessagesViewController.m
//  Helpful
//
//  Created by Jeroen Leenarts on 01-11-14.
//  Copyright (c) 2014 Helpful. All rights reserved.
//

#import "HFMessagesViewController.h"
#import "HFMessageCellTableViewCell.h"
#import "HFConversation.h"
#import "HFMessage.h"
#import "HFPerson.h"

#import "Helpful-Swift.h"

@interface HFMessagesViewController ()

@property (nonatomic, copy, readwrite) NSArray *messages;

@end

@implementation HFMessagesViewController

- (id)initWithConversation:(HFConversation *)conversation {
    if ((self = [super initWithStyle:UITableViewStylePlain])) {
        _conversation = conversation;
    }
    return self;
}

#pragma mark - Accessors

- (void)setMessages:(NSArray *)messages {
    if (![_messages isEqualToArray:messages]) {
        //Explicit copy not needed because sorting this way implies a copy.
        _messages = [messages sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"created" ascending:YES]]];

        //Sort messages ascending on created field
        [self.tableView reloadData];
    }
}

#pragma mark - UIViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HFMessageCellTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Reply", nil) style:UIBarButtonItemStylePlain target:nil action:nil];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (!self.messages) {
        [self hf_fetchMessages];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count * 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];

    [self hf_configureCell:cell atIndexPath:indexPath];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Private Methods

- (void)hf_fetchMessages {
    // Fetch all accounts.
    RKObjectRequestOperation *operation = [HFMessage fetchMessageRequestOperationForConversation:self.conversation];
    NSAssert(operation, @"Undefined request operation");
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        self.messages = [mappingResult array];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        // TODO: handle this!
        NSLog(@"could not fetch conversations: %@", error);
    }];
    [operation start];
}

- (void)hf_configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    HFMessageCellTableViewCell * messageCell = (HFMessageCellTableViewCell *)cell;
    if (indexPath.row == 0) {
        messageCell.decorationBarConstraint.constant = 50.f;
    } else {
        messageCell.decorationBarConstraint.constant = -10.f;
    }
    HFMessage *message = self.messages[0];
    messageCell.messageLabel.text = message.body;
    messageCell.messageLabel.numberOfLines = 2;
    messageCell.titleLabel.text = self.conversation.subject;
    messageCell.nameMailLabel.text = [NSString stringWithFormat:@"%@, %@", message.person.name, message.person.email];
    NSURL *imageUrl = [NSURL URLWithString:message.person.gravatarUrl];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:imageUrl] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"Error loading URL %@", imageUrl);
            return;
        }
        messageCell.portratImage.image = [[UIImage imageWithData:data] roundImageFor:messageCell.portratImage.bounds];
    }];
//    cell.imageView
}

@end
