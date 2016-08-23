     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Effective Interest Rate Details Report')      *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE004620 - Midas LE Effective Interest Rate Details Report   *
      *                                                               *
      *  Function:  This program will be created to generate report   *
      *             for the Effective Interest Rate details.          *
      *                                                               *
      *  Called By: LEC004620 - Effective Int. Rate Details Report    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG13079A          Date 26Feb07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 BUG13136           Date 24Jan07               *
      *                 BUG13088           Date 19Jan07               *
      *                 BUG13032           Date 12Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 Bug9668            Date 02Jan06               *
      *                 232628             Date 14Mar05               *
      *                 232322             Date 28Feb05               *
      *                 232321             Date 28Feb05               *
      *                 232312             Date 28Feb05               *
      *                 CAS009  *CREATE    Date 04May04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  BUG13079A - Discount/Premiums was included in Total Adj.     *
      *              to yield fees.                                   *
      *  BUG13136 - Initialise the report detail lines                *
      *  BUG13088 - Linear fee should not be reflected in the         *
      *             LE004620P2 report                                 *
      *  BUG13032 - Missing report title (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type                              *
      *  Bug9668 - Include fees paid on maturity date.                *
      *  232628 - CAS009 Rollover patch (LE).                         *
      *  232322 - LEC004620 failing although it has a dump            *
      *  232321 - Cashflow Date should be shown in report             *
      *  232312 - List All Cashflows within the EIR Period            *
      *  CAS009 - Effective Interest Rate/Amortised Cost Accounting   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    37         Multi-branch Indicator                          *
      *                                                               *
      *    98         Date Format                                     *
      *                                                               *
      *    90-99      Used by Standard Subroutines                    *
      *    U7+U8      Database Error                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FLE004620AUO    E             PRINTER
     F                                     INFDS(SPOOLU)
     FLE004620P1O    E             PRINTER USROPN
     F                                     INFDS(SPOOL1)
     FLE004620P2O    E             PRINTER USROPN
     F                                     INFDS(SPOOL2)
     FCLOANLB   IF   E           K DISK
     FLEEIRDL0  IF   E           K DISK
     FLENPVAL0  IF   E           K DISK
     FLECFSFL0  IF   E           K DISK
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ External data areas                  ¦
      ** ¦ ===================                  ¦
      ** +--------------------------------------+
 
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
 
      ** Program Status Data Structure
      /COPY ZACPYSRC,PSDS
 
      ** File Information Data Structure for LE004620P1.
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
 
      ** File Information Data Structure for LE004620P2.
     D SPOOL2          DS
     D  SFILE2                83     92
     D  SFNUM2               123    124B 0
     D  OFLLN2               188    189B 0
     D  PRTLN2               367    368B 0
 
      ** File Information Data Structure for LE004620AU.
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
     D  OFLLNU               188    189B 0
     D  PRTLNU               367    368B 0
 
      ** First DS for Access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for Access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** External data structure for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External data structure for Module Details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** External data structure for Branch Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** External data structure for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Whether or not *PSSR has been run previously
     D RunBefore       S              1A
 
      ** --- Start of fields used by access programs -----------------------------------------------
      ** Return code
     D PRtCd           S              7A
      ** Option
     D POpTn           S              7A
      ** Switchable feature ID (for AOSARDR0)
     D PSARD           S              6A
      ** Branch key
     D PBRCA           S              3A
      ** Currency key
     D PCCY            S              3A
      ** --- End of fields used by access programs -------------------------------------------------
 
      ** ZSEdit parms
     D ZFLD15          S             15P 0
     D ZDECS           S              1P 0
     D ZECODE          S              1A
     D ZOUT21          S             21A
 
      ** ZEdit2 parms
     D ZFIELD          S             16A
     D ZADEC           S              2P 0
 
      ** ZSFile parms
     D ZSEQ            S              5A
     D ZSENTY          S              3A
     D ZSNUM           S              6S 0
     D ZSERR           S              1A
 
     D PRSEQ           S              5A
     D PRENT           S              3A
     D P1OPEN          S              1A
     D P2OPEN          S              1A
     D RQDLN1          S              3S 0
     D RQDLN2          S              3S 0
     D DIFLN1          S              3S 0
     D DIFLN2          S              3S 0
     D SlBRCA          S              3A
     D SvBRCA          S              3A
     D VarRat1         S             13P 8
     D VarRat2         S             13P 9
     D KBRCA           S              3A
     D*KLNRF****       S              6S 0                                                    CLE148
     D KLNRF           S              6A                                                      CLE148
     D WNDYP           S              5S 0
     D WEIEIR          S             16S10
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      ** MAIN PROCEDURE                                                   *
      *********************************************************************
 
      ** Perform Initialisation.
 
     C                   EXSR      Init
 
      ** Perform Detail Processing.
 
     C                   EXSR      Proces
 
      ** Output Audit Report and End Program.
 
     C                   EXSR      Audit
 
      *********************************************************************
      /EJECT
      /TITLE SR/Init
      *****************************************************************
      *                                                               *
      *  Init - Subroutine to do Program Initialisation.              *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
 
     C     Init          BEGSR
 
     C                   MOVE      'N'           P1OPEN
     C                   MOVE      'N'           P2OPEN
 
      ** Report Work fields.
 
     C                   Z-ADD     0             RQDLN1
     C                   Z-ADD     0             DIFLN1
 
     C                   Z-ADD     0             RQDLN2
     C                   Z-ADD     0             DIFLN2
 
     C                   Z-ADD     0             RCOUNT
 
     C                   MOVE      *BLANKS       SlBRCA
     C                   MOVE      *BLANKS       SvBRCA
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      /TITLE SR/Proces
      *****************************************************************
      *                                                               *
      *  Proces - Subroutine to do the Detail Processing.             *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls:                                                       *
      *    Audit - Output Audit report                                *
      *    ClsP1 - Close P1                                           *
      *    ClsP2 - Close P2                                           *
      *    OpnP1 - Open P1                                            *
      *    OpnP2 - Open P2                                            *
      *    Report - Output Detail lines                               *
      *                                                               *
      *****************************************************************
 
     C     Proces        BEGSR
 
      ** Read first record from File.
 
     C                   IF        (PRENT = 'ALL') OR (PRENT = *BLANKS)
     C     KLOVAL        SETLL     CLOANLB
     C                   ELSE
     C     KLOANS        SETLL     CLOANLB
     C                   EVAL      SlBRCA = PRENT
     C                   ENDIF
 
     C                   READ      CLOANLB
 
      ** If End of File or branch of record is not same as selected
      ** branch, write No Details to report.
 
     C                   IF        %EOF(CLOANLB)
     C                             OR (SlBRCA <> *BLANKS)
     C                             AND (SlBRCA <> BRCA)
     C                   EXSR      Audit
     C                   ENDIF
 
      ** Do Until End of File.
 
     C                   DOU       %EOF(CLOANLB)
     C                             OR (SlBRCA <> *BLANKS)
     C                             AND (SlBRCA <> BRCA)
 
     C     LNRF          CHAIN     LEEIRDL0
 
      ** EIR record found
 
     C                   IF        %FOUND(LEEIRDL0)
 
      ** Count records read.
 
     C                   ADD       1             RCOUNT
 
      ** Check for change in Branch.
 
     C                   IF        BRCA <> SvBRCA
 
      ** Close the previous branch's spool files
 
     C                   IF        SvBRCA <> *BLANKS
     C                   EXSR      ClsP1
     C                   EXSR      ClsP2
     C                   ENDIF
 
      ** Access the next Branch's Details
 
     C                   EVAL      PBRCA = BRCA
     C                   EXSR      AOBRCH
     C                   EVAL      RBRCA = A8BRCD
     C                   EVAL      RBRNM = A8BRNM
 
      ** Open the next branch's spool files
 
     C                   EXSR      OpnP1
     C                   EXSR      OpnP2
 
     C                   EVAL      SvBRCA = BRCA
 
     C                   ENDIF
 
      ** Process Report Lines.
 
     C                   EXSR      Report
 
     C                   ENDIF
 
      ** Read next record.
 
     C                   READ      CLOANLB
 
     C                   IF        %EOF(CLOANLB)
     C                             OR (SlBRCA <> *BLANKS)
     C                             AND (SlBRCA <> BRCA)
     C     P1OPEN        IFEQ      'Y'
     C                   EXSR      ClsP1
     C                   ENDIF
     C     P2OPEN        IFEQ      'Y'
     C                   EXSR      ClsP2
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      /TITLE SR/Audit
      *****************************************************************
      *                                                               *
      *  Audit - Subroutine to Output Audit report and End Program.   *
      *                                                               *
      *  Called By: Main Processing, Proces, *PSSR                    *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
 
     C     Audit         BEGSR
 
      ** Ensure Report Spool File recorded by RCF.
 
     C                   Z-ADD     SFNUMU        ZSNUM
 
     C                   CALL      'ZSFILE'
     C                   PARM                    ZSEQ
     C                   PARM                    ZSENTY
     C                   PARM                    SFILEU
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
 
     C     ZSERR         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
 
      ** Output Report Header.
 
     C                   WRITE     LE004620HA
 
     C                   SELECT
 
      ** If there is a DB Error, output the DB Error Information.
 
     C                   WHEN      (*INU7 = *ON)
     C                   WRITE     DBERROR
 
      ** If no records read, Output "No Details" message.
 
     C                   WHEN      (RCOUNT = 0)
     C                   WRITE     NODTLS
 
      ** If no records read, Output "No Details" message.
 
     C                   WHEN      (RCOUNT > 0)
     C                   WRITE     DTLS
 
     C                   ENDSL
 
      ** End Program and Return.
 
     C                   SETON                                        LR
     C                   RETURN
 
     C                   ENDSR
      /EJECT
      /TITLE SR/REPORT
      *****************************************************************
      *                                                               *
      *  Report - Process Report Lines.                               *
      *                                                               *
      *  Called By: Proces                                            *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
     C     Report        BEGSR
 
      ** Initialise detail lines                                                            BUG13136
                                                                                            BUG13136
     C                   CLEAR                   LE004620D1                                 BUG13136
     C                   CLEAR                   LE004620D2                                 BUG13136
     C                   CLEAR                   LE004620D3                                 BUG13136
                                                                                            BUG13136
      ** CLOANCL details
 
     C                   MOVE      LNRF          RLNRF
     C                   EVAL      RCCY = CCY
     C                   EVAL      PCCY = CCY
     C                   MOVE      CNUM          RCNUM                                        232321
     C*******************EVAL******RLTYP  = LTYP + '-' + SUTP                          232321 CLE042
     C                   EVAL      RLTYP  = LTYP + '-' + SUTP + CLAS                          CLE042
 
     C                   EVAL      ZFLD15 = CPAM
     C                   EXSR      ZSEdit
     C                   EVAL      RCBAL  = ZOUT21
 
     C                   EVAL      ZFLD15 = TFDP
     C                   EXSR      ZSEdit
     C                   EVAL      RTFDP  = ZOUT21
                                                                                           BUG13079A
      ** Only include Fees and not the discounts/premiums                                  BUG13079A
                                                                                           BUG13079A
     C**********         EVAL      ZFLD15 = TFDPA                                          BUG13079A
     C                   EVAL      ZFLD15 = TFDPA - TOTI                                   BUG13079A
     C                   EXSR      ZSEdit
     C                   EVAL      RTFDPA = ZOUT21
 
     C                   EVAL      ZFLD15 = AFDP
     C                   EXSR      ZSEdit
     C                   EVAL      RAFDP  = ZOUT21
 
      ** LEEIRDPD details
 
     C                   EVAL      WEIEIR = EIEIR * 100
     C                   MOVE      WEIEIR        ZFIELD
     C                   EVAL      ZADEC = 10
     C                   EXSR      ZEdit2
     C                   EVAL      REIR   = ZFIELD
 
     C**********         EVAL      ZFLD15 = EIAMTD                                           Bug9668
     C                   EVAL      ZFLD15 = EIDPTD                                           Bug9668
     C                   EXSR      ZSEdit
     C                   EVAL      RACST  = ZOUT21
 
      ** LENPVAPD details
 
     C     LNRF          CHAIN     LENPVAL0
     C                   IF        %FOUND(LENPVAL0)
     C                   EVAL      ZFLD15 = LNNPVA
     C                   EVAL      PCCY = LNCYCD
     C                   EXSR      ZSEdit
     C                   EVAL      RNPV   = ZOUT21
     C                   ENDIF
 
      ** Write P1 Header if required
 
     C                   Z-ADD     8             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     LE004620H1
     C                   ENDIF
 
      ** Write P1 EIR Format
 
     C                   WRITE     LE004620D1
 
      ** Write P2 Header if required
 
     C                   Z-ADD     9             RQDLN2
     C     OFLLN2        SUB       PRTLN2        DIFLN2
     C     DIFLN2        IFLE      RQDLN2
     C                   WRITE     LE004620H2
     C                   ENDIF
 
      ** Write P2 EIR format
 
     C                   WRITE     LE004620D2
 
      ** Report all Cash Flow records within an EIR period
 
     C     LNRF          SETLL     LECFSFL0
     C     LNRF          READE     LECFSFL0
 
     C                   DOW       NOT%EOF(LECFSFL0)
     C**********                   AND (EISTDT <= LFFLDT)                                     232312
     C**********                   AND (EIENDT > LFFLDT)                                      232312
     C                   IF           LFFTYP = 'SFAM' AND LFFLDT = EIENDT                     232628
     C                             AND EIENDT <> MDAT                                        Bug9668
     C                             OR LFFTYP = 'EFAC' AND LFFLDT = EIENDT                     232628
     C                             AND EIENDT <> MDAT                                        Bug9668
     C                             OR LFFTYP = 'SFBT' AND LFFLDT = EIENDT                     232628
     C                             AND EIENDT <> MDAT                                        Bug9668
     C                             OR  LFFTYP = 'EFAN'                                      BUG13088
     C                             OR  LFFTYP = 'SFAN'                                      BUG13088
     C                             OR  LFFTYP = 'SFBN'                                      BUG13088
      ** Fees equal to EIR Period End date belong to the next period.                         232628
     C                   ELSE                                                                 232628
     C                   IF        (EISTDT <= LFFLDT)                                         232312
     C                             AND (EIENDT >= LFFLDT)                                     232312
     C                             AND LFIOIN <> 'S'                                          232628
 
     C**********         EVAL      RLTYP  = LFFTYP                                            232321
     C**********         IF        LFADLN = 0                                          232321 CLE148
     C                   IF        LFADLN = *BLANKS                                           CLE148
     C                   MOVE      *BLANKS       RSOLD                                        232321
     C                   ELSE                                                                 232321
     C                   MOVE      LFADLN        RSOLD
     C                   ENDIF                                                                232321
     C**********         MOVE      LFCNUM        RCNUM                                        232321
     C                   MOVE      LFNDYP        WNDYP
 
     C**********         MOVE      *BLANKS       RDENDS                                       232321
     C**********         MOVE      *BLANKS       RDEND                                        232321
     C**********         SELECT                                                               232321
     C**********         WHEN      WNDYP < 0                                                  232321
     C*****WNDYP         MULT      -1            WNDYP                                        232321
     C**********         MOVE      '-'           RDENDS                                       232321
     C**********         MOVE      WNDYP         RDEND                                        232321
     C**********         WHEN      WNDYP > 0                                                  232321
     C**********         MOVE      WNDYP         RDEND                                        232321
     C**********         ENDSL                                                                232321
 
     C                   EVAL      RCDATE = LFDATE                                            232321
     C                   EVAL      ZFLD15 = LFCAMT
     C                   EVAL      PCCY = LFCYCD
     C                   EXSR      ZSEdit
     C                   EVAL      RCSFL  = ZOUT21
 
     C                   EVAL      RTYPE  = LFFTYP
 
     C                   EVAL      ZFIELD = *BLANKS
     C                   Z-ADD     LFIRAT        VarRat1
     C                   MOVE      VarRat1       ZFIELD
     C                   EVAL      ZADEC = 8
     C                   EXSR      ZEdit2
     C                   MOVE      ZFIELD        RINTR
 
     C                   MOVE      LFICBS        RCALC
     C                   EVAL      RYIELD = LFYLDC
 
     C                   EVAL      ZFIELD = *BLANKS
     C                   Z-ADD     LFDSCF        VarRat2
     C                   MOVE      VarRat2       ZFIELD
     C                   EVAL      ZADEC = 9
     C                   EXSR      ZEdit2
     C                   MOVE      ZFIELD        RDISC
 
      ** Write P2 Header and EIR format if required
 
     C                   Z-ADD     1             RQDLN2
     C     OFLLN2        SUB       PRTLN2        DIFLN2
     C     DIFLN2        IFLE      RQDLN2
     C                   WRITE     LE004620H2
     C                   WRITE     LE004620D2
     C                   ENDIF
 
      ** Write P2 Cash Flow format
 
     C                   WRITE     LE004620D3
     C                   ENDIF                                                                232312
                                                                                              232628
     C                   ENDIF                                                                232628
 
      ** Read next Cash Flow record
 
     C     LNRF          READE     LECFSFL0
 
      ** ENDDO of Cash flows within an EIR period
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      /TITLE SR/OpnP1
      *****************************************************************
      *                                                               *
      *  OpnP1  - Open P1 processing.                                 *
      *                                                               *
      *****************************************************************
 
     C     OpnP1         BEGSR
 
     C                   IF        P1OPEN = 'N'
     C                   OPEN      LE004620P1
     C                   EVAL      P1OPEN = 'Y'
     C                   ENDIF
 
      ** Ensure Report Spool File recorded by RCF.
 
     C                   Z-ADD     SFNUM1        ZSNUM
 
     C                   CALL      'ZSFILE'
     C                   PARM                    ZSEQ
     C                   PARM                    ZSENTY
     C                   PARM                    SFILE1
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
 
     C     ZSERR         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
 
      ** Write Header
 
     C                   WRITE     LE004620H1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      /TITLE SR/OpnP2
      *****************************************************************
      *                                                               *
      *  OpnP2  - Open P2 processing.                                 *
      *                                                               *
      *****************************************************************
 
     C     OpnP2         BEGSR
 
     C                   IF        P2OPEN = 'N'
     C                   OPEN      LE004620P2
     C                   EVAL      P2OPEN = 'Y'
     C                   ENDIF
 
      ** Ensure Report Spool File recorded by RCF.
 
     C                   Z-ADD     SFNUM2        ZSNUM
      *
     C                   CALL      'ZSFILE'
     C                   PARM      PRSEQ         ZSEQ
     C                   PARM                    ZSENTY
     C                   PARM                    SFILE2
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
 
     C     ZSERR         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
 
      ** Write Header
 
     C                   WRITE     LE004620H2
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      /TITLE SR/ClsP1
      *****************************************************************
      *                                                               *
      *  ClsP1 - Close P1 Processing.                                 *
      *                                                               *
      *  Called By: PROCES                                            *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     ClsP1         BEGSR
 
      ** Check that sufficient lines remain for the Footer. If not,
      ** write out the Header on a new page.
 
     C                   Z-ADD     2             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     LE004620H1
     C                   ENDIF
 
      ** Write Footer
 
     C                   WRITE     LE004620F1
      *
      ** Close the spool file
      *
     C     P1OPEN        IFEQ      'Y'
     C                   CLOSE     LE004620P1
     C                   MOVE      'N'           P1OPEN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      /TITLE SR/ClsP2
      *****************************************************************
      *                                                               *
      *  ClsP2 - Close P2 Processing.                                 *
      *                                                               *
      *  Called By: PROCES                                            *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     ClsP2         BEGSR
 
      ** Check that sufficient lines remain for the Footer. If not,
      ** write out the Header on a new page.
 
     C                   Z-ADD     4             RQDLN2
     C     OFLLN2        SUB       PRTLN2        DIFLN2
     C     DIFLN2        IFLE      RQDLN2
     C                   WRITE     LE004620H2
     C                   ENDIF
 
      ** Write Footer
 
     C                   WRITE     LE004620F2
 
      ** Close the spool file
 
     C     P2OPEN        IFEQ      'Y'
     C                   CLOSE     LE004620P2
     C                   MOVE      'N'           P2OPEN
     C                   ENDIF
 
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
 
     C     *Entry        PLIST
     C                   PARM                    PRSEQ
     C                   PARM                    PRENT
 
     C     *DTAARA       DEFINE                  LDA
 
      ** Call Access Program for Bank Details - Title, Run Date and
      ** Run Day Number.
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        (PRtCd <> *BLANKS)
 
      ** Data base error in file SDBANKPD
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDBANKPD'
     C                   EVAL      DBKEY  =  '*FIRST'
     C                   EVAL      DBASE  =  001
      /COPY ZACPYSRC,DBFIELDS
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ENDIF
 
      ** Access the Midas Modules
 
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDMMOD        PARM      SDMMOD        DSSDY
 
     C                   IF        PRtcd <> *Blanks
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
 
      ** Check System Date Format, DDMMYY (*IN98 off)
      **                           MMDDYY (*IN98 on).
 
     C     BJDFIN        IFEQ      'M'
     C                   SETON                                        98
     C                   ENDIF
 
     C     KLOVAL        KLIST
     C                   KFLD                    KBRCA
     C                   KFLD                    KLNRF
 
     C     KLOANS        KLIST
     C                   KFLD                    PRENT
     C                   KFLD                    KLNRF
 
     C                   EVAL      KBRCA = *BLANKS
     C**********         EVAL      KLNRF = 0                                                  CLE148
     C                   EVAL      KLNRF = *BLANKS                                            CLE148
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      /TITLE SR/ZSEdit
      *****************************************************************
      *                                                               *
      *  ZSEdit - Call to 'ZSEDIT'                                    *
      *                                                               *
      *****************************************************************
 
     C     ZSEdit        BEGSR
 
     C                   EXSR      AOCURR
     C                   EVAL      ZDECS = A6NBDP
 
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM      'J'           ZECODE
     C                   PARM                    ZOUT21
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      /TITLE SR/ZEdit2
      *****************************************************************
      *                                                               *
      *  ZEdit2 - Call to 'ZEDIT2'                                    *
      *                                                               *
      *****************************************************************
 
     C     ZEdit2        BEGSR
 
     C                   CALLB     'ZEDIT2'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      /TITLE SR/AOBRCH
      *****************************************************************
      *                                                               *
      *  AOBRCH - Call to 'AOBRCHR1'                                  *
      *                                                               *
      *****************************************************************
 
     C     AOBRCH        BEGSR
 
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POptn
     C                   PARM                    PBRCA
     C     SDBRCH        PARM      SDBRCH        DSSDY
 
     C                   IF        (PRtCd <> *BLANKS)
 
      ** Data base error in file SDBRCHPD
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDBRCHPD'
     C                   EVAL      DBKEY  =  PBRCA
     C                   EVAL      DBASE  =  002
      /COPY ZACPYSRC,DBFIELDS
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      /TITLE SR/AOCURR
      *****************************************************************
      *                                                               *
      *  AOCURR - Call to 'AOCURRR0                                   *
      *                                                               *
      *****************************************************************
 
     C     AOCURR        BEGSR
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCCY
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        (PRtCd <> *BLANKS)
 
      ** Data base error in file SDBRCHPD
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDCURRPD'
     C                   EVAL      DBKEY  =  PCCY
     C                   EVAL      DBASE  =  003
      /COPY ZACPYSRC,DBFIELDS
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
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
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   IF        RunBefore = *BLANK
     C                   DUMP
     C                   EVAL      RunBefore = 'Y'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON                                                232322
     C                   EVAL      *INU8 = *ON                                                232322
     C                   EVAL      *INLR = *ON                                                232322
     C                   EXSR      AUDIT
     C**********         EVAL      *INU7 = *ON                                                232322
     C**********         EVAL      *INU8 = *ON                                                232322
     C**********         EVAL      *INLR = *ON                                                232322
 
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2004
