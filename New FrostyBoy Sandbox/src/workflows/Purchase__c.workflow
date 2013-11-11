<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>UnitPriceUpdate</fullName>
        <field>Unit_Price__c</field>
        <formula>if(isPickVal( Type__c ,&quot;Machine&quot;), Purchase_Cost__c , Purchase_Cost__c / Quantity__c )</formula>
        <name>UnitPriceUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>UpdateUnitPriceRule</fullName>
        <actions>
            <name>UnitPriceUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Purchase__c.Purchase_Cost__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
