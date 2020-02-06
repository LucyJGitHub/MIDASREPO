     H DEBUG
     H COPYRIGHT ('(c) Finastra International Limited 2002')
     H DATFMT(*DMY&)
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD RWA Codes Audit Report')
  *** *****************************************************************
      *  Midas - SD Module                                            *
      *                                                               *
      *  SD001246  - Risk Weighted Assets Code Report                 *
      *                                                               *
      *                                                               *
      *  Function:  This programm will be used to print report        *
      *             Risk Weighted Assets Code                         *
      *                                                               *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL018   *CREATE   Date 01Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL018 - Risk Weighted Assets                                *
      *                                                               *
      *****************************************************************
      *                                                               *
      * Use of Indicators                                             *
      *                                                               *
      * 37  - Multibranching ON                                       *
      * 50  - Audit mode - report today's changes                     *
      * 60  - Weighting is 0 - used for display                       *
      * 61  - RWA code deleted                                        *
      *                                                               *
      * Database Access Indicators                                    *
      *                                                               *
      * 89 - Access file SDRWACL2                                     *
      *                                                               *
      * Other Indicators                                              *
      *                                                               *
      *   98  - Date Format: DDMMYY (off); MMDDYY (on)                *
      * 90-99 - Used by Standard Subroutines                          *
      *                                                               *
      * U7+U8 - Database Error                                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR  - Error processing                                     *
      * *INZSR - Initialise                                           *
      *                                                               *
      * PROCES       : Detail Processing                              *
      * AUDIT        : Produce Audit Report                           *
      * PrintDetail  : Process Report Lines                           *
      * PrintTrail   : Print trailer - end of report                  *
      * DateM2       : Convert Midas format date to DD/MM/YY format   *
      *****************************************************************
      ** +--------------------------------------+
      ** | F-specs                              |
      ** | =======                              |
      ** +--------------------------------------+
      *
      **  Risk Weighted Assets Code file
      *
     F***SDRWACL1  IF   E           K DISK    INFSR(*PSSR)
     FSDRWACL2  IF   E           K DISK    INFSR(*PSSR)
      *
      **  Reports
      *
     FSD001246P1O    E             PRINTER INFDS(SPOOL1)  USROPN
      *
     FSD001246AUO    E             PRINTER INFDS(SPOOLU)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** | D-specs                              |
      ** | =======                              |
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** | Arrays and Data Structures           |
      ** | ==========================           |
      ** +--------------------------------------+
      *
      **  Rundat DS
      *
     DRUNDAT         E DS                  EXTNAME(RUNDAT) DTAARA(RUNDAT)
      *
      **  Branch Code Record Layout
      *
     D SdBRCA        E DS                  EXTNAME(SDBRCHPD)
      *
      **  SD Bank Detail
      *
     D SdBANK        E DS                  EXTNAME(SDBANKPD)
      *
      **  DS (long) used as Parameter with Access Objects
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** DS (short) used as Parameter with Access Objects
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      **  File Information Data Structure - AU report
      *
     DSPOOLU           DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
      *
      **  File Information Data Structure - P1 report
      *
     DSPOOL1           DS
     D  SFIL1                 83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
      *
      **  Audit report - CONTROL record
      *
     DDsRcount         DS
     D  RcountR                       5S 0
     D  RcountI                       5S 0
     D  RcountA                       5S 0
     D  RcountD                       5S 0
      *
      ** +--------------------------------------+
      ** | Declared variables                   |
      ** | ==================                   |
      ** +--------------------------------------+
      *
     D @RUN            S              1
     DwLine1           S              2B 0
     DwDate            S               D   DATFMT(*DMY)
     DwDate2           S              8A
     DwDay             S              6S 0
      *
      *------------------------------------------------------------------------*
      /COPY ZACPYSRC,PSDS
      /COPY ZACPYSRC,STD_D_SPEC
      *------------------------------------------------------------------------*
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** |                                                                |
      ** | Initial processing is performed automatically: the *INZSR is   |
      ** | executed at program activation.                                |
      ** |                                                                |
      ** +----------------------------------------------------------------+
      *
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
      *
     C                   Exsr      PROCES
      *
     C                   Exsr      AUDIT
      *
      /EJECT
      *========================================================================*
      *                    S  U  B  R  O  U  T  I  N  E  S                     *
      *========================================================================*
      *
      *========================================================================*
      /EJECT
     ******************************************************************
      * PROCES  -  Detail Processing                                  *
      * ------                                                        *
      * Called by : Main                                              *
      * Calls     : RCFP1, PrintDetail, PrintTrailer, AUDIT           *
      *****************************************************************
      *
     C     PROCES        BEGSR
      *
     C     *Loval        Setll     SDRWACL2
     C                   Read      SDRWACL2                               89
      *
      ***   If EOF report no records
 
     C                   If        *IN89 = *on
     C                   Exsr      AUDIT
     C                   Else
      *
      **  If record read, ensure spool file P1 recorded by RCF
      *
     C                   Open      SD001246P1
     C                   Exsr      RCFP1
      *
      **  Check if audit mode (report today's changes)
      *
     C                   IF        PARSI = 'A'
     C                   EVAL      *IN50 = *on
     C                   ENDIF
     C                   Write     HEADP1
      *
      **  Print Processing
      *
     C     *in89         DowEQ     '0'
     C                   Eval      RcountR=RcountR + 1
     C                   If        (parsi='A' and agrdnb=rwlcd) or              RunDay's record
     C                             (parsi<>'A')                                 all record
      *
     C                   Exsr      PrintDetail
     C                   EndIf
     C                   Read      SDRWACL2                               89
     C                   EndDo
      *
     C                   Exsr      PrintTrail
     C                   EndIf
      *
     C                   ENDSR
      /EJECT
     ***************************************************************************
      * PrintDetail  : Print detail                                            *
      * -----------                                                            *
      * Called by : PROCES                                                     *
      * Calls     :                                                            *
      **************************************************************************
     C     PrintDetail   BEGSR
      *
      **  Set Report Fields
      *
     C                   Eval      Rrwcode=rwcode
     C                   Eval      Rrwsetn=rwsetn
     C                   Eval      Rrwcdesc=rwcdesc
     C                   Eval      Rrwchtp=rwchtp
     C                   Eval      wDay=rwlcd
     C                   Exsr      DateM2
     C                   Eval      Rrwlcd=wDate2
      *
      **  If amount is 0 display as 0.00
      *
     C                   EVAL      *IN60 = *OFF
     C                   IF        RWRWAP <> 0
     C                   Eval      Rrwrwap=rwrwap
     C                   ELSE
     C                   EVAL      *IN60 = *ON
     C                   ENDIF
      *
      **  Check if code is deleted
      *
     C                   EVAL      *IN61 = *off
     C                   IF        RWRECI = '*'
     C                   EVAL      *IN61 = *on
     C                   ENDIF
      *
      **  Overflow control
      *
     C                   Eval      Wline1 = 1
     C                   if        (OFLLN1-PRTLN1)<=wLine1
     C                   Write     HEADP1
     C                   EndIf
     C                   Write     DETAIL
      *
      *
      **  Set Counters for Audit
      *
     C                   if        agrdnb=rwlcd
     C                   if        rwreci='*'
     C                   Eval      RcountD=RcountD+1
     C                   Endif
     C                   If        rwchtp='I'
     C                   Eval      RcountI=RcountI+1
     C                   EndIf
     C                   If        rwchtp='A'
     C                   Eval      RcountA=RcountA+1
     C                   EndIf
     C                   EndIf
      *
     C                   ENDSR
      /EJECT
     ***************************************************************************
      * PrintTrail   : Print trailer - end of report                           *
      * ----------                                                             *
      * Called by : Main Procedure                                             *
      * Calls     : None                                                       *
      **************************************************************************
     C     PrintTrail    BEGSR
      *
      **  If audit mode and no changes today, print 'no details'.
      *
     C                   IF        PARSI = 'A' and RCountI = 0 and
     C                             RCountA = 0 and RCountD = 0
     C                   WRITE     NORECORD
     C                   ELSE
      *
      **  Overflow control
      *
     C                   Eval      Wline1 = 4
     C                   if        (OFLLN1-PRTLN1)<=wLine1
     C                   Write     HEADP1
     C                   EndIf
     C                   Write     TRAILP1
      *
     C                   ENDIF
      *
     C                   Close     SD001246P1
      *
     C                   ENDSR
      /EJECT
     ***************************************************************************
      * Audit     : Print audit report                                         *
      * -----                                                                  *
      * Called by : Main Procedur                                              *
      * Calls     : None                                                       *
      **************************************************************************
     C     Audit         BEGSR
      *
      **  Print Audit Header
      *
     C                   Write     HEADAU
      *
      **  Print DBERROR or CONTROL or NoDETAILS
      *
     C                   If        *INU7=*ON
     C                   Write     DBERROR
     C                   Else
     C                   If        RcountR>0
     C                   Write     CONTROL
     C                   Else
     C                   Write     NODTLS
     C                   EndIf
     C                   EndIf
      *
      **  End Program and Return.
      *
     C                   Eval      *INLR = *ON
     C*                  RETURN
      *
     C                   ENDSR
      /EJECT
     ***************************************************************************
      * DateM2    : Convert Midas format date to DD/MM/YY format               *
      * ------                                                                 *
      * Called by : PrintDetail                                                *
      * Calls     : None                                                       *
      **************************************************************************
     C     DateM2        BEGSR
      *
     C                   Eval      wDate=D'31 12 71'
     C                   adddur    wDay:*D       wDate
     C                   MoveL     wDate         wDate2
      *
     C                   ENDSR
      /EJECT
     ******************************************************************
      * *INZSR - Program Initialisation routine                       *
      * ------                                                        *
      * Called by: Implicitly on program activation                   *
      * Calls    : None                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      **  Entry Parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    PRTNC             7            Return Code
     C                   PARM                    PARSI             1            Audit/Reguest
     C                   PARM                    PRSEQ                          RCF Seq.number
     C                   PARM                    PLEVL             1            Level
     C                   PARM                    PRENT                          Entity
      *
      **  Initialise Copyright Array
      *
     C                   MOVEA     CPY@          CPY@@            80
      *
      ** Prepare LDA
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'SD001246'    DBPGM
     C                   OUT       LDA
      *
      **  Access Bank Details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*BLANK '     @RTCD
     c                   PARM      '*FIRST '     @OPTN
     C     SdBANK        PARM      SdBANK        DSFDY
      *
      **  Database Error
      *
     C                   If        @RTCD <> *blanks
     C     *LOCK         IN        LDA                                          ************
     C                   Eval      DBFILE = 'SDBANKPD'                          * DBERR 01 *
     C                   Eval      DBASE = 1                                    ************
     C                   Eval      DBKEY = @OPTN
     C                   OUT       LDA
     C                   Exsr      *PSSR
     C                   EndIf
      *
      **  Check System Date Format, DDMMYY (*IN98 off)
      **                            MMDDYY (*IN98 on).
      *
     C                   If        BJDFIN = 'M'
     C                   Eval      *IN98 = *on
     C                   EndIf
      *
      **  Retrieve current Run Date
      *
     C                   IN        RUNDAT
      *
      **  Set multibranching indicator
      *
     C                   IF        AGMBIN = 'M'
     C                   ENDIF
      *
      **  Start RCF for Audit Printer File
      *
     C                   Exsr      RCFAU
      *
      **  Set on overflow printer file
      *
      *
      **  Initialize variables
      *
     C                   Clear                   DsRcount
     C                   Move      *BLANK        PRTNC
      *
     C                   ENDSR
      /EJECT
     ******************************************************************
      * RCFAU  - Subroutine to register AU PRTF via RCF               *
      * ------                                                        *
      * Called by : *INZSR                                            *
      * Calls     : None                                              *
      *****************************************************************
      *
     C     RCFAU         BEGSR
     C                   Z-ADD     SFNUMU        ZSNUM
     C                   MOVEL     SFILEU        SFILE
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    PRSEQ             5
     C                   PARM                    PRENT             3
     C                   PARM                    SFILE            10
     C                   PARM                    ZSNUM             6 0
     C                   PARM                    ZSERR             1
      *
      **  If an error occurred during ZSFILE processing,
      **  return to the calling program.
      *
     C     ZSERR         IfEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   EndIf
     C                   ENDSR
      /EJECT
     ******************************************************************
      * RCFP1  - Subroutine to register P1 PRTF via RCF               *
      * ------                                                        *
      * Called by : *INZSR                                            *
      * Calls     : None                                              *
      *****************************************************************
      *
     C     RCFP1         BEGSR
     C                   Z-ADD     SFNUM1        ZSNUM
     C                   MOVEL     SFIL1         SFILE
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    PRSEQ             5
     C                   PARM                    PRENT             3
     C                   PARM                    SFILE            10
     C                   PARM                    ZSNUM             6 0
     C                   PARM                    ZSERR             1
      *
      **  If an error occurred during ZSFILE processing,
      **  return to the calling program.
      *
     C     ZSERR         IfEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   EndIf
     C                   ENDSR
      /EJECT
     ******************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *  ----    Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: AUDIT                                                  *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   If        @RUN = *BLANK
     C                   Eval      @RUN = 'Y'
     C                   DUMP
     C                   EndIf
      *
     C                   Eval      PRTNC = 'ERROR'
     C                   Eval      *INU7 = *ON
     C                   Eval      *INU8 = *ON
     C                   Exsr      AUDIT
     C                   RETURN
      *
     C                   ENDSR
      *
**  CPY@
(c) Finastra International Limited 2002
