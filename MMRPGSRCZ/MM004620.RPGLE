     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Effective Interest Rate Details Report')      *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Module                                  *
      *                                                               *
      *  MM004620 - Midas MM Effective Interest Rate Details Report   *
      *                                                               *
      *  Function:  This program will be created to generate report   *
      *             for the Effective Interest Rate details.          *
      *                                                               *
      *  Called By: MMC004620 - Effective Int. Rate Details Report    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. CGL165             Date 17Feb15               *
      *  Prev Amend No. CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG12955           Date 19Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG12910           Date 18Dec06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG11346           Date 23May06               *
      *                 Bug9667            Date 29Dec05               *
      *                 232928             Date 08Apr05               *
      *                 CAS011             Date 16May05               *
      *                 CAS009  *CREATE    Date 04May04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  BUG12955 - Do not include non adjustment to yield fees in    *
      *             EIR Cash flow report.                             *
      *  BUG12910 - Amortised fees are not being printed because      *
      *             of incorrect filtering                            *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG11346 - Different amount on trade input to report         *
      *  Bug9667 - Incorrect report details.                          *
      *  232928 - Amortise all fees non-linearly, EIR calculation,    *
      *           Non-linear amortisation calculation & adjustment    *
      *  CAS011 - EIR/AC Accounting Upgrade to MP1                    *
      *  CAS009 - Effective Interest Rate/Amortised Cost Accounting   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    37         Multi-branch environment                        *
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
     FMM004620AUO    E             PRINTER
     F                                     INFDS(SPOOLU)
     FMM004620P1O    E             PRINTER USROPN
     F                                     INFDS(SPOOL1)
     FMM004620P2O    E             PRINTER USROPN
     F                                     INFDS(SPOOL2)
     F***DEALSL5   IF   E           K DISK                                                    CAS011
     FDEALSL8   IF   E           K DISK                                                       CAS011
     FMMEIRDL0  IF   E           K DISK
     FMMNPVAL0  IF   E           K DISK
     FMMCFSFL0  IF   E           K DISK
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
 
      ** File Information Data Structure for MM004620P1.
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
 
      ** File Information Data Structure for MM004620P2.
     D SPOOL2          DS
     D  SFILE2                83     92
     D  SFNUM2               123    124B 0
     D  OFLLN2               188    189B 0
     D  PRTLN2               367    368B 0
 
      ** File Information Data Structure for MM004620AU.
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
     D KDLNO           S              6S 0
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
     C*****KLOVAL        SETLL     DEALSL5                                                    CAS011
     C     KLOVAL        SETLL     DEALSL8                                                    CAS011
     C                   ELSE
     C*****KDEALS        SETLL     DEALSL5                                                    CAS011
     C     KDEALS        SETLL     DEALSL8                                                    CAS011
     C                   EVAL      SlBRCA = PRENT
     C                   ENDIF
 
     C**********         READ      DEALSL5                                                    CAS011
     C                   READ      DEALSL8                                                    CAS011
 
      ** If End of File or branch of record is not same as selected
      ** branch, write No Details to report.
 
     C**********         IF        %EOF(DEALSL5)                                              CAS011
     C                   IF        %EOF(DEALSL8)                                              CAS011
     C                             OR (SlBRCA <> *BLANKS)
     C                             AND (SlBRCA <> BRCA)
     C                   EXSR      Audit
     C                   ENDIF
 
      ** Do Until End of File.
 
     C**********         DOU       %EOF(DEALSL5)                                              CAS011
     C                   DOU       %EOF(DEALSL8)                                              CAS011
     C                             OR (SlBRCA <> *BLANKS)
     C                             AND (SlBRCA <> BRCA)
 
     C     DLNO          CHAIN     MMEIRDL0
 
      ** EIR record found
 
     C                   IF        %FOUND(MMEIRDL0)
 
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
 
     C**********         READ      DEALSL5                                                    CAS011
     C                   READ      DEALSL8                                                    CAS011
 
     C**********         IF        %EOF(DEALSL5)                                              CAS011
     C                   IF        %EOF(DEALSL8)                                              CAS011
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
 
     C                   WRITE     MM004620HA
 
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
      *****************************************************************
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
 
      ** DEALSDn details
 
     C                   MOVE      DLNO          RDLNO
     C                   EVAL      RCCY = CCY
     C                   EVAL      PCCY = CCY
 
     C                   IF        RCDT = 'D'                                               BUG11346
     C                   EVAL      ZFLD15 = FVAL                                            BUG11346
     C                   ELSE                                                               BUG11346
     C                   EVAL      ZFLD15 = PCPL
     C                   ENDIF                                                              BUG11346
     C                   EXSR      ZSEdit
     C                   EVAL      RCBAL  = ZOUT21
 
     C                   EVAL      ZFLD15 = TFDP
     C                   EXSR      ZSEdit
     C                   EVAL      RTFDP  = ZOUT21
 
     C                   EVAL      ZFLD15 = TFDPA
     C                   EXSR      ZSEdit
     C                   EVAL      RTFDPA = ZOUT21
 
     C                   EVAL      ZFLD15 = AFDP
     C                   EXSR      ZSEdit
     C                   EVAL      RAFDP  = ZOUT21
 
      ** MMEIRDPD details
 
     C                   EVAL      WEIEIR = EIEIR * 100
     C                   MOVE      WEIEIR        ZFIELD
     C                   EVAL      ZADEC = 10
     C                   EXSR      ZEdit2
     C                   EVAL      REIR   = ZFIELD
 
     C**********         EVAL      ZFLD15 = EIAMTD                                           Bug9667
     C                   EVAL      ZFLD15 = EIDPTD                                           Bug9667
     C                   EXSR      ZSEdit
     C                   EVAL      RACST  = ZOUT21
 
      ** MMNPVAPD details
 
     C     DLNO          CHAIN     MMNPVAL0
     C                   IF        %FOUND(MMNPVAL0)
     C                   EVAL      ZFLD15 = MNNPVA
     C                   EVAL      PCCY = MNCYCD
     C                   EXSR      ZSEdit
     C                   EVAL      RNPV   = ZOUT21
     C                   ENDIF
 
      ** Write P1 Header if required
 
     C                   Z-ADD     8             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     MM004620H1
     C                   ENDIF
 
      ** Write P1 EIR Format
 
     C                   WRITE     MM004620D1
 
      ** Write P2 Header if required
 
     C                   Z-ADD     9             RQDLN2
     C     OFLLN2        SUB       PRTLN2        DIFLN2
     C     DIFLN2        IFLE      RQDLN2
     C                   WRITE     MM004620H2
     C                   ENDIF
 
      ** Write P2 EIR format
 
     C                   WRITE     MM004620D2
 
      ** Report all Cash Flow records within an EIR period
 
     C     DLNO          SETLL     MMCFSFL0
     C     DLNO          READE     MMCFSFL0
 
     C                   DOW       NOT%EOF(MMCFSFL0)
     C                             AND (EISTDT <= MFFLDT)
     C                             AND (EIENDT >= MFFLDT)                                    Bug9667
     C**********                   AND (EIENDT > MFFLDT)                                     Bug9667
      ** This does not apply to records in EIR detail file since the end                    BUG12910
      ** date will always be the maturity date, therefore, there is no                      BUG12910
      ** more next period                                                                   BUG12910
     C**********         IF           MFFTYP = 'SFAM' AND MFFLDT = EIENDT            232928 BUG12910
     C**********                   OR MFFTYP = 'EFAC' AND MFFLDT = EIENDT            232928 BUG12910
     C**********                   OR MFFTYP = 'SFBT' AND MFFLDT = EIENDT            232928 BUG12910
      ***Fees*equal*to EIR Period End date belong to the next period.                232928 BUG12910
     C**********         ELSE                                                        232928 BUG12910
     C                   IF        MFFTYP <> 'EFAN' AND                                     BUG12955
     C                             MFFTYP <> 'SFAN' AND                                     BUG12955
     C                             MFFTYP <> 'SFBN'                                         BUG12955
 
     C                   EVAL      RDTYP  = MFDTYP
 
     C                   IF        MFADLN <> *ZEROS
     C                   MOVE      MFADLN        RSOLD
     C                   ELSE
     C                   EVAL      RSOLD = *BLANKS
     C                   ENDIF
 
     C                   MOVE      MFCNUM        RCNUM
     C                   Z-ADD     MFNDYP        WNDYP
 
      ** Report Cashflow date instead.                                                       Bug9667
                                                                                             Bug9667
     C                   EVAL      RDATE = MFDATE                                            Bug9667
                                                                                             Bug9667
     C**********         MOVE      *BLANKS       RDENDS                                      Bug9667
     C**********         MOVE      *BLANKS       RDEND                                       Bug9667
     C**********         SELECT                                                              Bug9667
     C**********         WHEN      WNDYP < 0                                                 Bug9667
     C*****WNDYP         MULT      -1            WNDYP                                       Bug9667
     C**********         MOVE      '-'           RDENDS                                      Bug9667
     C**********         MOVE      WNDYP         RDEND                                       Bug9667
     C**********         WHEN      WNDYP > 0                                                 Bug9667
     C**********         MOVE      WNDYP         RDEND                                       Bug9667
     C**********         ENDSL                                                               Bug9667
 
     C                   EVAL      ZFLD15 = MFCAMT
     C                   EVAL      PCCY = MFCYCD
     C                   EXSR      ZSEdit
     C                   EVAL      RCSFL  = ZOUT21
 
     C                   EVAL      RTYPE  = MFFTYP
 
     C                   EVAL      ZFIELD = *BLANKS
     C                   Z-ADD     MFIRAT        VarRat1
     C                   MOVE      VarRat1       ZFIELD
     C                   EVAL      ZADEC = 8
     C                   EXSR      ZEdit2
     C                   MOVE      ZFIELD        RINTR
 
     C                   MOVE      MFICBS        RCALC
     C                   EVAL      RYIELD = MFYLDC
 
     C                   EVAL      ZFIELD = *BLANKS
     C                   Z-ADD     MFDSCF        VarRat2
     C                   MOVE      VarRat2       ZFIELD
     C                   EVAL      ZADEC = 9
     C                   EXSR      ZEdit2
     C                   MOVE      ZFIELD        RDISC
 
      ** Write P2 Header and EIR format if required
 
     C                   Z-ADD     1             RQDLN2
     C     OFLLN2        SUB       PRTLN2        DIFLN2
     C     DIFLN2        IFLE      RQDLN2
     C                   WRITE     MM004620H2
     C                   WRITE     MM004620D2
     C                   ENDIF
 
      ** Write P2 Cash Flow format
 
     C                   WRITE     MM004620D3
 
                                                                                              232928
     C**********         ENDIF                                                       232928 BUG12910
     C                   ENDIF                                                              BUG12955
      ** Read next Cash Flow record
 
     C     DLNO          READE     MMCFSFL0
 
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
     C                   OPEN      MM004620P1
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
 
     C                   WRITE     MM004620H1
 
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
     C                   OPEN      MM004620P2
     C                   EVAL      P2OPEN = 'Y'
     C                   ENDIF
 
      ** Ensure Report Spool File recorded by RCF.
 
     C                   Z-ADD     SFNUM2        ZSNUM
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    ZSEQ
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
 
     C                   WRITE     MM004620H2
 
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
     C                   WRITE     MM004620H1
     C                   ENDIF
 
      ** Write Footer
 
     C                   WRITE     MM004620F1
      *
      ** Close the spool file
      *
     C     P1OPEN        IFEQ      'Y'
     C                   CLOSE     MM004620P1
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
     C                   WRITE     MM004620H2
     C                   ENDIF
 
      ** Write Footer
 
     C                   WRITE     MM004620F2
 
      ** Close the spool file
 
     C     P2OPEN        IFEQ      'Y'
     C                   CLOSE     MM004620P2
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
     C                   KFLD                    KDLNO
 
     C     KDEALS        KLIST
     C                   KFLD                    PRENT
     C                   KFLD                    KDLNO
 
     C                   EVAL      KBRCA = *BLANKS
     C                   EVAL      KDLNO = 0
 
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
     C*                  PARM      'J'           ZECODE
     C                   PARM      *BLANKS       ZECODE
     C                   PARM                    ZOUT21
 
     C                   ENDSR
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
 
     C                   EXSR      AUDIT
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2004
