//
//  STFUNoiseCanceller.m
//  Shut Up
//
//  Created by Darren Mo on 2014-04-13.
//  Copyright (c) 2014 Darren Mo. All rights reserved.
//

@import Accelerate;
#import <EZAudio.h>
#import "STFUNoiseCanceller.h"

#define kBufferLength 1024

@interface STFUNoiseCanceller () <EZMicrophoneDelegate, EZOutputDataSource> {
	TPCircularBuffer _buffer;
}

@property (strong, nonatomic) EZMicrophone *microphone;
@property (strong, nonatomic) EZOutput *output;

@end

@implementation STFUNoiseCanceller

- (instancetype)init {
	self = [super init];
	
	if (self) {
		_microphone = [[EZMicrophone alloc] initWithMicrophoneDelegate:self];
		_output = [[EZOutput alloc] initWithDataSource:self];
		TPCircularBufferInit(&_buffer, kBufferLength);
	}
	
	return self;
}

- (void)dealloc {
	TPCircularBufferCleanup(&_buffer);
}

- (void)startCancellingNoise {
	[self.microphone startFetchingAudio];
	[self.output startPlayback];
}

- (void)microphone:(EZMicrophone *)microphone hasAudioStreamBasicDescription:(AudioStreamBasicDescription)audioStreamBasicDescription {
	[EZAudio printASBD:audioStreamBasicDescription];
}

- (void)microphone:(EZMicrophone *)microphone hasBufferList:(AudioBufferList *)bufferList withBufferSize:(UInt32)bufferSize withNumberOfChannels:(UInt32)numberOfChannels {
	for (UInt32 i = 0; i < bufferList->mNumberBuffers; i++) {
		Float32 *samples = bufferList->mBuffers[i].mData;
		vDSP_vneg(samples, 1, samples, 1, bufferSize);
	}
	
	[EZAudio appendDataToCircularBuffer:&_buffer fromAudioBufferList:bufferList];
}

- (TPCircularBuffer *)outputShouldUseCircularBuffer:(EZOutput *)output {
	return &_buffer;
}

@end
