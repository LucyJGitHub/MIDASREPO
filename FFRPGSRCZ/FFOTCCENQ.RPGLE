     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Currency OTC Enquiry')                        *
      *****************************************************************
      *                                                               *
      *  Midas - Futures and Options Module                           *
      *                                                               *
      *  FFOTCCENQ - Futures and options Over-the Counter Trades      *
      *              Enquiry                                          *
      *                                                               *
      *  Function:  This is the main enquiry screen for Futures       *
      *             and Options currency OTC options.                 *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CAP208             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BG9185             Date 08Nov05               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP166             Date 15Oct01               *
      *                 CAS002             Date 14Jan02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CFF007             Date 13Feb01               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CGL007  *Create    Date 26Mar99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP208 - F&O Market Instrument API (Recompile)               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BG9185 - Correction to CGL029 (Recompile)                    *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP166 - API for Non-Currency OTC                            *
      *  CAS002 - Hedge Strategy/Linkage (Recompile)                  *
      *  CFF007 - Futures and Options Enhancement for Private Banking *
      *  CGL007 - Account Postings Enquiry                            *
      *                                                               *
      *****************************************************************
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SRP002 - Retrieve Transaction                                *
      *  SRP003 - Put A Transaction on the Main Details Screen        *
      *  SRP004 - Process Screen: Main Details                        *
      *  SRP005 - Initialize Field Status on Main Details Screen      *
      *  SRP006 - Initialize Function Key Status on Main Dtls Screen  *
      *                                                               *
      *  *INZSR - Initial Processing                                  *
      *****************************************************************
      *
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
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** Include the FF standard declares
      *
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
      *
     D/COPY ZACPYSRC,FVAL_ARRAY
      *
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
     D/COPY ZACPYSRC,ERR_ARRAYS
      *
      ** The following /COPY line includes all the named constants
      ** used specifically in FF.
      *
     D/COPY FFCPYSRC,NAMEDCONST
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Standing Data files
      ** ~~~~~~~~ ~~~~ ~~~~~
      ** passed as data structures to lower level modules.
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank Details
      *
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** General Ledger ICD
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** Modules details
      *
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)                                  CFF007
     D  QQACC1       E                     EXTFLD(QQACCD)                                     CGL029
      ** Dealing ICD                                                                          CFF007
      *                                                                                       CFF007
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CFF007
     D  SLCD         E                     EXTFLD(LCD)                                        CFF007
      ** Switchable Features Details                                                          CFF007
      *                                                                                       CFF007
     D SDPORT        E DS                  EXTNAME(SDPORTPD)                                  CFF007
      ** Portfolio Management ICD                                                             CFF007
      *                                                                                       CFF007
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short data structure for access programs
      *
      ** Transaction Details - File Format
      ** ~~~~~~~~~~~ ~~~~~~~   ~~~~ ~~~~~~
     D CurTranFil    E DS                  EXTNAME(TRANSD)
      ** Current transaction in file format
      *
      ** Transaction Details - Screen Format
      ** ~~~~~~~~~~~ ~~~~~~~   ~~~~~~ ~~~~~~
      *
     D CurTranScn    E DS                  EXTNAME(FFOTCCPD)
      ** Current transaction in screen format
     D                                     PREFIX(@)
      *
     D NewTranScn    E DS                  EXTNAME(FFOTCCPD)
      ** New transaction in screen format
      *
      ** Transaction Details - OK Flags
      ** ~~~~~~~~~~~ ~~~~~~~   ~~~~~~~~
      *
     D OKFlagsDS     E DS                  EXTNAME(FFEOTCCPD)
      ** External data structure for exchange-traded OK flags
      *
      ** Customer and Broker Settlement Details - File Format
      ** ~~~~~~~~ ~~~ ~~~~~~ ~~~~~~~~~~ ~~~~~~~   ~~~~ ~~~~~~
      *
     D CurSetFil     E DS                  EXTNAME(TRSET)
      ** Settlements in file format
     D                                     PREFIX(ST)
      *
      ** Customer Settlement Details - Screen Format
      ** ~~~~~~~~ ~~~~~~~~~~ ~~~~~~~   ~~~~~~ ~~~~~~
      *
     D NewCusScn     E DS                  EXTNAME(FFCSETPD)
      ** New Customer Settlement details in screen format
      *
     D CurCusScn     E DS                  EXTNAME(FFCSETPD) PREFIX(@)
      ** Current Customer Settlement Details in Screen Format
      *
      ** Broker Settlement Details - Screen Format
      ** ~~~~~~ ~~~~~~~~~~ ~~~~~~~   ~~~~~~ ~~~~~~
      *
     D NewBrokScn    E DS                  EXTNAME(FFBSETPD)
      ** New broker settlement details in screen format
      *
      ** Settlement Details - OK Flags
      ** ~~~~~~~~~~ ~~~~~~~   ~~ ~~~~~
      *
     D OKBrokSet     E DS                  EXTNAME(FFEBSETPD)
      ** External data structure for broker settlement flags
      *
     D OKCusSet      E DS                  EXTNAME(FFECSETPD)
      ** External data structure for customer settlement flags
      *
      ** Screen Control Indicators
      ** ~~~~~~ ~~~~~~~ ~~~~~~~~~~
      *
     D @CCI@M          DS
      ** Current Control Indicators for main details screen
     D  @EKYFD                 1      1
     D  @EDTFD                 2      2
     D  @EINKG                 3      3
     D  @EINKH                 4      4
     D  @EINKJ                 5      5
     D  @EINKP                 7      7
      *
     D InstType      E DS                  EXTNAME(INTYP)  PREFIX(IT)
      ** Instrument types
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D CustBrokFl      S              1A   INZ('C')
      ** Customer/Broker Flag (B = Broker, V = Customer)
      *
     D LinkEnq         S              1A   INZ('N')
      ** Flag to indicate that the FFOTCCRTV is not being called
      ** as a linked enquiry.
      *
      ** CFF007 enhancement                                                                   CFF007
     D CFF007          S              1A                                                      CFF007
                                                                                              CFF007
      ** CFF001 enhancement                                                                   CFF007
     D CFF001          S              1A                                                      CFF007
                                                                                              CFF007
      ** Premium                                                                              CFF007
     D SPREM           S             15A                                                      CFF007
                                                                                              CFF007
     D PSARD           S              6A                                                      CFF007
     D NewInst         S              1A                                                      CFF007
     D PRActn          S              1                                                       CFF007
     D PINKC           S              1A                                                      CFF007
     D PINKL           S              1A                                                      CFF007
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  P001 - Main Processing                                       *
      *                                                               *
      *  Calls:     SRP002 - Retrieve Transaction                     *
      *             SRP003 - Put a Transaction on the Main Details    *
      *                      Screen                                   *
      *             SRP004 - Process Screen: Main Details             *
      *                                                               *
      *****************************************************************
      *
     C                   EXSR      SRP002
      *
     C                   If        OKACTN = 'N' and OKTNBR = 'N'
     C                   Eval      PRET = 'E'
     C                   Else
     C                   EXSR      SRP003
     C                   Endif
      *
     C                   DOW       PRET = *blanks
     C                   EXSR      SRP004
     C                   ENDDO
      *
      ** Terminate program
      *
     C                   MOVE      '1'           *INLR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRP002 - Retrieve Transaction                                *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls:     FFOTCCRTV - FF OTC CCY options retrieve function  *
      *                                                               *
      *****************************************************************
      *
     C     SRP002        BEGSR
      *
     C                   CALLB     'FFOTCCRTV'
      *
      ** Return code
      *
     C                   PARM      *BLANK        ReturnCode
      *
      ** Inputs
      ** ------
      ** Mode = '*FRONT' (front office transaction interface)
      ** Mode = '      ' (not front office transaction interface) (6A)
      *
     C                   PARM      '      '      @@MODE            6
      *
      ** Response mode (1A)
      *
     C                   PARM      'S'           @@RSMD            1
      *
      ** Action Code (1A)
      *
     C                   PARM      PACT          SACTN
      *
      ** Front Office Transaction ID (20A)
      *
     C                   PARM      *Blanks       FOTRID           20
      *
      ** (Midas) Transaction Number (6A)
      *
     C                   PARM      WREF          STNBR
      *
      ** Module being called as linked enquiry (1A)
      *
     C                   PARM      'Y'           LinkEnq
      *
      ** Bank details ICD
      *
     C                   PARM                    SDBANK
      *
      ** General Ledger ICD
      *
     C                   PARM                    SDGELR
      *
      ** Multibranching indicator
      *
     C                   PARM                    BGMBIN
                                                                                              CAP166
      ** Transaction type                                                                     CAP166
                                                                                              CAP166
     C                   PARM      'OTCC'        TransType                                    CAP166
                                                                                              CAP166
      ** Outputs
      ** ~~~~~~~
      ***Instrument*Types***************************************************                  CFF007
      *
     C**********         PARM                    InstType                                     CFF007
      *
      ** (Current) transaction in file format
      *
     C                   PARM                    CurTranFil
      *
      ** (Current) Settlements in file format
      *
     C                   PARM                    CurSetFil
      *                                                                                       CFF007
      ** Instrument Types                                                                     CFF007
      *                                                                                       CFF007
     C                   PARM                    InstType                                     CFF007
      *
      ** OK - Action code (1A)
      *
     C                   PARM      *BLANK        OKACTN
      *
      ** OK - Transaction Number (1A)
      *
     C                   PARM      *BLANK        OKTNBR
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
      *
     C                   PARM      *ZERO         Idx               3 0
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRP003 - Put a Transaction on the Main Details Screen        *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls:     FFOTCCCVT - FF OTC conversion: file to screen     *
      *                         format                                *
      *                                                               *
      *****************************************************************
     C     SRP003        BEGSR
      *
      ** Call program to fill screen fields with data from TRANSD
      *
     C                   CALLB     'FFOTCCCVT'
      *
      ** Inputs
      ** ~~~~~~
     C                   PARM      *BLANKS       ReturnCode
      *
      ** Transaction in file format
      *
     C                   PARM                    CurTranFil
      *
      ***Settlement*details*in*file*format*****************************                       CFF007
      *
     C**********         PARM                    CurSetFil                                    CFF007
      *
      ** Instrument types
      *
     C                   PARM                    InstType
      * ICD                                                                                   CFF007
     C                   PARM                    SDBANK                                       CFF007
     C                   PARM                    SDDEAL                                       CFF007
     C                   PARM                    SDMMOD                                       CFF007
     C                   PARM                    SDPORT                                       CFF007
      *
      ** Outputs
      ** ~~~~~~~
      ** Transaction in screen format
      *
     C                   PARM                    NewTranScn
      *
      ***Transaction*Settlement*Details*in*screen*format***************                       CFF007
      *
     C**********         PARM                    NewCusScn                                    CFF007
      * Premium                                                                               CFF007
     C                   PARM                    SPREM                                        CFF007
      *
      ** Transaction Status
      *
     C                   PARM                    FFSTS            24
      ** CFF001 Enhancement                                                                   CFF007
     C                   PARM                    CFF001                                       CFF007
      ** CFF007 Enhancement                                                                   CFF007
     C                   PARM                    CFF007                                       CFF007
      *
     C                   EVAL      CustBrokFl = 'C'
      *
     C                   CALLB     'FFSETLCVT'
      *
      ** Outputs
      ** ~~~~~~~
      ** Return code (10A, returned to caller)
      *
     C                   PARM      *BLANKS       ReturnCode
      *
      ** Customer settlement instructions, screen format
      *
     C                   PARM                    NewCusScn
      *
      ** Broker settlement instructions, screen format
      *
     C                   PARM                    NewBrokScn
      *
      ** Inputs
      ** ~~~~~~
      ** Settlements in file format
      *
     C                   PARM                    CurSetFil
      *
      ** Customer/broker flag (1A)
      *
     C                   PARM                    CustBrokFl
      *
      ** Midas Transaction Number
      *
     C                   PARM                    STNBR
      *                                                                                       CFF007
      ** Instrument Currency                                                                  CFF007
      *                                                                                       CFF007
     C                   PARM                    ISCY                                         CFF007
      *
      ** Update 'Current' Deal with Deal in Screen Format
      *
     C                   MOVEL     NewTranScn    CurTranScn
     C                   MOVEL     NewCusScn     CurCusScn
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRP004 - Process Screen: Main Details                        *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls:     FFOTCCDSP - FF OTC Display                        *
      *                                                               *
      *****************************************************************
      *
     C     SRP004        BEGSR
      *
      ** Write/Read Display Screen
      *
     C                   RESET                   WriteOnly
     C                   RESET                   ReturnCode
     C                   CALLB     'FFOTCCDSP'
     C                   PARM      *BLANK        ReturnCode
      *
      ** Transaction (in Screen Format)
      *
     C                   PARM                    NewCusScn
     C                   PARM                    NewTranScn
      ** Premium                                                                              CFF007
     C                   PARM                    SPREM                                        CFF007
      *
      ** Transaction Status
      *
     C                   PARM                    FFSTS            24
      *
      ** Transaction (In Screen Format)
      *
     C                   PARM                    SDBANK
     C                   PARM                    SDGELR
     C                   PARM                    SDMMOD
      *
      ** Fields in Error
      *
     C                   PARM                    OKCusSet
     C                   PARM                    OKFlagsDS
      *
      ** Errors
      *
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warnings
      *
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Enabled Key & Detail fields
      *
     C                   PARM                    @EKYFD            1
     C                   PARM                    @EDTFD            1
      *
      ** Disable Function Keys
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KJ = Command Key 10 = Confirm Delete
      ** KP = Command Key 15 = BrowsE
      ** KT = Command Key 19 = Funding Info
      *
     C                   PARM                    @EINKG            1
     C                   PARM                    @EINKH            1
     C                   PARM                    @EINKJ            1
     C                   PARM                    @EINKP            1
     C**********         PARM                    @EINKT            1                          CFF007
      *
      ** Successful Insert Transaction
      *
     C                   PARM                    @SIDN             6
      *
      ** Output Parameters
      *
      ** Function Keys
      *
     C                   PARM                    @INKC             1
     C                   PARM                    @INKG             1
     C                   PARM                    @INKH             1
     C                   PARM                    @INKJ             1
     C                   PARM                    @INKL             1
     C                   PARM                    @INKP             1
     C**********         PARM                    @INKT             1                          CFF007
      *
      ** Write screen with no read indicator
      *
     C                   PARM                    WriteOnly
      ** CFF001 Enhancement                                                                   CFF007
     C                   PARM                    CFF001                                       CFF007
      ** CFF007 Enhancement                                                                   CFF007
     C                   PARM                    CFF007                                       CFF007
      *
      ** Reset Errors
      *
     C                   MOVE      *ALL'Y'       OKBrokSet
     C                   MOVE      *ALL'Y'       OKCusSet
     C                   MOVE      *ALL'Y'       OKFlagsDS
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
     C                   Select
     C                   When      @INKC = '1'
     C                   Eval      PRET = 'Q'
      *
     C                   When      @INKL = '1'
     C                   Eval      PRET = 'P'
                                                                                              CFF007
     C                   WHEN      CFF007 = 'Y'                                               CFF007
     C                             AND BGN4ST = 'Y'                                           CFF007
     C                             AND  @INKC <> '1'                                          CFF007
     C                             AND  @INKL <> '1'                                          CFF007
     C                   EXSR      SRPBSCN                                                    CFF007
      *
     C                   Endsl
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRP005 - Initialize Field Status on Main Details Screen      *
      *                                                               *
      *  Called By: *INZSR - Initial Processing                       *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
     C     SRP005        BEGSR
      *
      ** Disable Key & Details Fields on Main Details Screen
      *
     C                   MOVEL     'N'           @EKYFD
     C                   MOVEL     'N'           @EDTFD
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRP006 - Initialize Function Key Status in Main Detials      *
      *           Screen                                              *
      *                                                               *
      *  Called By: *INZSR - Initial Processing                       *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
     C     SRP006        BEGSR
      *
      ** Enable/Disable Function Keys on Main Details Screen
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KJ = Command Key 10 = Confirm Delete
      ** KP = Command Key 15 = Browse
      *
     C                   MOVEL     'N'           @EINKG
     C                   MOVEL     'N'           @EINKH
     C                   MOVEL     'N'           @EINKJ
     C                   MOVEL     'N'           @EINKP
      *
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  CFF007
      *****************************************************************                       CFF007
      *                                                               *                       CFF007
      *  SRPBSCN - Process Private Banking Screen                     *                       CFF007
      *                                                               *                       CFF007
      *  Called By: SRP004                                            *                       CFF007
      *                                                               *                       CFF007
      *  Calls:     FFOTCC2DP - FF OTC PB Fields Display              *                       CFF007
      *                                                               *                       CFF007
      *****************************************************************                       CFF007
      *                                                                                       CFF007
     C     SRPBSCN       BEGSR                                                                CFF007
                                                                                              CFF007
     C     PRET          DOWEQ     *BLANKS                                                    CFF007
      **  Display Screen                                                                      CFF007
                                                                                              CFF007
     C                   RESET                   ReturnCode                                   CFF007
     C                   CALLB     'FFOTCC2DP'                                                CFF007
     C                   PARM                    ReturnCode                                   CFF007
      ** Transaction (in Screen Format)                                                       CFF007
     C                   PARM                    NewTranScn                                   CFF007
      ** Premium                                                                              CFF007
     C                   PARM                    SPREM                                        CFF007
      ** New Intrument type                                                                   CFF007
     C                   PARM                    NewInst                                      CFF007
                                                                                              CFF007
     C                   PARM                    SDBANK                                       CFF007
     C                   PARM                    SDMMOD                                       CFF007
     C                   PARM                    SDGELR                                       CFF007
      ** Fields in Error                                                                      CFF007
     C                   PARM                    OKFlagsDS                                    CFF007
      ** Errors                                                                               CFF007
     C                   PARM                    FldNameArr                                   CFF007
     C                   PARM                    MsgIdArr                                     CFF007
     C                   PARM                    MsgDtaArr                                    CFF007
      ** Warnings                                                                             CFF007
     C                   PARM                    WFldNamArr                                   CFF007
     C                   PARM                    WMsgIdArr                                    CFF007
     C                   PARM                    WMsgDtaArr                                   CFF007
     C                   PARM                    PRActn                                       CFF007
      ** Function Keys                                                                        CFF007
     C                   PARM                    PINKC                                        CFF007
     C                   PARM                    PINKL                                        CFF007
                                                                                              CFF007
     C                   SELECT                                                               CFF007
     C     PINKC         WHENEQ    '1'                                                        CFF007
     C                   MOVEL     'Q'           PRET                                         CFF007
                                                                                              CFF007
     C     PINKL         WHENEQ    '1'                                                        CFF007
     C                   MOVEL     'P'           PRET                                         CFF007
     C                   ENDSL                                                                CFF007
                                                                                              CFF007
     C                   ENDDO                                                                CFF007
                                                                                              CFF007
     C     PINKL         IFEQ      '1'                                                        CFF007
     C                   MOVE      *BLANKS       PRET                                         CFF007
     C                   ENDIF                                                                CFF007
                                                                                              CFF007
     C                   ENDSR                                                                CFF007
      *****************************************************************                       CFF007
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initial Processing                                  *
      *                                                               *
      *  Calls:     AOBANKR0 - Bank ICD Access Object                 *
      *             AOGELRR0 - General Ledger Details Access Object   *
      *             AOMMODR0 - Midas Module Access Object             *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Access Bank details via access program
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Get the General Ledger ICD
      *
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      ** Get the module flags
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
                                                                                              CFF007
      ** Determine if CFF007 is installed                                                     CFF007
                                                                                              CFF007
     C                   CALLB     'AOSARDR0'                                                 CFF007
     C                   PARM      *BLANKS       @RTCD                                        CFF007
     C                   PARM      '*VERIFY'     @OPTN                                        CFF007
     C                   PARM      'CFF007'      PSARD                                        CFF007
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFF007
                                                                                              CFF007
     C     @RTCD         IFEQ      *BLANKS                                                    CFF007
     C                   MOVE      'Y'           CFF007                                       CFF007
     C                   ELSE                                                                 CFF007
     C                   MOVE      'N'           CFF007                                       CFF007
     C                   ENDIF                                                                CFF007
                                                                                              CFF007
      ** Determine if CFF001 is installed                                                     CFF007
                                                                                              CFF007
     C                   CALLB     'AOSARDR0'                                                 CFF007
     C                   PARM      *BLANKS       @RTCD                                        CFF007
     C                   PARM      '*VERIFY'     @OPTN                                        CFF007
     C                   PARM      'CFF001'      PSARD                                        CFF007
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFF007
                                                                                              CFF007
     C     @RTCD         IFEQ      *BLANKS                                                    CFF007
     C                   MOVE      'Y'           CFF001                                       CFF007
     C                   ELSE                                                                 CFF007
     C                   MOVE      'N'           CFF001                                       CFF007
     C                   ENDIF                                                                CFF007
      *
      ** Set the transaction typed field used by the database updater
      *
     C                   EVAL      TransType = OTCCurr
      *
      ** Start on Main Details Screen
      ** Initialise the write-without-read flag
      *
     C                   EVAL      WriteOnly = 'N'
      *
      ** Entry Parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    PACT              1
     C                   PARM                    PREF              6 0
     C                   PARM                    PRET              1
      *
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
      *
     C/COPY ZACPYSRC,DBFIELDS
      *
      ** Initialize field and function key status on main details screen
      *
     C                   MOVE      PREF          WREF              6
     C                   EXSR      SRP005
     C                   EXSR      SRP006
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
     C/COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
