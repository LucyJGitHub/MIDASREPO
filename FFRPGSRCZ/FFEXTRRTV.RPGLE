     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Exch-tr/settl retr + act/deal validation')    *
      *****************************************************************
      *                                                               *
      *  Midas - Futures and Options Module                           *
      *                                                               *
      *  FFEXTRRTV - Futures and Options exchange-traded retrieve     *
      *             (with action code versus transaction number       *
      *             validation).                                      *
      *                                                               *
      *  Function:  This module retrieves a futures and options       *
      *             transaction from the database. As it does so,     *
      *             it validates the action code and transaction      *
      *             number.                                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD000091           Date 09May13               *
      *  Prev Amend No. AR996631           Date 28Jun12               *
      *                 CAP208             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP191             Date 26Nov09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG6979            Date 04May05               *
      *                 220956             Date 01Sep03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS002             Date 14Jan02               *
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CFF007             Date 13Feb01               *
      * Midas DBA 3.05 -----------------------------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 172127             Date 25May00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 163820             Date 15Jul99               *
      * Midas DBA 3.01 Patch E ---------------------------------------*
      *                 170520             Date 19Nov99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 CAP006             Date 16Nov98               *
      *                 147775             Date 16Nov98               *
      *                 CAP004  *CREATE    Date 23Jun98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD000091 - Event Codes Substitution                          *
      *  AR996631 - System should not validate deal number range      *
      *             if PEA indicator is on                            *
      *  CAP208 - F&O Market Instrument API (Recompile)               *
      *  CAP191 - MQ Enabling of FUND and EXTR APIs (Recompile)       *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG6979 - Ensure ZMUSER is re-checked on every call,         *
      *            move out of *INZSR.                                *
      *  220956 - Fix to single-branch processing: should             *
      *           only check action code authority if single-branch   *
      *           code is defined.                                    *
      *  CAS002 - Hedge Strategy/Linkage (Recompile)                  *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CFF007 - Futures and Options Enhancement for Private Banking *
      *           (Recompiled)                                        *
      *  172127 - FF exch. trades input fails with an error in FDATE. *
      *  163820 - Transactions Repair Function performs SPF checking  *
      *           to find if user is authorised to the Branch , but   *
      *           does that against User's Default Branch code instead*
      *           of the selected transaction's Booking/Origin branch *
      *  170520 - Recompile over changed TRANSD file                  *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  CAP006 - APIs Phase IV                                       *
      *           Record updated by another workstation               *
      *  147775 - General FF API fixes                                *
      *  CAP004 - Conversion of FF inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      * Transaction details by Front Office ID
     FFFEXTRL1  IF   E           K DISK    INFSR(*PSSR)
 
      * Exchange-traded transactions file
     FFFEXTRL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(TRANSDF:TRANSINF)
 
      * Transactions in Closure reference sequence
     FTRANS8    IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(TRANSDF:TRANS8DF)
     F                                     USROPN
 
      * Instrument types
     FINTYP     IF   E           K DISK    INFSR(*PSSR) PREFIX(IT)
 
      **Market*Centres                                                                    172127
     F*MARKT*****IF***E           K DISK    INFSR(*PSSR)                                  172127
                                                                                          172127
      * Transaction settlement details
     FTRSET     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(@)
     F                                     USROPN
 
      ** The transaction ranges file
     FZATNRGL0  IF   E           K DISK    INFSR(*PSSR) USROPN
 
      ** Transactions of all types (OTCs and all market centres) for
      ** checking availability of transaction number.
     FTRANS2    IF   E           K DISK    INFSR(*pssr) USROPN PREFIX(AT)
     F                                     RENAME(TRANSDF : TRANSD2)
 
     F/COPY WNCPYSRC,FFEXTRTF01
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structure.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID an¢ *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
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
 
      ** +--- Named indicators -------------------------------------------+
      ** ¦                                                                ¦
      ** ¦ Map variable names to indicators to allow use of names instead ¦
      ** ¦ of numbers; base the following data structure on a pointer to  ¦
      ** ¦ the indicator array.                                           ¦
     D Indicators      DS                  BASED(pIndicator)
      ** ¦                                                                ¦
     D  NoRecFound            99     99
      ** ¦                                                                ¦
      ** ¦                                                                ¦
      ** ¦ Set the indicator array pointer                                ¦
     D pIndicator      S               *   INZ(%Addr(*In))
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for bank details
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** External DS for General Ledger details
     D  OBUU         E                     EXTFLD(BKOBRU)
     D  OBUV         E                     EXTFLD(BKOBUV)
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D TranFlFmt     E DS                  EXTNAME(TRANSD)
      ** Transaction in File Format
 
     D TrStFlFmt     E DS                  EXTNAME(TRSETD)
     D                                     PREFIX(@)
      ** Transaction Settlement details in file format
 
     D MarketCont    E DS                  EXTNAME(MKCTLD) PREFIX(M)
      ** Market control details
 
     D MarketCent    E DS                  EXTNAME(MARKT)  PREFIX(MK)
      ** Market centre details
 
     D InstType      E DS                  EXTNAME(INTYPD)  PREFIX(IT)
      ** Market centre details
                                                                                              CSC011
      ** Externally described DS for SAR details                                              CSC011
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC011
     D    SARLCD     E                     EXTFLD(LCD)                                        CSC011
                                                                                              CSC011
      ** Data structure for data area SC24X7                                                  CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
                                                                                              CSC011
      ** Data structure for data area SDSTAT                                                  CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
 
     D ZMUSER          DS            17    DTAARA(ZMUSER)
      ** User's default branch and department
     D  BRC                   11     13
     D  DEPT                  14     16
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Mode of operation
     D ModeOfOp        S              6A
 
      ** Front office transaction ID
     D  FOTrID         S             20A
 
      ** Action code OK flag
     D OKACTN          S              1A
 
      ** Market OK flag
     D OKMRKT          S              1A
 
      ** Transaction number OK flag
     D OKTNBR          S              1A
 
      ** Booking branch OK flag
     D OKBRCA          S              1A
 
      ** Response mode (1A, from caller (A=Asynchronous, S=Synchronous))
     D RespMode        S              1A
 
      ** Transaction Number
     D STNBR           S              6A
 
      ** Market
     D SMRKT           S              2A
 
      ** Action code
     D SACTN           S              1A
 
      ** Booking branch
     D SBRCD           S              3A
 
      ** Current trading date
     D CTDATE          S              5P 0
 
      ** Month of required date
     D FFMTH           S              2P 0
 
      ** Year of required date
     D FFYR            S              2P 0
 
      ** Working day defined by input fields
     D FFDAY           S              5P 0
 
      ** Module being called as linked enquiry
     D LnkEnq          S              1A
 
      ** Market
     D Market          S              2A
 
      ** Enquiry on Deleted Record? (Y or N)
     D EODR            S              1A
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Multi-branching indicator (passed from FFEXTRSIN)
     D  @MBIN          S              1A
 
      ** The module ID for transaction range number checking
     D Module          S              2A   INZ('FF')
                                                                                              CSC011
      ** Define variable for switchable CSC011.                                               CSC011
     D CSC011          S              1A   INZ('N')                                           CSC011
                                                                                              CSC011
      ** Define parameters for AOSARDR0                                                       CSC011
     D PRTCD           S              7A                                                      CSC011
     D POPTN           S              7A                                                      CSC011
     D PSARD           S              6A                                                      CSC011
      *                                                                                     AR996631
     D PSysVal1        C                   CONST('PEAIndicator')                            AR996631
     D PRetCode        S              7A                                                    AR996631
     D P@OP01          S             20A                                                    AR996631
     D P@VL01          S            200A                                                    AR996631
     D P@OP02          S             20A                                                    AR996631
     D P@VL02          S            200A                                                    AR996631
     D P@OP03          S             20A                                                    AR996631
     D P@VL03          S            200A                                                    AR996631
     D P@OP04          S             20A                                                    AR996631
     D P@VL04          S            200A                                                    AR996631
     D P@OP05          S             20A                                                    AR996631
     D P@VL05          S            200A                                                    AR996631
     D P@OP06          S             20A                                                    AR996631
     D P@VL06          S            200A                                                    AR996631
     D P@OP07          S             20A                                                    AR996631
     D P@VL07          S            200A                                                    AR996631
     D P@OP08          S             20A                                                    AR996631
     D P@VL08          S            200A                                                    AR996631
     D P@OP09          S             20A                                                    AR996631
     D P@VL09          S            200A                                                    AR996631
     D P@OP10          S             20A                                                    AR996631
     D P@VL10          S            200A                                                    AR996631
     D WPEAInd         S              1A                                                    AR996631
     D CSC054          S              1A                                                    AR996631
                                                                                            MD000091
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      **************************************************************
 
     C     Start         TAG
      ** Note: the above tag is only there to force the first comments in
      ** the C-specs to appear after the D- or I-specs in compiled listings.
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *
      * Initialisation
      *
     C                   EXSR      INIT
      *
      * If the mode is 'Front office', do specific validation for
      * front-office transactions.
      *
     C     ModeofOp      IFEQ      '*FRONT'
     C                   EXSR      VFRNT
      *
      **  Carry out no further validation if errors have occurred.
      *
     C                   IF        OKACTN='N' OR OKTNBR='N' OR OKMRKT='N'
     C                   RETURN
     C                   ENDIF
 
     C                   ENDIF
      *
      * Validate action code and transaction number
     C                   EXSR      VAL
      *
      **  Carry out no further validation if errors have occurred.
      *
     C                   IF        OKACTN='N' OR OKTNBR='N'
     C                             OR OKMRKT='N'
     C                   RETURN
     C                   ENDIF
      *
      *  *-----------------------------------------------*
      *  * Access Security Checking                      *
      *  *-----------------------------------------------*
      *
     C     RespMode      IFEQ      'S'
     C                   EXSR      ACSSEC
     C                   ENDIF
      *
      * Return
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * VFRNT - VALIDATION FOR FRONT OFFICE TRANSACTION INTERFACE
      *****************************************************************
     C     VFRNT         BEGSR
      *
      * ERROR IF ACTION CODE IS NOT 'I', 'A, or 'D'.
      *
     C     SACTN         IFNE      'I'
     C     SACTN         ANDNE     'A'
     C     SACTN         ANDNE     'D'
     C/COPY WNCPYSRC,FFEXTRTC01
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SACTN'
     C                   MOVEL     'APM0111'     MsgIdArr(Idx)
     C                   GOTO      EVFRNT
     C                   ENDIF
      *
      * ERROR IF FRONT OFFICE TRANSACTION ID IS BLANK
      *
     C     FOTRID        IFEQ      *BLANK
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Idx
     C                   Eval      FldNameArr(Idx) = 'SACTN'
     C                   MOVEL     'APM0101'     MsgIdArr(Idx)
     C                   GOTO      EVFRNT
     C                   ENDIF
      *
      * ACCESS TRANSACTION WITH FRONT OFFICE TRANSACTION ID
      *
     C     FOTRID        CHAIN     FFEXTRL1                           99
      *
      * IF INSERT
      *
     C     SACTN         IFEQ      'I'
      *
      * FRONT OFFICE TRANSACTION ID CAN'T BE PRESENT ALREADY
      *
     C     *IN99         IFEQ      '0'
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Idx
     C                   Eval      FldNameArr(Idx)='SACTN'
     C                   MOVEL     'APM0102'     MsgIdArr(Idx)
     C**********         MOVEL     FOTRID        MsgDtaArr(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(FOTRID)                   MD000091
     C                   GOTO      EVFRNT
     C                   ENDIF
 
     C                   ELSE
      *
      * IF NOT INSERT, FRONT OFFICE TRANSACTION ID MUST BE PRESENT
      *
     C     *IN99         IFEQ      '1'
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Idx
     C                   Eval      FldNameArr(Idx) = 'SACTN'
     C                   MOVEL     'APM0103'     MsgIdArr(Idx)
     C**********         MOVEL     FOTRID        MsgDtaArr(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(FOTRID)                   MD000091
     C                   GOTO      EVFRNT
     C                   ENDIF
      *
      * IF NOT INSERT, UPDATE MIDAS TRANSACTION NUMBER
      *
     C                   MOVEL     TNBR          STNBR
 
     C                   ENDIF
      *
     C     EVFRNT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * MarkDets - Get Market details
      *****************************************************************
     C     MarkDets      BEGSR
 
      * Get market details and market control
      *
     C                   CALLB     'FFVMARKET'
      *
      * Outputs
      * ~~~~~~~
     C                   PARM                    ReturnCode
     C                   PARM                    FldNamXArr
     C                   PARM                    MsgIDXArr
     C                   PARM                    MsgDtaXArr
     C                   PARM                    MarketCont
     C                   PARM                    MarketCent
      *
      * Inputs
      * ~~~~~~
     C                   PARM                    Market
     C                   PARM                    SACTN
 
      * If error(s) found, add deatails to the main arrays.
     C                   IF        ReturnCode <> *Blanks
 
     C                   RESET                   ReturnCode
     C                   CALLB     'APAPNDARRS'
      ** Outputs from called procedure
      ** -----------------------------
      ** Return code
     C                   PARM                    ReturnCode
      ** Error array index
     C                   PARM                    Idx
      ** Field names with errors array
     C                   PARM                    FldNameArr
      ** Error message ID array
     C                   PARM                    MsgIDArr
      ** Error message data array
     C                   PARM                    MsgDtaArr
      ** Warning array index
     C                   PARM                    WIdx
      ** Field names with warnings array
     C                   PARM                    WFldNamArr
      ** Warning message ID array
     C                   PARM                    WMsgIDArr
      ** Warning message data array
     C                   PARM                    WMsgDtaArr
 
      ** Inputs to called procedure
      ** --------------------------
      ** Field name array
     C                   PARM                    FldNamXArr
      ** Error message ID array
     C                   PARM                    MsgIDXArr
      ** Error message data array
     C                   PARM                    MsgDtaXArr
      ** Field name array
     C                   PARM                    FldNamWArr
      ** Warning message ID array
     C                   PARM                    MsgIDWArr
      ** Warning message data array
     C                   PARM                    MsgDtaWArr
 
     C                   EVAL      OKMRKT = 'N'
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL - VALIDATION OF ACTION CODE, TRANSACTION NUMBER AND MARKET
      *       VALIDATION OF SETTLEMENT DETAILS
      *****************************************************************
     C     VAL           BEGSR
 
      * ACTION CODE
      * ~~~~~~~~~~~
     C     SACTN         IFNE      'I'
     C     SACTN         ANDNE     'A'
     C     SACTN         ANDNE     'D'
     C     SACTN         ANDNE     'E'
     C/COPY WNCPYSRC,FFEXTRTC02
     C     LnkEnq        OREQ      'Y'
     C     SACTN         ANDNE     'E'
     C                   EVAL      ErrorFound = 'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SACTN'
     C                   MOVEL     'BBM0001'     MsgIdArr(Idx)
     C                   EVAL      OKACTN = 'N'
     C                   ENDIF
 
      *  MARKET
      *  ~~~~~~
     C                   EVAL      Market = SMRKT
     C                   EXSR      MarkDets
 
     C                   IF        OKMRKT = 'N'
     C                   GOTO      ENDVAL
 
     C                   ELSE
 
      ** Apply the multimember file overrides for the transaction, and
      ** get the current trading date.
     C                   RESET                   ReturnCode
     C                   CALLB     'FFAPYOVR'
     C                   PARM                    ReturnCode
     C                   PARM                    SMRKT
 
     C                   EXSR      GetCTDate
 
     C                   ENDIF
 
      * TRANSACTION NUMBER
      * ~~~~~~~~~~~~~~~~~~
 
      ** The transaction number can be blank on insert, so bypass all
      ** further validation in this case.
     C                   IF        STNBR <> *blanks OR SACTN <> 'I'
 
      **   Reset Processing
     C                   Z-ADD     0             KCLON
 
      **  1. Transaction number must be numeric and positive.
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      STNBR         ZFIELD
     C                   Z-ADD     6             ZADIG
     C                   Z-ADD     0             ZADEC
 
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   PARM                    ZADIG             2 0
 
     C                   IF        ZALIGNok = 'N'
     C                   EVAL      ErrorFound = 'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'STNBR'
     C                   MOVEL     'APM0112'     MsgIdArr(Idx)
     C                   EVAL      OKTNBR = 'N'
     C                   GOTO      ENDVAL
 
     C                   ELSE
      **                 (ZALIGN ok)
 
     C                   MOVE      ZFIELD        KTNBR             6 0
 
     C                   IF        WPEAInd <> 'Y'                                           AR996631
      **  1.5 Transaction number must be within the range for manual
      **      transaction numbers (on insert)
      ** (do not check if deal number generated through APIs)                   CAP006
     C******             IF        SACTN = 'I'                                  CAP006
     C                   IF        SACTN = 'I' AND ModeofOp <> '*FRONT'         CAP006
 
     C                   IF        KTNBR < FNOR
     C                   EVAL      ErrorFound = 'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'STNBR'
     C                   EVAL      MsgIdArr(Idx) = 'MMA0713'
     C**********         MOVEL     FNOR          MsgDtaArr(Idx)                             MD000091
     C                   MOVEL     FNOR          MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(MsgDtaTmp)                MD000091
     C                   EVAL      OKTNBR = 'N'
     C                   GOTO      ENDVAL
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF                                                              AR996631
      **                 (End of "If action = I")
 
     C                   ENDIF
      **                 (End of "If ZALIGN not OK")
 
     C     SACTN         IFEQ      'I'
 
      *    Insert
      *    ~~~~~~
      *    2. Record must not exist already, on any of TRANSD's members
     C                   OPEN      TRANS2
     C     KTNBR         CHAIN     TRANS2                             99
     C                   CLOSE     TRANS2
 
     C                   IF        NoRecFound = False
     C                   EVAL      ErrorFound = 'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'STNBR'
     C                   MOVEL     'APM0113'     MsgIdArr(Idx)
     C                   EVAL      OKTNBR = 'N'
 
     C                   ENDIF
 
     C                   ELSE
 
      *    Amend, Delete and Enquire
      *    ~~~~~~~~~~~~~~~~~~~~~~~~~
      *    3. Record must already exist
     C     KTNBR         CHAIN     FFEXTRL0                           99
 
     C                   IF        NoRecFound = False
 
      ** Access INTYP for instrument details
 
     C     ISTT          CHAIN     INTYP                              99
 
      ** If a record not found
     C                   IF        NoRecFound=True
     C     *LOCK         IN        LDA
     C                   Z-ADD     10            DBASE
     C                   MOVEL     'INTYP'       DBFILE
     C                   MOVEL     ISTT          DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Market on trade differs from market supplied
 
     C                   MOVEL     ISTT          TradeMRKT         2
     C                   IF        TradeMRKT  <>  SMRKT
     C                   Eval      NoRecFound = True
     C                   ENDIF
 
     C                   EVAL      EODR = 'N'
 
      ** Enquiry on Deleted Record?
 
     C                   IF        SACTN = 'E' AND RECI = '*'
     C                   EVAL      EODR = 'Y'
     C                   ENDIF
 
      *  Check if the record ID is 'R' as system changes the record ID
      *  of a deleted trade to 'R' during COB
 
     C                   IF        SACTN = 'E' AND RECI = 'R'
     C                   EVAL      EODR = 'Y'
     C                   ENDIF
 
     C                   IF        EODR <>'Y' AND RECI <>'D'
     C                   Eval      NoRecFound = True
     C                   ENDIF
     C                   ENDIF
 
      **   - Record does not exist (NB. can enquire on deleted records)
 
     C                   IF        NoRecFound = True
     C                   EVAL      ErrorFound = 'Y'
     C                   ADD       1             Idx
     C                   Eval      FldNameArr(Idx) = 'STNBR'
     C                   MOVEL     'APM0114'     MsgIdArr(Idx)
     C                   EVAL      OKTNBR = 'N'
     C                   GOTO      ENDVAL
     C                   ELSE
 
     C                   MOVE      'Y'           RECEXST           1
     C                   ENDIF
 
      **   4. Transaction type must be 'P' or 'S'
      **      but don't validate on enquire
     C                   IF        SACTN <> 'E'
     C     TRTY          IFNE      'P'
     C     TRTY          ANDNE     'S'
     C                   EVAL      ErrorFound = 'Y'
     C                   ADD       1             Idx
     C                   Eval      FldNameArr(Idx) = 'STNBR'
     C                   MOVEL     'MMA0329'     MsgIdArr(Idx)
     C                   EVAL      OKTNBR = 'N'
     C                   GOTO      ENDVAL
     C                   ENDIF
 
     C                   ENDIF
 
      **   5. If delete, a transaction must not exist on LF/TRANS8 with
      **    its Closure Ref. = this Transaction No.
 
     C     SACTN         IFEQ      'D'
     C                   MOVE      STNBR         KCLSR8
     C                   MOVE      'E'           KTRTY8
 
      ** TRANS8 is opened and closed for each chain to ensure that the
      ** correct, overriden-to member is opened.
     C                   OPEN      TRANS8
     C     KTRNS8        CHAIN     TRANS8                             99
     C                   CLOSE     TRANS8
     C
     C                   IF        NoRecFound = False AND CLSR=KCLSR8
     C                   EVAL      ErrorFound = 'Y'
     C                   ADD       1             Idx
     C                   Eval      FldNameArr(Idx) = 'STNBR'
     C                   MOVEL     'APM0116'     MsgIdArr(Idx)
     C                   EVAL      OKTNBR = 'N'
     C                   GOTO      ENDVAL
     C                   ENDIF
 
     C                   ENDIF
 
      **   6. If delete or amend, the settlement date of the instrument
      **      associated with the trade must be greater than or equal
      **      to the current trading date, which is the market centre
      **      business for a market traded instrument.
 
     C     SACTN         IFEQ      'D'
     C     SACTN         OREQ      'A'
      *
      ** If the instrument is a market instrument the settlement
      ** date for the instrument must be calculated from a settlement
      ** date formula using module FFDATE.
      *
      *
     C                   Z-ADD     YRNO          FFYR
     C                   Z-ADD     MTHN          FFMTH
 
     C                   CALLB     'FFDATE'
      ** Return code (10A, returned to caller)
     C                   PARM                    ReturnCode
      ** Working day (5,0P)
     C                   PARM                    FFDAY
      ** Date formula (7A)
     C                   PARM                    ITSEDF
      ** Month of required date (2,0P)
     C                   PARM                    FFMTH
      ** Year of required date (2,0P)
     C                   PARM                    FFYR
      ** Market currency (3A)
     C**********         PARM                    MKLC                                     172127
     C                   PARM                    MKMKLC                                   172127
      ** Market location (3A)
     C**********         PARM                    MLOC                                     172127
     C                   PARM                    MKMLOC                                   172127
      ** Instrument currency (3A)
     C                   PARM                    ISCY
      ** Other currency (3A)
     C                   PARM                    ITOTHC
      ** Date format indicator (1A, from RUNDAT or SDBANKPD)
     C                   PARM                    BJDFIN
     C                   MOVE      FFDAY         ITSETD
 
      ** If settlement  date is less than the current trading date,
      ** date validation error has occured.
      *
     C     ITSETD        IFLT      CTDATE
     C                   EVAL      ErrorFound = 'Y'
     C                   ADD       1             Idx
     C                   Eval      FldNameArr(Idx) = 'STNBR'
     C                   MOVEL     'APM0117'     MsgIdArr(Idx)
     C                   EVAL      OKTNBR = 'N'
     C                   GOTO      ENDVAL
     C                   ENDIF
 
     C                   ENDIF
     C/COPY WNCPYSRC,FFEXTRTC03
 
      *  SETTLEMENTS
      *  ~~~~~~~~~~~
 
     C     RECEXST       IFEQ      'Y'
 
      ** TRSET is opened and closed for each chain to ensure that the
      ** correct, overriden-to member is opened.
     C                   OPEN      TRSET
     C     TNBR          CHAIN     TRSET                              99
     C                   CLOSE     TRSET
     C                   IF        NoRecFound = True AND EODR <> 'Y'
     C                             AND @RECI <> 'D'
     C     *LOCK         IN        LDA
     C                   Z-ADD     11            DBASE
     C                   MOVEL     'SETTL'       DBFILE
     C                   MOVEL     TNBR          DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
      **                 (End of "If transaction number is not blank or
      **                  action is not insert".)
 
     C     ENDVAL        ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * GetCTDate - Determine the current trading date                *
      *                                                               *
      *****************************************************************
 
     C     GetCTDate     BEGSR
 
      ** Set up the current trading date
      ** -------------------------------
      ** MBUSD is from MKCTL and BJRDNB is from SDBANKPD
 
     C                   IF        MBUSD = 0
     C                   EVAL      CTDATE = BJRDNB
                                                                                              CSC011
      ** If 24x7 Midas availability is installed and user is in support                       CSC011
      ** system, set the trading date to the processing date held in                          CSC011
      ** dtaara SC24X7                                                                        CSC011
                                                                                              CSC011
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         CSC011
     C                   EVAL      CTDATE = S1DATE                                            CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ELSE
     C                   EVAL      CTDATE = MBUSD
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * ACSSEC - ACCESS SECURITY CHECKING
      *****************************************************************
     C     ACSSEC        BEGSR
 
      *  Single Branch
      *  ~~~~~~ ~~~~~~
      * If not multi-branching, check authority to only action code
 
     C     RECEXST       IFEQ      'Y'
     C     LnkEnq        IFNE      'Y'
     C     @MBIN         IFNE      'Y'
 
      * ... but we only check the action code if the single-branch code is set                220956
     C     BJSBRC        ANDNE     *BLANKS                                                    220956
 
     C                   CALL      'ZVACTU'
     C                   PARM      SACTN         @ZACTN            1
     C                   PARM                    @ERR              1 0
     C     @ERR          IFNE      *ZERO
     C                   EVAL      ErrorFound = 'Y'
     C                   ADD       1             Idx
     C                   Eval      FldNameArr(Idx) = 'SACTN'
     C                   MOVEL     'APM0118'     MsgIdArr(Idx)
     C                   EVAL      OKACTN = 'N'
     C                   GOTO      EACSSE
     C                   ENDIF
 
     C                   ELSE
 
      *  Multi-branching
      *  ~~~~~~~~~~~~~~~
      *  Access file for transaction associated  branch code
      *  for validation.
      ***If*insert*and*branch*has*not*been*entered,*use*the*user's                            163820
      ***default*branch*from*ZMUSER.                                                          163820
     C*************      IF        SACTN = 'I' AND BRCA = *blanks                             163820
     C*************      EVAL      BRCA = BRC                                                 163820
     C*************      ENDIF                                                                163820
                                                                                              163820
      * Do not default to User's Branch code , and perform security checking                  163820
      * for it when action code is Not 'I' - Insert .                                         163820
      *                                                                                       163820
     C     SACTN         IFNE      'I'                                                        163820
      *                                                                                       163820
 
     C                   CALL      'ZVACTBU'
     C                   PARM      SACTN         @ZACTN            1
     C                   PARM      BRCA          @ZBR              3
     C                   PARM                    @ERR              1 0
 
     C     @ERR          IFNE      *ZERO
     C                   EVAL      ErrorFound = 'Y'
     C                   ADD       1             Idx
     C                   Eval      FldNameArr(Idx) = 'SACTN'
     C                   MOVEL     'APM0119'     MsgIdArr(Idx)
     C                   EVAL      OKACTN = 'N'
     C                   EVAL      OKTNBR = 'N'
     C                   GOTO      EACSSE
     C                   ENDIF
     C                   ENDIF                                                                163820
 
 
      * Check authority to originating branch
     C     OBUU          IFEQ      'Y'
     C     OBUV          ANDEQ     'Y'
     C     SACTN         ANDNE     'E'
     C     SACTN         ANDNE     'I'
     C                   CALL      'ZVOBU'
     C                   PARM      ORBR          @ZBR              3
     C                   PARM                    @ERR              1 0
     C     @ERR          IFNE      *ZERO
     C                   EVAL      ErrorFound = 'Y'
     C                   ADD       1             Idx
     C                   Eval      FldNameArr(Idx) = 'SACTN'
     C                   MOVEL     'APM0120'     MsgIdArr(Idx)
     C                   EVAL      OKACTN = 'N'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
     C     EACSSE        ENDSR
 
      *****************************************************************
      * INIT - INITIALISATION
      *****************************************************************
 
     C     INIT          BEGSR
                                                                                             BUG6979
      ** Retrieve the user's default branch and department                                   BUG6979
     C                   IN        ZMUSER                                                    BUG6979
 
      * CLEAR OUTPUTS
     C                   CLEAR                   InstType
     C                   CLEAR                   TranFlFmt
     C                   CLEAR                   TrStFlFmt
     C                   MOVEL     'Y'           OKACTN
     C                   MOVEL     'Y'           OKTNBR
     C                   MOVEL     'Y'           OKMRKT
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      * Parameters
      *
     C     *ENTRY        PLIST
      * Return code
     C                   PARM                    ReturnCode
 
      ** Received parameters
      ** -------------------
      * Mode = '*FRONT' (front office transaction interface)
      * Mode = '      ' (not front office transaction interface) (6A)
     C                   PARM                    ModeofOp
      * Response mode (1A)
     C                   PARM                    RespMode
      * Action Code (1A)
     C                   PARM                    SACTN
      * Front Office Transaction ID (20A)
     C                   PARM                    FOTRID
      * (Midas) Transaction Number (6A)
     C                   PARM                    STNBR
      * (Midas) Market (1A)
     C                   PARM                    SMRKT
      ** Module being called as linked enquiry (1A)
     C                   PARM                    LnkEnq
      * Standing Data and mulit-branching indicator
     C                   PARM                    SDBANK
     C                   PARM                    SDGELR
     C                   PARM                    @MBIN
 
      ** Returned parameters
      ** -------------------
      ** Current transaction in file format
     C                   PARM                    TranFlFmt
      ** Current transaction settlement details in file format
     C                   PARM                    TrStFlFmt
      ** Instrument types
     C                   PARM                    InstType
      * OK - Action code (1A)
     C                   PARM                    OKACTN
      * OK - Transaction Number (1A)
     C                   PARM                    OKTNBR
      * OK - Market (1A)
     C                   PARM                    OKMRKT
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      **********                                                                             BUG6979
      ***Retrieve*the*user's*default*branch*and*department                                   BUG6979
     C**********         IN        ZMUSER                                                    BUG6979
 
      ** Retrieve the transaction range details
     C                   OPEN      ZATNRGL0
     C     TranRangeK    CHAIN     ZATNRGL0                           99
     C                   CLOSE     ZATNRGL0
 
      ** Database error processing:
     C                   IF        NoRecFound = True
     C                   EVAL      DBKEY = Module
     C                   EVAL      DBFILE = 'ZATNRGL0'
     C                   EVAL      DBASE = 1                                    * DBERR 904*
     C                   EXSR      *PSSR                                        ************
     C                   ENDIF
                                                                                              CSC011
      ** Determine if 24x7 Midas availability is installed                                    CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRTCD                                        CSC011
     C                   PARM      '*VERIFY'     POPTN                                        CSC011
     C                   PARM      'CSC011'      PSARD                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
      ** An NRF (No Record Found) return code is valid.                                       CSC011
      ** Issue database error only for error return codes.                                    CSC011
     C                   IF        PRTCD <> *BLANKS AND PRTCD <> '*NRF   '                    CSC011
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBKey = 'CSC011'                                           CSC011
     C                   EVAL      DBASE = 2                                                  CSC011
     C                   EXSR      *pssr                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C     PRTCD         IFEQ      *BLANKS                                                    CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      ** Check if CSC054 is on                                                              AR996631
      *                                                                                     AR996631
     C                   CALLB     'AOSARDR0'                                               AR996631
     C                   PARM      *BLANKS       PRTCD                                      AR996631
     C                   PARM      '*VERIFY'     POPTN                                      AR996631
     C                   PARM      'CSC054'      PSARD                                      AR996631
     C     SCSARD        PARM      SCSARD        DSFDY                                      AR996631
      *                                                                                     AR996631
      ** An NRF (No Record Found) return code is valid.                                     AR996631
      ** Issue database error only for error return codes.                                  AR996631
      *                                                                                     AR996631
     C                   IF        PRTCD <> *BLANKS                                         AR996631
     C                             AND PRTCD <> '*NRF   '                                   AR996631
     C                   EVAL      DBFile = 'SCSARDPD'                                      AR996631
     C                   EVAL      DBKey = 'CSC054'                                         AR996631
     C                   EVAL      DBASE = 3                                                AR996631
     C                   EXSR      *PSSR                                                    AR996631
     C                   ENDIF                                                              AR996631
      *                                                                                     AR996631
     C                   EVAL      CSC054 = 'N'                                             AR996631
     C                   EVAL      WPEAInd = 'N'                                            AR996631
     C                   IF        PRTCD = *BLANKS                                          AR996631
     C                   EVAL      CSC054 = 'Y'                                             AR996631
      *                                                                                     AR996631
     C                   CALL      'AOSVALR0'                                               AR996631
     C                   PARM      *BLANKS       PRetCode                                   AR996631
     C                   PARM      PSysVal1      P@OP01                                     AR996631
     C                   PARM      *BLANKS       P@VL01                                     AR996631
     C                   PARM      *BLANKS       P@OP02                                     AR996631
     C                   PARM      *BLANKS       P@VL02                                     AR996631
     C                   PARM      *BLANKS       P@OP03                                     AR996631
     C                   PARM      *BLANKS       P@VL03                                     AR996631
     C                   PARM      *BLANKS       P@OP04                                     AR996631
     C                   PARM      *BLANKS       P@VL04                                     AR996631
     C                   PARM      *BLANKS       P@OP05                                     AR996631
     C                   PARM      *BLANKS       P@VL05                                     AR996631
     C                   PARM      *BLANKS       P@OP06                                     AR996631
     C                   PARM      *BLANKS       P@VL06                                     AR996631
     C                   PARM      *BLANKS       P@OP07                                     AR996631
     C                   PARM      *BLANKS       P@VL07                                     AR996631
     C                   PARM      *BLANKS       P@OP08                                     AR996631
     C                   PARM      *BLANKS       P@VL08                                     AR996631
     C                   PARM      *BLANKS       P@OP09                                     AR996631
     C                   PARM      *BLANKS       P@VL09                                     AR996631
     C                   PARM      *BLANKS       P@OP10                                     AR996631
     C                   PARM      *BLANKS       P@VL10                                     AR996631
      *                                                                                     AR996631
     C                   IF        PRetCode  <> *BLANKS                                     AR996631
     C                   EVAL      DBFile = 'SDSVALPD'                                      AR996631
     C                   EVAL      DBKEy = '*KEY   '                                        AR996631
     C                   EVAL      DBase = 4                                                AR996631
     C                   EXSR      *PSSR                                                    AR996631
     C                   ENDIF                                                              AR996631
      *                                                                                     AR996631
     C                   MOVEL     P@VL01        WPEAInd                                    AR996631
      *                                                                                     AR996631
     C                   ENDIF                                                              AR996631
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
      * Key Lists
      * ~~~~~~~~~
      * LF/CLOST2
     C     KCLST2        KLIST
     C                   KFLD                    KTNBR             6 0
     C                   KFLD                    KCLON             6 0
      * LF/TRANS8
     C     KTRNS8        KLIST
     C                   KFLD                    KCLSR8            6 0
     C                   KFLD                    KTRTY8            1
 
      * Transaction ranges file, LF/ZATNRGL0
     C     TranRangeK    KLIST
     C                   KFLD                    Module
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
