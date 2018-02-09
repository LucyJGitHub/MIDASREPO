     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Trad risk weighted assets allocation')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading                                   *
      *                                                               *
      *  SE001302 - Securities Trading Risk Weighted Assets           *
      *             Allocation Program                                *
      *                                                               *
      *  Function:  This module will acces the RWA weightings for the *
      *             securities and call a program to calculate the    *
      *             Risk Weighted Balance for the securities.         *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CGL018  *CREATE    Date 10Oct02               *
      *                 XXXXXX             Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL018 - Risk Weighted Assets                                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of indicator                           *
      *                                                               *
      *    01         EOF for SESRWAL1                                *
      *    02         EOF for SDRWACL1                                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      **
     FSESRWAL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(CR)
     FSDRWACL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(PW)
     FSERWARPD  O    E           K DISK
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
 
 
 
      ** +-----------------------------------------------------------------+
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      ** +-----------------------------------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
 
      ** Data area for message file to use
     D ZADFMF        E DS                  EXTNAME(Y2MGFLA)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
     C                   EXSR      MAIN
 
     C                   EVAL      *INLR = *ON
 
      **********************************************************************
 
      /EJECT
      *****************************************************************
      *                                                               *
      * MAIN - Main Processing                                        *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     MAIN          BEGSR
 
     C                   EXSR      GETSECTREF
 
     C                   EXSR      CALCPGM
 
     C                   EXSR      RETURNEDVAL
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * GETSECTREF - Retrieve Security Weighted Percentage            *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     GETSECTREF    BEGSR
      *
      **  Using the passed security and set number, get the RWA Code in
      **  Security Risk Weighted Assets Codes File
      *
     C     KSRREC        CHAIN     SESRWAL1                           01
 
     C     *IN01         IFEQ      '0'
     C                   MOVE      CRRWCODE      TempCode
     C                   ENDIF
      *
      **  If the security does not have a RWA record for the set number, use
      **  the default RWA code to read the Risk Weighted Assets Codes file.
      **  (default RWA Code is *Blanks)
      *
     C     TempCode      IFEQ      *BLANKS
     C     *IN01         OREQ      '1'
     C                   MOVE      *BLANKS       WWSRWACode
     C                   MOVE      *BLANKS       SectRWACode
     C                   MOVE      WWSetNum      WWSRWSetNum
     C                   ELSE
     C                   MOVE      TempCode      WWSRWACode
     C                   MOVE      TempCode      SectRWACode
     C                   MOVE      WWSetNum      WWSRWSetNum
     C                   ENDIF
     C                   MOVE      *BLANKS       TempCode
 
     C                   EXSR      GETPERCENT
     C                   Z-ADD     TempPWtg      WPSectPWtg
     C                   MOVEL     TempPWtg      WWSectPWtg
 
     C                   Z-ADD     *ZERO         TempPWtg
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * GETPERCENT - Retrieve the Percentage Weighting of this RWA    *
      *              code and set for this security                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     GETPERCENT    BEGSR
      *
      **  Access SDRWACL1
      *
     C     KRWREC        CHAIN     SDRWACL1                           02
 
     C     *IN02         IFEQ      '0'
     C                   Z-ADD     PWRWRWAP      TempPWtg
     C                   ENDIF
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * CALCPGM - Call Calculation Program                            *
      *                                                               *
      * Calls: AOSREFR0, ZA001241                                     *
      *                                                               *
      *****************************************************************
 
     C     CALCPGM       BEGSR
      *
      ** Clear variables for the next call
      *
     C                   MOVEL     *BLANKS       P@RTCD
     C                   MOVEL     *BLANKS       P@OP01
     C                   MOVEL     *BLANKS       P@VL01
      *
      ** To find out which calculation program to call, concatenate the
      ** calling program to make one field, this will be the second parm
      ** in calling AOSREFR0.
      *
     C                   EVAL      P@OP01 = 'RiskWeightAssetSE' + WWCalcMet
 
     C                   CALLB     'AOSREFR0'
     C                   PARM                    P@RTCD            7
     C                   PARM                    P@OP01           30
     C                   PARM                    P@VL01          200
     C                   PARM                    P@OP02           30
     C                   PARM                    P@VL02          200
     C                   PARM                    P@OP03           30
     C                   PARM                    P@VL03          200
     C                   PARM                    P@OP04           30
     C                   PARM                    P@VL04          200
     C                   PARM                    P@OP05           30
     C                   PARM                    P@VL05          200
     C                   PARM                    P@OP06           30
     C                   PARM                    P@VL06          200
     C                   PARM                    P@OP07           30
     C                   PARM                    P@VL07          200
     C                   PARM                    P@OP08           30
     C                   PARM                    P@VL08          200
     C                   PARM                    P@OP09           30
     C                   PARM                    P@VL09          200
     C                   PARM                    P@OP10           30
     C                   PARM                    P@VL10          200
 
     C     P@RTCD        IFNE      *BLANKS
     C                   MOVEL     'USR1241'     WMSGI
     C                   MOVEL     'SDUSRMSG'    WMSGF
     C                   EXSR      SRMSGF
     C                   ENDIF
 
      *
      ** If Return Code is blank, call the program returned from third parm
      *
     C     P@RTCD        IFEQ      *BLANKS
 
     C                   EVAL      NCalcPgm = P@VL01
 
     C                   CALL      NCalcPgm
     C                   PARM                    WWAsetBal
     C                   PARM                    WPSectPWtg
     C                   PARM                    RetRiskWB
 
     C                   Eval      WWRiskWABal = RetRiskWB
 
     C                   ENDIF
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * RETURNEDVAL - Check the returned values from the calculation  *
      *               program.  If not equal to zeroes, output to file*
      *               for reporting purposes.                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     RETURNEDVAL   BEGSR
      *
      **  Check Interim RWA Balance for the Security
      *
     C                   EXSR      OUTSECT
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * OUTSECT - Output details to GLRWARL0 for this security        *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     OUTSECT       BEGSR
      *
      ** Calculate the Interim RWA Balance Adjusted Amount
      *
     C                   EVAL (H)  TmpAdjA = (WPSectPWtg * WWAsetBal) / 100
      *
      ** Set up values for output to file
      *
     C                   EVAL      RWRECI = 'D'
     C                   EVAL      RWMOD = 'SE'
     C                   EVAL      RWSETN = WWSetNum
     C                   EVAL      RWTRAN = WWSecBrca + WWSecBook
     C                                      + WWSecMrkt + WWSecRef
     C                   EVAL      RWAMNT = WWAsetBal
     C                   EVAL      RWCCY = WWSecCcy
     C                   EVAL      RWWSRC = 'SECURITY'
     C                   EVAL      RWCODE = SectRWACode
     C                   EVAL      RWPERC = WPSectPWtg
     C                   EVAL      RWIAMT = WWAsetBal
     C                   EVAL      RWADJA = TmpAdjA
     C                   EVAL      RWABAL = RetRiskWB
     C                   EVAL      RWCCCY = *blanks
     C                   EVAL      RWCREF = *blanks
 
      ** Write to file
     C                   WRITE     SERWARP0
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMSGF - Message Handling Subroutine                          *
      *                                                               *
      * Called by: CALCPGM                                            *
      *                                                               *
      * Calls    : ZA0340                                             *
      *                                                               *
      *****************************************************************
      *
     C     SRMSGF        BEGSR
      *
     C     WMSGF         IFEQ      *BLANKS
     C                   MOVE      ZADFMF        WMSGF
     C                   ENDIF
      *
     C                   CALL      'ZA0340'
     C                   PARM                    WMSGF
     C                   PARM                    WMSGI
 
     C                   MOVE      *BLANKS       WMSGF
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
     C                   PARM                    WWSecRef
     C                   PARM                    WWSecBrca         3
     C                   PARM                    WWSecBook         2
     C                   PARM                    WWSecMrkt         1
     C                   PARM                    WWSecCcy          3
     C                   PARM                    WWAsetBal
     C                   PARM                    WWSetNum
     C                   PARM                    WWCalcMet
     C                   PARM                    WWRiskWABal
 
     C     *LIKE         DEFINE    CRRWSESN      WWSecRef
     C     *LIKE         DEFINE    CRRWSETN      WWSetNum
     C     *LIKE         DEFINE    CRRWCHTP      WWCalcMet
     C     *LIKE         DEFINE    CRRWCODE      WWSRWACode
     C     *LIKE         DEFINE    CRRWCODE      TempCode
     C     *LIKE         DEFINE    CRRWSETN      WWSRWSetNum
     C     *LIKE         DEFINE    PWRWRWAP      TempPWtg
     C     *LIKE         DEFINE    WWRiskWABal   WWAsetBal
 
     C                   Z-ADD     *ZERO         WPSectPWtg        5 2
     C                   Z-ADD     *ZERO         TmpAdjA          15 0
     C                   Z-ADD     *ZERO         WWRiskWABal      15 0
     C                   MOVE      *BLANKS       NCalcPgm         10
     C                   MOVE      *BLANKS       SectRWACode       2
     C                   MOVE      *BLANKS       WMSGI            10
     C                   MOVE      *BLANKS       WMSGF            10
     C                   MOVE      *BLANKS       WWSectPWtg        5
     C                   Z-ADD     *ZERO         RetRiskWB        15 0
 
     C     KSRREC        KLIST
     C                   KFLD                    WWSecRef
     C                   KFLD                    WWSetNum
 
     C     KRWREC        KLIST
     C                   KFLD                    WWSRWACode
     C                   KFLD                    WWSRWSetNum
 
     C                   ENDSR
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
