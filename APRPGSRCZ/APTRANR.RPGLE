     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AP Transaction Retrieve')                        *
      *****************************************************************
      *                                                               *
      *  Midas - Application Programming Interfaces module            *
      *                                                               *
      *  APTRANR - Transaction Retrieve                               *
      *                                                               *
      *  Function: This module is used to retrieve transaction        *
      *            details from the Midas database.                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. AR701789           Date 26Sep16               *
      *  Prev Amend No. AR702532           Date 13Jan15               *
      *                 CAP212             Date 15Sep14               *
      *                 CGL165             Date 23Feb15               *
      *                 CGL132             Date 01May13               *
      *                 CSD092             Date 01Apr13               *
      *                 CSD093             Date 10Mar14               *
      *                 AR1086546          Date 18Jun13               *
      *                 CSW213             Date 03Jun13               *
      *                 MD000091           Date 03May13               *
      *                 AR1060863A         Date 06Apr13               *
      *                 AR804863           Date 07Feb13               *
      *                 CAP210             Date 28Sep12               *
      *                 AR1078092          Date 20Jan13               *
      *                 264044             Date 01Aug12               *
      *                 CLE134             Date 01Aug12               *
      *                 AR971184           Date 28May12               *
      *                 CSF011A            Date 28Nov11               *
      *                 AR833200           Date 22Sep11               *
      *                 CSF011             Date 12Sep11               *
      *                 AR885527           Date 05Jan12               *
      *                 CBF011             Date 04Jul11               *
      *                 CLE073             Date 12May08               *
      *                 CER059             Date 19Jul10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG14485           Date 31Jul07               *
      *                 BUG13297A          Date 26Feb07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 CSD079             Date 05Feb07               *
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 240684             Date 26Jun06               *
      *                 BUG9009            Date 03Nov05               *
      *                 BUG9994            Date 19Jan06               *
      *                 CAP087             Date 23Aug05               *
      *                 CLE106             Date 01Aug04               *
      *                 CDL038             Date 10May05               *
      *                 CSE071             Date 26May05               *
      *                 CAS011             Date 16May05               *
      *                 CDL033             Date 10Feb05               *
      *                 BUG6417            Date 28Mar05               *
      *                 CDL028             Date 07Feb05               *
      *                 CGP010             Date 17Jan05               *
      *                 BUG5671            Date 01Feb05               *
      *                 BUG5403            Date 10Jan05               *
      *                 BUG5449            Date 10Jan05               *
      *                 BUG4646            Date 04Nov04               *
      *                 BUG3721 (CLE028)   Date 04Aug04               *
      *                 CDL018             Date 16May04               *
      *                 BG1105             Date 15Dec03               *
      *                 BUG19  (CAP084)    Date 26Jan04               *
      *                 BUG1100            Date 04May04               *
      *                 BUG1057            Date 04May04               *
      *                 BUG1055            Date 16Apr04               *
      *                 CGL029             Date 11Mar04               *
      *                 CSC021             Date 15Dec03               *
      *                 CAP084  *CREATE    Date 26Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR701789 - Unable to reject a deal amendment. Add a new      *
      *             parameter to indicate reject transaction.         *
      *             Applied for MD041482                              *
      *  AR702532 - After rejection, there is no WIP record but RSTS  *
      *             is still 'R'. Pass reject action parameter to     *
      *             skip validation during rejection to prevent the   *
      *             error. Applied fix 262574. (Child: AR702533)      *
      *           - Applied for MD023814                              *
      *  CAP212 - FT Nostro Transfer API                              *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master (Recompile)                 *
      *  CSD092 - Account Review                                      *
      *  CSW093 - Document Management                                 *
      *  AR1086546 - Upgrade of CDL025 to MP 1.4 (Child: AR1086547).  *
      *              Applied for MD021813 (Recompile)                 *
      *  CSW213 - SWIFT Changes 2013                                  *
      *  MD000091 - Event Codes Substitution (Recompile)              *
      *  AR1060863A - Add missing parameter in MMLDNIR                *
      *             - Applied for AR1097090                           *
      *  AR804863 - Details are not correctly reverted back when the  *
      *             amended transaction is rejected in WIP. Pass      *
      *             reject button to correctly revert back amended    *
      *             details. (Child: AR804864)                        *
      *           - Applied for AR910559 (Child: AR910560)            *
      *  CAP210 - Adjustment to Accrued Interests API                 *
      *  AR1078092 - Event Code of 45021706 (settlement account is    *
      *              (blocked) is not user configurable               *
      *  264044 - CLE134 Test PDCL SOAP API                           *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  AR971184 - For some JMS APIs (CUSD, AMAD, DPMV, OPAY), Front *
      *             Office Id is no more updated in master database   *
      *             files which provokes some big problems in third   *
      *             party product such as TOF.(Child:AR971185)        *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  AR833200 - Outgoing payment enquiry issue                    *
      *  CSF011 - Customer Name on Inputs                             *
      *  AR885527 - Cannot Enquire, Edit, Action any transactions     *
      *             in FX and MM                                      *
      *  CBF011 - BF Infrastructure: Error Message Handling           *
      *           (Recompile)                                         *
      *  CLE073 - Calculated Loan Based Fees                          *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *         - LT073: upgrade ACU3, ACU4, CUAH and CCTX to CUSD    *
      *  BUG14485 - MidasPlus Definition for CUSD is not in synch     *
      *             with that of API XML definition (Recompile)       *
      *  BUG13297A - Add DDPATH field.                                *
      *  CSD079 - Enhanced Customer Maintenance API                   *
      *  CRE026 - Consumer Banking                                    *
      *  240684 - Applied fix BUG9009.                                *
      *  BUG9009 - Implement CGL037                                   *
      *  BUG9994 - DPWI/DPWO Enquiry - Details cannot be enquired;    *
      *            Complete/Delete button disabled                    *
      *  CAP087 - Depot Movement API - Java Wrapper in Midasplus.     *
      *           TRANSID has increased due to addition of Security   *
      *           Shortname. Need to extract DDDPSS, DDDPRN and       *
      *           DDDPMV correctly.                                   *
      *  CLE106 - Syndications Manager (Recompile)                    *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CSE071 - Multiple Holidays Re Securities (Recompile)         *
      *  CAS011 - EIR/AC Accounting Upgrade to MP1                    *
      *  CDL033 - Floating Rate CDs Issued.                           *
      *  BUG6417- Cash management components are missing in MidasPlus *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CGP010 - Global BSPL                                         *
      *  BUG5671- Add Sequence number to detail record CLS2           *
      *  BUG5403 - Principle Change Schedule missing in CACF          *
      *  BUG5449 -Schedules for CIRS api                              *
      *  BUG4646- Completion of SIRS api                              *
      *  BUG3721 - Flat Rate Personal Loans (Rule of 78s) (CLE028)    *
      *  CDL018 - Recompiled due to changes in MMLDNIR.               *
      *  BG1105 - Bug1105 Make MSGARROUT a variable length string     *
      *  BUG19  - LERI API processing.                                *
      *  BUG1100- Added FEEM processing.                              *
      *  BUG1057- Added PRCS API.                                     *
      *  BUG1055- Added SEDE API.                                     *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSC021 - Add call to SCHELPR to processing                   *
      *  CAP084 - Synchronous calling of APIs                         *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** error arrays, including the named constant giving the size of
      ** the arrays.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **---------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      ** The maximum size of the error arrays
     D ArrayMax        C                   CONST(75)
 
      ** Array of Fields in error.
     D FldNameArr      S             10A   DIM(ArrayMax)
 
      ** Array of error message IDs
     D MsgIDArr        S                   DIM(ArrayMax)
     D                                     LIKE(#MsgID)
 
      ** Array of error message data.
     D MsgDtaArr       S                   DIM(ArrayMax)
     D                                     LIKE(#MsgData)
 
      ** Array of Fields with warnings.
     D WFldNamArr      S             10A   DIM(ArrayMax)
 
      ** Array of warning message IDs
     D WMsgIDArr       S                   DIM(ArrayMax)
     D                                     LIKE(#MsgID)
 
      ** Array of warning message data.
     D WMsgDtaArr      S                   DIM(ArrayMax)
     D                                     LIKE(#MsgData)
 
      ** Entry parameters
     D TransType       S              4
     D Parm            S           1000
     D Buffer          S           6000
     D ApHead          S            200                                                     AR971184
      * In order to allow for growing and variable buffers, this buffer must be split up
      * Any APIs requiring more than 6000 buffer should use buffer2
     D BufferTotal     S           9999
     D Buffer9999      S           9999                                                       CER059
     D Buffer2         S           3999
     D BufferEx2       S           9999                                                      BUG4646
     D BufferEx3       S           9999                                                      BUG4646
     D BufferEx4       S           9999                                                      BUG4646
     D BufferEx5       S           9999                                                      BUG4646
     D BufferEx6       S           9999                                                      BUG4646
     D BufferEx7       S           9999                                                      BUG4646
     D BufferEx8       S           9999                                                      BUG4646
     D BufferEx9       S           9999                                                      BUG4646
     D*******MsgArrOUT       S           2000                                                 BG1105
     D MsgArrOUT       S           9999                                                       BG1105
     D APIRetC         S              1
     D DDCUST_In       S              6                                                       CSD079
     D DDCSNO_In       S              6                                                       CSD079
     D APINam          S             20                                                     AR885527
     D DDORLN_In       S              6                                                       CLE134
     D DDFECU_In       S              6                                                       CLE134
     D DDFFAC_In       S              5                                                       CLE134
     D***DDFESQ_In       S              2                                              CLE134 264044
     D DDFSE2_In       S              2                                                       264044
     D DDFLNO_In       S              6                                                       CLE134
     D DDPLON_In       S              6                                                       264044
     D DDPLO2_In       S              6                                                       264044
     D ModeofOp        S              6                                                       CAP210
     D RespMode        S              1                                                       CAP210
     D FOTRID          S             20                                                       CAP210
     D OKACTN          S              1                                                       CAP210
     D OKTRNN          S              1                                                       CAP210
 
      ** DS/variables to split up incoming parameter
     D APParm          DS          1000
     D  AuthComp               1      1
     D  FwdBck                 2      2
     D*********TransID                3    103                                                CSC021
     D  TransID                3    303                                                       CSC021
      * Incoming Header                                                                    AR1078092
     D HeadIn        E DS                  EXTNAME(APHEADPD)                               AR1078092
 
      **********************************************************************
      /SPACE 5
      **********************************************************************
      * Start of main processing
      **********************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    TransType
     C                   PARM                    Parm
     C                   PARM                    BufferTotal
     C                   PARM                    BufferEx2                                   BUG4646
     C                   PARM                    BufferEx3                                   BUG4646
     C                   PARM                    BufferEx4                                   BUG4646
     C                   PARM                    BufferEx5                                   BUG4646
     C                   PARM                    BufferEx6                                   BUG4646
     C                   PARM                    BufferEx7                                   BUG4646
     C                   PARM                    BufferEx8                                   BUG4646
     C                   PARM                    BufferEx9                                   BUG4646
     C                   PARM                    MsgArrOUT
     C                   PARM                    APIRetC
     C                   PARM                    ApHead                                     AR971184
      *
      * Extract entry parameters
     C                   Eval      APParm = Parm
 
      * Clear down buffers
     C                   Eval      Buffer = *BLANKS
     C                   Eval      Buffer2 = *BLANKS
     C                   Eval      BufferTotal = *BLANKS
     C                   Eval      BufferEx2 = *BLANKS                                       BUG4646
     C                   Eval      BufferEx3 = *BLANKS                                       BUG4646
     C                   Eval      BufferEx4 = *BLANKS                                       BUG4646
     C                   Eval      BufferEx5 = *BLANKS                                       BUG4646
     C                   Eval      BufferEx6 = *BLANKS                                       BUG4646
     C                   Eval      BufferEx7 = *BLANKS                                       BUG4646
     C                   Eval      BufferEx8 = *BLANKS                                       BUG4646
     C                   Eval      BufferEx9 = *BLANKS                                       BUG4646
 
      **--------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------
 
     C                   EVAL      HeadIn = ApHead                                         AR1078092
      * Call the required API
 
     C                   EXSR      CALLAPI
 
      * Move the buffers into the full buffer
     C                   EVAL      BufferTotal = Buffer + Buffer2
 
      * Edit the Messages for output
     C                   EXSR      EDTMSGS
 
     C                   SETON                                        LR
     C                   RETURN
      ****************************************************************
      /SPACE 5
      ****************************************************************
      * Call the required API
      ****************************************************************
     C     CALLAPI       BEGSR
 
     C                   SELECT
 
      * FX deals
     C     TransTYPE     WHENEQ    'FXDL'
 
     C                   MOVEL     TransID       DDDLNO_In
 
     C                   CALL      'FXFXDLR'
     C                   PARM                    AuthComp
     C                   PARM                    FwdBck
     C                   PARM                    DDDLNO_In         6
     C                   PARM                    Buffer
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetC
 
      * MM Loan/Deposit deals
 
     C     TransTYPE     WHENEQ    'LDNI'
 
     C                   MOVEL     TransID       DDDLNO_In
 
     C                   CALL      'MMLDNIR'
     C                   PARM                    AuthComp
     C                   PARM                    FwdBck
     C                   PARM                    DDDLNO_In
     C                   PARM                    Buffer
     C                   PARM                    Buffer2                                      CDL033
     C                   PARM                    BufferEx2                                    CDL033
     C                   PARM                    BufferEx3                                AR1060863A
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetC
     C                   PARM                    ACTRJ             1                        AR701789
 
      * Incoming payments
 
     C     TransTYPE     WHENEQ    'IPAY'
 
     C                   MOVEL     TransID       DDPREF_In        15
     C*****1****         SUBST     TransID:16    DDACTN_In         1                        AR833200
     C     1             SUBST     TransID:19    DDACTN_In         1                        AR833200
 
     C                   CALL      'FTIPAYR'
     C                   PARM                    FwdBck
     C                   PARM                    DDPREF_In
     C                   PARM                    DDACTN_In
     C                   PARM                    Buffer
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetC
 
      * Outgoing payments
 
     C     TransTYPE     WHENEQ    'OPAY'
 
     C                   MOVEL     TransID       DDPREF_In
     C*****1****         SUBST     TransID:16    DDACTN_In         1                        AR833200
     C     1             SUBST     TransID:19    DDACTN_In         1                        AR833200
 
     C                   CALL      'FTOPAYR'
     C                   PARM                    FwdBck
     C                   PARM                    DDPREF_In
     C                   PARM                    DDACTN_In
     C                   PARM                    Buffer
     C                   PARM                    Buffer2                                      CSF011
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetC
 
     C     TransTYPE     WHENEQ    'AMAD'
     C     TransTYPE     OREQ      'ACMC'                                                     CRE026
     C     TransTYPE     OREQ      'ACMI'                                                     CRE026
     C     TransTYPE     OREQ      'ACMN'                                                     CRE026
 
     C                   MOVEL     TransID       DDACRF_In
 
     C                   CALL      'GLAMADR'
     C                   PARM                    FwdBck
     C**********         PARM                    DDACRF_In        18                          CGL029
     C                   PARM                    DDACRF_In        24                          CGL029
     C                   PARM                    Buffer
     C                   PARM                    Buffer2                                      CSF011
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetC
 
      * SD Customers
 
     C     TransTYPE     WHENEQ    'CUSD'
     C     TransTYPE     OREQ      'CSDU'                                                     CSD079
     C     TransTYPE     OREQ      'CSDV'                                                     CSD079
 
     C                   MOVEL     TransID       DDCUSN_In
 
     C                   CALL      'SDCUSDR'
     C                   PARM                    AuthComp
     C                   PARM                    FwdBck
     C                   PARM                    DDCUSN_In         6
     C**********         PARM                    Buffer                                       CER059
     C                   PARM                    Buffer9999                                   CER059
     C                   PARM                    BufferEx2                                    CSW213
     C                   PARM                    BufferEx3                                    CSW213
     C                   PARM                    BufferEx4                                    CSW213
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetC
 
     C                   MOVEL     Buffer9999    Buffer                                       CER059
     C                   MOVE      Buffer9999    Buffer2                                      CER059
      * SD Securities Customers
 
     C     TransTYPE     WHENEQ    'SECD'
 
     C                   MOVEL     TransID       DDCUSN_In
 
     C                   CALL      'SDSECDR'
     C                   PARM                    AuthComp
     C                   PARM                    FwdBck
     C                   PARM                    DDCUSN_In         6
     C                   PARM                    Buffer
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetC
 
      * PM Portfolio Definition
 
     C     TransTYPE     WHENEQ    'PFDM'
 
     C                   MOVEL     TransID       DDCUSN_In
     C                   EVAL      DDPTFR_In = %SUBST(TransID:7:4)
 
     C                   CALL      'PMPFDMR'
     C                   PARM                    AuthComp
     C                   PARM                    FwdBck
     C                   PARM                    DDCUSN_In         6
     C                   PARM                    DDPTFR_In         4
     C                   PARM                    Buffer
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetC
 
      * MM Deal Amendments
 
     C     TransTYPE     WHENEQ    'DEAM'
 
     C                   MOVEL     TransID       DDDLNO_In
     C                   EVAL      DDVDAT_In = %SUBST(TransID:7:6)
     C                   EVAL      DDDS38_In = %SUBST(TransID:13:3)
 
     C                   CALL      'MMDEAMR'
     C                   PARM                    AuthComp
     C                   PARM                    FwdBck
     C                   PARM                    DDDLNO_In
     C                   PARM                    DDVDAT_In         6
     C                   PARM                    DDDS38_In         3
     C                   PARM                    Buffer
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetC
 
      * GL Collateral Details
 
     C     TransTYPE     WHENEQ    'COLL'
 
     C                   MOVEL     TransID       DDCREF_In
 
     C                   CALL      'GLCOLLR'
     C                   PARM                    AuthComp
     C                   PARM                    FwdBck
     C                   PARM                    DDCREF_In        10
     C                   PARM                    Buffer
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetC
 
      ** GL Collateral Allocations
 
     C     TransTYPE     WHENEQ    'COLA'
 
     C                   EVAL      ADBRCA_IN = %SUBST(TransID:1:3)
     C                   EVAL      ADCUSN_IN = %SUBST(TransID:4:10)
     C                   EVAL      ADMODI_IN = %SUBST(TransID:14:2)
     C                   EVAL      ADFCTY_IN = %SUBST(TransID:16:11)
     C                   EVAL      ADLNLM_IN = %SUBST(TransID:27:6)
     C**********         EVAL      ADREAC_IN = %SUBST(TransID:33:18)                          CGL029
     C**********         EVAL      ADCREF_IN = %SUBST(TransID:51:10)                          CGL029
     C                   EVAL      ADREAC_IN = %SUBST(TransID:33:24)                          CGL029
     C                   EVAL      ADCREF_IN = %SUBST(TransID:57:10)                          CGL029
 
     C                   CALL      'GLCOLAR'
     C                   PARM                    AuthComp          1
     C                   PARM                    FwdBck            1
     C                   PARM                    ADBRCA_IN         3
     C                   PARM                    ADCUSN_IN        10
     C                   PARM                    ADMODI_IN         2
     C                   PARM                    ADFCTY_IN        11
     C                   PARM                    ADLNLM_IN         6
     C**********         PARM                    ADREAC_IN        18                          CGL029
     C                   PARM                    ADREAC_IN        24                          CGL029
     C                   PARM                    ADCREF_IN        10
     C                   PARM                    Buffer
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetC
 
      * LE Facilities Details
 
     C     TransTYPE     WHENEQ    'FCIP'
 
     C                   MOVEL     TransID       DDCSSN_In
     C                   EVAL      DDFACT_In = %SUBST(TransID:11:3)
     C                   EVAL      DDFCNO_In = %SUBST(TransID:14:2)
 
     C                   CALL      'LEFCIPR'
     C                   PARM                    AuthComp
     C                   PARM                    FwdBck
     C                   PARM                    DDCSSN_In         6
     C                   PARM                    DDFACT_In         3
     C                   PARM                    DDFCNO_In         2
     C                   PARM                    DDBRCA_In         3
     C                   PARM                    Buffer
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetC
     C                   PARM                    DDPATH          200                       BUG13297A
 
      * LE Loan Details
 
     C     TransTYPE     WHENEQ    'CLIP'
 
     C                   MOVEL     TransID       DDLNRF_In
     C     1             SUBST     TransID:7     DDACTN_In                                   BUG3721
 
     C                   CALL      'LECLIPR'
     C                   PARM                    AuthComp
     C                   PARM                    FwdBck
     C                   PARM                    DDLNRF_In         6
     C                   PARM                    DDACTN_In         1                         BUG3721
     C                   PARM                    Buffer
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetC
      *                                                                                     AR804863
      ** Action Code (Reject transaction)                                                   AR804863
      *                                                                                     AR804863
     C                   PARM      *BLANK        @ACTRV            1                        AR804863
 
      * LE Rollover Details
 
     C     TransTYPE     WHENEQ    'LERI'
 
     C                   MOVEL     TransID       DDLNRF_In
     C     1             SUBST     TransID:7     DDACTN_In                                     BUG19
 
     C                   CALL      'LELERIR'
     C                   PARM                    AuthComp
     C                   PARM                    FwdBck
     C                   PARM                    DDLNRF_In         6
     C                   PARM                    DDACTN_In         1                           BUG19
     C                   PARM                    Buffer
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetC
     C                   PARM      *BLANK        @ACTRV            1                        AR702532
 
      * LE Repayment Schedules
 
     C     TransTYPE     WHENEQ    'RPSC'
 
     C                   EVAL      DDLNRF_In = TransID
     C                   EVAL      DDVDAT_In = %SUBST(TransID:7:6)
     C                   EVAL      DDSEQN_In = %SUBST(TransID:13:3)
 
     C                   CALL      'LERPSCR'
     C                   PARM                    AuthComp
     C                   PARM                    FwdBck
     C                   PARM                    DDLNRF_In
     C                   PARM                    DDSEQN_In         3
     C                   PARM                    DDVDAT_In
     C                   PARM                    Buffer
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetC
 
      * LE Loan Amendments
 
     C     TransTYPE     WHENEQ    'LOAM'
 
     C                   EVAL      DDLNRF_In = TransID
     C                   EVAL      DDVDAT_In = %SUBST(TransID:7:6)
     C                   EVAL      DDSEQN_In = %SUBST(TransID:13:3)
 
     C                   CALL      'LELOAMR'
     C                   PARM                    AuthComp
     C                   PARM                    FwdBck
     C                   PARM                    DDLNRF_In
     C                   PARM                    DDVDAT_In
     C                   PARM                    DDSEQN_In
     C                   PARM                    Buffer
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetC
 
      * LE Manual Repayment
 
     C     TransTYPE     WHENEQ    'MAPY'
 
     C                   EVAL      DDLNRF_In = TransID
     C                   EVAL      DDVDAT_In = %SUBST(TransID:7:6)
     C                   EVAL      DDSEQN_In = %SUBST(TransID:13:3)
 
     C                   CALL      'LEMAPYR'
     C                   PARM                    AuthComp
     C                   PARM                    FwdBck
     C                   PARM                    DDLNRF_In
     C                   PARM                    DDSEQN_In         3
     C                   PARM                    DDVDAT_In
     C                   PARM                    Buffer
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetC
 
      * SD Base rates
     C     TransTYPE     WHENEQ    'BSRT'
 
     C                   EVAL      DDCYCD_IN = %SUBST(TransID:1:3)
     C                   EVAL      DDBSRC_IN = %SUBST(TransID:4:2)
 
     C                   CALL      'SDBSRTR'
     C                   PARM                    FwdBck
     C                   PARM                    DDCYCD_IN         3
     C                   PARM                    DDBSRC_IN         2
     C                   PARM                    Buffer
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetC
 
      ** LE Fees                                                                             BUG1100
     C     TransTYPE     WHENEQ    'FEEM'                                                    BUG1100
                                                                                             BUG1100
     C                   EVAL      DDCNUM_IN = %SUBST(TransID:1:10)                          BUG1100
     C                   EVAL      DDFACT_IN = %SUBST(TransID:11:3)                          BUG1100
     C                   EVAL      DDFACN_IN = %SUBST(TransID:14:2)                          BUG1100
     C                   EVAL      DDLNRF_IN = %SUBST(TransID:16:6)                          BUG1100
     C                   EVAL      DDFSEQ_IN = %SUBST(TransID:22:2)                          BUG1100
                                                                                             BUG1100
     C                   CALL      'LEFEEMR'                                                 BUG1100
     C                   PARM                    AuthComp                                    BUG1100
     C                   PARM                    FwdBck                                      BUG1100
     C                   PARM                    DDCNUM_IN                                   BUG1100
     C                   PARM                    DDFACT_IN                                   BUG1100
     C                   PARM                    DDFACN_IN         2                         BUG1100
     C                   PARM                    DDLNRF_IN                                   BUG1100
     C                   PARM                    DDFSEQ_IN         3                         BUG1100
     C                   PARM                    Buffer                                      BUG1100
     C                   PARM                    FldNameArr                                  BUG1100
     C                   PARM                    MsgIDArr                                    BUG1100
     C                   PARM                    MsgDtaArr                                   BUG1100
     C                   PARM                    MsgFArray                                   BUG1100
     C                   PARM                    APIRetC                                     BUG1100
                                                                                             BUG1100
      * LE Fee Adjustment
     C     TransTYPE     WHENEQ    'FEAD'
 
     C                   EVAL      DDCNUM_IN = %SUBST(TransID:1:10)
     C                   EVAL      DDFACT_IN = %SUBST(TransID:11:3)
     C                   EVAL      DDFACN_IN = %SUBST(TransID:14:2)
     C                   EVAL      DDFSEQ_IN = %SUBST(TransID:16:2)
      *                                                                                       CLE073
     C                   EVAL      DDLOAN_IN = %SUBST(TransID:18:23)                          CLE073
      *                                                                                       CLE073
 
     C                   CALL      'LEFEADR'
     C                   PARM                    AuthComp
     C                   PARM                    FwdBck
     C                   PARM                    DDCNUM_IN
     C                   PARM                    DDFACT_IN
     C                   PARM                    DDFACN_IN         2
     C                   PARM                    DDFSEQ_IN         3
      *                                                                                       CLE073
     C                   PARM                    DDLOAN_IN         6                          CLE073
      *                                                                                       CLE073
     C                   PARM                    Buffer
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetC
 
      * LE Fee settlement
     C     TransTYPE     WHENEQ    'FEST'
 
     C                   EVAL      DDCNUM_IN = %SUBST(TransID:1:10)
     C                   EVAL      DDFACT_IN = %SUBST(TransID:11:3)
     C                   EVAL      DDFACN_IN = %SUBST(TransID:14:2)
     C                   EVAL      DDFSEQ_IN = %SUBST(TransID:16:2)
     C                   EVAL      DDVDAT_IN = %SUBST(TransID:18:6)
      *                                                                                       CLE073
     C                   EVAL      DDLOAN_IN = %SUBST(TransID:24:29)                          CLE073
      *                                                                                       CLE073
 
     C                   CALL      'LEFESTR'
     C                   PARM                    AuthComp
     C                   PARM                    FwdBck
     C                   PARM                    DDCNUM_IN
     C                   PARM                    DDFACT_IN
     C                   PARM                    DDFACN_IN         2
     C                   PARM                    DDFSEQ_IN         3
     C                   PARM                    DDVDAT_IN
      *                                                                                       CLE073
     C                   PARM                    DDLOAN_IN         6                          CLE073
      *                                                                                       CLE073
     C                   PARM                    Buffer
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetC
 
      * LE Funding Participant
     C     TransTYPE     WHENEQ    'FPRT'
 
     C                   EVAL      DDPMFC_IN = %SUBST(TransID:1:6)
     C                   EVAL      DDPMFT_IN = %SUBST(TransID:7:3)
     C                   EVAL      DDPMFN_IN = %SUBST(TransID:10:2)
     C                   EVAL      DDCNUM_IN = %SUBST(TransID:12:10)
     C                   EVAL      DDFACT_IN = %SUBST(TransID:22:3)
     C                   EVAL      DDFCNO_IN = %SUBST(TransID:25:2)
 
     C                   CALL      'LEFPRTR'
     C                   PARM                    AuthComp
     C                   PARM                    FwdBck
     C                   PARM                    DDPMFC_IN         6
     C                   PARM                    DDPMFT_IN         3
     C                   PARM                    DDPMFN_IN         2
     C                   PARM                    DDCNUM_IN        10
     C                   PARM                    DDFACT_IN         3
     C                   PARM                    DDFCNO_IN         2
     C                   PARM                    Buffer
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetC
 
      * LE Assignments
     C     TransTYPE     WHENEQ    'ASGN'
 
     C                   EVAL      DDBRCA_IN = %SUBST(TransID:1:3)
     C                   EVAL      DDCNAM_IN = %SUBST(TransID:4:6)
     C                   EVAL      DDFACT_IN = %SUBST(TransID:10:3)
     C                   EVAL      DDFCNO_IN = %SUBST(TransID:13:2)
     C                   EVAL      DDMNUM_IN = %SUBST(TransID:15:10)
     C                   EVAL      DDINUM_IN = %SUBST(TransID:25:10)
     C                   EVAL      DDVDTC_IN = %SUBST(TransID:35:6)
 
     C                   CALL      'LEASGNR'
     C                   PARM                    AuthComp          1
     C                   PARM                    FwdBck            1
     C                   PARM                    DDBRCA_IN         3
     C                   PARM                    DDCNAM_IN         6
     C                   PARM                    DDFACT_IN         3
     C                   PARM                    DDFCNO_IN         2
     C                   PARM                    DDMNUM_IN        10
     C                   PARM                    DDINUM_IN        10
     C                   PARM                    DDVDTC_IN         6
     C                   PARM                    Buffer
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetC
 
      * LE Facility Amendments
     C     TransTYPE     WHENEQ    'FAMD'
 
     C                   EVAL      DDCCSN_IN = %SUBST(TransID:1:10)
     C                   EVAL      DDFACT_IN = %SUBST(TransID:11:3)
     C                   EVAL      DDFCNO_IN = %SUBST(TransID:14:2)
     C                   EVAL      DDFATP_IN = %SUBST(TransID:16:2)
     C                   EVAL      DDVLDT_IN = %SUBST(TransID:18:6)
     C                   EVAL      DDSQNO_IN = %SUBST(TransID:24:3)
 
     C                   CALL      'LEFAMDR'
     C                   PARM                    AuthComp          1
     C                   PARM                    FwdBck            1
     C                   PARM                    DDCCSN_IN        10
     C                   PARM                    DDFACT_IN         3
     C                   PARM                    DDFCNO_IN         2
     C                   PARM                    DDFATP_IN         2
     C                   PARM                    DDVLDT_IN         6
     C                   PARM                    DDSQNO_IN         3
     C                   PARM                    Buffer
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetC
 
      * FRA - Forward Rate Agreement deals
     C     TransTYPE     WHENEQ    'FRA '
 
     C                   EVAL      DDDLNO_IN = %SUBST(TransID:1:6)
 
     C                   CALL      'IRFRAR'
     C                   PARM                    AuthComp
     C                   PARM                    FwdBck
     C                   PARM                    DDDLNO_IN         6
     C                   PARM                    Buffer
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetC
 
      ** Single Currency IRS (SIRS)
 
     C     TransTYPE     WHENEQ    'SIRS'
 
     C                   EVAL      DDDLNO_IN = %SUBST(TransID:1:6)
 
     C                   CALL      'IRSIRSR'
     C                   PARM                    AuthComp
     C                   PARM                    FwdBck
     C                   PARM                    DDDLNO_IN
     C                   PARM                    Buffer
     C                   PARM                    Buffer2                                     BUG4646
     C                   PARM                    BufferEx2                                   BUG4646
     C                   PARM                    BufferEx3                                   BUG4646
     C                   PARM                    BufferEx4                                   BUG4646
     C                   PARM                    BufferEx5                                   BUG4646
     C                   PARM                    BufferEx6                                   BUG4646
     C                   PARM                    BufferEx7                                   BUG4646
     C                   PARM                    BufferEx8                                   BUG4646
     C                   PARM                    BufferEx9                                   BUG4646
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetC
 
      ** Cross Currency IRS (CIRS)
 
     C     TransTYPE     WHENEQ    'CIRS'
 
     C                   EVAL      DDDLNO_IN = %SUBST(TransID:1:6)
 
     C                   CALL      'IRCIRSR'
     C                   PARM                    AuthComp
     C                   PARM                    FwdBck
     C                   PARM                    DDDLNO_IN
     C                   PARM                    Buffer
     C                   PARM                    Buffer2                                     BUG5449
     C                   PARM                    BufferEx2                                   BUG5449
     C                   PARM                    BufferEx3                                   BUG5449
     C                   PARM                    BufferEx4                                   BUG5449
     C                   PARM                    BufferEx5                                   BUG5449
     C                   PARM                    BufferEx6                                   BUG5449
     C                   PARM                    BufferEx7                                   BUG5449
     C                   PARM                    BufferEx8                                   BUG5449
     C                   PARM                    BufferEx9                                   BUG5449
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetC
 
      * SE Securities Details
     C     TransTYPE     WHENEQ    'SECS'
 
     C                   MOVEL     TransID       DDSESN_IN
 
     C                   CALL      'SESECSR'
     C                   PARM                    AuthComp
     C                   PARM                    FwdBck
     C                   PARM                    DDSESN_IN        10
     C                   PARM                    Buffer
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetC
 
      * SE Securities Trades
     C     TransTYPE     WHENEQ    'TRAD'
 
     C                   MOVEL     TransID       DDTDRF_IN
 
     C                   CALL      'SETRADR'
     C                   PARM                    AuthComp
     C                   PARM                    FwdBck
     C                   PARM                    DDTDRF_IN         6
     C                   PARM                    Buffer
     C                   PARM                    Buffer2                                     CSF011A
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetC
 
      * Data areas
 
     C     TransTYPE     WHENEQ    'DTAA'
 
     C                   MOVEL     TransID       DataArea
 
     C                   CALL      'AOCDTAAR0'
     C                   PARM                    DataArea         10
     C                   PARM                    Value          2000
     C                   MOVEL     Value         Buffer
 
      * RFT - Request for Transfer
     C     TransTYPE     WHENEQ    'RFTD'
 
     C                   MOVEL     TransID       DDRFTID_In
 
     C                   CALL      'FTM1011R'
     C                   PARM                    AuthComp
     C                   PARM                    FwdBck
     C                   PARM                    DDRFTID_IN       15
     C                   PARM                    Buffer
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetC
 
      * RFT - Request for Transfer details
     C     TransTYPE     WHENEQ    'RFT2'
 
     C                   EVAL      DDRFTID_IN = %SUBST(TransID:1:15)
     C                   EVAL      DDTRANR_IN = %SUBST(TransID:16:16)
 
     C                   CALL      'FTM1012R'
     C                   PARM                    AuthComp
     C                   PARM                    FwdBck
     C                   PARM                    DDRFTID_IN       15
     C                   PARM                    DDTRANR_IN       16
     C                   PARM                    Buffer
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetC
 
      ** CCT - Customer Credit Transfer
 
     C     TransTYPE     WHENEQ    'CCTD'
 
     C                   MOVEL     TransID       DDCCTID_In
 
     C                   CALL      'FTM1021R'
     C                   PARM                    AuthComp
     C                   PARM                    FwdBck
     C                   PARM                    DDCCTID_IN       15
     C                   PARM                    Buffer
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetC
 
      ** CCT - Customer Credit Transfer details
 
     C     TransTYPE     WHENEQ    'CCT2'
 
     C                   EVAL      DDCCTID_IN = %SUBST(TransID:1:15)
     C                   EVAL      DDTRANR_IN = %SUBST(TransID:16:16)
 
     C                   CALL      'FTM1022R'
     C                   PARM                    AuthComp
     C                   PARM                    FwdBck
     C                   PARM                    DDCCTID_IN       15
     C                   PARM                    DDTRANR_IN       16
     C                   PARM                    Buffer
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetC
 
      ** OTCC - Futures and Options Currency OTC
 
     C     TransTYPE     WHENEQ    'OTCC'
 
     C                   MOVEL     TransID       DDTRNO_In
 
     C                   CALL      'FFOTCCR'
     C                   PARM                    AuthComp
     C                   PARM                    FwdBck
     C                   PARM                    DDTRNO_IN         6
     C                   PARM                    Buffer
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetC
 
      ** OTCO - Futures and Options Non currency OTC
 
     C     TransTYPE     WHENEQ    'OTCO'
 
     C                   MOVEL     TransID       DDTRNO_In
 
     C                   CALL      'FFOTCOR'
     C                   PARM                    AuthComp
     C                   PARM                    FwdBck
     C                   PARM                    DDTRNO_IN
     C                   PARM                    Buffer
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetC
 
      ** EXTR - Futures and Options Exchange-Traded Transactions
 
     C     TransTYPE     WHENEQ    'EXTR'
 
     C                   MOVEL     TransID       DDTRNO_In
 
     C                   CALL      'FFEXTRR'
     C                   PARM                    AuthComp
     C                   PARM                    FwdBck
     C                   PARM                    DDTRNO_IN         6
     C                   PARM                    Buffer
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetC
 
      * SE Depot Movements
     C     TransTYPE     WHENEQ    'DPWI'
     C     TransTYPE     OREQ      'DPWO'
     C     TransTYPE     OREQ      'DPMV'                                                     CAP087
 
     C*******************MOVEL     TransID       TempWork          8                          CAP087
     C*******************MOVEL     TempWork      DDDPRN_IN                                    CAP087
     C*******************MOVE      TempWork      DDDPMV_IN                                    CAP087
     C                   MOVEL     TransID       TempWork         18                          CAP087
     C     10            SUBST     TransID:1     DDDPSS_In        10                          CAP087
     C     6             SUBST     TransID:11    DDDPRN_In                                    CAP087
     C     2             SUBST     TransID:17    DDDPMV_In                                    CAP087
 
     C                   CALL      'SEDPMVR'
     C                   PARM                    AuthComp
     C                   PARM                    FwdBck
     C                   PARM                    DDDPMV_IN         2
     C                   PARM                    DDDPRN_IN         6
     C                   PARM                    DDDPSS_In                                   BUG9994
     C                   PARM                    Buffer
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetC
 
      * MM Negotiable Assets Purchased
 
     C     TransTYPE     WHENEQ    'NASP'
 
     C                   MOVEL     TransID       DDDLNO_In
 
     C                   CALL      'MMNASPR'
     C                   PARM                    AuthComp
     C                   PARM                    FwdBck
     C                   PARM                    DDDLNO_In
     C                   PARM                    Buffer
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetC
 
      * MM Negotiable Assets Sold
 
     C     TransTYPE     WHENEQ    'NASS'
 
     C                   MOVEL     TransID       DDDLNO_In
 
     C                   CALL      'MMNASSR'
     C                   PARM                    AuthComp
     C                   PARM                    FwdBck
     C                   PARM                    DDDLNO_In
     C                   PARM                    Buffer
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetC
 
     C     TransTYPE     WHENEQ    'RODL'
 
     C                   MOVEL     TransID       DDDLNO_In
 
     C                   CALL      'MMRODLR'
     C                   PARM                    AuthComp
     C                   PARM                    FwdBck
     C                   PARM                    DDDLNO_In
     C                   PARM                    Buffer
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetC
 
     C     TransTYPE     WHENEQ    'CACF'
 
     C                   MOVEL     TransID       DDDLNO_In
 
     C                   CALL      'IRCACFR'
     C                   PARM                    AuthComp
     C                   PARM                    FwdBck
     C                   PARM                    DDDLNO_In
     C                   PARM                    Buffer
     C                   PARM                    Buffer2                                     BUG5403
     C                   PARM                    BufferEx2                                   BUG5403
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetC
 
      ** CLS Pay-in Schedules Header
 
     C     TransTYPE     WHENEQ    'CLSP'
 
     C                   MOVEL     TransID       PCcy_In
     C                   EVAL      PNost_In = %SUBST(TransID:4:2)
     C                   EVAL      PVDate_In = %SUBST(TransID:6:6)
     C                   EVAL      PSeq_In = %SUBST(TransID:12:2)
 
     C                   CALL      'FXCLSPR'
     C                   PARM                    AuthComp
     C                   PARM                    FwdBck
     C                   PARM                    PCCy_In           3
     C                   PARM                    PNost_In          2
     C                   PARM                    PVDate_In         6
     C                   PARM                    PSeq_In           2
     C                   PARM                    Buffer
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetC
 
      ** CLS Pay-in Schedules Detail
 
     C     TransTYPE     WHENEQ    'CLS2'
 
     C                   MOVEL     TransID       PCcy_In
     C                   EVAL      PNost_In = %SUBST(TransID:4:2)
     C                   EVAL      PVDate_In = %SUBST(TransID:6:6)
     C                   EVAL      PSeq_In = %SUBST(TransID:12:2)
     C                   EVAL      PTime_In = %SUBST(TransID:14:4)
      *******************EVAL      PAmt_In = %SUBST(TransID:18:18)                           BUG5671
     C                   EVAL      PDSeq_In = %SUBST(TransID:18:2)                           BUG5671
 
     C                   CALL      'FXCLSPR2'
     C                   PARM                    AuthComp
     C                   PARM                    FwdBck
     C                   PARM                    PCCy_In           3
     C                   PARM                    PNost_In          2
     C                   PARM                    PVDate_In         6
     C                   PARM                    PSeq_In           2
     C                   PARM                    PTime_In          4
      *******************PARM                    PAmt_In          18                         BUG5671
     C                   PARM                    PDSeq_In          2                         BUG5671
     C                   PARM                    Buffer
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetC
 
      ** INTC Internal Contracts
 
     C     TransTYPE     WHENEQ    'INTC'
 
     C                   EVAL      DDL1DN_IN = %SUBST(TransID:1:6)
     C                   EVAL      DDL2DN_IN = %SUBST(TransID:7:12)
     C                   EVAL      DDBRCD_IN = %SUBST(TransID:13:15)
     C                   EVAL      DDORBR_IN = %SUBST(TransID:16:18)
 
     C                   CALL      'ABINTCR'
     C                   PARM                    AuthComp
     C                   PARM                    FwdBck
     C                   PARM                    DDL1DN_In         6
     C                   PARM                    DDL2DN_In         6
     C                   PARM                    DDBRCD_In         3
     C                   PARM                    DDORBR_In         3
     C                   PARM                    Buffer
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetC
 
      ** AB Internal Funding Deals
 
     C     TransTYPE     WHENEQ    'FUND'
 
     C                   MOVEL     TransID       DDDLNO_In
 
     C                   CALL      'ABFUNDR'
     C                   PARM                    AuthComp
     C                   PARM                    FwdBck
     C                   PARM                    DDDLNO_In
     C                   PARM                    Buffer
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetC
 
      ** GL Batch Headers
      ** GL Journal Header Maintenance - Non-retail                                          BUG9009
 
     C     TransTYPE     WHENEQ    'BITH'
     C     TransTYPE     OrEq      'BINH'                                                    BUG9009
 
     C                   MOVEL     TransID       DDBTNB_In
 
     C                   CALL      'GLBITHR'
     C                   PARM                    AuthComp
     C                   PARM                    FwdBck
     C                   PARM                    DDBTNB_In         3
     C                   PARM                    Buffer
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetC
 
      ** GL Batch Items
      ** GL Journal Entry Item Maintenance - Non-retail                                      BUG9009
 
     C     TransTYPE     WHENEQ    'BITP'
     C     TransTYPE     OrEq      'BINP'                                                    BUG9009
 
     C                   MOVEL     TransID       DDBTNB_In
     C                   EVAL      DDBTNB_IN = %SUBST(TransID:1:3)
     C                   EVAL      DDBINB_IN = %SUBST(TransID:4:6)
 
     C                   CALL      'GLBITPR'
     C                   PARM                    AuthComp
     C                   PARM                    FwdBck
     C                   PARM                    DDBTNB_In         3
     C                   PARM                    DDBINB_In         3
     C                   PARM                    Buffer
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetC
 
      ** SD Spot Rates
 
     C     TransTYPE     WHENEQ    'SPTR'
 
     C                   MOVEL     TransID       DDCYCD_In
 
     C                   CALL      'SDSPTRR'
     C                   PARM                    AuthComp
     C                   PARM                    FwdBck
     C                   PARM                    DDCYCD_In
     C                   PARM                    Buffer
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetC
 
      ** IPAY SWIFT API
     C     TransTYPE     WHENEQ    'IPSW'
 
     C                   MOVEL     TransID       DDMSGR_In         8
     C     3             SUBST     TransID:9     DDPART_In         3
 
     C                   CALL      'FTIPSWR'
     C                   PARM                    DDMSGR_In
     C                   PARM                    DDPART_In
     C                   PARM                    Buffer
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetc
                                                                                              CSC021
      ** Help Link API                                                                        CSC021
     C     TransTYPE     WHENEQ    'HELP'                                                     CSC021
                                                                                              CSC021
     C                   EVAL      CallFm_IN = %SUBST(APParm:3:1)                             CSC021
     C                   EVAL      KeyInf_IN = %SUBST(APParm:4:200)                           CSC021
                                                                                              CSC021
     C                   CALL      'SCHELPR'                                                  CSC021
     C                   PARM                    CallFm_In         1                          CSC021
     C                   PARM                    KeyInf_In       200                          CSC021
     C                   PARM                    Buffer                                       CSC021
     C                   PARM                    FldNameArr                                   CSC021
     C                   PARM                    MsgIDArr                                     CSC021
     C                   PARM                    MsgDtaArr                                    CSC021
     C                   PARM                    MsgFArray                                    CSC021
     C                   PARM                    APIRetc                                      CSC021
 
      ** FD Forward rates API
 
     C     TransTYPE     WHENEQ    'FWRT'
 
     C                   MOVEL     TransID       DDCCY_In          3
 
     C                   CALL      'FDFWRTR'
     C                   PARM                    AuthComp
     C                   PARM                    FwdBck
     C                   PARM                    DDCCY_In
     C                   PARM                    Buffer
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetC
 
     C     TransTYPE     WHENEQ    'INTR'
 
     C                   MOVEL     TransID       DDCYCD_In
 
     C                   CALL      'FDINTRR'
     C                   PARM                    AuthComp
     C                   PARM                    FwdBck
     C                   PARM                    DDCYCD_In
     C                   PARM                    Buffer
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetC
                                                                                             BUG1055
      ** SE Security Diary Events                                                            BUG1055
                                                                                             BUG1055
     C     TransTYPE     WHENEQ    'SEDE'                                                    BUG1055
                                                                                             BUG1055
     C                   EVAL      DDSDSN_IN = %SUBST(TransID:1:10)                          BUG1055
     C                   EVAL      DDSDED_IN = %SUBST(TransID:11:6)                          BUG1055
     C                   EVAL      DDSDET_IN = %SUBST(TransID:17:2)                          BUG1055
                                                                                             BUG1055
     C                   CALL      'SESEDER'                                                 BUG1055
     C                   PARM                    AuthComp                                    BUG1055
     C                   PARM                    FwdBck                                      BUG1055
     C                   PARM                    DDSDSN_In        10                         BUG1055
     C                   PARM                    DDSDED_In         6                         BUG1055
     C                   PARM                    DDSDET_In         2                         BUG1055
     C                   PARM                    Buffer                                      BUG1055
     C                   PARM                    FldNameArr                                  BUG1055
     C                   PARM                    MsgIDArr                                    BUG1055
     C                   PARM                    MsgDtaArr                                   BUG1055
     C                   PARM                    MsgFArray                                   BUG1055
     C                   PARM                    APIRetC                                     BUG1055
                                                                                             BUG1055
                                                                                             BUG1057
      ** SE Securities Prices                                                                BUG1057
                                                                                             BUG1057
     C     TransTYPE     WHENEQ    'PRCS'                                                    BUG1057
                                                                                             BUG1057
     C                   EVAL      DDPSSN_In = %SUBST(TransID:1:10)                          BUG1057
     C                   EVAL      DDPCNM_In = %SUBST(TransID:11:10)                         BUG1057
     C                   EVAL      DDPMKT_In = %SUBST(TransID:21:1)                          BUG1057
     C                   EVAL      DDPBRA_In = %SUBST(TransID:22:3)                          BUG1057
     C                   EVAL      DDPBOK_In = %SUBST(TransID:25:2)                          BUG1057
     C                   EVAL      DDPPRT_In = %SUBST(TransID:27:2)                          BUG1057
     C                   EVAL      DDPTFR_In = %SUBST(TransID:29:4)                          BUG1057
     C                                                                                       BUG1057
     C                   CALL      'SEPRCSR'                                                 BUG1057
     C                   PARM                    AuthComp                                    BUG1057
     C                   PARM                    FwdBck                                      BUG1057
     C                   PARM                    DDPSSN_In        10                         BUG1057
     C                   PARM                    DDPCNM_In        10                         BUG1057
     C                   PARM                    DDPMKT_In         1                         BUG1057
     C                   PARM                    DDPBRA_In         3                         BUG1057
     C                   PARM                    DDPBOK_In         2                         BUG1057
     C                   PARM                    DDPPRT_In         2                         BUG1057
     C                   PARM                    DDPTFR_In         4                         BUG1057
     C                   PARM                    Buffer                                      BUG1057
     C                   PARM                    FldNameArr                                  BUG1057
     C                   PARM                    MsgIDArr                                    BUG1057
     C                   PARM                    MsgDtaArr                                   BUG1057
     C                   PARM                    MsgFArray                                   BUG1057
     C                   PARM                    APIRetC                                     BUG1057
                                                                                             CGP010
      ** BSPL Requests                                                                       CGP010
                                                                                             CGP010
     C     TransTYPE     WHENEQ    'BSRQ'                                                    CGP010
                                                                                             CGP010
     C                   EVAL      DDRQTYP_In = %SUBST(TransID:1:1)                          CGP010
     C                   EVAL      DDRQID_In  = %SUBST(TransID:2:15)                         CGP010
     C                                                                                       CGP010
     C                   CALL      'GOBSRQR'                                                 CGP010
     C                   PARM                    DDRQTYP_In        1                         CGP010
     C                   PARM                    DDRQID_In        15                         CGP010
     C                   PARM                    Buffer                                      CGP010
     C                   PARM                    FldNameArr                                  CGP010
     C                   PARM                    MsgIDArr                                    CGP010
     C                   PARM                    MsgDtaArr                                   CGP010
     C                   PARM                    MsgFArray                                   CGP010
     C                   PARM                    APIRetC                                     CGP010
                                                                                             BUG6417
      ** Cash Management Interest Statement                                                  BUG6417
                                                                                             BUG6417
     C     TransTYPE     WHENEQ    'RISL'                                                    BUG6417
                                                                                             BUG6417
     C                   MOVEL     TransID       I_RACCID                                    BUG6417
     C                   EVAL      I_R_DR_CR = %subst(Buffer: 1 : 1 )                        BUG6417
     C                   EVAL      I_SPnt    = %subst(Buffer: 2 : 5 )                        BUG6417
                                                                                             BUG6417
     C                   CALL      'RE104001'                                                BUG6417
     C                   PARM                    I_RACCID         24                         BUG6417
     C                   PARM                    I_R_DR_CR         1                         BUG6417
     C                   PARM                    I_SPnt            5                         BUG6417
     C                   PARM                    Buffer                                      BUG6417
     C                   PARM                    FldNameArr                                  BUG6417
     C                   PARM                    MsgIDArr                                    BUG6417
     C                   PARM                    MsgDtaArr                                   BUG6417
     C                   PARM                    MsgFArray                                   BUG6417
     C                   PARM                    APIRetc           1                         BUG6417
                                                                                              CAS011
      ** DL Dealing Fees                                                                      CAS011
                                                                                              CAS011
     C     TransTYPE     WHENEQ    'DLFE'                                                     CAS011
                                                                                              CAS011
     C                   EVAL      DDDLNO_IN = %SUBST(TransID:1:6)                            CAS011
     C                   EVAL      DDDFSQ_IN = %SUBST(TransID:7:8)                            CAS011
                                                                                              CAS011
     C                   CALL      'DLDLFER'                                                  CAS011
     C                   PARM                    AuthComp                                     CAS011
     C                   PARM                    FwdBck                                       CAS011
     C                   PARM                    DDDLNO_IN                                    CAS011
     C                   PARM                    DDDFSQ_IN         2                          CAS011
     C                   PARM                    Buffer                                       CAS011
     C                   PARM                    FldNameArr                                   CAS011
     C                   PARM                    MsgIDArr                                     CAS011
     C                   PARM                    MsgDtaArr                                    CAS011
     C                   PARM                    MsgFArray                                    CAS011
     C                   PARM                    APIRetC                                      CAS011
      *
      ** Collateral Type Details Retrieval                                                    CRE026
      *                                                                                       CRE026
     C     TransTYPE     WHENEQ    'COTY'                                                     CRE026
                                                                                              CRE026
     C                   MOVEL     TransID       DDCOLT_In                                    CRE026
                                                                                              CRE026
     C                   CALL      'SDCOTYR'                                                  CRE026
     C                   PARM                    AuthComp                                     CRE026
     C                   PARM                    FwdBck                                       CRE026
     C                   PARM                    DDCOLT_In         5                          CRE026
     C                   PARM                    Buffer                                       CRE026
     C                   PARM                    FldNameArr                                   CRE026
     C                   PARM                    MsgIDArr                                     CRE026
     C                   PARM                    MsgDtaArr                                    CRE026
     C                   PARM                    MsgFArray                                    CRE026
     C                   PARM                    APIRetC                                      CRE026
      *                                                                                       CRE026
      ** Country Details Retrieval                                                            CRE026
      *                                                                                       CRE026
     C     TransTYPE     WHENEQ    'CNTY'                                                     CRE026
                                                                                              CRE026
     C                   MOVEL     TransID       DDCNCD_In                                    CRE026
                                                                                              CRE026
     C                   CALL      'SDCNTYR'                                                  CRE026
     C                   PARM                    AuthComp                                     CRE026
     C                   PARM                    FwdBck                                       CRE026
     C                   PARM                    DDCNCD_In         2                          CRE026
     C                   PARM                    Buffer                                       CRE026
     C                   PARM                    FldNameArr                                   CRE026
     C                   PARM                    MsgIDArr                                     CRE026
     C                   PARM                    MsgDtaArr                                    CRE026
     C                   PARM                    MsgFArray                                    CRE026
     C                   PARM                    APIRetC                                      CRE026
      *                                                                                       CRE026
      ** Alternate Name and Addresses Retrieval                                               CRE026
      *                                                                                       CRE026
     C     TransTYPE     WHENEQ    'ALNA'                                                     CRE026
     C     TransTYPE     OREQ      'ALNU'                                                     CRE026
                                                                                              CRE026
     C                   EVAL      DDCUST_In = %SUBST(TransID:1:6)                            CRE026
     C                   EVAL      DDADCD_In = %SUBST(TransID:7:1)                            CRE026
                                                                                              CRE026
     C                   CALL      'SDALNAR'                                                  CRE026
     C                   PARM                    AuthComp                                     CRE026
     C                   PARM                    FwdBck                                       CRE026
     C                   PARM                    DDCUST_In         6                          CRE026
     C                   PARM                    DDADCD_In         1                          CRE026
     C                   PARM                    Buffer                                       CRE026
     C                   PARM                    FldNameArr                                   CRE026
     C                   PARM                    MsgIDArr                                     CRE026
     C                   PARM                    MsgDtaArr                                    CRE026
     C                   PARM                    MsgFArray                                    CRE026
     C                   PARM                    APIRetC                                      CRE026
      *                                                                                       CRE026
      ** User Definitions + Menu Items Details Retrieval                                      CRE026
      *                                                                                       CRE026
     C     TransTYPE     WHENEQ    'AMUS'                                                     CRE026
                                                                                              CRE026
     C                   MOVEL     TransID       DDUSRP_In                                    CRE026
                                                                                              CRE026
     C                   CALL      'SFAMUSR'                                                  CRE026
     C                   PARM                    AuthComp                                     CRE026
     C                   PARM                    FwdBck                                       CRE026
     C                   PARM                    DDUSRP_In        10                          CRE026
     C                   PARM                    Buffer                                       CRE026
     C                   PARM                    Buffer2                                      CRE026
     C                   PARM                    FldNameArr                                   CRE026
     C                   PARM                    MsgIDArr                                     CRE026
     C                   PARM                    MsgDtaArr                                    CRE026
     C                   PARM                    MsgFArray                                    CRE026
     C                   PARM                    APIRetC                                      CRE026
      *                                                                                       CRE026
      ** Nostro Codes Detail Retrieval                                                        CRE026
      *                                                                                       CRE026
     C     TransTYPE     WHENEQ    'NOSR'                                                     CRE026
     C     TransTYPE     OREQ      'NOSU'                                                     CRE026
                                                                                              CRE026
     C                   EVAL      DDCYCD_In = %SUBST(TransID:1:3)                            CRE026
     C                   EVAL      DDNONB_In = %SUBST(TransID:4:2)                            CRE026
                                                                                              CRE026
     C                   CALL      'SDNOSRR'                                                  CRE026
     C                   PARM                    AuthComp                                     CRE026
     C                   PARM                    FwdBck                                       CRE026
     C                   PARM                    DDCYCD_In         3                          CRE026
     C                   PARM                    DDNONB_In         2                          CRE026
     C                   PARM                    Buffer                                       CRE026
     C                   PARM                    FldNameArr                                   CRE026
     C                   PARM                    MsgIDArr                                     CRE026
     C                   PARM                    MsgDtaArr                                    CRE026
     C                   PARM                    MsgFArray                                    CRE026
     C                   PARM                    APIRetC                                      CRE026
      *                                                                                       CRE026
      ** Yield Curve Detail Retrieval                                                         CRE026
      *                                                                                       CRE026
     C     TransTYPE     WHENEQ    'YLCU'                                                     CRE026
                                                                                              CRE026
     C                   MOVEL     TransID       DDYLDC_In                                    CRE026
                                                                                              CRE026
     C                   CALL      'SDYLCUR'                                                  CRE026
     C                   PARM                    AuthComp                                     CRE026
     C                   PARM                    FwdBck                                       CRE026
     C                   PARM                    DDYLDC_In         5                          CRE026
     C                   PARM                    Buffer                                       CRE026
     C                   PARM                    FldNameArr                                   CRE026
     C                   PARM                    MsgIDArr                                     CRE026
     C                   PARM                    MsgDtaArr                                    CRE026
     C                   PARM                    MsgFArray                                    CRE026
     C                   PARM                    APIRetC                                      CRE026
      *                                                                                       CRE026
      ** Yield Rate Detail Retrieval                                                          CRE026
      *                                                                                       CRE026
     C     TransTYPE     WHENEQ    'YRAT'                                                     CRE026
                                                                                              CRE026
     C                   EVAL      #0YLDC    = %SUBST(TransID:1:5)                            CRE026
     C                   EVAL      #0YCCY    = %SUBST(TransID:6:3)                            CRE026
     C                   EVAL      #0YICM    = %SUBST(TransID:9:1)                            CRE026
     C                   EVAL      #0YCFQ    = %SUBST(TransID:10:1)                           CRE026
     C                   EVAL      #0SPDY    = %SUBST(TransID:11:2)                           CRE026
                                                                                              CRE026
     C                   CALL      'SDYRATR'                                                  CRE026
     C                   PARM                    AuthComp                                     CRE026
     C                   PARM                    FwdBck                                       CRE026
     C                   PARM                    #0YLDC            5                          CRE026
     C                   PARM                    #0YCCY            3                          CRE026
     C                   PARM                    #0YICM            1                          CRE026
     C                   PARM                    #0YCFQ            1                          CRE026
     C                   PARM                    #0SPDY            2                          CRE026
     C                   PARM                    Buffer                                       CRE026
     C                   PARM                    FldNameArr                                   CRE026
     C                   PARM                    MsgIDArr                                     CRE026
     C                   PARM                    MsgDtaArr                                    CRE026
     C                   PARM                    MsgFArray                                    CRE026
     C                   PARM                    APIRetC                                      CRE026
      *                                                                                       CRE026
      ** Risk Weighted Asset Detail Retrieval                                                 CSD079
      *                                                                                       CSD079
     C     TransTYPE     WHENEQ    'RWAN'                                                     CSD079
                                                                                              CSD079
     C                   MOVEL     TransID       DDCUST_In                                    CSD079
                                                                                              CSD079
     C                   CALL      'SDRWANR'                                                  CSD079
     C                   PARM                    AuthComp                                     CSD079
     C                   PARM                    FwdBck                                       CSD079
     C                   PARM                    DDCUST_In                                    CSD079
     C                   PARM                    Buffer                                       CSD079
     C                   PARM                    FldNameArr                                   CSD079
     C                   PARM                    MsgIDArr                                     CSD079
     C                   PARM                    MsgDtaArr                                    CSD079
     C                   PARM                    MsgFArray                                    CSD079
     C                   PARM                    APIRetC                                      CSD079
      *                                                                                       CSD079
      ** Customer Withholding Tax Detail Retrieval                                            CSD079
      *                                                                                       CSD079
     C     TransTYPE     WHENEQ    'CUWT'                                                     CSD079
     C     TransTYPE     OREQ      'CUWU'                                                     CSD079
                                                                                              CSD079
     C                   EVAL      DDCSNO_In = %SUBST(TransID:1:6)                            CSD079
                                                                                              CSD079
     C                   CALL      'SDCUWTR'                                                  CSD079
     C                   PARM                    AuthComp                                     CSD079
     C                   PARM                    FwdBck                                       CSD079
     C                   PARM                    DDCSNO_In                                    CSD079
     C                   PARM                    Buffer                                       CSD079
     C                   PARM                    FldNameArr                                   CSD079
     C                   PARM                    MsgIDArr                                     CSD079
     C                   PARM                    MsgDtaArr                                    CSD079
     C                   PARM                    MsgFArray                                    CSD079
     C                   PARM                    APIRetC                                      CSD079
                                                                                              CSD079
     C     TransTYPE     WHENEQ    'PDCL'                                                     CLE134
      *                                                                                       CLE134
     C                   EVAL      DDORLN_In = %SUBST(TransID:01:06)                          CLE134
     C                   EVAL      DDFECU_In = %SUBST(TransID:07:12)                          CLE134
     C                   EVAL      DDFFAC_In = %SUBST(TransID:13:17)                          CLE134
     C**********         EVAL      DDFESQ_In = %SUBST(TransID:18:19)                   CLE134 264044
     C                   EVAL      DDFSE2_In = %SUBST(TransID:18:19)                          264044
     C                   EVAL      DDFLNO_In = %SUBST(TransID:20:25)                          CLE134
     C                   EVAL      DDPLON_In = %SUBST(TransID:26:31)                          264044
     C                   EVAL      DDPLO2_In = %SUBST(TransID:32:37)                          264044
     C**********         EVAL      DDACTN_In = %SUBST(TransID:26:26)                   CLE134 264044
     C                   EVAL      DDACTN_In = %SUBST(TransID:38:38)                          264044
      *                                                                                       CLE134
     C                   CALL      'LEPDCLR'                                                  CLE134
     C                   PARM                    AuthComp                                     CLE134
     C                   PARM                    FwdBck                                       CLE134
     C                   PARM                    HeadIn                                    AR1078092
      *                                                                                       CLE134
      ** Key fields                                                                           CLE134
      *                                                                                       CLE134
     C                   PARM                    DDORLN_In                                    CLE134
     C                   PARM                    DDFECU_In                                    CLE134
     C                   PARM                    DDFFAC_In                                    CLE134
     C**********         PARM                    DDFESQ_In                             CLE134 264044
     C                   PARM                    DDFSE2_In                                    264044
     C                   PARM                    DDFLNO_In                                    CLE134
     C                   PARM                    DDPLON_In                                    264044
     C                   PARM                    DDPLO2_In                                    264044
      *                                                                                       264044
     C                   PARM                    DDACTN_In                                    CLE134
      *                                                                                       CLE134
      ** Buffers                                                                              CLE134
      *                                                                                       CLE134
     C                   PARM                    Buffer                                       CLE134
     C                   PARM                    FldNameArr                                   CLE134
     C                   PARM                    MsgIDArr                                     CLE134
     C                   PARM                    MsgDtaArr                                    CLE134
     C                   PARM                    MsgFArray                                    CLE134
     C                   PARM                    APIRetC                                      CLE134
 
      *                                                                                       CAP210
      ** Dealing Adjustment to Accrued Interest                                               CAP210
      *                                                                                       CAP210
     C     TransTYPE     WHENEQ    'DLAA'                                                     CAP210
                                                                                              CAP210
     C                   MOVEL     TransID       DDDLNO_In                                    CAP210
     C     1             SUBST     TransID:19    DDACTN_In                                    CAP210
                                                                                              CAP210
     C                   CALL      'DLDLAAR'                                                  CAP210
     C                   PARM                    AuthComp                                     CAP210
     C                   PARM                    FwdBck                                       CAP210
     C                   PARM                    DDDLNO_In                                    CAP210
     C                   PARM                    Buffer                                       CAP210
     C                   PARM                    FldNameArr                                   CAP210
     C                   PARM                    MsgIDArr                                     CAP210
     C                   PARM                    MsgDtaArr                                    CAP210
     C                   PARM                    MsgFArray                                    CAP210
     C                   PARM                    APIRetc                                      CAP210
      *                                                                                       CAP210
     C     TransTYPE     WHENEQ    'CTNM'                                                  AR1086546
     C     TransTYPE     OREQ      'CCTN'                                                  AR1086546
                                                                                           AR1086546
     C                   MOVEL     TransID       DDCUST_In                                 AR1086546
                                                                                           AR1086546
     C                   CALL      'SDCTNMR'                                               AR1086546
     C                   PARM                    AuthComp                                  AR1086546
     C                   PARM                    FwdBck                                    AR1086546
     C                   PARM                    DDCUST_In                                 AR1086546
     C                   PARM                    Buffer                                    AR1086546
     C                   PARM                    FldNameArr                                AR1086546
     C                   PARM                    MsgIDArr                                  AR1086546
     C                   PARM                    MsgDtaArr                                 AR1086546
     C                   PARM                    MsgFArray                                 AR1086546
     C                   PARM                    APIRetC                                   AR1086546
      *                                                                                    AR1086546
      ** Document Management Retrieval                                                        CSD093
                                                                                              CSD093
     C     TransTYPE     WHENEQ    'DCMT'                                                     CSD093
                                                                                              CSD093
     C                   EVAL      DDREFN_In = %SUBST(TransID:1:10)                           CSD093
     C                   EVAL      DDRTYP_In = %SUBST(TransID:11:1)                           CSD093
     C                   EVAL      DDCODE_In = %SUBST(TransID:12:2)                           CSD093
     C                   EVAL      DDSEQN_In = %SUBST(TransID:14:3)                           CSD093
                                                                                              CSD093
     C                   CALL      'SDDCMTR'                                                  CSD093
     C                   PARM                    DDREFN_In        10                          CSD093
     C                   PARM                    DDRTYP_In         1                          CSD093
     C                   PARM                    DDCODE_In         2                          CSD093
     C                   PARM                    DDSEQN_In         3                          CSD093
     C                   PARM                    Buffer                                       CSD093
     C                   PARM                    FldNameArr                                   CSD093
     C                   PARM                    MsgIDArr                                     CSD093
     C                   PARM                    MsgDtaArr                                    CSD093
     C                   PARM                    MsgFArray                                    CSD093
     C                   PARM                    APIRetC                                      CSD093
                                                                                              CSD093
      ** Account Review Retrievel                                                             CSD092
                                                                                              CSD092
     C     TransTYPE     WHENEQ    'ACRV'                                                     CSD092
                                                                                              CSD092
     C                   EVAL      DDARCU_In = %SUBST(TransID:1:6)                            CSD092
     C                   EVAL      DDARSD_In = %SUBST(TransID:7:6)                            CSD092
     C                   EVAL      DDARSQ_In = %SUBST(TransID:13:3)                           CSD092
                                                                                              CSD092
     C                   CALL      'SDACRVR'                                                  CSD092
     C                   PARM                    DDARCU_In         6                          CSD092
     C                   PARM                    DDARSD_In         6                          CSD092
     C                   PARM                    DDARSQ_In         3                          CSD092
     C                   PARM                    Buffer                                       CSD092
     C                   PARM                    FldNameArr                                   CSD092
     C                   PARM                    MsgIDArr                                     CSD092
     C                   PARM                    MsgDtaArr                                    CSD092
     C                   PARM                    MsgFArray                                    CSD092
     C                   PARM                    APIRetC                                      CSD092
                                                                                              CSD092
      * Nostro Transfers                                                                      CAP212
                                                                                              CAP212
     C     TransTYPE     WHENEQ    'FTNT'                                                     CAP212
                                                                                              CAP212
     C                   MOVEL     TransID       DDPREF_In                                    CAP212
     C     1             SUBST     TransID:19    DDACTN_In                                    CAP212
                                                                                              CAP212
     C                   CALL      'FTFTNTR'                                                  CAP212
     C                   PARM                    AuthComp                                     CAP212
     C                   PARM                    FwdBck                                       CAP212
     C                   PARM                    DDPREF_In                                    CAP212
     C                   PARM                    DDACTN_In                                    CAP212
     C                   PARM                    Buffer                                       CAP212
     C                   PARM                    FldNameArr                                   CAP212
     C                   PARM                    MsgIDArr                                     CAP212
     C                   PARM                    MsgDtaArr                                    CAP212
     C                   PARM                    MsgFArray                                    CAP212
     C                   PARM                    APIRetC                                      CAP212
                                                                                              CAP212
      * If unknown API requested, make sure this is reported back
     C                   OTHER
     C                   EXSR      *PSSR
 
     C                   ENDSL
 
     C                   ENDSR
      ****************************************************************
      /SPACE 5
      ****************************************************************
      * Edit the Messages for output
      ****************************************************************
     C     EDTMSGS       BEGSR
                                                                                            AR885527
     C                   EVAL      APINam = TransType                                       AR885527
     C                   CALLB     'APEDTMSGS'
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    MsgArrOUT
     C                   PARM                    APINam                                     AR885527
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      * *PSSR - Program exception error routine                       *
      *                                                               *
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, excluding a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   EVAL      APIRetC = '0'
     C                   RETURN
     C                   ENDSR
      ****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
