@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Invoice Exception - Consumption View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity Z7AB_CV_INV_EXP as projection on Z7AB_BA_INV_EXP
{
    key ReqId,
    CompanyCode,
    Vendor,
   @Semantics.amount.currencyCode: 'CurrencyKey'
    Amount,
    CurrencyKey,
    InvoiceDate,
    Status,
    FiDocNo,
    FiscalYear,
    RiskLevel,
    Createdby,
    Createdon,
    Changedby,
    Changedon
}   
