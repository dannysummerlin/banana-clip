// NOTES
// https://developer.salesforce.com/docs/component-library/documentation/en/lwc/lwc.use_flow_custom_property_editor_sobject_action_example
// inputVariables:
// [{
//     name: 'inputType',
//     value: 'Account',
//     valueDataType: 'Account'
// }]
// builderContext is real important
// InvocableVariable:
// [{
//     typeName: 'T__inputCollection', 
//     typeValue: 'Account' 
// }]

import { LightningElement, api } from 'lwc'

export default class BananaClipSettings extends LightningElement {
	@api inputVariables
	@api genericTypeMappings
	@api builderContext

// templateName
// recordType
// records
// emailField
// fieldMap
// emailSubject
// emailBody

	get inputValue() {
		const param = this.inputVariables.find(({ name }) => name === 'inputCollection')
		return param && param.value
	}

	get inputType() {
		const type = this.genericTypeMappings.find(
		({ typeName }) => typeName === 'T__inputCollection'
		)
		return type && type.typeValue
	}

	get outputType() {
		const type = this.genericTypeMappings.find(
		({ typeName }) => typeName === "U__outputMember"
		)
		return type && type.typeValue
	}

	get typeOptions() {
		return [
		  { label: 'Account', value: 'Account' },
		  { label: 'Case', value: 'Case' },
		{ label: 'Lead', value: 'Lead' },
		]
	}

	get valueOptions() {
		const variables = this.builderContext.variables
		return variables.map(({ name }) => ({
			label: name,
			value: name,
		}))
	}

	handleInputTypeChange(event) {
		if (event && event.detail) {
			const newValue = event.detail.value
			const typeChangedEvent = new CustomEvent(
				'configuration_editor_generic_type_mapping_changed',
				{
					bubbles: true,
					cancelable: false,
					composed: true,
					detail: {
						typeName: 'T__inputCollection',
						typeValue: newValue
					},
				}
			)
		this.dispatchEvent(typeChangedEvent)
		}
	}

	handleOutputTypeChange(event) {
		if (event && event.detail) {
			const newValue = event.detail.value
			const typeChangedEvent = new CustomEvent(
				"configuration_editor_generic_type_mapping_changed",
				{
					bubbles: true,
					cancelable: false,
					composed: true,
					detail: {
						typeName: "U__outputMember",
						typeValue: newValue
					}
				}
			)
		this.dispatchEvent(typeChangedEvent)
		}
	}

	handleValueChange(event) {
		if (event && event.detail) {
			const newValue = event.detail.value
			const valueChangedEvent = new CustomEvent(
				'configuration_editor_input_value_changed',
				{
					bubbles: true,
					cancelable: false,
					composed: true,
					detail: {
						name: 'inputCollection',
						newValue,
						newValueDataType: 'reference',
					},
				}
			)
		this.dispatchEvent(valueChangedEvent)
		}
	}
}