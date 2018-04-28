     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RP FF Transaction - COB Changes')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian DBA Replication                             *
      *                                                               *
      *  RP1413 - FF Transaction - COB Changes - Reset/Reports.       *
      *                                                               *
      *  Function:  This program resets FF Transaction                *
      *  (COB)      Replication Indicator field for records that have *
      *             been changed during previous COB and data of      *
      *             which have been passed to remote systems by       *
      *             change the Replication field to 'C' (like COB).   *
      *                                                               *
      *             Basic information of records, that have been      *
      *             changed during current COB, are printed on report *
      *                                                               *
      *             These two functions are mutually exclusive and    *
      *             conditioned by external indicator U1.             *
      *                                                               *
      *  Component of: RPC1413 - FF Transaction - COB Changes         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      *  Prev Amend No. CFF007  *CREATE    Date 13Feb01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CFF007 - Futures and Options Enhancement for Private Banking *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         End of file TRANSD                              *
      *    30         Controls text in header                         *
      *    38         Controls the display of Market or OTC in AU/P1  *
      *    83         General file access indicator                   *
      *    U1         Print on report / reset flag                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRReport - Subroutine to print details of processed record   *
      *  SRRCFP1 - Subroutine to register the P1 Printer File via RCF *
      *  SRRCFAU - Subroutine to register the AU Printer File via RCF *
      *  SRAudit - Subroutine to Output Audit report.                 *
      *  *PSSR   - Program exception error routine                    *
      *  *INZSR  - Program Initialization routine.                    *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** FF Transd.
     FTRANSD    UF   E           K DISK    INFSR(*PSSR)
 
      ** FF Instrument type
     FINTYP     IF   E           K DISK    PREFIX(IN)
     F                                     INFSR(*PSSR)
 
      ** FF Instrument Type details file
     FINTYP2    IF   E           K DISK    RENAME(INTYPDF:INTYPDF2)
     F                                     PREFIX(IN)
     F                                     INFSR(*PSSR)
 
      ** PB FF Transaction COB changes replication audit report.
     FRP1413AU  O    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SpoolU)
 
      ** PB FF Transaction COB changes replication report.
     FRP1413P1  O    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(Spool1)
     F                                     USROPN
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      ** External Data structure for Local data area (db error details).
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc
 
      *
      ** The following /COPY line includes all the defined fields in
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Data structure for access programs, long data structure.
     D Dssdy         E DS                  Extname(DSSDY)
 
      ** External data structure for Bank Details.
     D Sdbank        E DS                  Extname(SDBANKPD)
 
      ** File Information Data Structure for printer file RP1413AU.
     D SpoolU          DS
     D  SFNameU               83     92
     D  SFNumU               123    124B 0
 
      ** File Information Data Structure for printer file RP1413P1.
     D Spool1          DS
     D  SFName1               83     92
     D  SFNum1               123    124B 0
     D  SFOFLn1              188    189B 0
     D  SFPrtLn1             367    368B 0
 
      ** Rededine Instrument Type to retrieve OTC instrument
     D ISTT            DS
     D   WMarket               1      2
     D   WIstc                 3      5
 
      ** Months Short Names
     D ZMNM            S              3    DIM(12) CTDATA PERRCD(12)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** *Entry parameters
     D P_Market        S              2A
     D P_MarketName    S             20A
 
      ** --------- Start of fields used by access programs ----------**
      ** Return code.
     D PRtnCde         S              7A
      ** Option.
     D POption         S              7A
      ** Minimum Price fluctuation
     D PMNPF           S             15P 8
      ** Screen version of price
     D PStrike         S             16A
      ** File version of price
     D PSTRP           S             15P 8
      ** Tick denominator
     D PTKDM           S              3P 0
      ** ---------- End of fields used by access programs -----------**
 
      ** Parameter fields used by standard programs
     D PZField         S             16A
     D PZDecs          S              1P 0
     D PZSeq           S              5A
     D PZEntity        S              3A
     D PZSFName        S             10A
     D PZSFNum         S              6P 0
     D PZError         S              1A
 
      ** Fields used to check that sufficient lines remain for the
      ** printer file record format.
     D WDifLn1         S              2  0
     D WRqdLn1         S              2  0
 
      ** Work Field used to produce only one dump.
     D WRunBefore      S              1A
 
      ** Work Field used to open P1 printer file only once.
     D WOpenP1         S              1A
 
      ** Work Field used as key to access to Instrument Details
     D KInst           S              5A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** Rename fields on instrument file with common names
     IINTYPDF2
     I              ISTI                        INISTI2
     I              ISPT                        INISPT2
     I              ISCY                        INISCY2
     I              QOTC                        INQOTC2
     I              TKDM                        INTKDM2
     I              MNPF                        INMNPF2
     I              TKVL                        INTKVL2
     I              OTHC                        INOTHC2
 
      /EJECT
      *****************************************************************
      *                                                               *
      *                  M A I N  P R O C E S S I N G                 *
      **   +------------------------------------------------------+   *
      **   ¦                                                      ¦   *
      **   ¦ Initial processing is performed automatically: the   ¦   *
      **   ¦ *INZSR is executed at program activation.            ¦   *
      **   ¦                                                      ¦   *
      **   +------------------------------------------------------+   *
      *                                                               *
      *****************************************************************
 
      ** Read first FF Transd.
     C                   READ      TRANSDF                                01
 
      ** Do while FF Transaction be processed.
     C     *IN01         DOWEQ     *OFF
 
      ** If Replication field has to be reset.
     C     *INU1         IFEQ      *OFF
     C                   EVAL      REPI = *BLANK
     C                   UPDATE    TRANSDF
     C                   ELSE
     C                   EVAL      REPI = 'C'
     C                   UPDATE    TRANSDF
     C                   EXSR      SRReport
     C                   ENDIF
 
     C                   EVAL      RCOUNT = RCOUNT + 1
 
      ** Read next FF Transaction file record.
     C                   READ      TRANSDF                                01
 
     C                   ENDDO
 
      ** If printing of reports required.
     C     *INU1         IFEQ      *ON
 
      ** If at least one line has been printed.
     C     RCOUNT        IFGT      0
     C                   WRITE     ENDPAG1
 
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
     C                   EVAL      WRqdLn1 = 4
     C                   EVAL      WDifLn1 = SFOFLn1 - SFPrtLn1
     C     WDifLn1       IFLE      WRqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF
 
      ** Write out Trailer Format.
     C                   WRITE     TRAILP1
 
      ** Close FF Transaction COB changes Report printer file.
     C                   CLOSE     RP1413P1
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Print Audit Report.
     C                   EXSR      SRAudit
 
      ** End Program and Return.
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReport - Subroutine to print details of processed record.  *
      *                                                               *
      *  Called By: Main processing                                   *
      *                                                               *
      *  Calls:     SRRCFP1, *PSSR, FFPRCS, ZEDIT                     *
      *                                                               *
      *****************************************************************
     C     SRReport      BEGSR
 
      ** Insure Audit Report Spool File was recorded by RCF.
     C     WOpenP1       IFEQ      *BLANK
     C                   EVAL      WOpenP1 = 'Y'
     C                   OPEN      RP1413P1
     C                   EXSR      SRRCFP1
      ** Force header format printing.
     C                   EVAL      SFPrtLn1 =  SFOFLn1
     C                   ENDIF
 
      ** Set up report printer file fields.
 
      ** Define key list to access to FF Transactions file.
     C     KIntypd       KLIST
     C                   KFLD                    KInst
     C                   EVAL      KInst = ISTT
 
      ** Access Instrument Types Details file.
     C     KIntypd       CHAIN     INTYP                              83
 
      ** If Instrument Details do not exist, handle database error.
     C     *IN83         IFEQ      *ON
     C     *LOCK         IN        Lda
     C                   EVAL      DbPgm  = PSProcName
     C                   EVAL      DbFile = 'INTYPD'
     C                   EVAL      Dbase  = 01
     C                   EVAL      DbKey  = KInst
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** If instrument is an Market
      ** And Instrument processing type is Greatre than 3 but not 7
     C                   IF        INISTI = 'N'
     C                             AND INISPT > 3
     C                             AND INISPT <> 7
      ** Retrieve Instrument details of the future type reference
     C                   MOVEL     ISTT          KInst
     C                   MOVE      INFTRF        KInst
      ** Access Instrument Types Details file.
     C     KIntypd       CHAIN     INTYP2                             83
     C                   ELSE
     C                   MOVEL     INTKDM        INTKDM2
     C                   MOVE      INMNPF        INMNPF2
     C                   ENDIF
 
      ** Set up report printer file fields.
     C                   IF        TNBR < *ZEROS
     C                   Z-SUB     TNBR          WTNBR             6 0
     C                   MOVEL     WTNBR         P1TNBR
     C                   MOVE      '-(M)'        P1TNBR
     C                   ELSE
     C                   MOVE      *BLANKS       P1TNBR
     C                   MOVEL     TNBR          P1TNBR
     C                   ENDIF
 
     C*****BOCO*         IFNE      *ZEROS                                                     CSD027
     C                   MOVE      BOCO          P1BOCO
     C**********         ELSE                                                                 CSD027
     C**********         MOVE      *BLANKS       P1BOCO                                       CSD027
     C**********         ENDIF                                                                CSD027
 
     C*****CUSC*         IFNE      *ZEROS                                                     CSD027
     C                   MOVE      CUSC          P1CUSC
     C**********         ELSE                                                                 CSD027
     C**********         MOVE      *BLANKS       P1CUSC                                       CSD027
     C**********         ENDIF                                                                CSD027
 
     C                   EVAL      P1BOKC = BOKC
     C                   EVAL      P1TNAR = TNAR
     C                   EVAL      P1BRCA = BRCA
 
     C                   IF        INISTI = 'Y'
     C                   EVAL      P1ISTT = ISTT
     C                   EVAL      P1YRNO = *BLANKS
     C                   EVAL      P1MYS  = *BLANKS
     C                   EVAL      P1MTHN = *BLANKS
     C                   ELSE
     C                   MOVEL     WMarket       WRK3              3
     C                   MOVE      '-'           WRK3
     C                   MOVEL     WIstc         WRK4              4
     C                   MOVE      '-'           WRK4
     C                   MOVEL     WRK3          P1ISTT
     C                   MOVE      WRK4          P1ISTT
     C                   MOVEL     YRNO          P1YRNO
     C                   MOVEL     '-'           P1MYS
     C                   MOVE      ZMNM(MTHN)    P1MTHN
     C                   ENDIF
 
     C                   IF        INISPT > 3
     C                             AND INISPT <> 7
 
     C                   EVAL      P1PCAL = PCAL
     C                   MOVE      STRP          PSTRP
     C                   MOVE      INTKDM2       PTKDM
     C                   MOVE      INMNPF2       PMNPF
 
     C                   CALLB     'FFPRCS'
     C                   PARM      *BLANKS       PRtnCde
     C                   PARM      *BLANKS       PStrike
     C                   PARM                    PSTRP
     C                   PARM                    PTKDM
     C                   PARM                    PMNPF
 
     c     PRtnCde       IFEQ      *BLANKS
     C                   EVAL      P1STRP = PStrike
     c                   ELSE
     C                   EVAL      P1STRP = *BLANKS
     c                   ENDIF
 
     C                   ELSE
     C                   EVAL      P1PCAL = *BLANKS
     C                   EVAL      P1STRP = *BLANKS
     C                   ENDIF
 
      ** Format number of contrats
     C                   MOVE      NUCO          PZField
     C                   EVAL      PZDecs  = 0
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    PZField
     C                   PARM                    PZDecs
 
     C                   MOVE      PZField       P1NUCO
 
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
     C                   EVAL      WRqdLn1 = 3
     C                   EVAL      WDifLn1 = SFOFLn1 - SFPrtLn1
 
     C     WDifLn1       IFLE      WRqdLn1
 
      ** If end of page, print relevant record format.
     C     RCOUNT        IFGT      0
     C                   WRITE     ENDPAG1
     C                   ENDIF
 
     C                   EVAL      P1MRKT = P_Market
     C                   EVAL      P1MKTN = P_MarketName
 
     C                   IF        P1MRKT = '  '
     C                   EVAL      *IN38 = *ON
     C                   ELSE
     C                   EVAL      *IN38 = *OFF
     C                   ENDIF
 
     C                   WRITE     HEADP1
 
     C                   ENDIF
 
      ** Write record details.
     C                   WRITE     DETAIL1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRCFP1 - Subroutine to register the P1 Printer File via RCF *
      *                                                               *
      *  Called by: SRReport                                          *
      *                                                               *
      *  Calls:     ZSFILE                                            *
      *                                                               *
      *****************************************************************
     C     SRRCFP1       BEGSR
 
      ** Ensure Report Spool File recorded by RCF.
     C                   Z-ADD     SFNum1        PZSFNum
 
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       PZSeq
     C                   PARM                    PZEntity
     C                   PARM      SFName1       PZSFName
     C                   PARM                    PZSFNum
     C                   PARM      *BLANK        PZError
 
      ** If any Error occurred during ZSFILE processing, then return to
      ** Calling Program.
     C     PZError       IFEQ      'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRCFAU - Subroutine to register the AU Printer File via RCF *
      *                                                               *
      *  Called by: SRAUDIT                                           *
      *                                                               *
      *  Calls:     ZSFILE                                            *
      *                                                               *
      *****************************************************************
     C     SRRCFAU       BEGSR
 
      ** Ensure Audit Spool File recorded by RCF.
     C                   Z-ADD     SFNumU        PZSFNum
 
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       PZSeq
     C                   PARM      *BLANKS       PZEntity
     C                   PARM      SFNameU       PZSFName
     C                   PARM                    PZSFNum
     C                   PARM      *BLANK        PZError
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
     C     PZError       IFEQ      'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAUDIT - Subroutine to output Audit report.                 *
      *                                                               *
      *  Called By: Main Processing, *PSSR                            *
      *                                                               *
      *  Calls:     SRRCFAU                                           *
      *                                                               *
      *****************************************************************
     C     SRAUDIT       BEGSR
 
      ** Ensure Audit Report Spool File Recorded by RCF.
     C                   EXSR      SRRCFAU
 
      ** Output Report Header and File Controls.
     C                   WRITE     HEADAU
 
     C                   EVAL      P1MRKT = P_Market
     C                   EVAL      P1MKTN = P_MarketName
 
     C                   IF        P1MRKT = '  '
     C                   EVAL      *IN38 = *ON
     C                   ELSE
     C                   EVAL      *IN38 = *OFF
     C                   ENDIF
 
     C                   WRITE     CONTROL
 
      ** If there is a DB Error, output the DB Error Information.
     C     *INU7         IFEQ      *ON
     C                   WRITE     DBERROR
 
     C                   ELSE
 
      ** Or, if no records read, output "No Details" message.
     C     RCOUNT        IFEQ      0
     C                   WRITE     NODTLS
     C                   ENDIF
 
     C                   ENDIF
 
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
      *  Called by: (**calling routines**)                            *
      *                                                               *
      *  Calls:     SRAudit                                           *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C     WRunBefore    IFNE      'Y'
     C                   EVAL      WRunBefore = 'Y'
     C                   DUMP
     C                   CALLB     'DBERRCTL'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
      ** Ouput Audit Report.
     C                   EXSR      SRAUDIT
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR  - Program Initialization routine.                    *
      *                                                               *
      *  Called By: Implicitly on program activation.                 *
      *                                                               *
      *  Calls:     AOBANKR0, *PSSR                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Parameters list.
     C     *ENTRY        PLIST
     C                   PARM                    P_Market
     C                   PARM                    P_MarketName
 
      ** Access Bank details by using access program.
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRtnCde
     C                   PARM      '*FIRST '     POption
     C     SdBank        PARM      SdBank        Dssdy
 
      ** If Bank details do not exist, handle database error.
     C     PRtnCde       IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DbPgm  = PSProcName
     C                   EVAL      DbFile = 'SDBANKPD'
     C                   EVAL      Dbase  = 02
     C                   EVAL      DbKey  = '*FIRST'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Set on indicator to print appropriate audit report header.
     C     *INU1         IFEQ      *ON
     C                   EVAL      *IN30 = *ON
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
** Ctdata ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
