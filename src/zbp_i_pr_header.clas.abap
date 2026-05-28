CLASS zbp_i_pr_header DEFINITION PUBLIC ABSTRACT FINAL FOR BEHAVIOR OF zi_pr_header.
*    CLASS-DATA: lv_cud TYPE c,
*                gt_pr_header TYPE TABLE OF zpurchreq_header.

CLASS-DATA lv_crud TYPE c LENGTH 1.

 "Header buffers"
    CLASS-DATA gt_header      TYPE TABLE OF zpurchreq_header WITH EMPTY KEY.
    CLASS-DATA gt_header_del  TYPE TABLE OF zpurchreq_header WITH EMPTY KEY.

    "Item buffers"
    CLASS-DATA gt_item        TYPE TABLE OF zpurchreq_item   WITH EMPTY KEY.
    CLASS-DATA gt_item_del    TYPE TABLE OF zpurchreq_item   WITH EMPTY KEY.

ENDCLASS.

CLASS zbp_i_pr_header IMPLEMENTATION.
ENDCLASS.

*CLASS zbp_i_pr_header DEFINITION
*  PUBLIC
*  FINAL
*  CREATE PUBLIC.
*
*  PUBLIC SECTION.
*
*    "CRUD operation flag"
*    CLASS-DATA lv_crud TYPE c LENGTH 1.
*
*    "Header buffers"
*    CLASS-DATA gt_header      TYPE TABLE OF zpurchreq_header WITH EMPTY KEY.
*    CLASS-DATA gt_header_del  TYPE TABLE OF zpurchreq_header WITH EMPTY KEY.
*
*    "Item buffers"
*    CLASS-DATA gt_item        TYPE TABLE OF zpurchreq_item   WITH EMPTY KEY.
*    CLASS-DATA gt_item_del    TYPE TABLE OF zpurchreq_item   WITH EMPTY KEY.
*
*ENDCLASS.
*
*CLASS zbp_i_pr_header IMPLEMENTATION.
*ENDCLASS.
