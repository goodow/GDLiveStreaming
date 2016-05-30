//
// Created by Larry Tin on 16/5/9.
//

#import <Foundation/Foundation.h>
#import "GPUImageFilter.h"

@interface GDLFilterUtil : NSObject

+ (void)removeFilter:(GPUImageOutput <GPUImageInput> *)filter fromChain:(GPUImageFilter *)chain;

+ (void)insertFilter:(GPUImageOutput <GPUImageInput> *)filter before:(id <GPUImageInput>)before toChain:(GPUImageFilter *)chain;

@end