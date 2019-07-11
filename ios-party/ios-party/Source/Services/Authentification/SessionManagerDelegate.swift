
protocol SessionManagerDelegate {
    func sessionManagerLoginSuccessful(_ sessionManager: SessionManager)
    func sessionManagerLoginError(_ sessionManager: SessionManager, error: Error)
}
