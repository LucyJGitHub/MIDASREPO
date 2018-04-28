     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RP FF Transactions - take on')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian DBA Replication                             *
      *                                                               *
      *  RP1467 - FF Transactions Take On                             *
      *                                                               *
      *  Function: This module updates FF Transactions                *
      *            Replication Indicator field so that record would   *
      *            be processed by Meridian Replication functions,    *
      *            for take on purpose.                               *
      *                                                               *
      *  Component of: RPC1467 - FF Transactions Take On              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 206026             Date 09Oct02               *
      *                 206100             Date 27Jun02               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 198158             Date 24Oct01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CFF007  *CREATE    Date 13Feb01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  206026 - Avoid crash on SDCUSTPD and RP1467AU already open.  *
      *  206100 - "Gateway to PB" : Transactions, Portfolios not sent *
      *           Remove GEMS 198158 !                                *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  198158 - If error avoid Transactions transfer for customer PM*
      *  CFF007 - Futures and Options Enhancement for Private Banking *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    70         *Off - 'Private Banking' subheading             *
      *               *On  - 'Gateway to Private Banking' subheading  *
      *    71         *Off - All customers on report                  *
      *               *On  - Only a range of customers on report      *
      *    72         *On  - Show account officer on report           *
      *    73         *On  - Show branch on report                    *
      *    81         End of file CLINTCB                             *
      *    82         End of file TRANSD failed                       *
      *    83         End of file INTYPD failed                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRReport - Subroutine to print details of processed record   *
      *  SRRCFP1 - Subroutine to register the P1 Printer File via RCF *
      *  SRRCFAU - Subroutine to register the AU Printer File via RCF *
      *  SRAudit - Subroutine to Output Audit report.                 *
      *  SRInit  - Initialization subroutine.                         *
      *  *PSSR   - Program exception error routine                    *
      *  *INZSR  - Program Initialization routine.                    *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** SD Customer Master Details
     FSDCUSTPD  IF   E             DISK    INFSR(*PSSR)
 
      ** FF Transaction details file
     FTRANSC    UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** FF Instrument Type details file
     FINTYP     IF   E           K DISK    PREFIX(IN)
     F                                     INFSR(*PSSR)
 
      ** FF Instrument Type details file
     FINTYP2    IF   E           K DISK    RENAME(INTYPDF:INTYPDF2)
     F                                     PREFIX(IN)
     F                                     INFSR(*PSSR)
 
      ** PB FF Transactions take on audit report
     FRP1467AU  O    E             PRINTER INFDS(SpoolU)
     F                                     INFSR(*PSSR)
     F                                     USROPN
 
      ** PB FF Transactions take on report
     FRP1467P1  O    E             PRINTER INFDS(Spool1)
     F                                     INFSR(*PSSR)
     F                                     USROPN
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** External Data structure for Local data area (db error details)
     D LDA           E DS           256    Extname(LDA) Dtaara(LDA)
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc
 
      ** Customer Selection Data Area
     D RPCust        E DS                  Extname(RPCUST) DTAARA(RPCUST)
 
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
 
      ** Data structure for access programs, short data structure
     D Dsfdy         E DS                  Extname(DSFDY)
 
      ** Data structure for access programs, long data structure
     D Dssdy         E DS                  Extname(DSSDY)
 
      ** External data structure for Bank Details
     D SdBank        E DS                  Extname(SDBANKPD)
 
      ** External data structure for Account Officer Details
     D SdAcof        E DS                  Extname(SDACOFPD)
 
      ** External data structure for Branch Details
     D SdBrch        E DS                  Extname(SDBRCHPD)
     D  QQDFA1       E                     EXTFLD(QQDFAC)                                     CGL029
 
      ** External data structure for Midas Module Details
     D SdMmod        E DS                  Extname(SDMMODPD)
 
      ** Array containing narratives
     D WTbNarr         S             80    Dim(3) Ctdata Perrcd(1)
 
      ** Array containing month
     D WTbZMNM         S              3    Dim(12) Ctdata Perrcd(12)
 
      ** File Information Data Structure for printer file RP1467AU
     D SpoolU          DS
     D  SFNameU               83     92
     D  SFNumU               123    124B 0
 
      ** File Information Data Structure for printer file RP1467P1
     D Spool1          DS
     D  SFName1               83     92
     D  SFNum1               123    124B 0
     D  SFOflLn1             188    189B 0
     D  SFPrtLn1             367    368B 0
 
      ** Rededine Instrument Type to retrieve OTC instrument
     D ISTT            DS
     D   WMarket               1      2
     D   WIstc                 3      5
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** --------- Start of fields used by access programs ----------**
      ** Return code.
     D PRtnCde         S              7A
      ** Option.
     D POption         S              7A
      ** Account Officer.
     D PAccOff         S              2A
      ** Branch Code.
     D PBrch           S              3A
      ** Customer.
     D PCust           S             10A
      ** ---------- End of fields used by access programs -----------**
 
      ** Parameter fields used by standard programs
     D PZFld16A        S             16A
     D PZDecs          S              1P 0
     D PZSeq           S              5A
     D PZEntity        S              3A
     D PZSFName        S             10A
     D PZSFNum         S              6P 0
     D PZError         S              1A
 
      ** Field used by FFPRCS (cvt FF price from file to scr/rpt fmt)
      ** Return code
     D PRtnCde10       S             10A
      ** Screen version of price
     D PStrike         S             16A
      ** File version of price
     D PSTRP           S             15P 8
      ** Tick denominator
     D PTKDM           S              3P 0
      ** Minimum Price fluctuation
     D PMNPF           S             15P 8
 
      ** Fields used to check that sufficient lines remain for the
      ** printer file record format.
     D WDifLn1         S              2  0
     D WRqdLn1         S              2  0
 
      ** Field used to position to first FF Transations for customer.
     D*K_CustNum       S              6  0                                                    CSD027
     D K_CustNum       S              6A                                                      CSD027
 
      ** Work Field used as key to access to Instrument Details
     D K_Inst          S              5A
 
      ** Work Field used to open P1 printer file only once.
     D W_OpenP1        S              1A
 
      ** Work Field used to change value of field TRANSDF/REPI.
     D W_REPI          S              2  0
 
      ** Work Field used to produce only one dump.
     D WRunBefore      S              1A
 
      ** Length passed to formatting procedure RPPrCenter.
     D W_Length        S              3P 0
 
      ** Work field used to condition run of take on.
     D W_Takeon        S              1A
 
      ** +--------------------------------------+
      ** ¦ Prototypes                           ¦
      ** ¦ ==========                           ¦
      ** +--------------------------------------+
 
      ** Pull in prototype for RPPrCenter procedure.
      /COPY RPCPYSRC,RPFMTPPC
 
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
      *    +------------------------------------------------------+   *
      *    ¦                                                      ¦   *
      *    ¦ Initial processing is performed automatically: the   ¦   *
      *    ¦ *INZSR is executed at program activation.            ¦   *
      *    ¦                                                      ¦   *
      *    +------------------------------------------------------+   *
      *                                                               *
      *****************************************************************
 
      ** Perform initialization subroutine as program remains in memory
     C                   EXSR      SRInit
 
      ** Read first Customer.
     C                   READ      SDCUSTPD                               81
 
      ** Do while Customers to be processed for required selection.
     C     *IN81         DOWEQ     *OFF
     C                   EVAL      W_Takeon = 'Y'
 
      ** If Customer is not a Private Banking customer, that
      ** means this take on program is running within the scope
      ** of Gateway to Private Banking. So, insure that so a take
      ** on will only run for Portfolio Management customers.
     C     BBPRBA        IFNE      'Y'
     C     BBACOC        OREQ      *BLANKS
     C                   EVAL      W_Takeon = 'N'
 
      ****If*Portfolio*Management*module*is*installed.                          198158
     C*****BGPFMG        IFEQ      'Y'                                          198158
     C*****BBACOC        ANDNE     *BLANKS                                      198158
     C**********         CALLB     'AOPLCSR0'                                   198158
     C**********         PARM      *BLANKS       PRtnCde                        198158
     C**********         PARM      '*KEY    '    POption                        198158
     C**********         PARM      BBCUST        PCust                          198158
     C**********         PARM                    Dsfdy                          198158
      **********                                                                198158
      ****Process*only*Customers**whose*Portfolio*Management*Details*exist.     198158
     C*****P_Rtcd        IFEQ      *BLANKS                                      198158
     C**********         EVAL      W_Takeon = 'Y'                               198158
     C**********         ENDIF                                                  198158
      **********                                                                198158
     C**********         ENDIF                                                  198158
                                                                                              206100
      **  If Portfolio Management module is installed.                                        206100
     C     BGPFMG        Ifeq      'Y'                                                        206100
     C     BBACOC        Andne     *Blanks                                                    206100
     C                   CallB     'AOPLCSR0'                                                 206100
     C                   Parm      *blanks       PRtnCde                                      206100
     C                   Parm      '*KEY    '    POption                                      206100
     C                   Parm      BBCUST        PCust                                        206100
     C                   Parm                    Dsfdy                                        206100
                                                                                              206100
      **  Process only Customers  whose Portfolio Management Details exist.                   206100
     C     PRtnCde       Ifeq      *blanks                                                    206100
     C                   Eval      W_Takeon = 'Y'                                             206100
                                                                                              206100
     C                   Endif                                                                206100
                                                                                              206100
     C                   Endif                                                                206100
 
     C                   ENDIF
 
      ** If take on processing has to run for current customer.
     C     W_Takeon      IFEQ      'Y'
 
      ** Define key list to access to FF Transactions file.
     C     K_FFTrade     KLIST
     C                   KFLD                    K_CustNum
 
      ** Set up Key list to access to FF Transactions file.
     C                   MOVE      BBCUST        K_CustNum
 
      ** Position on first FF Transaction.
     C     K_FFTrade     SETLL     TRANSC
     C     K_FFTrade     READE     TRANSC                                 82
 
      ** Do while FF Transactions to be processed for required selection.
     C     *IN82         DOWEQ     *OFF
 
      ** Process only live FF Transactions.
     C     RECI          IFEQ      'D'
     C     NOCO          ANDNE     *Zeros
 
      ** Update Replication Indicator field.
     C                   TESTN                   REPI                 77
 
      ** If Replication Indicator is numeric.
     C     *IN77         IFEQ      *ON
     C                   MOVE      REPI          W_REPI
     C                   ADD       1             W_REPI
      ** If Replication Indicator is not numeric.
     C                   ELSE
     C                   EVAL      W_REPI = 1
     C                   ENDIF
     C                   MOVE      W_REPI        REPI
 
      ** Update FF Transactions file record.
     C                   UPDATE    TRANSDF
 
      ** Print FF Transactions informations on report.
     C                   EXSR      SRReport
 
     C                   ENDIF
 
      ** Read next FF Transactions record.
     C     K_FFTrade     READE     TRANSC                                 82
 
     C                   ENDDO
 
     C                   ENDIF
 
      ** Read next Customer.
     C                   READ      SDCUSTPD                               81
 
     C                   ENDDO
 
      ** Close Customer Master Details file.
     C                   CLOSE     SDCUSTPD
 
      ** Commit.
     C                   COMMIT
 
      ** If at least one line has been printed.
     C     RCOUNT        IFGT      0
      ** Write out Trailer Format.
     C                   WRITE     ENDPAG1
     C                   WRITE     TRAILP1
      ** Close FF Transactions take on Report printer file.
     C                   CLOSE     RP1467P1
     C                   ENDIF
 
      ** Print Audit Report.
     C                   EXSR      SRAudit
 
      ** End Program and Return.
     C                   MOVE      *ON           *INLR
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
     C     W_OpenP1      IFEQ      *BLANK
 
     C                   EVAL      W_OpenP1 = 'Y'
     C                   OPEN      RP1467P1
     C                   EXSR      SRRCFP1
 
      **-------------  Set up Report sub-heading fields -------------**
 
      ** If Account Officer Reference was selected.
     C     CSAcofCode    IFNE      *BLANKS
     C                   EVAL      P1ACOF = AUACOF
 
     C                   ELSE
 
      ** If customer range was selected.
     C     CSFromCust    IFNE      'ALL'
     C                   EVAL      P1CUSB = CSFromCust
     C                   EVAL      P1CUSA = CSToCust
     C                   ENDIF
 
     C                   ENDIF
 
      ** If Main Customer Branch was selected.
     C     CSMainBrch    IFNE      'ALL'
     C                   EVAL      P1BRCH = AUBRCH
     C                   ENDIF
 
      ** Force header format printing.
     C                   EVAL      SFPrtLn1 =  SFOflLn1
 
     C                   ENDIF
 
      ** Define key list to access to FF Transactions file.
     C     K_Intypd      KLIST
     C                   KFLD                    K_Inst
     C                   EVAL      K_Inst = ISTT
 
      ** Access Instrument Types Details file.
     C     K_Intypd      CHAIN     INTYP                              83
 
      ** If Instrument Details do not exist, handle database error.
     C     *IN83         IFEQ      *ON
     C     *lock         IN        Lda
     C                   EVAL      Dbpgm  = PSProcName
     C                   EVAL      Dbfile = 'INTYPD'
     C                   EVAL      Dbase  = 04
     C                   EVAL      Dbkey  = K_Inst
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** If instrument is an Market
      ** And Instrument processing type is Greatre than 3 but not 7
     C                   IF        INISTI = 'N'
     C                             And INISPT > 3
     C                             And INISPT <> 7
      ** Retrieve Instrument details of the future type reference
     C                   MOVEL     ISTT          K_Inst
     C                   MOVE      INFTRF        K_Inst
      ** Access Instrument Types Details file.
     C     K_Intypd      CHAIN     INTYP2                             83
     C                   ELSE
     C                   Z-ADD     INTKDM        INTKDM2
     C                   Z-ADD     INMNPF        INMNPF2
     C                   ENDIF
 
      ** Set up report printer file fields.
     C                   MOVE      TNBR          P1TNBR
 
     C*****BOCO*         IFNE      *zeros                                                     CSD027
     C                   MOVE      BOCO          P1BOCO
     C**********         ELSE                                                                 CSD027
     C**********         MOVE      *BLANKS       P1BOCO                                       CSD027
     C**********         ENDIF                                                                CSD027
 
     C*****CUSC*         IFNE      *zeros                                                     CSD027
     C                   MOVE      CUSC          P1CUSC
     C**********         ELSE                                                                 CSD027
     C**********         MOVE      *BLANKS       P1CUSC                                       CSD027
     C**********         ENDIF                                                                CSD027
 
     C                   EVAL      P1BOKC = BOKC
     C                   EVAL      P1TNAR = TNAR
 
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
     C                   MOVE      WTbZMNM(MTHN) P1MTHN
     C                   ENDIF
 
     C                   IF        INISPT > 3
     C                             AND INISPT <> 7
     C                   EVAL      P1PCAL = PCAL
     C                   Z-ADD     STRP          PSTRP
     C                   Z-ADD     INTKDM2       PTKDM
     C                   Z-ADD     INMNPF2       PMNPF
 
     C                   CALLB     'FFPRCS'
     C                   PARM      *BLANKS       PRtnCde10
     C                   PARM      *BLANKS       PStrike
     C                   PARM                    PSTRP
     C                   PARM                    PTKDM
     C                   PARM                    PMNPF
 
     c     PRtnCde10     Ifeq      *BLANKS
     C                   EVAL      P1STRP = PStrike
     c                   Else
     C                   EVAL      P1STRP = *BLANKS
     c                   Endif
 
     C                   ELSE
     C                   EVAL      P1PCAL = *BLANKS
     C                   EVAL      P1STRP = *BLANKS
     C                   ENDIF
 
      ** Format number of contrats
     C                   MOVE      NUCO          PZFld16A
     C                   EVAL      PZDecs  = 0
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    PZFld16A
     C                   PARM                    PZDecs
 
     C                   MOVE      PZFld16A      P1NUCO
 
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
     C                   EVAL      WRqdLn1 = 2
     C                   EVAL      WDifLn1 = SFOflLn1 - SFPrtLn1
     C     WDifLn1       IFLE      WRqdLn1
 
      ** If end of page, print relevant record format.
     C     RCOUNT        IFGT      0
     C                   WRITE     ENDPAG1
     C                   ENDIF
 
     C                   WRITE     HEADP1
 
     C                   ENDIF
 
      ** Write record details.
     C                   WRITE     DETAIL1
     C                   EVAL      RCOUNT = RCOUNT + 1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRCFP1  - Subroutine to register the P1 Printer File via RCF*
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
     C                   PARM                    PZError
 
      ** If any Error occurred during ZSFILE processing, then return to
      ** calling Program.
     C     PZError       IFEQ      'Y'
     C     *lock         IN        RPCust
     C                   EVAL      CSRetnCode = 'ZSRP1467P1'
     C                   OUT       RPCust
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRCFAU  - Subroutine to register the AU Printer File via RCF*
      *                                                               *
      *  Called by: SRAudit                                           *
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
 
      ** If Error occurs during ZSFILE processing, then return to
      ** calling Program.
     C     PZError       IFEQ      'Y'
     C     *lock         IN        RPCust
     C                   EVAL      CSRetnCode = 'ZSRP1467AU'
     C                   OUT       RPCust
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Subroutine to output Audit report.                 *
      *                                                               *
      *  Called By: Main Processing, *PSSR                            *
      *                                                               *
      *  Calls:     SRRCFAU                                           *
      *                                                               *
      *****************************************************************
     C     SRAudit       BEGSR
 
      ** Open Audit Report printer file.
     C                   OPEN      RP1467AU
 
      ** Ensure Audit Report Spool File Recorded by RCF.
     C                   EXSR      SRRCFAU
 
      ** Output Report Header and File Controls.
     C                   WRITE     HEADAU
     C                   WRITE     CONTROL
 
      ** If there is a DB Error, output the DB Error Information.
     C     *INU7         IFEQ      *on
     C                   WRITE     DBERROR
 
     C                   ELSE
 
      ** Or, if no records read, output "No Details" message.
     C     RCOUNT        IFEQ      0
     C                   WRITE     NODTLS
     C                   ENDIF
 
     C                   ENDIF
 
      ** Close Audit Report printer file.
     C                   CLOSE     RP1467AU
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInit - Initialization subroutine.                          *
      *                                                               *
      *  Called By: Main processing                                   *
      *                                                               *
      *  Calls:     AOACOFR0, *PSSR, AOBRCHR0                         *
      *                                                               *
      *****************************************************************
     C     SRInit        BEGSR
 
      ** Reset Printer files indicators.
     C                   MOVEA     '000'         *IN(71)
 
      ** Get Customer Selection Details from data area.
     C                   IN        RPCust
 
      **----------  Set up Audit Report sub-heading fields ----------**
 
      ** If Account Officer Reference was selected.
     C     CSAcofCode    IFNE      *BLANKS
 
      ** Access to Account Officer Details, by using Access Object
      ** to get Account Officer Name.
     C                   CALL      'AOACOFR0'
     C                   PARM      *BLANKS       PRtnCde
     C                   PARM      '*KEY   '     POption
     C                   PARM      CSAcofCode    PAccOff
     C     Sdacof        PARM      Sdacof        Dssdy
 
      ** If no record found, handle database error.
     C     PRtnCde       IFNE      *BLANKS
     C     *lock         IN        Lda
     C                   EVAL      Dbpgm  = PSProcName
     C                   EVAL      Dbfile = 'SDACOFPD'
     C                   EVAL      Dbase  = 01
     C                   EVAL      Dbkey  = PAccOff
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      AUACOF = %Trim(WTbNarr(1)) + ' ' +
     C                                      AZACOC + ' ' + %Trim(AZACON) +
     C                                      ' ' + WTbNarr(2)
     C                   EVAL      W_Length = 132
     C                   EVAL      AUACOF = RPPrCenter(AUACOF:W_Length)
     C                   EVAL      *IN72  = *ON
 
     C                   ELSE
 
      ** If customer range was selected.
     C     CSFromCust    IFNE      'ALL'
     C                   EVAL      AUCUSB = CSFromCust
     C                   EVAL      AUCUSA = CSToCust
     C                   EVAL      *IN71  = *ON
     C                   ENDIF
 
     C                   ENDIF
 
      ** If Main Customer Branch was selected.
     C     CSMainBrch    IFNE      'ALL'
 
      ** Access to Branch Details, by ujsing Access Object,
      ** to get Branch name.
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       PRtnCde
     C                   PARM      '*KEY   '     POption
     C                   PARM      CSMainBrch    PBrch
     C     Sdbrch        PARM      Sdbrch        Dssdy
 
      ** If no record found, handle database error.
     C     PRtnCde       IFNE      *BLANKS
     C     *lock         IN        Lda
     C                   EVAL      Dbpgm  = PSProcName
     C                   EVAL      Dbfile = 'SDBRCHPD'
     C                   EVAL      Dbase  = 02
     C                   EVAL      Dbkey  = PBrch
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      AUBRCH = %Trim(WTbNarr(3)) + ' ' +
     C                                      CSMainBrch + ' ' + A8BRNM
     C                   EVAL      W_Length = 132
     C                   EVAL      AUBRCH = RPPrCenter(AUBRCH:W_Length)
     C                   EVAL      *IN73  = *ON
 
     C                   ENDIF
 
      ** Open Customer Master Details file.
     C**********         OPEN      SDCUSTPD                                                   206026
     C                   OPEN      SDCUSTPD                             99                    206026
 
      ** Reset work fields.
     C                   RESET                   W_OpenP1
     C                   RESET                   RCOUNT
 
      ***Open*Audit*Report*printer*file.*******************************                       206026
     C**********         OPEN      RP1467AU                                                   206026
 
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
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls:     SRAudit                                            *
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
     C                   EXSR      SRAudit
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
      *  Calls:     AOBANKR0, *PSSR, AOMMODR0                         *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Access Bank details by using access program.
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRtnCde
     C                   PARM      '*FIRST '     POption
     C     SdBank        PARM      SdBank        Dssdy
 
      ** If Bank details do not exist, handle database error.
     C     PRtnCde       IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      Dbpgm  = PSProcName
     C                   EVAL      Dbfile = 'SDBANKPD'
     C                   EVAL      Dbase  = 03
     C                   EVAL      Dbkey  = '*FIRST'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check if Portfolio Management Module is installed.
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       PRtnCde
     C                   PARM      '*FIRST'      POption
     C     Sdmmod        PARM      Sdmmod        Dsfdy
 
      ** If Midas Module Details were not found, handle database error.
     C     PRtnCde       IFNE      *BLANKS
     C     *lock         IN        Lda
     C                   EVAL      Dbpgm  = PSProcName
     C                   EVAL      Dbfile = 'SDMMODPD'
     C                   EVAL      Dbase  = 03
     C                   EVAL      Dbkey  = '*FIRST'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
**Ctdata WTbNarr
All Customers Account Officer
is responsible for
Main Customer Branch
**Ctdata WTbZMNM
JANFEBMARAPRMAIJUNJULAUGSEPOCTNOVDEC
