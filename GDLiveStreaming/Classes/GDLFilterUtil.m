//
// Created by Larry Tin on 16/5/9.
//

#import "GDLFilterUtil.h"

@implementation GDLFilterUtil {

}

+ (void)insertFilter:(GPUImageOutput <GPUImageInput> *)filter before:(id <GPUImageInput>)before toChain:(GPUImageFilter *)chain {
  GPUImageOutput *lastOutput = [self findOutputBefore:before from:chain];
  NSArray *inputs = lastOutput.targets;
  [lastOutput removeAllTargets];
  for (id <GPUImageInput> input in inputs) {
    [filter addTarget:input];
  }
  [lastOutput addTarget:filter];
}

+ (void)removeFilter:(GPUImageOutput <GPUImageInput> *)filter fromChain:(GPUImageFilter *)chain {
  GPUImageOutput *previousFilter = [self findOutputBefore:filter from:chain];
  [previousFilter removeTarget:filter];
  NSArray *targets = filter.targets;
  for (id <GPUImageInput> input in targets) {
    [previousFilter addTarget:input];
  }
}

+ (GPUImageOutput *)findOutputBefore:(id <GPUImageInput>)input from:(GPUImageOutput *)output {
  if ([output.targets containsObject:input]) {
    return output;
  }
  for (GPUImageOutput *out in output.targets) {
    GPUImageOutput *find = [self findOutputBefore:input from:out];
    if (find) {
      return find;
    }
  }
  return nil;
}
@end