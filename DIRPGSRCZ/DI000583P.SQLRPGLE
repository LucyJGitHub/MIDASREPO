     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas OF Missing Account Rules List Report')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      ***GL000583P*-*Midas*OF*Missing*Account*Rules*List Report********                     MD029739
      *  DI000583P - Midas OF Missing Account Rules List Report       *                     MD029739
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD029739 *RENAMED* Date 15Aug14               *
      *                 MD024772           Date 03Feb14               *
      *                 MD024513           Date 23Jan14               *
      *                 MD023825           Date 28Nov13               *
      *                 MD023837           Date 27Nov13               *
      *                 CGL135A  *CREATE   Date 10Jul13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD029739 - File renaming for integration layer.              *
      *  MD024772 - Problems with Accounting Interface postings and   *
      *             enquiries.                                        *
      *  MD024513 - Add Description field (30A) to the Accounting     *
      *             Rules. (Recompile)                                *
      *  MD023825 - Missing reports called during Accounting Rules    *
      *             Process                                           *
      *  MD023837 - Triggers on tables GLACMNTD, GLACBHTD, GLACBDTD   *
      *             failed (Recompile)                                *
      *  CGL135A - Accounting Rules Process                           *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Midas GL Accounting Rules Audit/List report - Detail
     F***GL000583P1O E             PRINTER INFSR(*PSSR)                                     MD029739
     FDI000583P1O    E             PRINTER INFSR(*PSSR)                                     MD029739
     F                                     INFDS(SPOOL1)

      ** Midas GL Accounting Rules List report - Audit list
     F***GL000583AUO E             PRINTER INFDS(SPOOLU)                                    MD029739
     FDI000583AUO    E             PRINTER INFDS(SPOOLU)                                    MD029739
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

      ** External DS for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

     ** File DS
     **   Midas GL Accounting Rules
     D*ACBD****      E DS                  EXTNAME(GLACBDTD)                                MD029739
     D ACBD          E DS                  EXTNAME(DIACBDTD)                                MD029739


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

      ** Set file pointer to first record and do initial read.

     C/exec SQL
     C+ declare LIST cursor for
     C*+select** from GLACBDTD                                                              MD029739
     C+ select * from DIACBDTD                                                              MD029739
     C+ order by
     C+       BDBTID,
     C+       BDBKBR,
     C+       BDDPCD
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
     C+ into: ACBD
     C/end-exec

      ** Read Accounting Rules Batch Details until end of file

     C                   DOW       SQLCode <> 100

     C                   IF        BDCRST = 'I' OR BDCRST = 'U'
     C                   IF        Pmode <> 'A' or BDMSRP <> 'Y'                            MD023825

      ** Print Report Header 1

     C                   EXSR      SRPrintHdr1

      ** Print Report Header 2

     C                   EXSR      SRPrintHdr2

      ** Print Details

     C                   EXSR      SRPrintDtl

     C                   EVAL      WRecNo = WRecNo + 1

     C                   ENDIF                                                              MD023825
     C                   ENDIF

     C/exec SQL
     C+ fetch next from LIST
     C+ into :ACBD
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

     C                   WRITE     HEADER2

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

      ** Batch ID

     C                   EVAL      PABTID = BDBTID

      ** Status

     C                   SELECT
     C                   WHEN      BDCRST = 'I'
     C                   EVAL      PASTAT = 'Missing Accounting Rule'
     C                   WHEN      BDCRST = 'U'
     C                   EVAL      PASTAT = 'Missing Accounting Rule with ' +
     C                                      'Posting Generation'
     C                   ENDSL

      ** Booking Branch

     C                   EVAL      PABKBR = BDBKBR

      ** Department

     C                   EVAL      PADPCD = BDDPCD

      ** Currency

     C                   EVAL      PACCY  = BDCCY

      ** Event Amount

     C                   EXSR      GetCurrDtls
     C                   EVAL      WField = *BLANKS
     C                   EVAL      WAmount = *Zeros
     C                   EVAL      PDecPlace = *Zeros
     C                   MOVE      BDEVTA        WAmount
     C                   EVAL      PDecPlace = A6NBDP                                      ??
     C                   EXSR      FormatAmount
     C                   MOVE      WField        PAEVTA

      ** DR/CR

     C                   EVAL      PADCIP = BDDCIP

      ** Posting Date

     C                   EVAL      ZDAYNO = BDPSTD

     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         ZDATE
     C                   PARM      *BLANK        ZADATE
      *
     C                   MOVEL     ZDATE         PAPSTD

      ** Event Date

     C                   EVAL      ZDAYNO = BDEVTD

     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         ZDATE
     C                   PARM      *BLANK        ZADATE

     C                   MOVEL     ZDATE         PAEVTD

      ** Narrative

     C                   EVAL      PANARR = BDNARR
     C                   EVAL      PANAR2 = BDNAR2
     C                   EVAL      PANAR3 = BDNAR3
     C                   EVAL      PANAR4 = BDNAR4
     C                   EVAL      PANAR5 = BDNAR5
     C                   EVAL      PANAR6 = BDNAR6
     C                   EVAL      PANAR7 = BDNAR7

      ** Sett A/c DR

     C                   EVAL      PASADR = BDSADR

      ** Sett A/c CR

     C                   EVAL      PASACR = BDSACR

      ** Customers: Counterparty

     C                   EVAL      PACTPY = BDCTPY

      ** Depot

     C                   EVAL      PADPCN = BDDPCN

      ** Issuing

     C                   EVAL      PAISCN = BDISCN

      ** Associated

     C                   EVAL      PAASCN = BDASCN

      ** MatchField1

     C                   EVAL      PASMT1 = BDSMT1

      ** MatchField2

     C                   EVAL      PASMT2 = BDSMT2

      ** MatchField3

     C                   EVAL      PASMT3 = BDSMT3

      ** MatchField4

     C                   EVAL      PASMT4 = BDSMT4

      ** MatchField5

     C                   EVAL      PASMT5 = BDSMT5

      ** MatchField6

     C                   EVAL      PASMT6 = BDSMT6

      ** MatchField7

     C                   EVAL      PASMT7 = BDSMT7

      ** MatchField8

     C                   EVAL      PASMT8 = BDSMT8

      ** MatchField9

     C                   EVAL      PASMT9 = BDSMT9

      ** MatchField10

     C                   EVAL      PASMT10 = BDSMT10

      ** DR/CR

     C                   EVAL      PADRCR = BDDCIP

      ** Profit Centre

     C                   EVAL      PAPFCT = BDPFCT

      ** SWIFT Ref

     C                   EVAL      PASWFR = BDSWFR

      ** Cheque No

     c                   MOVE      BDCHQN        PACHQN

      ** Book Code

     C                   EVAL      PABKCD = BDBKCD

      ** Source Customer

     C                   EVAL      PASRCN = BDSRCN

      ** Reversal Ind

     C                   EVAL      PARVID = BDRVID
                                                                                            MD024772
      ** Customer Account from Interface                                                    MD024772
                                                                                            MD024772
     C                   EVAL      PICUSA = BICUSA                                          MD024772
                                                                                            MD024772
      ** Transaction Sub Type from Interface                                                MD024772
                                                                                            MD024772
     C                   EVAL      PITSTY = BITSTY                                          MD024772


     C                   IF        CGL145 = 'Y'
     C                   EVAL      *IN80 = *ON

      ** Customer Source Account ID

     C                   EVAL      PACSAI = BDCSAI

      ** Operation Type

     C                   EVAL      PAOPTP = BDOPTP

      ** Forecast Reference

     C                   EVAL      PAFCRF = BDFCRF

     C                   ENDIF

      ** Print Report Headers for every new page

     C                   EVAL      RqdLn1 = 1
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1

     C                   IF        DifLn1 <= RqdLn1
     C                   EXSR      SRPrintHdr1
     C                   EXSR      SRPrintHdr2
     C                   ENDIF

     C                   WRITE     DETAIL
                                                                                            MD023825
     C                   IF        Pmode = 'A'                                              MD023825
     C/EXEC SQL                                                                             MD023825
     C*+UPDATE*GLACBDTD  SET BDMSRP = 'Y'                                          MD023825 MD029739
     C+ UPDATE DIACBDTD  SET BDMSRP = 'Y'                                                   MD029739
     C+ where current of LIST                                                               MD023825
     C/END-EXEC                                                                             MD023825
     C                   ENDIF                                                              MD023825

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
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM      BDCCY         @CCY              3
     C     SDCURR        PARM      SDCURR        DSSDY

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
