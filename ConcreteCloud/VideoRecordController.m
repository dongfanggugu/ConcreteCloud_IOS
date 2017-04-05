//
//  VideoRecordController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2017/3/17.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoRecordController.h"
#import <AVFoundation/AVFoundation.h>

#define VIDEO_LENGTH 5


@interface VideoRecordController()<AVCaptureFileOutputRecordingDelegate>
{
    NSInteger _count;
}

@property (strong, nonatomic) AVCaptureMovieFileOutput *output;

@property (strong, nonatomic) UIView *processView;


@property (strong, nonatomic) UIButton *btnRecord;

@property (strong, nonatomic) NSTimer *timer;


@end


@implementation VideoRecordController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviTitle:@"视频录制"];
    [self initData];
    [self initDevice];
    [self initView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_timer && [_timer isValid])
    {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)initData
{
    _count = 0;
}

- (void)initView
{
    _btnRecord = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    
    [_btnRecord setTitle:@"录制" forState:UIControlStateNormal];
    
    
    
    _btnRecord.layer.masksToBounds = YES;
    
    _btnRecord.layer.cornerRadius = 30;
    
    _btnRecord.backgroundColor = [Utils getColorByRGB:TITLE_COLOR];
    
    _btnRecord.center = CGPointMake(self.screenWidth / 2, 350);
    
    [self.view addSubview:_btnRecord];
    
    [_btnRecord addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
    _processView = [[UIView alloc] initWithFrame:CGRectMake(0, 294, self.screenWidth, 10)];
    _processView.backgroundColor = [Utils getColorByRGB:TITLE_COLOR];
    
    [self.view addSubview:_processView];
}



- (void)click:(id)sender
{
    if ([self.output isRecording])
    {
        return;
    }
    
    
    [sender setTitle:@"停止" forState:UIControlStateNormal];
    
    //开始录制
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/myVideo.mp4"];
    NSURL *url = [NSURL fileURLWithPath:path];
    [self.output startRecordingToOutputFileURL:url recordingDelegate:self];
}


- (void)stop
{
    
}

- (void)initDevice
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *inputVideo = [AVCaptureDeviceInput deviceInputWithDevice:[devices firstObject] error:NULL];
    
    
    AVCaptureDevice *deviceAudio = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    
    AVCaptureDeviceInput *inputAudio = [AVCaptureDeviceInput deviceInputWithDevice:deviceAudio error:NULL];
    
    AVCaptureMovieFileOutput *output = [[AVCaptureMovieFileOutput alloc] init];
 
    self.output = output;
    
    
    
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    
    if ([session canAddInput:inputVideo])
    {
        [session addInput:inputVideo];
    }
    
    if ([session canAddInput:inputAudio])
    {
        [session addInput:inputAudio];
    }
    
    if ([session canAddOutput:output])
    {
        [session addOutput:output];
    }
    
    
    AVCaptureVideoPreviewLayer *preLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    
    preLayer.backgroundColor = [UIColor blueColor].CGColor;
    
    preLayer.frame = CGRectMake(0, 94, self.screenWidth, 200);
    
    preLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    [self.view.layer addSublayer:preLayer];
    
    [session startRunning];
}


- (void)itsTime
{
    _count += 1;
    
    if (VIDEO_LENGTH * 10 <= _count)
    {
        [self.output stopRecording];
        [_btnRecord setTitle:@"录制" forState:UIControlStateNormal];
        
        [_timer invalidate];
        
        _processView.frame = CGRectZero;
        _count = 0;
    }
    
    CGRect frame = _processView.frame;
    
    CGFloat interval = self.screenWidth / (VIDEO_LENGTH * 10);
    
    frame.size.width -= interval;
    
    _processView.frame = frame;
    
    CGPoint center = _processView.center;
    
    center.x = self.screenWidth / 2;
    
    _processView.center = center;
}

#pragma mark - AVCaptureFileOutputRecordingDelegate

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(itsTime) userInfo:nil repeats:YES];
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL
      fromConnections:(NSArray *)connections error:(NSError *)error
{
    NSLog(@"录制完成");
    
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/myVideo.mp4"];
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    NSString *base64Str = [self Base64StrWithData:data];
    
    [self upload:base64Str];
}

- (void)upload:(NSString *)videoStr;
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"video"] = videoStr;
   
    
    [[HttpClient shareClient] view:self.view post:URL_VIDEO_UPLOAD parameters:dic
                           success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSString *url = [[responseObject objectForKey:@"body"] objectForKey:@"url"];
        
        if (0 == url.length)
        {
            [HUDClass showHUDWithLabel:@"视频上传失败,请退出后重新进入录制上传" view:self.view];
            return;
        }
        
        if (_delegate && [_delegate respondsToSelector:@selector(onUploadVideo:videoKey:)])
        {
            [self back];
            [_delegate onUploadVideo:url videoKey:_videoKey];
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *errr) {
        [HUDClass showHUDWithLabel:@"视频上传失败,请退出后重新进入录制上传" view:self.view];
    }];
}


- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

// 二进制文件转为base64的字符串
- (NSString *)Base64StrWithData:(NSData *)data
{
    if (!data) {
        NSLog(@"NSData 不能为空");
        return nil;
    }
    NSString *str = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    return str;
}


@end
