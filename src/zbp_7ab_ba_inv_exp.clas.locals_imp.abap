CLASS lhc_Z7AB_BA_INV_EXP DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR z7ab_ba_inv_exp RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR z7ab_ba_inv_exp RESULT result.

    METHODS approveRequest FOR MODIFY
      IMPORTING keys FOR ACTION z7ab_ba_inv_exp~approveRequest RESULT result.


    METHODS setRisk FOR DETERMINE ON SAVE
      IMPORTING keys FOR z7ab_ba_inv_exp~setRisk.

    METHODS setStatus FOR DETERMINE ON SAVE
      IMPORTING keys FOR z7ab_ba_inv_exp~setStatus.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Z7AB_BA_INV_EXP RESULT result.

ENDCLASS.

CLASS lhc_Z7AB_BA_INV_EXP IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD approveRequest.
    MODIFY ENTITIES OF z7ab_ba_inv_exp IN LOCAL MODE
       ENTITY z7ab_ba_inv_exp UPDATE FIELDS ( Status )
        WITH VALUE #(
        FOR ls_key IN keys
        ( %tky = ls_key-%tky
         Status = 'Approved' ) )
       FAILED DATA(lt_failed)
       REPORTED DATA(lt_reported).

       READ ENTITIES OF z7ab_ba_inv_exp IN LOCAL MODE
    ENTITY z7ab_ba_inv_exp
    ALL FIELDS WITH
    CORRESPONDING #( keys )
    RESULT DATA(lt_result)
    FAILED DATA(lt_failed_read)
    REPORTED DATA(lt_reported_read).

  "Step 3 — Return the result to the UI
  result = VALUE #(
    FOR ls_result IN lt_result
    ( %tky   = ls_result-%tky
      %param = ls_result ) ).
  ENDMETHOD.


  METHOD setRisk.
  DATA: lv_low TYPE p LENGTH 10 DECIMALS 2 VALUE '1000.00',
         lv_med TYPE p LENGTH 10 DECIMALS 2 VALUE '20000.00'.

    READ ENTITIES OF z7ab_ba_inv_exp IN LOCAL MODE
    ENTITY z7ab_ba_inv_exp
    FIELDS ( Amount )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result).

   MODIFY ENTITIES OF z7ab_ba_inv_exp IN LOCAL MODE
    ENTITY z7ab_ba_inv_exp
    UPDATE FIELDS ( RiskLevel )
    WITH VALUE #(
      FOR ls_entity IN lt_result
      (
        %tky = ls_entity-%tky

        RiskLevel =
          COND #(
            WHEN ls_entity-Amount < lv_low
            THEN 'LOW'

            WHEN ls_entity-Amount <= lv_med
            THEN 'MEDIUM'

            ELSE 'HIGH'
          )
      )
    )  FAILED DATA(lt_failed)
       REPORTED DATA(lt_reported).


  ENDMETHOD.

  METHOD setStatus.
   MODIFY ENTITIES OF z7ab_ba_inv_exp IN LOCAL MODE
       ENTITY z7ab_ba_inv_exp UPDATE FIELDS ( Status )
       WITH VALUE #(
       FOR ls_key IN Keys
       ( %tky = ls_key-%tky
       Status = 'Pending'
        ) )
       FAILED DATA(lt_failed)
       REPORTED DATA(lt_reported).
  ENDMETHOD.

  METHOD get_instance_features.
      READ ENTITIES OF z7ab_ba_inv_exp IN LOCAL MODE
      ENTITY z7ab_ba_inv_exp
      FIELDS ( Status ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_approved)
      FAILED DATA(lt_failed).

      result = VALUE #( FOR ls_wa IN lt_approved
      LET statusval = COND #( WHEN ls_wa-Status = 'Approved'
                              THEN if_abap_behv=>fc-o-disabled
                              ELSE if_abap_behv=>fc-o-enabled )
                              IN ( %tky = ls_wa-%tky
                                   %action-approveRequest = statusval ) ).
  ENDMETHOD.

ENDCLASS.
