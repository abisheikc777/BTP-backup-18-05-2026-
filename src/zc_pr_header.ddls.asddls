@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Requestion Header - Projection'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_PR_Header 
provider contract transactional_query as projection on ZI_PR_Header
{
    key PrId,
    key RefNo,
    Requestor,
    @Semantics.amount.currencyCode: 'Currency'
    TotalAmt,
    Currency,
     @Semantics.user.createdBy: true
    CreatedBy,
    @Semantics.systemDateTime.createdAt: true
    CreatedOn,
    @Semantics.user.lastChangedBy: true
   ChangedBy,
    @Semantics.systemDateTime.lastChangedAt: true
    ChangedOn,
 
    /* Associations */
    _pr_items :redirected to composition child ZC_PR_Item
    
    
    
}
