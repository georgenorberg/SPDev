jQuery(document).ready(() => { 
   //only run when pageTitle is available and not in dialog 
   if (window.location.href.toLowerCase().indexOf('isdlg=1') == -1 && $("#pageTitle").length > 0) { 
       SP.SOD.executeFunc('sp.js', 'SP.ClientContext', () => { 
           SP.SOD.registerSod('sp.taxonomy.js', SP.Utilities.Utility.getLayoutsPageUrl('sp.taxonomy.js')); 
           SP.SOD.executeFunc('sp.taxonomy.js', 'SP.Taxonomy.TaxonomySession', () => { 
               SP.SOD.registerSod('sp.publishing.js', SP.Utilities.Utility.getLayoutsPageUrl('sp.publishing.js')); 
               SP.SOD.executeFunc('sp.publishing.js', 'SP.Publishing', function () { 
                   SP.SOD.executeFunc('sp.publishing.js', 'SP.Publishing.Navigation', function () { 
                   }); 
               }); 
           }); 
       }); 
   } 
});