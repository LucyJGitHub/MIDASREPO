     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Validate short term rate')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Validate Short Term Rate                             *
      *                                                               *
      *  IRVSTERMRT                                                   *
      *                                                               *
      *  Function:  This module validates the short term rate, and    *
      *             returns a blank indicator if there are no errors, *
      *             else it returns 'Error'.                          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD033488           Date 11Mar15               *
      *                 245692             Date 10Dec13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11457           Date 11May06               *
      *                 BUG7659            Date 23Jun05               *
      *                 BUG6472            Date 20Apr05               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP055             Date 13Mar02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CIR007             Date 11May01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CIR005             Date 21Jan00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP003  *CREATE    Date 01Feb98               *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD033488 - Allow negative rates. Use program ZA0841 instead  *
      *             ZA0840. To accept a '-' sign to indicate input    *
      *             amount is negative.                               *
      *  245692 - Incorrect validation of rates when the decimal se-  *
      *           parator in the Dealing ICD was defined as "," ins-  *
      *           tead of ".".                                        *
      *  BUG11457-Transaction ccy is not passed by callers            *
      *  BUG7659- Validate short term rate when there are warning     *
      *           errors on the value date                            *
      *  BUG6472- Added a sign field for short term rate              *
      *  CAP055 - APIs for FRA/IRS Caps/Collars/Floors                *
      *  CIR007 - Overnight Index Swaps                               *
      *  CIR005 - FRA/IRS Business Day Conventions.                   *
      *  CAP003 - Conversion of IR inputs into modular structure to   *
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
                                                                                CIR005
      ** External data extructure for SAR details                               CIR005
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CIR005
                                                                                CIR005
      ** External data extructure used by access objects                        CIR005
     D DSFDY         E DS                  EXTNAME(DSFDY)                       CIR005
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **Holiday Check indicator passed from ZCHKH
     D   ZIND          S              1A
      ** Valid Rate fix days passed as a parameter from calling program
     D  UFRFDX         S              2S 0                                      (TFRFDX+URFDFX)
      **Valid date indicator passed as a parameter
     D   VDATXok       S              1A
 
      **Valid Currency indicator passed as a parameter
     D   SUCUCYok      S              1A
 
      **Valid Floating Rate Fix Days indicator passed as parameter
     D   SUFRFDok      S              1A
 
      **Valid Base Rate type indicator passed as a parameter
     D   SUBRTTok      S              1A
 
      **Day number for holiday passed as parameter
     D   ZDAYNO        S              5P 0
 
      *Error message to be handed back as a parameter
     D   Msgid1        S                   LIKE(#Msgid)
 
      **Rate fix days used by DLBACK
     D    ZRFDY        S              5  0
 
      **Valid Value date passed as a parameter
     D   VDATX         S              5  0
 
      **'Currency for rate fix holiday' flag from FRA/IRS I.C.D. passed as parameter
     D   BQCRFH        S              1A
 
      **Currency field for DLBACK
     D   ZCCY          S              3A
 
      **Location Code for DLBACK
     D   ZLOC          S              3A
 
      **Valid value date for DLBACK
     D   ZINDT         S              5  0
 
      **Rate Fix Date field for DLBACK
     D   ZRFDT         S              5  0
 
      **Work Field for DLBACK
     D   ZWKFLD        S              5  0
 
      **ZALIGN indicator passed back from ZALIGN as parameter
     D   ZALIGNok      S              1A
 
      **Rate fix days passed as a parameter
     D   ZFIELD        S             16A
 
      **Length of Decimal field passed to ZALIGN as parameter
     D ZADEC           S              1  0
 
      **Length of digital field passed as a parameter to ZALIGN
     D ZADIG           S              2  0
 
      **Runday number passed as a parameter
     D BJRDNB          S              5  0
 
      **Currency code passed to program as parameter
     D BLCYCD          S              3A
 
      **Short term rate
     D SUEINR          S             12A
 
      **Base Rate Code
     D SUBRTT          S              2A
 
      **System Location code passed as a parameter
     D BJSLCD          S              3A
 
      **Currency field passed as a parameter from calling program
     D SUCUCY          S              3A
 
      **Local currency code passed to program as parameter
     D BJLCCY          S              3A
                                                                                CIR005
      ** Validate Business Day Convention flag                                  CIR005
     D  WValBDC        S              1A                                        CIR005
                                                                                CIR005
      ** Mode of operation received from controller                             CIR005
     D ModeOfOp        S              6A                                        CIR005
                                                                                CIR005
      ** Currencies for Rate Fixing Conventions Leg1                            CIR005
     D  PRateCur       S             30A                                        CIR005
 
      ** Rate Change Frequency Code                                                           CIR007
     DPRAtChgFq        S              1A                                                      CIR007
                                                                                              CIR007
      ** Deal Type used as Parameter                                                          CIR007
     DPDealTyp         S              2A                                                      CIR007
                                                                                              CIR007
      ** OVERNIGHT INDEX SWAPS                                                                CIR007
     DCIR007           S              1A                                                      CIR007
                                                                                              CAP055
      ** Average Rate Method                                                                  CAP055
     D SAVRAM          S              1A                                                      CAP055
                                                                                              CAP055
                                                                                              245692
      ** Decimal separator                                                                    245692
     D BNDCSP          S              1A                                                      245692
                                                                                              245692
      ***Parameter*list*for*ZA0840*************************************              245692 MD033488
      ** Parameter list for ZA0841                                                          MD033488
      ** =========================                                                            245692
      ** Return code for numeric validation module call                                       245692
     D @Rtcde          S             10A                                                      245692
      ** Alpha field for numeric validation                                                   245692
     D @@ALPH          S             16A                                                      245692
      ** Number of decimal places field for numeric validation                                245692
     D @@IDP           S              2  0                                                    245692
      ** Number of integers field for numeric validation                                      245692
     D @@IINT          S              2  0                                                    245692
      ** Millions/Thousands id (Y=function on)                                                245692
     D @@MTID          S              1A                                                      245692
      ** Amount calculation field                                                             245692
     D @@AMT           S             15  0                                                    245692
      ***Error*return*code*for*ZA0840*module***************************              245692 MD033488
      ** Error return code for ZA0841 module                                                MD033488
     D @@ERCD          S              1  0                                                    245692
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
     C                   RESET                   Msgid1
 
      ** Validate Our Short Term Rate using ZALIGN and DLBACK
 
     C                   Z-ADD     0             UEINRX           11 7
     C                   Z-ADD     0             @@AMT                                        245692
     C                   Z-ADD     0             @@ERCD                                       245692
     C     SUEINR        IFEQ      *BLANKS
     C     SUBRTT        IFNE      *BLANKS
     C*****VDATXok       ANDEQ     'Y'                                                       BUG7659
     C     VDATXok       ANDNE     'N'                                                       BUG7659
     C     SUCUCYok      ANDEQ     'Y'
     C     SUFRFDok      ANDEQ     'Y'
     C     SUBRTTok      ANDEQ     'Y'
     C                   Z-ADD     VDATX         ZINDT
     C                   Z-ADD     UFRFDX        ZRFDY
 
      ** If 'currency for rate fix holiday' flag from FRA/IRS I.C.D.
      ** is 'F', 'L' or 'D', set currency code to 'sterling code',
      ** 'local currency code' or 'screen currency code' respectively
 
     C     BQCRFH        IFEQ      'F'
     C                   MOVE      BLCYCD        ZCCY
     C                   ENDIF
 
     C     BQCRFH        IFEQ      'L'
     C                   MOVE      BJLCCY        ZCCY
     C                   ENDIF
 
     C     BQCRFH        IFEQ      'D'
     C     BQCRFH        OREQ      ' '
     C                   MOVE      SUCUCY        ZCCY
     C                   ENDIF
     C
     C                   MOVE      *BLANKS       ZLOC
                                                                                CIR005
      ** Calculate rate fix date using DLBACK if one of the following           CIR005
      ** conditions is satisfied:                                               CIR005
      ** 1) Business Day Convention enhancement is switched off.                CIR005
      ** 2) Business Day Convention enhancement is switched on AND              CIR005
      **    Validate Business Day Flag is set to 'Y' AND the first              CIR005
      **    Currency for Rate Fixing Convention is blank.                       CIR005
      ** 3) Module is called from the API CTL module.                           CIR005
                                                                                CIR005
     C                   IF        (CIR005 = 'N') Or ((CIR005 = 'Y') And        CIR005
     C                             (WValBDC = 'Y') And                          CIR005
     C                             (%SUBST(PRateCur:1:3) = *Blank))             CIR005
     C                             Or ((CIR005 = 'Y') And (ModeOfOp = '*FRONT') CIR005
     C                             And (%SUBST(PRateCur:1:3) = *Blank))         CIR005
     C                   EXSR      DLBACK
     C                   ENDIF                                                  CIR005
                                                                                CIR005
      ** Calculate rate fix date using Rate Fixing Conv. Currencies if          CIR005
      ** Business Day enhancement is switched on and the validate busi          CIR005
      ** ness day flag is set to 'Y' (second time screen validation)            CIR005
      ** and the 1st currency for Rate Fixing Conv. is not blank.               CIR005
                                                                                CIR005
     C                   IF        ((CIR005 = 'Y') And (WValBDC = 'Y') And      CIR005
     C                             (%SUBST(PRateCur:1:3) <> *Blank)) Or         CIR005
     C                             ((CIR005 = 'Y') And (ModeOfOp = '*FRONT')    CIR005
     C                             And (%SUBST(PRateCur:1:3) <> *Blank))        CIR005
     C                   Z-ADD     ZRFDY         WRFDY             2 0          CIR005
                                                                                CIR005
     C                   CALLB     'IRRTFXCNV'                                  CIR005
     C                   PARM                    ZINDT                          CIR005
     C                   PARM                    WRFDY                          CIR005
     C                   PARM      *Blank        ZLOC                           CIR005
     C                   PARM                    PRateCur                       CIR005
     C                   PARM                    ZRFDT                          CIR005
                                                                                CIR005
     C                   ENDIF                                                  CIR005
                                                                                CIR005
     C     ZRFDT         IFLT      BJRDNB
     C     CIR005        ANDEQ     'N'                                          CIR005
     C     CIR005        OREQ      'Y'                                          CIR005
     C     ZRFDT         ANDLT     BJRDNB                                       CIR005
     C     WValBDC       ANDEQ     'Y'                                          CIR005
     C                   MOVE      'MMA0032'     Msgid1
     C                   MOVE      'Y'           ErrorFound
     C                   END
     C                   END
     C                   ELSE
     C     SUBRTT        IFEQ      *BLANKS
     C                   MOVE      'MMA0033'     Msgid1
     C                   MOVE      'Y'           ErrorFound
     C                   ELSE
     C**********         MOVE      *BLANKS       ZFIELD                                       245692
     C**********         MOVE      SUEINR        ZFIELD                                       245692
     C**********         Z-ADD     7             ZADEC                                        245692
     C**********         Z-ADD     4             ZADIG                                        245692
     C                   MOVE      *BLANKS       @@ALPH                                       245692
     C                   MOVE      SUEINR        @@ALPH                                       245692
     C                   Z-ADD     7             @@IDP                                        245692
     C                   Z-ADD     4             @@IINT                                       245692
     C                   MOVE      'N'           @@MTID                                       245692
     C                   MOVE      'N'           ZAOPT             1
     C**********         CALLB     'ZALIGN'                                                   245692
     C**********         PARM                    ZALIGNok                                     245692
     C**********         PARM                    ZFIELD                                       245692
     C**********         PARM                    ZADEC                                        245692
     C**********         PARM                    ZADIG                                        245692
     C**********         CALLB     'ZA0840'                                          245692 MD033488
     C                   CALLB     'ZA0841'                                                 MD033488
     C                   PARM                    @Rtcde                                       245692
     C                   PARM                    @@ALPH                                       245692
     C                   PARM                    @@IDP                                        245692
     C                   PARM                    @@IINT                                       245692
     C                   PARM                    @@MTID                                       245692
     C                   PARM                    @@ERCD                                       245692
     C                   PARM                    @@AMT                                        245692
     C                   PARM                    BNDCSP                                       245692
 
     C*****ZALIGNok      IFEQ      'N'                                                        245692
     C     @@ERCD        IFNE      0                                                          245692
     C                   MOVE      'MMA0034'     Msgid1
     C                   MOVE      'Y'           ErrorFound
     C                   MOVE      'Y'           ZALIGNok
     C                   ELSE
      *                                                                                      BUG6472
      ** Sign must be '+' or '-'                                                             BUG6472
      *                                                                                      BUG6472
     C     SUSSGN        IFEQ      ' '                                                       BUG6472
     C                   MOVE      '+'           SUSSGN                                      BUG6472
     C                   ENDIF                                                               BUG6472
      *                                                                                      BUG6472
     C     SUSSGN        IFNE      '+'                                                       BUG6472
     C     SUSSGN        ANDNE     '-'                                                       BUG6472
     C                   MOVE      'MMA0035'     Msgid1                                      BUG6472
     C                   MOVE      'Y'           ErrorFound                                  BUG6472
      *                                                                                      BUG6472
     C                   ELSE                                                                BUG6472
     C**********         MOVE      ZFIELD        UEINRX                                       245692
     C                   MOVE      @@AMT         UEINRX                                       245692
      *                                                                                      BUG6472
     C     SUSSGN        IFEQ      '-'                                                       BUG6472
     C                   MULT      -1            UEINRX                                      BUG6472
     C                   ENDIF                                                               BUG6472
      *                                                                                      BUG6472
     C                   ENDIF                                                               BUG6472
     C                   END
     C                   END
     C                   END
                                                                                              CIR007
      ** If CIR007 is on , Deal Type is 'RS' and Rate Change Frequency                        CIR007
      ** Code is 'O' and the deal is "Back-Valued", a Short Term Rate                         CIR007
      ** must be entered and must not be equal to zero.                                       CIR007
                                                                                              CIR007
     C                   IF        ErrorFound <> 'Y'                                          CIR007
                                                                                              CIR007
     C                   IF        CIR007 = 'Y' AND PDealTyp = 'RS'                           CIR007
     C                             AND PRatChgFq = 'O' AND VDATX < BJRDNB                     CIR007
                                                                                              CIR007
     C                   IF        SUEINR = *BLANKS OR UEINRX = 0                             CIR007
     C                   MOVE      'Y'           ErrorFound                                   CIR007
     C                   MOVE      'MMA1180'     Msgid1                                       CIR007
     C                   ENDIF                                                                CIR007
                                                                                              CIR007
     C                   ENDIF                                                                CIR007
                                                                                              CIR007
     C                   ENDIF                                                                CIR007
 
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
     C                   RETURN
      *****************************************************************
     C*   SR: DLBACK - TO CALCULATE RATE FIX DATE FOR FRA/IRS         *
     C*****************************************************************
     C     DLBACK        BEGSR                                                  ** DLBACK **
     C*
     C* INPUT FIELD ZLOC CONTAINS THE RELEVANT BRANCH LOCATION
     C*
     C**  Initialise Work Field
     C                   Z-ADD     ZINDT         ZINDT             5 0
     C                   Z-ADD     ZRFDY         ZRFDY             5 0
     C                   MOVE      ZCCY          ZCCY              3
     C                   Z-ADD     0             ZWKFLD            5 0
     C                   MOVE      ZLOC          ZLOC              3
 
     C**  Set Rate Fix Date equal to Input Date
     C                   Z-ADD     ZINDT         ZRFDT             5 0
 
     C**  Perform the following processing until the work field is
     C**  greater than or equal to the Rate Fix Days
     C     ZWKFLD        DOUGE     ZRFDY
 
     C**  If the Rate Fix Days are not equal to zero subtract 1
     C**  from the Rate Fix Date
     C     ZRFDY         IFNE      0
     C                   SUB       1             ZRFDT
     C                   END
     C*   The following is repeated until the resultant date is
     C*   proved to be a working day in the relevant currency and
     C*   location.
     C*   Uses ZCHKH to check Rate Fix Date for a holiday
 
     C     ZIND          DOUEQ     'W'
 
     C                   Z-ADD     ZRFDT         ZDAYNO
     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJLCCY
     C                   PARM                    BJSLCD
     C                   PARM                    ZIND
 
     C* If date is a holiday (ZIND = 'H')
     C* subtract 1 from rate fix date
 
     C     ZIND          IFEQ      'H'
     C                   SUB       1             ZRFDT
     C                   END
     C                   END
 
     C**  When a working day has been found, add 1 to the Work Field
 
     C                   ADD       1             ZWKFLD
     C                   END
 
     C                   ENDSR
 
 
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
     C                   PARM                    RetCodeIn
     C                   PARM                    Msgid1
     C                   PARM                    VDATXok
     C                   PARM                    SUCUCYok
     C                   PARM                    SUFRFDok
     C                   PARM                    SUBRTTok
     C                   PARM                    VDATX
     C                   PARM                    BJLCCY
     C                   PARM                    BLCYCD
     C                   PARM                    BQCRFH
     C                   PARM                    BJSLCD
     C                   PARM                    BJRDNB
     C                   PARM                    SUEINR
     C                   PARM                    SUBRTT
     C                   PARM                    UFRFDX
     C                   PARM                    UEINRX
     C                   PARM                    ModeOfOp                       CIR005
     C                   PARM                    WValBDC                        CIR005
     C                   PARM                    PRateCur                       CIR005
     C                   PARM                    PRatChgFq                                    CIR007
     C                   PARM                    PDealTyp                                     CIR007
     C                   PARM                    CIR007                                       CIR007
     C                   PARM                    SAVRAM                                       CAP055
     C                   PARM                    SUSSGN            1                         BUG6472
     C                   PARM                    BNDCSP                                       245692
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
(c) Finastra International Limited 2001
