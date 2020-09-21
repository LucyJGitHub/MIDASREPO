     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate IBAN field')                         *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVIBAC   - Validate International Bank Account Number       *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD037025           Date 10Feb16               *
      *                 MD029037           Date 25Jul14               *
      *                 AR816838           Date 17Jul14               *
      *                 MD000091           Date 07May13               *
      *                 AR740293           Date 31Mar11               *
      *                 AR582286           Date 26Jul10               *
      *                 CER059             Date 19Jul10               *
      *                 CER045             Date 20Jul09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG17361           Date 04Apr08               *
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 07Jul06               *
      *                 238765             Date 30Jun06               *
      *                 224639             Date 06Jun06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 198980             Date 05Jul02               *
      *                 225488             Date 24Mar04               *
      *                 225015             Date 12Feb04               *
      *                 CGL029             Date 27Mar04               *
      *                 208237             Date 24Oct02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 193178             Date 11May01               *
      *                 193103             Date 10May01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP136             Date 15Nov99               *
      *                 175479             Date 17Feb00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CFT004  *CREATE    Date 05Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  MD037025 - Recompiled due to changes in INPAYIB              *
      *  MD029037 - Unable to close acount due to IBAN error          *
      *             Partially applied MD023875/AR467536               *
      *  AR816838 - Error message RE72034 during account opening.     *
      *             Amend program not to issue the error message when *
      *             action is 'I'nsert. (Child: AR816839)             *
      *           - Applied for CTI006                                *
      *  MD000091 - Event Codes Substitution                          *
      *  AR740293 - Error validating IBAN field (Child: AR740294)     *
      *  AR582286 - The system was not able to generate IBAN for      *
      *             the customer. Applied fix 206824.                 *
      *             Also reversed BUG17361                            *
      *  206824 - IBAN field not displayed and updated correctly      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER045 - German Features - Reporting Bundesbank (Recompile)  *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG17361 - Incorrect IBAN number written on Account          *
      *             maintenance                                       *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  238765 - Enhancement to 193178.  Do not use MANDATORY word   *
      *           on error message.                                   *
      *  224639 - Do Not allow IBAN to be amended if it is linked,    *
      *           to  an incoming payment. Upgrade core fix 183052 to *
      *           cater to API programs.                              *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  198980 - Manage IBAN field correctly.                        *
      *  225488 - IBAN number validated during amendment even if      *
      *           system generated during insert.                     *
      *           Added 1 line from 198980.                           *
      *  225015 - For error RE72025 include the correct associated    *
      *           field. MidasPlus will highlight the field in error. *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  208237 - System validates the IBAN code eventhough it was    *
      *           generated by the system, prohibiting the user to    *
      *           amend the details of the account. Need to reverse   *
      *           parts of fix 198980 and apply core fixes 193178 and *
      *           193103.                                             *
      *  193178 - For generation method 1 (do not generate as user    *
      *           will input the IBAN), make the IBAN field not       *
      *           mandatory. This is so that for internal accounts    *
      *           IBAN do not have to be input.                       *
      *           For retail accounts, a warning message will be      *
      *           given if the IBAN is not input.                     *
      *  193103 - Need to use correct fields to check if IBAN is not  *
      *           unique.                                             *
      *  CAP136 - Conversion of FT Incoming Payment inputs into       *
      *           modular structure to use as APIs.                   *
      *           Recompiled over changed PF/INPAYDD.                 *
      *  175479 - Recompiled over changes in INPAYDD                  *
      *  CFT004 - Straight Through Processing Phase 2                 *
      *         - International Bank Account Numbers                  *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FSDCTRYL2  IF   E           K DISK    INFSR(*PSSR)
     F
     FINPAYIB   IF   E           K DISK    INFSR(*PSSR)
     F
     FACCNTL6   IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(IB)
     F
     FACCNTL3   IF   E           K DISK    INFSR(*PSSR)                                       224639
     F                                     RENAME(ACCNTABF : ACCNTAX0)                        224639
     F                                     PREFIX(A1)                                         224639
     F
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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)
 
      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
      ** Array of Fields with warnings.
     D WFldNmXAr       S             10A   DIM(XArrayMax)
 
      ** Array of warning message IDs
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of warning message data.
     D WMsgDtXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
      *
      ** Decsripion of work fields
     DS5CNUM           S                   LIKE(IBCNUM)
     DS5ACOD           S                   LIKE(IBACOD)
     DS5ACSQ           S                   LIKE(IBACSQ)
     DS5ACNO           S                   LIKE(IBACNO)
     DS5BRCA           S                   LIKE(IBBRCA)
     DS5CCY            S                   LIKE(IBCCY)
 
     D*
     D** Data structure for AOIBANR6
     D*
     D**ACNT****         DS           485                                                     CGL029
     D ACNT            DS           491                                                       CGL029
     DS4CNUM                   2      7
     DS4CCY                    8     10
     D**S4ACOD**                11     14                                                     CGL029
     D**S4ACSQ**                15     16                                                     CGL029
     D**S4BRCA**                23     25                                                     CGL029
     D**S4ATYP**                26     26                                                     CGL029
     D**S4ACNO**               190    199                                                     CGL029
     D**S4IBAN**               449    482                                                     CGL029
     D**S4IBSQ**               483    485                                                     CGL029
     D S4ACOD                 11     20                                                       CGL029
     D S4ACSQ                 21     22                                                       CGL029
     D S4BRCA                 29     31                                                       CGL029
     D S4ATYP                 32     32                                                       CGL029
     D S4ACNO                196    205                                                       CGL029
     D S4IBAN                455    488                                                       CGL029
     D S4IBSQ                489    491                                                       CGL029
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** EXTERNAL DS FOR BRANCH DETAILS
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
      *                                                                                       193178
      ** Index for arrays of warning message ids, etc.                                        193178
     D WIx             S              3P 0                                                    193178
                                                                                              CGL029
     D DDACOD          S             10                                                       CGL029
 
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
                                                                                            MD000091
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
      *
      ** Remove blanks from IBAN field
     C     DDIBAN        IFNE      *BLANKS
     C                   CALLB     'AOIBANR3'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      DDIBAN        @IBAN            47
     C                   PARM                    @IWITH           47
     C                   PARM                    @INOBL           34
     C                   ENDIF
 
      ** Initialization
 
     C                   Eval      RetCodeIn = *Blanks
     C                   Eval      FldNamXAr = *Blanks
     C                   Eval      MsgIDXAr  = *Blanks
     C                   Eval      MsgDtaXAr = *Blanks
     C                   Eval      WFldNmXAr = *Blanks
     C                   Eval      WMsgIDXAr  = *Blanks
     C                   Eval      WMsgDtXAr = *Blanks
     C                   Eval      Idx = 0
     C                   Eval      WIx = 0                                                    193178
      *                                                                                       224639
      ** Set up the keylist to check for existence of account                                 224639
      *                                                                                       224639
     C                   MOVE      DDACOD        ACOD             10 0                        224639
     C**********         MOVE      DDCUSN        CNUM              6 0                        224639
     C                   MOVE      DDCUSN        CNUM              6                   224639 CSD031
     C                   MOVE      DDACSQ        ACSQ              2 0                        224639
      *                                                                                       224639
     C     CHKACC        KLIST                                                                224639
     C                   KFLD                    ACOD                                         224639
     C                   KFLD                    DDCCY                                        224639
     C                   KFLD                    CNUM                                         224639
     C                   KFLD                    ACSQ                                         224639
     C                   KFLD                    DDBRCA                                       224639
      *
      ** Retrieve Branch details for IBAN generation method
      *
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      DDBRCA        @BRCH             3
     C     SDBRCH        PARM      SDBRCH        DSSDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBRCHPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 901*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
      ** If IBAN generation method = ' ' IBAN field must be blank.
      *
     C     A8GENM        IfEq      *BLANKS
     C     DDIBAN        andne     *BLANKS
     C                   Move      'N'           DDIBANOk
     C                   Add       1             Idx
     C**********         Movel     'DDBRCA'      FldNamXAr(Idx)                               225015
     C                   Movel     'DDIBAN'      FldNamXAr(Idx)                               225015
     C                   Movel     'RE72025'     MsgIDXAr(Idx)
     C                   EndIf
      *
      *** If IBAN generation method is not equal to 1 and not blank,
      *** IBAN field must be blank as system will generate IBAN
      ****Do*not*generate*an*IBAN*if*any*of*the*account*details********            BUG17361 AR582286
      ****are*blank****************************************************            BUG17361 AR582286
      *
     C     A8GENM        Ifne      '1'
     C     A8GENM        Andne     *BLANKS
     C*****DDCUSN        Andne     *BLANKS                                         BUG17361 AR582286
     C*****DDCCY         Andne     *BLANKS                                         BUG17361 AR582286
     C*****DDACOD        Andne     *BLANKS                                         BUG17361 AR582286
     C*****DDACSQ        Andne     *BLANKS                                         BUG17361 AR582286
     C*****DDBRCA        Andne     *BLANKS                                         BUG17361 AR582286
     C*****DDATYP        Andne     *BLANKS                                         BUG17361 AR582286
     C*****DDACNO        Andne     *BLANKS                                         BUG17361 AR582286
     C     DDACTN        Andeq     'I'                                                      MD029037
      *                                                                                       198980
      * Check if IBAN is changed                                                              198980
      *                                                                                       198980
     C                   MOVEL     *BLANKS       ACNT                                         198980
     C                   MOVEL(P)  DDCUSN        S4CNUM                                       198980
     C                   MOVEL(P)  DDCCY         S4CCY                                        198980
     C                   MOVEL(P)  DDACOD        S4ACOD                                       198980
     C                   MOVEL(P)  DDACSQ        S4ACSQ                                       198980
     C                   MOVEL(P)  DDBRCA        S4BRCA                                       198980
     C                   MOVEL     DDATYP        S4ATYP                                       198980
     C                   MOVEL(P)  DDACNO        S4ACNO                                       198980
     C                   MOVEL     *BLANKS       S4IBAN                                       198980
     C                   MOVEL     *BLANKS       S4IBSQ                                       198980
      *                                                                                       198980
     C                   CALLB     'AOIBANR6'                                                 198980
     C                   PARM      *BLANKS       @RTCD                                        198980
     C     ACNT          PARM      ACNT          DSSDY                                        198980
      *                                                                                       198980
     C                   CALLB     'AOIBANR3'                                                 198980
     C                   PARM      *BLANKS       @RTCD             7                          198980
     C                   PARM      S4IBAN        @IBAN            47                          198980
     C                   PARM                    @IWITH           47                          198980
     C                   PARM                    @INOBL           34                          198980
      *
     C     DDIBAN        Ifne      *BLANKS
     C     DDIBAN        Andne     S4IBAN                                                     198980
     C*****DDACTN        Ifeq      'I'                                                        208237
     C**********         Move      'N'           DDIBANOk                                     208237
     C**********         Add       1             Idx                                          208237
     C**********         Movel     'DDIBAN'      FldNamXAr(Idx)                               208237
     C**********         Movel     'RE72020'     MsgIDXAr(Idx)                                208237
     C**********         Else                                                                 208237
     C     DDIBAN        Ifne      @IWITH
     C     DDIBAN        Andne     @INOBL                                                     225488
     C*****DDACTN        ANDEQ     'I'                                             AR740293 AR816838
     C     DDACTN        ANDNE     'I'                                                      AR816838
     C                   Move      'N'           DDIBANOk
     C                   Add       1             Idx
     C                   Movel     'DDIBAN'      FldNamXAr(Idx)
     C                   Movel     'RE72034'     MsgIDXAr(Idx)
     C                   Else
     C*
     C** If action code is not Insert, need to set screen field to
     C** the version of the IBAN without blanks.
     C*
     C*********          MOVEL     @INOBL        DDIBAN                                       206824
     C                   END
     C**********         END                                                                  208237
      *
     C                   ELSE
      *
     C                   MOVEL     *BLANKS       ACNT
     C                   MOVEL(P)  DDCUSN        S4CNUM
     C                   MOVEL(P)  DDCCY         S4CCY
     C                   MOVEL(P)  DDACOD        S4ACOD
     C                   MOVEL(P)  DDACSQ        S4ACSQ
     C                   MOVEL(P)  DDBRCA        S4BRCA
     C                   MOVEL     DDATYP        S4ATYP
     C                   MOVEL(P)  DDACNO        S4ACNO
     C                   MOVEL     *BLANKS       S4IBAN
     C                   MOVEL     *BLANKS       S4IBSQ
      *
     C                   CALLB     'AOIBANR6'
     C                   PARM      *BLANKS       @RTCD
     C     ACNT          PARM      ACNT          DSSDY
      *
     C                   SELECT
      *
      *** Maximum no. of unique IBAN sequences has been reached, error
      *
     C     @RTCD         WHENEQ    '*NOMORE'
     C                   Move      'N'           DDIBANOk
     C                   Add       1             Idx
     C                   Movel     'DDIBAN'      FldNamXAr(Idx)
     C                   Movel     'RE72021'     MsgIDXAr(Idx)
      *
     C     @RTCD         WHENEQ    '*GENMTH'
      *
      ** This is not an error for method 2, as do not generate IBANs
      ** for General Ledger accounts
      *
     C     A8GENM        Ifne      '2'
     C                   MOVE      *BLANKS       DDIBAN
     C***********        MoveL     'DDIBAN '     WFldNmXAr(1)                                 193178
     C***********        MoveL     'RE71068'     WMsgIDXAr(1)                                 193178
     C                   Add       1             WIx                                          193178
     C                   Movel     'DDIBAN'      WFldNmXAr(WIx)                               193178
     C                   Movel     'RE71068'     WMsgIdXAr(WIx)                               193178
     C                   EndIf
      *
     C     @RTCD         WHENEQ    '*UNIQUE'
     C                   Move      'N'           DDIBANOk
     C                   Add       1             Idx
     C                   Movel     'DDIBAN'      FldNamXAr(Idx)
     C                   Movel     'RE72029'     MsgIDXAr(Idx)
      *
     C     @RTCD         WHENEQ    *BLANKS
     C                   Eval      DDIBAN = S4IBAN
     C                   Eval      IBSEQN = S4IBSQ
      *
     C                   OTHER
     C                   MOVEL     'AOIBANR6'    DBFILE                         ************
     C                   MOVEL     '902'         DBASE                          * DBERR 902*
     C                   MOVEL     ACNT          DBKEY                          ************
     C                   EXSR      *PSSR
     C                   ENDSL
     C                   ENDIF
     C                   ENDIF
      *
      *** If IBAN generation method is equal to 1, validate IBAN field
      *
     C     A8GENM        IfEQ      '1'
      *                                                                                       224639
      ** IBAN canot be amended if incoming funds transfer records exists                      224639
      ** (CFT004 must be on)                                                                  224639
      *                                                                                       224639
     C     CHKACC        CHAIN     ACCNTAX0                           80                      224639
     C     *IN80         IFEQ      *OFF                                                       224639
     C                   Move      *OFF          *IN80                                        224639
     C     A1IBAN        CHAIN     INPAYIB                            80                      224639
     C     *IN80         IFEQ      *OFF                                                       224639
     C     DDIBAN        ANDNE     A1IBAN                                                     224639
     C     DDACTN        ANDEQ     'A'                                                        224639
     C                   Move      'N'           DDIBANOk                                     224639
     C                   Add       1             Idx                                          224639
     C                   Movel     'DDIBAN'      FldNamXAr(Idx)                               224639
     C                   Movel     'RE72026'     MsgIDXAr(Idx)                                224639
     C                   ENDIF                                                                224639
     C                   ENDIF                                                                224639
      *
      ****IBAN*field*is*mandatory*************************************                        193178
      *** IBAN field should be input for retail accounts                                      193178
      *
     C     DDIBAN        Ifeq      *BLANKS
     C     DDATYP        Ifeq      'R'                                                        193178
     C**********         Move      'N'           DDIBANOk                                     193178
     C**********         Add       1             Idx                                          193178
     C**********         Movel     'DDIBAN'      FldNamXAr(Idx)                               193178
     C**********         Movel     'RE72022'     MsgIDXAr(Idx)                                193178
     C                   Add       1             WIx                                          193178
     C                   Movel     'DDIBAN'      WFldNmXAr(WIx)                               193178
     C**********         Movel     'RE72022'     WMsgIdXAr(WIx)                        193178 238765
     C                   Movel     'RE72050'     WMsgIdXAr(WIx)                               238765
     C                   END                                                                  193178
      *
     C                   ELSE
      *
      *** Call AOIBANR3 to remove any blanks in IBAN
      *
     C                   CALLB     'AOIBANR3'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      DDIBAN        @IBAN
     C                   PARM                    @IWITH
     C                   PARM                    @INOBL
      *
     C     @RTCD         Ifne      *BLANKS
     C                   Move      'N'           DDIBANOk
     C                   Add       1             Idx
     C                   Movel     'DDIBAN'      FldNamXAr(Idx)
     C                   Movel     'RE72030'     MsgIDXAr(Idx)
     C                   ELSE
      *
      *** Call AOIBANR7, match ISO country code entered with the ISO
      *** country code returned
      *
     C                   CALLB     'AOIBANR7'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      DDBRCA        @BRCH             3
     C                   PARM                    @ISOC             2
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'AOIBANR7'    DBFILE                         ************
     C                   MOVEL     '903'         DBASE                          * DBERR 903*
     C                   MOVEL     DDBRCA        DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
     C     2             SUBST     @INOBL:1      ISO               2
     C     @ISOC         IFNE      ISO
     C                   Move      'N'           DDIBANOk
     C                   Add       1             Idx
     C                   Movel     'DDIBAN'      FldNamXAr(Idx)
     C                   Movel     'RE72023'     MsgIDXAr(Idx)
      *
     C                   ELSE
      *
      *** Retrieve IBAN country details
      *
     C     ISO           CHAIN     SDCTRYL2                           80
      *
      *** Total length of the IBAN entered must be equal to the IBAN
      *** length plus 4 characters
     C     A4BBAN        ADD       4             TOTBBN            2 0
     C     ' '           CHECKR    @INOBL        IBNLGT            2 0
      *
     C     TOTBBN        IFNE      IBNLGT
     C                   Move      'N'           DDIBANOk
     C                   Add       1             Idx
     C                   Movel     'DDIBAN'      FldNamXAr(Idx)
     C                   Movel     'RE72033'     MsgIDXAr(Idx)
     C                   ELSE
      *
      *** Call AOIBANR0 to validate the IBAN check digits
      *
     C                   CALLB     'AOIBANR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      'V'           IACTN             1
     C                   PARM      ISO           ICNTY             2
     C                   PARM      @INOBL        IIBANP           34
     C                   PARM                    OBBAN            30
     C                   PARM                    OIBAN            34
     C                   PARM                    OCKDG             2
      *
     C     @RTCD         IFNE      *BLANKS
     C                   Move      'N'           DDIBANOk
     C                   Add       1             Idx
     C                   Movel     'DDIBAN'      FldNamXAr(Idx)
     C                   Movel     'RE72031'     MsgIDXAr(Idx)
     C**********         Movel(p)  OCKDG         MsgDtaXAr(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(OCKDG))                                MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(OCKDG)                    MD000091
     C                   ELSE
      *
      *** If IBAN bank/branch length is not 0, then the fifth to
      *** position (5 + BBAN branch/bank length) must equal the IBAN ID
      *
     C     A4BBRL        Ifne      *ZERO
     C     A4BBRL        SUBST     @INOBL:5      IBANID           10
      *
     C     IBANID        Ifne      A8IBID
     C                   Move      'N'           DDIBANOk
     C                   Add       1             Idx
     C                   Movel     'DDIBAN'      FldNamXAr(Idx)
     C                   Movel     'RE72032'     MsgIDXAr(Idx)
     C**********         Movel(p)  A8IBID        MsgDtaXAr(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(A8IBID))                               MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(A8IBID)                   MD000091
      *
     C                   ELSE
      *
      *** IBAN must be unique
      *
     C     @INOBL        CHAIN     ACCNTL6                            80
      *
     C     *IN80         IFEQ      *OFF
     C                   MOVEL(P)  DDCUSN        S5CNUM
     C                   MOVEL(P)  DDACOD        S5ACOD
     C                   MOVEL(P)  DDACSQ        S5ACSQ
     C                   MOVEL(P)  DDACNO        S5ACNO
     C     S5CNUM        IFNE      IBCNUM
     C*****S5CCY         ORNE      IBCCY                                                      193103
     C     DDCCY         ORNE      IBCCY                                                      193103
     C     S5ACOD        ORNE      IBACOD
     C     S5ACSQ        ORNE      IBACSQ
     C*****S5BRCA        ORNE      IBBRCA                                                     193103
     C     DDBRCA        ORNE      IBBRCA                                                     193103
     C     S5ACNO        ORNE      IBACNO
     C                   Move      'N'           DDIBANOk
     C                   Add       1             Idx
     C                   Movel     'DDIBAN'      FldNamXAr(Idx)
     C                   Movel     'RE72024'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      IBSEQN = 'AAA'
     C                   EVAL      DDIBAN = @INOBL
     C                   ENDIF
     C                   ELSE
      *
      *** IBAN must be unique
      *
     C     @INOBL        CHAIN     ACCNTL6                            80
      *
     C     *IN80         IFEQ      *OFF
     C                   MOVEL(P)  DDCUSN        S5CNUM
     C                   MOVEL(P)  DDACOD        S5ACOD
     C                   MOVEL(P)  DDACSQ        S5ACSQ
     C                   MOVEL(P)  DDACNO        S5ACNO
     C     S5CNUM        IFNE      IBCNUM
     C*****S5CCY         ORNE      IBCCY                                                      193103
     C     DDCCY         ORNE      IBCCY                                                      193103
     C     S5ACOD        ORNE      IBACOD
     C     S5ACSQ        ORNE      IBACSQ
     C*****S5BRCA        ORNE      IBBRCA                                                     193103
     C     DDBRCA        ORNE      IBBRCA                                                     193103
     C     S5ACNO        ORNE      IBACNO
     C                   Move      'N'           DDIBANOk
     C                   Add       1             Idx
     C                   Movel     'DDIBAN'      FldNamXAr(Idx)
     C                   Movel     'RE72024'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      IBSEQN = 'AAA'
     C                   EVAL      DDIBAN = @INOBL
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      *
      *
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDIBANOK      IfEq      'N'
     C                   Eval      RetCodeIn = '*Error'
     C                   EndIf
      *
      ** RETURN
      *
     C                   Return
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *Entry        Plist
      *
      * INPUTS
      *
      ** Return Code
     C                   Parm                    RetCodeIn
      *
      ** International Bank Account Number (screen)
     C**********         Parm                    DDIBAN           34                          206824
     C                   Parm                    DDIBAN           47                          206824
      ** International Bank Account Number (on file)
     C                   Parm                    IBANFL           34
      ** International Bank Account Number Sequence
     C                   Parm                    IBSEQN            3
      ** Action Code
     C                   Parm                    DDACTN            1
      ** Branch Code
     C                   Parm                    DDBRCA            3
      ** Customer Number
     C                   Parm                    DDCUSN            6
      ** Currency
     C                   Parm                    DDCCY             3
      ** Account Code
     C**********         Parm                    DDACOD            4                          CGL029
     C                   Parm                    DDACOD                                       CGL029
      ** Account Sequence
     C                   Parm                    DDACSQ            2
      ** Account Type
     C                   Parm                    DDATYP            1
      ** Account Number
     C                   Parm                    DDACNO           10
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
      *
      * Warning message IDs/message data (arrays) from/to caller
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtXAr
      *
      ** Account Name - Ok
     C                   Parm                    DDIBANOK          1
     C
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
