// NOTES
// SelectRecordAction.cls
// public with sharing class SelectRecordAction {
//     @InvocableMethod(configurationEditor='c-select-record-editor')
//     public static List <Results> selectRecord(List<Requests> requestList) {
//         List<SObject> inputCollection = requestList[0].inputCollection;
//         //Store the first input record for output
//         SObject outputMember = inputCollection[0];
//         Results response = new Results();
//         response.outputMember = outputMember;
//         List<Results> responseWrapper= new List<Results>();
//         responseWrapper.add(response);
//         return responseWrapper;
//     }

// public class Requests {
//     @InvocableVariable(label='Object for Input' description='Records for Input')
//     public List<SObject> inputCollection;
//     }

// public class Results {
//     @InvocableVariable(label='Object for Storing Output' description='Records for Output')
//     public SObject outputMember;
//     }
// }


public class BananaClipController {
	@InvocableMethod(label='Create MailGun Job' description='Select a MailGun template and send to recipients' configurationEditor='c-banana-clip-settings')
	public static List<String> queueMailGunJob(List<BananaClip> inputs) {
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
			// placeholders
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
		public String templateName;
		@AuraEnabled @InvocableVariable(label='Record Collection' description='Records to use for sending' required=true)
		public List<sObject> records;
		@AuraEnabled @InvocableVariable(label='API Name of Email Field' description='The field on the records you want to put in the To: field' required=true)
		public String emailField;
		@AuraEnabled @InvocableVariable(label='Subject Line' description='The subject of the email' required=true)
		public String emailSubject;
		@AuraEnabled @InvocableVariable(label='Email Body' description='The body of the email. Please use the field map to include recipient-specific information' required=true)
		public String emailBody;
		@AuraEnabled @InvocableVariable(label='Field Map' description='Write one pair per line in the form <Salesforce Field Name> = <MailGun template field>' required=true)
		public String fieldMap; // string v long text?
	}
}
