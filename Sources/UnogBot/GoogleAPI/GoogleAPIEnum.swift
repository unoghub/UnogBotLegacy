protocol GoogleAPIEnum {}

extension GoogleAPIEnum {
    var value: String {
        let caseName = "\(self)"

        var caseNameScreaming = ""
        for char in caseName {
            if char.isUppercase {
                caseNameScreaming += "_"
            }
            caseNameScreaming += char.uppercased()
        }

        return caseNameScreaming
    }
}
