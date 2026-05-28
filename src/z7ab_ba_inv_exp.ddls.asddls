@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Invoice Exception - Basic View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity Z7AB_BA_INV_EXP as select from z7ab_tab_inv_exp
{
    key req_id as ReqId,
    company_code as CompanyCode,
    vendor as Vendor,
    @Semantics.amount.currencyCode: 'CurrencyKey'
    amount as Amount,
    currency_key as CurrencyKey,
    invoice_date as InvoiceDate,
    status as Status,
    fi_doc_no as FiDocNo,
    fiscal_year as FiscalYear,
    risk_level as RiskLevel,
    @Semantics.user.createdBy: true
    createdby as Createdby,
    @Semantics.systemDateTime.createdAt: true
    createdon as Createdon,
     @Semantics.user.lastChangedBy: true
    changedby as Changedby,
     @Semantics.systemDateTime.lastChangedAt: true
    changedon as Changedon
}
