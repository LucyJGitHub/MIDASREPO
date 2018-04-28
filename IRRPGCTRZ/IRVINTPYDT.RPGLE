     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Validate interest payment date')              *
      *****************************************************************
      *                                                               *
      *  Midas - IRS Validation Module                                *
      *                                                               *
      *  IRVINTPYDT - IRS Validate Interest payment date              *
      *                                                               *
      *  Function:  This module accepts a parameter containing the    *
      *             Interest payment date and confirms whether it has *
      *             a valid value. If it is valid the 10A return code *
      *             will be blank; if it is not it will contain       *
      *             'Error'                                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD000091           Date 08May13               *
      *  Prev Amend No. AR702741           Date 02Feb11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CIR005             Date 21Jan00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 167511             Date 14Sep99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP003  *CREATE    Date 01Feb98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD000091 - Event Codes Substitution                          *
      *  AR702741 - Include location as parameter in ZFREQB to        *
      *             determine the next settlement date                *
      *             (Child: AR702742)                                 *
      *  CIR005 - FRA/IRS Business Day Conventions.                   *
      *  167511 - FRA/IRS functions fail if dates contain invalid data*
      *  CAP003 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
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
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Data structure containing general ledger deatails
     D  SDGELR       E DS                  EXTNAME(SDGELRPD)
                                                                                CIR005
      ** Data structure containing Bank deatails                                CIR005
     D  SDBANK       E DS                  EXTNAME(SDBANKPD)                    CIR005
 
      ** External data extructure for SAR details                               CIR005
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CIR005
                                                                                CIR005
      ** External data extructure used by access objects                        CIR005
     D DSFDY         E DS                  EXTNAME(DSFDY)                       CIR005
                                                                                CIR005
      ** Internally described data structure for ZADATE
     D DateDS          DS             6
     D  DteMth                 1      2A
     D  DteDay                 3      4A
     D  DteYr                  5      6A
                                                                                CIR005
      ***Holiday*currency array for payment conventions                              CIR005 MD000091
     D*HolCurrArr******S              4A   DIM(10)                                   CIR005 MD000091
      ** Holiday currency array for payment conventions                                     MD000091
     D TmpCcyArr       S              5A   DIM(10)                                          MD000091
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** Valid rate change date passed to module from calling program
     D  UNICDX         S              5  0
 
      ** Average rate method switch passed to module from calling program
     D  SAVRAM         S              1A
 
      ** Rate fix frequency day in month passed as parameter to module
     D  TICFDX         S              2S 0
 
      ** Rate change frequency passed to module from calling program
     D  SRICFR         S              1A
 
      ** Currency passed to module  from calling program
     D  SUCUCY         S              3A
 
      ** Interest payment date sent as a parameter from calling program
     D  STNIPD         S              6A
 
      ** Valid Value Date passed as a parameter from calling program
     D  VDATX          S              5  0
 
      ** Valid Maturity date passed as a parameter from calling program
     D  MDATX          S              5  0
 
      ** Valid maturity date indicator passed as a parameter from calling program
     D  MDATXok        S              1A
 
      ** Rate change frequency indicator passed to program as parameter
     D  SRICFRok       S              1A
 
      ** Rate chnage date indicator passed as parameter from calling program
     D  STNICDok       S              1A
 
      **Rate change day in month indicator passed as parameter from calling program
     D  TICFDXok       S              1A
 
      ** Valid value date indicator passed as a parameter from calling program
     D  VDATXok        S              1A
                                                                                CIR005
      ** Index for arrays of warning messages                                   CIR005
     D WI              S              3P 0                                      CIR005
                                                                                CIR005
      ** Validate Business Day Convention flag                                  CIR005
     D  WValBDC        S              1A                                        CIR005
                                                                                CIR005
      ** Mode of operation received from controller                             CIR005
     D ModeOfOp        S              6A                                        CIR005
                                                                                CIR005
      ** Error Flag passed back from ZCHKH to module                            CIR005
     D WHolInd         S              1A                                        CIR005
                                                                                CIR005
      ** Currencies for Payment Conventions Leg1                                CIR005
     D PPayCur         S             30A                                        CIR005
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Valid Interest Payment date passed back to calling program
     D  TNIPDX         S              5  0
 
      ** Interest payment date as Midas day number passed back from ZDATE1
     D  ZDAYNO         S              5  0
 
      ** Date format indicator passed to ZDATE1 as a parameter
     D***BJDFIN**       S              1A                                       CIR005
 
      ** Currency work field for called program ZFREQB
     D  ZCCY           S              3A
 
      ** Field containing rate change frequency passed as a parameter to ZFREQB
     D  ZFREQ          S              1A
 
      ** Day in month value passed as parameter from calling program
     D  ZDAYX          S              2  0
 
      **  Location code passed to ZFREQB as a parameter
     D  ZLOC           S              3A
 
      ** Rate frequency day in month passed as a parameter to ZFREQB
     D  ZMDAY          S              2  0
 
      ** Error flag passed back from ZDATE1
     D  ErrorFlag      S              1A
 
      ** Error message passed back to calling program
     D  Msgid1         S                   LIKE(#Msgid)
                                                                                CIR005
      ** Warning error message passed back to calling program                   CIR005
     D  WMsgId1        S                   LIKE(#Msgid)                         CIR005
                                                                                CIR005
      ** Warning message data to be passed back to the calling module           CIR005
     D  WMsgData       S                   LIKE(#MsgData)                       CIR005
                                                                                            MD000091
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   RESET                   ErrorFound
     C                   RESET                   WarnFound                      CIR005
     C                   RESET                   Msgid1
     C                   MOVE      'N'           Mistake
 
     C*******************RESET                   *IN84                          167511
 
 
     C                   Z-ADD     0             TNIPDX
     C     STNIPD        IFNE      *BLANKS
                                                                                167511
     C*******************TESTN                   STNIPD               84        167511
     C******IN84*********IFEQ      '1'                                          167511
                                                                                167511
     C                   TESTN                   STNIPD               9798      167511
     C     *IN97         IFEQ      '1'                                          167511
     C     *IN98         OREQ      '1'                                          167511
     C                   MOVE      'Y'           NUMok             1
     C                   ELSE
     C                   MOVE      'N'           NUMok
     C                   ENDIF
     C     NUMok         IFEQ      'Y'                                          167511
     C                   CALLB     'ZDATE1'
     C                   PARM                    STNIPD
     C                   PARM      *ZEROS        ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag
     C                   ENDIF                                                  167511
     C
      *
     C     NUMok         IFEQ      'N'
     C     ErrorFlag     OREQ      'Y'
     C                   MOVE      'Y'           ErrorFound
     C                   MOVE      'EMM0008'     Msgid1
     C                   MOVE      'Y'           MISTAKE           1
     C                   ELSE
      ** Cross check with Value Date/Maturity Date.
     C*****VDATXok       IFEQ      'Y'                                          167511
     C     VDATXok       IFNE      'N'                                          167511
     C     ZDAYNO        ANDLE     VDATX
     C*****MDATXok       OREQ      'Y'                                          167511
     C     MDATXok       ORNE      'N'                                          167511
     C     ZDAYNO        ANDGT     MDATX
     C                   MOVE      'Y'           ErrorFound
     C                   MOVE      'MMA0037'     Msgid1
     C                   MOVE      'Y'           MISTAKE
     C
     C                   END
     C                   END
      * Save valid dates.
     C     MISTAKE       IFEQ      'N'
     C                   Z-ADD     ZDAYNO        TNIPDX
     C                   MOVEL     STNIPD        DateDS
     C     BJDFIN        IFEQ      'M'
     C                   MOVE      DteDay        ZDAYX
     C                   ELSE
     C                   MOVE      DteMth        ZDAYX
     C                   ENDIF
     C                   END
      *
     C                   END
      *
     C     TNIPDX        IFNE      0
     C     SAVRAM        ANDEQ     'Y'
     C     STNICDok      ANDNE     'N'                                          167511
     C*****STNICDok      ANDEQ     'Y'                                          167511
      *
     C     UNICDX        IFEQ      0
     C*****MDATXok       ANDEQ     'Y'                                          167511
     C     MDATXok       ANDNE     'N'                                          167511
     C     TNIPDX        ANDNE     MDATX
     C                   MOVE      'Y'           ErrorFound
     C                   MOVE      'MMA0074'     Msgid1
     C                   MOVE      'Y'           MISTAKE
     C                   END
     C     MISTAKE       IFEQ      'N'
     C     UNICDX        ANDNE     0
      *
     C     TNIPDX        IFLT      UNICDX
     C                   MOVE      'Y'           Errorfound
     C                   MOVE      'MMA0074'     Msgid1
     C                   MOVE      'Y'           MISTAKE
     C                   END
      *
     C     MISTAKE       IFEQ      'N'
     C     UNICDX        ANDLT     TNIPDX
     C     SRICFRok      ANDNE     'N'                                          167511
     C     TICFDXok      ANDNE     'N'                                          167511
     C     MDATXok       ANDNE     'N'                                          167511
     C*****SRICFRok      ANDEQ     'Y'                                          167511
     C*****TICFDXok      ANDEQ     'Y'                                          167511
     C*****MDATXok       ANDEQ     'Y'                                          167511
     C*
     C     SRICFR        IFEQ      *BLANKS
     C                   Z-ADD     MDATX         ZDAYNO
     C                   ELSE
     C                   MOVE      SRICFR        ZFREQ
     C                   Z-ADD     UNICDX        ZDAYNO
     C                   Z-ADD     TICFDX        ZMDAY
     C                   MOVE      SUCUCY        ZCCY
     C                   MOVE      *BLANKS       ZLOC
      *
     C     ZDAYNO        DOWLT     TNIPDX
     C                   CALLB     'ZFREQB'
     C                   PARM                    RetCodeIn
     C                   PARM                    ZFREQ
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM                    ZLOC                                       AR702741
     C                   PARM                    ZMDAY
     C                   PARM                    BJDFIN
     C     SDGELR        PARM                    SDGELR
     C                   END
      *
     C                   END
      *
     C     ZDAYNO        IFNE      TNIPDX
      * Avoid exceeding size of error code array.
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMA0075'     Msgid1
     C                   MOVE      'Y'           MISTAKE
     C                   END
      *
     C                   END
     C                   END
     C                   END
      *
     C     MISTAKE       IFEQ      'Y'
     C                   Z-ADD     0             TNIPDX
     C                   END
                                                                                CIR005
      ** Validate interest payment date for Payment Convention currency if      CIR005
      ** Business Day enhancement is switched on and the validate busi          CIR005
      ** ness day flag is set to 'Y' (second time screen validation)            CIR005
      ** and the 1st currency for Payment Convention is not blank.              CIR005
                                                                                CIR005
     C                   IF        ((CIR005 = 'Y') And (WValBDC = 'Y')          CIR005
     C                             And (%SUBST(PPayCur:1:3) <> *Blank)) Or      CIR005
     C                             ((CIR005 = 'Y') And (ModeOfOp = '*FRONT')    CIR005
     C                             And (%SUBST(PPayCur:1:3) <> *Blank))         CIR005
                                                                                CIR005
     C                   IF        (STNIPD <> *Blank) And (MISTAKE = 'N')       CIR005
     C                   MOVE      'N'           WHolFnd           1            CIR005
     C                   MOVE      'N'           WarnFound                      CIR005
     C                   Z-ADD     1             H                 2 0          CIR005
     C                   Z-ADD     1             C                 2 0          CIR005
     C                   Z-ADD     1             S                 2 0          CIR005
     C                   Z-ADD     3             L                 2 0          CIR005
                                                                                CIR005
      ** Get first currency                                                     CIR005
                                                                                CIR005
     C     L             SUBST     PPayCur:S     ZCCY                           CIR005
                                                                                CIR005
     C     C             DOWLE     10                                           CIR005
     C     ZCCY          ANDNE     *Blank                                       CIR005
     C                   CALLB     'ZCHKH'                                      CIR005
     C                   PARM                    ZDAYNO                         CIR005
     C                   PARM                    ZCCY                           CIR005
     C                   PARM                    BJSLCD                         CIR005
     C                   PARM                    WHolInd                        CIR005
                                                                                CIR005
      ** Interest payment date is holiday in payment convention currency        CIR005
                                                                                CIR005
     C                   IF        WHolind = 'H'                                CIR005
     C**********         MOVEL     ZCCY          HolCurrArr(H)                  CIR005      MD000091
     C                   MOVEL     ZCCY          TmpCcyArr(H)                               MD000091
     C                   EVAL      BLen = %Len(%Trim(ZCCY))                                 MD000091
     C                   EVAL      TmpCcyArr(H) = LenStr +%TRIM(ZCCY)                       MD000091
     C                   EVAL      H = H + 1                                    CIR005
                                                                                CIR005
      ** Set holiday found indicator to 'Y'                                     CIR005
                                                                                CIR005
     C                   MOVE      'Y'           WHolFnd                        CIR005
     C                   ENDIF                                                  CIR005
                                                                                CIR005
      ** Get next currency                                                      CIR005
                                                                                CIR005
     C                   EVAL      C = C+1                                      CIR005
     C                   EVAL      S = S+3                                      CIR005
     C                   IF        (C < 10) Or (C = 10)                         CIR005
     C     L             SUBST     PPayCur:S     ZCCY                           CIR005
     C                   ENDIF                                                  CIR005
     C                   ENDDO                                                  CIR005
                                                                                CIR005
      ** Holiday is found in any of the currency..Warning message.              CIR005
                                                                                CIR005
     C                   IF        WHolFnd = 'Y'                                CIR005
     C                   EVAL      WarnFound    = 'Y'                           CIR005
     C                   EVAL      WMsgId1 = 'MMA1113'                          CIR005
     C                   EVAL      RetCodeIn = 'Error'                          CIR005
     C**********         MOVEA     HolCurrArr    WMsgData                            CIR005 MD000091
     C                   MOVEA     TmpCcyArr     WMsgData                                   MD000091
     C**********         MOVEL     *Blanks       HolCurrArr                          CIR005 MD000091
     C                   MOVEL     *Blanks       TmpCcyArr                                  MD000091
     C                   ENDIF                                                  CIR005
     C                   ENDIF                                                  CIR005
     C                   ENDIF                                                  CIR005
     C
     C*******************IF        ErrorFound = 'Y'                             167511
     C*******************EVAL      RetCodeIn = 'Error'                          167511
     C*******************ENDIF                                                  167511
 
      ** The return code is set in the following /COPY:                         167511
     C/COPY ZACPYSRC,SETRETCDE                                                  167511
 
     C                   RETURN
 
      *****************************************************************
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
     C                   PARM                    ReturnCode                     167511
     C*******************PARM                    RetCodeIn                      167511
     C                   PARM                    Msgid1
     C                   PARM                    STNIPD
     C                   PARM                    VDATX
     C                   PARM                    MDATX
     C                   PARM                    VDATXok
     C                   PARM                    MDATXok
     C                   PARM                    TNIPDX
     C***********        PARM                    BJDFIN                         CIR005
     C                   PARM                    UNICDX
     C                   PARM                    SAVRAM
     C                   PARM                    TICFDX
     C                   PARM                    SRICFR
     C                   PARM                    SUCUCY
     C                   PARM                    ZDAYX
     C                   PARM                    SRICFRok
     C                   PARM                    STNICDok
     C                   PARM                    TICFDXok
     C                   PARM                    ModeOfOp                       CIR005
     C                   PARM                    WValBDC                        CIR005
     C                   PARM                    PPayCur                        CIR005
     C                   PARM                    WMsgId1                        CIR005
     C                   PARM                    WMsgData                       CIR005
     C     SDGELR        PARM                    SDGELR
     C     SDBANK        PARM                    SDBANK                         CIR005
     C
                                                                                CIR005
      ** Access SAR details file to determine if FRA/IRS Business Day           CIR005
      ** Day Convention is switched on.                                         CIR005
                                                                                CIR005
     C                   CALL      'AOSARDR0'                                   CIR005
     C                   PARM      *BLANKS       @RTCD                          CIR005
     C                   PARM      '*VERIFY'     @OPTN                          CIR005
     C                   PARM      'CIR005'      @SARD                          CIR005
     C     SCSARD        PARM      SCSARD        DSFDY                          CIR005
                                                                                CIR005
     C                   IF        (@RTCD <> *BLANKS) And (@RTCD <> '*NRF   ')  CIR005
     C                   MOVEL     'SCSARDPD'    DBFILE                         CIR005
     C                   MOVEL     '001'         DBASE                          CIR005
     C                   MOVEL     'CIR005'      DBKEY                          CIR005
     C                   EXSR      *PSSR                                        CIR005
     C                   ENDIF                                                  CIR005
                                                                                CIR005
     C                   IF        @RTCD = *BLANKS                              CIR005
     C                   MOVEL     'Y'           CIR005            1            CIR005
     C                   ELSE                                                   CIR005
     C                   MOVEL     'N'           CIR005                         CIR005
     C                   ENDIF                                                  CIR005
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
