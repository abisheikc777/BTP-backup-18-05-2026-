CLASS lhc_ZI_PR_Header DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR ZI_PR_Header RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR ZI_PR_Header RESULT result.

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
      IMPORTING keys_rba FOR READ ZI_PR_Header\_Pr_items FULL result_requested RESULT result LINK association_links.

    METHODS cba_Pr_items FOR MODIFY
      IMPORTING entities_cba FOR CREATE ZI_PR_Header\_Pr_items.

ENDCLASS.

CLASS lhc_ZI_PR_Header IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD create.

       DATA: ls_pr_hd TYPE zpurchreq_header.
*       READ TABLE entities ASSIGNING FIELD-SYMBOL(<fs_pr_header>) INDEX 1.
       DATA(ls_pr_hdr) = VALUE #( entities[ 1 ] OPTIONAL ).
       IF sy-subrc EQ 0.
       ls_pr_hd = CORRESPONDING #( ls_pr_hdr MAPPING FROM ENTITY USING CONTROL ).
       ENDIF.

       SELECT SINGLE * from zpurchreq_header WHERE
       pr_id = @ls_pr_hdr-PrId AND ref_no = @ls_pr_hdr-PrId INTO @DATA(ls_read).

       IF SY-subrc = 0.
        APPEND VALUE #( %msg = new_message( id = '00'
                                           number = '001'
                                           v1 = 'Record Already Existis'
                                           severity = if_abap_behv_message=>severity-error )
                       %key-PrId = ls_pr_hdr-PrId
                       %key-RefNo = ls_pr_hdr-RefNo
                       %cid =  ls_pr_hdr-%cid
                       %create = 'X'
                       PrId = ls_pr_hdr-PrId
                       RefNo = ls_pr_hdr-RefNo ) TO reported-zi_pr_header.

       ELSE.

       INSERT zpurchreq_header FROM @ls_pr_hd.
       IF sy-subrc IS INITIAL.
        mapped-zi_pr_header = VALUE #( BASE mapped-zi_pr_header
                                      ( %cid = ls_pr_hdr-%cid
                                        PrId = ls_pr_hd-pr_id
                                        RefNo = ls_pr_hd-ref_no ) ).
       ELSE.
       APPEND VALUE #( %cid = ls_pr_hdr-%cid
                         PrId = ls_pr_hd-pr_id
                         RefNo = ls_pr_hd-ref_no ) TO failed-zi_pr_header.

       APPEND VALUE #( %msg = new_message( id = '02'
                                           number = '002'
                                           v1 = 'Invalid Details'
                                           severity = if_abap_behv_message=>severity-error )
                       %key-PrId = ls_pr_hdr-PrId
                       %key-RefNo = ls_pr_hdr-RefNo
                       %cid =  ls_pr_hdr-%cid
                       %create = 'X'
                       PrId = ls_pr_hdr-PrId
                       RefNo = ls_pr_hdr-RefNo ) TO reported-zi_pr_header.
   ENDIF.
