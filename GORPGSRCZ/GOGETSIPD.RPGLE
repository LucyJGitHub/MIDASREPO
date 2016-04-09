     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Get security interest payment dates')         *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOGETSIPD - Get Security Interest Payment Dates.             *
      *                                                               *
      *  Function:  This module takes an array of coupon dates and    *
      *             determines the preceeding and next coupon dates   *
      *             and the number of coupons per year.               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. 261324             Date 24Apr13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *  Prev Amend No. 242841             Date 28Nov06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11193           Date 02May06               *
      *                 BUG11164           Date 06Apr06               *
      *                 CSE071             Date 19Jul05               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  261324 - GOC0020 ended in error during COB.                  *
      *           Initialised NCD to zero in *INIT mode.              *
      *         - Applied for AR1063996 (Child: AR1063998).           *
      *  242841   - Added a passed parameter (LCPN) for the call of   *
      *             program ZLCD.                                     *
      *  BUG11193 - Purchased Interest not calculated on BackValued   *
      *             Trade. (Recompile)                                *
      *  BUG11164 - A Serious Midas Error on SETRAD insert/amend      *
      *  CSE071 - Multiple Holidays Re Securities                     *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
 
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
     C                   PARM                    I#ERMS           50            * ERROR MESSAGE
 
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
     C                   PARM                    NMCY              3
     C                   PARM                    SITP              3
     C                   PARM                    BCNV              1
      * OUTPUTS
     C                   PARM                    O#IPY             2 0          * INT PAY PER YR
     C                   PARM                    O#PIDT            5 0          * PREC INT DATE
     C                   PARM                    O#NIDT            5 0          * PAYMENT DATES
 
      * INITIALISATION
 
     C     I#MODE        IFEQ      '*INIT   '
      *
      ** ZEROISE OUTPUTS
      *
     C                   Z-ADD     *ZERO         O#IPY
     C                   Z-ADD     *ZERO         O#PIDT
     C                   Z-ADD     *ZERO         O#NIDT
     C                   Z-ADD     *ZERO         NCD                                          261324
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
     C                   Z-ADD     ZZLCD         LastCoupDate      5 0
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
     C     NCD           IFGT      LastCoupDate
     C                   Z-ADD     NCD           LastCoupDate
     C                   Z-ADD     NCD           O#NIDT
     C     NCD           ADD       1             ECD
     C                   ELSE
      * (long term maturity period entered)
     C                   MOVEL     '*EOD   '     I#RTCD
     C                   ENDIF
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
     C     I#CR(#CNT)    IFEQ      ' '                                          * ZEROISE ANY
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
     C                   PARM                    LCPN                                         242841
     C                   PARM                    ZECD              5 0
     C                   PARM                    BJDFIN
     C                   PARM                    NMCY              3
     C                   PARM                    SITP              3
     C                   PARM                    BCNV              1
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
     C                   PARM                    NMCY              3
     C                   PARM                    SITP              3
     C                   PARM                    BCNV              1
     C                   PARM      LastCoupDate  LCPN              5 0
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
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
