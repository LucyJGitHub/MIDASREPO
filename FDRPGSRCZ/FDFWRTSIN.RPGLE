     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FD Forward Rates Screen Input Module')
      *****************************************************************
      *                                                               *
      *  Midas - Dealing ILE Module                                   *
      *                                                               *
      *  FDFWRTSIN - Forward Rates Screen Input Module                *
      *                                                               *
      *  Function:  This is the main screen input function            *
      *             for Forward Rates Details.                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *  Last Amend No. 241919             Date 22Dec06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG8233            Date 23Aug05               *
      *                 BUG8141            Date 11Aug05               *
      *                 238595 (Reopen)    Date 03Apr06               *
      *                 BUG1056            Date 20May04               *
      *                 213558             Date 22Jan03               *
      *                 214114             Date 14Jan03               *
      *                 213561             Date 10Jan03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 09Nov00               *
      *                 CAP059  *CREATE    Date 09Nov00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  241919 - Recompiled due to changes done to FDVFWRTPD.        *
      *  BUG8233- Error in Forward Rates upload via File Adapter API  *
      *           (Recompile)                                         *
      *  BUG8141- Recompiled due to changes to FDVFWRTPD              *
      *  238595 (Reopen) - Pass new parameter to FDFWRTVAL.           *
      *  BUG1056 - (CSC022) Commitment Control Changes for MidasPlus  *
      *  213558 - MDF Rate Maintenance Time/Date Stamp amendable      *
      *  214114 - Error on amend forward rate. Sometimes updates twice*
      *  213561 - Error when reach begin/end of file using F7 and F8  *
      *  CSD006 - Market Data Feeds                                   *
      *  CAP059 - Conversion of Forward Rates into Modular APIs       *
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
 
 
      ** Commitment Control Job Array                                                        BUG1056
     D WJobs           S             10A   Dim(10)                                           BUG1056
      **                                                                                     BUG1056
     D CrFRFilFmt    E DS                  EXTNAME(FWDRTFE)
     D                                     PREFIX(C_)
      ** Current Forward Rates Detail in File Format
 
     D PrvFRFilFmt   E DS                  EXTNAME(FDVFWRTPD)
     D                                     PREFIX(P_)
      ** Previous Forward Rates Detail in File Format
 
     D CurFRScnFmt   E DS                  EXTNAME(FDFWRTPD)
      ** Current Forward Rates Detail in Screen Format
 
     D CurFRExtDta   E DS                  EXTNAME(FDIREXPD)
      ** Current forward Rates Extra Data
 
     D PrvFRScnFmt   E DS                  EXTNAME(FDFWRTPD)
     D                                     PREFIX(@P)
      ** Previous Forward Rates Detail in Screen Format
 
     D ValidFRDets   E DS                  EXTNAME(FDVFWRTPD)
      ** Valid Forward Rate Detail File Format
 
     D OKFRDets      E DS                  EXTNAME(FDEFWRTPD)
      ** Error indicators
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** External DS for SAR Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, short data structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for Access Programs, long data structure
 
      ** SCCMTJOB DataArea Layout                                                            BUG1056
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                BUG1056
     D  WDSJobs                4    103A                                                     BUG1056
      **                                                                                     BUG1056
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
 
      ** Update Y/N?                                                                          238595
     D UpdateYN        S              1A   INZ(*BLANK)                                        238595
                                                                                              238595
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
 
      ** Timestamp for the transaction
     D TimeStamp       S               Z
 
      ** Query check in key screen customer number field
     D KEYQUERY        S              1A
 
      ** CSC022 switchable field                                                             BUG1056
     D CSC022          S              1A                                                     BUG1056
      **                                                                                     BUG1056
      ** CSC022 work fields                                                                  BUG1056
     D WArrPtr         S              3S 0                                                   BUG1056
     D WSkpComtRolbk   S              1A                                                     BUG1056
      **                                                                                     BUG1056
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
      **                                                                                     BUG1056
      ** Execute rollback if SAR CSC022 is not enrolled or                                   BUG1056
      **   job is not currently running in batch mode                                        BUG1056
      **                                                                                     BUG1056
     C                   If        CSC022 = 'N'                                              BUG1056
     C                   ROLBK
     C                   Else                                                                BUG1056
     C                   If        WSkpComtRolbk = 'N'                                       BUG1056
     C                   RolBk                                                               BUG1056
     C                   Else                                                                BUG1056
     C                   SetOn                                        U7U8                   BUG1056
     C                   EndIf                                                               BUG1056
     C                   EndIf                                                               BUG1056
     C                   ENDIF
 
      ** Read next browse subfile record
 
     C     @SCRN         IFEQ      'R'
     C                   EXSR      SrRDNXTB
     C                   ENDIF
 
      ** Do while screen: Initial Screen
 
     C     @SCRN         DOWEQ     'I'
     C                   EXSR      SrDSPINI
     C                   ENDDO
 
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
     C     @SCRN         IFEQ      'C'
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
 
     C                   EVAL      PrvFRScnFmt = CurFRScnFmt
     C                   Z-Add     WIdx_PVAL     PrvN_Warn
 
      ** Set function key narratives and field status
 
     C                   EXSR      SrSETFSTS
 
      ** Write/Read Display Screen
 
     C                   CALLB     'FDFWRTDSP'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    CurFRScnFmt
     C                   PARM                    OKFRDets
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    PEKYFD
     C                   PARM                    WriteOnly
     C                   PARM                    PEINKJ
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
      * SrROLL    - Display Previous or Next Forward Rate Details     *
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
 
      ** Read Forward Rate Detail
 
     C                   CALLB     'FDFWRTRED'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    DDACTN
     C                   PARM                    DDCCY
     C                   PARM                    PRDFWD
     C                   PARM                    PRDBCK
     C                   PARM      *BLANK        PERRMS
     C                   PARM      *BLANK        @TRRED            3
 
      ** Error message returned from read, send it to detail screen
 
     C     PERRMS        IFNE      *BLANK
     C                   EXSR      SrSNDERR
     C                   ENDIF
 
      ** Convert record to screen format
 
     C     PERRMS        IFEQ      *BLANK
     C     @TRRED        ANDNE     *BLANK
 
      * Retrieve transaction details
 
     C                   MOVEL     @TRRED        DDCCY
 
     C                   EXSR      SrRTVREC
 
      ** No error retrieving the record
 
     C                   IF        (DDACTNOK = 'Y') AND (DDCCYOK = 'Y')
     C                   MOVEL     CRFRFILFmt    PRVFRFilFmt
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
 
     C                   CALLB     'FDFWRTBRW'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    DDACTN
     C                   PARM                    DDCCY
     C                   PARM      'Y'           PBDSFL
     C                   PARM      *BLANK        PRDSFL
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
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
 
     C                   CALLB     'FDFWRTBRW'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    DDACTN
     C                   PARM                    DDCCY
     C                   PARM      *BLANK        PBDSFL
     C                   PARM      'Y'           PRDSFL
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
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
 
      ** Retrieve and Convert Forward Rate Details
 
     C     POPSEL        IFNE      *BLANK
 
     C                   EVAL      DDACTN = POPSEL
     C                   EVAL      DDCCY = PCCY
 
     C                   EXSR      SrRTVREC
 
      ** No error retrieving the record
 
     C                   IF        (DDACTNOK = 'Y') AND (DDCCYOK = 'Y')
     C                   MOVEL     CRFRFILFmt    PRVFRFilFmt
     C                   EXSR      SrCONVERT
     C                   ENDIF
 
      ** Set an indicator that a subfile record has been read
 
     C                   EVAL      WSFLRD = 'Y'
     C                   ELSE
     C                   EVAL      WRDNXTB = *BLANK
 
      ** All records that have been selected were already read, clear
      ** out screen fields
 
     C                   IF        (PrvFRScnFmt = CurFRScnFmt) AND
     C                             (WSFLRD = 'Y')
     C                   CLEAR                   CurFRScnFmt
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
     C                   Eval      @SCRN = 'C'
     C                   Eval      DDCCY =*BLANKS
     C                   GOTO      ENDVAL
     C                   ENDIF
 
      ** Prior to validation, initialise error indicators as 'OK'
 
     C                   EXSR      SrRESETERR
 
      ** Reset Forward rate valid file
 
     C                   CLEAR                   ValidFRDets
 
      ** Validate action code and currency and retrieve record if action is
      ** 'A', 'D', or 'E'.
 
     C                   EXSR      SrRTVREC
 
      ** If error found on action code or currency, display message
 
     C                   IF        (DDACTNOK = 'N') OR (DDCCYOK = 'N')
     C                   GOTO      ENDVAL
     C                   ENDIF
 
     C                   IF        DDACTN = 'I'
     C                   IF        DDACTN <> @PDDACTN OR
     C                             DDCCY <> @PDDCCY
     C                   MOVEL     CRFRFILFmt    PRVFRFilFmt
     C                   EXSR      SrDFT
     C                   GOTO      ENDVAL
     C                   ENDIF
     C                   ENDIF
 
      ** Put Forward rate details to screen fields when one of the following
      ** conditions are  true:
      ** 1.) First time to pass to CONVERSION module and the action taken is
      **     'E', 'A', or 'D'
      ** 2.) Record previously converted and the action code has been changed
      ** 3.) Record previously converted and the currency has been changed
      ** 4.) Enquire mode and there has been a change in the rate details when
      **     input fields are input capable
      ** 5.) Delete mode and there has been a change in the rate details when
      **     input fields are input capable
 
     C                   IF        (DDACTN = 'E') OR (DDACTN = 'D') OR
     C                             (DDACTN = 'A')
     C                   IF        (WPRVCONV = 'N') OR
     C                             (WPRVCONV = 'Y') AND (DDACTN <> @PDDACTN) OR
     C                             (WPRVCONV = 'Y') AND (DDCCY <> @PDDCCY) OR
     C                             (DDACTN = 'E') AND
     C                             (PrvFRScnFmt <> CurFRScnFmt) OR
     C                             (DDACTN = 'D') AND
     C                             (PrvFRScnFmt <> CurFRScnFmt)
 
      ** Save previous Forward rate details when action is 'A'
 
     C                   IF        DDACTN = 'A'
     C                   MOVEL     CrFRFilFmt    PrvFRFilFmt
     C                   ENDIF
     C                   EXSR      SrCONVERT
     C                   ENDIF
     C                   ENDIF
 
      ** For action 'E' or 'D' if the previous screen is the same as
      ** the current screen, go to initial screen
 
     C                   IF        (WriteOnly = 'Y') AND (DDACTN = 'E') OR
     C                             (WriteOnly = 'Y') AND (DDACTN = 'D')
     C                   IF        (PrvFRScnFmt = CurFRScnFmt)
     C                   CLEAR                   CurFRScnFmt
     C                   EXSR      SrRESETERR
     C                   GOTO      ENDVAL
     C                   ENDIF
     C                   ENDIF
 
     C                   IF         DDACTN = 'A' OR DDACTN = 'I'
 
     C                   CALLB     'FDFWRTAMD'
     C                   PARM                    RetCodeIn
     C                   PARM                    PrvFRScnFmt
     C                   PARM                    CurFRScnFmt
     C                   PARM                    OKFRDets
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    AmendOk           1
     C                   PARM      'Y'           ResetErrs         1
 
     C     Idx           IFNE      *ZERO
     C                   GOTO      ENDVAL
     C                   ENDIF
 
     C                   ENDIF
 
      ** Validate detail inputs for Amend or Insert
 
     C                   IF        (DDACTN = 'I') OR (DDACTN = 'A')
     C                   IF        DDACTN = 'A'                                               213558
      * blank out timestamp and request id when amending via screen                           213558
      * therefore won't show on tolerance report                                              213558
     C                   EVAL      DDDFRI= *BLANKS                                            213558
     C                   EVAL      DDDFTS= *BLANKS                                            213558
     C                   ENDIF                                                                213558
     C                   CALLB     'FDFWRTVAL'
     C                   PARM                    RespMode
     C                   PARM                    CurFRScnFmt
     C                   PARM                    CurFRExtDta
     C                   PARM                    PrvFRFilFmt
     C                   PARM                    OKFRDets
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    ValidFRDets
     C                   PARM                    UpdateYN                                     238595
 
      ** Errors returned
 
     C     Idx           IFNE      *ZERO
     C                   GOTO      ENDVAL
     C                   ENDIF
 
      ** If there are warnings which have not been displayed
      ** re-output the screen
 
     C                   EVAL      WIdx_PVal = WIdx_PVal + WIdx
     C     WIdx_PVal     IFNE      PrvN_Warn
     C                   GOTO      ENDVAL
     C                   ENDIF
 
      ** Clear any warning messages
 
     C                   MOVE      *ALL'Y'       OKFRDets
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
     C                   ENDIF
 
      ** Update the file
 
     C                   IF        (%SUBST(CurFRScnFmt:5) <> *BLANK) AND
     C                             (DDACTN = @PDDACTN) AND (DDCCY = @PDDCCY)
     C                   EVAL      @SCRN = 'U'
     C                   ENDIF
 
     C     ENDVAL        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRTVREC - Retrieve Forward Rate Details                      *
      *                                                               *
      *****************************************************************
     C     SrRTVREC      BEGSR
 
      ** Call Retrieve Module
 
     C                   CALLB     'FDFWRTRTV'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM      *BLANK        ModeOfOp
     C                   PARM                    RespMode
     C                   PARM                    DDACTN
     C                   PARM                    DDCCY
     C                   PARM      *BLANK        PFOTRID
     C                   PARM                    CrFRFilFmt
     C                   PARM                    DDACTNOK
     C                   PARM                    DDCCYOK
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * SrDFT - Default first rate                                    *
      *                                                               *
      *****************************************************************
     C     SrDFT         BEGSR
 
      ** Call Retrieve Module
 
     C                   CALLB     'FDFWRTDFT'
      * Return Code
     C                   PARM                    RetCodeIn
      ** Action Code
     C                   PARM                    DDACTN            1
      ** Currency Code
     C                   PARM                    DDCCY             3
      ** First Rate
     C                   PARM                    DDRTE1           14
      * OUTPUTS
      *
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFRDETS
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
      *
     C                   PARM                    Idx
      *
      * Reset of Fields in Error Required (Y/N)
     C                   PARM      'Y'           ResetErrs         1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCONVERT - Convert Forward Rate Details in Screen Format     *
      *                                                               *
      *****************************************************************
     C     SrCONVERT     BEGSR
 
      ** Call Convert Module
 
     C                   CALLB     'FDFWRTCVT'
     C                   PARM                    RetCodeIn
     C                   PARM                    CrFRFilFmt
     C                   PARM                    CurFRScnFmt
 
     C                   EVAL      WPRVCONV = 'Y'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrUPDATE -  Confirm Screen Inputs                             *
      *                                                               *
      *****************************************************************
     C     SrUPDATE      BEGSR
 
      ** Call update module
 
     C                   CALLB     'FDFWRTUPD'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    ValidFRDets
 
      ** If there were any errors in the update functions, rollback any
      ** updates and end this program. Otherwise, commit the updates
 
     C     RetCodeOut    IFNE      *BLANK
     C     RetCodeOut    ANDNE     '*RECUPD'
      **                                                                                     BUG1056
      ** Execute rollback if SAR CSC022 is not enrolled or                                   BUG1056
      **   job is not currently running in batch mode                                        BUG1056
      **                                                                                     BUG1056
     C                   If        CSC022 = 'N'                                              BUG1056
     C                             Or (CSC022 = 'Y' and WSkpComtRolbk = 'N')                 BUG1056
     C                   ROLBK
     C                   EndIf                                                               BUG1056
     C                   EXSR      *PSSR
     C                   ELSE
      **                                                                                     BUG1056
      ** Execute commit if SAR CSC022 is not enrolled or                                     BUG1056
      **   job is not currently running in batch mode                                        BUG1056
      **                                                                                     BUG1056
     C                   If        CSC022 = 'N'                                              BUG1056
     C                             Or (CSC022 = 'Y' and WSkpComtRolbk = 'N')                 BUG1056
     C                   COMMIT
     C                   EndIf                                                               BUG1056
     C                   ENDIF
 
      ** If update not done due to record being updated by another
      ** workstation send message to screen.
 
     C     RetCodeOut    IFEQ      '*RECUPD'
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'MMM1067'     MsgIdArr(1)
     C                   ENDIF
 
      ** If successful update, send message to screen
 
     C     RetCodeOut    IFEQ      *BLANK
     C     DDACTN        IFEQ      'A'
     C*******************MOVEL     'FDM8028'     MsgIdArr(1)
     C                   MOVEL     'FDM8028'     MsgIdArr(1)                                  214114
     C                   ELSE
     C     DDACTN        IFEQ      'I'
     c                   MOVEL     'FDM8029'     MsgIdArr(1)
     C                   ELSE
     C                   MOVEL     'FDM8027'     MsgIdArr(1)
     C                   ENDIF
     C                   ENDIF
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     DDCCY         MsgDtaArr(1)
     C                   ENDIF
 
      ** If records are still to be read from the subfile, read them
 
     C*****WRDNXTB*******IFEQ      'Y'                                                       214114
     C*******************MOVEL     'R'           @SCRN                                       214114
     C*******************ELSE                                                                214114
 
      ** Else, go to initial screen
 
     C                   CLEAR                   CurFRScnFmt
 
     C                   EVAL      @SCRN = 'I'
     C*******************ENDIF                                                                214114
 
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
 
     C                   MOVEL     CrFRFilFmt    ValidFRDets
     C                   EVAL      FWCHTP = 'D'
     C                   EVAL      @SCRN = 'U'
 
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
 
     C                   IF        PERRMS = 'MMM1003' OR PERRMS = 'MMM1002'                   213561
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
 
     C                   MOVE      *ALL'Y'       OKFRDets
 
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
     C********DM*******  IF        (WriteOnly = 'N') AND (PINKP = FALSE)
     C                   IF        PINKP = FALSE
     C                   CLEAR                   CurFRScnFmt
 
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
     C                   MOVEL     'FDFWRTSIN'   DBPGM
     C                   OUT       LDA
 
      ** Initialise Data Structures
 
     C                   CLEAR                   CurFRScnFmt
     C                   CLEAR                   CrFRFilFmt
     C                   CLEAR                   PrvFRScnFmt
     C                   CLEAR                   ValidFrDets
 
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
 
      ** Access SAR details file to see if CSD006 is installed.                 CSD006
 
     C                   CALLB     'AOSARDR0'                                   CSD006
     C                   PARM      *BLANKS       @RTCD                          CSD006
     C                   PARM      '*VERIFY'     @OPTN                          CSD006
     C                   PARM      'CSD006'      @SARD                          CSD006
     C     SCSARD        PARM      SCSARD        DSFDY                          CSD006
                                                                                CSD006
     C                   IF        @RTCD <> *Blanks AND                         CSD006
     C                             @RTCD <> '*NRF   '                           CSD006
     C                   MOVEL     'SCSARDPD'    DBFILE                         CSD006
     C                   Z-ADD     2             DBASE                          CSD006
     C                   MOVEL     'CSD006'      DBKEY                          CSD006
     C                   EXSR      *PSSR                                        CSD006
     C                   ENDIF                                                  CSD006
                                                                                CSD006
     C                   IF        @RTCD = *Blanks                              CSD006
     C                   MOVEL     'Y'           CSD006            1            CSD006
     C                   ELSE                                                   CSD006
     C                   MOVEL     'N'           CSD006                         CSD006
     C                   ENDIF                                                  CSD006
      **                                                                                     BUG1056
      ** Access SAR details to see if CSC022 is switched on                                  BUG1056
      **                                                                                     BUG1056
     C                   CallB     'AOSARDR0'                                                BUG1056
     C                   Parm      *Blanks       @RtCd                                       BUG1056
     C                   Parm      '*VERIFY'     @Optn                                       BUG1056
     C                   Parm      'CSC022'      @Sard                                       BUG1056
     C     SCSARD        Parm      SCSARD        DSFDY                                       BUG1056
      ** Initialize CSC022 and Skip Commit Flags                                             BUG1056
     C                   Eval      CSC022 = 'N'                                              BUG1056
     C                   Eval      WSkpComtRolbk = 'N'                                       BUG1056
      **                                                                                     BUG1056
     C                   If        @RtCd = *BLANKS                                           BUG1056
     C                   Eval      CSC022 = 'Y'                                              BUG1056
      **                                                                                     BUG1056
      ** Get Jobs currently running i batch mode using SCCMRJOB dataarea                     BUG1056
      **                                                                                     BUG1056
     C                   In        SCCMTJOB                                                  BUG1056
     C                   If        ComitNum > 0                                              BUG1056
      ** Move committed jobs to arrary for checking                                          BUG1056
     C                   MoveA     WDSJobs       WJobs                                       BUG1056
      ** Verify if job running exists in array                                               BUG1056
     C                   Eval      WArrPtr = %LookUp(PSJobName:WJobs)                        BUG1056
     C                   If        WArrPtr > 0                                               BUG1056
     C                   Eval      WSkpComtRolbk = 'Y'                                       BUG1056
     C                   EndIf                                                               BUG1056
     C                   EndIf                                                               BUG1056
      **                                                                                     BUG1056
     C                   Else                                                                BUG1056
      ** Execute *PSSR if CSC022 is not found or Database error                              BUG1056
     C                   If        @RtCd <> '*NRF'                                           BUG1056
     C     *Lock         In        LDA                                                       BUG1056
     C                   Eval      DBFile = 'SCSARDPD'                                       BUG1056
     C                   Eval      DBPgm  = 'FDFWRTSIN'                                      BUG1056
     C                   Eval      DBKey  = 'CSC022'                                         BUG1056
     C                   Eval      DBase  = 900                                              BUG1056
     C                   Out       LDA                                                       BUG1056
     C                   Exsr      *PSSR                                                     BUG1056
     C                   EndIf                                                               BUG1056
     C                   EndIf                                                               BUG1056
      **                                                                                     BUG1056
 
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
