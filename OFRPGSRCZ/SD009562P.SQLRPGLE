     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas OF Nostro Group Transaction Limit List/Audit')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009562P - Midas OF Nostro Group Transaction Limit Audit    *
      *              and List report                                  *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD026972A          Date 19May14               *
      *                 MD026972           Date 16May14               *
      *                 CGL155   *Create   Date 06Mar14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  MD026972A - Retrieve correct run date                        *
      *  MD026972 - Audit report produced did not contain details     *
      *             of inserted, amended and deleted transactions     *
      *  CGL155 - Forecast Group Limits                               *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Midas OF Nostro Group Transaction Limit Audit/List report - Detail
     FSD009562P1O    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOL1)

      ** Midas OF Nostro Group Transaction Limit Audit/List report - Audit
     FSD009562AUO    E             PRINTER INFDS(SPOOLU)
     F                                     INFSR(*PSSR)

      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+

      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS

      ** External DS for Bank Details
     D*SDBANK***     E DS                  EXTNAME(SDBANKPD)                                MD026972
     D*SDBANK***     E DS                  EXTNAME(SDSBNKTD)                      MD026972 MD026972A
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                               MD026972A
                                                                                           MD026972A
      ** External DS for Bank Details - Secondary COB                                      MD026972A
     D SDSBNK        E DS                  EXTNAME(SDSBNKTD)                               MD026972A
     D                                     PREFIX(S)                                       MD026972A
                                                                                           MD026972A
     D MPHAS           DS             1                                                    MD026972A
     D Phase1                  1      1                                                    MD026972A

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

     **   Midas OF Nostro Group Limits - Detail
     D NGLD          E DS                  EXTNAME(SDNGLDTD)

     **   Midas OF Nostro Group Limits - Header
     D NGLH          E DS                  EXTNAME(SDNGLHTD)

      ** File Information Data Structure for SD009562P1
     D SPOOL1          DS
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0

      ** File Information Data Structure for GL000591AU.
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
     D WRecNo          S              7S 0 Inz
     D WRecGrp         S              7S 0 Inz
     D RqdLn1          S              3  0
     D DifLn1          S              4  0

      ** Parameter list fields for ZDATE2
     D PzDayNo         S              5  0
     D PBJDFIN         S              1
     D PzDate          S              6  0
     D PZADate         S              7

      ** Parameter list fields for AOCUSTR0
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
      **   the Nostro Group Limits

     C/exec SQL
     C+ declare LIST cursor for
     C+ select * from SDNGLHTD
     C+ order by
     C+     NGGRPC
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
     C+ into: NGLH
     C/end-exec

      ** Read Nostro Group Limits file until end of file

     C                   DOW       SQLCode <> 100

      ** Clear details

     C                   CLEAR                   DETAIL

     C                   IF        ((PMode = 'A') AND (NGLCD = BJRDNB))
     C                             OR ((PMode <> 'A') AND
     C                             (NGRECI = 'D'))

     C                   EVAL      WRecGrp = WRecGrp + 1

      ** Print Report Headers for every new page

     C                   IF        WRecGrp = 1
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
     C+ into: NGLH
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
     C+ select * from SDNGLDTD
     C+ where
     C+     NCGRPC = :NGGRPC
     C+ order by
     C+     NCGRPC
     C+    ,NCNCCY
     C+    ,NCNOSC
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
     C+ into :NGLD
     C/end-exec

      ** Read Nostro Group Limits details until end of file

     C                   EVAL      WDtlHdr = 'N'

     C                   DOW       SQLCode <> 100

     C                   EVAL      WRecNo = WRecNo + 1
      ** Nostro Code

     C                   EVAL      PRNOST = NCNCCY + NCNOSC

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
     C+ into: NGLD
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
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PAKEY1
     C                   PARM      *BLANKS       PAKYST
     C     SDCUST        PARM      *BLANKS       DSSDY
      *
     C     PRtCd         IFEQ      *BLANKS
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

     C                   MOVE      NCNCCY        PCCY
     C                   MOVE      NCNOSC        PNOST

     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      *BLANKS       PCUST
     C                   PARM                    PCCY
     C                   PARM      *BLANKS       PACCD
     C                   PARM      *BLANKS       PACSN
     C                   PARM                    PNOST
     C                   PARM      *BLANKS       PBRCA
     C                   PARM      *BLANKS       PCSSN
     C                   PARM      *BLANKS       PPNOI
     C     SDNOST        PARM      SDNOST        DSSDY

     C     PRtCd         IFEQ      *BLANKS
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

     C                   CALL      'AOACCTR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY    '    POptn
     C                   PARM      *BLANKS       PACNO
     C                   PARM                    PCUST
     C                   PARM                    PCCY
     C                   PARM                    PACCD
     C                   PARM                    PACSN
     C                   PARM                    PBRCA
     C     SDACCT        PARM      SDACCT        DSSDY

     C     PRtCd         IFEQ      *BLANKS
     C                   EVAL      PRACNM = A_ANAM
     C                   ELSE
     C                   EVAL      PRACNM = *Blanks
     C                   ENDIF

     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  CnvFcastDat - Convert Groupt Date to DDMMYY                  *
      *                                                               *
      *****************************************************************
     C     CnvFcastDat   BEGSR

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
      *  FormatAmount - Format Amount Routine                         *
      *                                                               *
      *****************************************************************
     C     FormatAmount  BEGSR

      ** If non-zero, format amount
     C                   IF        WAmount <> 0

     C                   CALL      'ZSEDIT'
     C                   PARM                    WAmount
     C                   PARM                    PDecPlace
     C                   PARM      'J'           PEdtCode
     C                   PARM                    WField

     C                   ELSE

      * If zero, check number of decimal places
     C                   IF        PDecPlace = 0
     C                   EVAL      WField = '                   0 '
     C                   ELSEIF    PDecPlace = 1
     C                   EVAL      WField = '                 0.0 '
     C                   ELSEIF    PDecPlace = 2
     C                   EVAL      WField = '                0.00 '
     C                   ELSEIF    PDecPlace = 3
     C                   EVAL      WField = '               0.000 '
     C                   ELSEIF    PDecPlace = 4
     C                   EVAL      WField = '              0.0000 '
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  GetCurrDtls - Get Currency Details                           *
      *                                                               *
      *****************************************************************
     C     GetCurrDtls   BEGSR

     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY    '    POptn
     C                   PARM                    PCCY
     C     SDCURR        PARM      SDCURR        DSSDY

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
     C                   EVAL      FTITLE = 'NOSTRO GROUP TRANSACTION LIMIT '
     C                                      + '- LIST MODE'
     C                   EVAL      FUNDRS = '-------------------------------'
     C                                      + '-----------'
     C                   EVAL      *IN01 = *OFF
     C                   ELSE
     C                   EVAL      FTITLE = 'NOSTRO GROUP TRANSACTION LIMIT '
     C                                      + '- AUDIT MODE'
     C                   EVAL      FUNDRS = '-------------------------------'
     C                                      + '------------'
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

      ** Nostro Group

     C                   EVAL      PRGRPC = NGGRPC

      ** Nostro Group Description

     C                   EVAL      PRGDES = NGGDES

      ** Daily Limit


     C                   MOVE      NGLCCY        PCCY
     C                   EXSR      GetCurrDtls

     C                   EVAL      WField = *BLANKS
     C                   EVAL      WAmount = *Zeros
     C                   EVAL      PDecPlace = *Zeros
     C                   EVAL      WAmount = NGDLIM
     C                   EVAL      PDecPlace = A6NBDP
     C                   EXSR      FormatAmount
     C                   MOVE      WField        PRDLIM

      ** Limit Currency

     C                   EVAL      PRLCCY = NGLCCY

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

     C                   EVAL      PUSER1 = NGUSER

     **  Date

     C                   EVAL      PZDayNo = NGLCD
     C                   EXSR      CnvFcastDat
     C                   MOVE      *Blanks       PDATE1
     C                   MOVE      PZADate       PDATE1

     **  Time

     C                   EVAL      PTIME1 = %subst(NGTMST:12:2)
     C                              + ':' + %subst(NGTMST:15:2)
     C                              + ':' + %subst(NGTMST:18:2)

     **  Last action type

     C                   SELECT
     C                   WHEN      NGCHTP = 'I'
     C                   EVAL      PACT1  = 'INSERT'
     C                   WHEN      NGCHTP = 'A'
     C                   EVAL      PACT1  = 'AMEND'
     C                   WHEN      NGCHTP = 'D'
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

     C                   IF        WRecNo > 0
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

      ** Total count for group limit

     C                   EVAL      TCOUNT = WRecGrp

      ** Individual count for group limit

     C                   EVAL      ICOUNT = WRecNo

      ** If there is a DB Error, Output the DB Error Information.

     C                   IF        *INU7 = *ON
     C                   WRITE     DBERROR
     C                   ELSE

      ** If there is a record read, write audit control report.

     C                   IF        WRecNo <> 0
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
                                                                                           MD026972A
     C     *Dtaara       Define                  MPhas                                     MD026972A
     C                   In        MPhas                                                   MD026972A

      ** Access Bank details
      **   Retrieve Run day number

     C**********         CALL      'AOBANKR0'                                               MD026972
     C**********         CALL      'AOSBNKR0'                                     MD026972 MD026972A
     C     Phase1        IFEQ      'A'                                                     MD026972A
     C                   CALL      'AOBANKR0'                                              MD026972A
     C                   PARM      *Blanks       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY

     C                   IF        PRtCd <> *Blanks
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
                                                                                           MD026972A
     C                   ELSE                                                              MD026972A
     C                   Call      'AOSBNKR0'                                              MD026972A
     C                   Parm      *Blanks       PRtCd                                     MD026972A
     C                   Parm      '*FIRST '     POptn                                     MD026972A
     C     SDSBNK        Parm      SDSBNK        DSFDY                                     MD026972A
                                                                                           MD026972A
     C                   If        PRtCd <> *Blanks                                        MD026972A
     C     *LOCK         In        LDA                                                     MD026972A
     C                   Eval      DBKey = POptn                                           MD026972A
     C                   Eval      DBFile = 'SDBANKPD'                                     MD026972A
     C                   Eval      DBase = 6                                               MD026972A
     C                   Out       LDA                                                     MD026972A
     C                   Exsr      *PSSR                                                   MD026972A
     C                   Else                                                              MD026972A
     C                   Eval      SDBANK = SDSBNK                                         MD026972A
     C                   Eval      RRPTDS = BJURPT                                         MD026972A
     C                   Eval      PBJDFIN = BJDFIN                                        MD026972A
     C                   Endif                                                             MD026972A
     C                   ENDIF                                                             MD026972A

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
