" Second Push
CLASS lhc_ZI_PR_Header DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations
      FOR ZI_PR_Header RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations
      FOR ZI_PR_Header RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE ZI_PR_Header.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE ZI_PR_Header.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE ZI_PR_Header.

    METHODS read FOR READ
      IMPORTING keys FOR READ ZI_PR_Header RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK ZI_PR_Header.

    METHODS rba_Pr_items FOR READ
      IMPORTING keys_rba FOR READ ZI_PR_Header\_Pr_items
      FULL result_requested RESULT result LINK association_links.

    METHODS cba_Pr_items FOR MODIFY
      IMPORTING entities_cba FOR CREATE ZI_PR_Header\_Pr_items.

ENDCLASS.

CLASS lhc_ZI_PR_Header IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD create.

    DATA(ls_entity) = VALUE #( entities[ 1 ] OPTIONAL ).
    CHECK ls_entity IS NOT INITIAL.

    "Set CRUD flag"
    zbp_i_pr_header=>lv_crud = 'C'.

    "Check duplicate"
    SELECT SINGLE pr_id, ref_no
      FROM zpurchreq_header
      WHERE pr_id  = @ls_entity-PrId
        AND ref_no = @ls_entity-RefNo
      INTO @DATA(ls_check).

    IF sy-subrc = 0.

      "Duplicate — block"
      APPEND VALUE #(
        %cid       = ls_entity-%cid
        %key-PrId  = ls_entity-PrId
        %key-RefNo = ls_entity-RefNo
      ) TO failed-zi_pr_header.

      APPEND VALUE #(
        %cid       = ls_entity-%cid
        %key-PrId  = ls_entity-PrId
        %key-RefNo = ls_entity-RefNo
        %create    = 'X'
        PrId       = ls_entity-PrId
        RefNo      = ls_entity-RefNo
        %msg       = new_message_with_text(
                       severity = if_abap_behv_message=>severity-error
                       text     = 'Record Already Exists' )
      ) TO reported-zi_pr_header.

    ELSE.

      "Buffer the record"
      DATA(ls_hdr) = VALUE zpurchreq_header(
        pr_id      = ls_entity-PrId
        ref_no     = ls_entity-RefNo
        requestor  = ls_entity-Requestor
        total_amt  = ls_entity-TotalAmt
        currency   = ls_entity-Currency
        created_by = cl_abap_context_info=>get_user_technical_name( )
        changed_by = cl_abap_context_info=>get_user_technical_name( )
      ).
      GET TIME STAMP FIELD ls_hdr-created_on.
      GET TIME STAMP FIELD ls_hdr-changed_on.

      "Store in global buffer"
      zbp_i_pr_header=>gt_header = VALUE #(
        BASE zbp_i_pr_header=>gt_header
        ( ls_hdr )
      ).

      "Fill mapped"
      APPEND VALUE #(
        %cid  = ls_entity-%cid
        PrId  = ls_hdr-pr_id
        RefNo = ls_hdr-ref_no
      ) TO mapped-zi_pr_header.

    ENDIF.

  ENDMETHOD.

  METHOD update.

    DATA(ls_entity) = VALUE #( entities[ 1 ] OPTIONAL ).
    CHECK ls_entity IS NOT INITIAL.

    "Set CRUD flag"
    zbp_i_pr_header=>lv_crud = 'U'.

    "Read existing record"
    SELECT SINGLE *
      FROM zpurchreq_header
      WHERE pr_id  = @ls_entity-PrId
        AND ref_no = @ls_entity-RefNo
      INTO @DATA(ls_existing).

    IF sy-subrc <> 0.

      APPEND VALUE #(
        %key-PrId  = ls_entity-PrId
        %key-RefNo = ls_entity-RefNo
      ) TO failed-zi_pr_header.

      APPEND VALUE #(
        %key-PrId  = ls_entity-PrId
        %key-RefNo = ls_entity-RefNo
        %update    = 'X'
        PrId       = ls_entity-PrId
        RefNo      = ls_entity-RefNo
        %msg       = new_message_with_text(
                       severity = if_abap_behv_message=>severity-error
                       text     = 'Record Not Found' )
      ) TO reported-zi_pr_header.

      RETURN.

    ENDIF.

    "Apply changed fields using control"
    IF ls_entity-%control-Requestor = cl_abap_behv=>flag_changed.
      ls_existing-requestor = ls_entity-Requestor.
    ENDIF.
    IF ls_entity-%control-TotalAmt = cl_abap_behv=>flag_changed.
      ls_existing-total_amt = ls_entity-TotalAmt.
    ENDIF.
    IF ls_entity-%control-Currency = cl_abap_behv=>flag_changed.
      ls_existing-currency = ls_entity-Currency.
    ENDIF.

    ls_existing-changed_by = cl_abap_context_info=>get_user_technical_name( ).
    GET TIME STAMP FIELD ls_existing-changed_on.

    "Store in global buffer"
    zbp_i_pr_header=>gt_header = VALUE #(
      BASE zbp_i_pr_header=>gt_header
      ( ls_existing )
    ).

  ENDMETHOD.

  METHOD delete.

    CHECK keys IS NOT INITIAL.

    "Set CRUD flag"
    zbp_i_pr_header=>lv_crud = 'D'.

    "Store all delete keys in global buffer"
    zbp_i_pr_header=>gt_header_del = VALUE #(
      FOR ls_key IN keys
      ( pr_id  = ls_key-PrId
        ref_no = ls_key-RefNo )
    ).

      SELECT pr_id, ref_no, item_no
    FROM zpurchreq_item
    FOR ALL ENTRIES IN @keys
    WHERE pr_id  = @keys-PrId
      AND ref_no = @keys-RefNo
    INTO CORRESPONDING FIELDS OF TABLE @zbp_i_pr_header=>gt_item_del.

  ENDMETHOD.

  METHOD read.
 DATA: lt_header TYPE Table of zpurchreq_header.
    CHECK keys IS NOT INITIAL.
