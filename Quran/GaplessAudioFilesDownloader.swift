//
//  GaplessAudioFilesDownloader.swift
//  Quran
//
//  Created by Mohamed Afifi on 5/14/16.
//  Copyright © 2016 Quran.com. All rights reserved.
//

import Foundation

class GaplessAudioFilesDownloader: DefaultAudioFilesDownloader {

    let downloader: DownloadManager

    var response: Response?

    init(downloader: DownloadManager) {
        self.downloader = downloader
    }

    func filesForQari(_ qari: Qari,
                      startAyah: AyahNumber,
                      endAyah: AyahNumber) -> [Download] {

        guard case AudioType.gapless(let databaseFileName) = qari.audioType else {
            fatalError("Unsupported qari type gapped. Only gapless qaris can be downloaded here.")
        }

        let databaseRemoteURL = QuranURLs.AudioDatabaseURL.appendingPathComponent(
            databaseFileName).appendingPathExtension(Files.databaseRemoteFileExtension)
        let databaseLocalURL = qari.path.stringByAppendingPath(
            databaseFileName).stringByAppendingExtension(Files.databaseRemoteFileExtension)
        let databaseResumeURL = databaseLocalURL.stringByAppendingExtension(Files.downloadResumeDataExtension)

        // loop over the files
        var files: [Download] = []
        files.append(Download(url: databaseRemoteURL, resumePath: databaseResumeURL, destinationPath: databaseLocalURL))

        for sura in startAyah.sura...endAyah.sura {
            let fileName = String(format: "%03d", sura)

            let remoteURL = qari.audioURL.appendingPathComponent(fileName).appendingPathExtension(Files.audioExtension)
            let localURL = qari.path.stringByAppendingPath(fileName).stringByAppendingExtension(Files.audioExtension)
            let resumeURL = localURL.stringByAppendingExtension(Files.downloadResumeDataExtension)

            files.append(Download(url: remoteURL, resumePath: resumeURL, destinationPath: localURL))
        }
        return files
    }
}
