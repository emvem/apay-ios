//
// Created by Mikhail Belikov on 05.09.2023.
//

import Foundation
import UIKit
import SwiftUI

// https://github.com/alexdremov/PathPresenter?ref=alexdremov.me

class AirbaPayCoordinator: UIViewController {

    private var navigation: UINavigationController? = nil

    func startProcessing() {
        LoggerHelper.nextPage(pageName: "StartProcessingView")
        openPage(content: StartProcessingPage(navigateCoordinator: self))
    }

    func openHome() {
        LoggerHelper.nextPage(pageName: "HomePage")
        openPage(content: HomePage(navigateCoordinator: self))
    }

    func backToStartPage() {
        LoggerHelper.clear()
        navigationController?.popToRootViewController(animated: false)
        startProcessing()
    }

    func backToApp(
            result: Bool = false
    ) {
        LoggerHelper.clear()
        DataHolder.actionOnCloseProcessing?(result)
    }

    func openAcquiring(
            redirectUrl: String?
    ) {
        LoggerHelper.nextPage(pageName: "AcquiringPage")
        openPage(content: AcquiringPage(navigateCoordinator: self, redirectUrl: redirectUrl))
    }

    func openSuccess() {
        LoggerHelper.nextPage(pageName: "SuccessPage")

        if DataHolder.openCustomPageSuccess != nil {
            navigationController?.popToRootViewController(animated: false)
            DataHolder.openCustomPageSuccess!()
        } else {
            openPage(content: SuccessPage(navigateCoordinator: self))
        }
    }

    func openRepeat() {
        LoggerHelper.nextPage(pageName: "RepeatPage")
        openPage(content: RepeatPage(navigateCoordinator: self))
    }

    func openErrorPageWithCondition(
            errorCode: Int?
    ) {

        let error = ErrorsCode(code: errorCode ?? 1).getError()

        if (error == ErrorsCode().error_1) {
            LoggerHelper.nextPage(pageName: "ErrorSomethingWrongPage")
            openPage(content: ErrorSomethingWrongPage(navigateCoordinator: self))

        } else if (error.code == ErrorsCode().error_5020.code || errorCode == nil) {
            LoggerHelper.nextPage(pageName: "ErrorFinalPage")

            if DataHolder.openCustomPageFinalError != nil {
                navigationController?.popToRootViewController(animated: false)
                DataHolder.openCustomPageFinalError!()
            } else {
                openPage(content: ErrorFinalPage(navigateCoordinator: self))
            }

        } else if (error.code == ErrorsCode().error_5999.code && DataHolder.bankCode?.isEmpty == false) {
            LoggerHelper.nextPage(pageName: "ErrorWithInstructionPage")
            openPage(content: ErrorWithInstructionPage(navigateCoordinator: self))

        } else {
            LoggerHelper.nextPage(pageName: "ErrorPage")
            openPage(content: ErrorPage(
                    errorCode: ErrorsCode(code: errorCode ?? 1),
                    navigateCoordinator: self)
            )
        }
    }

    func openPage(content: some View) {
        if navigation == nil {
            let window = UIApplication.shared.connectedScenes
                    .filter({$0.activationState == .foregroundActive})
                    .map({$0 as? UIWindowScene})
                    .compactMap({$0})
                    .first?.windows
                    .filter({$0.isKeyWindow}).first

            navigation = UINavigationController(rootViewController: self)

            window?.rootViewController = navigation
        }

        let newVC = UIHostingController(rootView: content)

        navigationController?.setToolbarHidden(true, animated: false)
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.toolbar?.isHidden = true
        navigationController?.pushViewController(newVC, animated: false)

    }

}