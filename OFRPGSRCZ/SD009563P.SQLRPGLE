     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas OF MNCP Pool Report')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009563P - Midas OF MNCP Pool Report                        *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CGL159   *Create   Date 02Sep14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL159 - Optimisation of Cash Positions                      *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Midas OF MNCP Pool Audit/List Report
     FSD009563P1O    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOL1)

      ** Midas OF MNCP Pool Report - Audit
     FSD009563AUO    E             PRINTER INFDS(SPOOLU)
     F                                     INFSR(*PSSR)

      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+

      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS

      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** External DS for Bank Details - Secondary COB
     D SDSBNK        E DS                  EXTNAME(SDSBNKTD)
     D                                     PREFIX(S)

     D MPHAS           DS             1
     D Phase1                  1      1

      ** External DS for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      ** External DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)

      ** External DS for Nostro Details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)


      ** External DS for Account Details
     D SDACCT        E DS                  EXTNAME(ACCNTAB)
     D                                     PREFIX(A_)

      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)

      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)

     ** File DS

     **   Midas OF MNCP Pools - Details
     D MNPD          E DS                  EXTNAME(SDMNPDTD)

     **   Midas OF MNCP Pools - Header
     D MNPH          E DS                  EXTNAME(SDMNPHTD)

      ** File Information Data Structure for SD009563P1
     D SPOOL1          DS
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0

      ** File Information Data Structure for SD009563AU.
     D SPOOLU          DS
     D   SFILEU               83     92
     D   SFNUMU              123    124B 0

     D/COPY ZACPYSRC,STD_D_SPEC

      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+

      ** Parameters for access object programs
     D PRtCd           S              7
     D POptn           S              7

      ** Parameters for ZSFILE
     D PSeq            S              5
     D PLevel          S              1
     D SEnty           S              3
     D ZSnum           S              6  0
     D ZSnumU          S              6  0
     D ZSerr           S              1

      ** Parameter list fields
     D PMode           S              1
     D PEnty           S              3

      ** Other fields used
     D WRun            S              1A   Inz
     D WRecNost        S              7S 0 Inz
     D WRecPool        S              7S 0 Inz
     D RqdLn1          S              3  0
     D DifLn1          S              4  0

      ** Parameter list fields for ZDATE2
     D PzDayNo         S              5  0
     D PBJDFIN         S              1
     D PzDate          S              6  0
     D PZADate         S              7

      ** Parameter list fields for SDCUSTPD
     D PAKEY1          S             10
     D PAKYST          S              7

      ** Other paramter
     DPCUST            S              6A
     DPCCY             S              3A
     DPNOST            S              2A
     DPACCD            S             10A
     DPACSN            S              2A
     DPBRCA            S              3A
     DPCSSN            S             10A
     DPPNOI            S              1A
     DPACNO            S             10A


     D WDtlHdr         S              1A
     D WField          S             21A
     D PEdtCode        S              1A
     D PDecPlace       S              1  0
     D WAmount         S             15  0


      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *InzSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

      ** Set file pointer to first record and do initial read for
      **   the MNCP Pools

     C/exec SQL
     C+ declare LIST cursor for
     C+ select * from SDMNPHTD
     C+ order by
     C+    P1POOL, P1DATE ASC
     C/end-exec

     C/exec SQL
     C+ open LIST
     C/end-exec

      ** Handle SQL Error (if not %EOF)

     C                   If        SQLCOD < 0

     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 2
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   EndIf

     C/exec SQL
     C+ fetch next
     C+ from LIST
     C+ into: MNPH
     C/end-exec

      ** Read MNCP Pools - Header until end of file

     C                   DOW       SQLCode <> 100

      ** Clear details

     C                   CLEAR                   DETAIL

     C                   IF        ((PMode = 'A') AND (P1DATE = BJRDNB))
     C                             OR ((PMode <> 'A') AND
     C                             (P1RECI = 'D'))

     C                   EVAL      WRecPool = WRecPool + 1

      ** Print Report Headers for every new page

     C                   IF        WRecPool = 1
     C                             OR (OFLLN1 - PRTLN1) <= 10
     C                   EXSR      SRPrintHdr1
     c                   ENDIF

     C                   EXSR      SRPrintHdr2

      ** Print details

     C                   EXSR      SRDetails

     C                   IF        PMODE = 'A'
     C                   EXSR      SRPrintHdr3
     C                   ENDIF

     C                   ENDIF


     C/exec SQL
     C+ fetch next from LIST
     C+ into: MNPH
     C/end-exec

     C                   ENDDO

      ** Handle SQL Error (if not %EOF)

     C                   If        SQLCode < 100

     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 3
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   EndIf

     C/exec SQL
     C+ close LIST
     C/end-exec

     C                   EXSR      SRPrintFtr

     C                   EVAL      *INLR = *ON

     C                   RETURN
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrDetails - Print Details                                    *
      *                                                               *
      *****************************************************************
     C     SrDetails     BEGSR

     C/exec SQL
     C+ declare LIST2 cursor for
     C+ select * from SDMNPDTD
     C+ where
     C+     P2POOL = :P1POOL
     C+ order by
     C+     P2NOST,
     C+     P2DATE,
     C+     P2TMST
     C/end-exec

     C/exec SQL
     C+ open LIST2
     C/end-exec

      ** Handle SQL Error (if not %EOF)

     C                   If        SQLCOD < 0

     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 4
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   EndIf

     C/exec SQL
     C+ fetch next
     C+ from LIST2
     C+ into :MNPD
     C/end-exec

      ** Read MNCP Pools - Details file until end of file

     C                   EVAL      WDtlHdr = 'N'

     C                   DOW       SQLCode <> 100

     C                   EVAL      WRecNost = WRecNost + 1
      ** Nostro

     C                   EVAL      PRNOST = P2NOST

      ** Account Name

     C                   EXSR      GetNostDtls

      ** Retrieve Report Name and Report Town from Customer details

     C                   EXSR      GetCustDtls

     C                   EVAL      RqdLn1 = 5
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1

     C                   IF        DifLn1 <= RqdLn1
     C                   EXSR      SRPrintHdr1
     C                   ENDIF

     C                   IF        WDtlHdr = 'N'
     C                   EXSR      SRPrintHdr4
     C                   ENDIF

      ** Print Details

     C                   WRITE     DETAIL
     C                   EVAL      WDtlHdr = 'Y'

     C/exec SQL
     C+ fetch next from LIST2
     C+ into: MNPD
     C/end-exec

     C                   ENDDO

      ** Handle SQL Error (if not %EOF)

     C                   If        SQLCode < 100

     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 5
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   EndIf

     C/exec SQL
     C+ close LIST2
     C/end-exec


     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  GetCustDtls - Get Customer Details (Report Name and Town)    *
      *                                                               *
      *****************************************************************
     C     GetCustDtls   BEGSR

     C                   EVAL      PAKEY1 = A7CUST

     C/exec SQL
     C+ select *
     C+ into :SDCUST
     C+ from SDCUSTPD
     C+ where BBCUST = :PAKEY1
     C/end-exec

     C     SQLCOD        IFEQ      *Zeros
     C                   EVAL      PRCRNM = BBCRNM
     C                   EVAL      PRCRTN = BBCRTN
     C                   ELSE
     C                   EVAL      PRCRNM = *Blanks
     C                   EVAL      PRCRTN = *Blanks
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  GetNostDtls - Get Nostro Details                             *
      *                                                               *
      *****************************************************************
     C     GetNostDtls   BEGSR

     C                   MOVEL     P2NOST        PCCY
     C                   MOVE      P2NOST        PNOST

     C/exec SQL
     C+ select *
     C+ into :SDNOST
     C+ from SDNOSTPD
     C+ where A7CYCD = :PCCY and A7NONB = :PNOST
     C/end-exec

     C     SQLCOD        IFEQ      *Zeros
     C                   MOVE      A7CUST        PCUST
     C                   MOVE      A7CYCD        PCCY
     C                   MOVE      A7ACCD        PACCD
     C                   MOVE      A7ACSN        PACSN
     C                   MOVE      A7BRCD        PBRCA
      ** Get Account Name
     C                   EXSR      GetAcctDtls
     C                   ELSE
     C                   EVAL      PRACNM = *Blanks
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  GetAcctDtls - Get Account Details (Account Name)             *
      *                                                               *
      *****************************************************************
     C     GetAcctDtls   BEGSR

     C/exec SQL
     C+ select *
     C+ into :SDACCT
     C+ from ACCNTAB
     C+ where CNUM =: PCUST and CCY =: PCCY and ACOD =:PACCD and
     C+               ACSQ =: PACSN and BRCA =: PBRCA
     C/end-exec

     C     SQLCOD        IFEQ      *Zeros
     C                   EVAL      PRACNM = A_ANAM
     C                   ELSE
     C                   EVAL      PRACNM = *Blanks
     C                   ENDIF

     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  CnvProcDate - Convert Processing Date to DDMMYY              *
      *                                                               *
      *****************************************************************
     C     CnvProcDate   BEGSR

      ** Call ZDATE2 to convert date from Midas Dayno. format to
      ** DDMMMYY format

     C                   CALL      'ZDATE2'
     C                   PARM                    PZDayNo
     C                   PARM                    PBJDFIN
     C                   PARM      *ZEROS        PZDate
     C                   PARM      *BLANKS       PZADate

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrintHdr1- Print Header 1 Routine                          *
      *                                                               *
      *****************************************************************
     C     SRPrintHdr1   BEGSR

      ** Set up Header 1 details

      ** Prepare the Header Title to be used (must be centered)

     C                   IF        PMode = 'L'
     C                   EVAL      FTITLE = 'MNCP POOLS - LIST MODE'
     C                   EVAL      FUNDRS = '----------------------'
     C                   EVAL      *IN01 = *OFF
     C                   ELSE
     C                   EVAL      FTITLE = 'MNCP POOLS - AUDIT MODE'
     C                   EVAL      FUNDRS = '-----------------------'
     C                   EVAL      *IN01 = *ON
     C                   ENDIF


     C                   WRITE     HEADER1

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrintHdr2- Print Header 2 Routine                          *
      *                                                               *
      *****************************************************************
     C     SRPrintHdr2   BEGSR

     C                   CLEAR                   HEADER2

      ** Pool

     C                   EVAL      PRPOOL = P1POOL

      ** Description

     C                   EVAL      PRPDES = P1PDSC

      ** Pivot Currency

     C                   EVAL      PRPCCY = P1PCCY

     C                   WRITE     HEADER2

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrintHdr3- Print Header 3 Routine                          *
      *                                                               *
      *****************************************************************
     C     SRPrintHdr3   BEGSR


     **  Last Change User

     C                   EVAL      PUSER1 = P1USER

     **  Processing Date

     C                   EVAL      PZDayNo = P1DATE
     C                   EXSR      CnvProcDate
     C                   MOVE      *Blanks       PDATE1
     C                   MOVE      PZADate       PDATE1

     **  Time

     C                   EVAL      PTIME1 = %subst(P1TMST:12:2)
     C                              + ':' + %subst(P1TMST:15:2)
     C                              + ':' + %subst(P1TMST:18:2)

     **  Last action type

     C                   SELECT
     C                   WHEN      P1ACTN = 'I'
     C                   EVAL      PACT1  = 'INSERT'
     C                   WHEN      P1ACTN = 'A'
     C                   EVAL      PACT1  = 'AMEND'
     C                   WHEN      P1ACTN = 'D'
     C                   EVAL      PACT1  = 'DELETE'
     C                   ENDSL

     C                   WRITE     HEADER3

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrintHdr4 - Print Header 4 Routine                         *
      *                                                               *
      *****************************************************************
     C     SRPrintHdr4   BEGSR

     C                   WRITE     HEADER4

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrintFtr - Print Footer Routine                            *
      *                                                               *
      *****************************************************************
     C     SRPrintFtr    BEGSR

     C                   IF        WRecNost > 0
     C                   WRITE     FOOTER
     C                   ENDIF

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
     C                   PARM      *Blanks       SEnty
     C                   PARM                    SFILEU
     C                   PARM                    ZSnumU
     C                   PARM      *Blank        ZSerr

      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.

     C                   IF        ZSERR = 'Y'
     C                   EVAL      *InU7 = *On
     C                   EVAL      *InU8 = *On
     C                   EVAL      *InLR = *On
     C                   RETURN
     C                   ENDIF

     C                   WRITE     HEADAU

      ** Total Count for Pools

     C                   EVAL      TCOUNT = WRecPool

      ** If there is a DB Error, Output the DB Error Information.

     C                   IF        *INU7 = *ON
     C                   WRITE     DBERROR
     C                   ELSE

      ** If there is a record read, write audit control report.

     C                   IF        WRecNost <> 0
     C                   WRITE     CONTROL
     C                   ELSE

      ** Or, if no records read, Output "No Details" message.

     C                   WRITE     NODTLS
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *InzSr - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    ReturnCode
     C                   PARM                    PMode
     C                   PARM                    PSeq
     C                   PARM                    PLevel
     C                   PARM                    PEnty

      ** Set off program indicators

     C                   EVAL      *INU7 = *OFF
     C                   EVAL      *INU8 = *OFF

     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA

     C     *Dtaara       Define                  MPhas
     C                   In        MPhas

      ** Access Bank details
      **   Retrieve Run day number

     C     Phase1        IFEQ      'A'
     C/exec SQL
     C+ select *
     C+ into :SDBANK
     C+ from SDBANKPD
     C/end-exec

     C     SQLCOD        IFNE      *Zeros
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      RRPTDS = BJURPT
     C                   EVAL      PBJDFIN = BJDFIN
     C                   ENDIF

     C                   ELSE
     C/exec SQL
     C+ select *
     C+ into :SDSBNK
     C+ from SDSBNKTD
     C/end-exec

     C     SQLCOD        IFNE      *Zeros
     C     *LOCK         In        LDA
     C                   Eval      DBKey = POptn
     C                   Eval      DBFile = 'SDSBNKTD'
     C                   Eval      DBase = 6
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   Else
     C                   Eval      SDBANK = SDSBNK
     C                   Eval      RRPTDS = BJURPT
     C                   Eval      PBJDFIN = BJDFIN
     C                   Endif
     C                   ENDIF

      ** Ensure Detail Spool File recorded by RCF.

     C                   EVAL      ZSnum = SFNUM1

     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *Blanks       SEnty
     C                   PARM                    SFILE1
     C                   PARM                    ZSnum
     C                   PARM      *Blanks       ZSerr

     C                   IF        ZSErr = 'Y'
     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
     C                   RETURN
     C                   ENDIF

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
      *  Called by:                                                   *
      *                                                               *
      *  Calls:          None                                         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   IF        WRun = *Blanks
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
     C                   EVAL      ReturnCode = '*ERROR'

     C                   EXSR      SRAUDIT

     C                   RETURN

     C                   ENDSR
      /EJECT
      *****************************************************************
