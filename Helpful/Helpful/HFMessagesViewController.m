//
//  HFMessagesViewController.m
//  Helpful
//
//  Created by Jeroen Leenarts on 01-11-14.
//  Copyright (c) 2014 Helpful. All rights reserved.
//

#import "HFMessagesViewController.h"
#import "HFConversation.h"
#import "HFMessage.h"
#import "HFPerson.h"

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
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }

    [self hf_configureCell:cell atIndexPath:indexPath];

    return cell;
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
    HFMessage *message = self.messages[indexPath.row];
    cell.textLabel.text = message.body;
    cell.textLabel.numberOfLines = 0;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ ( %@ )", message.person.name, message.person.email];
}

@end
