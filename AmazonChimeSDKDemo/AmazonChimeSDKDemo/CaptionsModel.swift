//
//  CaptionsModel.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDK
import UIKit

class CaptionsModel: NSObject {
    var captions = [Caption]()
    var captionIndices = [String: Int]()    // map resultId to index in captions array
    var refreshCaptionsTableHandler: (() -> Void)?

    // triggered on main thread, no synchronization needed
    public func addTranscriptEvent(transcriptEvent: TranscriptEvent) {
        if let status = transcriptEvent as? TranscriptionStatus {
            let formattedEventTime = TimeStampConversion.formatTimestamp(timestamp: status.eventTimeMs)
            let content = "Live transcription \(status.type) at \(formattedEventTime) in \(status.transcriptionRegion) with configuration: \(status.transcriptionConfiguration)"
            let caption = Caption(speakerName: "",
                                  isPartial: false,
                                  content: content)
            captions.append(caption)
        } else if let transcript = transcriptEvent as? Transcript {
            transcript.results.forEach { result in
                guard let alternative = result.alternatives.first else {
                    return
                }

                // for simplicity and demo purposes, assume each result only contains transcripts from
                // the same speaker, which matches our observation with current transcription service behavior.
                // More complicated UI logic can be achieved by iterating through each item
                var speakerName: String
                if let firstItem = alternative.items.first {
                    speakerName = RosterModel.convertAttendeeName(from: firstItem.attendee)
                } else {
                    speakerName = ""
                }

                let caption = Caption(speakerName: speakerName,
                                      isPartial: result.isPartial,
                                      content: alternative.transcript)

                if let captionIndex = captionIndices[result.resultId] {
                    // update existing (partial) caption if exists
                    captions[captionIndex] = caption
                } else {
                    captions.append(caption)
                    captionIndices[result.resultId] = captions.count - 1
                }
            }
        }
        refreshCaptionsTableHandler?()
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource

extension CaptionsModel: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return captions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let caption = captions[indexPath.item]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: captionCellReuseIdentifier) as? CaptionCell else {
            return CaptionCell(caption: caption)
        }
        cell.updateCell(caption: caption)
        return cell
    }
}
