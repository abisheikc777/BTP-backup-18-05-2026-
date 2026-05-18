@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Invoice Exception - Testing'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity Z7AB_TS_INV_EXP as select from z7ab_tab_inv_exp
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
    createdby as Createdby,
    createdon as Createdon,
    changedby as Changedby,
    changedon as Changedon
}
