public class BananaClipController {
	@InvocableMethod(label='Create MailGun Job' description='Select a MailGun template and send to recipients')
	public static List<String> queueMailGunJob(List<BananaClipController.BananaClip> inputs) {
		List<String> results = new String[inputs.size() - 1]; // can't remember if .size is 0 based or not
		Map<String,Map<String,String>> rawData = new Map<String,Map<String,String>>(); // can't remember if .size is 0 based or not
		for (Integer i = inputs.size(); i >= 0; --i ) {
			BananaClipController.BananaClip current = inputs[i];
			Map<String,String> dataMap = new Map<String,String>();
			List<String> mapEntries = current.fieldMap.split('\n');
			for (Integer j = mapEntries.size(); j >= 0; --j) {
				List<String> entry = mapEntries[j].split('=');
				dataMap.put(entry[0].trim(), entry[1].trim());
			}
			Integer dataMapLength = dataMap.size();
			for (Integer j = current.records.size(); j >= 0; --j) {
				String emailAddress = current.records[j][current.emailField];
				Map<String,String> recordData = new Map<String, String>();
				for (key : dataMap) {
					recordData.put(dataMap.get(key), current.records[j][key])
				}
				rawData.put(emailAddress, recordData);
			}
			Map<String,String> sendingJSON = Map<String,String>();
			requestData.put('template', current.templateName);
			requestData.put('recipients', current.rawData);
			String sendingJSON = JSON.stringify(requestData);
			results[i] = callWebService(url, sendingJSON);
		}
		return results;
	}

	// for lighting components to use, probably not necessary for this sort of thing
	// @AuraEnabled
	// public static String getBigHistory(String recordId, Integer resultCount) {
	// 	return JSON.serialize(hr);
	// }

	public class BananaClip {
		@AuraEnabled @InvocableVariable(label='Template' description='Template to use' required=true)
		public String templateName; // looking to make the interface for this dynamic, pulling the templates and pre-populating a single select control
		@AuraEnabled @InvocableVariable(label='Record Collection' description='Records to use for sending' required=true)
		public List<sObject> records;
		@AuraEnabled @InvocableVariable(label='API Name of Email Field' description='The field on the records you want to put in the To: field' required=true)
		public String emailField;
		// ends up being a text area with hand entered data. If possible would be good to parse the template field list and then offer drop downs for each to
		// be selected - the custom options feature could be the way to go here
		@AuraEnabled @InvocableVariable(label='Field Map' description='Write one pair per line in the form <Salesforce Field Name> = <MailGun template field>' required=true)
		public String fieldMap; // string v long text?
	}
}
