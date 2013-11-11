<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Populate_End_Date</fullName>
        <field>End_Date__c</field>
        <formula>Contract_End_Date__c</formula>
        <name>Populate End Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Monthly_Payment</fullName>
        <field>Sale_price__c</field>
        <formula>MonthlyPaymentFormula__c</formula>
        <name>Update Monthly Payment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_Indicator</fullName>
        <field>Machine_Status_Indicator__c</field>
        <formula>CASE(Status__c,&apos;Allocated&apos;,1,
&apos;Ready&apos;,0,
&apos;Allocated-Cool Off&apos;,2,
&apos;Repair&apos;,3,
&apos;Contract Completed&apos;,0,
&apos;Contract Terminated&apos;,0
,-1)</formula>
        <name>Update Status Indicator</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Get End Date</fullName>
        <actions>
            <name>Populate_End_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT( ISBLANK( Contract_End_Date__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LastServiceDateUpdate</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Machine_Inventory__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>when record is created then update the Last Service date field with created date</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Populate Monthly Payment</fullName>
        <actions>
            <name>Update_Monthly_Payment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Machine_Inventory__c.Contract_Start_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Status Indicator</fullName>
        <actions>
            <name>Update_Status_Indicator</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>IF(ISNEW(),true,ISCHANGED( Status__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UpdateNameWhenStatusCoolOff</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Machine_Inventory__c.Status__c</field>
            <operation>equals</operation>
            <value>Cool-off</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
