function createListItem() {  
   var clientContext = new SP.ClientContext(_spPageContextInfo.siteAbsoluteUrl);  
   var oList = clientContext.get_web().get_lists().getByTitle('TestList');  
   var itemCreateInfo = new SP.ListItemCreationInformation();  
   this.oListItem = oList.addItem(itemCreateInfo);
  
   //Single line of text  
   oListItem.set_item('Title', 'My New Item!'); 
 
   //Single Choice  
   oListItem.set_item('PetkaChoiceDrop', 'Enter Choice #1');  

   //Multi Choice  
   var petkaChoiceMultiArray = new Array("Enter Choice #1","Enter Choice #2");    
   oListItem.set_item('PetkaChoiceMulti', petkaChoiceMultiArray);  

   //Single Lookup  
   var PetkaLookupSingle = new SP.FieldLookupValue();  
   PetkaLookupSingle.set_lookupId(2);  
   oListItem.set_item('PetkaLookup', PetkaLookupSingle);  

   //Multi Lookup  
   var lookupsIds = [1,2];  
   var lookups = [];  
   for (var ii in lookupsIds) {  
      var lookupValue = new SP.FieldLookupValue();  
      lookupValue.set_lookupId(lookupsIds[ii]);  
      lookups.push(lookupValue);  
   }  
   oListItem.set_item('PetkaLookupMulti', lookups);
  
   //Yes=1 / No=0  
   oListItem.set_item('PetkaYesNo', 1);  

   // Single Person  
   var singleUser = SP.FieldUserValue.fromUser('Peter Dotsenko');  
   oListItem.set_item('PetkaPersonSingle', singleUser);  
   
   //Multi Person  
   var petkaUserMultiArray = new Array("peterd@domain.com","Peter Dotsenko","domain\\peterd");  
   var lookups = [];  
   for (var ii in petkaUserMultiArray) {  
      var lookupValue = SP.FieldUserValue.fromUser(petkaUserMultiArray[ii]);  
      lookups.push(lookupValue);  
   }  
   oListItem.set_item('PetkaPersonMulti', lookups); 
 
   //Managed Multi  
   var field = oList.get_fields().getByInternalNameOrTitle("PetkaManagedMulti");  
   var taxField = clientContext.castTo(field, SP.Taxonomy.TaxonomyField);  
   var terms = new SP.Taxonomy.TaxonomyFieldValueCollection(clientContext,getMultiTax(),taxField);  
   taxField.setFieldValueByValueCollection(oListItem, terms);  

   //Managed Single  
   var field = oList.get_fields().getByInternalNameOrTitle("PetkaManagedSingle");  
   var taxField = clientContext.castTo(field, SP.Taxonomy.TaxonomyField);  
   var taxonomySingle = new SP.Taxonomy.TaxonomyFieldValue();  
   taxonomySingle.set_label("Mamo");  
   taxonomySingle.set_termGuid("10d05b55-6ae5-413b-9fe6-ff11b9b5767c");  
   taxonomySingle.set_wssId(-1);  
   taxField.setFieldValueByValue(oListItem, taxonomySingle);
  
   //Hyperlink or Picture  
   var hyperLink = new SP.FieldUrlValue();  
   hyperLink.set_url("http://cnn.com");  
   hyperLink.set_description("CNN");  
   oListItem.set_item('PetkaHyperLink', hyperLink);
  
   //Currency  
   oListItem.set_item('PetkaCurrency', '100');
  
   //DateTime  
   oListItem.set_item('PetkaDateTime', '3/14/2014'); 
 
   //MultiLine text  
   oListItem.set_item('PetkaMultiText', '<p><strong>Hello!</strong></p>');
  
   oListItem.update();  
   clientContext.load(oListItem);  
   clientContext.executeQueryAsync(  
     Function.createDelegate(this, this.onQuerySucceeded),   
     Function.createDelegate(this, this.onQueryFailed)  
   );  
 }

function getMultiTax(){  
      var terms = new Array();  
      terms.push("-1;#Mamo|10d05b55-6ae5-413b-9fe6-ff11b9b5767c");  
      terms.push("-1;#Popo|178888b0-7942-45bb-b3f1-2f38d476e3db");  
      return terms.join(";#");  
}

function onQuerySucceeded() {
    SP.UI.Notify.addNotification('Item created: ' + oListItem.get_id());
}

function onQueryFailed(sender, args) {
    console.log('Request failed. ' + args.get_message() + '\n' + args.get_stackTrace());
}
  