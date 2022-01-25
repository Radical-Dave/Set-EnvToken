Describe 'smoke tests' {
    BeforeAll {
        $ModuleScriptPath = $PSCommandPath.Replace('\tests\','\').Replace('.Tests.','.')
        $PSScriptName = (Split-Path $ModuleScriptPath -Leaf).Replace('.ps1','')
        . $ModuleScriptPath
    }
    It 'passes default PSScriptAnalyzer rules' {        
        Invoke-ScriptAnalyzer -Path $ModuleScriptPath | Should -BeNullOrEmpty
    }
    It 'passes empty params' {
        {&"$PSScriptName"} | Should -Not -BeNullOrEmpty
    }
    It 'passes do test' {
        $results = . .\"$PSScriptName"
        $check = [System.Environment]::GetEnvironmentVariable('subscription')
        $check | Should -Not -BeNullOrEmpty
    }
}