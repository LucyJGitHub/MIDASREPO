     H DEBUG
     H COPYRIGHT('(c) Finastra International Systems Ltd. 2020')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SE Pos Sett Authorised Over Blk CR A/C Rep')     *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      ***SEH030*-*SE*Positions*Settlements*Authorised*Over*Blocked*****                  HUT111
      *  XX111030 - SE Positions Settlements Authorised Over Blocked  *                  HUT111
      *           Credit A/C Report                                   *
      *                                                               *
      *  Function: This report program will list all Corporate Action *
      *            position settlements authorized during input cycle *
      *            which were settled to blocked credit accounts.     *
      *                                                               *
      ***Called*By:*SECH030*-*SE*Positions*Settlements*Authorised******                  HUT111
      *  Called By: SECH030 - SE Positions Settlements Authorised     *                  HUT111
      *                       Over Blocked Credit A/C                 *
      *                                                               *
      ***(c)*Misys*International*Banking*Systems*Ltd.*2016*************                  HUT111
      *  (c) Finastra International Systems Ltd. 2020                 *                  HUT111
      *                                                               *
      *  Last Amend No. HUT111             Date 08Apr20               *
      *  Prev Amend No. HUT024  *CREATE    Date 17Oct16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  HUT111 - Corporate Actions Blocked Credit Account            *
      *           (Upgrade HUT024 to FM2.1 SP22)                      *
      *  HUT024  Corporate Actions Blocked Credit Account            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         End of file for SEPOBCPP                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRInit    - Initialisation routine                           *
      *  SRProc    - Detail Processing routine                        *
      *  SRTerm    - Terminate program                                *
      *  SRPrint   - Print records                                    *
      *  SRSetFields - Set values for fields routine                  *
      *  SRFmtDate   - Subroutine for ZDATE2                          *
      *  SREdit - Subroutine to edit the amount                       *
      *  *PSSR     - Error processing                                 *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** Midas SE Position Settlements with A/C Blocked for CR
     F**********SEPOBCPP  IF   E           K DISK    INFSR(*PSSR)                        HUT111
     FXXPOBCTD  IF   E           K DISK    INFSR(*PSSR)                                  HUT111

      ** Midas SE Pos Sett Authorised Over Blk CR A/C Report
     F**********SEH030P1  O    E             PRINTER USROPN                              HUT111
     FXX111030P1O    E             PRINTER USROPN                                        HUT111
     F                                     INFDS(Spool1)

      *****************************************************************
      **------------------------------------------------------------------+
      ** The following /COPY line includes (among others) the LDA layout  ¦
      ** and the copyright array definition:                              ¦
     D/COPY ZACPYSRC,STD_D_SPEC                                           ¦
      **------------------------------------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS

      ***File*Information*Data*Structure*for*SEH030P1                                    HUT111
      ** File Information Data Structure for XX111030P1                                  HUT111
     D Spool1          DS
     D   Sfnum1              123    124B 0
     D   Oflln1              188    189B 0
     D   Prtln1              367    368B 0

      ** Data structure for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Data structure for Currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      ** Short dummy data structure for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Long dummy data structure for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** Entry Parameters
     D RSEQ            S              5A
     D RENT            S              3A

     D Sfilp           S             10
     D Splno           S              6  0
     D Zerr            S              1

     D WOpenP1         S              1A
     D Rqdln1          S              3  0
     D Difln1          S              3  0

     D PRtcd           S              7A
     D POptn           S              7A
     D PCCY            S              3A
     D ZDayNo          S              5  0
     D ZDate           S              6  0
     D ZADate          S              7A
     D PZFLD15         S             15  0
     D PZECODE         S              1A
     D PZOUT21         S             21A
     D PZDECS          S              1  0

      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
     C                   EXSR      SRInit
     C                   EXSR      SRProc
     C                   EXSR      SRTerm
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProc - Record Processing routine                           *
      *                                                               *
      *****************************************************************

     C     SRProc        BEGSR

      ** Access all Position Settlements with A/C Blocked for Credit

     C******LOVAL        SETLL     SEPOBCPP                                              HUT111
     C**********         READ      SEPOBCD0                               01             HUT111
     C     *LOVAL        SETLL     XXPOBCTD                                              HUT111
     C                   READ      XXPOBCD0                               01             HUT111

     C                   DOW       *IN01 = *Off

     C                   EXSR      SRSetFields
     C                   EXSR      SRPrint

     C**********         READ      SEPOBCD0                               01             HUT111
     C                   READ      XXPOBCD0                               01             HUT111
     C                   ENDDO

      ** If no records were printed, write No Details to Report

     C                   IF        WOpenP1 = 'Y'
     C**********         WRITE     SEH030D4                                              HUT111
     C**********         CLOSE     SEH030P1                                              HUT111
     C                   WRITE     XX111030D4                                            HUT111
     C                   CLOSE     XX111030P1                                            HUT111
     C                   ELSE
     C                   IF        WOpenP1 = 'N'
     C**********         OPEN      SEH030P1                                              HUT111
     C                   OPEN      XX111030P1                                            HUT111
     C                   ENDIF
     C**********         WRITE     SEH030D1                                              HUT111
     C**********         WRITE     SEH030D5                                              HUT111
     C                   WRITE     XX111030D1                                            HUT111
     C                   WRITE     XX111030D5                                            HUT111
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrint - Print the record details to report file            *
      *                                                               *
      *****************************************************************

     C     SRPrint       BEGSR

     C                   IF        WOpenP1 = 'N'
     C                   EVAL      WOpenP1 = 'Y'
     C**********         OPEN      SEH030P1                                              HUT111
     C**********         WRITE     SEH030D1                                              HUT111
     C                   OPEN      XX111030P1                                            HUT111
     C                   WRITE     XX111030D1                                            HUT111
     C                   ENDIF

     C                   Z-ADD     1             Rqdln1
     C     Oflln1        SUB       Prtln1        Difln1
     C                   IF        Difln1 <= Rqdln1
     C**********         WRITE     SEH030D1                                              HUT111
     C                   WRITE     XX111030D1                                            HUT111
     C                   ENDIF

     C                   EVAL      RPTOT = (RPTOT + 1)
     C**********         WRITE     SEH030D3                                              HUT111
     C                   WRITE     XX111030D3                                            HUT111

      ** Clear report fields

     C                   EVAL      RPBCA = *BLANKS
     C                   EVAL      RPSSH = *BLANKS
     C                   EVAL      RPCPY = *BLANKS
     C                   EVAL      RPEVT = *BLANKS
     C                   EVAL      RPSVL = *BLANKS
     C                   EVAL      RPAMD = *BLANKS
     C                   EVAL      RPSCU = *BLANKS
     C                   EVAL      RPSMT = *BLANKS
     C                   EVAL      RACNO = *BLANKS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetFields - Set the value of report fields                 *
      *                                                               *
      *****************************************************************

     C     SRSetFields   BEGSR

      ** Booking Branch
     C                   EVAL      RPBCA = XPBCA

      ** Security
     C                   EVAL      RPSSH = XPSSH

      ** Customer Number
     C                   MOVE      XPCPY         RPCPY

      ** Event Type
     C                   EVAL      RPEVT = XPEVT

      ** Value Date
     C                   EVAL      ZDayNo = XPSVL
     C                   EXSR      SRFmtDate
     C                   EVAL      RPSVL = ZADate

      ** Amount
     C                   Z-ADD     XPAMD         PZFLD15
     C                   EVAL      PZECODE = 'J'
     C                   EXSR      SREdit
     C                   MOVE      PZOut21       RPAMD

      ** Settlement Currency
     C                   EVAL      RPSCU = XPSCU

      ** Settlement Method
     C                   EVAL      RPSMT = XPSMT

      ** Settlement Account
     C                   EVAL      RACNO = XACNO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTerm - Termination routine                                 *
      *                                                               *
      *****************************************************************

     C     SRTerm        BEGSR

     C                   MOVE      *ON           *INLR
     C                   RETURN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtDate - Subroutine for ZDATE2                              *
      *                                                               *
      *****************************************************************

     C     SRFmtDate     BEGSR

     C                   CALL      'ZDATE2'
     C                   PARM                    ZDayNo
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         ZDate
     C                   PARM      *BLANKS       ZADate

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREdit - Subroutine to edit the amount based from the number  *
      *          of decimal places setup in SDCURRPD                  *
      *                                                               *
      * Called by: SRFormat                                           *
      *                                                               *
      * Calls: AOCURRR0, ZSEDIT                                       *
      *                                                               *
      *****************************************************************
     C     SREdit        BEGSR

     C                   EVAL      PCcy = XPSCU
      *
      ** Call AOCURRR0 to check the no. of decimal places setup
      ** for the currency in SDCURRPD
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCcy
     C     SDCURR        PARM      SDCURR        DSSDY

     C     PRtcd         IFNE      *BLANKS
     C                   EVAL      DBFILE =  'SDCURRPD'
     C                   EVAL      DBKEY  =  PCCy
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  004
     C                   EVAL      DBMOD  =  PSProcMod
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   Z-ADD     A6NBDP        PZDecs
      *
      ** Call ZSEDIT to format the amount based from no. of decimal
      ** places
      *
     C                   CALL      'ZSEDIT'
     C                   PARM                    PZFld15
     C                   PARM                    PZDecs
     C                   PARM                    PZeCode
     C                   PARM                    PZOut21

     C                   EVAL      PZFld15 = *ZEROS
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRInit - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************

     C     SRInit        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    RSEQ

      ** RCF Printer File

     C                   Z-ADD     Sfnum1        Splno
     C**********         MOVEL     'SEH030P1'    Sfilp                                   HUT111
     C                   MOVEL     'XX111030P1'  Sfilp                                   HUT111

     C                   Call      'ZSFILE'
     C                   PARM                    RSEQ
     C                   PARM      *BLANK        RENT
     C                   PARM                    Sfilp
     C                   PARM                    Splno
     C                   Parm      *BLANK        Zerr

     C                   IF        Zerr = 'Y'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'ZSFILE'
     C**********         EVAL      DBKEY = 'SEH030P1'                                    HUT111
     C                   EVAL      DBKEY = 'XX111030P1'                                  HUT111
     C                   EVAL      DBPGM = PSProcPgm
     C                   EVAL      DBASE = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Access bank details

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY

     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = POptn
     C**********         EVAL      DBPGM = 'SEH030  '                                    HUT111
     C                   EVAL      DBPGM = 'XX111030'                                    HUT111
     C                   EVAL      DBASE = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Initialise work fields

     C                   EVAL      Prtln1 = *ZERO
     C                   EVAL      WOpenP1 = 'N'
     C                   EVAL      RPTOT = *ZERO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On

     C                   IF        WOpenP1 = 'Y'
     C**********         CLOSE     SEH030P1                                              HUT111
     C                   CLOSE     XX111030P1                                            HUT111
     C                   ENDIF

     C                   DUMP
     C                   RETURN

     C                   ENDSR
      ********************************************************************
**  CPY@
(c) Finastra International Systems Ltd. 2020