ENDIF.
  ENDMETHOD.

  METHOD update.
     DATA:  ls_po_hd_u TYPE zpurchreq_header,
            ls_pr      TYPE ZI_PR_Header.

     DATA(ls_po_hd_u_r) = VALUE #( entities[ 1 ] OPTIONAL ).
     IF SY-subrc = 0.
     SELECT SINGLE * FROM zpurchreq_header
     WHERE pr_id = @ls_po_hd_u_r-PrId
     AND  ref_no = @ls_po_hd_u_r-RefNo
     INTO @ls_po_hd_u.

     IF ls_po_hd_u_r-PrId IS NOT INITIAL.
        ls_po_hd_u-pr_id = ls_po_hd_u_r-PrId.
     ENDIF.

     IF ls_po_hd_u_r-RefNo IS NOT INITIAL.
        ls_po_hd_u-ref_no = ls_po_hd_u_r-RefNo.
     ENDIF.

     IF ls_po_hd_u_r-Requestor IS NOT INITIAL.
        ls_po_hd_u-requestor = ls_po_hd_u_r-Requestor.
     ENDIF.

     IF ls_po_hd_u_r-TotalAmt IS NOT INITIAL.
        ls_po_hd_u-total_amt = ls_po_hd_u_r-TotalAmt.
     ENDIF.

     IF ls_po_hd_u_r-Currency IS NOT INITIAL.
        ls_po_hd_u-currency = ls_po_hd_u_r-Currency.
     ENDIF.

     ENDIF.

     UPDATE zpurchreq_header FROM @ls_po_hd_u.

     IF SY-subrc IS INITIAL.
     mapped-zi_pr_header = VALUE #( BASE mapped-zi_pr_header
                                    ( %cid = ls_po_hd_u_r-%cid_ref
                                     PrId  = ls_po_hd_u_r-PrId
                                     RefNo = ls_po_hd_u_r-RefNo ) ).
     ELSE.

     APPEND VALUE #( %cid = ls_po_hd_u_r-%cid_ref
                     PrId  = ls_po_hd_u_r-PrId
                     RefNo = ls_po_hd_u_r-RefNo ) TO failed-zi_pr_header.

     APPEND VALUE #( %msg = new_message( id = '02'
                                           number = '002'
                                           v1 = 'Invalid Details'
                                           severity = if_abap_behv_message=>severity-error )

                    %key-PrId  = ls_po_hd_u_r-PrId
                    %key-RefNo = ls_po_hd_u_r-RefNo
                    %cid = ls_po_hd_u_r-%cid_ref
                    %update = 'X'
                    PrId = ls_po_hd_u_r-PrId
                    RefNo = ls_po_hd_u_r-RefNo ) TO reported-zi_pr_header.

     ENDIF.

  ENDMETHOD.

  METHOD delete.

      DATA(ls_keys) = VALUE #( keys[ 1 ] OPTIONAL ).
      IF Sy-subrc = 0.
      DELETE FROM zpurchreq_header
      WHERE pr_id = @ls_keys-PrId
      AND   ref_no =  @ls_keys-RefNo.

      IF sy-subrc NE 0.
      APPEND VALUE #( %cid = ls_keys-%cid_ref
                      PrId = ls_keys-PrId
                      RefNo = ls_keys-RefNo
       ) TO failed-zi_pr_header.

       APPEND VALUE #( %msg = new_message( id = '00'
                                           number = '001'
                                           v1 = 'Invalid Details'
                                           severity = if_abap_behv_message=>severity-error )

                    %key-PrId  = ls_keys-PrId
                    %key-RefNo = ls_keys-RefNo
                    %cid = ls_keys-%cid_ref
                    %update = 'X'
                    PrId = ls_keys-PrId
                    RefNo = ls_keys-RefNo ) TO reported-zi_pr_header.

    ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD read.

    SELECT * FROM zpurchreq_header
    FOR ALL ENTRIES IN @keys
    WHERE pr_id = @keys-PrId
    AND ref_no  = @keys-RefNo
    INTO CORRESPONDING FIELDS OF TABLE @result.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD rba_Pr_items.
  ENDMETHOD.

  METHOD cba_Pr_items.

        DATA: ls_pr_item TYPE zpurchreq_item.
        DATA(ls_pr_it_r) = VALUE #(  entities_cba[ 1 ] OPTIONAL ).

        IF sy-subrc EQ 0.
        DATA(lv_pr_id) = ls_pr_it_r-PrId.
        DATA(lv_ref_no) = ls_pr_it_r-RefNo.


        DATA(ls_items_r) = VALUE #( ls_pr_it_r-%target[ 1 ] OPTIONAL ).
        IF Sy-subrc = 0.
        DATA(ls_items) = CORRESPONDING zpurchreq_item( ls_items_r MAPPING FROM ENTITY USING CONTROL ).
        ENDIF.

        INSERT zpurchreq_item from @ls_items.

        IF sy-subrc EQ 0.
        INSERT VALUE #( %cid = ls_pr_it_r-%cid_ref
                        PrId = lv_pr_id
                        RefNo = lv_ref_no
                        itemno = ls_items-item_no ) INTO TABLE mapped-zi_pr_item.
        ELSE.
        APPEND VALUE #( %cid = ls_pr_it_r-%cid_ref
                        PrId = lv_pr_id
                        RefNo = lv_ref_no
                        itemno = ls_items-item_no ) TO failed-zi_pr_item.

        APPEND VALUE #( %msg = new_message( id = '00'
                                           number = '001'
                                           v1 = 'Invalid Details'
                                           severity = if_abap_behv_message=>severity-error )

                    %key-PrId  = lv_pr_id
                    %key-RefNo = lv_ref_no
                    %cid = ls_pr_it_r-%cid_ref
                    %update = 'X'
                    PrId = lv_pr_id
                    RefNo = lv_ref_no
                    itemno = ls_items-item_no ) TO reported-zi_pr_item.

        ENDIF.
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
      IMPORTING keys_rba FOR READ ZI_PR_Item\_Pr_header FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_ZI_PR_Item IMPLEMENTATION.

  METHOD update.
  DATA: ls_pr_items TYPE zpurchreq_item,
        lt_pr_items TYPE TABLE OF zpurchreq_item.

        SELECT * FROM zpurchreq_item FOR ALL ENTRIES IN @entities
        WHERE pr_id = @entities-PrId
        and ref_no = @entities-RefNo
        and item_no = @entities-ItemNo INTO TABLE @lt_pr_items.

        DATA(lt_temp) = lt_pr_items.
        CLEAR lt_pr_items.

        lt_pr_items = VALUE #( FOR ls_wa in entities
