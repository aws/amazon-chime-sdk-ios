# Video Pagination with Active Speaker-Based Policy

## Overview

Amazon Chime SDK currently supports [multiple video tiles](https://docs.aws.amazon.com/chime/latest/dg/meetings-sdk.html#mtg-limits) in a meeting. However, in many cases, the application may not want to render all the available video streams, because of the following reasons:

* **Hardware limitation** - On mobile devices, screen sizes are relatively small and network as well as computation resources are rather limited. If an application renders all the available videos on the same screen at the same time, it will consume a lot of network bandwidth and CPU to subscribe to video streams and decode video frames. Each video tile will be extremely small and barely visible, which results in a bad user experience.
* **Use cases do not require multiple videos** - An application could have specific use cases that do not require multiple videos being rendered at the same time. For example, an online fitness training application may only want to show the video from the instructor and the student themselves, and ignore all the video streams from other students.

In the following example, we will show you how to selectively render some of the available video streams using `pauseRemoteVideoTile(tileId:)` and `resumeRemoteVideoTile(tileId:)` APIs. We will implement the following features:

* Remote videos will be paginated into several pages. Each page contains at most 4 remote videos.
* User can switch between different pages.
* User can manually pause/resume specific video tiles.
* Video tiles from active speakers will be promoted to the top of the list automatically.

## Prerequisite

Amazon Chime SDK provides multiple APIs for sending, receiving, and displaying videos. Before we jump into code implementation, please read [In-depth Look and Comparison Between Video APIs](api_overview.md#8g-in-depth-look-and-comparison-between-video-apis) to understand what these video APIs do under the hood and when you want to call them.

You should also have basic knowledge about how to render an ordered collection of data items and present them using customizable layouts.

## Implementation - Video Pagination

To implement basic video pagination feature, we need to maintain the following states in the application:

```swift
// How many remote videos to render at most per page
private let remoteVideoTileCountPerPage = 4

// Index of the page that the user is currently viewing
private var currentRemoteVideoPageIndex = 0

// An ordered list of VideoTileState for remote videos
private var remoteVideoTileStates: [VideoTileState] = []

// Ids of the video tiles that user paused manually
private var userPausedVideoTileIds: Set<Int> = Set()
```

Given 1) the page number that the user is on; and 2) the number of remote videos per page, we can calculate the slice of `VideoTileState`s to render:

```swift
private var remoteVideoStatesOnCurrentPage: [VideoTileState] {
    let remoteVideoStartIndex = currentRemoteVideoPageIndex * remoteVideoTileCountPerPage
    let remoteVideoEndIndex = min(remoteVideoTileStates.count, remoteVideoStartIndex + remoteVideoTileCountPerPage) - 1

    if remoteVideoEndIndex < remoteVideoStartIndex {
        return []
    }
    return Array(remoteVideoTileStates[remoteVideoStartIndex...remoteVideoEndIndex])
}

private var remoteVideoStatesNotOnCurrentPage: [VideoTileState] {
    let remoteVideoAttendeeIdsOnCurrentPage = Set(remoteVideoStatesOnCurrentPage.map { $0.attendeeId })
    return remoteVideoTileStates.filter { !remoteVideoAttendeeIdsOnCurrentPage.contains($0.attendeeId) }
}
```

Once we have the current page calculated, we can resume videos on the current page and pause rest of the videos. Note that user may also explicitly pause remote videos, and we will not resume those videos even they are on the current page.

```swift
func refreshVideoUI() {
    for remoteVideoTileState in remoteVideoStatesOnCurrentPage {
        if !userPausedVideoTileIds.contains(remoteVideoTileState.tileId) {
            audioVideoFacade.resumeRemoteVideoTile(tileId: remoteVideoTileState.tileId)
        }
    }
    for remoteVideoTileState in remoteVideoStatesNotOnCurrentPage {
        audioVideoFacade.pauseRemoteVideoTile(tileId: remoteVideoTileState.tileId)
    }
}

func onPauseToggled(tag: Int, paused: Bool) {
    if let tileState = getVideoTileState(for: IndexPath(item: tag, section: 0)), !tileState.isLocalTile {
        if paused {
            userPausedVideoTileIds.insert(tileState.tileId)
            audioVideoFacade.pauseRemoteVideoTile(tileId: tileState.tileId)
        } else {
            userPausedVideoTileIds.remove(tileState.tileId)
            audioVideoFacade.resumeRemoteVideoTile(tileId: tileState.tileId)
        }
    }
}
```

## Implementation - Active Speaker-Based Policy

The application can reorder video tiles based on the active speaker policy. To implement this, when `ActiveSpeakerPolicy` detects new active speakers, we sort `remoteVideoTileStates` accordingly so that videos from active speakers are promoted to the top of the list.

```swift
func updateRemoteVideoStatesBasedOnActiveSpeakers(activeSpeakers: [AttendeeInfo]) {
    let activeSpeakerIds = Set(activeSpeakers.map { $0.attendeeId })

    // Cast to NSArray to make sure the sorting implementation is stable
    remoteVideoTileStates = (remoteVideoTileStates as NSArray).sortedArray(options: .stable,
                                                                           usingComparator: { (lhs, rhs) -> ComparisonResult in
        let lhsIsActiveSpeaker = activeSpeakerIds.contains((lhs as? VideoTileState)?.attendeeId ?? "")
        let rhsIsActiveSpeaker = activeSpeakerIds.contains((rhs as? VideoTileState)?.attendeeId ?? "")

        if lhsIsActiveSpeaker == rhsIsActiveSpeaker {
            return ComparisonResult.orderedSame
        } else if lhsIsActiveSpeaker && !rhsIsActiveSpeaker {
            return ComparisonResult.orderedAscending
        } else {
            return ComparisonResult.orderedDescending
        }
    }) as? [VideoTileState] ?? []
}

func activeSpeakerDidDetect(attendeeInfo: [AttendeeInfo]) {
    updateRemoteVideoStatesBasedOnActiveSpeakers(activeSpeakers: attendeeInfo)
    refreshVideoUI()
}
```
