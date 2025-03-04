//
//  SineweaverExtensionAUProcessHelper.hpp
//  Sineweaver
//
//  Created on 04.03.25
//

#pragma once

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

#include <vector>
#include "SineweaverExtensionDSPKernel.hpp"

//MARK:- AUProcessHelper Utility Class
class AUProcessHelper
{
public:
    AUProcessHelper(SineweaverExtensionDSPKernel& kernel)
    : mKernel{kernel}
    {
    }
    
    void setChannelCount(UInt32 inputChannelCount, UInt32 outputChannelCount)
    {
        mOutputBuffers.resize(outputChannelCount);
    }

    /**
     This function handles the event list processing and rendering loop for you.
     Call it inside your internalRenderBlock.
     */
    void processWithEvents(AudioBufferList* outBufferList, AudioTimeStamp const *timestamp, AUAudioFrameCount frameCount, AURenderEvent const *events) {
        
        AUEventSampleTime now = AUEventSampleTime(timestamp->mSampleTime);
        AUAudioFrameCount framesRemaining = frameCount;
        AURenderEvent const *nextEvent = events; // events is a linked list, at the beginning, the nextEvent is the first event
        
        auto callProcess = [this] (AudioBufferList* outBufferListPtr, AUEventSampleTime now, AUAudioFrameCount frameCount, AUAudioFrameCount const frameOffset) {
            for (int channel = 0; channel < mOutputBuffers.size(); ++channel) {
                mOutputBuffers[channel] = (float*)outBufferListPtr->mBuffers[channel].mData + frameOffset;
            }
            
            mKernel.process(mOutputBuffers, now, frameCount);
        };
        
        while (framesRemaining > 0) {
            // If there are no more events, we can process the entire remaining segment and exit.
            if (nextEvent == nullptr) {
                AUAudioFrameCount const frameOffset = frameCount - framesRemaining;
                callProcess(outBufferList, now, framesRemaining, frameOffset);
                return;
            }
            
            // **** start late events late.
            auto timeZero = AUEventSampleTime(0);
            auto headEventTime = nextEvent->head.eventSampleTime;
            AUAudioFrameCount framesThisSegment = AUAudioFrameCount(std::max(timeZero, headEventTime - now));
            
            // Compute everything before the next event.
            if (framesThisSegment > 0) {
                AUAudioFrameCount const frameOffset = frameCount - framesRemaining;
                callProcess(outBufferList, now, framesThisSegment, frameOffset);
                
                // Advance frames.
                framesRemaining -= framesThisSegment;
                
                // Advance time.
                now += AUEventSampleTime(framesThisSegment);
            }
            
            nextEvent = performAllSimultaneousEvents(now, nextEvent);
        }
    }
    
    AURenderEvent const * performAllSimultaneousEvents(AUEventSampleTime now, AURenderEvent const *event) {
        do {
            mKernel.handleOneEvent(now, event);
            
            // Go to next event.
            event = event->head.next;
            
            // While event is not null and is simultaneous (or late).
        } while (event && event->head.eventSampleTime <= now);
        return event;
    }
	
	// Block which subclassers must provide to implement rendering.
	AUInternalRenderBlock internalRenderBlock() {
		/*
		 Capture in locals to avoid ObjC member lookups. If "self" is captured in
		 render, we're doing it wrong.
		 */
		return ^AUAudioUnitStatus(AudioUnitRenderActionFlags 				*actionFlags,
								  const AudioTimeStamp       				*timestamp,
								  AVAudioFrameCount           				frameCount,
								  NSInteger                   				outputBusNumber,
								  AudioBufferList            				*outputData,
								  const AURenderEvent        				*realtimeEventListHead,
								  AURenderPullInputBlock __unsafe_unretained pullInputBlock) {
			
			if (frameCount > mKernel.maximumFramesToRender()) {
				return kAudioUnitErr_TooManyFramesToProcess;
			}
			
			/*
			 Important:
			 If the caller passed non-null output pointers (outputData->mBuffers[x].mData), use those.
			 
			 If the caller passed null output buffer pointers, process in memory owned by the Audio Unit
			 and modify the (outputData->mBuffers[x].mData) pointers to point to this owned memory.
			 The Audio Unit is responsible for preserving the validity of this memory until the next call to render,
			 or deallocateRenderResources is called.
			 
			 If your algorithm cannot process in-place, you will need to preallocate an output buffer
			 and use it here.
			 
			 See the description of the canProcessInPlace property.
			 */
			processWithEvents(outputData, timestamp, frameCount, realtimeEventListHead);
			
			return noErr;
		};
		
	}
private:
    SineweaverExtensionDSPKernel& mKernel;
    std::vector<float*> mOutputBuffers;
};