* Error Syntax: "Unspecified Provider Error"
*    SELECT *
*      FROM zpurchreq_header
*      FOR ALL ENTRIES IN @keys
*      WHERE pr_id  = @keys-PrId
*        AND ref_no = @keys-RefNo
*      INTO CORRESPONDING FIELDS OF TABLE @result.
*
*      CHECK keys IS NOT INITIAL.

  SELECT *
    FROM zpurchreq_header
    FOR ALL ENTRIES IN @keys
    WHERE pr_id  = @keys-PrId
      AND ref_no = @keys-RefNo
    INTO CORRESPONDING FIELDS OF TABLE @lt_header.

  result = VALUE #( FOR ls_hdr IN lt_header
                    ( PrId      = ls_hdr-pr_id
                      RefNo     = ls_hdr-ref_no
                      Requestor = ls_hdr-requestor
                      TotalAmt  = ls_hdr-total_amt
                      Currency  = ls_hdr-currency
                      CreatedBy = ls_hdr-created_by
                      CreatedOn = ls_hdr-created_on
                      ChangedBy = ls_hdr-changed_by
                      ChangedOn = ls_hdr-changed_on ) ).


  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD rba_Pr_items.

    CHECK keys_rba IS NOT INITIAL.

    SELECT *
      FROM zpurchreq_item
      FOR ALL ENTRIES IN @keys_rba
      WHERE pr_id  = @keys_rba-PrId
        AND ref_no = @keys_rba-RefNo
      INTO CORRESPONDING FIELDS OF TABLE @result.

    LOOP AT result ASSIGNING FIELD-SYMBOL(<fs_result>).
      APPEND VALUE #(
        source-PrId   = <fs_result>-PrId
        source-RefNo  = <fs_result>-RefNo
        target-PrId   = <fs_result>-PrId
        target-RefNo  = <fs_result>-RefNo
        target-ItemNo = <fs_result>-ItemNo
      ) TO association_links.
    ENDLOOP.

  ENDMETHOD.

  METHOD cba_Pr_items.

  zbp_i_pr_header=>lv_crud = 'C'.
  DATA: lt_data type table of zi_pr_item.

    DATA(ls_entity) = VALUE #( entities_cba[ 1 ] OPTIONAL ).
    CHECK ls_entity IS NOT INITIAL.


    lt_data  = VALUE #( FOR ls_wa IN ls_entity-%target
                       ( PrId = ls_wa-PrId

                        ItemNo = ls_wa-ItemNo
                        RefNo  = ls_wa-RefNo
                        Material = ls_wa-Material
                        Quantity = ls_wa-Quantity
                        Uom      = ls_wa-Uom
                        Price    = ls_wa-Price
                        Currency = ls_wa-Currency
                        ItemAmount = ls_wa-ItemAmount
                        CreatedBy  = cl_abap_context_info=>get_user_technical_name( )
                        CreatedOn = xco_cp=>sy->moment( )->as( xco_cp_time=>format->abap )->value ) ).


