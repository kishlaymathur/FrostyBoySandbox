<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_to_be_Sent_when_Machine_is_Dispatched_from_Warehouse</fullName>
        <description>Email to be Sent when Machine is Dispatched from Warehouse</description>
        <protected>false</protected>
        <recipients>
            <recipient>brigitte@frostyboy.com.au</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>felipe@frostyboy.com.au</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Mail_to_Operation_Manager</template>
    </alerts>
    <alerts>
        <fullName>Mail_to_John_to_notify_Contract_creation</fullName>
        <description>Mail to John to notify Contract creation</description>
        <protected>false</protected>
        <recipients>
            <recipient>john.willy@frostyboy.com.au</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Mail_to_John</template>
    </alerts>
    <alerts>
        <fullName>Mail_to_be_sent_to_Distributor_when_ETA_is_set</fullName>
        <description>Mail to be sent to Distributor when ETA is set</description>
        <protected>false</protected>
        <recipients>
            <field>Distributor_Primary_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>felipe@frostyboy.com.au</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Mail_to_Distributor</template>
    </alerts>
    <alerts>
        <fullName>Mail_to_be_sent_to_Sales_Admin_when_Internal_Delivery_Date_and_Machine_Fields_ar</fullName>
        <description>Mail to be sent to Sales Admin when Internal Delivery Date and Machine Fields are populated</description>
        <protected>false</protected>
        <recipients>
            <recipient>brigitte@frostyboy.com.au</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Mail_to_Sales_Admin</template>
    </alerts>
    <alerts>
        <fullName>Notify_Distributor_about_ETA</fullName>
        <description>Notify Distributor about ETA</description>
        <protected>false</protected>
        <recipients>
            <field>Distributor_Primary_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Mail_to_Distributor_2</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_notifying_Distributor_of_Expected_Date_of_Arrival</fullName>
        <description>Send Email notifying Distributor of Expected Date of Arrival</description>
        <protected>false</protected>
        <recipients>
            <field>Distributor_Primary_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Mail_to_Distributor_2</template>
    </alerts>
    <fieldUpdates>
        <fullName>Populate_term_as_12</fullName>
        <field>ContractTerm</field>
        <formula>12</formula>
        <name>Populate term as 12</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Primary_Email</fullName>
        <field>Distributor_Primary_Email__c</field>
        <formula>Account.Primary_Email__c</formula>
        <name>Set Primary Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Value_to_Contract_Terminated</fullName>
        <field>Status</field>
        <literalValue>Contract Terminated</literalValue>
        <name>Set Value to Contract Terminated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_the_Contract_status_to_Activated</fullName>
        <field>Status</field>
        <literalValue>Activated</literalValue>
        <name>Set the Contract status to Activated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_the_status_as_Activated</fullName>
        <field>Status</field>
        <literalValue>Activated</literalValue>
        <name>Set the status as Activated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Contract_Start_Date</fullName>
        <field>StartDate</field>
        <formula>Expected_Arrival_Date_Distributor__c</formula>
        <name>Update Contract Start Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Change Contract Start Date when ETA is changed</fullName>
        <actions>
            <name>Update_Contract_Start_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contract.Expected_Arrival_Date_Distributor__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Default term to 12 months</fullName>
        <actions>
            <name>Populate_term_as_12</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contract.StartDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Get Primary Email from Distributor</fullName>
        <actions>
            <name>Set_Primary_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT( ISBLANK( AccountId ) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notify distributor when ETA is set</fullName>
        <actions>
            <name>Mail_to_be_sent_to_Distributor_when_ETA_is_set</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contract.Warehouse_Arrival_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send John an Email on Contract creation</fullName>
        <actions>
            <name>Mail_to_John_to_notify_Contract_creation</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contract.StartDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Send Mail to Distributor</fullName>
        <actions>
            <name>Notify_Distributor_about_ETA</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Set_the_status_as_Activated</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contract.Expected_Arrival_Date_Distributor__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contract.Dispatched_to__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send Mail to Operation Manager and Sales Admin</fullName>
        <actions>
            <name>Email_to_be_Sent_when_Machine_is_Dispatched_from_Warehouse</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contract.Dispatched_from_Warehouse__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send Mail to Sales Admin</fullName>
        <actions>
            <name>Mail_to_be_sent_to_Sales_Admin_when_Internal_Delivery_Date_and_Machine_Fields_ar</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( NOT( ISBLANK(Internal_Delivery_Date__c) ) , NOT( ISBLANK(Machine_Serial_Number__c ) ) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Status to Contract Terminated</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Contract.StartDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Set_Value_to_Contract_Terminated</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Contract.StartDate</offsetFromField>
            <timeLength>365</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
