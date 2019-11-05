     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Effective Interest Rate Details Report')      *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE004621 - Midas LE Effective Interest Rate Details Report   *
      *                                                               *
      *  Function:  This program will be created to generate report   *
      *             for the Effective Interest Rate details.          *
      *                                                               *
      *  Called By: LEC004621 - Effective Int. Rate Details Report    *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 AR784436           Date 22Jun11               *
      *                 AR747614           Date 25May11               *
      *                 AR695779           Date 31Jan10               *
      *                 262607             Date 27Jan10               *
      *                 262618             Date 17Mar09               *
      *                 258459             Date 14Jan09               *
      *                 262550             Date 23Dec08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG17318           Date 04Apr08               *
      *                 BUG17295           Date 02Apr08               *
      *                 BUG17292           Date 02Apr08               *
      *                 BUG17223           Date 28Mar08               *
      *                 BUG17291           Date 28Mar08               *
      *                 BUG17294           Date 26Mar08               *
      *                 CAS019             Date 24Mar07               *
      *                 240763             Date 17Apr06               *
      *                 CAS016  *CREATE    Date 28Feb06               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  AR784436 - Wrong amortised F/D/P to date and amortised cost  *
      *             after change in base rate                         *
      *  AR747614 - EIR not computed for amortising fee with          *
      *             amortised separate indicator Y.                   *
      *             (Child: Artf747615)                               *
      *  AR695779 - Additional coding requirement for CAS016 fixes    *
      *           - Some fully prepaid loans still reported despite   *
      *             262607. (Child: AR695780).                        *
      *  262607 - Don't report fully prepaid loans                    *
      *  262618 - Ignore Past Due cash flows to avoid duplication of  *
      *           events. Rework of core fix 258942.                  *
      *  258459 - Incorrect Amortised Cost amount indicated on        *
      *           LE004621P1. Move EIDPTD instead of EIAMTD to RACST  *
      *           Fix patterned to BUG9668.                           *
      *  262550   - Avoid repetition of loan details.                 *
      *             Output correct dates on separate fees.            *
      *             Output EIR on separate fees.                      *
      *             Remove selections on cash flow type.              *
      *  BUG17318 - xxEyyN_nnF account key has incorrect amount       *
      *             Addition of Fee currency in LE004621 Report       *
      *  BUG17295 - Fees on End Date not being reported               *
      *  BUG17292 - Wrong amount displayed for Total Amortising Fees  *
      *  BUG17223 - NPV amounts of some loans are copied from the     *
      *             immediately preceding loan with attached yield    *
      *             curve                                             *
      *  BUG17291 - Applied fix BUG15532                              *
      *  BUG15532 - Incorrect EIR Reporting for Amortised Over Period *
      *             fees                                              *
      *  BUG17294 -Fees/Discount Amount is more appropriate column    *
      *            name as this includes disc. computed nonlinearly   *
      *            (Recompile)                                        *
      *  CAS019 - Upgrade of CAS016 to Midas Plus                     *
      *  240763 - Changed RQDLN1 from 4 to 6                          *
      *  CAS016 - IAS18 EIR Recalculation (Fee Amortisation Over      *
      *           Whole Period)                                       *
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
     FLE004621AUO    E             PRINTER
     F                                     INFDS(SPOOLU)
     FLE004621P1O    E             PRINTER USROPN
     F                                     INFDS(SPOOL1)
     FLE004621P2O    E             PRINTER USROPN
     F                                     INFDS(SPOOL2)
     FCLOANLB   IF   E           K DISK
     FLEEIRDLD  IF   E           K DISK
     FLENPVAL0  IF   E           K DISK
     FLECFSFL0  IF   E           K DISK
     F***LEFEEDLC  IF   E           K DISK                                                    262550
     FLEFEEDLN  IF   E           K DISK                                                       262550
     FLEFEEDLD  IF   E           K DISK                                                     BUG15532
     F                                     RENAME(LEFEEDF:LEFEEDF1)                         BUG15532
     F***LEERAPL0  IF   E           K DISK                                                  BUG15532
     FLEERAPL2  IF   E           K DISK                                                     BUG15532
     FLEEIRAL5  IF   E           K DISK
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
 
      ** File Information Data Structure for LE004621P1.
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
 
      ** File Information Data Structure for LE004621P2.
     D SPOOL2          DS
     D  SFILE2                83     92
     D  SFNUM2               123    124B 0
     D  OFLLN2               188    189B 0
     D  PRTLN2               367    368B 0
 
      ** File Information Data Structure for LE004621AU.
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
 
      ** External data structure for Fee Details
     D SDFEE         E DS                  EXTNAME(SDFEEPD)
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
     D KFSEQ           S              2S 0                                                  BUG17295
     D WNDYP           S              5S 0
     D WEIEIR          S             16S10
     D PFEE            S              2A
     D WFAMT           S             16S 0
     D WAAMT           S             16S 0
     D WFLAG           S              1A
     D WEIRDF          S              1A                                                    BUG15532
     D WERAPF          S              1A                                                    BUG15532
     D WWSTDT          S              5P 0                                                  AR784436
     D WREPORT         S              1A                                                    AR784436
 
     D ZDAYNO          S              5  0
     D ZDATE           S              6  0
     D ZADATE          S              7A
 
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
                                                                                              262607
      ** If loan fully prepaid skip it                                                        262607
     C                   DOW       CPAM = *ZERO                                               262607
     C                             AND VDAT < BJRDNB                                          262607
     C                   READ      CLOANLB                                                    262607
     C                   ENDDO                                                                262607
 
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
 
      ** Initialise Work Fields                                                             BUG15532
     C                   EVAL      WEIRDF = 'N'                                             BUG15532
     C                   EVAL      WERAPF = 'N'                                             BUG15532
      *                                                                                     BUG15532
     C     LNRF          CHAIN     LEEIRDLD                           01
                                                                                              262607
      ** If loan fully prepaid skip it                                                        262607
     C                   IF        CPAM = *ZERO                                               262607
     C                             AND VDAT < BJRDNB                                          262607
     C                   MOVE      *ON           *IN01                                        262607
     C                   ENDIF                                                                262607
 
      ** EIR record found
 
     C**********         IF        *IN01 = *ON                                              BUG15532
     C*****LNRF*         CHAIN     LEERAPL0                           01                    BUG15532
     C**********         ENDIF                                                              BUG15532
 
      ** Count records read.
 
     C                   IF        *IN01 = *OFF
     C                   ADD       1             RCOUNT
                                                                                            BUG15532
      ** Record found in EIRD File                                                          BUG15532
     C                   EVAL      WEIRDF = 'Y'                                             BUG15532
 
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
      ** If loan fully prepaid skip SR/Proces1                                              AR695779
     C                   IF        CPAM = *ZERO                                             AR695779
     C                             AND VDAT < BJRDNB                                        AR695779
     C                   ELSE                                                               AR747614
                                                                                            BUG15532
      ** Process Fees from LEERAPPD - Amortised Over Period File                            BUG15532
     C                   EXSR      Proces1                                                  BUG15532
     C                   ENDIF                                                              AR695779
 
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
      *****************************************************************                     BUG15532
      /EJECT                                                                                BUG15532
      /TITLE SR/Proces1                                                                     BUG15532
      *****************************************************************                     BUG15532
      *                                                               *                     BUG15532
      *  Proces1 - Subroutine to do the Detail Processing - LEERAPPD  *                     BUG15532
      *                                                               *                     BUG15532
      *  Called By: Proces                                            *                     BUG15532
      *  Calls:                                                       *                     BUG15532
      *                                                               *                     BUG15532
      *****************************************************************                     BUG15532
                                                                                            BUG15532
     C     Proces1       BEGSR                                                              BUG15532
      *                                                                                     BUG15532
     C     LNRF          CHAIN     LEERAPL2                           02                    BUG15532
      *                                                                                     BUG15532
     C                   IF        *IN02 = *OFF                                             BUG15532
      *                                                                                     BUG15532
     C                   EVAL      WERAPF = 'Y'                                             BUG15532
      ** Check for change in Branch.                                                        BUG15532
                                                                                            BUG15532
     C                   IF        BRCA <> SvBRCA                                           BUG15532
                                                                                            BUG15532
      ** Close the previous branch's spool files                                            BUG15532
                                                                                            BUG15532
     C                   IF        SvBRCA <> *BLANKS                                        BUG15532
     C                   EXSR      ClsP1                                                    BUG15532
     C                   EXSR      ClsP2                                                    BUG15532
     C                   ENDIF                                                              BUG15532
                                                                                            BUG15532
      ** Access the next Branch's Details                                                   BUG15532
                                                                                            BUG15532
     C                   EVAL      PBRCA = BRCA                                             BUG15532
     C                   EXSR      AOBRCH                                                   BUG15532
     C                   EVAL      RBRCA = A8BRCD                                           BUG15532
     C                   EVAL      RBRNM = A8BRNM                                           BUG15532
                                                                                            BUG15532
      ** Open the next branch's spool files                                                 BUG15532
                                                                                            BUG15532
     C                   EXSR      OpnP1                                                    BUG15532
     C                   EXSR      OpnP2                                                    BUG15532
                                                                                            BUG15532
     C                   EVAL      SvBRCA = BRCA                                            BUG15532
                                                                                            BUG15532
     C                   ENDIF                                                              BUG15532
      **********                                                                     BUG15532 262550
     C**********         ENDIF                                                       BUG15532 262550
      **********                                                                     BUG15532 262550
     C**********         DOW       *IN02 = *OFF                                      BUG15532 262550
     C**********         ADD       1             RCOUNT                              BUG15532 262550
      *                                                                                       262550
      * If loan details not printed (due to LEEIRDPD record not being                         262550
      * present) print them now.                                                              262550
      *                                                                                       262550
     C     WEIRDF        IFEQ      'N'                                                        262550
      *                                                                                     BUG15532
     C                   MOVE      LNRF          RLNRF                                      BUG15532
     C                   MOVE      CNUM          RCNUM                                      BUG15532
     C                   EVAL      RLTYP  = LTYP + '-' + SUTP                               BUG15532
     C                   EVAL      RCCY = CCY                                               BUG15532
                                                                                            BUG15532
     C                   EVAL      PCCY = CCY                                                 262550
     C                   EVAL      ZFLD15 = CPAM                                            BUG15532
     C                   EXSR      ZSEdit                                                   BUG15532
     C                   EVAL      RCBAL  = ZOUT21                                          BUG15532
     C                                                                                      BUG15532
      *EIR                                                                                  BUG15532
     C**********         EVAL      WEIEIR = EIEIR * 100                              BUG15532 262550
     C**********         MOVE      WEIEIR        ZFIELD                              BUG15532 262550
     C**********         EVAL      ZADEC = 10                                        BUG15532 262550
     C**********         EXSR      ZEdit2                                            BUG15532 262550
     C**********         EVAL      REIR   = ZFIELD                                   BUG15532 262550
     C                   EVAL      REIR   = *BLANKS                                           262550
      *                                                                                     BUG15532
      ** Write P1 Header if required                                                        BUG15532
                                                                                            BUG15532
     C                   Z-ADD     9             RQDLN1                                     BUG15532
     C     OFLLN1        SUB       PRTLN1        DIFLN1                                     BUG15532
     C     DIFLN1        IFLE      RQDLN1                                                   BUG15532
     C                   WRITE     LE004621H1                                               BUG15532
     C                   ENDIF                                                              BUG15532
      *                                                                                     BUG15532
     C                   WRITE     LE004621D1                                               BUG15532
      **********                                                                     BUG15532 262550
     C*****LNRF*         CHAIN     LENPVAL0                                          BUG15532 262550
     C**********         IF        %FOUND(LENPVAL0)                                  BUG15532 262550
     C**********         EVAL      ZFLD15 = LNNPVA                                   BUG15532 262550
     C**********         EVAL      PCCY = LNCYCD                                     BUG15532 262550
     C**********         EXSR      ZSEdit                                            BUG15532 262550
     C**********         EVAL      RNPV   = ZOUT21                                   BUG15532 262550
      **********                                                                     BUG17223 262550
      *Initialise NPV if no yield curve                                              BUG17223 262550
     C**********         ELSE                                                        BUG17223 262550
     C**********         EVAL      RNPV = *BLANKS                                    BUG17223 262550
     C**********         ENDIF                                                       BUG15532 262550
      **********                                                                     BUG15532 262550
      *Amortised*to*Date***********************************************              BUG15532 262550
     C**********         EVAL      ZFLD15 = EIAMTD                                   BUG15532 262550
     C**********         EXSR      ZSEdit                                            BUG15532 262550
     C**********         EVAL      RACST  = ZOUT21                                   BUG15532 262550
      **********                                                                     BUG15532 262550
     C**********         EVAL      ZFLD15 = TFDP                                     BUG15532 262550
     C**********         EXSR      ZSEdit                                            BUG15532 262550
     C**********         EVAL      RTFDP  = ZOUT21                                   BUG15532 262550
      **********                                                                     BUG15532 262550
     C**********         EVAL      ZFLD15 = TFDPA                                  BUG15532 BUG17292
     C**********         EVAL      ZFLD15 = TFAM                                     BUG17292 262550
     C**********         EXSR      ZSEdit                                            BUG15532 262550
     C**********         EVAL      RTFDPA = ZOUT21                                   BUG15532 262550
      **********                                                                     BUG15532 262550
     C**********         EVAL      ZFLD15 = AFDP                                     BUG15532 262550
     C**********         EXSR      ZSEdit                                            BUG15532 262550
     C**********         EVAL      RAFDP  = ZOUT21                                   BUG15532 262550
      **********                                                                     BUG15532 262550
     C**********         WRITE     LE004621D2                                        BUG15532 262550
      *                                                                                       262550
      ** Write P1 Header if required                                                          262550
                                                                                              262550
     C                   Z-ADD     9             RQDLN1                                       262550
     C     OFLLN1        SUB       PRTLN1        DIFLN1                                       262550
     C     DIFLN1        IFLE      RQDLN1                                                     262550
     C                   WRITE     LE004621H1                                                 262550
     C                   WRITE     LE004621D1                                                 262550
     C                   ENDIF                                                                262550
      *                                                                                       262550
     C                   WRITE     LE004621H2                                                 262550
      *                                                                                       262550
     C                   ENDIF                                                                262550
      *                                                                                       262550
     C                   ENDIF                                                                262550
      *                                                                                       262550
     C                   DOW       *IN02 = *OFF                                               262550
     C                   ADD       1             RCOUNT                                       262550
      *                                                                                     BUG15532
      *                                                                                     BUG15532
     C                   MOVE      LNRF          RLNRF                                      BUG15532
     C                   MOVE      EIFSEQ        RFSEQ                                      BUG15532
      *                                                                                     BUG15532
     C     KFEE1         CHAIN     LEFEEDLD                                                 BUG15532
     C                   IF        %FOUND(LEFEEDLD)                                         BUG15532
      *                                                                                     BUG15532
     C**********         EVAL      ZDAYNO = FEPSTD                                   BUG15532 262550
     C                   EVAL      ZDAYNO = FESTPD                                            262550
     C                   EXSR      ZDate2                                                   BUG15532
     C                   EVAL      RSTPD = ZADATE                                           BUG15532
      *                                                                                     BUG15532
     C**********         EVAL      ZDAYNO = FEPEND                                   BUG15532 262550
     C                   EVAL      ZDAYNO = FEENPD                                            262550
     C                   EXSR      ZDate2                                                   BUG15532
     C                   EVAL      RENPD = ZADATE                                           BUG15532
      * Fees Amount                                                                         BUG15532
     C                   IF        CCY <> FEFCCY                                            BUG15532
     C     KFEE          CHAIN     LEEIRAL5                                                 BUG15532
                                                                                            BUG15532
     C                   IF        %FOUND(LEEIRAL5)                                         BUG15532
     C                   EVAL      WFAMT = WFAMT + EAAMNT                                   BUG15532
     C                   EVAL      ZFLD15 = EAAMNT                                          BUG15532
     C                   EXSR      ZSEdit                                                   BUG15532
     C                   EVAL      RFAMT  = ZOUT21                                          BUG15532
                                                                                            BUG15532
     C                   EVAL      WAAMT = WAAMT + EAAAMP                                   BUG15532
     C                   EVAL      ZFLD15 = EAAAMP                                          BUG15532
     C                   EXSR      ZSEdit                                                   BUG15532
     C                   EVAL      RAAMT  = ZOUT21                                          BUG15532
     C                   ENDIF                                                              BUG15532
     C                   ELSE                                                               BUG15532
                                                                                            BUG15532
     C                   EVAL      WFAMT = WFAMT + FEFAMT                                   BUG15532
     C                   EVAL      ZFLD15 = FEFAMT                                          BUG15532
     C                   EXSR      ZSEdit                                                   BUG15532
     C                   EVAL      RFAMT  = ZOUT21                                          BUG15532
                                                                                            BUG15532
     C                   EVAL      WAAMT = WAAMT + FEAMTD                                   BUG15532
     C                   EVAL      ZFLD15 = FEAMTD                                          BUG15532
     C                   EXSR      ZSEdit                                                   BUG15532
     C                   EVAL      RAAMT  = ZOUT21                                          BUG15532
     C                   ENDIF                                                              BUG15532
      *                                                                                       262550
      * Format EIR                                                                            262550
     C                   EVAL      WEIEIR = EIEIR * 100                                       262550
     C                   MOVE      WEIEIR        ZFIELD                                       262550
     C                   EVAL      ZADEC = 10                                                 262550
     C                   EXSR      ZEdit2                                                     262550
     C                   EVAL      REIR   = ZFIELD                                            262550
                                                                                            BUG15532
     C                   ENDIF                                                              BUG15532
      *                                                                                     BUG15532
     C**********         Z-ADD     6             RQDLN1                              BUG15532 262550
     C                   Z-ADD     3             RQDLN1                                       262550
     C     OFLLN1        SUB       PRTLN1        DIFLN1                                     BUG15532
     C     DIFLN1        IFLE      RQDLN1                                                   BUG15532
     C                   WRITE     LE004621H1                                               BUG15532
     C                   WRITE     LE004621D1                                               BUG15532
     C                   ENDIF                                                              BUG15532
      *                                                                                     BUG15532
     C**********         WRITE     LE004621H2                                        BUG15532 262550
     C                   WRITE     LE004621D3                                               BUG15532
      *                                                                                     BUG15532
     C     LNRF          READE     LEERAPL2                               02                BUG15532
     C                   ENDDO                                                              BUG15532
                                                                                            BUG15532
      ** Format P2 report                                                                   BUG15532
     C                   IF        WEIRDF = 'N'                                             BUG15532
     C                   IF        WERAPF = 'Y'                                             BUG15532
      *                                                                                     BUG15532
     C                   Z-ADD     9             RQDLN2                                     BUG15532
     C     OFLLN2        SUB       PRTLN2        DIFLN2                                     BUG15532
     C     DIFLN2        IFLE      RQDLN2                                                   BUG15532
     C                   WRITE     LE004621H3                                               BUG15532
     C                   ENDIF                                                              BUG15532
                                                                                            BUG15532
     C                   WRITE     LE004621D4                                               BUG15532
                                                                                            BUG15532
      ** Report all Cash Flow records within an EIR period                                  BUG15532
                                                                                            BUG15532
     C     LNRF          SETLL     LECFSFL0                                                 BUG15532
     C     LNRF          READE     LECFSFL0                                                 BUG15532
                                                                                            BUG15532
     C                   DOW       NOT %EOF(LECFSFL0)                                       BUG15532
     C**********         IF           LFFTYP = 'SFAM' AND LFFLDT = EIENDT            BUG15532 262550
     C**********                   OR LFFTYP = 'EFAC' AND LFFLDT = EIENDT            BUG15532 262550
     C**********                   OR LFFTYP = 'SFBT' AND LFFLDT = EIENDT            BUG15532 262550
     C**********                   OR LFFTYP = 'EFAN'                                BUG15532 262550
     C**********                   OR LFFTYP = 'SFAN'                                BUG15532 262550
     C**********                   OR LFFTYP = 'SFBN'                                BUG15532 262550
      ***Fees*equal to EIR Period End date belong to the next period.                BUG15532 262550
     C**********         ELSE                                                        BUG15532 262550
     C                   IF        (EISTDT <= LFFLDT)                                       BUG15532
     C                             AND (EIENDT >= LFFLDT)                                   BUG15532
     C                             AND LFIOIN <> 'S'                                        BUG15532
     C                             AND LFFTYP <> 'PDPR'                                       262618
     C                             AND LFFTYP <> 'PDIN'                                       262618
                                                                                            BUG15532
     C**********         IF        LFADLN = 0                                        BUG15532 CLE148
     C                   IF        LFADLN = *BLANKS                                           CLE148
     C                   MOVE      *BLANKS       RSOLD                                      BUG15532
     C                   ELSE                                                               BUG15532
     C                   MOVE      LFADLN        RSOLD                                      BUG15532
     C                   ENDIF                                                              BUG15532
     C                   MOVE      LFNDYP        WNDYP                                      BUG15532
                                                                                            BUG15532
     C                   EVAL      RCDATE = LFDATE                                          BUG15532
     C                   EVAL      ZFLD15 = LFCAMT                                          BUG15532
     C                   EVAL      PCCY = LFCYCD                                            BUG15532
     C                   EXSR      ZSEdit                                                   BUG15532
     C                   EVAL      RCSFL  = ZOUT21                                          BUG15532
                                                                                            BUG15532
     C                   EVAL      RTYPE  = LFFTYP                                          BUG15532
                                                                                            BUG15532
     C                   EVAL      ZFIELD = *BLANKS                                         BUG15532
     C                   Z-ADD     LFIRAT        VarRat1                                    BUG15532
     C                   MOVE      VarRat1       ZFIELD                                     BUG15532
     C                   EVAL      ZADEC = 8                                                BUG15532
     C                   EXSR      ZEdit2                                                   BUG15532
     C                   MOVE      ZFIELD        RINTR                                      BUG15532
                                                                                            BUG15532
     C                   MOVE      LFICBS        RCALC                                      BUG15532
     C                   EVAL      RYIELD = LFYLDC                                          BUG15532
                                                                                            BUG15532
     C                   EVAL      ZFIELD = *BLANKS                                         BUG15532
     C                   Z-ADD     LFDSCF        VarRat2                                    BUG15532
     C                   MOVE      VarRat2       ZFIELD                                     BUG15532
     C                   EVAL      ZADEC = 9                                                BUG15532
     C                   EXSR      ZEdit2                                                   BUG15532
     C                   MOVE      ZFIELD        RDISC                                      BUG15532
                                                                                            BUG15532
      ** Write P2 Header and EIR format if required                                         BUG15532
                                                                                            BUG15532
     C                   Z-ADD     1             RQDLN2                                     BUG15532
     C     OFLLN2        SUB       PRTLN2        DIFLN2                                     BUG15532
     C     DIFLN2        IFLE      RQDLN2                                                   BUG15532
     C                   WRITE     LE004621H3                                               BUG15532
     C                   WRITE     LE004621D4                                               BUG15532
     C                   ENDIF                                                              BUG15532
                                                                                            BUG15532
      ** Write P2 Cash Flow format                                                          BUG15532
                                                                                            BUG15532
     C                   WRITE     LE004621D5                                               BUG15532
     C                   ENDIF                                                              BUG15532
      **********                                                                     BUG15532 262550
     C**********         ENDIF                                                       BUG15532 262550
                                                                                            BUG15532
      ** Read next Cash Flow record                                                         BUG15532
                                                                                            BUG15532
     C     LNRF          READE     LECFSFL0                                                 BUG15532
                                                                                            BUG15532
      ** ENDDO of Cash flows within an EIR period                                           BUG15532
                                                                                            BUG15532
     C                   ENDDO                                                              BUG15532
      *                                                                                     BUG15532
     C                   ENDIF                                                              BUG15532
      *                                                                                     BUG15532
     C                   ENDIF                                                              BUG15532
      *                                                                                     BUG15532
     C                   ENDSR                                                              BUG15532
                                                                                            BUG15532
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
 
     C                   WRITE     LE004621HA
 
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
 
      ** CLOANCL details
 
     C                   MOVE      LNRF          RLNRF
     C                   EVAL      RCCY = CCY
     C                   EVAL      PCCY = CCY
     C                   MOVE      CNUM          RCNUM
     C                   EVAL      RLTYP  = LTYP + '-' + SUTP
 
     C                   EVAL      ZFLD15 = CPAM
     C                   EXSR      ZSEdit
     C                   EVAL      RCBAL  = ZOUT21
 
     C                   EVAL      ZFLD15 = TFDP
     C                   EXSR      ZSEdit
     C                   EVAL      RTFDP  = ZOUT21
 
     C**********         EVAL      ZFLD15 = TFDPA                                           BUG17292
     C                   EVAL      ZFLD15 = TFAM                                            BUG17292
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
 
     C**********         EVAL      ZFLD15 = EIAMTD                                            258459
     C                   EVAL      ZFLD15 = EIDPTD                                            258459
     C                   EXSR      ZSEdit
     C                   EVAL      RACST  = ZOUT21
 
      ** LENPVAPD details
 
     C     LNRF          CHAIN     LENPVAL0
     C                   IF        %FOUND(LENPVAL0)
     C                   EVAL      ZFLD15 = LNNPVA
     C                   EVAL      PCCY = LNCYCD
     C                   EXSR      ZSEdit
     C                   EVAL      RNPV   = ZOUT21
      *                                                                                     BUG17223
      *Initialise NPV if no yield curve                                                     BUG17223
     C                   ELSE                                                               BUG17223
     C                   EVAL      RNPV = *BLANKS                                           BUG17223
     C                   ENDIF
 
      ** Write P1 Header if required
 
     C                   Z-ADD     9             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     LE004621H1
     C                   ENDIF
 
      ** Write P1 EIR Format
 
     C                   WRITE     LE004621D1
     C                   WRITE     LE004621D2
 
     C                   EVAL      WFAMT = 0
     C                   EVAL      WAAMT = 0
     C                   EVAL      WFLAG = 'N'
 
      ** Discounted Loans
     C                   IF        PTYP = 63
     C                             OR PTYP = 65
     C                             OR PTYP = 67
     C                   EVAL      WFLAG = 'Y'
     C                   EVAL      RFSEQ = *BLANKS
 
     C                   EVAL      ZDAYNO = VDAT
     C                   EXSR      ZDate2
     C                   EVAL      RSTPD = ZADATE
 
     C                   EVAL      ZDAYNO = MDAT
     C                   EXSR      ZDate2
     C                   EVAL      RENPD = ZADATE
 
     C                   EVAL      WFAMT = WFAMT + TOTI
     C                   EVAL      ZFLD15 = TOTI
     C                   EXSR      ZSEdit
     C                   EVAL      RFAMT  = ZOUT21
 
     C                   EVAL      RAFMT  = *BLANKS                                         BUG17318
                                                                                            BUG17318
     C                   EVAL      WAAMT = WAAMT + AMDS
     C                   EVAL      ZFLD15 = AMDS
     C                   EXSR      ZSEdit
     C                   EVAL      RAAMT  = ZOUT21
 
      ** Write P1 Header if required
 
     C**********         Z-ADD     4             RQDLN1                                       240763
     C                   Z-ADD     6             RQDLN1                                       240763
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     LE004621H1
     C                   WRITE     LE004621D1
     C                   ENDIF
 
     C                   WRITE     LE004621H2
     C                   WRITE     LE004621D3
 
     C                   ENDIF
 
      ** Read all adjustment to yield fees attached to the loan
     C*****LNRF*         SETLL     LEFEEDLC                                                   262550
     C*****LNRF*         READE     LEFEEDLC                                                   262550
     C     LNRF          SETLL     LEFEEDLN                                                   262550
     C     LNRF          READE     LEFEEDLN                                                   262550
 
     C**********         IF        NOT %EOF(LEFEEDLC)                                         262550
     C                   IF        NOT %EOF(LEFEEDLN)                                         262550
     C                             AND PTYP <> 63
     C                             AND PTYP <> 65
     C                             AND PTYP <> 67
     C                   EVAL      WFLAG = 'Y'
     C                   Z-ADD     4             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     LE004621H1
     C                   WRITE     LE004621D1
     C                   ENDIF
 
     C                   WRITE     LE004621H2
     C                   ENDIF
 
     C**********         DOW       NOT %EOF(LEFEEDLC)                                         262550
     C                   DOW       NOT %EOF(LEFEEDLN)                                         262550
 
     C                   MOVE      FEFCOD        PFEE
     C                   EXSR      AOFEE
 
     C                   IF        AUADJY = 'Y'
     C                             AND FERECI <> 'R'
     C                             AND FERECI <> '*'
                                                                                            BUG15532
      ** Exclude fees to be amortised over period                                           BUG15532
     C                             AND FEAMRI <> 'Y'                                        BUG15532
                                                                                            BUG15532
     C                   MOVE      FEFSEQ        RFSEQ
 
     C                   EVAL      ZDAYNO = FESTPD
     C                   EXSR      ZDate2
     C                   EVAL      RSTPD = ZADATE
 
     C                   EVAL      ZDAYNO = FEENPD
     C                   EXSR      ZDate2
     C                   EVAL      RENPD = ZADATE
 
     C                   IF        CCY <> FEFCCY
     C     KFEE          CHAIN     LEEIRAL5
 
     C                   IF        %FOUND(LEEIRAL5)
     C                   EVAL      WFAMT = WFAMT + EAAMNT
     C                   EVAL      ZFLD15 = EAAMNT
     C                   EXSR      ZSEdit
     C                   EVAL      RFAMT  = ZOUT21
 
     C                   EVAL      ZFLD15 = FEAFES                                          BUG17318
     C                   EXSR      ZSEdit                                                   BUG17318
     C                   EVAL      RAFMT  = ZOUT21                                          BUG17318
                                                                                            BUG17318
     C                   EVAL      WAAMT = WAAMT + EAAAMP
     C                   EVAL      ZFLD15 = EAAAMP
     C                   EXSR      ZSEdit
     C                   EVAL      RAAMT  = ZOUT21
     C                   ENDIF
     C                   ELSE
 
     C                   EVAL      WFAMT = WFAMT + FEFAMT
     C                   EVAL      ZFLD15 = FEFAMT
     C                   EXSR      ZSEdit
     C                   EVAL      RFAMT  = ZOUT21
 
     C                   EVAL      RAFMT  = *BLANKS                                         BUG17318
                                                                                            BUG17318
     C                   EVAL      WAAMT = WAAMT + FEAMTD
     C                   EVAL      ZFLD15 = FEAMTD
     C                   EXSR      ZSEdit
     C                   EVAL      RAAMT  = ZOUT21
     C                   ENDIF
 
      ** Write P1 Header if required
 
     C                   Z-ADD     1             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     LE004621H1
     C                   WRITE     LE004621D1
     C                   WRITE     LE004621H2
     C                   ENDIF
     C                   WRITE     LE004621D3
 
     C                   ENDIF
 
     C*****LNRF*         READE     LEFEEDLC                                                   262550
     C     LNRF          READE     LEFEEDLN                                                   262550
     C                   ENDDO
 
     C                   EVAL      ZFLD15 = WFAMT
     C                   EXSR      ZSEdit
     C                   EVAL      RTFEE  = ZOUT21
 
     C                   EVAL      ZFLD15 = WAAMT
     C                   EXSR      ZSEdit
     C                   EVAL      RTMRT  = ZOUT21
 
     C                   IF        WFLAG = 'Y'
      ** Write P1 Header if required
 
     C                   Z-ADD     3             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     LE004621H1
     C                   WRITE     LE004621D1
     C                   ENDIF
 
     C                   WRITE     LE004621T1
     C                   ENDIF
 
      ** Format P2 report
     C                   Z-ADD     9             RQDLN2
     C     OFLLN2        SUB       PRTLN2        DIFLN2
     C     DIFLN2        IFLE      RQDLN2
     C                   WRITE     LE004621H3
     C                   ENDIF
 
     C                   WRITE     LE004621D4
 
      ** Report all Cash Flow records within an EIR period
 
     C     LNRF          SETLL     LECFSFL0
     C     LNRF          READE     LECFSFL0
 
     C                   DOW       NOT %EOF(LECFSFL0)
      *****************************************************************              BUG17295 262550
      ***Adjusted*checking*of*fees*on*Loan*end*date********************              BUG17295 262550
      *****************************************************************              BUG17295 262550
     C**********         IF        LFFTYP = 'SFAM' OR LFFTYP = 'EFAC'                BUG17295 262550
     C**********                   OR LFFTYP = 'SFBT'                                BUG17295 262550
      *****************************************************************              BUG17295 262550
     C**********         EVAL      KFSEQ = LFFSEQ                                    BUG17295 262550
      *****************************************************************              BUG17295 262550
     C*****KFee2         CHAIN     LEFEEDLD                                          BUG17295 262550
      *****************************************************************              BUG17295 262550
     C**********         ENDIF                                                       BUG17295 262550
      *****************************************************************              BUG17295 262550
     C**********         IF           LFFTYP = 'SFAM' AND LFFLDT = EIENDT                   BUG17295
     C**********                   OR LFFTYP = 'EFAC' AND LFFLDT = EIENDT                   BUG17295
     C**********                   OR LFFTYP = 'SFBT' AND LFFLDT = EIENDT                   BUG17295
     C**********         IF        LFFTYP = 'SFAM' AND FEAMRI = 'N'                  BUG17295 262550
     C**********                   OR LFFTYP = 'EFAC' AND FEAMRI = 'N'               BUG17295 262550
     C**********                   OR LFFTYP = 'SFBT' AND FEAMRI = 'N'               BUG17295 262550
     C**********                   OR LFFTYP = 'EFAN'                                         262550
     C**********                   OR LFFTYP = 'SFAN'                                         262550
     C**********                   OR LFFTYP = 'SFBN'                                         262550
      ***Fees*equal to EIR Period End date belong to the next period.                         262550
     C**********         ELSE                                                                 262550
     C                   IF        (EISTDT <= LFFLDT)
     C                             AND (EIENDT >= LFFLDT)
     C                             AND LFIOIN <> 'S'
     C                             AND LFFTYP <> 'PDPR'                                       262618
     C                             AND LFFTYP <> 'PDIN'                                       262618
     C                             OR EIENDT >= LFFLDT                                      AR784436
     C                             AND LFIOIN <> 'S'                                        AR784436
     C                             AND LFFTYP = 'SAMT'                                      AR784436
     C                             AND INTR <> LFIRAT                                       AR784436
                                                                                            AR784436
     C                   EVAL      WREPORT = 'Y'                                            AR784436
     C                   IF        EIENDT >= LFFLDT                                         AR784436
     C                             AND LFIOIN <> 'S'                                        AR784436
     C                             AND LFFTYP = 'SAMT'                                      AR784436
     C                             AND EISTDT > LFFLDT                                      AR784436
     C                   EVAL      WWSTDT = EISTDT                                          AR784436
     C                   READ      LEEIRDLD                                                 AR784436
     C                   IF        %EOF(LEEIRDLD)                                           AR784436
     C                             OR EITRAN <> LNRF                                        AR784436
     C                             OR EIPRDP = 0                                            AR784436
     C                   EVAL      WREPORT = 'N'                                            AR784436
     C                   ELSE                                                               AR784436
     C                   EVAL      ZDAYNO = WWSTDT                                          AR784436
     C                   EXSR      ZDate2                                                   AR784436
     C                   EVAL      LFDATE = ZADATE                                          AR784436
     C                   EVAL      LFCAMT = EIPRDP                                          AR784436
     C                   EVAL      LFFTYP = 'DUMM'                                          AR784436
     C                   Z-ADD     INTR          LFIRAT                                     AR784436
     C                   ENDIF                                                              AR784436
     C                   READP     LEEIRDLD                                                 AR784436
     C                                                                                      AR784436
     C                   ENDIF                                                              AR784436
 
     C                   IF        WREPORT = 'Y'                                            AR784436
     C**********         IF        LFADLN = 0                                                 CLE148
     C                   IF        LFADLN = *BLANKS                                           CLE148
     C                   MOVE      *BLANKS       RSOLD
     C                   ELSE
     C                   MOVE      LFADLN        RSOLD
     C                   ENDIF
     C                   MOVE      LFNDYP        WNDYP
 
     C                   EVAL      RCDATE = LFDATE
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
     C                   WRITE     LE004621H3
     C                   WRITE     LE004621D4
     C                   ENDIF
 
      ** Write P2 Cash Flow format
 
     C                   WRITE     LE004621D5
     C                   ENDIF
     C                   ENDIF                                                              AR784436
      *****************************************************************                       262550
     C**********         ENDIF                                                                262550
 
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
     C                   OPEN      LE004621P1
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
 
     C                   WRITE     LE004621H1
 
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
     C                   OPEN      LE004621P2
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
 
     C                   WRITE     LE004621H3
 
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
 
     C**********         Z-ADD     2             RQDLN1                                       CAS019
     C                   Z-ADD     3             RQDLN1                                       CAS019
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     LE004621H1
     C                   ENDIF
 
      ** Write Footer
 
     C                   WRITE     LE004621F1
      *
      ** Close the spool file
      *
     C     P1OPEN        IFEQ      'Y'
     C                   CLOSE     LE004621P1
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
     C                   WRITE     LE004621H3
     C                   ENDIF
 
      ** Write Footer
 
     C                   WRITE     LE004621F2
 
      ** Close the spool file
 
     C     P2OPEN        IFEQ      'Y'
     C                   CLOSE     LE004621P2
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
 
     C     KFEE          KLIST
     C                   KFLD                    FELOAN
     C                   KFLD                    FEFSEQ
 
     C     KFEE1         KLIST                                                              BUG15532
     C                   KFLD                    EITRAN                                     BUG15532
     C                   KFLD                    EIFSEQ                                     BUG15532
                                                                                            BUG15532
     C     KFee2         KLIST                                                              BUG17295
     C                   KFLD                    KLNRF                                      BUG17295
     C                   KFLD                    KFSEQ                                      BUG17295
                                                                                            BUG17295
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
      /TITLE SR/ZDate2
      *****************************************************************
      *                                                               *
      *  ZDate2 - Call to 'ZDate2'                                    *
      *                                                               *
      *****************************************************************
 
     C     ZDate2        BEGSR
 
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         ZDATE
     C                   PARM      *BLANKS       ZADATE
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      /TITLE SR/AOBRCH
      *****************************************************************
      *                                                               *
      *  AOBRCH - Call to AOBRCHR1                                    *
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
      *  AOCURR - Call to AOCURRR0                                    *
      *                                                               *
      *****************************************************************
 
     C     AOCURR        BEGSR
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCCY
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        (PRtCd <> *BLANKS)
 
      ** Data base error in file SDCURRPD
 
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
      /TITLE SR/AOFEE
      *****************************************************************
      *                                                               *
      *  AOFEE - Call to AOFEER0                                      *
      *                                                               *
      *****************************************************************
 
     C     AOFEE         BEGSR
 
     C                   CALL      'AOFEER0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PFEE
     C     SDFEE         PARM      SDFEE         DSSDY
 
     C                   IF        (PRTCD <> *BLANKS)
 
      ** Data base error in file SDFEEPD
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDFEEPD'
     C                   EVAL      DBKEY  =  PFEE
     C                   EVAL      DBASE  =  005
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
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   EXSR      AUDIT
 
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2006
