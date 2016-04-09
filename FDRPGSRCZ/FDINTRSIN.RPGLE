     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FD MM Interest Rates Screen Input Module')
      *****************************************************************
      *                                                               *
      *  Midas - FD ILE Module                                        *
      *                                                               *
      *  FDINTRSIN - Interest Rates Screen Input Module               *
      *                                                               *
      *  Function:  This is the main screen input function            *
      *             for Interest Rates Details.                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. BUG1625            Date 19May04               *
      *  Prev Amend No. 213558             Date 22Jan03               *
      *                 213561             Date 10Jan03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CAP058  *CREATE    Date 13Jul00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG1625 - Commitment Control Changes for MidasPlus           *
      *  213558 - MDF Rate Maintenance Time/Date Stamp amendable      *
      *  213561 - Error when reach begin/end of file using F7 and F8  *
      *  CAP058 - Full API for Money Market Interest Rates            *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      *                                                               *
      *      FUNCTION OF INDICATORS                                   *
      *                                                               *
      *       LR  End of Program                                      *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *      SUBROUTINE DESCRIPTIONS                                  *
      *                                                               *
      *      *INZSR        - Program Initilisation                    *
      *      SrDSPINI      - Display Initial Screen                   *
      *      SrROLL        - Display Previous or Next Interest Rate   *
      *                      Details                                  *
      *      SrBROWSE      - Build Browse Subfile                     *
      *      SrRDNXTB      - Read Next Browse                         *
      *      SrPROCESS     - Processes Input                          *
      *      SrVALIDATE    - Validate Input                           *
      *      SrRTVREC      - Retrieve Interest Rate Details           *
      *      SrCONVERT     - Convert Interest Rate Details to Screen  *
      *                      Format                                   *
      *      SrCONFIRM     - Confirm Screen Inputs                    *
      *      SrUPDATE      - Update Interest Rate DB File             *
      *      SrDELETE      - Delete Record                            *
      *      SrEXITC       - Exit Confirmation Screen                 *
      *      SrSETFSTS     - Set Field Status                         *
      *      SrRESETERR    - Reset error fields                       *
      *      SrSNDERR      - Send Error Messages from the called      *
      *                      Module                                   *
      *      SrEND         - Program Termination                      *
      *      SrCANCEL      - Cancel Screen Inputs                     *
      *      *PSSR         - Standard Error Subroutine                *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *      PROCEDURES AND PROGRAMS CALLED                           *
      *                                                               *
      *      AOBANKR0      - Access Object for Bank Details           *
      *      AOSARDR0      - Access Object for Switchable Features    *
      *      FDINTRDSP     - Interest Rates Details Display Module    *
      *      FDINTRRED     - Interest Rates Details Read Module       *
      *      FDINTRBRW     - Interest Rates Details Browse Module     *
      *      FDINTRVAL     - Interest Rates Details Validation Module *
      *      FDINTRRTV     - Interest Rates Details Retrieve Module   *
      *      FDINTRCVT     - Interest Rates Details Convert Module    *
      *      FDINTRUPD     - Interest Rates Details Update Module     *
      *                                                               *
      *****************************************************************
 
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layou
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
 
 
     D CrIRFilFmt    E DS                  EXTNAME(FDVINTRPD)
     D                                     PREFIX(C_)
      ** Current Interest Rates Detail in File Format
 
     D PrvIRFilFmt   E DS                  EXTNAME(FDVINTRPD)
     D                                     PREFIX(P_)
      ** Previous Interest Rates Detail in File Format
 
     D CurIRScnFmt   E DS                  EXTNAME(FDINTRPD)
      ** Current Interest Rates Detail in Screen Format
 
     D CurIRExtDta   E DS                  EXTNAME(FDIREXPD)
      ** Current Interest Rates Extra Data
 
     D PrvIRScnFmt   E DS                  EXTNAME(FDINTRPD)
     D                                     PREFIX(@P)
      ** Previous Interest Rates Detail in Screen Format
 
     D ValidIRDets   E DS                  EXTNAME(FDVINTRPD)
      ** Valid Interest Rate Detail File Format
 
     D ValWrkFlds    E DS                  EXTNAME(FDWINTRPD)
      ** Interest Rates Validation Workfields
 
     D OKIRDets      E DS                  EXTNAME(FDEINTRPD)
      ** Error indicators
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** External DS for SAR Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, short data structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for Access Programs, long data structure
                                                                                             BUG1625
      ** Jobs Handling Commitment Control                                                    BUG1625
     D SCCMTJOB      E DS           256    EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                BUG1625
     D  COMITARR               4    103                                                      BUG1625
                                                                                             BUG1625
      ** Array of Commitment Job Names                                                       BUG1625
     D COMITJOB        S             10A   DIM(10)                                           BUG1625
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
 
      ** Build subfile
     D PBDSFL          S              1A
 
      ** Error message reference
     D PERRMS          S              7A
 
      ** Read backwards in roll
     D PRDBCK          S              1A
 
      ** Read forwards in roll
     D PRDFWD          S              1A
 
      ** Read subfile
     D PRDSFL          S              1A
 
      ** Enable Key fields action code and currency
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
     D WPRVCONV        S              1A   INZ('N')
     D POPSEL          S              1A
     D PCCY            S              3A
     D PFOTRID         S             20A
     D WINICA          S              1A
     D WBRWCA          S              1A
     D WSFLRD          S              1A
     D CSC022          S              1A   INZ('N')                                          BUG1625
     D CNT             S              3  0                                                   BUG1625
     D COMITSKIP       S              1A                                                     BUG1625
     D PRtCd           S              7A                                                     BUG1625
     D POptn           S              7A                                                     BUG1625
     D PSard           S              6A                                                     BUG1625
 
      ** Timestamp for the transaction
     D TimeStamp       S               Z
 
      ** Query check in key screen customer number field
     D KEYQUERY        S              1A
 
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
 
      ** Read next browse subfile record
 
     C     @SCRN         IFEQ      'R'
     C                   EXSR      SrRDNXTB
     C                   ENDIF
 
      ** Do while screen: Initial Screen
 
     C     @SCRN         DOWEQ     'I'
     C                   EXSR      SrDSPINI
     C                   ENDDO
 
      ** Confimation screen
 
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
      *
      ** Build key screen '?' browse subfile record
      *
     C     @SCRN         IFEQ      'S'
     C                   EXSR      KBLDBRW
     C                   ENDIF
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrDSPINI  - Display Initial Screen                            *
      *                                                               *
      *****************************************************************
     C     SrDSPINI      BEGSR
 
      ** Save previous screen
 
     C                   EVAL      PrvIRScnFmt = CurIRScnFmt
     C                   Z-Add     WIdx_PVAL     PrvN_Warn
 
      ** Set function key narratives and field status
 
     C                   EXSR      SrSETFSTS
 
      ** Write/Read Display Screen
 
     C                   CALLB     'FDINTRDSP'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    CurIRScnFmt
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    OKIRDets
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
     C     PINKG         CASEQ     TRUE          SrROLL
     C     PINKH         CASEQ     TRUE          SrROLL
     C     PINKJ         CASEQ     TRUE          SrDELETE
     C     PINKP         CASEQ     TRUE          SrBROWSE
     C                   CAS                     SrPROCESS
     C                   ENDCS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * KBLDBRW - BUILD BROWSE SUBFILE
      *****************************************************************
     C     KBLDBRW       BEGSR
 
      * Build Browse subfile
     C                   CALLB     'AOCURRR0'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
     C                   PARM      *BLANK        @RTCD             7            B:Return code
     C                   PARM      '*KEY'        @OPTN             7            I:Option
     C                   PARM      '?'           @K101             3            I:Key field
     C                   PARM                    DSSDY                          O:Format
 
      * If F3 taken in browse, return to key screen
     C     @RTCD         IFEQ      '*NOSEL'
     C                   EVAL      @SCRN = 'I'
     C                   GOTO      ENDKBLDBRW
     C                   ELSE
     C                   EVAL      DDCCY = @K101
     C                   ENDIF
      *
      * Read next browse subfile record
      *
     C                   MOVEL     'I'           @SCRN
      *
     C     EndKBLDBRW    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrROLL    - Display Previous or Next Interest Rate Details    *
      *                                                               *
      *****************************************************************
     C     SrROLL        BEGSR
 
      ** Initialise read indicators
 
     C                   EVAL      PRDFWD = *BLANKS
     C                   EVAL      PRDFWD = *BLANKS
 
      ** Set read indicator
 
     C     PINKG         IFEQ      TRUE
     C                   EVAL      PRDBCK = 'Y'
     C                   ELSE
     C                   EVAL      PRDFWD = 'Y'
     C                   ENDIF
 
      ** Set action code to 'E' if entered blank
 
     C     DDACTN        IFEQ      *BLANK
     C                   EVAL      DDACTN = 'E'
     C                   ENDIF
 
      ** Read Interest Rate Detail
 
     C                   CALLB     'FDINTRRED'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    DDACTN
     C                   PARM                    DDCCY
     C                   PARM                    PRDFWD
     C                   PARM                    PRDBCK
     C                   PARM      *BLANK        PERRMS
 
      ** Error message returned from read, send it to detail screen
 
     C     PERRMS        IFNE      *BLANK
     C                   EXSR      SrSNDERR
     C                   ENDIF
 
      ** Convert record to screen format
 
     C     PERRMS        IFEQ      *BLANK
     C                   EXSR      SrRTVREC
 
      ** No error retrieving the record
 
     C                   IF        (DDACTNOK = 'Y') AND (DDCCYOK = 'Y')
 
      ** Save previous interest rate details
 
     C                   MOVEL     CrIRFilFmt    PrvIRFilFmt
 
      ** Convert to screen format
 
     C                   EXSR      SrCONVERT
     C                   ENDIF
 
      ** Display Record
 
     C                   EVAL      @SCRN = 'I'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrBROWSE  - Build Browse Subfile                              *
      *                                                               *
      *****************************************************************
     C     SrBROWSE      BEGSR
 
      ** Reset read next browse subfile record
 
     C                   EVAL      WRDNXTB = *BLANK
     C                   EVAL      WSFLRD = 'N'
 
     C                   CALLB     'FDINTRBRW'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM      'Y'           PBDSFL
     C                   PARM      *BLANK        PRDSFL
     C                   PARM      *BLANK        PERRMS
     C                   PARM      *BLANK        POPSEL
     C                   PARM      *BLANK        PCCY
     C                   PARM      FALSE         PINKC
     C                   PARM      FALSE         PINKL
 
     C                   SELECT
 
      ** F3 taken
 
     C     PINKC         WHENEQ    TRUE
     C                   EXSR      SrEND
 
      ** F12 taken
 
     C     PINKL         WHENEQ    TRUE
     C                   EXSR      SrCANCEL
 
      ** Error message returned from calling BRW
 
     C                   OTHER
     C     PERRMS        IFNE      *BLANKS
     C                   EXSR      SrSNDERR
     C                   ELSE
 
      ** No error, read selected record
 
     C                   EVAL      WRDNXTB = 'Y'
     C                   EVAL      @SCRN = 'R'
     C                   ENDIF
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRDNXTB  - Read Next Browse                                  *
      *                                                               *
      *****************************************************************
     C     SrRDNXTB      BEGSR
 
     C                   CALLB     'FDINTRBRW'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM      *BLANK        PBDSFL
     C                   PARM      'Y'           PRDSFL
     C                   PARM      *BLANK        PERRMS
     C                   PARM      *BLANK        POPSEL
     C                   PARM      *BLANK        PCCY
     C                   PARM      FALSE         PINKC
     C                   PARM      FALSE         PINKL
 
      ** Error message returned from calling BRW
 
     C     PERRMS        IFNE      *BLANKS
     C                   EXSR      SrSNDERR
     C                   ENDIF
 
      ** No error
 
     C     PERRMS        IFEQ      *BLANK
 
      ** Retrieve and Convert Interest Rate Details
 
     C     POPSEL        IFNE      *BLANK
 
     C                   EVAL      DDACTN = POPSEL
     C                   EVAL      DDCCY = PCCY
 
     C                   EXSR      SrRTVREC
 
      ** No error retrieving the record
 
     C                   IF        (DDACTNOK = 'Y') AND (DDCCYOK = 'Y')
 
      ** Save previous interest rate details
 
     C                   MOVEL     CrIRFilFmt    PrvIRFilFmt
 
      ** Convert to screen format
 
     C                   EXSR      SrCONVERT
     C                   ENDIF
 
      ** Set an indicator that a subfile record has been read
 
     C                   EVAL      WSFLRD = 'Y'
     C                   ELSE
     C                   EVAL      WRDNXTB = *BLANK
 
      ** All records that have been selected were already read, clear
      ** out screen fields
 
     C                   IF        (PrvIRScnFmt = CurIRScnFmt) AND
     C                             (WSFLRD = 'Y')
     C                   CLEAR                   CurIRScnFmt
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Goto initial screen
 
     C                   EVAL      @SCRN = 'I'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrPROCESS - Processes Input                                   *
      *                                                               *
      *****************************************************************
     C     SrPROCESS     BEGSR
 
      ** If Action 'E' or 'D' and still have record to read on browse, read
      ** next browse record
 
     C                   IF        (WRDNXTB = 'Y') AND (DDACTN = 'E') OR
     C                             (WRDNXTB = 'Y') AND (DDACTN = 'D')
     C                   EVAL      @SCRN = 'R'
     C                   ELSE
 
      ** Validate Input
 
     C                   EXSR      SrVALIDATE
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrVALIDATE - Validate Input                                   *
      *                                                               *
      *****************************************************************
     C     SrVALIDATE    BEGSR
 
 
      * If query on key screen, provide Transaction subfile for selection
 
     C                   MOVEL     DDCCY         KEYQuery
     C                   IF        KEYQuery = '?'
     C                   Eval      @SCRN = 'S'
     C                   Eval      DDCCY =*BLANKS
     C                   GOTO      ENDVAL
     C                   ENDIF
 
      ** Prior to validation, initialise error indicators as 'OK'
 
     C                   EXSR      SrRESETERR
 
      ** Reset interest rate valid file
 
     C                   CLEAR                   ValidIRDets
 
      ** Validate action code and currency and retrieve record if action is
      ** 'A', 'D', or 'E'.
 
     C                   EXSR      SrRTVREC
 
      ** If error found on action code or currency, display message
 
     C                   IF        (DDACTNOK = 'N') OR (DDCCYOK = 'N')
     C                   GOTO      ENDVAL
     C                   ENDIF
 
      ** Save previous interest rate details
 
     C                   IF        (DDACTN <> 'I')
     C                   IF        (DDACTN <> @PDDACTN) OR (DDCCY <> @PDDCCY)
     C                   MOVEL     CrIRFilFmt    PrvIRFilFmt
     C                   ENDIF
     C                   ENDIF
 
      ** Put interest rate details to screen fields when one of the following
      ** conditions is true:
      ** 1.) First time to pass to CONVERSION module and the action taken is
      **     'E', 'A', or 'D'
      ** 2.) The action code has been changed
      ** 3.) The currency has been changed
      ** 4.) Enquire mode and there has been a change in the rate details when
      **     input fields are input capable
      ** 5.) Delete mode and there has been a change in the rate details when
      **     input fields are input capable
 
     C                   IF        (DDACTN = 'E') OR (DDACTN = 'D') OR
     C                             (DDACTN = 'A')
 
     C                   IF        (DDACTN <> @PDDACTN) OR (DDCCY <> @PDDCCY) OR
     C                             (DDACTN = 'E') AND
     C                             (PrvIRScnFmt <> CurIRScnFmt) OR
     C                             (DDACTN = 'D') AND
     C                             (PrvIRScnFmt <> CurIRScnFmt)
     C                   EVAL      WPRVCONV = 'N'
     C                   ENDIF
 
      ** Convert to screen format
 
     C                   IF        (WPRVCONV = 'N')
     C                   EXSR      SrCONVERT
     C                   ENDIF
     C                   ENDIF
 
      ** For action 'E' or 'D' if the previous screen is the same as
      ** the current screen, go to initial screen
 
     C                   IF        (WriteOnly = 'Y') AND (DDACTN = 'E') OR
     C                             (WriteOnly = 'Y') AND (DDACTN = 'D')
     C                   IF        (PrvIRScnFmt = CurIRScnFmt)
     C                   CLEAR                   CurIRScnFmt
     C                   EXSR      SrRESETERR
     C                   GOTO      ENDVAL
     C                   ENDIF
     C                   ENDIF
 
      ** Validate detail inputs for Amend or Insert
 
     C                   IF        (DDACTN = 'I') OR (DDACTN = 'A')
     C                   IF        DDACTN = 'A'                                               213558
      * blank out timestamp and request id when amending via screen                           213558
      * therefore won't show on tolerance report                                              213558
     C                   EVAL      DDDTFR= *BLANKS                                            213558
     C                   EVAL      DDDFTS= *BLANKS                                            213558
     C                   ENDIF                                                                213558
     C                   CALLB     'FDINTRVAL'
     C                   PARM                    RespMode
     C                   PARM      *BLANK        ModeOfOp
     C                   PARM                    CurIRScnFmt
     C                   PARM                    CurIRExtDta
     C                   PARM                    PrvIRFilFmt
     C                   PARM                    OKIRDets
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    ValidIRDets
     C                   PARM                    ValWrkFlds
 
      ** Errors returned
 
     C     Idx           IFNE      *ZERO
     C                   GOTO      ENDVAL
     C                   ENDIF
 
      ** If the screen has changed in the course of the validation
      ** or there are warnings which have not been displayed,
      ** re-output the screen
 
     C                   EVAL      WIdx_PVal = WIdx_PVal + WIdx
     C                   IF        (CurIRScnFmt <> PrvIRScnFmt) OR
     C                             (WIdx_PVal <> PrvN_Warn)
     C                   GOTO      ENDVAL
     C                   ENDIF
 
      ** Clear any warning messages
 
     C                   MOVE      *ALL'Y'       OKIRDets
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
 
      ** Confirm inputs
 
     C                   IF        (%SUBST(CurIRScnFmt:5) <> *BLANK) AND
     C                             (DDACTN = @PDDACTN) AND (DDCCY = @PDDCCY)
     C                   EVAL      @SCRN = 'C'
     C                   ENDIF
     C                   ENDIF
 
     C     ENDVAL        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRTVREC - Retrieve Interest Rate Details                     *
      *                                                               *
      *****************************************************************
     C     SrRTVREC      BEGSR
 
      ** Set default action code work field to 'Y' so that if action code
      ** is blank it will be defaulted to 'E'.
 
     C                   EVAL      WDFTAC = 'Y'
 
      ** Call Retrieve Module
 
     C                   CALLB     'FDINTRRTV'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM      *BLANK        ModeOfOp
     C                   PARM                    RespMode
     C                   PARM                    DDACTN
     C                   PARM                    DDCCY
     C                   PARM                    DDCYNM           32
     C                   PARM      *BLANK        PFOTRID
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
     C                   PARM                    CurIRScnFmt
     C                   PARM                    ValWrkFlds
 
     C                   EVAL      WPRVCONV = 'Y'
 
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
     C                   PARM                    CurIRScnFmt
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    OKIRDets
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
 
      ** Call update module
 
     C                   CALLB     'FDINTRUPD'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    ValidIRDets
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
     C                   ENDIF
 
      ** If successful update, send message to screen
 
     C     RetCodeOut    IFEQ      *BLANK
     C     DDACTN        IFEQ      'D'
     C                   MOVEL     'FDM8027'     MsgIdArr(1)
     C                   ELSE
     C     DDACTN        IFEQ      'A'
     C                   MOVEL     'FDM8028'     MsgIdArr(1)
     C                   ELSE
     C                   MOVEL     'FDM8029'     MsgIdArr(1)
     C                   ENDIF
     C                   ENDIF
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     DDCCY         MsgDtaArr(1)
     C                   ENDIF
 
      ** If records are still to be read from the subfile, read them
 
     C     WRDNXTB       IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
 
      ** Else, go to initial screen
 
     C                   CLEAR                   CurIRScnFmt
 
     C                   EVAL      @SCRN = 'I'
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
 
     C                   MOVEL     CrIRFilFmt    ValidIRDets
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
     C                   EXSR      SrSETFSTS
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
 
     C                   EVAL      PEINKG = 'Y'
     C                   EVAL      PEINKH = 'Y'
     C                   EVAL      PEINKJ = 'Y'
     C                   EVAL      PEINKP = 'Y'
 
     C                   SELECT
 
      ** Fields are input capable
 
     C                   WHEN      (DDACTN = 'I') OR (DDACTN = 'A')
     C                   EVAL      WriteOnly = 'N'
     C                   EVAL      PEINKJ = 'N'
 
      ** Fields are not capable for input
 
     C                   WHEN      (DDACTN = 'E') OR (DDACTN = 'D')
 
      ** Make fields available for input when cancel has been pressed
      ** from the initial screen or an error has been sent
 
     C                   IF        WBRWCA <> 'Y'
     C                   IF        (WINICA = 'Y') OR
     C                             (PERRMS <> *BLANK) OR (Idx <> *ZERO)
     C                   EVAL      WriteOnly = 'N'
     C                   ELSE
     C                   EVAL      WriteOnly = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        PERRMS = 'FDM0053' OR PERRMS = 'FDM0054'                   213561
     C                   EVAL      WriteOnly = 'Y'                                            213561
     C                   ENDIF                                                                213561
      *                                                                                       213561
     C                   IF        DDACTN = 'D'
     C                   EVAL      PEINKJ = 'Y'
     C                   ELSE
     C                   EVAL      PEINKJ = 'N'
     C                   ENDIF
 
     C                   OTHER
     C                   EVAL      WriteOnly = 'N'
     C                   EVAL      PEINKJ = 'N'
     C                   ENDSL
 
      ** Initialise cancel workfields (Cancels taken on Browse or Initial Screen)
 
     C                   EVAL      WINICA = 'N'
     C                   EVAL      WBRWCA = 'N'
 
      ** Set status of key fields
 
     C     WriteOnly     IFEQ      'Y'
     C                   EVAL      PEKYFD = 'N'
     C                   ELSE
     C                   EVAL      PEKYFD = 'Y'
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
 
     C                   MOVE      *ALL'Y'       OKIRDets
 
     C                   MOVE      *BLANK        PERRMS
 
      ** Reset Warning workfield
 
     C                   EVAL      WIdx_PVAL = *ZERO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrSNDERR - Send Error Messages from the called Module         *
      *                                                               *
      *****************************************************************
     C     SrSNDERR      BEGSR
 
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
 
      ** If input fields are enabled, blank screens
 
     C     @SCRN         IFEQ      'I'
     C                   IF        (WriteOnly = 'N') AND (PINKP = FALSE)
     C                   CLEAR                   CurIRScnFmt
 
      ** Reset read next browse indicator
 
     C                   EVAL      WRDNXTB = *BLANK
     C                   ENDIF
 
      ** Cancel taken from browse, otherwise taken on initial screen
 
     C     PINKP         IFEQ      TRUE
     C                   EVAL      WBRWCA  = 'Y'
     C                   ELSE
     C                   EVAL      WINICA  = 'Y'
     C                   ENDIF
     C                   ENDIF
 
      ** Reset error fields
 
     C                   EXSR      SrRESETERR
 
     C                   EVAL      @SCRN = 'I'
 
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
     C                   MOVEL     'FDINTRSIN'   DBPGM
     C                   OUT       LDA
 
      ** Initialise Data Structures
 
     C                   CLEAR                   CurIRScnFmt
     C                   CLEAR                   CrIRFilFmt
     C                   CLEAR                   PrvIRScnFmt
     C                   CLEAR                   ValidIrDets
 
      ** Initialise read next browse workfield
 
     C                   EVAL      WRDNXTB = *BLANK
 
      ** Set screen to initial screen
 
     C                   EVAL      @SCRN = 'I'
 
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
 
      ** Access SAR details file to see if CSD006 is installed.
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSD006'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        @RTCD <> *Blanks AND
     C                             @RTCD <> '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     2             DBASE
     C                   MOVEL     'CSD006'      DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        @RTCD = *Blanks
     C                   MOVEL     'Y'           CSD006
     C                   ELSE
     C                   MOVEL     'N'           CSD006
     C                   ENDIF
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
     C                   IF        PRtCd <> '*NRF'                                           BUG1625
     C                   EVAL      DBKEY = 'CSC022'                                          BUG1625
     C                   EVAL      DBFILE = 'SCSARDPD'                                       BUG1625
     C                   EVAL      DBASE = 003                                               BUG1625
     C                   EXSR      *PSSR                                                     BUG1625
     C                   ENDIF                                                               BUG1625
                                                                                             BUG1625
     C                   ENDIF                                                               BUG1625
                                                                                             BUG1625
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** ==============================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
