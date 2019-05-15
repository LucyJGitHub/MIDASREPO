     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Get security interest payment dates')
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DEGETSIPD - Get Security Interest Payment Dates.             *
      *                                                               *
      *  Function:  This module takes an array of coupon dates and    *
      *             determines the preceeding and next coupon dates   *
      *             and the number of coupons per year.               *
      *                                                               *
      *  Component of: DEPXTSBPS                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG11193           Date 02May06               *
      *                 BUG11164           Date 06Apr06               *
      *                 CSE071             Date 19Jul05               *
      *                 218087             Date 16Jun03               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002             Date 25Apr01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 191727             Date 30Mar01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CDE001  *CREATE    Date 16Dec99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG11193 - Purchased Interest not calculated on BackValued   *
      *             Trade. (Recompile)                                *
      *  BUG11164 - A Serious Midas Error on SETRAD insert/amend      *
      *  CSE071 - Multiple Holidays Re Securities                     *
      *  218087 - The call to ZNCD missing a parameter.               *
      *  CDE002 - CCRM Revenue Analysis                               *
      *  191727 - The call to ZLCD was missing three parameters.      *
      *  CDE001 - Data Export - CCRM Limits.                          *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Coupon dates array
     D CDArr           DS            48
     D  I#CD                   1     48
     D                                     DIM(12) ASCEND
 
      ** Coupon rate indicator array
     D CRArr           DS            12
     D  I#CR                   1     12
     D                                     DIM(12) ASCEND
 
      *
      * INPUT PARAMETERS
      *
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7            * RETURN CODE
     C                   PARM                    I#ERMS           30            * ERROR MESSAGE
 
      * INPUTS
     C                   PARM                    I#MODE           10
     C                   PARM                    I#ZECD            5 0          * SPOT DATE
     C                   PARM                    CDArr                          * INT.DAY   X12
     C                   PARM                    CRArr                          * INT.RT/PY X12
     C                   PARM                    LCPN                                       BUG11164
     C                   PARM                    ISSD              5 0          * INITIAL DATE
     C                   PARM                    ITLD              5 0          * INITIAL DATE
     C                   PARM                    FCPN              5 0          * FIRST COUPON
     C                   PARM                    MATY              5 0          * MATURITY DATE
     C                   PARM                    BJDFIN            1
     C                   PARM                    NMCY              3                          CDE002
     C                   PARM                    SITP              3                          CDE002
     C                   PARM                    BCNV              1                          CDE002
      * OUTPUTS
     C                   PARM                    O#IPY             2 0          * INT PAY PER YR
     C                   PARM                    O#PIDT            5 0          * PREC INT DATE
     C                   PARM                    O#NIDT            5 0          * PAYMENT DATES
 
      * INITIALIZATION
 
     C     I#MODE        IFEQ      '*INIT   '
      *
      ** ZEROIZE OUTPUTS
      *
     C                   Z-ADD     *ZERO         O#IPY
     C                   Z-ADD     *ZERO         O#PIDT
     C                   Z-ADD     *ZERO         O#NIDT
      *
      * EARLY EXIT CONDITIONS
      *
     C                   EXSR      EARLYEXIT
      *
      * IF NO PAYMENT DATES PRESENT, SIGNIFY 'END OF DATA'
      * AND RETURN
      *
     C     I#CD(1)       IFEQ      *BLANK
     C     I#CD(1)       OREQ      '0000'
     C                   MOVEL     '*EOD   '     I#RTCD
     C                   RETURN
     C                   END
      *
      * DETERMINE NUMBER OF COUPONS/YEAR
      *
     C                   EXSR      DET_#COUPS
      *
      * DETERMINE COUPON DATE PRECEDING EVENT CONTROL DATE
      *
     C                   Z-ADD     I#ZECD        ZECD
     C                   EXSR      ZLCD
     C                   Z-ADD     ZZLCD         O#PIDT
      *
      ** START FROM PRECEDING COUPON DATE
      *
     C     O#PIDT        ADD       1             ECD
 
     C                   ENDIF
 
      ** IF PAST MATURITY DATE THEN SIGNIFY 'END OF DATA'
 
     C     ECD           IFGT      MATY
     C                   MOVEL     '*EOD   '     I#RTCD
     C                   ELSE
      *
      ** ELSE DETERMINE THE NEXT COUPON DATE
      *
     C                   EXSR      ZNCD
     C                   Z-ADD     NCD           O#NIDT
     C     NCD           ADD       1             ECD
     C                   ENDIF
      *
      ** EXIT
      *
     C                   RETURN
      *
      *****************************************************************
     C/SPACE 5
      **********************************************************************
     C     EARLYEXIT     BEGSR
      *
      * EXIT IF NO ISSUE DATE
      *
     C     ISSD          IFEQ      *ZERO
     C     ISSD          OREQ      99999
     C                   RETURN
     C                   END
      *
      * EXIT IF NO MATURITY DATE
      *
     C     MATY          IFEQ      *ZERO
     C     MATY          OREQ      99999
     C                   RETURN
     C                   END
 
     C                   ENDSR
      **********************************************************************
     C/SPACE 5
      **********************************************************************
      * DETERMINE NUMBER OF COUPONS/YEAR
      **********************************************************************
     C     DET_#COUPS    BEGSR
     C                   Z-ADD     1             #CNT              5 0
     C     #CNT          DOUGT     12
     C     I#CR(#CNT)    IFEQ      'P'
     C     I#CR(#CNT)    OREQ      'C'
     C                   ADD       1             O#IPY
     C                   END
     C     I#CR(#CNT)    IFEQ      ' '                                          * ZEROIZE ANY
     C                   MOVE      *ZEROS        I#CD(#CNT)                     * BLANKS IN
     C                   END                                                    * DATE ARRAY
     C                   ADD       1             #CNT
     C                   END
     C                   ENDSR
      **********************************************************************
     C/SPACE 5
      **********************************************************************
     C     ZLCD          BEGSR
 
     C                   CALLB     'ZLCD'
     C                   PARM                    ISSD
     C                   PARM                    ITLD
     C                   PARM                    FCPN
     C                   PARM                    MATY
     C                   PARM                    CDArr
     C                   PARM                    CRArr
     C                   PARM                    LCPN                                       BUG11164
     C                   PARM                    ZECD              5 0
     C                   PARM                    BJDFIN
     C                   PARM                    NMCY              3                          191727
     C                   PARM                    SITP              3                          191727
     C                   PARM                    BCNV              1                          191727
     C                   PARM                    HCY1              3                          CSE071
     C                   PARM                    HCY2              3                          CSE071
     C                   PARM                    HCY3              3                          CSE071
     C                   PARM                    HCY4              3                          CSE071
     C                   PARM                    HCY5              3                          CSE071
     C                   PARM                    HCY6              3                          CSE071
     C                   PARM                    HCY7              3                          CSE071
     C                   PARM                    HCY8              3                          CSE071
     C                   PARM                    HCY9              3                          CSE071
     C                   PARM                    ZZLCD             5 0
 
     C                   ENDSR
      **********************************************************************
     C/SPACE 5
      **********************************************************************
     C     ZNCD          BEGSR
 
     C                   CALLB     'ZNCD'
     C                   PARM                    ITLD
     C                   PARM                    FCPN
     C                   PARM                    MATY
     C                   PARM                    CDArr
     C                   PARM                    CRArr
     C                   PARM                    ECD               5 0
     C                   PARM                    BJDFIN
     C                   PARM                    NMCY              3                          191727
     C                   PARM                    SITP              3                          191727
     C                   PARM                    BCNV              1                          191727
      ** Last Coupon Date                                                                     218087
     C                   PARM                    LCPN              5 0                        218087
     C                   PARM                    HCY1              3                          CSE071
     C                   PARM                    HCY2              3                          CSE071
     C                   PARM                    HCY3              3                          CSE071
     C                   PARM                    HCY4              3                          CSE071
     C                   PARM                    HCY5              3                          CSE071
     C                   PARM                    HCY6              3                          CSE071
     C                   PARM                    HCY7              3                          CSE071
     C                   PARM                    HCY8              3                          CSE071
     C                   PARM                    HCY9              3                          CSE071
     C                   PARM                    NCD               5 0
 
     C                   ENDSR
      **********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY DECPYSRC,DEPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
