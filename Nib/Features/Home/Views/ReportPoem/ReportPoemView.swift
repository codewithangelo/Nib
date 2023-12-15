//
//  ReportPoemView.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-11.
//

import SwiftUI

struct ReportPoemView: View {
    @EnvironmentObject
    var appRoot: AppRootViewModel
    
    let poem: Poem
    var onReportCompleted: (() -> Void)? = nil
    
    private static let reportingService: ReportingServiceProtocol = ReportingService()
    
    @StateObject
    private var viewModel: ReportPoemViewModel = ReportPoemViewModel(reportingService: reportingService)
    
    var body: some View {
        VStack(alignment: .leading) {
            viewTitle
            viewDescription
            
            reportSpamRadio
            reportSexualRadio
            reportHateSpeechRadio
            reportBullyingRadio
            reportFakeNewsRadio
            reportViolenceRadio
            reportSelfHarmRadio
            
            submitReportButton
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

extension ReportPoemView {
    private var viewTitle: some View {
        Text("report.title")
            .font(.headline)
            .bold()
            .padding([.top, .bottom])
            .frame(maxWidth: .infinity)
    }
    
    private var viewDescription: some View {
        Text("report.description")
            .font(.headline)
            .bold()
            .padding(.bottom)
    }
    
    private var submitReportButton: some View {
        Button(
            role: .destructive,
            action: {
                reportPoem()
                onReportCompleted?()
            },
            label: { Text("report.buttons.submitReport") }
        )
    }
    
    private var reportSpamRadio: some View {
        RadioButton(
            id: ReportReason.spam.rawValue,
            checked: viewModel.reason == ReportReason.spam,
            onCheck: onRadioCheck,
            label: { Text("report.radios.spam") }
        )
    }
    
    private var reportSexualRadio: some View {
        RadioButton(
            id: ReportReason.sexual.rawValue,
            checked: viewModel.reason == ReportReason.sexual,
            onCheck: onRadioCheck,
            label: { Text("report.radios.sexual") }
        )
    }
    
    private var reportHateSpeechRadio: some View {
        RadioButton(
            id: ReportReason.hateSpeech.rawValue,
            checked: viewModel.reason == ReportReason.hateSpeech,
            onCheck: onRadioCheck,
            label: { Text("report.radios.hateSpeech") }
        )
    }
    
    private var reportBullyingRadio: some View {
        RadioButton(
            id: ReportReason.bullying.rawValue,
            checked: viewModel.reason == ReportReason.bullying,
            onCheck: onRadioCheck,
            label: { Text("report.radios.bullying") }
        )
    }
    
    private var reportFakeNewsRadio: some View {
        RadioButton(
            id: ReportReason.fakeNews.rawValue,
            checked: viewModel.reason == ReportReason.fakeNews,
            onCheck: onRadioCheck,
            label: { Text("report.radios.fakeNews") }
        )
    }
    
    private var reportViolenceRadio: some View {
        RadioButton(
            id: ReportReason.violent.rawValue,
            checked: viewModel.reason == ReportReason.violent,
            onCheck: onRadioCheck,
            label: { Text("report.radios.violent") }
        )
    }
    
    private var reportSelfHarmRadio: some View {
        RadioButton(
            id: ReportReason.selfHarm.rawValue,
            checked: viewModel.reason == ReportReason.selfHarm,
            onCheck: onRadioCheck,
            label: { Text("report.radios.selfHarm") }
        )
    }
}

extension ReportPoemView {
    private func onRadioCheck(id: String) -> Void {
        guard let reason = ReportReason.ID(rawValue: id) else {
            appRoot.toast = Toast(
                style: .error,
                message: NSLocalizedString("report.error", comment: "")
            )
            return
        }
        
        viewModel.reason = reason
    }
}

extension ReportPoemView {
    private func reportPoem() {
        guard let poemId = poem.id else {
            appRoot.toast = Toast(
                style: .error,
                message: NSLocalizedString("report.error", comment: "")
            )
            return
        }
        
        Task {
            do {
                try await viewModel.confirmReport(poemId: poemId)
                appRoot.toast = Toast(
                    style: .success,
                    message: NSLocalizedString("report.success", comment: "")
                )
            } catch {
                appRoot.toast = Toast(
                    style: .error,
                    message: NSLocalizedString("report.error", comment: "")
                )
            }
        }
    }
}

#Preview {
    ReportPoemView(poem: Poem(
        authorId: "123",
        content: "Lorem Ipsum",
        title: "Title"
    ))
}
