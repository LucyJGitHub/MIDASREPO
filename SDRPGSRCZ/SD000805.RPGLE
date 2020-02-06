     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Customer Segmentation Codes Take-on Prog')    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000805 - Midas SD Customer Segmentation Codes Take-on      *
      *             Program                                           *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSD090  *CREATE    Date 06Dec10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD090 - Customer Segmentation                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR     - Error processing                                 *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas SD Customer Marketing Groups File
     FSDCMRKPD  UF   E           K DISK    INFSR(*PSSR)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      **  Access the System Value
     D SVAL01          C                   CONST('CustSegmDft')
 
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ ===================================  ¦
      ** +--------------------------------------+
 
      ** The following /COPY line includes all the defined fields in
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Call AOSVALR0 to get the system value for the
      ** Defaulting of Customer Segmentation Code
 
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      SVAL01        P@OP01           20
     C                   PARM      *BLANKS       P@VL01          200
     C                   PARM      *BLANKS       P@OP02           20
     C                   PARM      *BLANKS       P@VL02          200
     C                   PARM      *BLANKS       P@OP03           20
     C                   PARM      *BLANKS       P@VL03          200
     C                   PARM      *BLANKS       P@OP04           20
     C                   PARM      *BLANKS       P@VL04          200
     C                   PARM      *BLANKS       P@OP05           20
     C                   PARM      *BLANKS       P@VL05          200
     C                   PARM      *BLANKS       P@OP06           20
     C                   PARM      *BLANKS       P@VL06          200
     C                   PARM      *BLANKS       P@OP07           20
     C                   PARM      *BLANKS       P@VL07          200
     C                   PARM      *BLANKS       P@OP08           20
     C                   PARM      *BLANKS       P@VL08          200
     C                   PARM      *BLANKS       P@OP09           20
     C                   PARM      *BLANKS       P@VL09          200
     C                   PARM      *BLANKS       P@OP10           20
     C                   PARM      *BLANKS       P@VL10          200
 
      ** If the system value is not found then issue an error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBKEY = P@OP01
     C                   EVAL      DBFILE = 'SDSVALPD'
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
 
     C                   ELSE
 
      ** Update Segmentation Code field in Customer Marketing Groups file
      ** based on CustSegmDft system values.
 
     C                   READ      SDCMRKD0
     C                   DOW       NOT %EOF(SDCMRKPD)
     C                   EVAL      D7CSDE = P@VL01
     C                   UPDATE    SDCMRKD0
     C                   READ      SDCMRKD0
     C                   ENDDO
 
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program Exception Error Routine                      *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   RETURN
 
     C                   ENDSR
