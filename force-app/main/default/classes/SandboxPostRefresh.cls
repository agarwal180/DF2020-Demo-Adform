/*
    * Name        : ImportData_Test
    * Author        : Dmitrij Marcinkevic
    * Description   : Class generates test data on sandbox refresh
    * Maintenance History:
    * 2018-06-19
*/
global class SandboxPostRefresh implements SandboxPostCopy {
	global void runApexClass(SandboxContext context){
		ImportData.initData();
	}
}