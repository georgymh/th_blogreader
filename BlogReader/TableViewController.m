//
//  TableViewController.m
//  BlogReader
//
//  Created by Georgy Marrero on 1/5/15.
//  Copyright (c) 2015 Georgy Marrero. All rights reserved.
//

#import "TableViewController.h"
#import "BlogPost.h"
#import "WebViewController.h"

@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL * blogURL = [NSURL URLWithString:@"http://blog.teamtreehouse.com/api/get_recent_summary/"];
    NSData *jsonData = [NSData dataWithContentsOfURL:blogURL];
    NSError *error = nil;
    NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    //NSLog(@"%@",dataDictionary);
    
    self.blogPosts = [NSMutableArray array];
    NSArray *blogPostsArray = [dataDictionary objectForKey:@"posts"];
    for (NSDictionary *bpDictionary in blogPostsArray) {
        BlogPost *blogPost = [BlogPost blogPostWithTitle:[bpDictionary objectForKey:@"title"]];
        blogPost.author = [bpDictionary objectForKey:@"author"];
        blogPost.thumbnail = [bpDictionary objectForKey:@"thumbnail"];
        blogPost.date = [bpDictionary objectForKey:@"date"];
        blogPost.url = [NSURL URLWithString:[bpDictionary objectForKey:@"url"]];
        [self.blogPosts addObject:blogPost];
    }

    //self.blogPosts = [dataDictionary objectForKey:@"posts"];
    
    //NSURL * blogURL = [NSURL URLWithString:@"https://ajax.googleapis.com/ajax/services/search/web?v=1.0&q=The+Lean+Startup"];
    //self.blogPosts = [[dataDictionary objectForKey:@"responseData"] objectForKey:@"results"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.blogPosts count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    BlogPost *blogPost = [self.blogPosts objectAtIndex:indexPath.row];
    
    if ( [blogPost.thumbnail isKindOfClass:[NSString class]]) {
        NSData *imageData = [NSData dataWithContentsOfURL:[blogPost thumbnailURL]];
        UIImage *image = [UIImage imageWithData:imageData];
        
        cell.imageView.image = image;
    } else {
        cell.imageView.image = [UIImage imageNamed:@"unknown.jpg"];
    }
    
    cell.textLabel.text = blogPost.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Author: %@ // %@", blogPost.author, blogPost.formattedDate];
    
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"preparing for segue: %@", segue.identifier);
    
    if ( [segue.identifier isEqualToString:@"showBlogPost"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        BlogPost *blogPost = [self.blogPosts objectAtIndex:indexPath.row];
        WebViewController *wbc = (WebViewController *)segue.destinationViewController;
        wbc.blogPostURL = blogPost.url;
    }
}

@end