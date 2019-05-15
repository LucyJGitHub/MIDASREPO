     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Invalid exchange-traded FOs repair')          *
      *****************************************************************
      *                                                               *
      *  Midas - Futures and Options Module                           *
      *                                                               *
      *  FFEXTRRPR - Invalid FF exchange-traded transactions repair   *
      *                                                               *
      *  Function:  This function allows invalid exchange traded      *
      *             futures and options to be repaired and            *
      *             applied to the Midas database.                    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CAP208             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG26918           Date 19Jan09               *
      *                 CAP191             Date 26Nov09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 247980             Date 22May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG9617            Date 14Dec05               *
      *                 CER001             Date 25Apr05               *
      *                 BG9185             Date 08Nov05               *
      *                 CGL014             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 208635             Date 16Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 198102             Date 14Feb02               *
      *                 CAS002             Date 14Jan02               *
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CFF007             Date 13Feb01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 191171             Date 26Mar01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 166907             Date 27Dec99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP014             Date 10Dec99               *
      *                 CAP013             Date 07Sep99               *
      *                 CAP011             Date 07Sep99               *
      *                 168345             Date 14Oct99               *
      * Midas DBA 3.01 Patch E ---------------------------------------*
      *                 170520             Date 19Nov99               *
      * Midas DBA 3.00 -----------------Base--------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 CAP006             Date 19Mar99               *
      *                 147775             Date 16Nov98               *
      *                 CAP004  *CREATE    Date 01Jul98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP208 - F&O Market Instrument API (Recompile)               *
      *  BUG26918 - Extra projects found in Drop 1 sources            *
      *           - Physically delete codes of CAP201 and CSC022      *
      *  CAP191 - MQ Enabling of FUND and EXTR APIs (Recompile)       *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  247980 - Settlement defaults are not applied when commission *
      *           amount not equal to zero.                           *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG9617- Action 'N' updates the database file even with      *
      *           Errors                                              *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  BG9185 - Correction to CGL029 (Recompile)                    *
      *  CGL014 - Collaterals Processing                              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  208635 - Allow broker if S01457 is installed.                *
      *  198102 - Warning messages (if any) are not processed if no   *
      *           error messages encountered.                         *
      *  CAS002 - Hedge Strategy/Linkage (Recompile)                  *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CFF007 - Futures and Options Enhancement for Private Banking *
      *  191171 - Window does not appear if action is D               *
      *  166907 - Display 'Deal No. 999999 successfully inserted.'    *
      *           in the correct screen.                              *
      *  CAP014 - Repair function enhancements                        *
      *  CAP013 - Allow access by Midas transaction ID if not insert  *
      *  CAP011 - Substitution of Midas database flds for externl i/fs*
      *  168345 - Prevent two users from accessing same transaction   *
      *           in repair screen at the same cycle, and converting  *
      *           it into two different Midas Deal No.s  .            *
      *           Second user should not be allowed to repair the tran-
      *           saction and convert it into a another Midas Deal.   *
      *  170520 - Recompile over changed TRANSD file                  *
      *  CPL002 - Midas-Plato Interface (Recompile)                   *
      *  CAP006 - Check for deal being updated by another workstation *
      *  147775 - General FF API fixes - (Pre-release unnanotated)    *
      *  CAP004 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Transaction error details
     FZATRNERRL0IF   E           K DISK    INFSR(*PSSR)
 
      ** Invalid exchange-traded transactions by timestamp and
      ** front-office ID
     FFFIEXTRL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FFIEXTRD0 : FFIEXTRX0)
 
      ** Invalid exchange-traded transactions by front-office ID
      ** and timestamp
     FFFIEXTRL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** Invalid broker settlement instructions by timestamp and
      ** front-office ID and front-office ID and timestamp
     FFFIBSETL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FFIBSETD0:FFIBSETX0)
     FFFIBSETL1 UF   E           K DISK    INFSR(*PSSR) COMMIT
 
      ** Invalid customer settlement instructions by timestamp and
      ** front-office ID and front-office ID and timestamp
     FFFICSETL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FFICSETD0:FFICSETX0)
     FFFICSETL1 UF   E           K DISK    INFSR(*PSSR) COMMIT
                                                                                              CSC011
      ** API invalid log file                                                                 CSC011
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR) USROPN                                CSC011
     F                                     COMMIT                                             CSC011
      *                                                                                       CER001
      ** Invalid File                                                                         CER001
      *                                                                                       CER001
     FFFIETLX1L0UF   E           K DISK    RENAME(FFIETLXD6:RTVIDX1)                          CER001
     F                                     PREFIX(L:1)                                        CER001
     F                                     INFSR(*PSSR)                                       CER001
     F                                     USROPN                                             CER001
     F                                     COMMIT                                             CER001
     F                                                                                        CER001
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,FFEXTRR012
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the FF standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
     D/COPY QWINDSRC,FFTRANSDTA
                                                                                              CER001
     D DATALUX         DS          1024                                                       CER001
     D  #1FLD1A                1      6  0                                                    CER001
      *                                                                                       CER001
     D  #1ISTT                 1      5                                                       CER001
     D  #1TNBR                 6     11                                                       CER001
     D  #1MRKT                12     13                                                       CER001
     D  #1FOTR                14     33                                                       CER001
     D  #1TMST                34     59Z                                                      CER001
     D  #1DEXT                60     60                                                       CER001
 
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
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D @EI             S              1    DIM(60) INZ(*all'Y')
 
      * Transaction Details - File Format
      * ~~~~~~~~~~~ ~~~~~~~   ~~~~ ~~~~~~
 
     D CurTranFil    E DS                  EXTNAME(TRANSD)
      * Current transaction in file format
 
     D NewTranFil    E DS                  EXTNAME(FFVTRANPD)
      * Valid transaction in file format
     D                                     PREFIX(V)
 
      * Transaction Details - Screen Format
      * ~~~~~~~~~~~ ~~~~~~~   ~~~~~~ ~~~~~~
 
     D CurTranScn    E DS                  EXTNAME(FFEXTRPD)
      * Current transaction in screen format
     D                                     PREFIX(@)
 
     D NewTranScn    E DS                  EXTNAME(FFEXTRPD)
      * New transaction in screen format
 
      * Transaction Details - OK Flags
      * ~~~~~~~~~~~ ~~~~~~~   ~~~~~~~~
 
     D OKTransDet    E DS                  EXTNAME(FFEEXTRPD)
      ** External data structure for transaction details OK flags
 
      * Customer and Broker Settlement Details - File Format
      * ~~~~~~~~ ~~~ ~~~~~~ ~~~~~~~~~~ ~~~~~~~   ~~~~ ~~~~~~
 
     D CurTrstFil    E DS                  EXTNAME(TRSETD)
      * Settlements in file format
     D                                     PREFIX(ST)
 
     D NewTrstFil    E DS                  EXTNAME(FFVSETLPD) PREFIX(VS)
      ** Valid settlement instructions; prefixed with VS for valid
      ** settlemnts.
 
      * Customer Settlement Details - Screen Format
      * ~~~~~~~~ ~~~~~~~~~~ ~~~~~~~   ~~~~~~ ~~~~~~
 
     D NewCuStScn    E DS                  EXTNAME(FFCSETPD)
      ** New Customer Settlement details in screen format
 
     D CurCuStScn    E DS                  EXTNAME(FFCSETPD) PREFIX(@)
      ** Current Customer Settlement Details in Screen Format
 
 
      * Broker Settlement Details - Screen Format
      * ~~~~~~ ~~~~~~~~~~ ~~~~~~~   ~~~~~~ ~~~~~~
 
     D NewBrStScn    E DS                  EXTNAME(FFBSETPD)
      ** New broker settlement details in screen format
 
     D CurBrStScn    E DS                  EXTNAME(FFBSETPD)
      ** Current broker settlement details in screen format
     D                                     PREFIX(@)
 
 
      * Settlement Details - OK Flags
      * ~~~~~~~~~~ ~~~~~~~   ~~ ~~~~~
 
     D OKBrokSet     E DS                  EXTNAME(FFEBSETPD)
      ** External data structure for broker settlement flags
 
     D OKCustSet     E DS                  EXTNAME(FFECSETPD)
      ** External data structure for customer settlement flags
 
 
     D MarketDet     E DS                  EXTNAME(MARKT) PREFIX(MK)
      ** Market details DS (MK=MarKet)
 
     D InstType      E DS                  EXTNAME(INTYPD)  PREFIX(IT)
      ** Instrument types
 
     D ExtData       E DS                  EXTNAME(FFETEXPD)
      * FF Extension data (Exchange Traded) - File (D/B) format
 
 
      ** Standing Data files
      ** ~~~~~~~~ ~~~~ ~~~~~
      ** passed as data structures to lower level modules.
      **
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank Details
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** Modules details
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CFF007
     D  SLCD         E                     EXTFLD(LCD)                                        CFF007
      ** Switchable Features Details                                                          CFF007
                                                                                              CFF007
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** Branch Details
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** General Ledger ICD
 
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)                      CPM003
     D  #ACCD1       E                     EXTFLD(QQACCD)                                     CGL029
     ** Trading details
 
     D SDPORT        E DS                  EXTNAME(SDPORTPD)                    CPM003
      ** Portfolio Management ICD
 
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D  #ACCD2       E                     EXTFLD(QQACCD)                                     CGL029
     ** Retail ICD
 
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
     D  #ACCD3       E                     EXTFLD(QQACCD)                                     CGL029
      ** Dealing ICD
 
     D SDFODA        E DS                  EXTNAME(SDFODAPD)
     D  #ACCD4       E                     EXTFLD(QQACCD)                                     CGL029
      ** Futures and Options ICD
 
     D SDAPI         E DS                  EXTNAME(SDAPIPD)                     CAP011
      ** EXTERNAL DS FOR API ICD                                                CAP011
                                                                                CAP011
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short data structure for access programs
 
      ** Data structure for data area SC24X7                                                  CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
                                                                                              CSC011
      ** Data structure for data area SDSTAT                                                  CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
                                                                                              CSC011
     D WTmpFldNamArr   S             10A   DIM(ArrayMax)                                      198102
      ** Temporary Field arrays                                                               198102
                                                                                              198102
     D WTmpMsgIDArr    S                   DIM(ArrayMax) LIKE(#MsgID)                         198102
      ** Temporary message ID arrays                                                          198102
                                                                                              198102
     D WTmpMsgDtaArr   S                   DIM(ArrayMax) LIKE(#MsgData)                       198102
      ** Temporary message Data arrays                                                        198102
                                                                                              198102
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **   Timestamp selected
     D @TMESTPSEL      S             26Z
 
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
 
      ** -------------------------------------------------------------------
      ** Fields for getting the starting field number from file (parameters
      ** to ZAGETFLDNO, plus the offset to the requested field).
     D Format          S             10A   INZ('FFEXTRPD')
 
     D Field           S             10A   INZ('SACTN')
 
     D FieldNo         S              5P 0
 
     D FldOffset       S              5P 0
 
      ** End of fields for getting starting field number
      ** -------------------------------------------------------------------
 
      ** The current trading date
     D CTDATE          S                   LIKE(BJRDNB)
 
      ** Enhanced OTCs feature flag (not used, but passed as a blank PARM)
     D CFF001          S              1A
                                                                                              CFF007
      ** CFF007 enhancement                                                                   CFF007
     D CFF007          S              1A                                                      CFF007
                                                                                              CFF007
      ** PB customer indicator - broker                                                       CFF007
     D PPBBFLG         S              1A                                                      CFF007
                                                                                              CFF007
      ** PB customer indicator - customer                                                     CFF007
     D PPBCFLG         S              1A                                                      CFF007
                                                                                              CFF007
      ** Switchable feature                                                                   CFF007
     D PSARD           S              6A                                                      CFF007
 
      ** --- Parameters for ZATRNRTV ---------------------------------------------------------------
      ** Module ID
     D Module          S              2A   INZ('FF')
 
      ** Transaction type (dummy field as it is not needed for FF)
     D DummyTRTY       S              1A
      ** --- End of parameters for ZATRNRTV --------------------------------------------------------
 
      ** Customer/Broker Flag (B = Broker, C = Customer)
     D CustBrokFl      S              1A
 
      ** Customer or broker number
     D*CustBrokNo      S              6S 0                                                    CSD027
     D CustBrokNo      S              6                                                       CSD027
 
      ** Flags to indicate that the broker and/or customer settlements
      ** are in error.
     D BrokSetErr      S              1A   INZ('N')
     D CustSetErr      S              1A   INZ('N')
 
      ** Flags to indicate that the broker and/or customer charges and
      ** commission fields are in error.
     D BrokCCErr       S              1A   INZ('N')
     D CustCCErr       S              1A   INZ('N')
 
      ** Flag to indicate that the FFEXTRRTV is not being called
      ** as a linked enquiry.
     D LinkEnq         S              1A   INZ('N')
 
      ** Customer/Broker Flag (Y = Broker, N = Customer)
     D BrokerFlag      S              1A
 
      ** Flag to indicate that the transaction number was automatically
      ** generated
     D AutoTran        S              1A   INZ('N')
 
      ** Start position in error flag array of the broker settlement
      ** instructions flags
     D BSetStart       S              5P 0
 
      ** Error flag array start position of the customer settlement
      ** instructions flags
     D CSetStart       S              5P 0
 
      ** Record length
     D RecordLen       S              5P 0
 
      ** File name (for UTGETRCDLN)
     D FileName        S             10A
 
      ** File library (for UTGETRCDLN)
     D FileLib         S             10A   INZ('*LIBL')
                                                                                              CSC011
      ** CSC011 enhancement                                                                   CSC011
     D CSC011          S              1A   INZ('N')                                           CSC011
                                                                                              CSC011
      ** Work field for Message type                                                          CSC011
     D WMTYP           S                   LIKE(APMTYP)                                       CSC011
                                                                                              CSC011
      ** Define parameters for AOSARDR0                                                       CSC011
     D PRTCD           S              7A                                                      CSC011
     D POPTN           S              7A                                                      CSC011
 
      ** General index variables                                                              198102
     D WIx             S              3P 0                                                    198102
     D WIy             S              3P 0                                                    198102
                                                                                              198102
      ** Variables to save previous values of fields                                          198102
     D WPrvSCOPR       S                   LIKE(SCOPR)                                        198102
     D WPrvSPTFR       S                   LIKE(SPTFR)                                        198102
      *                                                                                       CGL029
     D CGL014          S              1                                                       CGL014
                                                                                              CGL014
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
                                                                                              198102
      ** New Futures and Options in Screen Format                                             CER001
     D NwDlScnFmt    E DS                  EXTNAME(FFETRXPD)                                  CER001
                                                                                              198102
      ** New Futures and Options in File Format                                               CER001
     D NwDlFilFmt    E DS                  EXTNAME(FFVTNLX1PD)                                CER001
                                                                                              CER001
      ** Current Futures and Options in File Format (FF)                                      CER001
     D PcDlFilFmt    E DS                  EXTNAME(FFTRX2L0)                                  CER001
                                                                                              CER001
     D PRetnCode       S                   LIKE(RetCodeIn)                                    CER001
     D PActnCode       S                   LIKE(ActionCode)                                   CER001
     D PDatalux        S                   LIKE(DATALUX)                                      CER001
     D W0RTN           S              7                                                       CER001
     D PFind           S              1                                                       CER001
      ** Define parameters for FFEXTR2RP                                                      CER001
      *                                                                                       CER001
                                                                                              CER001
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,FFEXTRR001
     D SOTMESTMP       S             26Z                                                      CER001
     D SOFOTRANID      S             20                                                       CER001
     D SISPT           S              1                                                       CER001
     D SISTT           S              5                                                       CER001
 
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
 
      /COPY WNCPYSRC,FFEXTRR002
 
      * Do screen: browse invalid transactions
     C     @SCRN         IFEQ      'B'
     C                   EXSR      SCRN@B
     C                   END
 
      /COPY WNCPYSRC,FFEXTRR003
 
      * Read next browse subfile record
     C     @SCRN         IFEQ      'R'
     C                   EXSR      RDNBRW
     C                   ENDIF
 
      /COPY WNCPYSRC,FFEXTRR004
 
      * Do while screen: main details
     C     @SCRN         DOWEQ     'M'
     C                   EXSR      SCRN@M
     C                   ENDDO
 
      /COPY WNCPYSRC,FFEXTRR005
 
      * Settlement details processing
     C     @SCRN         DOWEQ     'S'
     C                   EXSR      SCRN@S
     C                   ENDDO
 
      /COPY WNCPYSRC,FFEXTRR006
 
     C                   IF        @SCRN = 'L'                                                CER001
     C                   EXSR      SRLUXW                                                     CER001
     C                   ENDIF                                                                CER001
      * Screen: window
     C     @SCRN         IFEQ      'W'
     C                   EXSR      WINDOW
     C                   ENDIF
 
      /COPY WNCPYSRC,FFEXTRR007
 
      * Screen: confirmation of input
     C     @SCRN         IFEQ      'C'
     C                   EXSR      SCRN@C
     C                   ENDIF
 
      /COPY WNCPYSRC,FFEXTRR008
 
      * Do file updates
     C     @SCRN         IFEQ      'U'
     C                   EXSR      UPDATS
     C                   ENDIF
 
      /COPY WNCPYSRC,FFEXTRR009
 
      * Terminate program
     C     @SCRN         IFEQ      'T'
     C                   MOVE      '1'           *INLR
     C                   ENDIF
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,FFEXTRR010
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@B - BROWSE INVALID TRANSACTIONS
      *****************************************************************
     C     SCRN@B        BEGSR
      *
      * Reset read next browse subfile record
      *
     C                   MOVEL     *BLANK        @RDNB             1
 
      * Build browse subfile
     C                   CALLB     'FFEXTRRPB'
      * Inputs
      * ------
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      * Build subfile
     C                   PARM      'Y'           @BDSFL            1
      * Read subfile record
     C                   PARM      *BLANK        @RDSFL            1
      * Error in update of previous deal                                        CAP006
     C                   PARM                    @ERRUP            1            CAP006
      *                                                                         CAP006
      * Outputs
      * -------
      * Error message
     C                   PARM      *BLANK        @ERRMS            7
      * Option selected
     C                   PARM                    @OPSEL            1
      * Action selected
     C                   PARM                    @ACSEL            1
      * FO transaction ID selected
     C                   PARM                    @FOTRANSEL       20
      * Timestamp of transaction selected
     C                   PARM                    @TMESTPSEL
      * Market centre of transaction selected
     C                   PARM                    SMRKT
      * Command keys
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
      *                                                                         166907
      ** Successfully Inserted Deal Number                                      166907
      *                                                                         166907
     C                   PARM                    @SIDN             6            166907
                                                                                              CSC011
      ** Enhancement CSC011                                                                   CSC011
     C                   PARM                    CSC011                                       CSC011
 
 
      * If F3 or F12 taken in browse, or error message, end program
     C     @INKC         IFEQ      '1'
     C     @INKL         OREQ      '1'
     C     @ERRMS        ORNE      *BLANK
     C                   EXSR      ENDP
     C                   GOTO      ESCRN@B
     C                   END
 
      * Read next browse subfile record
     C                   MOVE      'Y'           @RDNB
     C                   MOVE      'R'           @SCRN
      *
     C     ESCRN@B       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDNBRW - READ NEXT BROWSE SUBFILE RECORD
      *****************************************************************
     C     RDNBRW        BEGSR
      *
      * Read next subfile record
     C                   CALLB     'FFEXTRRPB'
      * Inputs
      * ------
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      * Build subfile
     C                   PARM      *BLANK        @BDSFL            1
      * Read subfile record
     C                   PARM      'Y'           @RDSFL            1
      * Error in update of previous deal                                        CAP006
     C                   PARM                    @ERRUP            1            CAP006
      *                                                                         CAP006
      * Outputs
      * -------
      * Error message
     C                   PARM      *BLANK        @ERRMS            7
      * Option selected
     C                   PARM      *BLANK        @OPSEL            1
      * Action selected
     C                   PARM      *BLANK        @ACSEL            1
      * FO transaction ID selected
     C                   PARM      *BLANK        @FOTRANSEL       20
      * Timestamp of transaction selected
     C                   PARM                    @TMESTPSEL
      * Market centre of transaction selected
     C                   PARM      *BLANK        SMRKT
      * Command keys
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
      *                                                                         166907
      ** Successfully Inserted Deal Number                                      166907
      *                                                                         166907
     C                   PARM                    @SIDN             6            166907
                                                                                              CSC011
      ** Enhancement CSC011                                                                   CSC011
     C                   PARM                    CSC011                                       CSC011
 
 
      * If F3 taken within invalid transaction deletion function,
      * End program
     C     @INKC         IFEQ      '1'
     C                   EXSR      ENDP
     C                   GOTO      ERDNBRW
     C                   END
 
      * If invalid transaction read from subfile
     C     @OPSEL        IFNE      *BLANK
 
      * Blank the main details screen, saving the market field to prevent
      * erroneous error messages appearing.
     C                   EVAL      @SMRKT = SMRKT
     C                   MOVEL     *BLANK        NewTranScn
     C                   EVAL      SMRKT = @SMRKT
     C                   MOVEL     *BLANK        FFSTS
 
      * Reset errors
     C                   MOVE      *ALL'Y'       OKTransDet
     C                   MOVE      *ALL'Y'       OKBrokSet
     C                   MOVE      *ALL'Y'       OKCustSet
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * Retrieve transaction details
      *
     C                   MOVEL     @ACSEL        SACTN
     C                   MOVEL     @FOTRANSEL    FOTRID
     C*******************MOVEL     '*FRONT'      @@MODE                         CAP013
      *                                                                         CAP013
      * Make sure Invalid transaction's  details are passed to 'Retrieve'       CAP013
      * module for SPF checking .                                               CAP013
      *                                                                         CAP013
     C     ZATRNKX0      CHAIN     FFIEXTRL0                          99        CAP013
      *                                                                         CAP013
      * Set retrieve mode to '*FRONT' (Access using Front Office ID)            CAP013
      *  if insert                                                              CAP013
      *  if not insert and Midas transaction ID is not present                  CAP013
      * Otherwise                                                               CAP013
      *  Set retrieve mode to blank  (Access using Midas transaction ID).       CAP013
      *                                                                         CAP013
     C     SACTN         IFEQ      'I'                                          CAP013
     C                   MOVEL     '*FRONT'      @@MODE                         CAP013
     C                   ELSE                                                   CAP013
     C     STNBR         IFEQ      *BLANK                                       CAP013
     C                   MOVEL     '*FRONT'      @@MODE                         CAP013
     C                   ELSE                                                   CAP013
     C                   MOVEL     '      '      @@MODE                         CAP013
     C                   ENDIF                                                  CAP013
     C                   ENDIF                                                  CAP013
      *                                                                         CAP013
     C                   EXSR      RTVTRN
 
      * If transaction details were retrieved,
      * put the transaction on the main details screen
     C     RECI          IFNE      *BLANK
     C     SACTN         ANDNE     'I'
     C                   EXSR      PUTD@M
     C                   END
 
      * Now overwrite the fields on the main details screen with those
      * on the invalid transactions file (except for the Midas transaction
      * number and Midas associated transaction number retrieved above
      * using the front office transaction and associated transaction IDs).
      * Access invalid transaction with timestamp and front office
      * transaction ID.
     C                   MOVEL     STNBR         ##STNBR           6
     C     ZATRNKX0      CHAIN     FFIEXTRL0                          99
     C     RECI          IFNE      *BLANK
     C     SACTN         ANDNE     'I'
     C                   MOVEL     ##STNBR       STNBR
     C                   END
 
     C                   IF        ULX604  = 'Y'                                              CER001
     C     ZATRNKX0      CHAIN     RTVIDX1                                                    CER001
     C                   EVAL      #1DEXT  = 'Y'                                              CER001
     C                   ENDIF                                                                CER001
      * Access invalid transaction settlement instructions
 
      * broker...
     C                   CLEAR                   NewBrStScn
     C     ZATRNKX0      CHAIN     FFIBSETX0                          99
 
      * ... and customer
     C                   CLEAR                   NewCuStScn
     C     ZATRNKX0      CHAIN     FFICSETX0                          99
      *                                                                         CAP011
      * If transaction details were retrieved and this is an amendment          CAP011
      * Do data substitution if the substitution character is present           CAP011
      *                                                                         CAP011
     C     RECI          IFNE      *BLANK                                       CAP011
     C     SACTN         ANDEQ     'A'                                          CAP011
     C     GHSUBS        ANDNE     *BLANK                                       CAP011
     C     GHSUBS        SCAN      NewTranScn                             99    CAP011
     C  N99GHSUBS        scan      NewBrStScn                             99    CAP011
     C  N99GHSUBS        scan      NewCuStScn                             99    CAP011
     C     *IN99         IFEQ      *ON                                          CAP011
     C                   EXSR      TDtDtaSubs                                   CAP011
     C                   END                                                    CAP011
     C                   END                                                    CAP011
 
      * If action code, or transaction number were NOT OK
      * blank out action code so that the input cannot proceed
      *
     C     OKACTN        IFEQ      'N'
     C     OKTNBR        OREQ      'N'
     C                   MOVEL     *BLANK        SACTN
     C                   END
      *
      * Send the transactions error messages to the main details screen
      *
     C                   EXSR      SNDM@M
      *
      * GO TO MAIN DETAILS SCREEN
      *
     C                   MOVE      'M'           @SCRN
      *
      * ELSE IF NO INVALID transaction READ FROM SUBFILE
      *
     C                   ELSE
      *
      * GO TO BROWSE SCREEN
      *
     C                   MOVE      'B'           @SCRN
     C                   END
      *
     C     ERDNBRW       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SNDM@M - SEND A MESSAGE TO MAIN DETAILS SCREEN
      *****************************************************************
     C     SNDM@M        BEGSR
 
     C                   Z-ADD     Idx           E                 3 0
      *
      ** If there are fundamental errors in this transaction
      ** Identify this fact.
      *
     C     OKACTN        IFEQ      'N'
     C     OKTNBR        OREQ      'N'
     C                   ADD       1             E
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     'APM0110'     MsgIdArr(E)
     C                   ENDIF
      *
      ** Initialize error indicators
      *
     C                   MOVE      *ALL'Y'       @EI
     C                   MOVEA     OKTransDet    @EI
 
      ** Read error messages for transaction
     C     ZATRNKD0      SETLL     ZATRNERRD0
     C     ZATRNKD0      READE     ZATRNERRD0                             99    *
 
      ** Add error message to array passed to detail screen
      ** and set OK flag for field to 'N'
     C     *IN99         DOWEQ     '0'
      *                                                                                       CER001
      ** Do not display LUX related error messages in this screen                             CER001
      *                                                                                       CER001
     C                   IF        ULX604 <> 'Y' or                                           CER001
     C                             (ULX604 = 'Y' and                                          CER001
     C                             %Subst(ABMSGID:1:2) <> 'ER')                               CER001
 
     C                   ADD       1             E
     C                   MOVEL     ABFIELDNAM    FldNameArr(E)
     C                   MOVEL     ABMSGID       MsgIdArr(E)
     C                   Z-ADD     ABFIELDID     F                 3 0
     C                   SUB       FldOffset     F
     C     F             IFLT      1
     C     F             ORGT      60
     C                   Z-ADD     1             F
     C                   END
     C                   MOVE      'N'           @EI(F)
     C                   ENDIF                                                                CER001
     C     ZATRNKD0      READE     ZATRNERRD0                             99    *
     C                   ENDDO
 
      ** Put the extracted OK flags into the relevant OK flags data
      ** structures.
     C                   MOVEA     @EI           OKTransDet
     C                   MOVEA     @EI(BSetStart)OKBrokSet
     C                   MOVEA     @EI(CSetStart)OKCustSet
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@M - PROCESS SCREEN: MAIN DETAILS
      *****************************************************************
 
     C     SCRN@M        BEGSR
 
      * Issue rollback to clear any possible updates in window function
     C     BGWDPR        IFEQ      'Y'
     C                   ROLBK
     C                   END
 
      * Reset the transaction-number-automatically-generated flag
     C                   RESET                   AutoTran
 
      *
      * Enable/disable detail fields on main details screen
      * if changes to the data are allowed                                      CAP014
      * (key fields = action code & deal number; detail fields = rest)
      * (Action code can only be 'I', 'A', or 'D')
      *
     C     SACTN         IFEQ      'I'
     C     @OPSEL        ANDEQ     'U'                                          CAP014
     C     SACTN         OREQ      'A'
     C     @OPSEL        ANDEQ     'U'                                          CAP014
     C                   MOVEL     'Y'           @EDTFD
     C                   ELSE
     C                   MOVEL     'N'           @EDTFD
     C                   END
      *
      * KJ = COMMAND KEY 10 = CONFIRM DELETE
      *
     C     SACTN         IFEQ      'D'
     C                   MOVEL     'Y'           @EINKJ
     C                   ELSE
     C                   MOVEL     'N'           @EINKJ
     C                   END
 
      * Write/read display screen
     C                   RESET                   ReturnCode
     C                   CALLB     'FFEXTRDSP'
     C                   PARM                    ReturnCode
      * TRANSACTION (IN SCREEN FORMAT)
     C                   PARM                    NewBrStScn
     C                   PARM                    NewCuStScn
     C                   PARM                    NewTranScn
      * TRANSACTION STATUS
     C                   PARM                    FFSTS            24
      * ICD
     C                   PARM                    SDBANK
     C                   PARM                    SDGELR
     C                   PARM                    SDMMOD
      * FIELDS IN ERROR
     C                   PARM                    OKBrokSet
     C                   PARM                    OKCustSet
     C                   PARM                    OKTransDet
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      * ENABLED KEY & DETAIL FIELDS
     C                   PARM      'N'           @EKYFD            1
     C                   PARM                    @EDTFD            1
      * ENABLED FUNCTION KEYS
      * KG = COMMAND KEY 07 = READ PREVIOUS
      * KH = COMMAND KEY 08 = READ NEXT
      * KJ = COMMAND KEY 10 = CONFIRM DELETE
      * KP = COMMAND KEY 15 = BROWSE
     C                   PARM      'N'           @EINKG            1
     C                   PARM      'N'           @EINKH            1
     C                   PARM                    @EINKJ            1
     C                   PARM      'N'           @EINKP            1
      *
      * SUCCESFUL INSERT TRANSACTION
     C                   PARM                    @SIDN             6
 
      * OUTPUT PARAMETERS
      * -----------------
      * FUNCTION KEYS
     C                   PARM                    @INKC             1
     C                   PARM                    @INKG             1
     C                   PARM                    @INKH             1
     C                   PARM                    @INKJ             1
     C                   PARM                    @INKL             1
     C                   PARM                    @INKP             1
      * Write screen with no read indicator
     C                   PARM      'N'           WriteOnly
      ** CFF007 enhancement                                                                   CFF007
     C                   PARM                    CFF007                                       CFF007
 
 
      * RESET ERRORS
     C                   MOVE      *ALL'Y'       OKBrokSet
     C                   MOVE      *ALL'Y'       OKCustSet
     C                   MOVE      *ALL'Y'       OKTransDet
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
 
      * CK/3 - END PROGRAM
     C     @INKC         CASEQ     '1'           ENDP
 
      * CK/12 - CANCEL ON MAIN DETAILS SCREEN
     C     @INKL         CASEQ     '1'           CANC@M
 
      * VALIDATE INPUT TO MAIN DETAILS SCREEN
     C                   CAS                     VAL@M
 
     C                   ENDCS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@M  - VALIDATE INPUT TO MAIN DETAILS SCREEN
      *****************************************************************
 
     C     VAL@M         BEGSR
 
      * Retrieve Transaction details
     C                   MOVEL     '      '      @@MODE
     C                   EXSR      RTVTRN
 
      * If action code or transaction number are NOT OK
      * Re-output screen with error messages on it
     C     OKACTN        IFEQ      'N'
     C     OKTNBR        OREQ      'N'
     C     OKMRKT        OREQ      'N'
     C                   GOTO      EVAL@M
     C                   ENDIF
 
      *----------------------------------------------------------------
 
      * IF DELETE
     C     SACTN         IFEQ      'D'
 
      * Update transaction in File Format
     C                   MOVEL     CurTranFil    NewTranFil
 
      * Update transaction settlement details in File Format
     C                   MOVEL     CurTrstFil    NewTrstFil
 
      * IF CK/10 TAKEN, GO ONTO UPDATES
     C     @INKJ         IFEQ      '1'
      *                                                                                       CER001
     C                   IF        ULX604 = 'Y'                                               CER001
     C                   MOVEL     'L'           @SCRN                                        CER001
     C                   ELSE                                                                 CER001
     C     BGWDPR        IFEQ      'Y'                                                        191171
     C                   MOVEL     'W'           @SCRN                                        191171
     C                   ELSE                                                                 191171
     C                   MOVEL     'U'           @SCRN
     C                   END                                                                  191171
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF
     C                   GOTO      EVAL@M
     C                   ENDIF
 
      *----------------------------------------------------------------
      * IF INSERT OR AMEND
     C     SACTN         IFEQ      'I'
     C     SACTN         OREQ      'A'
 
      * Prior to validation, initialize error indicators as 'OK'
      * and clear Transaction in File Format
     C                   Z-ADD     *ZERO         Idx               3 0
     C                   Z-ADD     *ZERO         WIdx              3 0
     C                   MOVE      *ALL'Y'       OKBrokSet
     C                   MOVE      *ALL'Y'       OKCustSet
     C                   MOVE      *ALL'Y'       OKTransDet
     C                   CLEAR                   NewTranFil
     C                   CLEAR                   NewTrstFil
 
      * IF AMEND
     C     SACTN         IFEQ      'A'
 
      * Update transaction in File Format
     C                   MOVEL     CurTranFil    NewTranFil
 
      * Update transaction settlement details in File Format
     C                   MOVEL     CurTrstFil    NewTrstFil
 
      * Validate whether non-amendable fields have been changed
     C                   RESET                   ReturnCode
     C                   CALLB     'FFEXTRAMD'
      * Outputs
      * ~~~~~~~
      * Return Code
     C                   PARM                    ReturnCode
      * Transaction Details OK flags(DS) from/to caller
     C                   PARM                    OKTransDet
      * Broker Settlement OK flags(DS) from/to caller
     C                   PARM                    OKBrokSet
      * Customer Settlement OK flags(DS) from/to caller
     C                   PARM                    OKCustSet
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      * Amendments OK
     C                   PARM                    @@AMOK            1
 
      * Inputs
      * ------
      * New transaction in Screen Format
     C                   PARM                    NewTranScn
      * New Broker Settlement details in Screen Format
     C                   PARM                    NewBrStScn
      * New Customer Settlement deatils in screen format
     C                   PARM                    NewCuStScn
      * Current transaction in Screen Format
     C                   PARM                    CurTranScn
      * Current Broker Settlement Details in Screen Format
     C                   PARM                    CurBrStScn
      * Current Customer Settlement Details in Screen Format
     C                   PARM                    CurCuStScn
      * Current transaction in file format
     C                   PARM                    CurTranFil
      * Standing Data ICD
     C                   PARM                    SDBANK
      * Midas modules
     C                   PARM                    SDMMOD
      * General Ledger ICD
     C                   PARM                    SDGELR
      * Reset of Fields in Error Required (Y/N)
     C                   PARM      'Y'           @@RSTE            1
      ** CFF007 Enhancement                                                                   CFF007
     C                   PARM                    CFF007                                       CFF007
 
     C                   ENDIF
 
      * If errors returned by the amend function, do not do validation
      * processing.
     C                   IF        Idx = 0
 
      * Validate Transaction details
     C                   RESET                   ReturnCode
     C                   CALLB     'FFEXTRVAL'
      * Outputs
      * ~~~~~~~
     C                   PARM                    ReturnCode
     C                   PARM                    OKTransDet
     C                   PARM                    Idx
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    NewTranFil
     C                   PARM                    SDBRCH
     C                   PARM                    CTDATE
     C                   PARM                    InstType
      ** PB customer indicator - broker                                                       CFF007
     C                   PARM                    PPBBFLG                                      CFF007
      ** PB customer indicator - customer                                                     CFF007
     C                   PARM                    PPBCFLG                                      CFF007
 
      * Inputs
      * ~~~~~~
     C                   PARM                    RespMode
     C                   PARM                    NewTranScn
      ** Extension file data
     C                   PARM                    ExtData
      ** ICD
     C                   PARM                    SDBANK
     C                   PARM                    SDMMOD
     C                   PARM                    SDGELR
     C                   PARM                    SDFODA
     C                   PARM                    SDDEAL
     C                   PARM                    SDPORT                                        CPM00
      ** CFF007 enhancement                                                                   CFF007
     C                   PARM                    CFF007                                       CFF007
     C                   PARM                    S01457                                       208635
 
     C                   ENDIF
      *                  (End of "If no errors returned by amend")
 
      ** If no errors but at least one warning message exists, then                           198102
      ** repeat processing.                                                                   198102
                                                                                              198102
     C     Idx           IFEQ      0                                                          198102
                                                                                              198102
     C                   MOVEL     *BLANKS       WTmpFldNamArr                                198102
     C                   MOVEL     *BLANKS       WTmpMsgIDArr                                 198102
     C                   MOVEL     *BLANKS       WTmpMsgDtaArr                                198102
     C                   Z-ADD     1             WIx                                          198102
     C                   Z-ADD     0             WIy                                          198102
                                                                                              198102
     C     WMsgIDArr(WIx)DOWNE     *BLANKS                                                    198102
                                                                                              198102
     C                   SELECT                                                               198102
                                                                                              198102
      ** Contract Price                                                                       198102
     C     WMsgIDArr(WIx)WHENEQ    'MMA0340'                                                  198102
     C     WMsgIDArr(WIx)OREQ      'MMA0341'                                                  198102
     C     SCOPR         IFNE      WPrvSCOPR                                                  198102
     C                   ADD       1             WIy                                          198102
     C                   EVAL      WTmpFldNamArr(WIy) = WFldNamArr(WIx)                       198102
     C                   EVAL      WTmpMsgIDArr(WIy) = WMsgIDArr(WIx)                         198102
     C                   EVAL      WTmpMsgDtaArr(WIy) = WMsgDtaArr(WIx)                       198102
     C                   MOVEL     SCOPR         WPrvSCOPR                                    198102
     C                   ENDIF                                                                198102
                                                                                              198102
      ** Portfolio Reference                                                                  198102
     C     WMsgIDArr(WIx)WHENEQ    'MMA0335'                                                  198102
     C     SPTFR         IFNE      WPrvSPTFR                                                  198102
     C                   ADD       1             WIy                                          198102
     C                   EVAL      WTmpFldNamArr(WIy) = WFldNamArr(WIx)                       198102
     C                   EVAL      WTmpMsgIDArr(WIy) = WMsgIDArr(WIx)                         198102
     C                   EVAL      WTmpMsgDtaArr(WIy) = WMsgDtaArr(WIx)                       198102
     C                   MOVEL     SPTFR         WPrvSPTFR                                    198102
     C                   ENDIF                                                                198102
                                                                                              198102
      ** By default, move warning message to WTmpMsgIDArr                                     198102
     C                   OTHER                                                                198102
     C                   ADD       1             WIy                                          198102
     C                   EVAL      WTmpFldNamArr(WIy) = WFldNamArr(WIx)                       198102
     C                   EVAL      WTmpMsgIDArr(WIy) = WMsgIDArr(WIx)                         198102
     C                   EVAL      WTmpMsgDtaArr(WIy) = WMsgDtaArr(WIx)                       198102
                                                                                              198102
     C                   ENDSL                                                                198102
                                                                                              198102
     C                   ADD       1             WIx                                          198102
                                                                                              198102
     C                   ENDDO                                                                198102
                                                                                              198102
     C                   MOVEL     *BLANKS       WFldNamArr                                   198102
     C                   MOVEL     *BLANKS       WMsgIDArr                                    198102
     C                   MOVEL     *BLANKS       WMsgDtaArr                                   198102
     C                   MOVEA     WTmpFldNamArr WFldNamArr                                   198102
     C                   MOVEA     WTmpMsgIDArr  WMsgIDArr                                    198102
     C                   MOVEA     WTmpMsgDtaArr WMsgDtaArr                                   198102
     C                   Z-ADD     WIy           WIdx                                         198102
                                                                                              198102
     C     WIdx          IFGT      0                                                          198102
     C                   GOTO      EVAL@M                                                     198102
     C                   ENDIF                                                                198102
                                                                                              198102
     C                   ENDIF                                                                198102
                                                                                              198102
      * If errors returned
     C     Idx           IFNE      0
     C                   GOTO      EVAL@M
     C                   ENDIF
 
      * Continue to settlements screen
     C                   MOVEL     'S'           @SCRN
 
     C                   ENDIF
 
      *----------------------------------------------------------------
 
     C     EVAL@M        ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * AppendArrs - Append one field's error and warning details to  *
      *              the general error and warning arrays.            *
      *                                                               *
      *****************************************************************
 
     C     AppendArrs    BEGSR
 
     C                   RESET                   ReturnCode
     C                   CALLB     'APAPNDARRS'
      ** Outputs
      ** ~~~~~~~
      ** Return code (10A, returned to caller)
     C                   PARM                    ReturnCode
      ** Error array index (3,0P)
     C                   PARM                    Idx
      ** Field names with errors array (<ArrayMax> x 10A)
     C                   PARM                    FldNameArr
      ** Error message ID array (<ArrayMax> x 7A)
     C                   PARM                    MsgIDArr
      ** Error message data array (<ArrayMax> x 45A)
     C                   PARM                    MsgDtaArr
      ** Warning array index (3,0P)
     C                   PARM                    WIdx
      ** Field names with warnings array (<ArrayMax> x 10A)
     C                   PARM                    WFldNamArr
      ** Warning message ID array (<ArrayMax> x 7A)
     C                   PARM                    WMsgIDArr
      ** Warning message data array (<ArrayMax> x 45A)
     C                   PARM                    WMsgDtaArr
 
      ** Inputs to called procedure
      ** --------------------------
      ** Field name array (<ErrArrMax> x 10A)
     C                   PARM                    FldNamXArr
      ** Error message ID array (<ErrArrMax> x 7A)
     C                   PARM                    MsgIDXArr
      ** Error message data array (<ErrArrMax> x 45A)
     C                   PARM                    MsgDtaXArr
      ** Field name array (<WArrMax> x 10A)
     C                   PARM                    FldNamWArr
      ** Warning message ID array (<WArrMax> x 7A)
     C                   PARM                    MsgIDWArr
      ** Warning message data array (<WArrMax> x 45A)
     C                   PARM                    MsgDtaWArr
 
     C                   ENDSR
 
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * WINDOW - CALL WINDOW MANAGER
      *****************************************************************
 
     C     WINDOW        BEGSR
 
      * Reset erros
     C                   MOVE      *ALL'Y'       OKBrokSet
     C                   MOVE      *ALL'Y'       OKCustSet
     C                   MOVE      *ALL'Y'       OKTransDet
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
 
      * Write out screen to remove error messages
     C                   RESET                   ReturnCode
     C                   CALLB     'FFEXTRDSP'
     C                   PARM                    ReturnCode
      *
      * TRANSACTION (IN SCREEN FORMAT)
     C                   PARM                    NewBrStScn
     C                   PARM                    NewCuStScn
     C                   PARM                    NewTranScn
      *
      * TRANSACTION STATUS
     C                   PARM                    FFSTS            24
      *
      * ICD
     C                   PARM                    SDBANK
     C                   PARM                    SDGELR
     C                   PARM                    SDMMOD
      *
      *
      * FIELDS IN ERROR
     C                   PARM                    OKBrokSet
     C                   PARM                    OKCustSet
     C                   PARM                    OKTransDet
      *
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      * ENABLED KEY & DETAIL FIELDS
      *
     C                   PARM                    @EKYFD            1
     C                   PARM                    @EDTFD            1
      *
      * ENABLED FUNCTION KEYS
      * KG = COMMAND KEY 07 = READ PREVIOUS
      * KH = COMMAND KEY 08 = READ NEXT
      * KJ = COMMAND KEY 10 = CONFIRM DELETE
      * KP = COMMAND KEY 15 = BROWSE
     C                   PARM                    @EINKG            1
     C                   PARM                    @EINKH            1
     C                   PARM                    @EINKJ            1
     C                   PARM                    @EINKP            1
      *
      * SUCCESFUL INSERT TRANSACTION
     C                   PARM                    @SIDN             6
      *
      * OUTPUT PARAMETERS
      *
      * FUNCTION KEYS
     C                   PARM                    @INKC             1
     C                   PARM                    @INKG             1
     C                   PARM                    @INKH             1
     C                   PARM                    @INKJ             1
     C                   PARM                    @INKL             1
     C                   PARM                    @INKP             1
      *
      * Write screen with no read indicator
     C                   PARM      'Y'           WriteOnly
      ** CFF007 enhancement                                                                   CFF007
     C                   PARM                    CFF007                                       CFF007
 
      * If transaction number not defined (on insert),
      * get next available transaction number.
     C                   IF        STNBR = *blank
 
     C                   RESET                   ReturnCode
     C                   CALLB     'ZATRNRTV'
     C                   PARM                    ReturnCode
     C                   PARM                    Module
     C                   PARM                    DummyTRTY
     C                   PARM                    STNBR
     C                   PARM                    VTNBR
 
      * End in error if generator returned an error
     C                   IF        ReturnCode <> *blank
     C                   MOVEL     'ZATRNRTV'    DBFILE                         ************
     C                   MOVEL     '001'         DBASE                          * DBERR 001*
     C                   MOVEL     STNBR         DBKEY                         ************
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Set a flag to indicate that the transaction number was generated
      * rather than entered.
     C                   EVAL      AutoTran = 'Y'
 
     C                   ENDIF
 
     C/COPY WNCPYSRC,FFTRANSMV1
                                                                                              CER001
     C                   IF        ULX604  = 'Y'                                              CER001
     C                   EVAL      #1TNBR  = STNBR                                            CER001
      *                                                                                       CER001
     C                   MOVEL     PSSrcMbr      WMbr              6                          CER001
      *                                                                                       CER001
     C                   IF        WMbr    = 'FFOTCC'                                         CER001
     C                   EVAL      #1ISTT  = SISTT                                            CER001
     C                   EVAL      #1MRKT  = *BLANKS                                          CER001
     C                   EVAL      #1FOTR  = SOFOTRANID                                       CER001
     C                   EVAL      #1TMST  = SOTMESTMP                                        CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      #1ISTT  = ISTT                                             CER001
     C                   EVAL      #1MRKT  = SMRKT                                            CER001
     C                   EVAL      #1FOTR  = SEFOTRANID                                       CER001
     C                   EVAL      #1TMST  = SETMESTMP                                        CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   CALL      'WN0010'
     C                   PARM      'FFEXTRRPR'   #PGM             10
     C                   PARM                    FKEY              2
     C                   PARM      SACTN         ACTION            1
     C                   PARM                    DATA
     C                   PARM      *BLANKS       #RTRN             7
     C                   PARM                    SPAREW          256
 
      * Process returned command keys
     C     #RTRN         IFEQ      'Y2U9999'
     C                   EXSR      ENDP
     C                   ELSE
 
      *  If Cmd12 pressed, or in enquiry, return to main details screen;
      *  otherwise, go to confirmation screen
     C     #RTRN         IFEQ      'USR0790'
     C     SACTN         OREQ      'E'
     C     @OPSEL        OREQ      'N'                                                       BUG9617
     C     @RDNB         IFEQ      'Y'
 
     C                   EVAL      @SCRN = 'R'
     C                   ELSE
     C                   EVAL      @SCRN = 'M'
 
     C                   ENDIF
 
     C                   ELSE
 
     C     SACTN         IFEQ      'D'                                                        191171
     C                   EVAL      @SCRN = 'U'                                                191171
     C                   ELSE                                                                 191171
     C                   EVAL      @SCRN = 'C'
     C                   END                                                                  191171
 
     C                   ENDIF
 
     C                   ENDIF
 
     C     WIND          ENDSR
 
      *****************************************************************                       CER001
      *                                                               *                       CER001
      *  SRLUXW - For LUX Window                                      *                       CER001
      *                                                               *                       CER001
      *****************************************************************                       CER001
                                                                                              CER001
     C     SRLUXW        BEGSR                                                                CER001
      *                                                                                       CER001
     C                   MOVEL     STNBR         #1TNBR                                       CER001
      *                                                                                       CER001
     C                   MOVEL     ISTT          #1ISTT                                       CER001
     C                   MOVEL     SMRKT         #1MRKT                                       CER001
     C                   MOVE      SEFOTRANID    #1FOTR                                       CER001
     C                   MOVE      SETMESTMP     #1TMST                                       CER001
      *                                                                                       CER001
      ** If Option selected is "N", pass an action code value of "E"                          CER001
      *                                                                                       CER001
     C                   IF        @OPSEL    = 'N'                                            CER001
     C                   EVAL      PActnCode = 'E'                                            CER001
     C                   EVAL      #1DEXT    = 'Y'                                            CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      PActnCode = SACTN                                          CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   CALL      'FFEXTR2RP'                                                CER001
     C                   PARM      *Blanks       PRetnCode                                    CER001
     C                   PARM                    PActnCode                                    CER001
     C                   PARM                    DATALUX                                      CER001
     C                   PARM                    W0RTN                                        CER001
     C                   PARM                    NwDlScnFmt                                   CER001
     C                   PARM                    NwDlFilFmt                                   CER001
     C                   EVAL      #1DEXT = *BLANK                                            CER001
      *                                                                                       CER001
      ** Process returned command keys                                                        CER001
      *                                                                                       CER001
     C     W0RTN         IFEQ      'Y2U9999'                                                  CER001
     C                   EXSR      ENDP                                                       CER001
     C                   ELSE                                                                 CER001
      *                                                                                       CER001
      ** If Cmd12 pressed, or in enquiry, return to main details                              CER001
      ** screen. otherwise, go to confirmation screen                                         CER001
      *                                                                                       CER001
     C                   IF        W0RTN   = 'USR0790' or @OPSEL = 'E'                        CER001
      *                                                                                       CER001
     C                   EVAL      @SCRN   = 'M'                                              CER001
      *                                                                                       CER001
     C                   ELSE                                                                 CER001
      *                                                                                       CER001
     C                   IF        BGWDPR  = 'Y'                                              CER001
     C                   EVAL      @SCRN   = 'W'                                              CER001
     C                   ELSE                                                                 CER001
     C                   IF        SACTN   = 'D'                                              CER001
     C                   EVAL      @SCRN   = 'U'                                              CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      @SCRN   = 'C'                                              CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDSR                                                                CER001
      *                                                                                       CER001
      *****************************************************************
      /EJECT
      *****************************************************************
      * RTVTRN - RETRIEVE TRANSACTION
      *****************************************************************
 
     C     RTVTRN        BEGSR
 
     C                   RESET                   ReturnCode
     C                   CALLB     'FFEXTRRTV'
      * Return code
     C                   PARM                    ReturnCode
      * Inputs
      * ------
      * Mode = '*FRONT' (front office transaction interface)
      * Mode = '      ' (not front office transaction interface) (6A)
     C                   PARM                    @@MODE            6
      * Response mode (1A)
     C                   PARM      'S'           @@RSMD            1
      * Action Code (1A)
     C                   PARM                    SACTN
      * Front Office Transaction ID (20A)
     C                   PARM                    FOTRID           20
      * (Midas) Transaction Number (6A)
     C                   PARM                    STNBR
      * (Midas) Market (1A)
     C                   PARM                    SMRKT
      ** Module being called as linked enquiry (1A)
     C                   PARM                    LinkEnq
      * Bank details ICD
     C                   PARM                    SDBANK
      * General Ledger ICD
     C                   PARM                    SDGELR
      * Multibranching indicator
     C                   PARM                    BGMBIN
      * Outputs
      * ~~~~~~~
      ** Current transaction in file format
     C                   PARM                    CurTranFil
      ** Current settlements in file format
     C                   PARM                    CurTrstFil
      ** Instrument types
     C                   PARM                    InstType
      * OK - Action code (1A)
     C                   PARM      *BLANK        OKACTN
      * OK - Transaction Number (1A)
     C                   PARM      *BLANK        OKTNBR
      * OK - Market (1A)
     C                   PARM      *BLANK        OKMRKT            1
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx
      *
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * PUTD@M - PUT A TRANSACTION ON THE MAIN DETAILS SCREEN
      *****************************************************************
 
     C     PUTD@M        BEGSR
 
      * Call program to fill screen fields with data from TRANSD
     C                   RESET                   ReturnCode
     C                   CALLB     'FFEXTRCVT'
      * Inputs
      * ~~~~~~
     C                   PARM                    ReturnCode
      * Transaction in file format
     C                   PARM                    CurTranFil
      * ICD
     C                   PARM                    SDBANK
     C                   PARM                    SDDEAL
     C                   PARM                    SDMMOD
     C                   PARM                    SDPORT
      * Outputs
      * ~~~~~~~
      * Transaction in screen format
     C                   PARM                    NewTranScn
      * Transaction Status
     C                   PARM                    FFSTS            24
      ** CFF007 enhancement                                                                   CFF007
     C                   PARM                    CFF007                                       CFF007
 
     C                   EVAL      CustBrokFl = 'B'
 
     C                   RESET                   ReturnCode
     C                   CALLB     'FFSETLCVT'
      * Outputs
      * ~~~~~~~
      ** Return code (10A, returned to caller)
     C                   PARM                    ReturnCode
      ** Customer settlement instructions, screen format
     C                   PARM                    NewCuStScn
      ** Broker settlement instructions, screen format
     C                   PARM                    NewBrStScn
      *
      * Inputs
      * ~~~~~~
      * Settlements in file format
     C                   PARM                    CurTrstFil
      ** Customer/broker flag (1A)
     C                   PARM                    CustBrokFl
      ** Midas Transaction Number
     C                   PARM                    STNBR
      ** Instrument currency
     C                   PARM                    ISCY
 
 
     C                   EVAL      CustBrokFl = 'C'
 
     C                   RESET                   ReturnCode
     C                   CALLB     'FFSETLCVT'
      * Outputs
      * ~~~~~~~
      ** Return code (10A, returned to caller)
     C                   PARM                    ReturnCode
      ** Customer settlement instructions, screen format
     C                   PARM                    NewCuStScn
      ** Broker settlement instructions, screen format
     C                   PARM                    NewBrStScn
      *
      * Inputs
      * ~~~~~~
      * Settlements in file format
     C                   PARM                    CurTrstFil
      ** Customer/broker flag (1A)
     C                   PARM                    CustBrokFl
      ** Midas Transaction Number
     C                   PARM                    STNBR
      ** Instrument currency
     C                   PARM                    ISCY
 
      * Update 'Current' Deal with Deal in Screen Format
      *
     C                   MOVEL     NewTranScn    CurTranScn
     C                   MOVEL     NewCuStScn    CurCuStScn
     C                   MOVEL     NewBrStScn    CurBrStScn
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@M - CANCEL ON MAIN DETAILS SCREEN
      *****************************************************************
     C     CANC@M        BEGSR
      *
      * IF RECORDS ARE STILL TO BE READ FROM THE SUBFILE, READ THEM
      *
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
      *
      * ELSE, RETURN TO THE BROWSE SCREEN
      *
     C                   MOVEL     'B'           @SCRN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SCRN@S    -  Not exactly a separate screen but the bottom     *
      *              half of the main details input screen.           *
      *              This validates the charges and commission        *
      *              details and applies default settlement           *
      *              instructions if none have been applied;          *
      *              otherwise settlement details are converted and   *
      *              validated.                                       *
      *****************************************************************
 
     C     SCRN@S        BEGSR
 
      * Clear broker settlement details screen if broker not defined
 
     C                   IF        SBOCO = *blanks
     C                             OR %subst(SBOCO : 1 : 1) = '*'
     C                   CLEAR                   NewBrStScn
     C                   ENDIF
 
      * Clear customer settlement details screen if customer not defined
 
     C                   IF        SCUSC = *blanks
     C                   CLEAR                   NewCuStScn
     C                   ENDIF
 
      * This routine is called if none of the settlement fields have been
      * entered.
     C**********         IF            (NewCuStScn = *blank)                                  247980
     C**********                   AND (NewBrStScn = *blank)                                  247980
 
      * First default broker instructions if broker has been entered,
      * and has not been entered as '*'.
     C                   IF        SBOCO <> *blanks
     C                             AND %subst(SBOCO : 1 : 1) <> '*'
 
     C                   EVAL      CustBrokFl = 'B'
     C**********         MOVE      *zero         CustBrokNo                                   CSD027
     C                   EVAL      CustBrokNo = *BLANKS                                       CSD027
     C                   MOVEL     SBOCO         CustBrokNo
 
     C                   RESET                   ReturnCode
     C                   CALLB     'FFSETLDFT'
      *                      Return code
      *  Outputs
      *  ~~~~~~~
     C                   PARM                    ReturnCode
      **                     Broker settlement instructions
     C                   PARM                    NewBrStScn
      **                     Customer settlement instructions
     C                   PARM                    NewCuStScn
      *                      Return code
      *  Inputs
      *  ~~~~~~
      ** Customer/broker flag
     C                   PARM                    CustBrokFl
      ** Customer or broker number
     C                   PARM                    CustBrokNo
      ** Market centre
     C                   PARM                    SMRKT
      ** Instrument code
     C                   PARM                    SISTC
      ** Transaction type (purchase or sale)
     C                   PARM                    STRTY
      ** Enhanced OTCs feature flag
     C                   PARM                    CFF001
 
     C                   ENDIF
      *                  (End of "If broker and not '*'")
 
 
      ** Next default customer instructions, but
      ** only if the customer was entered.
     C                   IF        SCUSC <> *blanks
 
     C                   EVAL      CustBrokFl = 'C'
     C**********         MOVE      *ZERO         CustBrokNo                                   CSD027
     C                   EVAL      CustBrokNo = *BLANKS                                       CSD027
     C                   MOVEL     SCUSC         CustBrokNo
 
     C                   RESET                   ReturnCode
     C                   CALLB     'FFSETLDFT'
      *  Outputs
      *  ~~~~~~~
      *                      Return code
     C                   PARM                    ReturnCode
      *                      Broker settlement instructions
     C                   PARM                    NewBrStScn
      *                      Customer settlement instructions
     C                   PARM                    NewCuStScn
      *  Inputs
      *  ~~~~~~
      *  Customer/broker flag
     C                   PARM                    CustBrokFl
      *  Customer or broker number
     C                   PARM                    CustBrokNo
      *  Market centre
     C                   PARM                    SMRKT
      *  Instrument code
     C                   PARM                    SISTC
      ** Transaction type (purchase or sale) (1A)
     C                   PARM                    STRTY
      *  Enhanced OTCs feature flag
     C                   PARM                    CFF001
 
     C                   ENDIF
      *                  (End of "If Customer")
 
     C**********         ENDIF                                                                247980
      *                  (End of "If no settlement instructions entered")
 
      * Validate the broker and customer charge and commission details
 
     C                   EXSR      ValChgCom
 
      ** Validate broker and customer settlement instructions
 
     C                   RESET                   BrokSetErr
     C                   RESET                   CustSetErr
 
      ** 1. Broker (if broker defined)
      ** ---------
     C                   IF        SBOCO <> *blanks
     C                             AND %subst(SBOCO : 1 : 1) <> '*'
 
     C                   EVAL      CustBrokFl = 'B'
     C                   RESET                   ReturnCode
     C                   CALLB     'FFSETLVAL'
      ** Outputs
      ** ~~~~~~~
      ** Return Code
     C                   PARM                    ReturnCode
      ** Field name array (<ErrArrMax> x 10A, returned to caller)
     C                   PARM                    FldNamXArr
      ** Error message ID array (<ErrArrMax> x 7A, returned to caller)
     C                   PARM                    MsgIDXArr
      ** Error message data array (<ErrArrMax> x 45A, returned to caller)
     C                   PARM                    MsgDtaXArr
      ** Field name array (<WArrMax> x 10A, returned to caller)
     C                   PARM                    FldNamWArr
      ** Warning message ID array (<WArrMax> x 7A, returned to caller)
     C                   PARM                    MsgIDWArr
      ** Warning message data array (<WArrMax> x 45A, returned to caller)
     C                   PARM                    MsgDtaWArr
      ** The valid settlements file format (data structure, from FFVSETLPD)
     C                   PARM                    NewTrstFil
      ** Inputs
      ** ~~~~~~
      ** Data structure containing broker settlement details
     C                   PARM                    NewBrStScn
      ** Data structure containing customer settlement details
     C                   PARM                    NewCuStScn
      ** Data structure containing broker settlement OK flags
     C                   PARM                    OKBrokSet
      ** Data structure containing customer settlement OK flags
     C                   PARM                    OKCustSet
      ** Customer/ Broker flag (1A)
     C                   PARM                    CustBrokFl
      ** Branch code (3A, from transaction)
     C                   PARM                    SBRCD
      ** Portfolio reference (4A)
     C                   PARM                    SPTFR
      ** Instrument currency (3A)
     C                   PARM                    VISCY
      ** Trade date in Midas day number format (5,0P)
     C                   PARM                    VTRSD
      ** Broker Code (6S,0 from FFVTRANPD)
     C                   PARM                    VBOCO
      ** Customer Code (6S,0 from FFVTRANPD)
     C                   PARM                    VCUSC
      ** Branch internal customer number (from SDBRCHPD)
     C                   PARM                    A8BICN
      ** Current trading date
     C                   PARM                    CTDATE
      ** Bank Details ICD
     C                   PARM                    SDBANK
      ** General Ledger ICD
     C                   PARM                    SDGELR
      ** Midas Modules ICD
     C                   PARM                    SDMMOD
      ** Trading ICD
     C                   PARM                    SDTRAD
      ** Portfolio Management ICD
     C                   PARM                    SDPORT
      ** Retail ICD
     C                   PARM                    SDRETL
      ** CFF007 enhancement                                                                   CFF007
     C                   PARM                    CFF007                                       CFF007
      ** PB customer indicator - broker                                                       CFF007
     C                   PARM                    PPBBFLG                                      CFF007
      ** PB customer indicator - customer                                                     CFF007
     C                   PARM                    PPBCFLG                                      CFF007
      ** Collaterals Processing enhancement                                                   CGL014
     C                   PARM                    CGL014                                       CGL014
 
      ** Record any failure or warning
     C                   IF        ReturnCode <> *blanks
 
     C                   IF        ReturnCode = 'Error'
     C                   EVAL      BrokSetErr = 'Y'
     C                   ENDIF
 
     C                   IF        ReturnCode = 'ErrAndWarn'
     C                   EVAL      BrokSetErr = 'Y'
     C                   ENDIF
 
     C                   IF        ReturnCode = 'Warning'
     C                   EVAL      BrokSetErr = 'W'
     C                   ENDIF
 
      ** Append the array details from the above call onto the general
      ** error arrays
     C                   EXSR      AppendArrs
     C                   ENDIF
     C                   ENDIF
 
      ** 2. Customer (if customer defined)
      ** -----------
     C                   IF        SCUSC <> *blanks
 
     C                   EVAL      CustBrokFl = 'C'
     C                   RESET                   ReturnCode
     C                   CALLB     'FFSETLVAL'
      ** Outputs
      ** -------
      ** Return Code
     C                   PARM                    ReturnCode
      ** Field name array (<ErrArrMax> x 10A, returned to caller)
     C                   PARM                    FldNamXArr
      ** Error message ID array (<ErrArrMax> x 7A, returned to caller)
     C                   PARM                    MsgIDXArr
      ** Error message data array (<ErrArrMax> x 45A, returned to caller)
     C                   PARM                    MsgDtaXArr
      ** Field name array (<WArrMax> x 10A, returned to caller)
     C                   PARM                    FldNamWArr
      ** Warning message ID array (<WArrMax> x 7A, returned to caller)
     C                   PARM                    MsgIDWArr
      ** Warning message data array (<WArrMax> x 45A, returned to caller)
     C                   PARM                    MsgDtaWArr
      ** The valid settlements file format (data structure, from FFVSETLPD)
     C                   PARM                    NewTrstFil
      ** Inputs
      ** ~~~~~~
      ** Data structure containing broker settlement details
     C                   PARM                    NewBrStScn
      ** Data structure containing customer settlement details
     C                   PARM                    NewCuStScn
      ** Data structure containing broker settlement OK flags
     C                   PARM                    OKBrokSet
      ** Data structure containing customer settlement OK flags
     C                   PARM                    OKCustSet
      ** Customer/ Broker flag (1A)
     C                   PARM                    CustBrokFl
      ** Branch code (3A, from transaction)
     C                   PARM                    SBRCD
      ** Portfolio reference (4A)
     C                   PARM                    SPTFR
      ** Instrument currency (3A)
     C                   PARM                    VISCY
      ** Trade date in Midas day number format (5,0P)
     C                   PARM                    VTRSD
      ** Broker Code (6S,0 from FFVTRANPD)
     C                   PARM                    VBOCO
      ** Customer Code (6S,0 from FFVTRANPD)
     C                   PARM                    VCUSC
      ** Branch internal customer number (from SDBRCHPD)
     C                   PARM                    A8BICN
      ** Current trading date
     C                   PARM                    CTDATE
      ** Bank Details ICD
     C                   PARM                    SDBANK
      ** General Ledger ICD
     C                   PARM                    SDGELR
      ** Midas Modules ICD
     C                   PARM                    SDMMOD
      ** Trading ICD
     C                   PARM                    SDTRAD
      ** Portfolio Management ICD
     C                   PARM                    SDPORT
      ** Retail ICD
     C                   PARM                    SDRETL
      ** CFF007 enhancement                                                                   CFF007
     C                   PARM                    CFF007                                       CFF007
      ** PB customer indicator - broker                                                       CFF007
     C                   PARM                    PPBBFLG                                      CFF007
      ** PB customer indicator - customer                                                     CFF007
     C                   PARM                    PPBCFLG                                      CFF007
      ** Collaterals Processing enhancement                                                   CGL014
     C                   PARM                    CGL014                                       CGL014
 
      ** Record any failure or warning
     C                   IF        ReturnCode <> *blanks
 
     C                   IF        ReturnCode = 'Error'
     C                   EVAL      CustSetErr = 'Y'
     C                   ENDIF
 
     C                   IF        ReturnCode = 'ErrAndWarn'
     C                   EVAL      CustSetErr = 'Y'
     C                   ENDIF
 
     C                   IF        ReturnCode = 'Warning'
     C                   EVAL      CustSetErr = 'W'
     C                   ENDIF
 
      ** Append the array details from the above call onto the general
      ** error arrays
     C                   EXSR      AppendArrs
     C                   ENDIF
     C                   ENDIF
      *
      * If settlement or charges and commission details invalid, return to
      * main details screen.
     C                   IF           BrokSetErr = 'Y' OR CustSetErr = 'Y'
     C                             OR BrokCCErr = 'Y' OR CustCCErr = 'Y'
 
     C                   MOVEL     'M'           @SCRN
 
     C                   ELSE
 
      *                                                                                       CER001
     C                   IF        ULX604  = 'Y'                                              CER001
     C                   EVAL      @SCRN   = 'L'                                              CER001
     C                   ELSE                                                                 CER001
      * Otherwise, if windows on, show windows screen
     C     BGWDPR        IFEQ      'Y'
     C                   MOVEL     'W'           @SCRN
     C                   ELSE
 
      * Otherwise continue to the confirmation screen
     C                   MOVEL     'C'           @SCRN
 
     C                   ENDIF
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@C - PROCESS SCREEN: CONFIRMATION OF INPUT
      *          EVOKED FOR INSERTS, AMENDS & AUTHORIZATIONS
      *****************************************************************
 
     C     SCRN@C        BEGSR
 
      * If transaction is valid output message 'Press enter to accept'
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'APM0121'     MsgIdArr(1)
 
      * Write/read display screen
     C                   RESET                   ReturnCode
     C                   CALLB     'FFEXTRDSP'
     C                   PARM                    ReturnCode
 
      * TRANSACTION (IN SCREEN FORMAT)
     C                   PARM                    NewBrStScn
     C                   PARM                    NewCuStScn
     C                   PARM                    NewTranScn
      *
      * TRANSACTION STATUS
     C                   PARM                    FFSTS            24
      *
      * ICD
     C                   PARM                    SDBANK
     C                   PARM                    SDGELR
     C                   PARM                    SDMMOD
      *
      * FIELDS IN ERROR
     C                   PARM                    OKBrokSet
     C                   PARM                    OKCustSet
     C                   PARM                    OKTransDet
      *
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      * ENABLED KEY & DETAIL FIELDS
      *
     C                   PARM      'N'           @EKYFD            1
     C                   PARM      'N'           @EDTFD            1
      *
      * ENABLED FUNCTION KEYS
      * KG = COMMAND KEY 07 = READ PREVIOUS
      * KH = COMMAND KEY 08 = READ NEXT
      * KJ = COMMAND KEY 10 = CONFIRM DELETE
      * KP = COMMAND KEY 15 = BROWSE
     C                   PARM      'N'           @EINKG            1
     C                   PARM      'N'           @EINKH            1
     C                   PARM      'N'           @EINKJ            1
     C                   PARM      'N'           @EINKP            1
      *
      * SUCCESFUL INSERT TRANSACTION
     C                   PARM                    @SIDN             6
      *
      * OUTPUT PARAMETERS
      *
      * FUNCTION KEYS
     C                   PARM                    @INKC             1
     C                   PARM                    @INKG             1
     C                   PARM                    @INKH             1
     C                   PARM                    @INKJ             1
     C                   PARM                    @INKL             1
     C                   PARM                    @INKP             1
 
      * Write screen with no read indicator
     C                   PARM      'N'           WriteOnly
      ** CFF007 enhancement                                                                   CFF007
     C                   PARM                    CFF007                                       CFF007
 
      * RESET ERRORS
     C                   MOVE      *ALL'Y'       OKBrokSet
     C                   MOVE      *ALL'Y'       OKCustSet
     C                   MOVE      *ALL'Y'       OKTransDet
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
 
      * CK/3 - END PROGRAM
     C     @INKC         CASEQ     '1'           ENDP
      *
      * CK/12 - CANCEL ON CONFIRMATION SCREEN
      *
     C     @INKL         CASEQ     '1'           CANC@C
 
      * EXIT CONFIRMATION SCREEN
     C                   CAS                     EXIT@C
     C                   ENDCS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@C - CANCEL ON CONFIRMATION SCREEN
      *****************************************************************
 
     C     CANC@C        BEGSR
 
      * RETURN TO MAIN DETAILS SCREEN
     C                   MOVEL     'M'           @SCRN
 
      * If F12 was pressed on the confirm screen, and the transaction number
      * was automatically generated, blank it out and do a rollback to
      * release the generated transaction number.
     C                   IF        AutoTran = 'Y'
     C                   CLEAR                   STNBR
     C                   ROLBK
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * EXIT@C - EXIT FROM CONFIRMATION SCREEN
      *****************************************************************
     C     EXIT@C        BEGSR
      *
      * IF NO ERRORS IN VALIDATION
      *
     C     Idx           IFEQ      *ZERO
      *
      * CONTINUE WITH UPDATES
      *
     C                   MOVEL     'U'           @SCRN
      *
      * ELSE, RETURN TO MAIN DETAILS SCREEN
      *
     C                   ELSE
     C                   MOVEL     'M'           @SCRN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATS - UPDATES
      *****************************************************************
 
     C     Updats        BEGSR
 
      * If transaction number not defined (on insert),
      * get next available transaction number.
     C                   IF        STNBR = *blank
 
     C                   RESET                   ReturnCode
     C                   CALLB     'ZATRNRTV'
     C                   PARM                    ReturnCode
     C                   PARM                    Module
     C                   PARM                    DummyTRTY
     C                   PARM                    STNBR
     C                   PARM                    VTNBR
 
      * End in error if generator returned an error
     C                   IF        ReturnCode <> *blank
     C                   MOVEL     'ZATRNRTV'    DBFILE                         ************
     C                   MOVEL     '002'         DBASE                          * DBERR 001*
     C                   MOVEL     STNBR         DBKEY                         ************
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Set a flag to indicate that the transaction number was generated
      * rather than entered.
     C                   EVAL      AutoTran = 'Y'
 
     C*******************EVAL      @SIDN = STNBR                                166907
 
     C                   ENDIF
      *                                                                         166907
      ** Succesfully Inserted Deal Number                                       166907
      *                                                                         166907
     C                   EVAL      @SIDN = STNBR                                166907
 
      ** Settlements file version of transaction number
     C                   EVAL      VSTNBR = VTNBR
 
      * Set the change type equal to the action code
     C                   EVAL      VCHTP  = SACTN
 
      * Set the front office transaction ID
     C                   EVAL      VFRNT  = @FOTRANSEL
     C                   EVAL      VSFRNT = @FOTRANSEL                          CAP013
 
      ** Update the main transaction details
     C                   RESET                   ReturnCode
     C                   CALLB     'FFTRANUPD'
      ** Returned parameters
      ** -------------------
     C                   PARM                    ReturnCode
      ** Sent parameters
      ** ---------------
      ** The format containing the valid transaction
     C                   PARM                    NewTranFil
      ** The instrument details (data structure)
     C                   PARM                    InstType
      ** The settlement details (data structure)
     C                   PARM                    NewTrstFil
      ** A code to indicate whether the trade is an OTC or an exchange-
      ** traded one.
     C                   PARM                    TransType
      ** New OTC instrument Y/N
     C                   PARM      'N'           NewOTCInst        1
      ** Whether switchable feature CFF001 (Enhanced OTCs) is on
     C                   PARM                    CFF001
      ** General Ledger ICD (SDGELRPD data structure
     C                   PARM                    SDGELR
      ** Midas modules (DS, from SDMMODPD)
     C                   PARM                    SDMMOD
      ** Trade and book positions reconcilable flag (from SDFODAPD)
     C                   PARM                    BXTBRC
 
 
      ** If no errors, update settlement instructions.
     C**********         IF        ReturnCode <> 'Error'                        CAP006
     C                   IF        ReturnCode <> 'Error' and                    CAP006
     C                             ReturnCode <> '*RECUPD'                      CAP006
 
      * Update the settlement instructions.
     C                   CALLB     'FFSETLUPD'
      * Return code (10A, returned to caller)
     C                   PARM                    ReturnCode
      *
      *  Inputs
      *  ~~~~~~
      ** The format containing the valid settlements (data structure)
     C                   PARM                    NewTrstFil
      ** The format containing the valid transaction (data structure)
     C                   PARM                    NewTranFil
      ** The instrument details (data structure)
     C                   PARM                    InstType
      ** Multibranching indicator
     C                   PARM                    BGMBIN
      ** CFF007 Enhancement                                                                   CFF007
     C                   PARM                    CFF007                                       CFF007
      ** PB customer indicator - broker                                                       CFF007
     C                   PARM                    PPBBFLG                                      CFF007
      ** PB customer indicator - customer                                                     CFF007
     C                   PARM                    PPBCFLG                                      CFF007
 
     C                   ENDIF
      **                 (End of "If return code <> 'Error'")
 
      *                                                                                       CER001
      ** If no error found and LUX switchcable is on,                                         CER001
      ** update extension file.                                                               CER001
      *                                                                                       CER001
     C                   IF        ReturnCode = *BLANK And ULX604 = 'Y'                       CER001
     C                   EVAL      #6LXFFTNBR = VSTNBR                                        CER001
     C                   CALLB     'FFTRAN2UP'                                                CER001
     C                   PARM                    SACTN                                        CER001
     C                   PARM      *BLANK        @RTCD                                        CER001
     C                   PARM      'Y'           PFind                                        CER001
     C                   PARM                    NwDlFilFmt                                   CER001
     C                   PARM                    PcDlFilFmt                                   CER001
     C                   EVAL      Returncode = @RTCD                                         CER001
     C                   ENDIF                                                                CER001
      * If there were any errors in the update functions, rollback any
      * updates and end this module.
      * Otherwise delete the invalid transaction & commit the updates       DATES
     C*********          IF        ReturnCode <> *blanks                        CAP006
     C                   IF        ReturnCode <> *blanks                        168345
     C**************     IF        ReturnCode <> *blanks and             CAP006 168345
     C**************               ReturnCode <> '*RECUPD'               CAP006 168345
     C                   ROLBK
     C                   IF        ReturnCode <> '*RECUPD'                      168345
     C                   EVAL      @ERRUP  = 'N'                                              CER001
     C                   EXSR      *pssr
     C                   ELSE                                                                 CER001
     C                   EVAL      @ERRUP  = 'Y'                                              CER001
     C                   ENDIF                                                  168345
 
     C                   ELSE
 
     C     ZATRNKD0      CHAIN     FFIEXTRL1                          99
     C  N99              DELETE    FFIEXTRD0
     C     ZATRNKD0      CHAIN     FFIBSETD0                          99
     C  N99              DELETE    FFIBSETD0
     C     ZATRNKD0      CHAIN     FFICSETD0                          99
     C  N99              DELETE    FFICSETD0
     C                   IF        ULX604  = 'Y'                                              CER001
     C     K@KEY1        CHAIN     RTVIDX1                            99                      CER001
     C                   IF        %FOUND                                                     CER001
     C                   DELETE    RTVIDX1                                                    CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
                                                                                              CSC011
      ** Also delete corresponding record in API standard log file                            CSC011
      ** if CSC011 is present and user is still in support system.                            CSC011
                                                                                              CSC011
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         CSC011
     C                   EVAL      WMTYP = 'FFEXTR'                                           CSC011
     C     KAPILOG       CHAIN     APILOGL0                           71                      CSC011
                                                                                              CSC011
      ** If record found                                                                      CSC011
     C                   IF        *IN71 = '0'                                                CSC011
     C                   DELETE    APILOGD0                                                   CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   COMMIT
     C/COPY WNCPYSRC,FFEXTRRC01
     C                   ENDIF
 
      * If error occurred in updating last transaction set on flag to           CAP006
      * display message on 'browse' screen.                                     CAP006
     C                   IF        ReturnCode = '*RECUPD'                       CAP006
     C                   MOVE      'Y'           @ERRUP                         CAP006
     C                   ELSE                                                   CAP006
     C                   MOVE      'N'           @ERRUP                         CAP006
     C                   END                                                    CAP006
     C                                                                          CAP006
      ** Remove the multimembered file overrides for this transaction
     C                   RESET                   ReturnCode
     C                   CALLB     'FFDLTOVR'
     C                   PARM                    ReturnCode
 
     C**********         ENDIF                                                  CAP006
 
      * IF RECORDS ARE STILL TO BE READ FROM THE SUBFILE, READ THEM
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
      *
      * ELSE, RETURN TO THE BROWSE SCREEN
      *
     C                   MOVEL     'B'           @SCRN
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * ENDP - END PROGRAM
      *****************************************************************
 
     C     ENDP          BEGSR
 
      * Issue rollback to clear any possible updates in window function
 
     C     BGWDPR        IFEQ      'Y'
     C                   ROLBK
     C                   ENDIF
 
     C                   MOVEL     'T'           @SCRN
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      * ValChgCom - Validate charges and commission details.
      *
      *****************************************************************
 
     C     ValChgCom     BEGSR
 
      ** FFVCHGCOM is called twice, once for broker charges and commissions
      ** and once for customer charges and commissions.
 
     C                   RESET                   BrokCCErr
     C                   RESET                   CustCCErr
 
      ** 1. Broker
      ** ---------
     C                   EVAL      BrokerFlag = 'Y'
     C                   RESET                   ReturnCode
     C                   CALLB     'FFVCHGCOM'
      ** Outputs from called procedure
      ** -----------------------------
      ** Return Code
     C                   PARM                    ReturnCode
      ** Field name array (<ErrArrMax> x 10A, returned to caller)
     C                   PARM                    FldNamXArr
      ** Error message ID array (<ErrArrMax> x 7A, returned to caller)
     C                   PARM                    MsgIDXArr
      ** Error message data array (<ErrArrMax> x 45A, returned to caller)
     C                   PARM                    MsgDtaXArr
      ** Broker settlement OK flags.
     C                   PARM                    OKBrokSet
      ** Customer settlement OK flags
     C                   PARM                    OKCustSet
      ** The valid settlements file format (data structure, from FFVSETLPD)
     C                   PARM                    NewTrstFil
 
      ** Inputs to called procedure
      ** --------------------------
      ** Data structure containing customer settlement details
     C                   PARM                    NewBrStScn
      ** Customer/ Broker flag (1A, Y = Broker, N = Customer)
     C                   PARM                    BrokerFlag
      ** Instrument currency (3A)
     C                   PARM                    VISCY
      ** Broker Chrg./Comm. Pattern                                                           CFF007
     C                   PARM                    ITBCPT                                       CFF007
      ** Market                                                                               CFF007
     C                   PARM                    SMRKT                                        CFF007
      ** Instrument                                                                           CFF007
     C                   PARM                    SISTC                                        CFF007
      ** No. of contracts                                                                     CFF007
     C                   PARM                    VNUCO                                        CFF007
      ** Action code                                                                          CFF007
     C                   PARM                    SACTN                                        CFF007
      ** Broker                                                                               CFF007
     C                   PARM                    SBOCO                                        CFF007
      ** CFF007 enhancement                                                                   CFF007
     C                   PARM                    CFF007                                       CFF007
      ** PB customer indicator                                                                CFF007
     C                   PARM                    PPBBFLG                                      CFF007
 
      ** Record any failure
     C                   IF        ReturnCode <> *blanks
     C                   EVAL      BrokCCErr = 'Y'
 
      ** Append the array details from the above call onto the general
      ** error arrays
     C                   EXSR      AppendArrs
     C                   ENDIF
 
 
      ** 2. Customer
      ** -----------
     C                   EVAL      BrokerFlag = 'N'
     C                   RESET                   ReturnCode
     C                   CALLB     'FFVCHGCOM'
      ** Outputs from called procedure
      ** -----------------------------
      ** Return Code
     C                   PARM                    ReturnCode
      ** Field name array (<ErrArrMax> x 10A, returned to caller)
     C                   PARM                    FldNamXArr
      ** Error message ID array (<ErrArrMax> x 7A, returned to caller)
     C                   PARM                    MsgIDXArr
      ** Error message data array (<ErrArrMax> x 45A, returned to caller)
     C                   PARM                    MsgDtaXArr
      ** Broker settlement OK flags.
     C                   PARM                    OKBrokSet
      ** Customer settlement OK flags
     C                   PARM                    OKCustSet
      ** The valid settlements file format (data structure, from FFVSETLPD)
     C                   PARM                    NewTrstFil
 
      ** Inputs to called procedure
      ** --------------------------
      ** Data structure containing customer settlement details
     C                   PARM                    NewCuStScn
      ** Customer/ Broker flag (1A, Y = Broker, N = Customer)
     C                   PARM                    BrokerFlag
      ** Instrument currency (3A)
     C                   PARM                    VISCY
      ** Broker Chrg./Comm. Pattern                                                           CFF007
     C                   PARM                    ITBCPT                                       CFF007
      ** Market                                                                               CFF007
     C                   PARM                    SMRKT                                        CFF007
      ** Instrument                                                                           CFF007
     C                   PARM                    SISTC                                        CFF007
      ** No. of contracts                                                                     CFF007
     C                   PARM                    VNUCO                                        CFF007
      ** Action code                                                                          CFF007
     C                   PARM                    SACTN                                        CFF007
      ** Broker                                                                               CFF007
     C                   PARM                    SBOCO                                        CFF007
      ** CFF007 enhancement                                                                   CFF007
     C                   PARM                    CFF007                                       CFF007
      ** PB customer indicator                                                                CFF007
     C                   PARM                    PPBCFLG                                      CFF007
 
      ** Record any failure
     C                   IF        ReturnCode <> *blanks
     C                   EVAL      CustCCErr = 'Y'
 
      ** Append the array details from the above call onto the general
      ** error arrays
     C                   EXSR      AppendArrs
     C                   ENDIF
 
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT                                                                    CAP011
      *****************************************************************         CAP011
      *                                                               *         CAP011
      * TDtDtaSubs - Transaction Details Data Substitution            *         CAP011
      *                                                               *         CAP011
      *****************************************************************         CAP011
                                                                                CAP011
     C     TDtDtaSubs    BEGSR                                                  CAP011
                                                                                CAP011
     C                   RESET                   ReturnCode                     CAP011
                                                                                CAP011
      * TRANSACTION DETAILS                                                     CAP011
     C                   CALLB     'APDTASUBS'                                  CAP011
                                                                                CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode       10            CAP011
      * Substitution character                                                  CAP011
     C                   PARM      GHSUBS        SubsChar          1            CAP011
      * Incoming Data                                                           CAP011
     C                   PARM      NewTranScn    IncDATA        2000            CAP011
      * Current Data                                                            CAP011
     C                   PARM      CurTranScn    CurDATA        2000            CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       NewTranScn                     CAP011
                                                                                CAP011
      * BROKER SETTLEMENT DETAILS                                               CAP011
     C                   CALLB     'APDTASUBS'                                  CAP011
                                                                                CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode       10            CAP011
      * Substitution character                                                  CAP011
     C                   PARM      GHSUBS        SubsChar          1            CAP011
      * Incoming Data                                                           CAP011
     C                   PARM      NewBrStScn    IncDATA        2000            CAP011
      * Current Data                                                            CAP011
     C                   PARM      CurBrStScn    CurDATA        2000            CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       NewBrStScn                     CAP011
                                                                                CAP011
      * CUSTOMER SETTLEMENT DETAILS                                             CAP011
     C                   CALLB     'APDTASUBS'                                  CAP011
                                                                                CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode       10            CAP011
      * Substitution character                                                  CAP011
     C                   PARM      GHSUBS        SubsChar          1            CAP011
      * Incoming Data                                                           CAP011
     C                   PARM      NewCuStScn    IncDATA        2000            CAP011
      * Current Data                                                            CAP011
     C                   PARM      CurCuStScn    CurDATA        2000            CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       NewCuStScn                     CAP011
                                                                                CAP011
     C                   ENDSR                                                  CAP011
      *****************************************************************         CAP011
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Access Bank details via access program
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Get the module flags
     C                   CALLB     'AOMMODR0'                                                  CPM00
     C                   PARM      *BLANKS       @RTCD                                         CPM00
     C                   PARM      '*FIRST '     @OPTN                                         CPM00
     C     SDMMOD        PARM      SDMMOD        DSFDY                                         CPM00
 
      ** Get the General Ledger ICD
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
 
      ** Get the trading details
     C                   CALLB     'AOTRADR0'                                                  S0119
     C                   PARM      '*DBERR '     @RTCD             7                           S0119
     C                   PARM      '*FIRST '     @OPTN             7                           S0119
     C     SDTRAD        PARM      SDTRAD        DSFDY                                         S0119
 
      ** Access Dealing ICD
     C**********         CALL      'AODEALR0'                                                 CGL029
     C                   CALL      'AODEALR1'                                                 CGL029
     C                   PARM      '*DBERR'      @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
 
 
      ** Get the portfolio ICD
     C     BGPFMG        IFEQ      'Y'
     C                   CALLB     'AOPORTR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDPORT        PARM      SDPORT        DSFDY
     C                   ENDIF
 
      ** Get the retail ICD
     C     BGRTBN        IFEQ      'Y'
     C     BGIOAC        OREQ      'Y'
     C                   CALLB     'AORETLR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDRETL        PARM      SDRETL        DSFDY
     C                   ENDIF
 
      ** Futures and Options ICD
     C                   CALL      'AOFODAR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDFODA        PARM      SDFODA        DSFDY
                                                                                CAP011
      ** Get the API ICD                                                        CAP011
     C                   CALLB     'AOAPIR0'                                    CAP011
     C                   PARM      '*DBERR '     @RTCD                          CAP011
     C                   PARM      '*FIRST '     @OPTN                          CAP011
     C     SDAPI         PARM      SDAPI         DSFDY                          CAP011
 
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
      ** Determine if CSC011 is installed                                                     CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRTCD                                        CSC011
     C                   PARM      '*VERIFY'     POPTN                                        CSC011
     C                   PARM      'CSC011'      PSARD                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRTCD = *BLANKS                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   OPEN      APILOGL0                                                   CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      ** Determine if S01457 is installed                                                     208635
                                                                                              208635
     C                   CALLB     'AOSARDR0'                                                 208635
     C                   PARM      *BLANKS       @RTCD                                        208635
     C                   PARM      '*VERIFY'     @OPTN                                        208635
     C                   PARM      'S01457'      PSARD                                        208635
     C     SCSARD        PARM      SCSARD        DSFDY                                        208635
                                                                                              208635
     C     @RTCD         IFEQ      *BLANKS                                                    208635
     C                   MOVE      'Y'           S01457            1                          208635
     C                   ELSE                                                                 208635
     C                   MOVE      'N'           S01457                                       208635
     C                   ENDIF                                                                208635
                                                                                              CGL014
      ** Check if enhancement CGL014 (Collaterals Processing) is on                           CGL014
                                                                                              CGL014
     C                   CALLB     'AOSARDR0'                                                 CGL014
     C                   PARM      *BLANKS       @RTCD                                        CGL014
     C                   PARM      '*VERIFY'     @OPTN                                        CGL014
     C                   PARM      'CGL014'      PSARD                                        CGL014
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL014
                                                                                              CGL014
     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                  CGL014
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL014
     C                   EVAL      DBKEY  = 'CGL014'                                          CGL014
     C                   EVAL      DBASE  = 3                                                 CGL014
     C                   EXSR      *PSSR                                                      CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C                   IF        @RTCD = *BLANKS                                            CGL014
     C                   EVAL      CGL014 = 'Y'                                               CGL014
     C                   ELSE                                                                 CGL014
     C                   EVAL      CGL014 = 'N'                                               CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
      * Key Lists
 
     C     ZATRNKD0      KLIST
     C                   KFLD                    @FOTRANSEL
     C                   KFLD                    @TMESTPSEL
     C     ZATRNKX0      KLIST
     C                   KFLD                    @TMESTPSEL
     C                   KFLD                    @FOTRANSEL
                                                                                              CSC011
      ** Key List for access to API standard log file                                         CSC011
     C     KAPILOG       KLIST                                                                CSC011
     C                   KFLD                    WMTYP                                        CSC011
     C                   KFLD                    @FOTRANSEL                                   CSC011
     C                   KFLD                    @TMESTPSEL                                   CSC011
                                                                                              CSC011
 
      ** Set the transaction typed field used by the database updater
     C                   EVAL      TransType = 'EXTR'
 
      ** Get the field number for the action code field; the screen fields
      ** start from that number.  Subtract one from it to give the value
      ** to subtract from each field's number.
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM                    ReturnCode
     C                   PARM                    Format
     C                   PARM                    Field
     C                   PARM                    FieldNo
 
     C                   IF        ReturnCode = *blank
     C                   EVAL      FldOffset = FieldNo - 1
 
      ** If there was an error default the offset to 13
     C                   ELSE
     C                   EVAL      FldOffset = 13
     C                   ENDIF
 
      ** Use the get record length function to retrieve the record
      ** lengths of the error OK-flag files.  As each field on these is
      ** only one byte, this gives us the number of fields.  Use these
      ** values to calculate the start positions in the array of error
      ** flags for the various data structures.
     C                   EVAL      FileName = 'FFEEXTRPD'
     C                   CLEAR                   RecordLen
     C                   CLEAR                   ReturnCode
     C                   CALLB     'UTGETRCDLN'
      ** Return code
     C                   PARM                    ReturnCode
      ** Record length
     C                   PARM                    RecordLen
      ** File name
     C                   PARM                    FileName
      ** File library
     C                   PARM                    FileLib
 
     C                   EVAL      BSetStart = RecordLen + 1
 
     C                   EVAL      FileName = 'FFEBSETPD'
     C                   CLEAR                   RecordLen
     C                   CLEAR                   ReturnCode
     C                   CALLB     'UTGETRCDLN'
      ** Return code
     C                   PARM                    ReturnCode
      ** Record length
     C                   PARM                    RecordLen
      ** File name
     C                   PARM                    FileName
      ** File library
     C                   PARM                    FileLib
 
     C                   EVAL      CSetStart = BSetStart + RecordLen
 
      ** Start on Browse Screen
     C                   MOVEL     'B'           @SCRN             1
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,FFEXTRR011
      *                                                                                       CER001
      ** Verify if ULX604 is switched-ON                                                      CER001
      *                                                                                       CER001
     C                   MOVEL     'N'           ULX604            1                          CER001
     C                   CALLB     'AOSARDR0'                                                 CER001
     C                   PARM      '       '     @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX604'      @SARD             6                          CER001
                                                                                              CER001
     C                   IF        @RTCD   = *BLANK                                           CER001
     C                   EVAL      ULX604  = 'Y'                                              CER001
      *                                                                                       CER001
      ** Do not process lux extension details when Lux Return indicator is                    CER001
      ** not set to 'Y'                                                                       CER001
      *                                                                                       CER001
     C                   IF        BGLRIN <> 'Y'                                              CER001
     C                   EVAL      ULX604  = 'N'                                              CER001
     C                   ELSE                                                                 CER001
     C                   OPEN      FFIETLX1L0                                                 CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
                                                                                              CER001
     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                  CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBKEY  = 'ULX604'                                          CER001
     C                   EVAL      DBASE  = 4                                                 CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C     K@KEY1        KLIST                                                                CER001
     C                   KFLD                    #1TMST                                       CER001
     C                   KFLD                    #1FOTR                                       CER001
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
