/**
* Wrapper class for TotalCheck Web Service
* Manual modifications are mostly constants and comments. These are marked thus in other cases with comments
* Author: wsdl2apex (Salesforce)
* Modified by: vidhyashankar@prmaustralia.com.au
  
* Salesforce doesn't provide documentation (at the time of development) around the use of the WebServiceCallout.invoke() method 
* Filling in what is available from forums etc
* WebServiceCallout.invoke(
*     <Instance of ServicePort class>,
*     <Instance of Request class>,
*     <Instance of Response class>,
*     new String[]{<WS endpoint URL>,
*        <soapAction if any or blank>,
*        <Request schema>,
*        <Request method name>,
*        <Response schema>,
*        <Apex class for response; response unserialized to this type>}
*    );
*/
public with sharing class TotalCheckWebService {
    public class SelectAddress {
        public TotalCheckWebService.addressSuggestion suggestion;
        private String[] suggestion_type_info = new String[]{'suggestion',TotalCheckConstants.ENV_REQUEST_NS,'addressSuggestion','0','1','false'};
        private String[] apex_schema_type_info = new String[]{TotalCheckConstants.ENV_REQUEST_NS,'false','false'};
        private String[] field_order_type_info = new String[]{'suggestion'};
    }
    public class ClientSystemException extends Exception{
        private String[] apex_schema_type_info = new String[]{TotalCheckConstants.ENV_REQUEST_NS,'false','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class SuggestAddressesResult {
        public String debug;
        public TotalCheckWebService.addressSuggestion[] resultList;
        public Integer resultStatus;
        private String[] debug_type_info = new String[]{'debug',TotalCheckConstants.XML_SCHEMA_NS,'string','0','1','false'};
        private String[] resultList_type_info = new String[]{'resultList',TotalCheckConstants.ENV_REQUEST_NS,'addressSuggestion','0','-1','true'};
        private String[] resultStatus_type_info = new String[]{'resultStatus',TotalCheckConstants.XML_SCHEMA_NS,'int','1','1','false'};
        private String[] apex_schema_type_info = new String[]{TotalCheckConstants.ENV_REQUEST_NS,'false','false'};
        private String[] field_order_type_info = new String[]{'debug','resultList','resultStatus'};
    }
    public class UsernameToken {
        /* Constructor added to initalize credentials for WS callout */
        public UsernameToken(String username, String password) {
            this.Username = username;
            this.Password = password;
        }
        public String Username;
        public String Password;
        private String[] Username_type_info = new String[]{'Username',TotalCheckConstants.SECURITY_HEADER_SCHEMA_NS,'string','1','1','false'};
        private String[] Password_type_info = new String[]{'Password',TotalCheckConstants.SECURITY_HEADER_SCHEMA_NS,'string','1','1','false'};
        private String[] apex_schema_type_info = new String[]{TotalCheckConstants.SECURITY_HEADER_SCHEMA_NS,'true','true'};
        private String[] field_order_type_info = new String[]{'Username','Password'};
    }
    public class SuggestNames {
        public String searchType;
        public String name;
        private String[] searchType_type_info = new String[]{'searchType',TotalCheckConstants.XML_SCHEMA_NS,'string','0','1','false'};
        private String[] name_type_info = new String[]{'name',TotalCheckConstants.XML_SCHEMA_NS,'string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{TotalCheckConstants.ENV_REQUEST_NS,'false','false'};
        private String[] field_order_type_info = new String[]{'searchType','name'};
    }
    public class SelectAddressResult {
        public String[] alternativePhoneNumbers;
        public String barcode;
        public String bsp;
        public String buildingName;
        public String debug;
        public TotalCheckWebService.AddressDetail[] detailList;
        public String dpid;
        public String formattedAddress;
        public Boolean inPrintedWpBook;
        public String phoneNumber;
        public Boolean postal;
        public String postcode;
        public String primaryName;
        public Integer resultStatus;
        public String secondaryName;
        public String state;
        public String streetName;
        public String streetNumber;
        public String streetSuffix;
        public String streetType;
        public String subPremise;
        public String suburb;
        public Boolean whitePages;
        public String wpListingType;
        private String[] alternativePhoneNumbers_type_info = new String[]{'alternativePhoneNumbers',TotalCheckConstants.XML_SCHEMA_NS,'string','0','-1','true'};
        private String[] barcode_type_info = new String[]{'barcode',TotalCheckConstants.XML_SCHEMA_NS,'string','0','1','false'};
        private String[] bsp_type_info = new String[]{'bsp',TotalCheckConstants.XML_SCHEMA_NS,'string','0','1','false'};
        private String[] buildingName_type_info = new String[]{'buildingName',TotalCheckConstants.XML_SCHEMA_NS,'string','0','1','false'};
        private String[] debug_type_info = new String[]{'debug',TotalCheckConstants.XML_SCHEMA_NS,'string','0','1','false'};
        private String[] detailList_type_info = new String[]{'detailList',TotalCheckConstants.ENV_REQUEST_NS,'AddressDetail','0','-1','true'};
        private String[] dpid_type_info = new String[]{'dpid',TotalCheckConstants.XML_SCHEMA_NS,'string','0','1','false'};
        private String[] formattedAddress_type_info = new String[]{'formattedAddress',TotalCheckConstants.XML_SCHEMA_NS,'string','0','1','false'};
        private String[] inPrintedWpBook_type_info = new String[]{'inPrintedWpBook',TotalCheckConstants.XML_SCHEMA_NS,'boolean','1','1','false'};
        private String[] phoneNumber_type_info = new String[]{'phoneNumber',TotalCheckConstants.XML_SCHEMA_NS,'string','0','1','false'};
        private String[] postal_type_info = new String[]{'postal',TotalCheckConstants.XML_SCHEMA_NS,'boolean','1','1','false'};
        private String[] postcode_type_info = new String[]{'postcode',TotalCheckConstants.XML_SCHEMA_NS,'string','0','1','false'};
        private String[] primaryName_type_info = new String[]{'primaryName',TotalCheckConstants.XML_SCHEMA_NS,'string','0','1','false'};
        private String[] resultStatus_type_info = new String[]{'resultStatus',TotalCheckConstants.XML_SCHEMA_NS,'int','1','1','false'};
        private String[] secondaryName_type_info = new String[]{'secondaryName',TotalCheckConstants.XML_SCHEMA_NS,'string','0','1','false'};
        private String[] state_type_info = new String[]{'state',TotalCheckConstants.XML_SCHEMA_NS,'string','0','1','false'};
        private String[] streetName_type_info = new String[]{'streetName',TotalCheckConstants.XML_SCHEMA_NS,'string','0','1','false'};
        private String[] streetNumber_type_info = new String[]{'streetNumber',TotalCheckConstants.XML_SCHEMA_NS,'string','0','1','false'};
        private String[] streetSuffix_type_info = new String[]{'streetSuffix',TotalCheckConstants.XML_SCHEMA_NS,'string','0','1','false'};
        private String[] streetType_type_info = new String[]{'streetType',TotalCheckConstants.XML_SCHEMA_NS,'string','0','1','false'};
        private String[] subPremise_type_info = new String[]{'subPremise',TotalCheckConstants.XML_SCHEMA_NS,'string','0','1','false'};
        private String[] suburb_type_info = new String[]{'suburb',TotalCheckConstants.XML_SCHEMA_NS,'string','0','1','false'};
        private String[] whitePages_type_info = new String[]{'whitePages',TotalCheckConstants.XML_SCHEMA_NS,'boolean','1','1','false'};
        private String[] wpListingType_type_info = new String[]{'wpListingType',TotalCheckConstants.XML_SCHEMA_NS,'string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{TotalCheckConstants.ENV_REQUEST_NS,'false','false'};
        private String[] field_order_type_info = new String[]{'alternativePhoneNumbers','barcode','bsp','buildingName','debug','detailList','dpid','formattedAddress','inPrintedWpBook','phoneNumber','postal','postcode','primaryName','resultStatus','secondaryName','state','streetName','streetNumber','streetSuffix','streetType','subPremise','suburb','whitePages','wpListingType'};
    }
    public class AddressDetail {
        public String barcode;
        public String bsp;
        public String buildingName;
        public String dpid;
        public String formattedAddress;
        public String postcode;
        public String state;
        public String streetName;
        public String streetNumber;
        public String streetSuffix;
        public String streetType;
        public String subPremise;
        public String suburb;
        private String[] barcode_type_info = new String[]{'barcode',TotalCheckConstants.XML_SCHEMA_NS,'string','0','1','false'};
        private String[] bsp_type_info = new String[]{'bsp',TotalCheckConstants.XML_SCHEMA_NS,'string','0','1','false'};
        private String[] buildingName_type_info = new String[]{'buildingName',TotalCheckConstants.XML_SCHEMA_NS,'string','0','1','false'};
        private String[] dpid_type_info = new String[]{'dpid',TotalCheckConstants.XML_SCHEMA_NS,'string','0','1','false'};
        private String[] formattedAddress_type_info = new String[]{'formattedAddress',TotalCheckConstants.XML_SCHEMA_NS,'string','0','1','false'};
        private String[] postcode_type_info = new String[]{'postcode',TotalCheckConstants.XML_SCHEMA_NS,'string','0','1','false'};
        private String[] state_type_info = new String[]{'state',TotalCheckConstants.XML_SCHEMA_NS,'string','0','1','false'};
        private String[] streetName_type_info = new String[]{'streetName',TotalCheckConstants.XML_SCHEMA_NS,'string','0','1','false'};
        private String[] streetNumber_type_info = new String[]{'streetNumber',TotalCheckConstants.XML_SCHEMA_NS,'string','0','1','false'};
        private String[] streetSuffix_type_info = new String[]{'streetSuffix',TotalCheckConstants.XML_SCHEMA_NS,'string','0','1','false'};
        private String[] streetType_type_info = new String[]{'streetType',TotalCheckConstants.XML_SCHEMA_NS,'string','0','1','false'};
        private String[] subPremise_type_info = new String[]{'subPremise',TotalCheckConstants.XML_SCHEMA_NS,'string','0','1','false'};
        private String[] suburb_type_info = new String[]{'suburb',TotalCheckConstants.XML_SCHEMA_NS,'string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{TotalCheckConstants.ENV_REQUEST_NS,'false','false'};
        private String[] field_order_type_info = new String[]{'barcode','bsp','buildingName','dpid','formattedAddress','postcode','state','streetName','streetNumber','streetSuffix','streetType','subPremise','suburb'};
    }
    public class SuggestAddressesResponse {
        public TotalCheckWebService.SuggestAddressesResult return_x;
        private String[] return_x_type_info = new String[]{'return',TotalCheckConstants.ENV_REQUEST_NS,'SuggestAddressesResult','0','1','false'};
        private String[] apex_schema_type_info = new String[]{TotalCheckConstants.ENV_REQUEST_NS,'false','false'};
        private String[] field_order_type_info = new String[]{'return_x'};
    }
    public class Security {
        String username;
        String password;
        public TotalCheckWebService.UsernameToken UsernameToken;
        
        /* Constructor added to initialize WSSE Security header */
        public Security(String username, String password){
            this.username = username;
            this.password = password;
            this.UsernameToken = new TotalCheckWebService.UsernameToken(username, password);
        }
        
        private String[] UsernameToken_type_info = new String[]{'UsernameToken',TotalCheckConstants.SECURITY_HEADER_SCHEMA_NS,'UsernameToken','1','1','false'};
        private String[] apex_schema_type_info = new String[]{TotalCheckConstants.SECURITY_HEADER_SCHEMA_NS,'true','true'};
        private String[] field_order_type_info = new String[]{'UsernameToken'};
    }
    public class AddressSuggestion {
        public String formattedAddress;
        public Integer index;
        public Boolean postal;
        public TotalCheckWebService.addressSearch search;
        public String secondaryName;
        public Boolean whitePages;
        private String[] formattedAddress_type_info = new String[]{'formattedAddress',TotalCheckConstants.XML_SCHEMA_NS,'string','0','1','false'};
        private String[] index_type_info = new String[]{'index',TotalCheckConstants.XML_SCHEMA_NS,'int','1','1','false'};
        private String[] postal_type_info = new String[]{'postal',TotalCheckConstants.XML_SCHEMA_NS,'boolean','1','1','false'};
        private String[] search_type_info = new String[]{'search',TotalCheckConstants.ENV_REQUEST_NS,'addressSearch','0','1','false'};
        private String[] secondaryName_type_info = new String[]{'secondaryName',TotalCheckConstants.XML_SCHEMA_NS,'string','0','1','false'};
        private String[] whitePages_type_info = new String[]{'whitePages',TotalCheckConstants.XML_SCHEMA_NS,'boolean','1','1','false'};
        private String[] apex_schema_type_info = new String[]{TotalCheckConstants.ENV_REQUEST_NS,'false','false'};
        private String[] field_order_type_info = new String[]{'formattedAddress','index','postal','search','secondaryName','whitePages'};
    }
    public class TotalCheckServiceImplPort {
        public String endpoint_x = TotalCheckConstants.ENV_REQUEST_NS;
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        public TotalCheckWebService.Security Security;
        private String Security_hns = 'Security=' + TotalCheckConstants.SECURITY_HEADER_SCHEMA_NS; // For WSSE security schema
        private String[] ns_map_type_info = new String[]{TotalCheckConstants.ENV_REQUEST_NS, 'TotalCheckWebService'};
        
        /* Constructor to initialize WS callout */
        public TotalCheckServiceImplPort(String APIUsername, String APIPassword){
            Security = new TotalCheckWebService.Security(APIUsername, APIPassword);
        }
         
        public TotalCheckWebService.SelectAddressResult selectAddress(TotalCheckWebService.AddressSuggestion suggestion) {
            TotalCheckWebService.SelectAddress request_x = new TotalCheckWebService.SelectAddress();
            TotalCheckWebService.SelectAddressResponse response_x;
            request_x.suggestion = suggestion;
            Map<String, TotalCheckWebService.SelectAddressResponse> response_map_x = new Map<String, TotalCheckWebService.SelectAddressResponse>();
            response_map_x.put('response_x', response_x);
            System.debug(System.NOW());
            if(!Test.isRunningTest()){ // Test classes will skip this
                WebServiceCallout.invoke(
                  this,
                  request_x,
                  response_map_x,
                  new String[]{endpoint_x,
                  '',
                  TotalCheckConstants.ENV_REQUEST_NS,
                  'selectAddress',
                  TotalCheckConstants.STAGE_RESPONSE_NS,
                  'selectAddressResponse',
                  'TotalCheckWebService.SelectAddressResponse'}
                );
                System.debug(System.NOW());
                response_x = response_map_x.get('response_x');
            }
            else{
                // For test coverage
                SelectAddressResult selAddrRes = new SelectAddressResult();
                selAddrRes.formattedAddress = '34 ZigZag Street, SuburbS, MLB';
                selAddrRes.postal = true;
                selAddrRes.whitepages = true;
                selAddrRes.primaryName = 'abc';
                selAddrRes.secondaryName = 'try';
                selAddrRes.phoneNumber = '1239087';
                selAddrRes.suburb = 'SuburbS';
                TotalCheckWebService.AddressDetail detail1 = new TotalCheckWebService.AddressDetail();
                detail1.subPremise = 'subpremise1';
                detail1.formattedAddress = 'subpremise1/34 ZigZag Street, SuburbS, MLB';
                TotalCheckWebService.AddressDetail detail2 = new TotalCheckWebService.AddressDetail();
                detail2.subPremise = 'subpremise2';
                detail2.formattedAddress = 'subpremise2/34 ZigZag Street, SuburbS, MLB';
                selAddrRes.detailList = new List<TotalCheckWebService.AddressDetail>{detail1, detail2};
                SelectAddressResponse selAddrResponse = new SelectAddressResponse();
                selAddrResponse.return_x = selAddrRes;
                response_x = selAddrResponse;
            }
            system.debug(response_x);
            return response_x.return_x;
        }
        public String[] suggestNames(String searchType,String name) {
            TotalCheckWebService.SuggestNames request_x = new TotalCheckWebService.SuggestNames();
            TotalCheckWebService.SuggestNamesResponse response_x;
            request_x.searchType = searchType;
            request_x.name = name;
            Map<String, TotalCheckWebService.SuggestNamesResponse> response_map_x = new Map<String, TotalCheckWebService.SuggestNamesResponse>();
            response_map_x.put('response_x', response_x);
            System.debug(System.NOW());
            if(!Test.isRunningTest()){ // Test classes will skip this
                WebServiceCallout.invoke(
                  this,
                  request_x,
                  response_map_x,
                  new String[]{endpoint_x,
                  '',
                  TotalCheckConstants.ENV_REQUEST_NS,
                  'suggestNames',
                  TotalCheckConstants.STAGE_RESPONSE_NS,
                  'suggestNamesResponse',
                  'TotalCheckWebService.SuggestNamesResponse'}
                );
                System.debug(System.NOW());
                response_x = response_map_x.get('response_x');
             }
             else{
                // For test coverage
                SuggestNamesResponse suggN = new SuggestNamesResponse();
                suggN.return_x=new String[]{'abc','bcd','cde'};
                response_x = suggN;
             }
             system.debug(response_x);
             return response_x.return_x;
        }
        public TotalCheckWebService.SuggestAddressesResult suggestAddresses(TotalCheckWebService.addressSearch search) {
            TotalCheckWebService.SuggestAddresses request_x = new TotalCheckWebService.SuggestAddresses();
            TotalCheckWebService.SuggestAddressesResponse response_x;
            request_x.search = search;
            Map<String, TotalCheckWebService.SuggestAddressesResponse> response_map_x = new Map<String, TotalCheckWebService.SuggestAddressesResponse>();
            response_map_x.put('response_x', response_x);
            System.debug(System.NOW());
            if(!Test.isRunningTest()){ // Test classes will skip this
                WebServiceCallout.invoke(
                  this,
                  request_x,
                  response_map_x,
                  new String[]{endpoint_x,
                  '',
                  TotalCheckConstants.ENV_REQUEST_NS,
                  'suggestAddresses',
                  TotalCheckConstants.STAGE_RESPONSE_NS,
                  'suggestAddressesResponse',
                  'TotalCheckWebService.SuggestAddressesResponse'}
                );
                System.debug(System.NOW());
                response_x = response_map_x.get('response_x');
            }
            else{
                // For test coverage
                AddressSearch search1 = new AddressSearch();
                search1.formattedAddressIncludesPostcode = true;
                search1.formattedAddressIncludesState = true;
                search1.formattedAddressIncludesSuburb = true;
                search1.streetNumber = '34';
                search1.streetName = 'ZigZag Street';
                search1.suburb = 'SuburbS';
                search1.state = 'MLB';
                AddressSuggestion sugg = new AddressSuggestion();
                sugg.search = search1;
                sugg.postal = false;
                sugg.whitePages = false;
                sugg.formattedAddress = '34 ZigZag Street, SuburbS, MLB';
                SuggestAddressesResult suggAddrRes = new SuggestAddressesResult();
                suggAddrRes.resultList = new List<AddressSuggestion>();
                suggAddrRes.resultList.add(sugg);
                suggAddrRes.resultStatus = 1;
                SuggestAddressesResponse suggAddrResponse = new SuggestAddressesResponse();
                suggAddrResponse.return_x = suggAddrRes;
                response_x = suggAddrResponse;
            }
            system.debug(response_x);
            return response_x.return_x;
        }
    }
    public class SelectAddressResponse {
        public TotalCheckWebService.SelectAddressResult return_x;
        private String[] return_x_type_info = new String[]{'return',TotalCheckConstants.ENV_REQUEST_NS,'SelectAddressResult','0','1','false'};
        private String[] apex_schema_type_info = new String[]{TotalCheckConstants.ENV_REQUEST_NS,'false','false'};
        private String[] field_order_type_info = new String[]{'return_x'};
    }
    public class SuggestNamesResponse {
        public String[] return_x;
        private String[] return_x_type_info = new String[]{'return',TotalCheckConstants.XML_SCHEMA_NS,'string','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{TotalCheckConstants.ENV_REQUEST_NS,'false','false'};
        private String[] field_order_type_info = new String[]{'return_x'};
    }
    public class AddressSearch {
        public String formattedAddress;
        public Boolean formattedAddressIncludesPostcode;
        public Boolean formattedAddressIncludesState;
        public Boolean formattedAddressIncludesSuburb;
        public String name;
        public String options;
        public String phoneNumber;
        public String postcode;
        public String searchType;
        public String state;
        public String streetName;
        public String streetNumber;
        public String streetType;
        public String suburb;
        private String[] formattedAddress_type_info = new String[]{'formattedAddress',TotalCheckConstants.XML_SCHEMA_NS,'string','0','1','false'};
        private String[] formattedAddressIncludesPostcode_type_info = new String[]{'formattedAddressIncludesPostcode',TotalCheckConstants.XML_SCHEMA_NS,'boolean','1','1','false'};
        private String[] formattedAddressIncludesState_type_info = new String[]{'formattedAddressIncludesState',TotalCheckConstants.XML_SCHEMA_NS,'boolean','1','1','false'};
        private String[] formattedAddressIncludesSuburb_type_info = new String[]{'formattedAddressIncludesSuburb',TotalCheckConstants.XML_SCHEMA_NS,'boolean','1','1','false'};
        private String[] name_type_info = new String[]{'name',TotalCheckConstants.XML_SCHEMA_NS,'string','0','1','false'};
        private String[] options_type_info = new String[]{'options',TotalCheckConstants.XML_SCHEMA_NS,'string','0','1','false'};
        private String[] phoneNumber_type_info = new String[]{'phoneNumber',TotalCheckConstants.XML_SCHEMA_NS,'string','0','1','false'};
        private String[] postcode_type_info = new String[]{'postcode',TotalCheckConstants.XML_SCHEMA_NS,'string','0','1','false'};
        private String[] searchType_type_info = new String[]{'searchType',TotalCheckConstants.XML_SCHEMA_NS,'string','0','1','false'};
        private String[] state_type_info = new String[]{'state',TotalCheckConstants.XML_SCHEMA_NS,'string','0','1','false'};
        private String[] streetName_type_info = new String[]{'streetName',TotalCheckConstants.XML_SCHEMA_NS,'string','0','1','false'};
        private String[] streetNumber_type_info = new String[]{'streetNumber',TotalCheckConstants.XML_SCHEMA_NS,'string','0','1','false'};
        private String[] streetType_type_info = new String[]{'streetType',TotalCheckConstants.XML_SCHEMA_NS,'string','0','1','false'};
        private String[] suburb_type_info = new String[]{'suburb',TotalCheckConstants.XML_SCHEMA_NS,'string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{TotalCheckConstants.ENV_REQUEST_NS,'false','false'};
        private String[] field_order_type_info = new String[]{'formattedAddress','formattedAddressIncludesPostcode','formattedAddressIncludesState','formattedAddressIncludesSuburb','name','options','phoneNumber','postcode','searchType','state','streetName','streetNumber','streetType','suburb'};
    }
    public class SuggestAddresses {
        public TotalCheckWebService.addressSearch search;
        private String[] search_type_info = new String[]{'search',TotalCheckConstants.ENV_REQUEST_NS,'addressSearch','0','1','false'};
        private String[] apex_schema_type_info = new String[]{TotalCheckConstants.ENV_REQUEST_NS,'false','false'};
        private String[] field_order_type_info = new String[]{'search'};
    }
}