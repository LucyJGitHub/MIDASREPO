     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ME Network A/c MT94x Dtl Desc.- Key Validat°')   *
      *****************************************************************
      *                                                               *
      *  Midas - Messages Generation Module                           *
      *                                                               *
      *  RPGLE/ME002340 - Midas ME Network Account MT94x Details      *
      *                   Description Maintenance (Key Screen         *
      *                   Validation)                                 *
      *                                                               *
      *  Function:  This module validates the key fields of a Network *
      *             Account MT94x Details record.                     *
      *             Note that this module should only be called for   *
      *             "Insert".                                         *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD050698           Date 17Jul18               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD040941           Date 05Sep16               *
      *                 BUG22523           Date 03Feb09               *
      *                 BUG22481           Date 02Feb09               *
      *                 BUG22418           Date 02Feb09               *
      *                 BG21987            Date 22Jan09               *
      *                 BG21986            Date 21Jan09               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL013   *CREATE   Date 25Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD050698 - Send an error message if the SWIFT ID to be used  *
      *             as Destination is being used by more than one     *
      *             live customer.                                    *
      *  MD046248 - Finastra Rebranding                               *
      *  MD040941 - Non Swift-BIC is not accepted in Network accounts.*
      *             Introduce a new system value to control whether   *
      *             non SWIFT-BIC & non customer numbers are allowed. *
      *  BUG22523- Destination accepts non numerical values           *
      *            for Multicash Networks                             *
      *  BUG22481 - Field 86 Structure validation field not available *
      *             during Enquire and Amend                          *
      *  BUG22418 - Multicash Participant Number is Unique for a      *
      *             Customer but not for Customer Accounts            *
      *  BG21987 - Only 1 network can be assigned as a Default        *
      *            Field 86 Structure Validation for 1 retail account *
      *  BG21986 - Restrict existing validation for Multicash Network *
      *  CER030 - Multicash German Feature                            *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL013 - MT94x Message Generation                            *
      *                                                               *
      *****************************************************************
 
     FGLNW94L1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLNW94D0:GLNW94D1)
      ** Midas GL Network Accounts - MT94x - Retrieval
      *
      ** Midas GL Network Accounts - MT94x                                                    CER030
      *                                                                                       CER030
     F***GLNW94L9  IF   E           K DISK    PREFIX(D)                              CER030 BUG22418
     FGLNW94L10 IF   E           K DISK    PREFIX(D)                                        BUG22418
      *                                                                                      BG21987
     F***GLNW94L7  IF   E        K DISK    INFSR(*PSSR)                             BG21987 BUG22481
     F**********                           RENAME(GLNW94D0:GLNW94D2)                BG21987 BUG22481
     F**********                           PREFIX(M)                                BG21987 BUG22481
      *                                                                                      BG21987
     FSDCUSTL7  IF   E           K DISK    INFSR(*PSSR)                                     MD050698
     F                                     RENAME(@CUSTGE:SDCUSTSW)                         MD050698
     F                                     PREFIX(A)                                        MD050698
      *****************************************************************
      *                                                               *
      * Use of Indicators                                             *
      *                                                               *
      * Error Indicators                                              *
      *                                                               *
      * 40 - General Error Indicator                                  *
      * 41 - Destination Id.                                          *
      * (The DS IN40_TO_70 is used to cover the whole set of reserved *
      *  error indicators)                                            *
      *                                                               *
      * Database Error Indicators                                     *
      *                                                               *
      * U7 - Abnormal Completion                                      *
      * U8 - File Out of Balance                                      *
      * U7 + U8 - Database Error                                      *
      *                                                               *
      * Other Indicators                                              *
      *                                                               *
      * 99 - Multi-purpose                                            *
      *                                                               *
      *****************************************************************
 
      ** Automatically included D-specs
      ** ==============================
      *
 
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
 
      ** Manually included D-specs
      ** =========================
      *
 
      ** Named constants
      ** ---------------
      *
 
      ** Arrays and Data Structures
      ** --------------------------
      *
 
     D NewFilRcd     E DS                  EXTNAME(GLNW94PD)
      ** New Network Account MT94x Detais File Record (i.e. new state after amendments)
      *
 
     D ScrLayout     E DS                  EXTNAME(ME002320DF:ME002320F0)
      ** Key Screen Layout
      *
 
     D DsNWRK        E DS                  EXTNAME(SDNWRKPD)
      ** Network details record format data structure
      *
 
     D DsCUST        E DS                  EXTNAME(SDCUSTPD)
      ** Midas SD Customer Details record layout
      *
 
     D DsCNST        E DS                  EXTNAME(SDCNSTPD)
      ** Midas SD Counterparty Nostro Details record layout
      *
 
     D DsBICD        E DS                  EXTNAME(MEBICDPD)
      ** Midas BIC Directory Details record layout
      *
 
     D DSLDY         E DS                  EXTNAME(DSLDY)
      ** DS (longest) used as output parameter for Access Objects
      *
 
      *                                                                                       CER030
      ** Short data structure                                                                 CER030
      *                                                                                       CER030
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CER030
      *                                                                                       CER030
      ** External DS for SAR Details                                                          CER030
      *                                                                                       CER030
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER030
      ** Declared variables
      ** ------------------
      *
      ** Destination Second format
     D DSTNScdFmt      S                   LIKE(F0DSTN)
 
      ** Destination Key Field
     D K0DSTN          S                   LIKE(F0DSTN)
 
      ** Error Indicators Array
      *
     D IN40_TO_70      S              1    DIM(31)
      *                                                                                       CER030
      ** Fields for CER030                                                                    CER030
      *                                                                                       CER030
     D CER030          S              1A                                                      CER030
     D POptn           S              7A                                                      CER030
     D PRtcd           S              7A                                                      CER030
     D PSard           S              6A                                                      CER030
      *                                                                                       CER030
      ** Work Variables                                                                       CER030
      *                                                                                       CER030
     D WDstn           S             11A                                                      CER030
     D WPos            S              2S 0                                                    CER030
     D WDstn8          S              8A                                                     BG21986
     D WChk#           S              1S 0                                                  BUG22523
     D WCSID           S                   LIKE(BBCSID)                                     MD050698
     D W2CSID          S                   LIKE(BBCSID)                                     MD050698
     D WBICB           S              4A                                                    MD050698   
     D WCtr            S              4S 0                                                  MD050698
     D WLen            S              2S 0                                                  MD050698
 
      *                                                                                     BUG22523
      ** Constants                                                                          BUG22523
     D CDigits         C                   '0123456789'                                     BUG22523
      *                                                                                     MD040941
      ** System Value to determine if any MT94x destination is allowed.                     MD040941
      *                                                                                     MD040941
     D PSysVal01       S             20A   INZ('AllowAnyMT94xDest   ')                      MD040941
     D PCurSet01       S            200A                                                    MD040941
     D PSysVal02       S             20A                                                    MD040941
     D PCurSet02       S            200A                                                    MD040941
     D PSysVal03       S             20A                                                    MD040941
     D PCurSet03       S            200A                                                    MD040941
     D PSysVal04       S             20A                                                    MD040941
     D PCurSet04       S            200A                                                    MD040941
     D PSysVal05       S             20A                                                    MD040941
     D PCurSet05       S            200A                                                    MD040941
     D PSysVal06       S             20A                                                    MD040941
     D PCurSet06       S            200A                                                    MD040941
     D PSysVal07       S             20A                                                    MD040941
     D PCurSet07       S            200A                                                    MD040941
     D PSysVal08       S             20A                                                    MD040941
     D PCurSet08       S            200A                                                    MD040941
     D PSysVal09       S             20A                                                    MD040941
     D PCurSet09       S            200A                                                    MD040941
     D PSysVal10       S             20A                                                    MD040941
     D PCurSet10       S            200A                                                    MD040941
     D WSysVal01       S              1A                                                    MD040941
      *                                                                                     BUG22523
      *------------------------------------------------------------------------*
      ** C Spec. Declaratives
      ** ====================
      *
 
      ** Entry Parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    RetCodeOut
     C                   PARM                    ActionCode
     C                   PARM                    CallerIn         10
     C                   PARM                    ScrLayout
     C                   PARM                    IN40_TO_70
     C                   PARM                    NewFilRcd
 
      ** Key lists
      *
     C     KGLNW94L1     KLIST
     C                   KFLD                    F0NWRK
     C                   KFLD                    F0BRCA
     C                   KFLD                    F0CNUM
     C                   KFLD                    F0CCY
     C                   KFLD                    F0ACCD
     C                   KFLD                    F0ACSQ
     C                   KFLD                    F0NATY
     C********           KFLD                    F0DSTN
     C                   KFLD                    K0DSTN
      *                                                                                      BG21987
     C*****KGLNW94L7     KLIST                                                      BG21987 BUG22481
     C**********         KFLD                    F0BRCA                             BG21987 BUG22481
     C**********         KFLD                    F0CNUM                             BG21987 BUG22481
     C**********         KFLD                    F0CCY                              BG21987 BUG22481
     C**********         KFLD                    F0ACCD                             BG21987 BUG22481
     C**********         KFLD                    F0ACSQ                             BG21987 BUG22481
      *                                                                                     BUG22418
      ** Key field list for GLNW94L10                                                       BUG22418
      *                                                                                     BUG22418
     C     KGLNW94L10    KLIST                                                              BUG22418
     C                   KFLD                    F0NWRK                                     BUG22418
     C                   KFLD                    F0DSTN                                     BUG22418
                                                                                            MD050698
     C     KSDCUSTL7     KLIST                                                              MD050698
     C                   KFLD                    WCSID                                      MD050698
 
      *========================================================================*
      *              M  A  I  N     P  R  O  C  E  S  S  I  N  G               *
      *========================================================================*
 
      ** Init processing uses the standard *INZSR SR
 
      *------------------------------------------------------------------------*
      *                         Key Fields Validation                          *
      *------------------------------------------------------------------------*
 
      ** Destination Id.
      *
      ** -- The field is mandatory
      *
 B1  C                   IF        F0DSTN = *Blanks
     C                   MOVE      'ME00034'     ZAMSID
     C                   MOVE      *On           *IN41
 X1  C                   ELSE
      *                                                                                       CER030
      ** If Multicash Network                                                                 CER030
      *                                                                                       CER030
     C                   IF        CER030 = 'Y' AND EDMCNW = 'Y'                              CER030
      *                                                                                       CER030
     C**********         EVAL      WDstn = %TRIM(F0DSTN)                              CER030 BG21986
     C                   EVAL      WDstn = F0DSTN                                            BG21986
     C**********         EVAL      WPos = %SCAN(' ':WDstn)                            CER030 BG21986
     C                   EVAL      WPos = %LEN(%TRIMR(F0DSTN))                               BG21986
      *                                                                                       CER030
      ** Entered destination should not exceed 8 char                                         CER030
      ** Destination should be Numeric (8 digits)                                            BG21986
      *                                                                                       CER030
     C                   EVAL      WDstn8 = F0DSTN                                           BG21986
      *                                                                                     BUG22523
     C                   EVAL      WChk# = 0                                                BUG22523
     C                   EVAL      WChk# = %CHECK(CDigits:WDstn8)                           BUG22523
     C**********         TESTN                   WDstn8               92            BG21986 BUG22523
      *                                                                                      BG21986
     C**********         IF        WPos > 9  OR WPos = *ZEROS                         CER030 BG21986
     C**********         IF        WPos <> 8 OR *IN92 = *OFF                        BG21986 BUG22523
     C                   IF        WPos <> 8 or WChk# <> 0                                  BUG22523
     C                   EVAL      WDstn = %TRIM(F0DSTN)                                      CER030
     C                   MOVE      'ME00200'     ZAMSID                                       CER030
     C                   MOVE      *ON           *IN41                                        CER030
     C                   ELSE                                                                 CER030
      *                                                                                       CER030
      ** If Multicash Network then should be Unique                                           CER030
      *                                                                                       CER030
     C*****WDstn         CHAIN     GLNW94L9                                          CER030 BUG22418
     C     KGLNW94L10    CHAIN     GLNW94L10                                                BUG22418
     C**********         IF        %FOUND(GLNW94L9)                                  CER030 BUG22418
     C                   IF        %FOUND(GLNW94L10)                                        BUG22418
     C                   MOVE      'ME00203'     ZAMSID                                       CER030
     C                   MOVE      *ON           *IN41                                        CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C**********         ENDIF                                                        CER030 BG21986
     C                   ELSE                                                                BG21986
      *                                                                                       CER030
     C**********         IF        ZAMSID = *BLANKS                                   CER030 BG21986
 
      ** -- The field must contain a live SWIFT BIC or customer number
      **    Also, the BIC is only allowed for a "*SWIFT" network protocol
      *
     C                   MOVEL     F0DSTN        @BICC
     C                   MOVE      F0DSTN        @BICB
 
     C                   CALL      'ME1400'
     C                   PARM      *Blanks       @RtCd                          I:Return code
     C                   PARM                    @BICC             8            I:Bic Code
     C                   PARM                    @BICB             3            I:Bic Branch
     C                   PARM      *Blanks       DsCUST                         O:Customer Detail
     C                   PARM      *Blanks       DsCNST                         O:Counterparty Dtl
     C                   PARM      *Blanks       DsBICD                         O:Bic Directory Dtl
     C                   PARM      *Blanks       @ICUST            1            O:Customer found
     C                   PARM      *Blanks       @ICNST            1            O:Counterparty fd
     C                   PARM      *Blanks       @IBICD            1            O:Bic found
 
 B2  C                   IF        EDPROT = '*SWIFT'
 
 B3  C                   IF        @ICUST <> 'Y' AND @IBICD <> 'Y'
 B3  C                             OR @ICUST = 'Y' AND BBCSID = *BLANKS
     C                   MOVE      'ME00056'     ZAMSID
     C                   MOVE      *On           *IN41
 E3  C                   ENDIF
 
     ** Do not convert automatically the customer number in SWIFT address
      *
 B3  C*******            IF        @ICUST = 'Y' AND BBCSID <> *BLANKS
     C*******            MOVEL(P)  BBCSID        F0DSTN              Load SWIFT address
 E3  C*******            ENDIF
 
 X2  C                   ELSE
 
     C                   MOVE      'N'           ZWARN             1                        MD040941
 B3  C                   IF        @ICUST <> 'Y'
     C                   IF        WSysVal01 = 'N'                                          MD040941
     C                   MOVE      'ME00057'     ZAMSID
     C                   MOVE      *On           *IN41
     C                   ELSE                                                               MD040941
     C                   MOVE      'ME00096'     ZAMSID                                     MD040941
     C                   MOVE      'Y'           ZWARN                                      MD040941
     C                   ENDIF                                                              MD040941
 E3  C                   ENDIF
 
 E2  C                   ENDIF
 
      ** Check if SWIFT BIC is being used/shared by more than one live customer             MD050698
      *                                                                                     MD050698
     C                   EVAL      WLen = %LEN(%TRIM(F0DSTN))                               MD050698
     C                   IF        @ICUST = 'Y' AND WLen > 6                                MD050698
     C                   EVAL      WCtr = 0                                                 MD050698
     C                   EVAL      WCSID = @BICC                                            MD050698
     C                   EVAL      WBICB = @BICB                                            MD050698
     C                   MOVE      WBICB         WCSID                                      MD050698
     C                   EVAL      W2CSID = WCSID                                           MD050698
                                                                                            MD050698
     C     KSDCUSTL7     SETLL     SDCUSTSW                                                 MD050698
     C     KSDCUSTL7     READE     SDCUSTSW                               90                MD050698 
     C                   DOW       *IN90 = *OFF AND WCtr <= 1                               MD050698
     C                   IF        ABBDTDL = 0                                              MD050698
     C                   EVAL      WCtr = WCtr + 1                                          MD050698
     C                   ENDIF                                                              MD050698
     C     KSDCUSTL7     READE     SDCUSTSW                               90                MD050698
     C                   ENDDO                                                              MD050698
                                                                                            MD050698
     C                   IF        WCtr = 0                                                 MD050698
     C                   IF        @BICB = *BLANKS                                          MD050698
     C                   MOVE      'XXX '        WCSID                                      MD050698
     C     KSDCUSTL7     SETLL     SDCUSTSW                                                 MD050698
     C     KSDCUSTL7     READE     SDCUSTSW                               90                MD050698 
     C                   DOW       *IN90 = *OFF AND WCtr <= 1                               MD050698
     C                   IF        ABBDTDL = 0                                              MD050698
     C                   EVAL      WCtr = WCtr + 1                                          MD050698
     C                   ENDIF                                                              MD050698
     C     KSDCUSTL7     READE     SDCUSTSW                               90                MD050698
     C                   ENDDO                                                              MD050698
     C                   ENDIF                                                              MD050698
     C                   ENDIF                                                              MD050698
                                                                                            MD050698
     C                   IF        WCtr > 1                                                 MD050698
     C                   EVAL      ZAMSID = 'MIN0614'                                       MD050698
     C                   EVAL      ZAMSDA = W2CSID                                          MD050698 
     C                   EVAL      *IN41 = *ON                                              MD050698
     C                   ENDIF                                                              MD050698
                                                                                            MD050698
     C                   ENDIF                                                              MD050698

      ** Retrieve the second format of the destination
      *
     C                   IF        @ICUST = 'Y'
     C                   IF        F0DSTN <> BBCUST
     C                   EVAL      DSTNScdFmt = BBCUST
     C                   ELSE
     C                   EVAL      DSTNScdFmt = BBCSID
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF                                                                CER030
 E1  C                   ENDIF
 
      ** -- If an error was found
      *
     C**********         IF        *IN41                                                    MD040941
     C                   IF        *IN41 OR ZWARN = 'Y'                                     MD040941
     C                   EXSR      $ZaSndMsg
     C                   IF        *IN41                                                    MD040941
     C                   MOVE      *On           *IN40
     C                   ENDIF                                                              MD040941
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End Destination Id.
      *                                                                                       CER030
      ** Default for Field 86 structure validation                                            CER030
      *                                                                                       CER030
     C**********         IF        F0SV86 = *BLANKS                                  CER030 BUG22481
     C**********         EVAL      ZAMSID = 'ME00034'                                CER030 BUG22481
     C**********         EVAL      *IN42 = *ON                                       CER030 BUG22481
      *                                                                                       CER030
     C**********         ELSEIF    F0SV86 <> 'Y' AND F0SV86 <> 'N'                   CER030 BUG22481
     C**********         EVAL      ZAMSID = 'ME00202'                                CER030 BUG22481
     C**********         EVAL      *IN42 = *ON                                       CER030 BUG22481
      *                                                                                       CER030
     C**********         ELSEIF    EDENRA = 'N' AND F0SV86 = 'Y'                     CER030 BUG22481
     C**********         EVAL      ZAMSID = 'ME00201'                                CER030 BUG22481
     C**********         EVAL      *IN42 = *ON                                       CER030 BUG22481
      *                                                                                      BG21987
     C**********         ELSEIF    F0SV86 = 'Y'                                     BG21987 BUG22481
     C*****KGLNW94L7     CHAIN     GLNW94L7                                         BG21987 BUG22481
      *                                                                                      BG21987
     C**********         IF        %FOUND (GLNW94L7)                                BG21987 BUG22481
     C**********         EVAL      ZAMSID = 'ME00204'                               BG21987 BUG22481
     C**********         EVAL      *IN42 = *ON                                      BG21987 BUG22481
     C**********         ENDIF                                                      BG21987 BUG22481
      *                                                                                       CER030
     C**********         ENDIF                                                       CER030 BUG22481
      *                                                                                       CER030
      ** If an error was found                                                                CER030
      *                                                                                       CER030
     C**********         IF        *IN42 = *ON                                       CER030 BUG22481
      *                                                                                       CER030
     C**********         EXSR      $ZASndMsg                                         CER030 BUG22481
     C**********         EVAL      *IN40 = *ON                                       CER030 BUG22481
     C**********         EVAL      RetCodeOut = '*MSG'                               CER030 BUG22481
      *                                                                                       CER030
     C**********         ENDIF                                                       CER030 BUG22481
      *                                                                                       CER030
 
      ** End the module if any error encountered
      *
     C   40              EXSR      $ExitMod
 
      *------------------------------------------------------------------------*
      *                  Database Keys Consistency Validation                  *
      *------------------------------------------------------------------------*
 
      ** Check if the key already exists in the database with the second format of the
      ** Destination.
      *
     C                   EVAL      K0DSTN = DSTNScdFmt
     C     KGLNW94L1     CHAIN     GLNW94D1                           99
 B1  C                   IF        NOT *IN99
 B2  C                             AND N4RECI = 'D'
     C                   MOVE      'ME00041'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   MOVE      *On           *IN40
     C                   MOVE      *On           *IN41
     C                   ENDIF
 
      ** Check if the key already exists in the database
      *
     C                   EVAL      K0DSTN = F0DSTN
     C     KGLNW94L1     CHAIN     GLNW94D1                           99
 
      ** -- The record already exists ==> error if it is not deleted,
      **                    otherwise change the Action Code to Amend
      *
 B1  C                   IF        NOT *IN99
      *
 B2  C                   IF        N4RECI = 'D'
     C                   MOVE      'ME00041'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   MOVE      *On           *IN40
     C                   MOVE      *On           *IN41
 X2  C                   ELSE
     C                   EVAL      ActionCode = 'A'
 E2  C                   ENDIF
      *
 E1  C                   ENDIF
 
      ** End of the module
      *
     C                   EXSR      $ExitMod
 
      *========================================================================*
      *                    S  U  B  R  O  U  T  I  N  E  S                     *
      *========================================================================*
 
      *========================================================================*
      * $ZaSndMsg : Send message to the program message queue                  *
      *------------------------------------------------------------------------*
     C     $ZaSndMsg     BEGSR
      *    ----------    ------
 
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGM
     C                   PARM                    ZAPGRL
     C                   PARM                    ZAMSID
     C                   PARM                    ZAMSGF
     C                   PARM                    ZAMSDA
     C                   PARM                    ZAMSTP
      *    ----------    ------
     C     @ZaSndMsg     ENDSR
 
      *========================================================================*
      * $ExitMod  : Exit from the module                                       *
      *------------------------------------------------------------------------*
     C     $ExitMod      BEGSR
      *    ----------    ------
      ** Return the current values of the error indicators
      *
     C                   MOVEA     *IN(40)       IN40_TO_70
 
     C                   MOVE      *On           *INLR
     C                   RETURN
      *    ----------    ------
     C     @ExitMod      ENDSR
 
      *========================================================================*
      * *INZSR    : Init Processing                                            *
      *========================================================================*
     C     *INZSR        BEGSR
      *    ----------    ------
      ** Initialise Copyright Array
      *
     C                   MOVEA     CPY@          CPY@@            80
 
      ** Define fields used by the message sending function
      *
      ** -- If no named caller --> set-up ZAPGM with the current program name
      *
     C                   IF        CallerIn = *Blanks
     C                   MOVEL     PSProcPgm     ZAPGM            10
 
      ** -- Otherwise set-up ZAPGM with the caller name
      *
     C                   ELSE
     C                   MOVEL     CallerIn      ZAPGM
     C                   ENDIF
 
     C                   MOVEL     'MEMSG'       ZAMSGF           10
     C                   MOVEL     '*SAME'       ZAPGRL            5
     C                   MOVEL     *Blanks       ZAMSID            7
     C                   MOVEL     *Blanks       ZAMSDA          132
     C                   MOVEL     *Blanks       ZAMSTP            7
 
      ** Initialize error indicators with the values passed by the caller
      *
     C                   MOVEA     IN40_TO_70    *IN(40)
 
      ** Reset general error indicator
      *
     C                   MOVE      *OFF          *IN40
 
      ** Clear the return code
      *
     C                   EVAL      RetCodeOut = *Blanks
 
      ** Clear the second format of the destination
      *
     C                   EVAL      DSTNScdFmt = *Blanks
 
      ** Retrieve the associated network record
      *
     C                   CALLB     'AONWRKR1'
     C                   PARM      *Blanks       @RtCd
     C                   PARM      '*KEY'        @Optn
     C                   PARM      F0NWRK        @NWRK             6
     C     DsNWRK        PARM                    DSLDY
 
     C                   IF        @RtCd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDNWRKPD'                          *=======*
     C                   EVAL      DBKey  = F0NWRK                              *       *
     C                   EVAL      DBPgm  = ZAPGM                               * Error *
     C                   EVAL      DBase  = 001                                 *       *
     C                   EVAL      DBMod  = PSProcMod                           *  001  *
     C                   EVAL      DBProc = PSProcName                          *       *
     C                   OUT       LDA                                          *=======*
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CER030
      ** Check the switchable feature CER030                                                  CER030
      *                                                                                       CER030
     C                   CALLB     'AOSARDR0'                                                 CER030
     C                   PARM      *BLANKS       PRtCd                                        CER030
     C                   PARM      '*VERIFY'     POptn                                        CER030
     C                   PARM      'CER030'      PSard                                        CER030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER030
      *                                                                                       CER030
     C                   IF        PRtcd = *BLANKS                                            CER030
     C                   EVAL      CER030 = 'Y'                                               CER030
     C                   ELSE                                                                 CER030
      *                                                                                       CER030
     C                   IF        PRtcd <> '*NRF'                                            CER030
     C     *LOCK         IN        LDA                                                        CER030
     C                   EVAL      DBFile = 'SCSARDPD'                                        CER030
     C                   EVAL      DBKey  = '*VERIFY'                                         CER030
     C                   EVAL      DBase  = 002                                               CER030
     C                   OUT       LDA                                                        CER030
     C                   EXSR      *PSSR                                                      CER030
      *                                                                                       CER030
     C                   ELSE                                                                 CER030
     C                   EVAL      CER030 = 'N'                                               CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   CALLB     'AOSVALR0'                                               MD040941
     C                   PARM      *BLANKS       PRtCd                                      MD040941
     C                   PARM                    PSysVal01                                  MD040941
     C                   PARM                    PCurSet01                                  MD040941
     C                   PARM                    PSysVal02                                  MD040941
     C                   PARM                    PCurSet02                                  MD040941
     C                   PARM                    PSysVal03                                  MD040941
     C                   PARM                    PCurSet03                                  MD040941
     C                   PARM                    PSysVal04                                  MD040941
     C                   PARM                    PCurSet04                                  MD040941
     C                   PARM                    PSysVal05                                  MD040941
     C                   PARM                    PCurSet05                                  MD040941
     C                   PARM                    PSysVal06                                  MD040941
     C                   PARM                    PCurSet06                                  MD040941
     C                   PARM                    PSysVal07                                  MD040941
     C                   PARM                    PCurSet07                                  MD040941
     C                   PARM                    PSysVal08                                  MD040941
     C                   PARM                    PCurSet08                                  MD040941
     C                   PARM                    PSysVal09                                  MD040941
     C                   PARM                    PCurSet09                                  MD040941
     C                   PARM                    PSysVal10                                  MD040941
     C                   PARM                    PCurSet10                                  MD040941
                                                                                            MD040941
     C                   EVAL      WSysVal01 = 'N'                                          MD040941
                                                                                            MD040941
     C                   IF        PRtCd = *BLANKS                                          MD040941
     C                   MOVEL     PCurSet01     WSysVal01                                  MD040941
     C                   ENDIF                                                              MD040941
                                                                                            MD040941
      *    ----------    ------
     C     @INZSR        ENDSR
 
      *========================================================================*
      * *PSSR     : Program exception error subroutine                         *
      *------------------------------------------------------------------------*
     C     *PSSR         BEGSR
      *    ----------    ------
     C                   DUMP
 
     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
 
     C                   CALLB     'DBERRCTL'                           99
 
     C                   MOVEL(P)  '*ERROR'      RetCodeOut
     C                   EXSR      $ExitMod
      *    ----------    ------
     C     @PSSR         ENDSR
 
      *========================================================================*
**  CPY@
(c) Finastra International Limited 2002