IF lt_data IS NOT INITIAL.
    "Store in global item buffer"
    zbp_i_pr_header=>gt_item = VALUE #(
      BASE zbp_i_pr_header=>gt_item
      FOR ls_wa1 in lt_data
      (  pr_id = ls_wa1-PrId
                        item_no = ls_wa1-ItemNo
                        ref_no  = ls_wa1-RefNo
                        Material = ls_wa1-Material
                        Quantity = ls_wa1-Quantity
                        Uom      = ls_wa1-Uom
                        Price    = ls_wa1-Price
                        Currency = ls_wa1-Currency
                        item_amount = ls_wa1-ItemAmount
                        created_by  = ls_wa1-CreatedBy
                        created_on = ls_wa1-CreatedOn )
    ).

    "Fill mapped"
    mapped-zi_pr_item = VALUE #( BASE mapped-zi_pr_item
                                FOR ls_wa2 IN lt_data INDEX INTO lv_index
                                LET ls_val = ls_entity-%target[ lv_index ]
                                IN
                                ( %cid = ls_val-%cid
                                  PrId = ls_wa2-PrId
                                  RefNo = ls_wa2-RefNo
                                  ItemNo = ls_wa2-ItemNo ) ).

ENDIF.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_ZI_PR_Item DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE ZI_PR_Item.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE ZI_PR_Item.

    METHODS read FOR READ
      IMPORTING keys FOR READ ZI_PR_Item RESULT result.

    METHODS rba_Pr_header FOR READ
      IMPORTING keys_rba FOR READ ZI_PR_Item\_Pr_header
      FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_ZI_PR_Item IMPLEMENTATION.

  METHOD update.
    zbp_i_pr_header=>lv_crud = 'U'.
    TYPES: BEGIN OF ty_struct,
           Pr_id TYPE zl_de_pr_id,
           item_no TYPE zl_de_pr_id,
           ref_no TYPE zl_de_pr_id,
           END of TY_STRUCT.
DATA: lt_key TYPE TABLE OF ty_struct,
      lt_fin_data TYPE TABLE OF zpurchreq_item.

    lt_key = VALUE #( FOR ls_wa IN entities
                    ( pr_id = ls_wa-PrId
                      item_no = ls_wa-ItemNo
                      ref_no = ls_wa-RefNo ) ).
    SELECT  * FROM zpurchreq_item
    FOR ALL ENTRIES IN @lt_key
    WHERE pr_id = @lt_key-pr_id
    AND   ref_no = @lt_key-ref_no
    AND   item_no = @lt_key-item_no
    INTO TABLE @DATA(lt_existing).

    IF sy-subrc = 0.
    lt_fin_data = VALUE #( FOR ls_wa IN entities
                           LET ls_existing = VALUE #( lt_existing[ pr_id = ls_wa-PrId ref_no = ls_wa-RefNo item_no = ls_wa-ItemNo ] OPTIONAL )
                           IN
                          ( pr_id = ls_existing-pr_id

                            item_no = ls_existing-item_no

                            ref_no = ls_existing-ref_no

                            Material = COND #( WHEN ls_wa-%control-Material = cl_abap_behv=>flag_changed
                                               THEN ls_wa-Material
                                               ELSE ls_existing-material )
                            Quantity = COND #( WHEN ls_wa-%control-Quantity = cl_abap_behv=>flag_changed
                                               THEN ls_wa-Quantity
                                               ELSE ls_existing-quantity )

                           Uom = COND #( WHEN ls_wa-%control-Uom = cl_abap_behv=>flag_changed
                                               THEN ls_wa-Uom
                                               ELSE ls_existing-uom )

                           Price = COND #( WHEN ls_wa-%control-Price = cl_abap_behv=>flag_changed
                                               THEN ls_wa-Price
                                               ELSE ls_existing-price )

                           Currency = COND #( WHEN ls_wa-%control-Currency = cl_abap_behv=>flag_changed
                                               THEN ls_wa-Currency
                                               ELSE ls_existing-currency )

                           item_amount = COND #( WHEN ls_wa-%control-ItemAmount = cl_abap_behv=>flag_changed
                                               THEN ls_wa-ItemAmount
                                               ELSE ls_existing-item_amount )
                           created_by  = ls_existing-created_by
                           created_on  = ls_existing-created_on
                           changed_by  = cl_abap_context_info=>get_user_technical_name( )
                           changed_on = xco_cp=>sy->moment( )->as( xco_cp_time=>format->abap )->value ) ) .