*         LET  ls_pr_it  = VALUE #( lt_temp[ pr_id = ls_wa-PrId ref_no = ls_wa-Ref_No item_no = ls_wa-ItemNo ] OPTIONAL )
*         IN
         (
           pr_id = COND #( WHEN ls_wa-PrId IS NOT INITIAL
                           THEN ls_wa-PrId )
           item_no = COND #( WHEN ls_wa-ItemNo IS NOT INITIAL
                           THEN ls_wa-ItemNo )
           ref_no = COND #( WHEN ls_wa-RefNo IS NOT INITIAL
                           THEN ls_wa-RefNo )
           material = COND #( WHEN ls_wa-Material IS NOT INITIAL
                           THEN ls_wa-Material )
           quantity = COND #( WHEN ls_wa-Quantity IS NOT INITIAL
                           THEN ls_wa-Quantity )
           uom    = COND #( WHEN ls_wa-Uom IS NOT INITIAL
                           THEN ls_wa-Uom )
           price  = COND #( WHEN ls_wa-Price IS NOT INITIAL
                           THEN ls_wa-Price )
           currency = COND #( WHEN ls_wa-Currency IS NOT INITIAL
                           THEN ls_wa-Currency )
           item_amount = COND #( WHEN ls_wa-ItemAmount IS NOT INITIAL
                           THEN ls_wa-ItemAmount )
          ) ) .

          UPDATE zpurchreq_item FROM TABLE @lt_pr_items.
          IF sy-subrc EQ 0.

          mapped-zi_pr_item = VALUE #( BASE mapped-zi_pr_item
                                      FOR ls_entity IN entities
                                    ( %cid = ls_entity-%cid_ref
                                     PrId  = ls_entity-PrId
                                     RefNo = ls_entity-RefNo
                                     ItemNo = ls_entity-ItemNo ) ).


          reported-zi_pr_item = VALUE #( BASE reported-zi_pr_item
                                         FOR ls_entity IN entities
                                       ( %msg = new_message(  id = '00'
                                           number = '001'
                                           v1 = 'Invalid Details'
                                           severity = if_abap_behv_message=>severity-error )
                                           %key-ItemNo = ls_entity-ItemNo
                                           %key-PrId   = ls_entity-PrId
                                           %key-RefNo = ls_entity-RefNo
                                           %cid        = ls_entity-%cid_ref
                                           %update     = 'X'
                                            ItemNo = ls_entity-ItemNo
                                             PrId   = ls_entity-PrId
                                             RefNo = ls_entity-RefNo ) ).
           ENDIF.
  ENDMETHOD.

  METHOD delete.
  DATA(ls_keys) = VALUE #( keys[ 1 ] OPTIONAL ).
  IF Sy-subrc EQ 0.
  DELETE FROM zpurchreq_item
  WHERE pr_id EQ @ls_keys-PrId AND
        ref_no EQ @ls_keys-RefNo AND
        item_no EQ @ls_keys-ItemNo.


        failed-zi_pr_item = VALUE #( BASE failed-zi_pr_item
                                    ( %cid = ls_keys-%cid_ref
                                     ItemNo = ls_keys-ItemNo
                                     RefNo = ls_keys-RefNo
                                     PrId   = ls_keys-PrId ) ).
        reported-zi_pr_item = VALUE #( BASE reported-zi_pr_item
                                     (  %msg = new_message(  id = '00'
                                           number = '001'
                                           v1 = 'Invalid Details'
                                           severity = if_abap_behv_message=>severity-error )
                                          %key-ItemNo = ls_keys-ItemNo
                                          %key-PrId   = ls_keys-PrId
                                          %key-RefNo = ls_keys-RefNo
                                          ItemNo = ls_keys-ItemNo
                                          PrId   = ls_keys-PrId
                                          RefNo = ls_keys-RefNo
                                            ) ).
  ENDIF.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD rba_Pr_header.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZI_PR_HEADER DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZI_PR_HEADER IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
