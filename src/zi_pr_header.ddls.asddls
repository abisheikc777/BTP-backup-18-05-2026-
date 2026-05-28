@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Requestion Header'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_PR_Header as select from zpurchreq_header
composition [0..*] of ZI_PR_Item as _pr_items 
{
    key pr_id as PrId,
    key ref_no as RefNo,
    requestor as Requestor,
    @Semantics.amount.currencyCode: 'Currency'
    total_amt as TotalAmt,
    currency as Currency,
    @Semantics.user.createdBy: true
    created_by as CreatedBy,
    @Semantics.systemDateTime.createdAt: true
    created_on as CreatedOn,
    @Semantics.user.lastChangedBy: true
    changed_by as ChangedBy,
    @Semantics.systemDateTime.lastChangedAt: true
    changed_on as ChangedOn,
    _pr_items
}
