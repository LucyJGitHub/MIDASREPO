     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FD MM interest rates repair control')
      *****************************************************************
      *                                                               *
      *  Midas - FD ILE Module                                        *
      *                                                               *
      *  FDINTRRPR - Interest Rates Repair Controlling Module         *
      *                                                               *
      *  Function:  This function allows invalid Interest Rate de -   *
      *             tails to be 'repaired' and applied to Midas       *
      *             Database.                                         *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG1625            Date 19May04               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      *                 196570             Date 20Jul01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CAP058  *CREATE    Date 13Jul00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG1625 - Commitment Control Changes for MidasPlus           *
      *  CSC011 - 24X7 Midas Availability                             *
      *  196570 - Patch for Market Data Feed                          *
      *  CAP058 - Market Data Feeds                                   *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Transaction Errors file keyed on Front Office Transaction Id and
      ** Timestamp
     FZATRNERRL0IF   E           K DISK    INFSR(*PSSR)
 
      ** Invalid Interest Rate details by Timestamp and Front Office Id
      ** (Record Retrieval)
     FFDIINTRL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FDIINTRD0:FDIINTRX0)
 
      ** Invalid Interest Rate details by Timestamp and Front Office Id
      ** (Record Update)
     FFDIINTRL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
                                                                                              CSC011
     ** API Invalid Log File                                                                  CSC011
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR) USROPN                                CSC011
     F                                     COMMIT                                             CSC011
 
      *****************************************************************
      *                                                               *
      *      FUNCTION OF INDICATORS                                   *
      *                                                               *
      *       99  Chain Indicator                                     *
      *       U6  Error Indicator                                     *
      *       LR  End of Program                                      *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *      SUBROUTINE DESCRIPTION                                   *
      *                                                               *
      *      *INZSR        - Program Initilisation                    *
      *      SrBRWINV      - Build Browse Invalid Rates Subfile       *
      *      SrRDNXTB      - Read Next Browse                         *
      *      SrSNDERR      - Send Error Messages                      *
      *      SrDSPINI      - Display Initial Screen                   *
      *      SrVALIDATE    - Validate Input                           *
      *      SrRTVDET      - Retrieve Interest Rate Details           *
      *      SrCONVERT     - Convert Interest Rate Details in Screen  *
      *                      Format                                   *
      *      SrCONFIRM     - Confirm Screen Inputs                    *
      *      SrUPDATE      - Update Database                          *
      *      SrDELETE      - Delete Record                            *
      *      SrEXITC       - Exit Confirmation Screen                 *
      *      SrSETFSTS     - Set Field Status                         *
      *      SrRESETERR    - Reset Error Fields                       *
      *      SrADDERM      - Add Error Messages to Error Arrays       *
      *      SrEND         - Program Termination                      *
      *      SrCANCEL      - Cancel Screen Inputs                     *
      *      SrTDtDSubs    - Transaction Details Data Substitution    *
      *      *PSSR         - Standard Error Subroutine                *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *      PROCEDURES AND PROGRAMS CALLED                           *
      *                                                               *
      *      FDINTRRPB     - Interest Rates Repair Browser Module     *
      *      FDINTRDSP     - Interest Rates Details Display Module    *
      *      FDINTRVAL     - Interest Rates Screen Validation Module  *
      *      FDINTRRTV     - Interest Rates Retrieve Module           *
      *      FDINTRCVT     - Interest Rates Details Convert Module    *
      *      FDINTRUPD     - Interest Rates Database Update Module    *
      *      APDTASUBS     - AP Data Substitution                     *
      *      AOBANKR0      - Access Object for Bank Details           *
      *      AOAPIR0       - Access Object for API ICD                *
      *      AOSARDR0      - Access Object for Switchable Feautres    *
      *      ZACGTFLDNO    - Get Number of Field in an API Format     *
      *                                                               *
      *****************************************************************
 
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
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **---------------------------------------------------------------
 
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
 
     D @EI             S              1    DIM(70)
 
      ** Current Interest Rates File Format
     D CrIRFilFmt    E DS                  EXTNAME(FDVINTRPD)
     D                                     PREFIX(C_)
 
      ** Current Interest Rates in Screen Format
     D CurIRScrn     E DS                  EXTNAME(FDINTRPD)
     D                                     PREFIX(@)
 
      ** New Interest Rates in File Format - Update file
     D NwIRFilFmt    E DS                  EXTNAME(FDVINTRPD)
 
      ** New Interest Rates in Screen Format
     D NewIRScrn     E DS                  EXTNAME(FDINTRPD)
 
      ** Previous Interest Rates in File Format
     D PrvIRFilFmt   E DS                  EXTNAME(FDVINTRPD)
     D                                     PREFIX(@P)
 
      ** Previous Interest Rates in Screen Format
     D PrvIRScrn     E DS                  EXTNAME(FDINTRPD)
     D                                     PREFIX(@P)
 
      ** Error indicators
     D OKIRFlags     E DS                  EXTNAME(FDEINTRPD)
 
      ** Interest Rates Validation Workfields
     D ValWrkFlds    E DS                  EXTNAME(FDWINTRPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Switchable Features
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
 
      ** External DS for API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
 
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for Access Programs, Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** FD Interest Rates Extra Data - File (D/B) format
     D ExtData       E DS                  EXTNAME(FDIREXPD)
 
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 status data area                                                                CSC011
                                                                                              CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SD data area                                                                         CSC011
                                                                                             BUG1625
      ** Jobs Handling Commitment Control                                                    BUG1625
     D SCCMTJOB      E DS           256    EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                BUG1625
     D  COMITARR               4    103                                                      BUG1625
                                                                                             BUG1625
      ** Array of Commitment Job Names                                                       BUG1625
     D COMITJOB        S             10A   DIM(10)                                           BUG1625
                                                                                              CSC011
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
 
      ** -------------------------------------------------------------------
      ** Fields for getting the starting field number from file (parameters
      ** to ZACGTFLDNO, plus the offset to the requested field).
     D Format1         S             10A   INZ('FDINTRPD')
 
     D Field1          S             10A   INZ('DDACTN')
 
     D FldOffset1      S              5P 0
 
     D FieldNo         S              5P 0
 
      ** End of fields for getting starting field number
      ** --------------------------------------------------------------
      ** Flags to indicate whether substitution is required in
      ** each of the various parts the transaction
     D RepPrim         S              1A   INZ('N')
 
      ** Build subfile
     D PBDSFL          S              1A
 
      ** Read subfile
     D PRDSFL          S              1A
 
      ** Error message reference
     D PERRMS          S              7A
     D PERRUP          S              1A
 
      ** Read backwards in roll
     D PRDBCK          S              1A
 
      ** Read forwards in roll
     D PRDFWD          S              1A
 
      ** Enable key fields action code and currency
     D PEKYFD          S              1A
 
      ** Enable F7, F8, F10 and F15 in Command Narrative
     D PEINKG          S              1A
     D PEINKH          S              1A
     D PEINKJ          S              1A
     D PEINKP          S              1A
 
      ** Function Keys - 3,7,8,10,12 and 15
     D PINKC           S              1A
     D PINKG           S              1A
     D PINKH           S              1A
     D PINKJ           S              1A
     D PINKL           S              1A
     D PINKP           S              1A
 
      ** Screen / function
     D @SCRN           S              1A
 
      ** Mode of operation
     D ModeOfOP        S              6A
 
      ** Index of errors and warnings
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
      ** Other workfields
     D WIdx_PVAL       S              3P 0
     D PrvN_Warn       S              3P 0
     D WRDNXTB         S              1A
     D WCCY            S              3A
     D POPSEL          S              1A
     D PACSEL          S              1A
     D PCCY            S              3A
     D PFOTRANSEL      S             20A
     D PTMESTPSEL      S             26Z
     D PFOTRID         S             20A
                                                                                              CSC011
      ** Fields defined for Enhancement CSC011                                                CSC011
                                                                                              CSC011
     D CSC011          S              1A                                                      CSC011
     D CSC022          S              1A   INZ('N')                                          BUG1625
     D CNT             S              3  0                                                   BUG1625
     D COMITSKIP       S              1A                                                     BUG1625
     D PRtCd           S              7A                                                      CSC011
     D POptn           S              7A                                                      CSC011
     D PSard           S              6A                                                      CSC011
     D KMsgType        S              8A                                                      CSC011
     D KFrntOffID      S             20A                                                      CSC011
     D KTimeStamp      S                   LIKE(PTMESTPSEL)                                   CSC011
 
      ** -------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
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
 
      ** Issue rollback to clear any possible updates in window functions
 
     C     PINKL         IFEQ      TRUE
     C     CSC022        IFEQ      'N'                                                       BUG1625
     C                   ROLBK
     C                   ELSE                                                                BUG1625
     C     COMITSKIP     IFNE      'Y'                                                       BUG1625
     C                   ROLBK                                                               BUG1625
     C                   ELSE                                                                BUG1625
     C                   SETON                                        U7U8                   BUG1625
     C                   ENDIF                                                               BUG1625
     C                   ENDIF                                                               BUG1625
     C                   ENDIF
 
      ** Do screen: Browse Invalid Inputs
 
     C     @SCRN         IFEQ      'B'
     C                   EXSR      SrBRWINV
     C                   ENDIF
 
      ** Read next browse subfile record
 
     C     @SCRN         IFEQ      'R'
     C                   EXSR      SrRDNXTB
     C                   ENDIF
 
      ** DO WHILE screen
 
     C     @SCRN         DOWEQ     'I'
     C                   EXSR      SrDSPINI
     C                   ENDDO
 
      ** Screen: Confirmation of input
 
     C     @SCRN         IFEQ      'C'
     C                   EXSR      SrCONFIRM
     C                   ENDIF
 
      ** Do File updates
 
     C     @SCRN         IFEQ      'U'
     C                   EXSR      SrUPDATE
     C                   ENDIF
 
      ** Terminate program
 
     C     @SCRN         IFEQ      'T'
     C                   MOVE      *ON           *INLR
     C                   ENDIF
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrBRWINV  - Build Browse Invalid Rates Subfile                *
      *                                                               *
      *****************************************************************
     C     SrBRWINV      BEGSR
 
      ** Reset read next browse subfile record
 
     C                   EVAL      WRDNXTB = *BLANK
 
     C                   CALLB     'FDINTRRPB'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM      'Y'           PBDSFL
     C                   PARM      *BLANK        PRDSFL
     C                   PARM                    PERRUP
     C                   PARM      *BLANK        PERRMS
     C                   PARM      *BLANK        POPSEL
     C                   PARM      *BLANK        PACSEL
     C                   PARM      *BLANK        PCCY
     C                   PARM      *BLANK        PFOTRANSEL
     C                   PARM                    PTMESTPSEL
     C                   PARM      FALSE         PINKC
     C                   PARM      FALSE         PINKL
     C                   PARM                    CSC011                                       CSC011
      ** CSC022 Enhancement is installed                                                     BUG1625
                                                                                             BUG1625
     C                   PARM                    CSC022                                      BUG1625
                                                                                             BUG1625
 
      ** F3/F12 taken or error
 
     C                   IF        (PINKC = TRUE) OR (PINKL = TRUE) OR
     C                             (PERRMS <> *BLANK)
     C                   EXSR      SrEND
     C                   IF        PERRMS <> *BLANK
     C                   EVAL      *INU6 = TRUE
     C                   ENDIF
     C                   ELSE
 
      ** No error, read selected record
 
     C                   EVAL      WRDNXTB = 'Y'
     C                   EVAL      @SCRN = 'R'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRDNXTB  - Read Next Browse                                  *
      *                                                               *
      *****************************************************************
     C     SrRDNXTB      BEGSR
 
      ** Read Next Subfile Record
 
     C                   CALLB     'FDINTRRPB'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM      *BLANK        PBDSFL
     C                   PARM      'Y'           PRDSFL
     C                   PARM                    PERRUP
     C                   PARM      *BLANK        PERRMS
     C                   PARM      *BLANK        POPSEL
     C                   PARM      *BLANK        PACSEL
     C                   PARM      *BLANK        PCCY
     C                   PARM      *BLANK        PFOTRANSEL
     C                   PARM                    PTMESTPSEL
     C                   PARM      FALSE         PINKC
     C                   PARM      FALSE         PINKL
     C                   PARM                    CSC011                                       CSC011
 
      ** F3 taken within invalid transaction deletion function,
      ** End program
 
     C                   IF        (PINKC = TRUE)
     C                   EXSR      SrEND
     C                   GOTO      ENDRDNXTB
     C                   ENDIF
 
      ** If Invalid Rate read from subfile
 
     C     POPSEL        IFNE      *BLANK
 
     C                   CLEAR                   NewIRScrn
 
      ** Reset errors
 
     C                   EXSR      SrRESETERR
 
      ** Retrieve Interest Rate details
 
     C                   EVAL      DDACTN = PACSEL
     C                   EVAL      PFOTRID = PFOTRANSEL
 
      ** Make sure Invalid transaction's details are passed to 'Retrieve'
      ** module for SPF checking
 
     C     ZAIRKX0       CHAIN     FDIINTRL0                          99
 
      ** Set retrieve mode to '*FRONT' (Access using Front Office ID)
      ** If action selected is 'I' or not insert but the transaction ID is
      ** blank, otherwise set retrive mode to blank
 
     C     DDACTN        IFEQ      'I'
     C                   MOVEL     '*FRONT'      ModeOfOp
     C                   ELSE
     C     DDCCY         IFEQ      *BLANK
     C                   MOVEL     '*FRONT'      ModeOfOp
     C                   ELSE
     C                   MOVEL     '      '      ModeOfOp
     C                   ENDIF
     C                   ENDIF
 
     C                   EXSR      SrRTVDET
 
      ** For the rest of the processing, set Mode of Operation
      ** to '*RPR  ' for the other modules to process transaction
      ** as coming from the repair function.
 
     C                   EVAL      ModeOfOp = '*RPR  '
 
      ** If rate details were retrieved, convert to screen format
 
     C                   IF        (C_FYCCY <> *BLANK) AND (DDACTN <> 'I')
     C                   EXSR      SrCONVERT
     C                   MOVEL     CrIRFilFmt    NwIRFilFmt
     C                   ENDIF
 
      ** Now overwrite the fields on the main details screen with those
      ** on the invalid interest rates file (except for the Midas transac
      ** tion reference retrieed above using the front office transaction
      ** ID). Access invalid rates with timestamp and front office transac -
      ** tion ID.
 
     C                   EVAL      WCCY = DDCCY
     C     ZAIRKX0       CHAIN     FDIINTRL0                          99
 
     C                   IF        (C_FYCCY <> *BLANK) AND (DDACTN <> 'I')
     C                   EVAL      DDCCY = WCCY
     C                   ENDIF
 
      ** If interest rates details were retrieved and this is an amendment,
      ** Do data substitution if the substitution character is present
 
     C                   IF        (C_FYCCY <> *BLANK) AND (DDACTN = 'A') AND
     C                             (GHSUBS <> *BLANK)
     C     GHSUBS        SCAN      NewIRScrn                              99
     C     *IN99         IFEQ      TRUE
     C                   EXSR      SrTDtDSubs
     C                   ENDIF
     C                   ENDIF
 
      ** If action code or transaction reference were not OK,
      ** blank out action code so that the input cannot proceed
 
     C                   IF        (DDACTNOK = 'N') OR (DDCCYOK = 'N')
     C                   EVAL      DDACTN = *BLANK
     C                   ENDIF
 
      ** Send error messages to detail screen
 
     C                   EXSR      SrSNDERR
     C                   EVAL      @SCRN = 'I'
 
      ** No invalid rates read from subfile, go to browse screen
 
     C                   ELSE
     C                   EVAL      @SCRN = 'B'
     C                   ENDIF
 
     C     ENDRDNXTB     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrSNDERR - Send Error Messages                                *
      *                                                               *
      *****************************************************************
     C     SrSNDERR      BEGSR
 
     C                   Z-ADD     Idx           E                 3 0
 
      ** If there are fundamental errors in this transaction
      ** Identify this fact.
 
     C                   IF        (DDACTNOK = 'N') OR (DDCCYOK = 'N')
     C                   ADD       1             E
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     'APM0110'     MsgIdArr(E)
     C                   ENDIF
 
      ** Initialize error indicators
 
     C                   MOVEA     OKIRFlags     @EI
 
      ** Read error messages for Transactions
 
     C     ZAIRKD0       SETLL     ZATRNERRD0
     C     ZAIRKD0       READE     ZATRNERRD0                             99
 
      ** Add error message to array passed to detail screen
      ** and set OK flag for field to 'N'
 
     C     *IN99         DOWEQ     '0'
 
     C     ABFIELDID     IFGE      FldOffset1
     C                   ADD       1             E
     C                   MOVEL     ABFIELDNAM    FldNameArr(E)
     C                   MOVEL     ABMSGID       MsgIdArr(E)
     C                   Z-ADD     ABFIELDID     F                 3 0
     C                   SUB       FldOffset1    F
     C     F             IFLT      1
     C     F             ORGT      70
     C                   Z-ADD     1             F
     C                   ENDIF
     C                   MOVE      'N'           @EI(F)
     C                   ENDIF
 
     C     ZAIRKD0       READE     ZATRNERRD0                             99
     C                   ENDDO
 
     C                   MOVEA     @EI           OKIRFlags
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrDSPINI  - Display Initial Screen                            *
      *                                                               *
      *****************************************************************
     C     SrDSPINI      BEGSR
 
      ** Save previous screen
 
     C                   EVAL      PrvIRScrn = NewIRScrn
     C                   Z-Add     WIdx_PVAL     PrvN_Warn
 
      ** Set function key narratives and field status
 
     C                   EXSR      SrSETFSTS
 
      ** Write/Read Display Screen
 
     C                   CALLB     'FDINTRDSP'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    NewIRScrn
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    OKIRFlags
     C                   PARM                    PEKYFD
     C                   PARM                    WriteOnly
     C                   PARM                    PEINKG
     C                   PARM                    PEINKH
     C                   PARM                    PEINKJ
     C                   PARM                    PEINKP
     C                   PARM      FALSE         PINKC
     C                   PARM      FALSE         PINKG
     C                   PARM      FALSE         PINKH
     C                   PARM      FALSE         PINKJ
     C                   PARM      FALSE         PINKL
     C                   PARM      FALSE         PINKP
 
      ** Reset Error fields
 
     C                   EXSR      SrRESETERR
 
      ** Process function keys
 
     C     PINKC         CASEQ     TRUE          SrEND
     C     PINKL         CASEQ     TRUE          SrCANCEL
     C     PINKJ         CASEQ     TRUE          SrDELETE
     C                   CAS                     SrVALIDATE
     C                   ENDCS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrVALIDATE - Validate Input                                   *
      *                                                               *
      *****************************************************************
     C     SrVALIDATE    BEGSR
 
      ** Save Previous details in file format
 
     C                   Movel     NwIRFilFmt    PrvIRFilFmt
 
      ** Prior to validation, initialise error indicators as 'OK'
 
     C                   EXSR      SrRESETERR
 
      ** Reset interest rate valid file
 
     C                   CLEAR                   NwIRFilFmt
 
      ** Validate action code and currency
 
     C                   EXSR      SrRTVDET
 
      ** If error found on action code or currency, display message
 
     C                   IF        (DDACTNOK = 'N') OR (DDCCYOK = 'N')
     C                   GOTO      ENDVAL
     C                   ENDIF
 
      ** Validate detail inputs for Amend or Insert
 
     C                   IF        (DDACTN = 'I') OR (DDACTN = 'A')
     C                   CALLB     'FDINTRVAL'
     C                   PARM                    RespMode
     C                   PARM                    ModeOfOp
     C                   PARM                    NewIRScrn
     C                   PARM                    ExtData
     C                   PARM                    PrvIRFilFmt
     C                   PARM                    OKIRFlags
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    NwIRFilFmt
     C                   PARM                    ValWrkFlds
 
      ** Errors returned
 
     C     Idx           IFNE      *ZERO
     C                   GOTO      ENDVAL
     C                   ENDIF
 
      ** If the screen has changed in the course of the validation
      ** or there are warnings which have not been displayed,
      ** re-output the screen
 
     C                   EVAL      WIdx_PVal = WIdx_PVal + WIdx
     C                   IF        (NewIRScrn <> PrvIRScrn) OR
     C                             (WIdx_PVal <> PrvN_Warn)
     C                   GOTO      ENDVAL
     C                   ENDIF
 
      ** Clear any warning messages
 
     C                   MOVE      *ALL'Y'       OKIRFlags
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
 
      ** Confirm inputs
 
     C                   IF        (%SUBST(NewIRScrn:5) <> *BLANK) AND
     C                             (DDACTN = @PDDACTN) AND (DDCCY = @PDDCCY)
     C                   EVAL      @SCRN = 'C'
     C                   ENDIF
     C                   ENDIF
 
     C     ENDVAL        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRTVDET - Retrieve Interest Rate Details                     *
      *                                                               *
      *****************************************************************
     C     SrRTVDET      BEGSR
 
      ** Call Retrieve Module
 
     C                   CALLB     'FDINTRRTV'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    ModeOfOp
     C                   PARM                    RespMode
     C                   PARM                    DDACTN
     C                   PARM                    DDCCY
     C                   PARM                    DDCYNM           32
     C                   PARM                    PFOTRID
     C                   PARM                    CrIRFilFmt
     C                   PARM                    DDACTNOK
     C                   PARM                    DDCCYOK
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    ValWrkFlds
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCONVERT - Convert Interest Rate Details in Screen Format    *
      *                                                               *
      *****************************************************************
     C     SrCONVERT     BEGSR
 
      ** Call Convert Module
 
     C                   CALLB     'FDINTRCVT'
     C                   PARM                    RetCodeIn
     C                   PARM                    CrIRFilFmt
     C                   PARM                    NewIRScrn
     C                   PARM                    ValWrkFlds
 
     C                   EVAL      CurIRScrn = NewIRScrn
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCONFIRM - Confirm Screen Inputs                             *
      *                                                               *
      *****************************************************************
     C     SrCONFIRM     BEGSR
 
      ** If transaction is valid output message 'Press enter to accept'
 
     C     Idx           IFEQ      *ZERO
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'MMM1030'     MsgIdArr(1)
     C                   ENDIF
 
     C                   CALLB     'FDINTRDSP'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    NewIRScrn
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    OKIRFlags
     C                   PARM      'N'           PEKYFD
     C                   PARM      'Y'           WriteOnly
     C                   PARM      'N'           PEINKG
     C                   PARM      'N'           PEINKH
     C                   PARM      'N'           PEINKJ
     C                   PARM      'N'           PEINKP
     C                   PARM      FALSE         PINKC
     C                   PARM      FALSE         PINKG
     C                   PARM      FALSE         PINKH
     C                   PARM      FALSE         PINKJ
     C                   PARM      FALSE         PINKL
     C                   PARM      FALSE         PINKP
 
      ** Reset Error fields
 
     C                   EXSR      SrRESETERR
 
      ** Process function keys
 
     C     PINKC         CASEQ     TRUE          SrEND
     C     PINKL         CASEQ     TRUE          SrCANCEL
     C                   CAS                     SrEXITC
     C                   ENDCS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrUPDATE -  Update Database                                   *
      *                                                               *
      *****************************************************************
     C     SrUPDATE      BEGSR
 
      ** Update Front Office Transaction Id
 
     C     WAPIT         IFEQ      'B'
     C                   EVAL      FYBOFR = PFOTRANSEL
     C                   ELSE
     C     WAPIT         IFEQ      'L'
     C                   EVAL      FYLEFR = PFOTRANSEL
     C                   ELSE
     C                   EVAL      FYBOFR = PFOTRANSEL
     C                   EVAL      FYLEFR = PFOTRANSEL
     C                   ENDIF
     C                   ENDIF
 
      ** Call update module
 
     C                   CALLB     'FDINTRUPD'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    NwIRFilFmt
     C                   PARM                    ValWrkFlds
 
      ** If there were any errors in the update functions, rollback any
      ** updates and end this program. Otherwise, commit the updates
 
     C     RetCodeOut    IFNE      *BLANK
     C     RetCodeOut    ANDNE     '*RECUPD'
     C     CSC022        IFEQ      'N'                                                       BUG1625
     C                   ROLBK
     C                   ELSE                                                                BUG1625
     C     COMITSKIP     IFNE      'Y'                                                       BUG1625
     C                   ROLBK                                                               BUG1625
     C                   ENDIF                                                               BUG1625
     C                   ENDIF                                                               BUG1625
     C                   EXSR      *PSSR
     C                   ELSE
     C     ZAIRKD0       CHAIN     FDIINTRD0                          99
     C     *IN99         IFEQ      FALSE
     C                   DELETE    FDIINTRD0
     C                   ENDIF
                                                                                              CSC011
      ** Delete invalid record from the log file.                                             CSC011
                                                                                              CSC011
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         CSC011
                                                                                              CSC011
     C                   EVAL      KMsgType = 'FDINTR'                                        CSC011
     C                   EVAL      KFrntOffID = PFOTRANSEL                                    CSC011
     C                   EVAL      KTimeStamp = PTMESTPSEL                                    CSC011
                                                                                              CSC011
     C     KAPILOGL0     CHAIN     APILOGL0                           99                      CSC011
     C                   IF        *IN99 = *OFF                                               CSC011
     C                   DELETE    APILOGL0                                                   CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C     CSC022        IFEQ      'N'                                                       BUG1625
     C                   COMMIT
     C                   ELSE                                                                BUG1625
     C     COMITSKIP     IFNE      'Y'                                                       BUG1625
     C                   COMMIT                                                              BUG1625
     C                   ENDIF                                                               BUG1625
     C                   ENDIF                                                               BUG1625
     C                   ENDIF
 
      ** If update not done due to record being updated by another
      ** workstation send message to screen.
 
     C     RetCodeOut    IFEQ      '*RECUPD'
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'MMM1067'     MsgIdArr(1)
     C                   EVAL      PERRUP = 'Y'
     C                   ELSE
     C                   EVAL      PERRUP = 'N'
     C                   ENDIF
 
      ** If records are still to be read from the subfile, read them
 
     C     WRDNXTB       IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
 
      ** Else, go to Browse screen
 
     C                   CLEAR                   NewIRScrn
 
     C                   EXSR      SrRESETERR
     C                   EVAL      @SCRN = 'B'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrDELETE -  Delete Record                                     *
      *                                                               *
      *****************************************************************
     C     SrDELETE      BEGSR
 
      ** F10 taken, go on to updates
 
     C                   EVAL      FYCHTP = DDACTN
     C                   EVAL      @SCRN = 'U'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrEXITC - Exit Confirmation Screen                            *
      *                                                               *
      *****************************************************************
     C     SrEXITC       BEGSR
 
      ** No errors in validation, continue with updates
 
     C     Idx           IFEQ      *ZERO
     C                   EVAL      @SCRN = 'U'
     C                   ELSE
 
      ** Go back to initial screen
 
     C                   EVAL      @SCRN = 'I'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrSETFSTS - Set Field Status                                  *
      *                                                               *
      *****************************************************************
     C     SrSETFSTS     BEGSR
 
      ** According to action code, set WriteOnly indicator
 
     C                   EVAL      PEINKG = 'N'
     C                   EVAL      PEINKH = 'N'
     C                   EVAL      PEINKJ = 'N'
     C                   EVAL      PEINKP = 'N'
     C                   EVAL      PEKYFD = 'N'
 
      ** Only make detail fields capable of input when the option selected
      ** is Update and the actio code is either insert or amend
 
     C                   IF        (POPSEL = 'U') AND (DDACTN = 'I') OR
     C                             (POPSEL = 'U') AND (DDACTN = 'A')
     C                   EVAL      WriteOnly = 'N'
     C                   ELSE
     C                   EVAL      WriteOnly = 'Y'
     C                   ENDIF
 
     C                   IF        DDACTN = 'D'
     C                   EVAL      PEINKJ = 'Y'
     C                   ELSE
     C                   EVAL      PEINKJ = 'N'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRESETERR - Reset error fields                               *
      *                                                               *
      *****************************************************************
     C     SrRESETERR    BEGSR
 
      ** Reset error fields
 
     C                   RESET                   FldNameArr
     C                   RESET                   MsgIDArr
     C                   RESET                   MsgDtaArr
     C                   RESET                   Idx
 
      ** Reset warning fields
 
     C                   RESET                   WFldNamArr
     C                   RESET                   WMsgIdArr
     C                   RESET                   WMsgDtaArr
     C                   RESET                   WIdx
 
      ** Reset OK flags
 
     C                   MOVE      *ALL'Y'       OKIRFlags
 
     C                   MOVE      *BLANK        PERRMS
 
      ** Reset Warning workfield
 
     C                   EVAL      WIdx_PVAL = *ZERO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrADDERM - Add Error Messages to Error Arrays                 *
      *                                                               *
      *****************************************************************
     C     SrADDERM      BEGSR
 
      ** Action code is invalid
 
     C     PERRMS        IFEQ      'FDM0052'
     C     PERRMS        OREQ      'FDM0501'
     C                   EVAL      DDACTNOK = 'N'
     C                   ENDIF
 
      ** End of file reached for F8 key
 
     C     PERRMS        IFEQ      'FDM0053'
     C                   EVAL      DDCCYOK = 'N'
     C                   ENDIF
 
      ** Beginning of file reached for F7 key
 
     C     PERRMS        IFEQ      'FDM0054'
     C                   EVAL      DDCCYOK = 'N'
     C                   ENDIF
 
      ** action code invalid for user
 
     C     PERRMS        IFEQ      'FXM0292'
     C                   EVAL      DDACTNOK = 'N'
     C                   ENDIF
 
      ** Add error message to array passed to input screen
 
     C                   Z-ADD     1             E                 3 0
     C     *BLANK        LOOKUP    FldNameArr(E)                          99
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     PERRMS        MsgIdArr(E)
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrEND - Program Termination                                   *
      *                                                               *
      *****************************************************************
     C     SrEND         BEGSR
 
     C                   EVAL      @SCRN = 'T'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCANCEL - Cancel Screen Inputs                               *
      *                                                               *
      *****************************************************************
     C     SrCANCEL      BEGSR
 
      ** If cancel was taken out from the confirmation screen, goto update
      ** screen
 
     C     @SCRN         IFEQ      'C'
     C                   EVAL      @SCRN = 'I'
     C                   ELSE
 
      ** If Records are still to be read from the subfile, read them
 
     C     WRDNXTB       IFEQ      'Y'
     C                   EVAL      @SCRN = 'R'
     C                   ELSE
 
      ** Return to browse screen
 
     C                   EVAL      @SCRN = 'B'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrTDtDSubs - Transaction Details Data Substitution            *
      *                                                               *
      *****************************************************************
     C     SrTDtDSubs    BEGSR
 
     C                   CLEAR                   IncData
     C                   CLEAR                   CurData
 
     C                   CALLB     'APDTASUBS'
     C                   PARM      *BLANKS       ReturnCode       10
     C                   PARM      GHSUBS        SubsChar          1
     C                   PARM      NewIRScrn     IncDATA        2000
     C                   PARM      CurIRScrn     CurDATA        2000
 
     C                   MOVEL     IncDATA       NewIRScrn
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Initialize program name
 
     C     *LOCK         IN        LDA
     C                   MOVEL     'FDINTRRPR'   DBPGM
     C                   OUT       LDA
 
      ** Initialise Data Structures
 
     C                   CLEAR                   CurIRScrn
     C                   CLEAR                   CrIRFilFmt
     C                   CLEAR                   NewIRScrn
     C                   CLEAR                   NwIRFilFmt
     C                   CLEAR                   PrvIRScrn
 
      ** Initialise read next browse workfield
 
     C                   EVAL      WRDNXTB = *BLANK
 
      ** Set screen to initial screen
 
     C                   EVAL      @SCRN = 'B'
 
      ** Key Lists
 
     C     ZAIRKD0       KLIST
     C                   KFLD                    PFOTRANSEL
     C                   KFLD                    PTMESTPSEL
 
     C     ZAIRKX0       KLIST
     C                   KFLD                    PTMESTPSEL
     C                   KFLD                    PFOTRANSEL
 
     C     KAPILOGL0     KLIST                                                                CSC011
     C                   KFLD                    KMsgType                                     CSC011
     C                   KFLD                    KFrntOffID                                   CSC011
     C                   KFLD                    KTimeStamp                                   CSC011
                                                                                              CSC011
      ** Access bank detail
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     1             DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                              CSC011
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRtCd                                        CSC011
     C                   PARM      '*VERIFY'     POptn                                        CSC011
     C                   PARM      'CSC011'      PSard                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRtCd = *Blanks                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   OPEN      APILOGL0                                                   CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
                                                                                              CSC011
     C                   IF        PRtCd <> '*NRF'                                            CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE =  3                                                 CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
      *                                                                                      BUG1625
      ** Access SAR details file to determine if CSC022 switchable feature                   BUG1625
      ** is switched on                                                                      BUG1625
     C                   CALLB     'AOSARDR0'                                                BUG1625
     C                   PARM      *BLANKS       PRtCd                                       BUG1625
     C                   PARM      '*VERIFY'     POptn                                       BUG1625
     C                   PARM      'CSC022'      PSard                                       BUG1625
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG1625
                                                                                             BUG1625
     C                   IF        PRtCd = *Blanks                                           BUG1625
                                                                                             BUG1625
     C                   EVAL      CSC022 = 'Y'                                              BUG1625
     C                   IN        SCCMTJOB                                                  BUG1625
     C                   Z-ADD     1             CNT                                         BUG1625
     C                   MOVEL     *BLANKS       COMITSKIP                                   BUG1625
     C                   MOVEA     COMITARR      COMITJOB                                    BUG1625
     C     COMITNUM      IFGT      0                                                         BUG1625
     C     CNT           DOWLE     COMITNUM                                                  BUG1625
     C     PSJOBNAME     IFEQ      COMITJOB(CNT)                                             BUG1625
     C                   MOVEL     'Y'           COMITSKIP                                   BUG1625
     C                   ENDIF                                                               BUG1625
     C                   ADD       1             CNT                                         BUG1625
     C                   ENDDO                                                               BUG1625
     C                   ENDIF                                                               BUG1625
                                                                                             BUG1625
     C                   ELSE                                                                BUG1625
      ** Database error                                                                      BUG1625
                                                                                             BUG1625
     C                   IF        PRtCd <> '*NRF'                                           BUG1625
     C     *LOCK         IN        LDA                                                       BUG1625
     C                   EVAL      DBKEY = 'CSC022'                                          BUG1625
     C                   EVAL      DBFILE = 'SCSARDPD'                                       BUG1625
     C                   EVAL      DBASE = 004                                               BUG1625
     C                   OUT       LDA                                                       BUG1625
     C                   EXSR      *PSSR                                                     BUG1625
     C                   ENDIF                                                               BUG1625
                                                                                             BUG1625
     C                   ENDIF
 
      ** Access API ICD details
 
     C                   CALL      'AOAPIR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY
 
      ** Database error
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDAPIPD'     DBFILE
     C                   Z-ADD     2             DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Get the field number for the action code field; the screen fields
      ** start from that number. Subtract one from it to give the value to
      ** subtract from each field's number
 
      ** Access SAR details file to see if CSD006 is installed.                               196570
                                                                                              196570
     C                   CALL      'AOSARDR0'                                                 196570
     C                   PARM      *BLANKS       @RTCD                                        196570
     C                   PARM      '*VERIFY'     @OPTN                                        196570
     C                   PARM      'CSD006'      @SARD                                        196570
     C     SCSARD        PARM      SCSARD        DSFDY                                        196570
                                                                                              196570
     C                   IF        @RTCD <> *Blanks AND                                       196570
     C                             @RTCD <> '*NRF   '                                         196570
     C                   MOVEL     'SCSARDPD'    DBFILE                                       196570
     C                   Z-ADD     3             DBASE                                        196570
     C                   MOVEL     'CSD006'      DBKEY                                        196570
     C                   EXSR      *PSSR                                                      196570
     C                   ENDIF                                                                196570
                                                                                              196570
     C                   IF        @RTCD = *Blanks                                            196570
     C                   MOVEL     'Y'           CSD006                                       196570
     C                   ELSE                                                                 196570
     C                   MOVEL     'N'           CSD006                                       196570
     C                   ENDIF                                                                196570
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM                    ReturnCode
     C                   PARM                    Format1
     C                   PARM                    Field1
     C                   PARM                    FieldNo
 
     C                   IF        ReturnCode = *blank
     C                   EVAL      FldOffset1 = FieldNo - 1
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
