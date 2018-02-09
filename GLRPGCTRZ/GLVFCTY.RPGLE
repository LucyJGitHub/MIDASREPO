     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate Facility Type, No. & Encashment')    *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVFCTY  - Validate Facility Type, Number and Encashment     *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD032890           Date 18Feb15               *
      *                 CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG11670           Date 30Jun06               *
      *                 240037A (Reopen)   Date 15Jun06               *
      *                 240037             Date 23May06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG5948            Date 28Feb05               *
      *                 CSD025             Date 11Jan05               *
      *                 BUG4067 (Reopen)   Date 17Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG4481            Date 06Oct04               *
      *                 BUG4067            Date 26Aug04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP035  *CREATE    Date 19Mar99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD032890 - Cannot amend Retail account with expired facility *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  BUG11670 - System should not default the transaction customer*
      *           on the facility details tab                         *
      *  240037A (Reopen) - Serious Midas error - incomplete facility *
      *           customer during input of accounts                   *
      *  240037 - Serious Midas error - incomplete facility           *
      *           customer during input of accounts                   *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG5948 - Include Aggregate Facility file in checking for    *
      *            live facility.                                     *
      *  CSD025 - Customer De-Activation                              *
      *  BUG4067 - PM Instrument code should be validated when the    *
      *            PM Module is switched on.                          *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG4481 - Reverse BUG4067 to avoid problem in Accounts       *
      *            Maintenance.                                       *
      *  BUG4067 - Do not allow attachment of facility to an account  *
      *            with account code that has a blank PM Instrument   *
      *            code.                                              *
      *  CLE025 - Credit Lines                                        *
      *  CAP035 - Midas/ToF Interface                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
      ** LE Customer Lending Facility File
     FFCLTY     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(FCLTYHHF)
     F                                     IGNORE(FCLTYFNF)
     F                                     IGNORE(FCLTYZZF)
 
      ** LE Aggregate Facility File                                                          BUG5948
     FLEAGFCL0  IF   E           K DISK    INFSR(*PSSR)                                      BUG5948
     F                                     IGNORE(FCLTYHHF)                                  BUG5948
     F                                     IGNORE(FCLTYFNF)                                  BUG5948
     F                                     IGNORE(FCLTYZZF)                                  BUG5948
     F                                     RENAME(FCLTYFMF:LEAGFMD0)                         BUG5948
                                                                                             BUG5948
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
 
      ** Array of fields in warning
     D WFldNamXA       S             10A   DIM(XArrayMax)                                   MD032890
                                                                                            MD032890
      ** Array of warning message IDs                                                       MD032890
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)                      MD032890
                                                                                            MD032890
      ** Array of warning message data.                                                     MD032890
     D WMsgDtaXAr      S                   DIM(XArrayMax) LIKE(#MsgData)                    MD032890
                                                                                            MD032890
      ** Index for arrays of warning message ids etc                                        MD032890
     D WIx             S              3P 0                                                  MD032890
      ** Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)
 
      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
     D NUM             S              1    DIM(10) CTDATA PERRCD(10)
     D ZONE            S              1    DIM(2)
 
      ** External DS for Facility Details
     D SDFACT        E DS                  EXTNAME(SDFACTPD)
                                                                                              CLE025
      ** External DS for SAR Details                                                          CLE025
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CLE025
     D   ZONE2       E                     EXTFLD(ZONE)                                       CLE025
                                                                                              CLE025
      ** External DS for Customer Details                                                     CLE025
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CLE025
 
      ***External DS for Account Code Details                                        BUG4067 BUG4481
     D*SDACOD***     E DS                  EXTNAME(SDACODPD)                         BUG4067 BUG4481
      **********                                                                     BUG4067 BUG4481
      ** External DS for Account Code Details                                                BUG4067
     D SDACOD        E DS                  EXTNAME(SDACODPD)                                 BUG4067
                                                                                             BUG4067
      ** External DS for Midas Modules details                                               BUG4067
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                                 BUG4067
                                                                                             BUG4067
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for access programs, long data structure                                   CLE025
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CLE025
                                                                                              CLE025
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
     D CLE025          S              1                                                       CLE025
     D DDFCCU          S             10                                                       CLE025
     D DDFCCUOk        S              1                                                       CLE025
                                                                                              CLE025
     D PRTCD           S              7                                                       CLE025
     D POPTN           S              7                                                       CLE025
     D PSARD           S              6                                                       CLE025
     D PCUST           S             10                                                       CLE025
     D PKYST           S              7                                                       CLE025
     D*PACOD****       S             10                                              BUG4067 BUG4481
     D*DDACOD***       S             10                                              BUG4067 BUG4481
     D PACOD           S             10                                                      BUG4067
     D DDACOD          S             10                                                      BUG4067
 
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
 
      ** Initialization
 
     C                   MoveL     *Blanks       RetCodeIn
     C                   MoveL     *Blanks       FldNamXAr
     C                   MoveL     *Blanks       MsgIDXAr
     C                   MoveL     *Blanks       MsgDtaXAr
     C                   Z-Add     0             Idx
      *
      ** Facility Type
     C     DDFACT        IFNE      *BLANK
     C                   CALLB     'AOFACTR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDFACT        @FACT             3
     C     SDFACT        PARM      SDFACT        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   Move      'N'           DDFACTOk
     C                   Add       1             Idx
     C                   MoveL     'DDFACT'      FldNamXAr(Idx)
     C                   MoveL     'RE71501'     MsgIDXAr(Idx)
     C                   ELSE
     C                   MOVE      @FACT         DDFACT
     C                   ENDIF
     C                   ENDIF
      *
      ** Facility Number
     C     DDFACT        IFEQ      *BLANK
     C     DDFCNO        IFNE      *BLANK
     C                   Move      'N'           DDFCNOOk
     C                   Add       1             Idx
     C                   MoveL     'DDFCNO'      FldNamXAr(Idx)
     C                   MoveL     'RE71502'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   MOVEA     DDFCNO        ZONE
     C     ZONE(1)       LOOKUP    NUM(1)                                 80
     C     ZONE(2)       LOOKUP    NUM(1)                                 81
      *
     C     *IN80         IFEQ      '0'
     C     *IN81         OREQ      '0'
     C                   Move      'N'           DDFCNOOk
     C                   Add       1             Idx
     C                   MoveL     'DDFCNO'      FldNamXAr(Idx)
     C                   MoveL     'RE71503'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF                                                                240037
      *
      ** Check if facility is linked to customer
      ** - only if facility type and number have been input
     C*****DDFACT        IFNE      *BLANKS                                                    240037
     C*****DDFCNO        ANDNE     *BLANKS                                                    240037
                                                                                              CLE025
      ** If CLE025 is on, ensure that the facility customer,                                  CLE025
      ** type, and sequence refers to a live facility.                                        CLE025
                                                                                              CLE025
     C                   IF        CLE025 = 'Y'                                               CLE025
     C**********         EVAL      WCNUM = 0                                           CLE025 CSD027
     C                   EVAL      WCNUM = *BLANKS                                            CSD027
                                                                                              CLE025
     C                   IF        DDFCCU = *BLANKS                                           CLE025
     C                             AND DDFACT <> *BLANKS                                    BUG11670
     C                             AND DDFCNO <> *BLANKS                                    BUG11670
     C                   EVAL      DDFCCU = DDCUSN                                            CLE025
     C                   MOVEL     DDFCCU        WCNUM                                        CLE025
     C                   ELSE                                                                 CLE025
                                                                                              CLE025
     C                   IF        DDFCCU <> *Blanks                                        BUG11670
     C                   CALLB     'AOCUSTR0'                                                 CLE025
     C                   PARM      *BLANKS       PRTCD                                        CLE025
     C                   PARM      '*KEY   '     POPTN                                        CLE025
     C                   PARM      DDFCCU        PCUST                                        CLE025
     C                   PARM      *BLANKS       PKYST                                        CLE025
     C     SDCUST        PARM      SDCUST        DSSDY                                        CLE025
                                                                                              CLE025
     C**********         IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '          CLE025 240037A
     C**********                   AND  PRTCD <> '*KEY   '                             CLE025 240037
     C**********         EVAL      DBFILE = 'SDCUSTPD'                                 CLE025 240037
     C**********         EVAL      DBKEY = DDFCCU                                      CLE025 240037
     C**********         EVAL      DBASE = 2                                           CLE025 240037
     C**********         EXSR      *PSSR                                               CLE025 240037
     C                   IF        PRTCD <> *BLANKS                                          240037A
     C                   Move      'N'           DDFCCUOk                                     240037
     C                   Add       1             Idx                                          240037
     C                   MoveL     'DDFCCU'      FldNamXAr(Idx)                               240037
     C                   MoveL     'RE71903'     MsgIDXAr(Idx)                                240037
     C                   ENDIF                                                                CLE025
     C                   IF        PRTCD = *BLANKS                                            CLE025
     C                   MOVE      *BLANKS       DDFCCU                                       CLE025
     C                   MOVEL     BBCUST        DDFCCU                                       CLE025
     C                   MOVEL     DDFCCU        WCNUM                                        CLE025
     C                   ENDIF                                                                CLE025
     C                   ENDIF                                                              BUG11670
     C                   ENDIF                                                                CLE025
                                                                                              CLE025
     C                   ELSE                                                                 CLE025
     C                   Move      DDCUSN        WCNUM
     C                   ENDIF                                                                CLE025
                                                                                              240037
     C     DDFACT        IFNE      *BLANKS                                                    240037
     C     DDFCNO        ANDNE     *BLANKS                                                    240037
     C                   Move      DDFACT        WFACT
     C                   Move      DDFCNO        WFCNO
     C                   MOVEL     'A'           WRCTP
     C     FACTK         CHAIN     FCLTY                              80
      *
     C     *IN80         IFEQ      *ON                                                       BUG5948
     C     FACTK         CHAIN     LEAGFCL0                           80                     BUG5948
     C                   ENDIF                                                               BUG5948
      *                                                                                      BUG5948
     C     *IN80         IFEQ      '1'
     C     RECI          ORNE      'D'
     C                   IF        DDACTN = 'I'                                             MD032890
     C                   IF        CLE025 = 'Y'                                               CLE025
     C                   Move      'N'           DDFCCUOk                                     CLE025
     C                   ENDIF                                                                CLE025
     C                   Move      'N'           DDFACTOk
     C                   Move      'N'           DDFCNOOk
     C                   Add       1             Idx
     C                   MoveL     'DDFACT'      FldNamXAr(Idx)
     C                   MoveL     'RE71505'     MsgIDXAr(Idx)
     C                   ELSE
     C                   IF        CLE025 = 'Y'                                             MD032890
     C                   Move      'N'           DDFCCUOk                                   MD032890
     C                   ENDIF                                                              MD032890
     C                   Move      'N'           DDFACTOk                                   MD032890
     C                   Move      'N'           DDFCNOOk                                   MD032890
     C                   Add       1             wIx                                        MD032890
     C                   MoveL     'DDFACT'      WFldNamXA(wIx)                             MD032890
     C                   MoveL     'RE71505'     WMsgIDXAr(wIx)                             MD032890
     C                   ENDIF                                                              MD032890
     C                   ENDIF                                                              MD032890
      *
     C                   ENDIF
     C**********         ENDIF                                                                240037
      *
      ** Encashment Facility
     C     DDEFAC        IFNE      *BLANKS
     C                   MOVEA     DDEFAC        ZONE
     C     ZONE(1)       LOOKUP    NUM(1)                                 80
     C     ZONE(2)       LOOKUP    NUM(1)                                 81
      *
     C     *IN80         IFEQ      '0'
     C     *IN81         OREQ      '0'
     C                   Move      'N'           DDEFACOk
     C                   Add       1             Idx
     C                   MoveL     'DDEFAC'      FldNamXAr(Idx)
     C                   MoveL     'RE71503'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *****************************************************************              BUG4067 BUG4481
     C**********         CALL      'AOACODR0'                                        BUG4067 BUG4481
     C**********         PARM      '*DBERR '     PRTCD                               BUG4067 BUG4481
     C**********         PARM      '*KEY   '     POPTN                               BUG4067 BUG4481
     C**********         PARM      DDACOD        PACOD                               BUG4067 BUG4481
     C*****SDACOD        PARM      SDACOD        DSFDY                               BUG4067 BUG4481
      *****************************************************************              BUG4067 BUG4481
      ***Not*Found                                                                   BUG4067 BUG4481
     C**********         IF        PRTCD <> *BLANKS                                  BUG4067 BUG4481
     C**********         EVAL      DDFACTOk = 'N'                                    BUG4067 BUG4481
     C**********         EVAL      DDFCNOOk = 'N'                                    BUG4067 BUG4481
     C**********         Add       1             Idx                                 BUG4067 BUG4481
     C**********         EVAL      FldNamXAr(Idx) = 'DDFACT'                         BUG4067 BUG4481
     C**********         EVAL      MsgIDXAr(Idx) = 'REL0019'                         BUG4067 BUG4481
     C**********         ELSE                                                        BUG4067 BUG4481
     C**********         IF        A5INNR = *BLANKS                                  BUG4067 BUG4481
     C**********         EVAL      DDFACTOk = 'N'                                    BUG4067 BUG4481
     C**********         EVAL      DDFCNOOk = 'N'                                    BUG4067 BUG4481
     C**********         Add       1             Idx                                 BUG4067 BUG4481
     C**********         EVAL      FldNamXAr(Idx) = 'DDFACT'                         BUG4067 BUG4481
     C**********         EVAL      MsgIDXAr(Idx) = 'RE71122'                         BUG4067 BUG4481
     C**********         ENDIF                                                       BUG4067 BUG4481
     C**********         ENDIF                                                       BUG4067 BUG4481
      *****************************************************************              BUG4067 BUG4481
                                                                                             BUG4067
     C                   IF        BGPFMG = 'Y'                                              BUG4067
     C                   CALL      'AOACODR0'                                                BUG4067
     C                   PARM      '*DBERR '     PRTCD                                       BUG4067
     C                   PARM      '*KEY   '     POPTN                                       BUG4067
     C                   PARM      DDACOD        PACOD                                       BUG4067
     C     SDACOD        PARM      SDACOD        DSFDY                                       BUG4067
                                                                                             BUG4067
      ** Not Found                                                                           BUG4067
     C                   IF        PRTCD <> *BLANKS                                          BUG4067
     C                   EVAL      DDFACTOk = 'N'                                            BUG4067
     C                   EVAL      DDFCNOOk = 'N'                                            BUG4067
     C                   Add       1             Idx                                         BUG4067
     C                   EVAL      FldNamXAr(Idx) = 'DDFACT'                                 BUG4067
     C                   EVAL      MsgIDXAr(Idx) = 'REL0019'                                 BUG4067
     C                   ELSE                                                                BUG4067
     C                   IF        A5INNR = *BLANKS                                          BUG4067
     C                   EVAL      DDFACTOk = 'N'                                            BUG4067
     C                   EVAL      DDFCNOOk = 'N'                                            BUG4067
     C                   Add       1             Idx                                         BUG4067
     C                   EVAL      FldNamXAr(Idx) = 'DDFACT'                                 BUG4067
     C                   EVAL      MsgIDXAr(Idx) = 'RE71122'                                 BUG4067
     C                   ENDIF                                                               BUG4067
     C                   ENDIF                                                               BUG4067
     C                   ENDIF                                                               BUG4067
                                                                                             BUG4067
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDFACTOk      IfEq      'N'
     C     DDFCNOOk      OrEq      'N'
     C     DDEFACOk      OrEq      'N'
     C     DDFCCUOk      OREQ      'N'                                                        CLE025
     C                   Eval      RetCodeIn = 'Error'
     C                   EndIf
      *
      ** RETURN
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *Entry        Plist
      *
      ** INPUTS
      *
      ** Return Code
     C                   Parm                    RetCodeIn
      *
      ** Account Screen fields
     C                   Parm                    DDFACT            3
     C                   Parm                    DDFCNO            2
     C                   Parm                    DDEFAC            2
     C                   Parm                    DDCUSN            6
     C                   PARM                    DDFCCU                                       CLE025
     C**********         PARM                    DDACOD                              BUG4067 BUG4481
     C                   PARM                    DDACOD                                      BUG4067
      *
      ** OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
      *                                                                                     MD032890
      * Warning fields/message IDs/message data (arrays) from/to caller                     MD032890
     C                   Parm                    WFldNamXA                                  MD032890
     C                   Parm                    WMSGIDXAr                                  MD032890
     C                   Parm                    WMsgDtaXAr                                 MD032890
      *
      ** Facility Type - Ok
      ** Facility No. - Ok
      ** Encashment Facility - Ok
      ** Facility Customer - Ok                                                               CLE025
     C                   Parm                    DDFACTOk          1
     C                   Parm                    DDFCNOOk          1
     C                   Parm                    DDEFACOk          1
     C                   PARM                    DDFCCUOk                                     CLE025
     C                   PARM                    DDACTN            1                        MD032890
                                                                                              CLE025
      ** Check if switchable feature CLE025 (Multi-Option Facilities) is on                   CLE025
                                                                                              CLE025
     C                   CALLB     'AOSARDR0'                                                 CLE025
     C                   PARM      *BLANKS       PRTCD                                        CLE025
     C                   PARM      '*VERIFY'     POPTN                                        CLE025
     C                   PARM      'CLE025'      PSARD                                        CLE025
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE025
                                                                                              CLE025
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CLE025
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CLE025
     C                   EVAL      DBKEY = 'CLE025'                                           CLE025
     C                   EVAL      DBASE = 1                                                  CLE025
     C                   EXSR      *PSSR                                                      CLE025
     C                   ENDIF                                                                CLE025
                                                                                              CLE025
     C                   IF        PRTCD = *BLANKS                                            CLE025
     C                   EVAL      CLE025 = 'Y'                                               CLE025
     C                   ELSE                                                                 CLE025
     C                   EVAL      CLE025 = 'N'                                               CLE025
     C                   ENDIF                                                                CLE025
      *                                                                                      BUG4067
      ** Access MIDAS Modules details via access program                                     BUG4067
      *  (database error handling done in access program)                                    BUG4067
     C                   CALLB     'AOMMODR0'                                                BUG4067
     C                   PARM      '*DBERR '     @RTCD                                       BUG4067
     C                   PARM      '*FIRST '     @OPTN                                       BUG4067
     C     SDMMOD        PARM      SDMMOD        DSFDY                                       BUG4067
      *
      ** Defile key list to access FCLTY
     C     FACTK         KLIST
     C**********         KFLD                    WCNUM             6 0                        CSD027
     C                   KFLD                    WCNUM             6                          CSD027
     C                   KFLD                    WFACT             3 0
     C                   KFLD                    WFCNO             2 0
     C                   KFLD                    WRCTP             1
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
** NUM
0123456789
