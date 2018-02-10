     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas OF Accounting Rules List/Audit Report')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL000581P - Midas GL Accounting Rules List/Audit Report      *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD024513           Date 23Jan14               *
      *                 CGL135A  *CREATE   Date 10Jul13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD024513 - Add Description field (30A) to the Accounting     *
      *             Rules.                                            *
      *  CGL135A - Accounting Rules Process                           *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Midas GL Accounting Rules Audit/List report - Detail
     FGL000581P1O    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOL1)

      ** Midas GL Accounting Rules List report - Audit list
     FGL000581AUO    E             PRINTER INFDS(SPOOLU)
     F                                     INFSR(*PSSR)

      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+

      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS

      ** External DS for Bank Details
     D SDBANK        E DS                  Extname(SDBANKPD)

      ** External DS for SAR Details
     D SCSARD        E DS                  Extname(SCSARDPD)

      **  Short DS for access programs
     D DSFDY         E DS                  Extname(DSFDY)

      **  Long DS for access programs
     D DSSDY         E DS                  Extname(DSSDY)

     ** File DS
     **   Midas GL Accounting Rules
     D ACRUD         E DS                  EXTNAME(GLACRUTD)


      ** File Information Data Structure for SD000764P1.
     D SPOOL1          DS
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0

      ** File Information Data Structure for SD000764AU.
     D SPOOLU          DS
     D   SFILEU               83     92
     D   SFNUMU              123    124B 0

      ** Parameter data
     D PData           DS
     D  Data                   1    100A

     D/COPY ZACPYSRC,STD_D_SPEC

      ** Time data
     D PTimestamp      DS            26
     D  Hour1                 12     13
     D  Min1                  15     16
     D  Sec1                  18     19

     D PTime           DS
     D  Hour2                  1      2
     D  Colon1                 3      3    INZ(':')
     D  Min2                   4      5
     D  Colon2                 6      6    INZ(':')
     D  Sec2                   7      8

      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+

      ** Parameters for access object programs
     D PRtCd           S              7
     D POptn           S              7
     D PSARD           S              6

      ** Parameters for ZSFILE
     D PSeq            S              5
     D PLevel          S              1
     D SEnty           S              3
     D ZSnum           S              6  0
     D ZSnumU          S              6  0
     D ZSerr           S              1

      ** Parameter for ZDATE2
     D ZDAYNO          S              5  0
     D ZDATE           S              6  0
     D ZADATE          S              7A

      ** Parameter list fields
     D PMode           S              1
     D PLevl           S              1
     D PEnty           S              3

      ** Other fields used
     D WRun            S              1A   Inz
     D WRecNo          S              7S 0 Inz
     D RqdLn1          S              3  0
     D DifLn1          S              4  0
     D CGL145          S              1A

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

      ** Set file pointer to first record and do initial read.

     C/exec SQL
     C+ declare LIST cursor for
     C+ select * from GLACRUTD
     C+ order by
     C+       ARMATF1, ARMATF2,
     C+       ARMATF3, ARMATF4,
     C+       ARMATF5, ARMATF6,
     C+       ARMATF7, ARMATF8,
     C+       ARMATF9, ARMATF10
     C/end-exec

     C/exec SQL
     C+ open LIST
     C/end-exec

      ** Handle SQL Error (if not %EOF)

     C                   If        SQLCOD < 0

     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 3
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   EndIf


     C/exec SQL
     C+ fetch next
     C+ from LIST
     C+ into: ACRUD
     C/end-exec

      ** Read SD Non-A/c Holders File until end of file

     C                   DOW       SQLCode <> 100

     C                   IF        (PMode = 'A' AND ARLCD = BJRDNB)
     C                             OR (PMode <> 'A' AND
     C                             ARRECI = 'D' AND ARCHTP <> 'D')

      ** Print Report Header 1

     C                   EXSR      SRPrintHdr1

      ** Print Report Header 2

     C                   EXSR      SRPrintHdr2

      ** Print Report Header List/Audit

     C                   IF        PMode = 'A'
     C                   EXSR      SRPrintHdr4
     C                   ELSE
     C                   EXSR      SRPrintHdr3
     C                   ENDIF

      ** Print Details

     C                   EXSR      SRPrintDtl

     C                   EVAL      WRecNo = WRecNo + 1

     C                   ENDIF

     C/exec SQL
     C+ fetch next from LIST
     C+ into :ACRUD
     C/end-exec

     C                   ENDDO

      ** Handle SQL Error (if not %EOF)

     C                   If        SQLCode < 100

     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 4
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
      *  SRPrintHdr1- Print Header 1 Routine                          *
      *                                                               *
      *****************************************************************
     C     SRPrintHdr1   BEGSR

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

      ** Set up Header 2 details

     C                   CLEAR                   HEADER2

      ** Prepare the Header Title to be used

     C                   IF        PMode = 'L'
     C                   EVAL      *IN50 = *ON
     C                   ELSE
     C                   EVAL      *IN50 = *OFF
     C                   ENDIF

      ** Trans. Type
     C                   EVAL      PARMAT1 = ARMATF1

      ** Sub Type
     C                   EVAL      PARMAT2 = ARMATF2

      ** Payment Type
     C                   EVAL      PARMAT3 = ARMATF3

      ** MatchField4
     C                   EVAL      PARMAT4 = ARMATF4

      ** MatchField5
     C                   EVAL      PARMAT5 = ARMATF5

      ** MatchField6
     C                   EVAL      PARMAT6 = ARMATF6

      ** MatchField7
     C                   EVAL      PARMAT7 = ARMATF7

      ** MatchField8
     C                   EVAL      PARMAT8 = ARMATF8

      ** MatchField9
     C                   EVAL      PARMAT9 = ARMATF9

      ** MatchField10
     C                   EVAL      PARMAT10 = ARMATF10

      ** DR/CR
     C                   EVAL      PADRCR = ARDCIP

      ** Unique ID Indicator                                                                MD024513
     C                   EVAL      PARUNID = ARUNID                                         MD024513
                                                                                            MD024513
      ** Description                                                                        MD024513
     C                   EVAL      PARDESC = ARDESC                                         MD024513
                                                                                            MD024513
     C                   WRITE     HEADER2

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrintHdr3 - Print Header 4 Routine                         *
      *                                                               *
      *****************************************************************
     C     SRPrintHdr3   BEGSR

      ** Compare vs Forecast

     C                   CLEAR                   HEADER3

     C                   IF        CGL145 = 'Y'
     C                   EVAL      *IN70 = *ON
     C                   EVAL      PRCMVF1 = ARCMVFC
     C                   ENDIF

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

     C                   CLEAR                   HEADER4

      ** Compare vs Forecast
     C                   IF        CGL145 = 'Y'
     C                   EVAL      *IN70 = *ON
     C                   EVAL      PRCMVF1 = ARCMVFC
     C                   ENDIF

     **  Last Change User
     C                   IF        ARAUSR = *BLANKS
     C                   EVAL      PUSER1 = ARIUSR
     C                   ELSE
     C                   EVAL      PUSER1 = ARAUSR
     C                   ENDIF

     **  Date
     C                   EVAL      ZDAYNO = ARLCD

     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         ZDATE
     C                   PARM      *BLANK        ZADATE
      *
     C                   MOVEL     ZADATE        PDATE1

     **  Time
     C                   MOVEL     ARTMST        PTimestamp
     C                   EVAL      Hour2 = Hour1
     C                   EVAL      Min2  = Min1
     C                   EVAL      Sec2  = Sec1
     C                   EVAL      PTIME1 = Ptime

     **  Last action type
     C                   SELECT
     C                   WHEN      ARSTAT = 'I'
     C                   EVAL      PACT1  = 'INSERT'
     C                   WHEN      ARSTAT = 'A'
     C                   EVAL      PACT1  = 'AMEND'
     C                   WHEN      ARSTAT = 'D'
     C                   EVAL      PACT1  = 'DELETE'
     C                   WHEN      ARSTAT = 'X'
     C                   EVAL      PACT1  = 'AUTHORIZE'
     C                   ENDSL

     C                   WRITE     HEADER4

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrintDtl - Print Detail Routine                            *
      *                                                               *
      *****************************************************************
     C     SRPrintDtl    BEGSR

      ** Set up Details

     C                   CLEAR                   DETAIL

      ** Debit Details

      **   Transaction Type
     C                   IF        ARTTDR <> *ZEROS
     C                   MOVEL     ARTTDR        PDBTRA1
     C                   ENDIF

      **   Branch
     C                   EVAL      PDBBRA1 = ARBCDR1
     C                   EVAL      PDBBRA2 = ARBCDR2
     C                   EVAL      PDBBRA3 = ARBCDR3

      **   Customer
     C                   EVAL      PDBCUS1 = ARCNDR1
     C                   EVAL      PDBCUS2 = ARCNDR2
     C                   EVAL      PDBCUS3 = ARCNDR3

      **   Account Code
     C                   IF        ARACDR1 <> *ZEROS
     C                   MOVEL     ARACDR1       PDBCOD1
     C                   ENDIF
     C                   IF        ARACDR2 <> *ZEROS
     C                   MOVEL     ARACDR2       PDBCOD2
     C                   ENDIF
     C                   IF        ARACDR2 <> *ZEROS
     C                   MOVEL     ARACDR3       PDBCOD3
     C                   ENDIF

      **   Account Seq
     C                   IF        ARASDR1 <> *ZEROS
     C                   MOVEL     ARASDR1       PDBSEQ1
     C                   ENDIF
     C                   IF        ARASDR2 <> *ZEROS
     C                   MOVEL     ARASDR2       PDBSEQ2
     C                   ENDIF
     C                   IF        ARASDR3 <> *ZEROS
     C                   MOVEL     ARASDR3       PDBSEQ3
     C                   ENDIF

      **   Narrative Code
     C                   EVAL      PDBNCO1 = ARNADR1
     C                   EVAL      PDBNCO2 = ARNADR2
     C                   EVAL      PDBNCO3 = ARNADR3

      **   Received Narrative
     C                   EVAL      PDBNAR1 = ARRNDR1
     C                   EVAL      PDBNAR2 = ARRNDR2
     C                   EVAL      PDBNAR3 = ARRNDR3

      **   Posting Ref
     C                   EVAL      PDBPOS1 = ARPRFDR1
     C                   EVAL      PDBPOS2 = ARPRFDR2
     C                   EVAL      PDBPOS3 = ARPRFDR3


      ** Credit Details

      **   Transaction Type
     C                   IF        ARTTCR <> *ZEROS
     C                   MOVEL     ARTTCR        PCRTRA1
     C                   ENDIF

      **   Branch
     C                   EVAL      PCRBRA1 = ARBCCR1
     C                   EVAL      PCRBRA2 = ARBCCR2
     C                   EVAL      PCRBRA3 = ARBCCR3

      **   Customer
     C                   EVAL      PCRCUS1 = ARCNCR1
     C                   EVAL      PCRCUS2 = ARCNCR2
     C                   EVAL      PCRCUS3 = ARCNCR3

      **   Account Code
     C                   IF        ARACCR1 <> *ZEROS
     C                   MOVEL     ARACCR1       PCRCOD1
     C                   ENDIF
     C                   IF        ARACCR2 <> *ZEROS
     C                   MOVEL     ARACCR2       PCRCOD2
     C                   ENDIF
     C                   IF        ARACCR3 <> *ZEROS
     C                   MOVEL     ARACCR3       PCRCOD3
     C                   ENDIF

      **   Account Seq
     C                   IF        ARASCR1 <> *ZEROS
     C                   MOVEL     ARASCR1       PCRSEQ1
     C                   ENDIF
     C                   IF        ARASCR2 <> *ZEROS
     C                   MOVEL     ARASCR2       PCRSEQ2
     C                   ENDIF
     C                   IF        ARASCR3 <> *ZEROS
     C                   MOVEL     ARASCR3       PCRSEQ3
     C                   ENDIF

      **   Narrative Code
     C                   EVAL      PCRNCO1 = ARNACR1
     C                   EVAL      PCRNCO2 = ARNACR2
     C                   EVAL      PCRNCO3 = ARNACR3

      **   Received Narrative
     C                   EVAL      PCRNAR1 = ARRNCR1
     C                   EVAL      PCRNAR2 = ARRNCR2
     C                   EVAL      PCRNAR3 = ARRNCR3

      **   Posting Ref
     C                   MOVEL     ARPRFCR1      PCRPOS1
     C                   MOVEL     ARPRFCR2      PCRPOS2
     C                   MOVEL     ARPRFCR3      PCRPOS3

      ** Print Report Headers for every new page

     C                   EVAL      RqdLn1 = 1
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1

     C                   IF        DifLn1 <= RqdLn1
     C                   EXSR      SRPrintHdr1
     C                   EXSR      SRPrintHdr2
     C                   ENDIF

     C                   WRITE     DETAIL

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

     C                   EVAL      RCOUNT = WRecNo

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

      ** Access Bank details
      **   Retrieve Run day number

     C                   CALL      'AOBANKR0'
     C                   PARM      *Blanks       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY

     C                   IF        PRtCd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      RRPTDS = BJURPT
     C                   ENDIF

      ** Check CGL145 feature

     C                   Call      'AOSARDR0'
     C                   Parm      *Blanks       PRtCd
     C                   Parm      '*VERIFY'     POptn
     C                   Parm      'CGL145'      PSARD
     C                   Parm                    DSFDY

     C                   IF        PRtCd <> *BLANKS AND
     C                             PRtCd <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'CGL145'
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBase = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   IF        PRtCd <> *BLANKS
     C                   EVAL      CGL145 = 'N'
     C                   ELSE
     C                   EVAL      CGL145 = 'Y'
     C                   ENDIF
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
