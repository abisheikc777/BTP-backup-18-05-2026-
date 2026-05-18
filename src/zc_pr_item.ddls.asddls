@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Requestion Item- Projection'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_PR_Item as projection on ZI_PR_Item
{
    key PrId,
    key ItemNo,
    key RefNo,
    Material,
    @Semantics.quantity.unitOfMeasure: 'UoM'
    Quantity,
    Uom,
    @Semantics.amount.currencyCode: 'Currency'
    Price,
    Currency,
    @Semantics.amount.currencyCode: 'Currency'
    ItemAmount,
    CreatedBy,
    CreatedOn,
    ChangedBy,
    ChangedOn,
    /* Associations */
    _pr_header : redirected to parent ZC_PR_Header
}
