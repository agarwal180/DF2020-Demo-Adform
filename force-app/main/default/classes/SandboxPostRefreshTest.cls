@isTest
private class SandboxPostRefreshTest {
	@isTest
    static void testSandboxPostRefresh(){
        Test.startTest();
        SandboxContext context;
        SandboxPostRefresh sp=new SandboxPostRefresh();
        sp.runApexClass(context);
        Test.stopTest();
    }
}