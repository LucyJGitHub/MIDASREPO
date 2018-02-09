     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas DL Pay/receive message extraction for CLS')
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DL6316 - Pay / Receive message extraction for Continuous     *
      *           Linked Settlement.                                  *
      *                                                               *
      *  Function:  This program is called by DLC6316 to check the    *
      *  pay-in schedule to determine if there are any MT202 or MT210 *
      *  messages to be generated.                                    *
      *                                                               *
      *  Called By: DLC6316 - Pay/Receive message extraction for CLS  *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. 217486             Date 06Jun06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG5671            Date 01Feb05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 203505             Date 06Mar02               *
      *                 196191             Date 06Mar02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSW025             Date 26Mar02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 194019             Date 31Jul01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 190033             Date 15Feb01               *
      *                 189658             Date 06Feb01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CDL008  *CREATE    Date 02May00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  217486 - MT202/MT210 generated for a customer even though it *
      *           is setup not to.  Do not generate message if it is  *
      *           suppressed in Standing Data.  Applied fix 209950.   *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG5671- Add Sequence number to detail record (recompile)    *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  203505 - MG0202 expects field MGAWBN to be left aligned.     *
      *  196191 - Enhance 194019 fix.                                 *
      *  CSW025 - Midas Message Manager                               *
      *           - Pass original change type                         *
      *  194019 - Do not put duplicate TRNs on MGOREFPD               *
      *  190033 - MT202/MT210 for CLS schedules must show real nostro *
      *  189658 - CLS Pay-in schedule can be input without a time     *
      *  CDL008 - Continuous Linked Settlement                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         End of header file                              *
      *    02         End of detail file                              *
      *    03         Chain fail on FXSEQNPD                          *
      *    98         Date Format                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      * SRDBErr - Database error processing                           *
      * SRInitFlds - Initialise fields                                *
      * SRUpdFXCLS - Update CLS detail file                           *
      * SRCLSDet - Read detailed CLS schedule processing              *
      * SRMGF210 - Determine receive details                          *
      * SRMGF202 - Determine pay details                              *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** CLS pay schedule detail file
     FFXCLSPSDL1UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** Transaction Sequence Number for CLS Pay/Receives
     FFXSEQNPD  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** CLS pay schedule header file
     FFXCLSPSHL1IF   E           K DISK    INFSR(*PSSR)
      *
      ** MG MT202 generation driver file
     FMGF202PD  O    E             DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** MG MT210 generation driver file
     FMGF210PD  O    E             DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** Pay/Receive message extraction for CLS - audit
     FMGOREFA6  IF   E           K DISK                                                       194019
      *                                                                                       194019
     FDL6316AU  O    E             PRINTER USROPN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
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
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** External DS for nostro details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
      *
      ** External DS for customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** DS for access objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *
      ** DS for access objects - very long data structure
     D DSLDY         E DS                  EXTNAME(DSLDY)
      *
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  EndOfFileH            01     01
     D  EndOfFileD            02     02
      *
      ** Time data structure
     D                 DS
     D  Whhmmss                1      6S 0
     D  Whh                    1      2S 0
     D  Wmm                    3      4S 0
     D  Whhmm                  1      4S 0
      *
      ** Time difference data structure
     D                 DS
     D WTimd                   1      5A
     D WTimdhh                 1      2S 0
     D WTimdmm                 3      4S 0
     D Wsign                   5      5A
      *
      ** Time for payment data structure
     D                 DS
     D WTimtopay               1      4S 0
     D WLtimhh                 1      2S 0
     D WLtimmm                 3      4S 0
     D WCLSTimeA               1      4A
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Work parameters
     D PPNOI           S              1A
     D PFmt            S              1A
     D PAcSn           S              2A
     D PNoNb           S              2A
     D PCyCd           S              3A
     D PBrCd           S              3A
     D***PAccn**         S              4A                                                    CGL029
     D PAccn           S             10A                                                      CGL029
     D PDayNo          S              5P 0
     D PCust           S              6A
     D PDate           S              6P 0
     D PADate          S              7A
     D PRtCd           S              7A
     D POptn           S              7A
     D PKyST           S              7A
     D PCsSn           S             10A
     D PKey1           S             10A
      *
      ** Work variable
     D WPay_Rec        S              1A
     D WRun            S              1A
     D Noupdate        S              1A
     D WSeqN           S              2A
     D WTothh          S              2S 0
     D WLeadHr         S              2S 0
     D WLeadMin        S              2S 0
     D WTotmm          S              3S 0
     D WVDat           S              4A
     D WTrnSeq         S              2A
      *
      ** Pointer for the indicator array
     D IndicatorP      S               *   INZ(%Addr(*IN))
      *                                                                                       217486
     DNGN              S              3A   DIM(15)                                            217486
      *
      ** Rename pay-in schedule detail fields
     IFXCLPDD0
     I              PYRECI                      DRECI
     I              PYCCY                       DCCY
     I              PYNOST                      DNOST
     I              PYSEQN                      DSEQN
     I              PYPRFC                      DPRFC
     I              PYTIMD                      DTIMD
     I              PYTIMS                      DTIMS
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Position pointer to first record.
      *
     C     *LOVAL        SETLL     FXCLSPSHL1
      *
      ** Read pay schedule header record.
      *
     C                   READ      FXCLSPSHL1                             01
      *
      ** Repeat while not end of file.
      *
     C                   DOW       EndOfFileH = False
 
     C                   IF        PYVALD >= BJRDNB AND PYRECI = 'D'
      *
      ** Initialise fields
     C                   EXSR      SRInitFlds
      *
      ** Pay details
     C                   IF        PYTOTP <> *ZEROS
     C                   EVAL      WPay_Rec = 'P'
     C                   ENDIF
      *
      ** Receive details
     C                   IF        PYTOTR <> *ZEROS
     C                   EVAL      WPay_Rec = 'R'
     C                   ENDIF
      *
      ** Read pay schedule details
     C                   EXSR      SRCLSDet
 
     C                   ENDIF
      *
      ** Read next pay schedule header record.
     C                   READ      FXCLSPSHL1                             01
 
     C                   ENDDO
      *
      **  Terminate program
      *
     C                   EVAL      *INLR = *ON
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCLSDet - Read detailed CLS schedule processing             *
      *                                                               *
      *****************************************************************
     C     SRCLSDet      BEGSR
      *
      ** Position pointer to top record.
      *
     C     KPaydetail    SETLL     FXCLSPSDL1
      *
      ** Read pay schedule detail record.
      *
     C     KPaydetail    READE     FXCLSPSDL1                             02
 
     C                   DOW       EndOfFileD = False
 
     C                   IF        DRECI = 'D'
     C                   EVAL      Noupdate = 'Y'
 
      ** Process receive detail
     C                   IF        WPay_Rec = 'R'
     C                   EXSR      SRMGF210
     C                   ENDIF
      *
      ** Process pay detail
     C                   IF        WPay_Rec = 'P'
     C                   EXSR      SRMGF202
     C                   ENDIF
      *
      ** Update CLS pay-in schedule file
     C                   IF        Noupdate = 'Y'
     C                   EXSR      SRUpdFXCLS
     C                   ENDIF
     C                   ENDIF
      *
      ** Read next pay schedule detail record.
     C     KPaydetail    READE     FXCLSPSDL1                             02
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMGF210 - Determine receive details.                        *
      *                                                               *
      *****************************************************************
     C     SRMGF210      BEGSR
      *
      ** Destination customer
      *
      ** Access nostro detail to retrieve CLS pay/receive nostro.
     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      *BLANKS       PCust
     C                   PARM      DCCY          PCyCd
     C                   PARM      *BLANKS       PAccn
     C                   PARM      *BLANKS       PAcSn
     C                   PARM      DNOST         PNoNb
     C                   PARM      *BLANKS       PBrCd
     C                   PARM      *BLANKS       PCsSn
     C                   PARM      *BLANKS       PPNOI
     C     SDNOST        PARM      SDNOST        DSFDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = PCyCd + PNoNb
     C                   EVAL      DBFILE = 'SDNOSTPD'
     C                   EVAL      DBASE = 002
     C                   OUT       LDA
     C                   EXSR      SRDBErr
     C                   ELSE
      *
      ** Ordering bank number
      *
     C                   EVAL      MGROBN = A7CLSM
      *
      ** Branch code
      *
     C                   EVAL      MGBRCA = A7BRCD
      *
      ** Access nostro detail to retrieve destination customer .
     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      *BLANKS       PCust
     C                   PARM      DCCY          PCyCd
     C                   PARM      *BLANKS       PAccn
     C                   PARM      *BLANKS       PAcSn
     C                   PARM      A7LPR         PNoNb
     C                   PARM      *BLANKS       PBrCd
     C                   PARM      *BLANKS       PCsSn
     C                   PARM      *BLANKS       PPNOI
     C     SDNOST        PARM      SDNOST        DSFDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = PCyCd + PNoNb
     C                   EVAL      DBFILE = 'SDNOSTPD'
     C                   EVAL      DBASE = 003
     C                   OUT       LDA
     C                   EXSR      SRDBErr
     C                   ELSE
     C                   MOVE      A7CUST        MGDEST
     C                   ENDIF
     C                   ENDIF
      *                                                                                       217486
      ** Check if destination needs the message                                               217486
      *                                                                                       217486
     C                   EVAL      @TYP = '210'                                               217486
     C                   EXSR      SRMsgChk                                                   217486
     C                   If        *IN10                                                      217486
     C                   GOTO      EMGF210                                                    217486
     C                   Endif                                                                217486
                                                                                              217486
      *
      ** Transaction number
      *
     C                   Z-ADD     PYVDAT        PDayNo
     C                   Z-ADD     0             PDate
     C                   CALL      'ZDATE2'
     C                   PARM                    PDayNo
     C                   PARM      'D'           PFmt
     C                   PARM                    PDate
     C                   PARM      *BLANKS       PADate
 
     C                   MOVEL     PDate         WVDat
     C                   MOVE      DSEQN         WSeqN
      *
     C                   Z-ADD     1             PYTSEQ                                       194019
     C                   MOVE      PYTSEQ        WTrnSeq                                      194019
     C***********        EVAL      MGTNUM = DCCY + DNOST + WVDat +                            190033
     C                   EVAL      MGTNUM = DCCY + A7NONB + WVDat +                           190033
     C                             WSeqN + WTrnSeq                                            194019
     C***********                  WSeqN + '01'                                               194019
      *
      **  Determine if the TRN is unique                                                      194019
     C                   EVAL      TRNO = 'DL' + MGTNUM                                       194019
     C     TRNO          CHAIN     MGOREFD0                           11                      194019
      *                                                                                       194019
     C     *IN11         DOWEQ     '0'                                                        194019
     C                   ADD       1             PYTSEQ                                       194019
     C                   MOVE      PYTSEQ        WTrnSeq                                      194019
     C                   EVAL      MGTNUM = DCCY + A7NONB + WVDat +                           194019
     C                             WSeqN + WTrnSeq                                            194019
     C                   EVAL      TRNO = 'DL' + MGTNUM                                       194019
     C     TRNO          CHAIN     MGOREFD0                           11                      194019
     C                   END                                                                  194019
      *                                                                                       194019
      ** Value date
      *
     C                   EVAL      MGVDAT = PYVDAT
      *
      ** Currency code
      *
     C                   EVAL      MGCCY = DCCY
      *
      ** Event amount
      *
     C                   Z-ADD     PYAMT         MGEAMT
      *
      ** Transaction type
      *
     C                   EVAL      MGTTYP = 'RC'
      *
      ** Last change type
      *
     C                   EVAL      MGCHTP = 'I'
      *
      ** Customer number
      *
     C                   EVAL      MGCNUM = MGDEST
      *
      ** Settlement type
      *
     C                   MOVE      '08'          MGSETP
      *
      ** Our receive branch
      *
     C                   EVAL      MGROBR = MGBRCA
      *
      ** Receipt - our nostro
     C***********        EVAL      MGRONS = DNOST                                             190033
     C                   EVAL      MGRONS = A7NONB                                            190033
      *
      ** Output record to file.
      *
     C                   MOVE      'I'           MGCHTP                                       CSW025
     C                   WRITE     MGF210D0
 
     C**********         ENDSR                                                                217486
     C     EMGF210       ENDSR                                                                217486
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMGF202 - Determine pay details.                            *
      *                                                               *
      *****************************************************************
     C     SRMGF202      BEGSR
      *
      ** Bank to bank information 1
      *
      ** Access nostro detail to retrieve "multiple pay-in
      ** generated by time".
     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      *BLANKS       PCust
     C                   PARM      DCCY          PCyCd
     C                   PARM      *BLANKS       PAccn
     C                   PARM      *BLANKS       PAcSn
     C                   PARM      DNOST         PNoNb
     C                   PARM      *BLANKS       PBrCd
     C                   PARM      *BLANKS       PCsSn
     C                   PARM      *BLANKS       PPNOI
     C     SDNOST        PARM      SDNOST        DSFDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = PCyCd + PNoNb
     C                   EVAL      DBFILE = 'SDNOSTPD'
     C                   EVAL      DBASE = 005
     C                   OUT       LDA
     C                   EXSR      SRDBErr
     C                   ELSE
      *
      ** Get current system time
     C                   TIME                    Whhmmss
      *
      ** Move time difference to a data structure
     C                   MOVEL     DTIMD         WTimd
      *
      ** CET time is ahead, add system time and time difference. Otherwise
      ** subtract.
     C                   IF        Wsign = '+'
 
     C                   EVAL      WTothh = Whh + WTimdhh
     C                   EVAL      WTotmm = Wmm + WTimdmm
     C                   IF        WTotmm >= 60
     C                   EVAL      WTotmm = WTotmm - 60
     C                   EVAL      WTothh = WTothh + 1
     C                   ENDIF
     C                   EVAL      Whh = WTothh
     C                   EVAL      Wmm = WTotmm
 
     C                   ELSE
 
     C                   IF        Wmm < WTimdmm
     C                   EVAL      WTotmm = Wmm + 60
     C                   EVAL      Whh = Whh - 1
     C                   EVAL      WTotmm = WTotmm - WTimdmm
     C                   ELSE
     C                   EVAL      WTotmm = Wmm - WTimdmm
     C                   ENDIF
     C                   EVAL      WTothh = Whh - WTimdhh
     C                   EVAL      Whh = WTothh
     C                   EVAL      Wmm = WTotmm
 
     C                   ENDIF
      *
      ** Compute: CLS Time minus Payment Lead Time
      *
     C                   IF        PYLTIM <> *Blanks                                          189658
      *                                                                                       189658
     C                   Z-ADD     *ZEROS        WLeadHr
     C                   MOVEL     PYLTIM        WTimtopay
      *
      ** If lead time is more than 60 minutes, convert to number of hours
      ** and number of minutes, before subtracting from CLS Time.
      *
     C                   IF        A7PMLT > 60
     C     A7PMLT        DIV       60            WLeadHr
     C                   MVR                     WLeadMin
     C                   EVAL      A7PMLT = WLeadMin
     C                   ENDIF
 
     C                   IF        WLtimmm < A7PMLT
     C                   EVAL      WTotmm = WLtimmm + 60
     C                   EVAL      WLtimhh = WLtimhh - 1
     C                   EVAL      WTotmm = WTotmm - A7PMLT
     C                   ELSE
     C                   EVAL      WTotmm = WLtimmm - A7PMLT
     C                   ENDIF
 
     C                   IF        WLeadHr <> *ZERO
     C                   EVAL      WLtimhh = WLtimhh - WLeadHr
     C                   ENDIF
 
     C                   EVAL      WLtimmm = WTotmm
      *                                                                                       189658
     C                   ENDIF                                                                189658
      *
      ** If Multiple Pay-In Generated By Time = N, generate payment now
      ** but specify CLS Time in Field :72:
      *
     C                   IF        A7MPGT = 'N'
     C                             AND PYLTIM <> *BLANKS                                      189658
     C                   EVAL      MGBTB1 = '/CLSTIME/' + WCLSTimeA
     C                   ENDIF
      *
      ** Else, do not generate payment if system time hasn't reached
      ** CLS Time yet.
      *
     C                   IF        A7MPGT = 'Y'
     C                   IF        WTimtopay >= Whhmm
     C                   EVAL      Noupdate = 'N'
     C                   GOTO      EMGF202
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Branch code
      *
     C                   EVAL      MGBRCA = A7BRCD
      *
      ** Beneficiary number
      *
     C                   MOVE      A7CLSM        MGBENN
      *
      ** Account with bank number
      *
     C*******            MOVE      A7CLSC        MGAWBN                                       203505
     C                   MOVEL     A7CLSC        MGAWBN                                       203505
      *
      ** Destination customer
      *
     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      *BLANKS       PCust
     C                   PARM      DCCY          PCyCd
     C                   PARM      *BLANKS       PAccn
     C                   PARM      *BLANKS       PAcSn
     C                   PARM      A7LPR         PNoNb
     C                   PARM      *BLANKS       PBrCd
     C                   PARM      *BLANKS       PCsSn
     C                   PARM      *BLANKS       PPNOI
     C     SDNOST        PARM      SDNOST        DSFDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = PCyCd + PNoNb
     C                   EVAL      DBFILE = 'SDNOSTPD'
     C                   EVAL      DBASE = 006
     C                   OUT       LDA
     C                   EXSR      SRDBErr
     C                   ELSE
     C                   MOVE      A7CUST        MGDEST
     C                   ENDIF
      *                                                                                       217486
      ** Check if destination needs the message                                               217486
      *                                                                                       217486
     C                   EVAL      @TYP = '202'                                               217486
     C                   EXSR      SRMsgChk                                                   217486
     C                   If        *IN10                                                      217486
     C                   GOTO      EMGF202                                                    217486
     C                   Endif                                                                217486
      *
      ** Transaction number
      *
     C                   Z-ADD     PYVDAT        PDayNo
     C                   Z-ADD     0             PDate
     C                   CALL      'ZDATE2'
     C                   PARM                    PDayNo
     C                   PARM      'D'           PFmt
     C                   PARM                    PDate
     C                   PARM      *BLANKS       PADate
 
     C                   MOVEL     PDate         WVDat
     C                   MOVE      DSEQN         WSeqN
 
      ** Obtain transaction sequence number from file or create new
 
     C     KSeqNo        CHAIN     FXSEQNPD                           03
 
      **  Determine if the TRN is unique                                                      194019
     C     *IN03         IFEQ      '1'                                                        196191
     C                   Z-ADD     1             PYTSEQ                                       194019
     C                   ELSE                                                                 196191
     C                   ADD       1             PYTSEQ                                       196191
     C                   ENDIF                                                                196191
     C                   MOVE      PYTSEQ        WTrnSeq                                      194019
     C                   EVAL      MGTNUM = DCCY + A7NONB + WVDat +                           194019
     C                             WSeqN + WTrnSeq                                            194019
     C                   EVAL      TRNO = 'DL' + MGTNUM                                       194019
     C     TRNO          CHAIN     MGOREFD0                           11                      194019
      *                                                                                       194019
     C     *IN11         DOWEQ     '0'                                                        194019
     C                   ADD       1             PYTSEQ                                       194019
     C                   MOVE      PYTSEQ        WTrnSeq                                      194019
     C                   EVAL      MGTNUM = DCCY + A7NONB + WVDat +                           194019
     C                             WSeqN + WTrnSeq                                            194019
     C                   EVAL      TRNO = 'DL' + MGTNUM                                       194019
     C     TRNO          CHAIN     MGOREFD0                           11                      194019
     C                   END                                                                  194019
      *                                                                                       194019
     C     *IN03         IFEQ      *OFF
     C**********         ADD       1             PYTSEQ                                       196191
     C                   UPDATE    FXSEQND0
     C                   ELSE
     C                   EVAL      PYCURR = DCCY
     C                   EVAL      PYDNOS = DNOST
     C                   EVAL      PYVLDT = PYVDAT
     C                   EVAL      PYCSEQ = DSEQN
     C***********        EVAL      PYTSEQ = 1                                                 194019
     C                   WRITE     FXSEQND0
     C                   ENDIF
 
     C                   MOVE      PYTSEQ        WTrnSeq
 
     C***********        EVAL      MGTNUM = DCCY + DNOST + WVDat +                            190033
     C                   EVAL      MGTNUM = DCCY + A7NONB + WVDat +                           190033
     C                             WSeqN + WTrnSeq
      *
      ** Value date
      *
     C                   EVAL      MGVDAT = PYVDAT
      *
      ** Currency code
      *
     C                   EVAL      MGCCY = DCCY
      *
      ** Event amount
      *
     C                   Z-ADD     PYAMT         MGEAMT
      *
      ** Transaction type
      *
     C                   EVAL      MGTTYP = 'PC'
      *
      ** Last change type
      *
     C                   EVAL      MGCHTP = 'I'
      *
      ** Customer number
      *
     C                   EVAL      MGCNUM = MGDEST
      *
      ** Settlement type
      *
     C                   MOVE      '08'          MGSETP
      *
      ** Our pay branch
      *
     C                   EVAL      MGPOBR = MGBRCA
      *
      ** Payments - our nostro
     C***********        EVAL      MGPONS = DNOST                                             190033
     C                   EVAL      MGPONS = A7NONB                                            190033
      *
      ** Output record to file.
      *
     C                   MOVE      'I'           MGCHTP                                       CSW025
     C                   WRITE     MGF202D0
 
     C     EMGF202       ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdFXCLS - Update CLS detail file                          *
      *                                                               *
      *****************************************************************
     C     SRUpdFXCLS    BEGSR
      *
      ** Flag CLS generated flag to 'Y'
      *
     C                   EVAL      PYGENT = 'Y'
      *
      ** Update pay schedule file
      *
     C                   UPDATE    FXCLPDD0
 
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  217486
      *****************************************************************                       217486
      *                                                               *                       217486
      *  SRMsgChk - Verify if message is suppressed                   *                       217486
      *                                                               *                       217486
      *****************************************************************                       217486
     C     SRMsgChk      BEGSR                                                                217486
                                                                                              217486
     C     *LIKE         DEFINE    NGN(1)        @TYP                                         217486
     C                   EVAL      *IN10 = *OFF                                               217486
      *                                                                                       217486
      **Get customer details                                                                  217486
      *                                                                                       217486
     C                   CALL      'AOCUSTR0'                                                 217486
     C                   PARM      *BLANKS       @Rtcd             7                          217486
     C                   PARM      '*KEY   '     @Optn             7                          217486
     C                   PARM      A7CUST        @Bbkey           10                          217486
     C                   PARM      *BLANKS       @Bbky2            7                          217486
     C     SDCUST        PARM      SDCUST        DSSDY                                        217486
                                                                                              217486
     C                   If        @Rtcd <> *BLANKS or @Bbky2 = 'ERROR  '                     217486
     C     *LOCK         IN        LDA                                                        217486
     C                   EVAL      DBKEY = A7CUST                                             217486
     C                   EVAL      DBFILE = 'SDCUSTPD'                                        217486
     C                   EVAL      DBASE = 007                                                217486
     C                   OUT       LDA                                                        217486
     C                   EXSR      SRDBErr                                                    217486
     C                   EndIf                                                                217486
      *                                                                                       217486
      **  Load array NGN with all message types that are not                                  217486
      **  to be generated for this customer                                                   217486
      *                                                                                       217486
     C                   EVAL      NGN(1) =  BBNG01                                           217486
     C                   EVAL      NGN(2) =  BBNG02                                           217486
     C                   EVAL      NGN(3) =  BBNG03                                           217486
     C                   EVAL      NGN(4) =  BBNG04                                           217486
     C                   EVAL      NGN(5) =  BBNG05                                           217486
     C                   EVAL      NGN(6) =  BBNG06                                           217486
     C                   EVAL      NGN(7) =  BBNG07                                           217486
     C                   EVAL      NGN(8) =  BBNG08                                           217486
     C                   EVAL      NGN(9) =  BBNG09                                           217486
     C                   EVAL      NGN(10)=  BBNG10                                           217486
     C                   EVAL      NGN(11)=  BBNG11                                           217486
     C                   EVAL      NGN(12)=  BBNG12                                           217486
     C                   EVAL      NGN(13)=  BBNG13                                           217486
     C                   EVAL      NGN(14)=  BBNG14                                           217486
     C                   EVAL      NGN(15)=  BBNG15                                           217486
      *                                                                                       217486
     C     @TYP          Lookup    NGN                                    10                  217486
      *                                                                                       217486
     C                   ENDSR                                                                217486
      *****************************************************************                       217486
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInitFlds - Initialise fields                               *
      *                                                               *
      *****************************************************************
     C     SRInitFlds    BEGSR
      *
      ** Initialise fields for MGF202PD
      *
     C**********         EVAL      MGDEST = *ZEROS                                            CSD027
     C                   EVAL      MGDEST = *BLANKS                                           CSD027
     C                   EVAL      MGTNUM = *BLANKS
     C                   EVAL      MGMODI = *BLANKS
     C                   EVAL      MGVDAT = *ZEROS
     C                   EVAL      MGCCY  = *BLANKS
     C                   EVAL      MGEAMT = *ZEROS
     C                   EVAL      MGTTYP = *BLANKS
     C                   EVAL      MGTSTP = *BLANKS
     C                   EVAL      MGBRCA = *BLANKS
     C                   EVAL      MGAMTP = *BLANKS
     C                   EVAL      MGCHTP = *BLANK
     C**********         EVAL      MGCNUM = *ZEROS                                            CSD027
     C                   EVAL      MGCNUM = *BLANKS                                           CSD027
     C                   EVAL      MGSETP = *ZEROS
     C**********         EVAL      MGPOBN = *ZEROS                                            CSD027
     C                   EVAL      MGPOBN = *BLANKS                                           CSD027
     C                   EVAL      MGRVNO = *BLANKS
     C                   EVAL      MGRCRN = *BLANKS
     C                   EVAL      MGRCRA = *BLANKS
     C                   EVAL      MGPIBN = *BLANKS
     C                   EVAL      MGPIBA = *BLANKS
     C                   EVAL      MGPONS = *BLANKS
     C                   EVAL      MGPOBR = *BLANKS
     C                   EVAL      MGAWBN = *BLANKS
     C                   EVAL      MGAWBA = *BLANKS
     C                   EVAL      MGBENN = *BLANKS
     C                   EVAL      MGBENA = *BLANKS
     C                   EVAL      MGBTB1 = *BLANKS
     C                   EVAL      MGBTB2 = *BLANKS
     C                   EVAL      MGBTB3 = *BLANKS
     C                   EVAL      MGBTB4 = *BLANKS
     C                   EVAL      MGBTB5 = *BLANKS
     C                   EVAL      MGBTB6 = *BLANKS
     C                   EVAL      MGRATE = *ZEROS
     C                   EVAL      MGAVDT = *ZEROS
     C                   EVAL      MGASEQ = *ZEROS
     C                   EVAL      MGAWBB = *BLANKS
     C                   EVAL      MGCVMI = *BLANK
     C                   EVAL      MGOTRA = *ZEROS
     C                   EVAL      MGOTRC = *BLANKS
      *
      ** Initialise fields for MGF210PD
      *
     C**********         EVAL      MGROCN = *ZEROS                                            CSD027
     C**********         EVAL      MGROBN = *ZEROS                                            CSD027
     C                   EVAL      MGROCN = *BLANKS                                           CSD027
     C                   EVAL      MGROBN = *BLANKS                                           CSD027
     C                   EVAL      MGRIBN = *BLANKS
     C                   EVAL      MGRIBA = *BLANKS
     C                   EVAL      MGRONS = *BLANKS
     C                   EVAL      MGROBR = *BLANKS
     C                   EVAL      MGRATE = *ZEROS
     C                   EVAL      MGAVDT = *ZEROS
     C                   EVAL      MGASEQ = *ZEROS
     C                   EVAL      MGOTRA = *ZEROS
     C                   EVAL      MGOTRC = *BLANKS
      *
      ** Set value for module id.
      *
     C                   EVAL      MGMODI = 'DL'
 
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
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA
      *
      ** Access bank details.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error.
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   OUT       LDA
     C                   EXSR      SRDBErr
     C                   ENDIF
      *
      ** Key list for CLS pay schedule detail file.
      *
     C     KPaydetail    KLIST
     C                   KFLD                    PYCCY
     C                   KFLD                    PYNOST
     C                   KFLD                    PYVALD
     C                   KFLD                    PYSEQN
 
      ** Key list for Transaction sequence number
 
     C     KSeqNo        KLIST
     C                   KFLD                    DCCY
     C                   KFLD                    DNOST
     C                   KFLD                    PYVDAT
     C                   KFLD                    DSEQN
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDBErr - Database error processing                          *
      *                                                               *
      *****************************************************************
     C     SRDBErr       BEGSR
 
     C                   OPEN      DL6316AU
     C                   WRITE     HEADAU
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   WRITE     DBERROR
     C                   CLOSE     DL6316AU
 
     C                   EXSR      *PSSR
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
