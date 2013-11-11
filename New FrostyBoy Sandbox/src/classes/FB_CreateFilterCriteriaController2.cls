public class FB_CreateFilterCriteriaController2 {

    public FB_CreateFilterCriteriaController2(ApexPages.StandardController controller) {

    }
    public class PopupWrapper
    {
        public String pickvals{get;set;}
    }
    //public List<String> pickvals{get;set;}
    public String selectedValueField{get;set;}
    public String selectedValueOperator{get;set;}
    public String selectedValue{get;set;}
    public Boolean isPicklist{get;set;}
    public static List<PopupWrapper> popwrap{get;set;}
    public String setpickval{get;set;}
    Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.Account.fields.getMap();
    
    public PageReference addselectedValue()
    {
        return null;
    }
    
    public List<SelectOption> getFields()
    {
        //Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.Account.fields.getMap();
        List<SelectOption> fieldNames = new List<SelectOption>();
        List<String> flabels = new List<String>();
        for(String fieldName: fieldMap.keyset())
        {
            Schema.SObjectField fval = fieldMap.get(fieldName);
            String flabel = fval.getDescribe().getLabel();
            fieldNames.add(new SelectOption(fieldName,flabel));
        }
        //System.debug(fieldNames);
        return fieldNames; 
    }
    public List<SelectOption> getOperators()
    {
        List<SelectOption> operatorNames = new List<SelectOption>();
        
        operatorNames.add(new SelectOption('=','equals'));
        operatorNames.add(new SelectOption('!=','not equals'));
        operatorNames.add(new SelectOption('like','contains'));
        operatorNames.add(new SelectOption('like','starts with'));
        operatorNames.add(new SelectOption('>','greater than'));
        operatorNames.add(new SelectOption('<','less than'));
        operatorNames.add(new SelectOption('>=','greater than equals'));
        operatorNames.add(new SelectOption('<=','less than equals'));
        
        return operatorNames;
    }
    
    public List<PopupWrapper> getPickValues(){
    //system.debug(popwrap);
    return popwrap ;
    }
    
    public void onFieldChange()
    {
        Schema.SObjectField fval = fieldMap.get(selectedValueField);
        Schema.DisplayType ftype = fval.getDescribe().getType();
        //System.debug(ftype);
        if(ftype.name()=='PICKLIST')
        {
            isPicklist=true;
            List<Schema.PicklistEntry> picklistVals = fval.getDescribe().getPicklistValues();
            //System.debug(picklistVals);
            popwrap = new List<PopupWrapper>();
            for(Schema.PicklistEntry instance:picklistVals )
            {
                PopupWrapper iPopwrap = new PopupWrapper();
                String pickLabel = instance.getLabel();
                iPopwrap.pickvals=pickLabel;
                popwrap.add(iPopwrap);
                
            }
            System.debug(popwrap);
        }
        else
        {
            isPicklist=false;
        }
        selectedValue='';
        //return null;
    }
    public PageReference Go()
    {
        
        String filterQuery='';
        if(selectedValueOperator=='like')
        {
            filterQuery = 'select Id,Name from Account where '+ selectedValueField +'  '+ selectedValueOperator +' ' + '\'%' +selectedValue +'%\'';
        }
        else
        {
            filterQuery = 'select Id,Name from Account where '+ selectedValueField +'  '+ selectedValueOperator +' ' + '\'' +selectedValue +'\'';
            
        }
        System.debug(filterQuery);
        return null;
    }

}