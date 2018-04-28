     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Amount Amortisation List')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL001995 - Amount Amortisation Audit List                    *
      *                                                               *
      *  Function:  This program will be created to generate an       *
      *             audit list of all records inserted, amended and   *
      *             deleted from the Amount Amortisation main file    *
      *             GLAMRTPD.                                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. BUG13042           Date 16Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CAS009  *CREATE    Date 04May04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG13042 - Two different reports having same title           *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAS009 - Effective Interest Rate/Amortised Cost Accounting   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators:                                           *
      *                                                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRTotal - Perform total time operations                      *
      *  SROpenPrtf - Open prtf if the prtf is not open               *
      *  SRPrint - Print details                                      *
      *  SRFiletoPrtf - Format and move file field values to prtf     *
      *  SRDetailsBrc - Access Branch details                         *
      *  SRDetailsCcy - Access Currency details                       *
      *  SRZEdit2 - Format amount                                     *
      *  SRZDate2 - Convert a day number to date format               *
      *  SRBreakCcy - Currency break in report                        *
      *  SRBreakBrc - Branch break in report                          *
      *  SREndBrc - Write branch trailer in report                    *
      *  SREnd   - Write trailer in report                            *
      *  SRAudit - Write audit report                                 *
      *  SROverflow - Write header if overflow                        *
      *  *INZSR  - Initialise                                         *
      *  *PSSR   - Error processing                                   *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      ** Amount Amortisation
     FGLAMRTL2  IF   E           K DISK    INFSR(*PSSR)
      ** Amount Amortisation Trailer file
     FGLAMRZPD  IF   E             DISK    INFSR(*PSSR)
      ** Amount Amortisation Printer file - Details
     FGL001995P1O    E             PRINTER INFDS(SPOOL1)
     F                                     USROPN
     F                                     INFSR(*PSSR)
      ** Amount Amortisation Printer file - Audit
     FGL001995AUO    E             PRINTER INFDS(SPOOLU)
     F                                     INFSR(*PSSR)
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+
      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA)
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc
      ** External DS for Bank Details
     D SDBANK        E DS                  Extname(SDBANKPD)
      ** External DS for Branch Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** External data structure for Module Details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** External DS for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      **  Short DS for access programs
     D DSFDY         E DS                  Extname(DSFDY)
      **  Long DS for access programs
     D DSSDY         E DS                  Extname(DSSDY)
      ** File Information Data Structure for GL001995P1.
     D SPOOL1          DS
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0
      ** File Information Data Structure for GL001995AU.
     D SPOOLU          DS
     D   SFILEU               83     92
     D   SFNUMU              123    124B 0
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+
      ** Parameters for ZDATE2
     D PDaynoIn        S              5P 0
     D PDateOut        S              6P 0
     D PADateOut       S              7
      ** Parameters for ZEDIT2
     D PZField         S             16
     D PZDec           S              2  0
      ** Parameters for ZSFILE
     D PSeq            S              5
     D SEnty           S              3
     D ZSnum           S              6  0
     D ZSnumU          S              6  0
     D ZSerr           S              1
      ** Parameters for access object programs
     D PRetCode        S              7
     D POption         S              7
     D PBranch         S              3
     D PCcy            S              3
     D PSard           S              6
      ** Parameter list fields
     D PMode           S              1
     D PLevl           S              1
     D PEnty           S              3
      ** Other fields used
     D WRun            S              1
     D WOpen           S              1    INZ('N')
     D WFirst          S              1    INZ('Y')
     D WFName          S             10
     D WPrtRec         S              1
     D WNoRec          S              5  0 INZ(0)
     D RqdLn1          S              3  0
     D DifLn1          S              4  0
     D WSvBrca         S                   LIKE(A1BRCA)
     D WSvBrnm         S                   LIKE(A8BRNM)
     D WSvCcy          S                   LIKE(A1CCY)
     D WSvAatd         S                   LIKE(A1AATD)
     D WSvUnam         S                   LIKE(A1UNAM)
     D WTotA           S                   LIKE(A1AATD)
     D WTotU           S                   LIKE(A1UNAM)
     D WWTotA          S                   LIKE(A1AATD)
     D WWTotU          S                   LIKE(A1UNAM)
     D WEFYL           S                   LIKE(A1EFYL)
     D WUNAM           S                   LIKE(A1UNAM)
     D WAATD           S                   LIKE(A1AATD)
     D WFIELD          S             15
     D WZField         S             16
     D WWField         S             17
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Set file pointer to first record and do initial read.
 
     C                   IF        PEnty  = *BLANKS
     C                             OR PEnty  = 'ALL'
     C                             OR PMode = 'A'
     C     *LOVAL        SETLL     GLAMRTL2
     C                   ELSE
     C     PEnty         SETLL     GLAMRTL2
     C                   ENDIF
 
     C                   READ      GLAMRTL2
 
      ** Read until a record is not found
 
     C                   DOW       NOT %EOF(GLAMRTL2)
 
      ** Check if Audit list or full list.
 
     C                   IF        PEnty = *BLANKS OR
     C                             PEnty = 'ALL' OR
     C                             A1BRCA = PEnty
     C                   EVAL      WPrtRec = 'Y'
 
      ** Count no. of records processed.
 
     C                   IF        A1RECI <> '*'
     C                             AND A1RECI <> 'C'
     C                   EVAL      WNoRec = WNoRec + 1
     C                   ENDIF
 
     C                   IF        PMode = 'A' AND
     C                             A1LCD <> BJRDNB
     C                             OR A1RECI = 'C'
     C                             AND PMode <> 'A'
     C                             OR A1RECI = '*'
     C                             AND PMode <> 'A'
     C                   EVAL      WPrtRec = 'N'
     C                   ENDIF
 
      ** Process Report Lines.
 
     C                   IF        WPrtRec = 'Y'
 
      ** For initial print of details, write header
 
     C                   IF        WFirst = 'N'
     C                   EXSR      SRTotal
     C                   ELSE
 
      ** Open prtf if the prtf is not open
 
     C                   EXSR      SROpenPrtf
      ** Branch details
 
     C                   EVAL      PBranch = A1BRCA
     C                   EXSR      SRDetailsBrc
     C                   EVAL      RBRCA1 = A1BRCA
     C                   EVAL      RBRNM1 = A8BRNM
 
     C                   WRITE     HEADP1
     C                   MOVE      '1'           *IN01
     C                   EVAL      WFirst = 'N'
     C                   ENDIF
 
     C                   EXSR      SRPrint
     C                   MOVE      '0'           *IN01
 
     C                   ENDIF
     C                   ENDIF
 
      ** Read next record.
 
     C                   READ      GLAMRTL2
     C                   ENDDO
 
     C                   IF        WFirst = 'N'
     C                   EXSR      SRBreakCcy
     C                   EXSR      SRBreakBrc
     C                   ENDIF
 
      ** If there are no records in the input file,
      ** no totals will be printed
 
     C                   EXSR      SREnd
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTotal - Perform total time operations                      *
      *                                                               *
      *****************************************************************
     C     SRTotal       BEGSR
 
     C                   IF        A1BRCA = WSvBrca AND
     C                             A1CCY = WSvCcy
     C                   ADD       WSvAatd       WTotA
     C                   ADD       WSvUnam       WTotU
     C                   ELSE
     C                   EXSR      SRBreakCcy
     C                   ENDIF
 
     C                   IF        A1BRCA = WSvBrca
     C                   ELSE
     C                   EXSR      SRBreakBrc
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SROpenPrtf - Open prtf if the prtf is not open               *
      *                                                               *
      *****************************************************************
     C     SROpenPrtf    BEGSR
 
      ** If the prtf is not open
 
     C                   OPEN      GL001995P1
 
      ** Ensure Detail Spool File recorded by RCF.
 
     C                   EVAL      ZSnum = SFNUM1
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *BLANK        SEnty
     C                   PARM                    SFILE1
     C                   PARM                    ZSnum
     C                   PARM      *BLANK        ZSerr
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
 
     C     ZSerr         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrnt - Print details                                       *
      *                                                               *
      *****************************************************************
     C     SRPrint       BEGSR
 
      ** Move file field values to prtf
 
     C                   EXSR      SRFiletoPrtf
 
      ** Write Detail
 
     C                   SELECT
 
      ** When there is no Currency break
 
     C                   WHEN      A1CCY = WSvCcy
     C                   EVAL      RqdLn1 = 7
      ** When there is a Currency break
 
     C                   OTHER
     C                   EVAL      RqdLn1 = 9
     C                   ENDSL
 
     C                   EXSR      SROverflow
     C                   WRITE     DETAIL1
 
      ** Initialise Work Fields
 
     C                   EVAL      WSvBrca = A1BRCA
     C                   EVAL      WSvBrnm = A8BRNM
     C                   EVAL      WSvCcy = A1CCY
 
     C                   EVAL      WSvAatd = A1AATD
     C                   EVAL      WSvUnam = A1UNAM
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFiletoPrtf - Format and move file field values to prtf     *
      *                                                               *
      *****************************************************************
     C     SRFiletoPrtf  BEGSR
 
      ** Currency details
 
     C                   EVAL      RCCY = A1CCY
 
     C                   EVAL      PCcy = A1CCY
     C                   EXSR      SRDetailsCcy
     C                   EVAL      RCYNM = A6CYNM
 
      ** Transaction Reference No.
 
     C                   MOVE      A1AREF        RAREF
 
      ** Posting Narrative
 
     C                   EVAL      RNARR = A1NARR
 
      ** Start Date
 
     C                   EVAL      PDaynoIn = A1STDT
     C                   EXSR      SRZDate2
     C                   EVAL      RSTDT = PADateOut
 
      ** Maturity Date
 
     C                   EVAL      PDaynoIn = A1MDAT
     C                   EXSR      SRZDate2
     C                   EVAL      RMDAT = PADateOut
 
      ** Calculation Basis
 
     C                   EVAL      RCLBS = A1CLBS
 
      ** Effective Yield
 
     C                   MOVE      *BLANKS       PZField
     C                   EVAL      WEFYL = A1EFYL
     C                   IF        A1EFYL < 0
     C                   EVAL      WEFYL = A1EFYL * -1
     C                   ENDIF
     C                   MOVE      WEFYL         PZField
     C                   Z-ADD     12            PZDec
     C                   EXSR      SRZEdit2
 
     C                   IF        A1EFYL < 0
     C                   MOVEL     PZField       WFIELD
     C     WFIELD        CAT       '-'           REFYL
     C                   ELSE
     C                   MOVE      PZField       REFYL
     C                   ENDIF
 
      ** Amortisation Method
 
     C                   EVAL      RAMMD = A1AMMD
 
      ** Debit and Credit account details
 
     C                   MOVE      A1DRCN        RDRCN
     C                   MOVE      A1DRCO        RDRCO
     C                   MOVE      A1DRSQ        RDRSQ
 
     C                   MOVE      A1CRCN        RCRCN
     C                   MOVE      A1CRCO        RCRCO
     C                   MOVE      A1CRSQ        RCRSQ
 
      ** Discount Amount
 
     C                   MOVE      *BLANK        PZField
     C                   MOVE      A1DSAM        PZField
     C                   Z-ADD     A6NBDP        PZDec
     C                   EXSR      SRZEdit2
     C                   MOVE      PZField       RDSAM
 
      ** Par Amount
 
     C                   MOVE      *BLANK        PZField
     C                   MOVE      A1PRAM        PZField
     C                   EXSR      SRZEdit2
     C                   MOVE      PZField       RPRAM
 
      ** Amount Amortised Posted to Date
 
     C                   MOVE      *BLANK        PZField
     C                   EVAL      WAATD = A1AATD
     C                   IF        A1AATD < 0
     C                   EVAL      WAATD = A1AATD * -1
     C                   ENDIF
     C                   MOVE      WAATD         PZField
     C                   EXSR      SRZEdit2
     C                   IF        A1AATD < 0
     C                   MOVEL     PZField       WZFIELD
     C     WZFIELD       CAT       '-'           WWFIELD
     C                   MOVE      WWFIELD       RAATD
     C                   ELSE
     C                   MOVE      PZField       RAATD
     C                   ENDIF
 
      ** Amount Unamortised Posted to Date
 
     C                   MOVE      *BLANK        PZField
     C                   EVAL      WUNAM = A1UNAM
     C                   IF        A1UNAM < 0
     C                   EVAL      WUNAM = A1UNAM * -1
     C                   ENDIF
     C                   MOVE      WUNAM         PZField
     C                   EXSR      SRZEdit2
     C                   IF        A1UNAM < 0
     C                   MOVEL     PZField       WZFIELD
     C     WZFIELD       CAT       '-'           WWFIELD
     C                   MOVE      WWFIELD       RUNAM
     C                   ELSE
     C                   MOVE      PZField       RUNAM
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDetailsBrc - Access Branch details                         *
      *                                                               *
      *****************************************************************
     C     SRDetailsBrc  BEGSR
 
     C                   CALL      'AOBRCHR0'
     C                   PARM      *BLANK        PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PBranch
     C     SDBRCH        PARM      SDBRCH        DSSDY
 
      ** Database error processing
 
     C                   IF        PRetCode <> *BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDBRCHPD'
     C                   EVAL      DBKey = PBranch
     C                   EVAL      DBPgm = 'GL1995'
     C                   EVAL      DBase = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDetailsCcy - Access Currency details                       *
      *                                                               *
      *****************************************************************
     C     SRDetailsCcy  BEGSR
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANK        PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PCcy
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** Database error processing
 
     C                   IF        PRetCode <> *BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDCURRPD'
     C                   EVAL      DBKey = PCcy
     C                   EVAL      DBPgm = 'GL1995'
     C                   EVAL      DBase = 003
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZEdit2 - Format amount                                     *
      *                                                               *
      *****************************************************************
     C     SRZEdit2      BEGSR
 
     C                   CALLB     'ZEDIT2'
     C                   PARM                    PZField
     C                   PARM                    PZDec
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZDate2 - Convert a day number to date format               *
      *                                                               *
      *****************************************************************
     C     SRZDate2      BEGSR
 
     C                   CALL      'ZDATE2'
     C                   PARM                    PDaynoIn
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         PDateOut
     C                   PARM                    PADateOut
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBreakCcy - Currency break in report                        *
      *                                                               *
      *****************************************************************
     C     SRBreakCcy    BEGSR
 
     C                   ADD       WSvAatd       WTotA
     C                   ADD       WSvUnam       WTotU
 
      ** Format and move file field values to prtf
 
     C                   MOVE      *BLANK        PZField
     C                   EVAL      WWTotA = WTotA
     C                   IF        WTotA < 0
     C                   EVAL      WWTotA = WTotA * -1
     C                   ENDIF
     C                   MOVE      WWTotA        PZField
     C                   Z-ADD     A6NBDP        PZDec
     C                   EXSR      SRZEdit2
     C                   IF        WTotA < 0
     C                   MOVEL     PZField       WZFIELD
     C     WZFIELD       CAT       '-'           WWFIELD
     C                   MOVE      WWFIELD       RTOTA
     C                   ELSE
     C                   MOVE      PZField       RTOTA
     C                   ENDIF
 
     C                   MOVE      *BLANK        PZField
     C                   EVAL      WWTotU = WTotU
     C                   IF        WTotU < 0
     C                   EVAL      WWTotU = WTotU * -1
     C                   ENDIF
     C                   MOVE      WWTotU        PZField
     C                   Z-ADD     A6NBDP        PZDec
     C                   EXSR      SRZEdit2
     C                   IF        WTotU < 0
     C                   MOVEL     PZField       WZFIELD
     C     WZFIELD       CAT       '-'           WWFIELD
     C                   MOVE      WWFIELD       RTOTU
     C                   ELSE
     C                   MOVE      PZField       RTOTU
     C                   ENDIF
 
      ** Write Totals
 
     C                   EVAL      RqdLn1 = 3
     C                   EXSR      SROverflow
     C                   WRITE     ENDER1
 
      ** Initialise Totals
 
     C                   Z-ADD     *ZERO         WTotA
     C                   Z-ADD     *ZERO         WTotU
     C                   MOVE      '1'           *IN01
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBreakBrc - Branch break in report                          *
      *                                                               *
      *****************************************************************
     C     SRBreakBrc    BEGSR
 
     C                   EXSR      SREndBrc
     C                   IF        NOT %EOF(GLAMRTL2)
     C                   CLOSE     GL001995P1
 
      ** Open prtf if the prtf is not open
 
     C                   EXSR      SROpenPrtf
 
      ** Move file field values to prtf
 
 
      ** Branch details
 
     C                   EVAL      PBranch = A1BRCA
     C                   EXSR      SRDetailsBrc
     C                   EVAL      RBRCA1 = A1BRCA
     C                   EVAL      RBRNM1 = A8BRNM
 
     C                   WRITE     HEADP1
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREndBrc - Write branch trailer in report                    *
      *                                                               *
      *****************************************************************
     C     SREndBrc      BEGSR
 
      ** Move file field values to prtf
 
     C                   EVAL      RBRCA2 = WSvBrca
 
      ** Write out report trailer.
 
     C                   EVAL      RqdLn1 = 3
     C                   EXSR      SROverflow
     C                   WRITE     TRAILP1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREnd - Write trailer in report                              *
      *                                                               *
      *****************************************************************
     C     SREnd         BEGSR
 
      ** Set file pointer to first record and do initial read.
 
     C     1             SETLL     GLAMRZPD
 
      ** Retrieve trailer details.
 
     C                   READ      GLAMRZPD
 
      ** Database error processing
 
     C                   IF        %EOF(GLAMRZPD)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'GLAMRZPD'
     C                   EVAL      DBKey = '*FIRST'
     C                   EVAL      DBPgm = 'GL001995'
     C                   EVAL      DBase = 004
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      RINSER = INNO
     C                   EVAL      RAMEND = AMDN
     C                   EVAL      RDELET = DELN
     C                   EVAL      RAUDIT = NORE
     C                   EVAL      RCOUNT = WNoRec
 
     C                   IF        PMode = 'A'
     C                   IF        RCOUNT <> RAUDIT
     C                   EVAL      *IN21 = *On
     C                   ELSE
     C                   EVAL      *IN21 = *Off
     C                   ENDIF
 
     C                   ENDIF
 
      ** Write audit report.
 
     C                   EXSR      SRAudit
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Write audit report                                 *
      *                                                               *
      *****************************************************************
     C     SRAudit       BEGSR
 
      ** Ensure Audit Spool File recorded by RCF.
 
     C                   EVAL      ZSnumU = SFNUMU
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *BLANK        SEnty
     C                   PARM                    SFILEU
     C                   PARM                    ZSnumU
     C                   PARM      *BLANK        ZSerr
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
 
     C     ZSERR         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
 
     C                   WRITE     HEADAU
 
      ** If there is a DB Error, Output the DB Error Information.
 
     C                   IF        *INU7 = *ON
     C                   WRITE     DBERROR
     C                   ELSE
 
      ** If there is a record read, write audit control report.
 
     C                   IF        WNoRec <> 0
     C                   WRITE     CONTROL
     C                   ELSE
 
      ** Or, if no records read, Output "No Details" message.
 
     C                   WRITE     NODTLS
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      *INLR ='1'
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SROverflow - Write header if overflow                        *
      *                                                               *
      *****************************************************************
     C     SROverflow    BEGSR
 
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
      ** If overflow has occured, write header
 
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *  Called by:      Implicitly on program activation             *
      *                                                               *
      *  Calls:          None                                         *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PMode
     C                   PARM                    PSeq
     C                   PARM                    PLevl
     C                   PARM                    PEnty
 
     C     *DTAARA       DEFINE                  LDA
 
      ** Access Bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANK        PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error processing
 
     C                   IF        PRetCode <> *BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBKey = POption
     C                   EVAL      DBPgm = 'GL001995'
     C                   EVAL      DBase = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access the Midas Modules
 
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDMMOD        PARM      SDMMOD        DSFDY
 
     C                   IF        PRetCode <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDMMODPD'
     C                   EVAL      DBKEY  =  '*FIRST'
     C                   EVAL      DBASE  =  004
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check System if Multi-Branch environment
 
     C                   IF        BGMBIN = 'Y'
     C                   SETON                                        37
     C                   ENDIF
                                                                                            BUG13042
      ** Set *IN35 *ON (AUDIT LIST)  *OFF (FULL LIST)                                       BUG13042
                                                                                            BUG13042
     C                   IF        (PMode = 'A')                                            BUG13042
     C                   EVAL      *IN35 = *ON                                              BUG13042
     C                   ELSE                                                               BUG13042
     C                   EVAL      *IN35 = *OFF                                             BUG13042
     C                   ENDIF                                                              BUG13042
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *  Called by:      (**calling routines**)                       *
      *                                                               *
      *  Calls:          None                                         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        WRun = *BLANK
     C                   MOVEL     'Y'           WRun
     C                   DUMP
     C                   ENDIF
 
      ** Write audit report.
 
     C                   EXSR      SRAudit
 
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   RETURN
 
     C                   ENDSR
