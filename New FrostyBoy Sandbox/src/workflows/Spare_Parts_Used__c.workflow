<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Get_Cost_Incurred</fullName>
        <field>Cost_Incurred__c</field>
        <formula>Cost__c</formula>
        <name>Get Cost Incurred</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Get Cost for Rollup</fullName>
        <actions>
            <name>Get_Cost_Incurred</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>OR(ISCHANGED( Cost__c ) ,ISNEW())</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
