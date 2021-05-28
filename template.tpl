___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Query String Modifier",
  "categories": ["UTILITY"],
  "description": "Returns the query string from a given URL, either as it is or with redacted or removed non whitelisted parameters.",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "SELECT",
    "name": "location",
    "displayName": "URL Type",
    "macrosInSelect": true,
    "selectItems": [
      {
        "value": "page",
        "displayValue": "Page URL"
      },
      {
        "value": "element",
        "displayValue": "Element URL (click, form)"
      }
    ],
    "simpleValueType": true,
    "help": "Enter a variable which contains a URL. \u003cbr\u003e\u003cb\u003ePage URL\u003c/b\u003e and \u003cb\u003eElement URL\u003c/b\u003e are pre-defined values, but you could choose any variable you would like to."
  },
  {
    "type": "CHECKBOX",
    "name": "questionmark",
    "checkboxText": "Include question mark before query string (only if query exists)",
    "simpleValueType": true,
    "defaultValue": false
  },
  {
    "type": "CHECKBOX",
    "name": "whitelist",
    "checkboxText": "Only allow whitelisted parameters",
    "simpleValueType": true
  },
  {
    "type": "SELECT",
    "name": "redact_remove",
    "displayName": "Replace or remove non whitelisted parameter values",
    "macrosInSelect": false,
    "selectItems": [
      {
        "value": "remove",
        "displayValue": "Remove"
      },
      {
        "value": "redact",
        "displayValue": "Redact"
      }
    ],
    "simpleValueType": true,
    "help": "Choose whether to remove query parameters from the query string or to replace the values.",
    "enablingConditions": [
      {
        "paramName": "whitelist",
        "paramValue": true,
        "type": "EQUALS"
      }
    ],
    "subParams": [
      {
        "type": "TEXT",
        "name": "replacement",
        "displayName": "Replacement text",
        "simpleValueType": true,
        "defaultValue": "[REDACTED]",
        "enablingConditions": [
          {
            "paramName": "redact_remove",
            "paramValue": "redact",
            "type": "EQUALS"
          }
        ],
        "help": "Choose what text to replace the non whitelisted parameter value with.",
        "canBeEmptyString": true
      }
    ]
  },
  {
    "type": "SIMPLE_TABLE",
    "name": "whitelist_table",
    "displayName": "Enter the whitelisted parameters",
    "simpleTableColumns": [
      {
        "defaultValue": "",
        "displayName": "",
        "name": "parameter",
        "type": "TEXT"
      }
    ],
    "enablingConditions": [
      {
        "paramName": "whitelist",
        "paramValue": true,
        "type": "EQUALS"
      }
    ],
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ],
    "newRowButtonText": "Add Parameter",
    "help": "You should include UTM parameters, gclid and search query parameter if you don\u0027t want to break the default functionality in Google Analytics."
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const log = require('logToConsole');
const getUrl = require('getUrl');
const copyFromDataLayer = require('copyFromDataLayer');
log(data);
let url = data.location;

switch(data.location){
  case 'page':
    url = getUrl('protocol') + "://" + getUrl('host') + getUrl('path');
    if(getUrl('query')){
      url += "?" + getUrl('query');
    }
    break;
  case 'element':
    url = copyFromDataLayer('gtm.elementUrl');
    break;
  default:
    break;
}

let new_query_string = [];

const query_string = url.split("?");
if(query_string.length > 1){
  if(data.whitelist){
    const queries = query_string[1].split("&");
    let whitelist = data.whitelist_table.map(x => x.parameter);
    
    for(var query of queries){
      if(whitelist.indexOf(query.split("=")[0]) > -1){
         new_query_string.push(query);
      } else if(data.redact_remove === "redact"){
         new_query_string.push(query.split("=")[0] + "=" + data.replacement); 
      }
    }
  } else {
    new_query_string.push(query_string[1]); 
  }
} 

if(new_query_string.length > 0){
    if(data.questionmark){
       return "?" + new_query_string.join("&"); 
    } else {
       return new_query_string.join("&"); 
    }
}

return "";


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "read_data_layer",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keyPatterns",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "gtm.elementUrl"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "get_url",
        "versionId": "1"
      },
      "param": [
        {
          "key": "queriesAllowed",
          "value": {
            "type": 1,
            "string": "any"
          }
        },
        {
          "key": "urlParts",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "path",
          "value": {
            "type": 8,
            "boolean": true
          }
        },
        {
          "key": "protocol",
          "value": {
            "type": 8,
            "boolean": true
          }
        },
        {
          "key": "query",
          "value": {
            "type": 8,
            "boolean": true
          }
        },
        {
          "key": "host",
          "value": {
            "type": 8,
            "boolean": true
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "isRequired": true
  }
]


___TESTS___

scenarios:
- name: Test of default Page URL - Redact
  code: |-
    const mockData = {
      'location': 'page',
      'questionmark': true,
      'whitelist': true,
      'redact_remove': 'redact',
      'redact_remove.replacement': '[REDACTED]',
      'whitelist_table': [{
          'parameter': 'utm_source'
        }
       ]
    };

    // Call runCode to run the template's code.
    let variableResult = runCode(mockData);

    // Verify that the variable returns a result.
    assertThat(variableResult).isNotEqualTo(undefined);
- name: Test of custom Page URL - Redact
  code: "const mockData = {\n  'location': 'https://www.domain.com/test/?utm_source=test&test=123&pwd=1234',\n\
    \  'questionmark': true,\n  'whitelist': true,\n  'redact_remove': 'redact',\n\
    \  'replacement': '[REDACTED]',\n  'whitelist_table': [{\n      'parameter': 'utm_source'\n\
    \    },\n                      {\n                       'parameter': 'test' \n\
    \                      }\n   ]\n};\n\n// Call runCode to run the template's code.\n\
    let variableResult = runCode(mockData);\n\n// Verify that the variable returns\
    \ a result.\nassertThat(variableResult).isNotEqualTo(undefined);"
- name: Test of custom Page URL - Remove
  code: |-
    const mockData = {
      'location': 'https://www.domain.com/test/?utm_source=test&test=123&pwd=1234',
      'questionmark': true,
      'whitelist': true,
      'redact_remove': 'remove',
      'whitelist_table': [{
          'parameter': 'utm_source'
        }
       ]
    };

    // Call runCode to run the template's code.
    let variableResult = runCode(mockData);

    // Verify that the variable returns a result.
    assertThat(variableResult).isNotEqualTo(undefined);
- name: Test of custom Page URL - Remove - All
  code: |-
    const mockData = {
      'location': 'https://www.domain.com/test/?utm_source=test&test=123&pwd=1234',
      'questionmark': true,
      'whitelist': true,
      'redact_remove': 'remove',
      'whitelist_table': [{
          'parameter': 'utm_medium'
        }
       ]
    };

    // Call runCode to run the template's code.
    let variableResult = runCode(mockData);

    // Verify that the variable returns a result.
    assertThat(variableResult).isNotEqualTo(undefined);


___NOTES___

Created on 5/28/2021, 10:28:55 PM


