/**
* Class defining constants like TotalCheck Web Service Namespaces, current environment, string constants etc
*
* Author: vidhyashankar@prmaustralia.com.au
*/
public with sharing class TotalCheckConstants {
    // TotalCheck WS Namespaces, Schema URL
    public static final String STAGE_REQUEST_NS = 'https://stage.totalcheck.sensis.com.au/service/webservice';
    public static final String STAGE_RESPONSE_NS = 'http://totalcheck.sensis.com.au/service';
    public static final String LIVE_REQUEST_NS = 'https://totalcheck.sensis.com.au/service/webservice';
    public static final String LIVE_RESPONSE_NS = 'http://totalcheck.sensis.com.au/service';
    public static final String XML_SCHEMA_NS = 'http://www.w3.org/2001/XMLSchema';
    public static final String SECURITY_HEADER_SCHEMA_NS = 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd';
    
    // General constants
    public static final String ACCOUNT_ID_STARTS_WITH = '001';
    public static final String CONTACT_ID_STARTS_WITH = '003';
    public static final String LEAD_ID_STARTS_WITH = '00Q';
    public static final String URL_ENCODING = 'UTF-8';
    public static final String RETURN_URL_KEY = 'retURL';
    public static final String RECORD_TYPE_KEY = 'RecordType';
    public static final String OBJECT_TYPE_KEY = 'ent';
    public static final String SEARCH_TYPE_RESIDENTIAL = 'Residential';
    public static final String SEARCH_TYPE_BUSINESS = 'Business';
    public static final String SEARCH_TYPE_ALL = 'Both';
    
    // Modify the below to switch between live and stage environments
    // Both will use credentials saved via TotalCheckAPIController only   
    public static final String ENV_REQUEST_NS = LIVE_REQUEST_NS;
    public static final String ENV_RESPONSE_NS = LIVE_RESPONSE_NS;
}