*        "Store in global item buffer"
        zbp_i_pr_header=>gt_item = VALUE #( BASE zbp_i_pr_header=>gt_item
                                            FOR ls_wa1 IN lt_fin_data
                                            ( CORRESPONDING #( ls_wa1 ) ) ).

      ENDIF.

  ENDMETHOD.

  METHOD delete.

    CHECK keys IS NOT INITIAL.

    "Store item delete keys in global buffer"
    zbp_i_pr_header=>gt_item_del = VALUE #(
      BASE zbp_i_pr_header=>gt_item_del
      FOR ls_key IN keys
      ( pr_id   = ls_key-PrId
        ref_no  = ls_key-RefNo
        item_no = ls_key-ItemNo )
    ).


  ENDMETHOD.

  METHOD read.

    CHECK keys IS NOT INITIAL.

    SELECT *
      FROM zpurchreq_item
      FOR ALL ENTRIES IN @keys
      WHERE pr_id   = @keys-PrId
        AND ref_no  = @keys-RefNo
        AND item_no = @keys-ItemNo
      INTO CORRESPONDING FIELDS OF TABLE @result.

  ENDMETHOD.

  METHOD rba_Pr_header.

    CHECK keys_rba IS NOT INITIAL.

    SELECT *
      FROM zpurchreq_header
      FOR ALL ENTRIES IN @keys_rba
      WHERE pr_id  = @keys_rba-PrId
        AND ref_no = @keys_rba-RefNo
      INTO CORRESPONDING FIELDS OF TABLE @result.

    LOOP AT result ASSIGNING FIELD-SYMBOL(<fs_result>).
      APPEND VALUE #(
        source-PrId  = <fs_result>-PrId
        source-RefNo = <fs_result>-RefNo
        target-PrId  = <fs_result>-PrId
        target-RefNo = <fs_result>-RefNo
      ) TO association_links.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZI_PR_HEADER DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.
    METHODS finalize          REDEFINITION.
    METHODS check_before_save REDEFINITION.
    METHODS save              REDEFINITION.
    METHODS cleanup           REDEFINITION.
    METHODS cleanup_finalize  REDEFINITION.
ENDCLASS.

CLASS lsc_ZI_PR_HEADER IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.

    "Validate mandatory fields before save"
    LOOP AT zbp_i_pr_header=>gt_header INTO DATA(ls_hdr).

      IF ls_hdr-pr_id IS INITIAL OR
         ls_hdr-ref_no IS INITIAL.

        APPEND VALUE #(
          %msg = new_message_with_text(
                   severity = if_abap_behv_message=>severity-error
                   text     = 'PR ID and Ref No are mandatory' )
        ) TO reported-zi_pr_header.

        RETURN.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD save.

    "Use CRUD flag to determine operation — same pattern as Employee example"
    CASE zbp_i_pr_header=>lv_crud.

      WHEN 'C'.
        "Insert header records"
        IF zbp_i_pr_header=>gt_header IS NOT INITIAL.
          INSERT zpurchreq_header
            FROM TABLE @zbp_i_pr_header=>gt_header.
        ENDIF.

        "Insert item records created with header"
        IF zbp_i_pr_header=>gt_item IS NOT INITIAL.
          MODIFY zpurchreq_item
            FROM TABLE @zbp_i_pr_header=>gt_item.
        ENDIF.

      WHEN 'U'.
        "Update header records"
        IF zbp_i_pr_header=>gt_header IS NOT INITIAL.
          UPDATE zpurchreq_header
            FROM TABLE @zbp_i_pr_header=>gt_header.
        ENDIF.

        "Update item records"
        IF zbp_i_pr_header=>gt_item IS NOT INITIAL.
          MODIFY zpurchreq_item
            FROM TABLE @zbp_i_pr_header=>gt_item.
        ENDIF.

      WHEN 'D'.
        "Delete item records first — FK constraint"
        IF zbp_i_pr_header=>gt_item_del IS NOT INITIAL.
          DELETE zpurchreq_item
            FROM TABLE @zbp_i_pr_header=>gt_item_del.
        ENDIF.

        "Delete header records"
        IF zbp_i_pr_header=>gt_header_del IS NOT INITIAL.
          DELETE zpurchreq_header
            FROM TABLE @zbp_i_pr_header=>gt_header_del.
        ENDIF.

    ENDCASE.

  ENDMETHOD.

  METHOD cleanup.

    "Clear ALL global buffers"
    CLEAR zbp_i_pr_header=>lv_crud.
    CLEAR zbp_i_pr_header=>gt_header.
    CLEAR zbp_i_pr_header=>gt_header_del.
    CLEAR zbp_i_pr_header=>gt_item.
    CLEAR zbp_i_pr_header=>gt_item_del.

  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.

