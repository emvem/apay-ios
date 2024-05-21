//
//  ExternalApiApplePay.swift
//  AirbaPaySdk
//
//  Created by Mikhail Belikov on 15.05.2024.
//

import Foundation
import UIKit

extension AirbaPaySdk {

    func blProcessExternalApplePay() {
        blAuth(
                navigateCoordinator: navigateCoordinator,
                onSuccess: {
                    blInitPayments(
                            onApplePayResult: { _ in
                                DispatchQueue.main.async {
                                    DataHolder.isApplePayFlow = true
                                    self.navigateCoordinator.applePay!.buyBtnTapped()
                                }
                            },
                            navigateCoordinator: self.navigateCoordinator
                    )
                },
                paymentId: nil
        )
    }

    func blProcessExternalApplePay(uiViewController: UIViewController) {
        blAuth(
                navigateCoordinator: navigateCoordinator,
                onSuccess: {
                    blInitPayments(
                            onApplePayResult: { _ in
                                DispatchQueue.main.async {
                                    DataHolder.isApplePayFlow = true
                                    self.navigateCoordinator.applePay!.buyBtnTapped(uiViewController: uiViewController)
                                }
                            },
                            navigateCoordinator: self.navigateCoordinator
                    )
                },
                paymentId: nil
        )
    }
}
