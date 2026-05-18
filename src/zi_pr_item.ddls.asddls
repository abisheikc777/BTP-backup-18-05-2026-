@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Requestion Item'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_PR_Item as select from zpurchreq_item
association to parent ZI_PR_Header as _pr_header on $projection.PrId = _pr_header.PrId
and $projection.RefNo = _pr_header.RefNo
{
   key pr_id as PrId,
   key item_no as ItemNo,
   key ref_no as RefNo,
   material as Material,
   @Semantics.quantity.unitOfMeasure: 'UoM'
   quantity as Quantity,
   uom as Uom,
   @Semantics.amount.currencyCode: 'currency'
   price as Price,
   currency as Currency,
   @Semantics.amount.currencyCode: 'currency'
   item_amount as ItemAmount,
   created_by as CreatedBy,
   created_on as CreatedOn,
   changed_by as ChangedBy,
   changed_on as ChangedOn,
   _pr_header
}
