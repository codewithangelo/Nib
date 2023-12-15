//
//  ReportPoemView.swift
//  Nib
//
//  Created by Angelo Austria on 2023-12-11.
//

import SwiftUI

struct ReportPoemView: View {
    let poem: Poem
    var onReportCompleted: (() -> Void)? = nil
    
    private static let reportingService: ReportingServiceProtocol = ReportingService()
    
    @StateObject
    private var viewModel: ReportPoemViewModel = ReportPoemViewModel(reportingService: reportingService)
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("report.title")
                .font(.headline)
                .bold()
                .padding(.bottom)
                .frame(maxWidth: .infinity)
            
            Text("Why are you reporting this poem?")
                .font(.headline)
                .bold()
                .padding(.bottom)
            
            reportSpamRadio
            reportSexualRadio
            reportHateSpeechRadio
            reportBullyingRadio
            reportFakeNewsRadio
            reportViolenceRadio
            reportSelfHarmRadio
            
            Button(
                role: .destructive,
                action: {
                    reportPoem()
                    onReportCompleted?()
                },
                label: { Text("Submit Report") }
            )
            
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

extension ReportPoemView {
    private var reportSpamRadio: some View {
        RadioButton(
            id: ReportReason.spam.rawValue,
            checked: viewModel.reason == ReportReason.spam,
            onCheck: onRadioCheck,
            label: { Text("It's spam") }
        )
    }
    
    private var reportSexualRadio: some View {
        RadioButton(
            id: ReportReason.sexual.rawValue,
            checked: viewModel.reason == ReportReason.sexual,
            onCheck: onRadioCheck,
            label: { Text("Contains sexual content") }
        )
    }
    
    private var reportHateSpeechRadio: some View {
        RadioButton(
            id: ReportReason.hateSpeech.rawValue,
            checked: viewModel.reason == ReportReason.hateSpeech,
            onCheck: onRadioCheck,
            label: { Text("Contains hate speech or symbols") }
        )
    }
    
    private var reportBullyingRadio: some View {
        RadioButton(
            id: ReportReason.bullying.rawValue,
            checked: viewModel.reason == ReportReason.bullying,
            onCheck: onRadioCheck,
            label: { Text("Bullying or harassment") }
        )
    }
    
    private var reportFakeNewsRadio: some View {
        RadioButton(
            id: ReportReason.fakeNews.rawValue,
            checked: viewModel.reason == ReportReason.fakeNews,
            onCheck: onRadioCheck,
            label: { Text("It's fake news or false information") }
        )
    }
    
    private var reportViolenceRadio: some View {
        RadioButton(
            id: ReportReason.violent.rawValue,
            checked: viewModel.reason == ReportReason.violent,
            onCheck: onRadioCheck,
            label: { Text("Violence") }
        )
    }
    
    private var reportSelfHarmRadio: some View {
        RadioButton(
            id: ReportReason.selfHarm.rawValue,
            checked: viewModel.reason == ReportReason.selfHarm,
            onCheck: onRadioCheck,
            label: { Text("Mentions self-harm") }
        )
    }
}

extension ReportPoemView {
    private func onRadioCheck(id: String) -> Void {
        guard let reason = ReportReason.ID(rawValue: id) else {
            // TODO: Throw error
            return
        }
        
        viewModel.reason = reason
    }
}

extension ReportPoemView {
    private func reportPoem() {
        guard let poemId = poem.id else {
            // TODO: Throw error
            return
        }
        
        Task {
            do {
                try await viewModel.confirmReport(poemId: poemId)
            } catch {
                print(error)
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
