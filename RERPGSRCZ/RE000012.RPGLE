     H DEBUG
     H COPYRIGHT('(c)Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas RE Account Balance Check Warning Report')        *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE000012 - Account Balance Check Warning Report              *
      *                                                               *
      *  Function:  This will produce report which lists all retail   *
      *  (COB)      customer accounts whose balance is projected to   *
      *             be overdrawn on the new business day. In this     *
      *             case, it will identify and print all the move-    *
      *             ments on that particular account.                 *
      *                                                               *
      *  (c)Finastra International Limited 2004                       *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 05Feb18               *
      *                 CDL099             Date 06Oct17               *
      *                 CRE095             Date 25Apr14               *
      *                 CGL165             Date 15Feb17               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 AR1095876          Date 30Sep13               *
      *                 AR1022006          Date 01Aug12               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP204             Date 15Feb10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 11May06               *
      *                 CSD031             Date 10Apr06               *
      *                 CLE042             Date 06Sep05               *
      *                 CDL038             Date 10May05               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL028             Date 07Feb05               *
      *                 BUG4596            Date 04Nov04               *
      *                 CRE010  *CREATE    Date 06Sep04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CRE095 - Rate Fixing for RE Accounts (Recompile)             *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  AR1095876- ABC - Forward Days 1 should = DNWD-1, not just    *
      *             RUND (Child: AR1095877) (Recompile)               *
      *  AR1022006 - COB Performance Optimisation                     *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  CLE148 - Alpha Loan Reference                                *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CAP204 - Teller Related APIs - Account Transfer              *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  BUG4596 - RABC checking did not take into consideration      *
      *            overdraft and minimum balance                      *
      *  CRE010 - Retail Account Balance Check                        *
      *                                                               *
      *****************************************************************
     FRE000012AUO    E             PRINTER
     F                                     INFDS(SPOOLU)
      ** RPT: Account Balance Checking Warnings Report - Audit

     FRE000012P1O    E             PRINTER USROPN
     F                                     INFDS(SPOOL1)
      ** RPT: Account Balance Checking Warnings Report

     FRSACMTL8  IF   E           K DISK
      ** Account Movements by BRCA/CUSN/CCYD/ACDE/ASNC
                                                                                              CRE010
     FFFACMV3   IF   E           K DISK                                                       CRE010
      ** Account Movements by BRCA/CUSN/CCYD/ACDE/ASNC/VUDT (Futures&Options)                 CRE010

     FACCNTJ1   IF   E           K DISK    INFSR(*PSSR)
      ** Joined ACCNTAB/GLACNTQD by BRCA/CNUM/CCY/ACOD/ACSQ (RECI = 'D' & ATYP = 'R')

     FMEMOSL2   IF   E           K DISK
      ** Shadow balances by retail a/c number

     FFXDEALLL  IF   E           K DISK
      ** FX Deals File

     FMMDEALLL  IF   E           K DISK
      ** MM Deals File                                                                        CRE010
      ***FX*Deals*File                                                                        CRE010
                                                                                              CRE010
     FDLDLDGLE  IF   E           K DISK                                                       CRE010
      ** FRA/IRS Deals                                                                        CRE010

     FDEAMSD    IF   E           K DISK
      ** Deal Amendments File

     FLOAMSOM4  IF   E           K DISK
      ** Loan Amendments File

     FSETRADL3  IF   E           K DISK
      ** Trades File

      *****************************************************************
      /EJECT
      *****************************************************************
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      ** Array containing Copyright statement
     D TArr            S             30    DIM(50) CTDATA PERRCD(1)

      /SPACE 3
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
      *

     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      ** Data Area giving Installation Control Details

     D PSDS           SDS
      ** Program Status Data Structure
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263

     D SPOOL1          DS
      ** File Information Data Structure for RE000012P1
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0

     D SPOOLU          DS
      ***  File Information Data Structure for RE000012AU
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0

      ***  Dummy Data Structures used by Access Programs.

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  External data structures for Bank Details

     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ***  External data structures for Branch Details

     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ***  External data structures for Currency Details

     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
      ***  External data structures for Nostro Details
      *                                                                                       CAP204
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CAP204
      ** Switcable Features file                                                              CAP204

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  Short data structures for Access Objects

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long data structure for access objects

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D                 DS
     D  R1PSTA                 1     21
     D  WkAmt                  1     19
     D  WkInd                 20     21
                                                                                              CRE010
     D                 DS                                                                     CRE010
     D  TRYP                   1      2                                                       CRE010
     D  TRYP1                  1      1                                                       CRE010
     D  TRYP2                  2      2                                                       CRE010
                                                                                              CRE010
     D WkOpen          S              1
     D PSequ           S              5
     D PEnty           S              3
     D PRtCd           S              7
     D POptn           S              7
     D PCust           S             10
     D PCcy            S              3
     D PBrca           S              3
     D PStKey          S              7
     D PFld15          S             15  0
     D PDecs           S              1  0
     D PECode          S              1
     D Zout21          S             21
     D PZSErr          S              1
     D PZSNum          S              6  0
     D PSFile          S             10
     D PDayNo          S              5  0
     D PDateN          S              6  0
     D PDateA          S              7
     D WRun            S              1
     D PCNum           S              6
     D PAcCd           S             10
     D PAcSq           S              2
     D PNoNb           S              2
     D PBrCd           S              3
     D PCsSn           S             10
     D PPNoI           S              1
     D*PValK1***       S             20                                                      BUG4596
     D*PVal1****       S            200                                                      BUG4596
     D*PValK2***       S             20                                                      BUG4596
     D*PVal2****       S            200                                                      BUG4596
     D*PValK3***       S             20                                                      BUG4596
     D*PVal3****       S            200                                                      BUG4596
     D*PValK4***       S             20                                                      BUG4596
     D*PVal4****       S            200                                                      BUG4596
     D*PValK5***       S             20                                                      BUG4596
     D*PVal5****       S            200                                                      BUG4596
     D*PValK6***       S             20                                                      BUG4596
     D*PVal6****       S            200                                                      BUG4596
     D*PValK7***       S             20                                                      BUG4596
     D*PVal7****       S            200                                                      BUG4596
     D*PValK8***       S             20                                                      BUG4596
     D*PVal8****       S            200                                                      BUG4596
     D*PValK9***       S             20                                                      BUG4596
     D*PVal9****       S            200                                                      BUG4596
     D*PValK0***       S             20                                                      BUG4596
     D*PVal0****       S            200                                                      BUG4596
     D WkCLBLN         S             15  0
     D WkCLBL          S             15  0
     D WkAvBalM        S             15  0
     D WkAvBalA        S             15  0
     D WkMinBalF       S              1
     D RQDLN1          S              3  0
     D DIFLN1          S              3  0
     D WkNostro        S              1
     D WkOvrDrw        S              1
     D WkTNMR          S              6  0
     D WkRSAC          S              1                                                       CRE010
     D WkFrACMV        S              1                                                       CRE010
     D WkMINB          S             15  0                                                   BUG4596
     D WkODLN          S             15  0                                                   BUG4596
     D WkBlwMnm        S              1                                                      BUG4596
     D WkAvBalX        S             15  0                                                   BUG4596
     D R1CLBL          S             21                                                      BUG4596
     D CLE134          S              1                                                       CLE134

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
                                                                                              CRE010
     IFFACMVDF                                                                                CRE010
     I              NRTC                        NRTCX                                         CRE010

      *****************************************************************
      /SPACE 3
      *****************************************************************
      /EJECT
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================

      ** Perform Detail Processing.
     C                   EXSR      SRProcess

      ** Output Audit Report and End Program.
     C                   EXSR      SRAudit
      *
      *================================================================
      *  P R O G R A M   E N D                                        *
      *================================================================
     C/EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

      ** Set up copyright parameter
     C                   MOVEA     CPY@          ACT@             80

      ** Receive Parameter List.
     C     *ENTRY        PLIST
     C                   PARM                    PSequ
     C                   PARM                    PEnty

      ** Receive Parameter List.
     C     KAccnt        KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    CNUM
     C                   KFLD                    CCY
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ

      ** Initialise LDA field.
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVEL     'RE000012'    DBPGM
     C                   OUT       LDA

     C
      ** Call Access Program for Bank Details - Title, Run Date and
      ** Run Day Number.
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Handle Database Error.
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Check System Date Format, DDMMYY (*IN98 off) ; MMDDYY (*IN98 on)
     C                   IF        BJDFIN = 'M'
     C                   MOVE      *ON           *IN98
     C                   ENDIF

      ***Call*Access Program for System Values                                               BUG4596
     C**********         EVAL      PValK1 = 'CheckMinimumBalance'                            BUG4596
     C**********         CALL      'AOSVALR0'                                                BUG4596
     C**********         PARM      *BLANKS       PRtCd                                       BUG4596
     C**********         PARM                    PValK1                                      BUG4596
     C**********         PARM      *BLANKS       PVal1                                       BUG4596
     C**********         PARM      *BLANKS       PValK2                                      BUG4596
     C**********         PARM      *BLANKS       PVal2                                       BUG4596
     C**********         PARM      *BLANKS       PValK3                                      BUG4596
     C**********         PARM      *BLANKS       PVal3                                       BUG4596
     C**********         PARM      *BLANKS       PValK4                                      BUG4596
     C**********         PARM      *BLANKS       PVal4                                       BUG4596
     C**********         PARM      *BLANKS       PValK5                                      BUG4596
     C**********         PARM      *BLANKS       PVal5                                       BUG4596
     C**********         PARM      *BLANKS       PValK6                                      BUG4596
     C**********         PARM      *BLANKS       PVal6                                       BUG4596
     C**********         PARM      *BLANKS       PValK7                                      BUG4596
     C**********         PARM      *BLANKS       PVal7                                       BUG4596
     C**********         PARM      *BLANKS       PValK8                                      BUG4596
     C**********         PARM      *BLANKS       PVal8                                       BUG4596
     C**********         PARM      *BLANKS       PValK9                                      BUG4596
     C**********         PARM      *BLANKS       PVal9                                       BUG4596
     C**********         PARM      *BLANKS       PValK0                                      BUG4596
     C**********         PARM      *BLANKS       PVal0                                       BUG4596
      **********                                                                             BUG4596
     C**********         IF        PRtCd <> *BLANKS                                          BUG4596
     C**********         IF        PVal1 = '*NRF'                                            BUG4596
     C**** *LOCK         IN        LDA                                                       BUG4596
     C**********         EVAL      DBFILE = 'SDSVALPD'                                       BUG4596
     C**********         EVAL      DBKEY = PValK1                                            BUG4596
     C**********         EVAL      DBASE = 2                                                 BUG4596
     C**********         OUT       LDA                                                       BUG4596
     C**********         EXSR      *PSSR                                                     BUG4596
     C**********         ENDIF                                                               BUG4596
     C**********         ENDIF                                                               BUG4596
      **********                                                                             BUG4596
     C**********         EVAL      WkMinBalF = PVal1                                         BUG4596
      *                                                                                       CAP204
      ** Access SAR details file to determine if Retail Account                               CAP204
      ** Transfer is switched on                                                              CAP204
     C                   CALL      'AOSARDR0'                                                 CAP204
     C                   PARM      *BLANKS       @RTCD             7                          CAP204
     C                   PARM      '*VERIFY'     @OPTN             7                          CAP204
     C                   PARM      'CAP204'      @SARD             6                          CAP204
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP204
      *                                                                                       CAP204
     C                   MOVEL     'N'           CAP204            1                          CAP204
     C     @RTCD         IFEQ      *BLANKS                                                    CAP204
     C                   MOVEL     'Y'           CAP204                                       CAP204
     C                   ELSE                                                                 CAP204
     C     @RTCD         IFNE      '*NRF   '                                                  CAP204
     C     *LOCK         IN        LDA                                                        CAP204
     C                   EVAL      DBASE = 6                                                  CAP204
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAP204
     C                   EVAL      DBKEY = 'CAP204'                                           CAP204
     C                   OUT       LDA                                                        CAP204
     C                   EXSR      *PSSR                                                      CAP204
     C                   ENDIF                                                                CAP204
     C                   ENDIF                                                                CAP204
                                                                                              CLE134
      ** Check if CLE134 is ON                                                                CLE134
                                                                                              CLE134
     C                   CALL      'AOSARDR0'                                                 CLE134
     C                   PARM      *BLANK        @RTCD                                        CLE134
     C                   PARM      '*VERIFY'     @OPTN                                        CLE134
     C                   PARM      'CLE134'      @SARD                                        CLE134
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE134
                                                                                              CLE134
     C                   IF        @RTCD = *BLANK                                             CLE134
     C                   EVAL      CLE134 = 'Y'                                               CLE134
     C                   ELSE                                                                 CLE134
     C                   EVAL      CLE134 = 'N'                                               CLE134
     C                   ENDIF                                                                CLE134

      ** Access RUNDAT for multibranching indicator
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT

     C                   IF        AGMBIN = 'Y'
     C                   MOVE      *ON           *IN37
     C                   ENDIF

      ** Ensure Audit Spool File recorded by RCF.
     C                   MOVEL     SFILEU        PSFile
     C                   Z-ADD     SFNUMU        PZSNum

     C                   EXSR      SRRCFProc

      ** Report Work fields.
     C                   Z-ADD     0             RQDLN1
     C                   Z-ADD     0             DIFLN1

      ** Initialise report fields
     C                   EXSR      SRInitFld

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcess - Subroutine to do the Detail Proccessing          *
      *                                                               *
      *****************************************************************
     C     SRProcess     BEGSR

      ** Check If Only a Single Branch is to be Reported
     C                   IF        PEnty <> 'ALL' AND PEnty <> '   '
     C     PEnty         SETLL     ACCNTJ1
     C                   ENDIF

      ** Read first record from File.
     C                   READ      ACCNTJ1                                89

      ** Do While not End of File
     C                   DOW       *IN89 = *OFF AND PEnty <> 'ALL' AND
     C                             PEnty <> '   ' AND PEnty = BRCA OR
     C                             *IN89 = *OFF AND PEnty = 'ALL' OR
     C                             *IN89 = *OFF AND PEnty = '   '

      ** Check if Nostro
     C                   EXSR      SRChkIfNost

     C                   IF        WkNostro = 'N' AND F1IABC = 'Y'

      ** Check if Overdrawn for the day
      ** or below minimum balance                                                            BUG4596
     C                   EXSR      SRChkIfOvrD

      ** If Overdrawn, report
     C                   IF        WkOvrDrw = 'Y'
     C                             OR WkBlwMnm = 'Y'                                         BUG4596

      ** Process Report Lines.
     C                   EXSR      SRReport

      ** Count records read.
     C                   ADD       1             RCOUNT

      ** Endif for If overdrawn
     C                   ENDIF

      ** Endif for If nostro
     C                   ENDIF

      ** Read next record.
     C                   READ      ACCNTJ1                                89

      ** End of Do Until End of Valid Records.
     C                   ENDDO

      ** Write End of Report.
     C                   IF        WkOpen = *ON
     C                   EXSR      SRWriteEnd
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkIfNost - Checks if Retail Account can be found in       *
      *                the Nostro Table                               *
      *                                                               *
      *****************************************************************
     C     SRChkIfNost   BEGSR

     C                   MOVE      BRCA          PBrCd
     C                   MOVE      CNUM          PCNum
     C                   MOVE      CCY           PCcy
     C                   MOVE      ACOD          PAcCd
     C                   MOVE      ACSQ          PAcSq

     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM                    PCNum
     C                   PARM                    PCcy
     C                   PARM                    PAcCd
     C                   PARM                    PAcSq
     C                   PARM      *BLANKS       PNoNb
     C                   PARM                    PBrCd
     C                   PARM      *BLANKS       PCsSn
     C                   PARM      *BLANKS       PPNoI
     C     SDNOST        PARM      *BLANKS       DSFDY

     C                   IF        PRtCd <> *BLANKS AND PRtCd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDNOSTPD'
     C                   EVAL      DBKEY = PBrCd + PCNum + PCcy + PAcCd + PAcSq
     C                   EVAL      DBASE = 3
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      WkNostro = 'Y'
     C                   ELSE
     C                   EVAL      WkNostro = 'N'
     C                   ENDIF
     C
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkIfOvrD - Subroutine that Checks if Account is Projected *
      *                to be Overdrawn                                *
      *                or Projected Cleared Balance will go beyond    *                      BUG4596
      *                Minimum Balance                                *                      BUG4596
      *                                                               *
      *****************************************************************
     C     SRChkIfOvrD   BEGSR

     C                   EVAL      WkOvrDrw = 'N'
     C                   EVAL      WkBlwMnm = 'N'                                            BUG4596

     C     ACNO          CHAIN     MEMOSL2                            90

     C                   IF        *IN90 = *OFF
     C                   Z-SUB     CLBLN         WkCLBLN
     C                   Z-SUB     CLBL          WkCLBL
     C                   EVAL      PCcy = CCY                                                BUG4596
     C                   EXSR      SRGetCurrD                                                BUG4596
     C                   EVAL      WkMINB = MINB * (10**A6NBDP)                              BUG4596
     C                   EVAL      WkODLN = ODLN * (10**A6NBDP)                              BUG4596
     C                   EVAL      WkAvBalM = WkCLBLN - HELD - BCOA
     C                   EVAL      WkAvBalA = WkCLBL  - HELD - BCOA
     C                   EVAL      WkAvBalX = WkCLBLN - WkMINB                               BUG4596

     C**********         IF        ODED >= BJRDNB AND ODLN <> *ZERO                          BUG4596
     C**********         ADD       ODLN          WkAvBalM                                    BUG4596
     C**********         ADD       ODLN          WkAvBalA                                    BUG4596
     C**********         ELSE                                                                BUG4596
     C**********         IF        WkMinBalF = 'Y' AND BCOA = *ZERO                          BUG4596
     C**********         SUB       MINB          WkAvBalM                                    BUG4596
     C**********         SUB       MINB          WkAvBalA                                    BUG4596
     C**********         ENDIF                                                               BUG4596
     C                   IF        ODED >= BJRDNB AND WkODLN <> *ZERO                        BUG4596
     C                   ADD       WkODLN        WkAvBalM                                    BUG4596
     C                   ADD       WkODLN        WkAvBalA                                    BUG4596
     C                   ENDIF

     C                   IF        WkAvBalX < *ZERO AND MINB <> 0                            BUG4596
     C                   EVAL      WkBlwMnm = 'Y'                                            BUG4596
     C                   ENDIF                                                               BUG4596
                                                                                             BUG4596
     C                   IF        WkAvBalM < *ZERO
     C                   EVAL      WkOvrDrw = 'Y'
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReport - Process Report Lines                              *
      *                                                               *
      *****************************************************************
     C     SRReport      BEGSR

      ** Branch Level Break
     C                   IF        BRCA <> A8BRCD

     C                   IF        WkOpen = *ON
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
     C                   Z-ADD     4             RQDLN1
     C                   EVAL      DIFLN1 = OFLLN1 - PRTLN1

     C                   IF        DIFLN1 <= RQDLN1
     C                   WRITE     RE000012R0
     C                   EXSR      SRWriteAccD
     C                   ENDIF

     C                   WRITE     RE000012R4
     C                   CLOSE     RE000012P1
     C                   ENDIF

      ** Open RE000012P1 and register in RCF
     C                   OPEN      RE000012P1
     C                   MOVE      *ON           WkOpen

      ** Ensure Report Spool File recorded by RCF.
     C                   MOVE      SFILE1        PSFile
     C                   Z-ADD     SFNUM1        PZSNum

     C                   EXSR      SRRCFProc

     C                   MOVEL     BRCA          A8BRCD
     C                   EVAL      PBrca = BRCA
     C                   EXSR      SRGetBrchD

      ** Write out the Header
     C                   WRITE     RE000012R0
     C                   ENDIF

     C                   EXSR      SRWriteAccD

      ** Set report detail fields
     C                   EXSR      SRReadRSAC
                                                                                              CRE010
      ** Set report detail fields for records read from FFACMVD                               CRE010
     C                   EXSR      SRReadFFAC                                                 CRE010

      ** Initialize Report Fields
     C                   EXSR      SRInitFld

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReadRSAC - Subroutine that Reads Through RSACMTPD          *
      *                                                               *
      *****************************************************************
     C     SRReadRSAC    BEGSR

     C     KAccnt        SETLL     RSACMTL8
     C     KAccnt        READE     RSACMTL8

     C                   IF        NOT(%EOF(RSACMTL8)) AND VUDT <= BJRDNB
     C                   EXSR      SRWriteTrnH
     C                   EVAL      WkRSAC = 'Y'                                               CRE010
     C                   ENDIF

     C                   DOW       NOT(%EOF(RSACMTL8)) AND VUDT <= BJRDNB
                                                                                              CLE134
      ** Process auto-settle = 'C' the same way as 'N', therefore movement in shadow          CLE134
      ** posting with auto-settle ='C' are to be excluded in available balance calc.          CLE134
      ** When XRFI and XRFN are empty proceed processing otherwise read next record           CLE134
                                                                                              CLE134
     C**********         IF        XRFI <> *BLANKS  AND                             CLE134 AR1022006
     C**********                   XRFN <> 0 and CLE134 = 'Y'                       CLE134 AR1022006
     C                   MOVEL     XRFI          PREF              2                       AR1022006
     C                   IF        CLE134 = 'Y'                                            AR1022006
     C                   IF        PREF = 'CL' OR                                          AR1022006
     C                             PREF = 'FE'                                             AR1022006
     C                   ELSE                                                              AR1022006
     C     KAccnt        READE     RSACMTL8                                                   CLE134
     C                   ITER                                                                 CLE134
     C                   ENDIF                                                             AR1022006
     C                   ENDIF                                                                CLE134
     C                                                                                        CLE134
     C                   EVAL      WkFrACMV = 'N'                                             CRE010
     C                   EXSR      SRWriteTrnD
     C     KAccnt        READE     RSACMTL8
     C                   ENDDO

     C                   ENDSR
      *****************************************************************                       CRE010
      /EJECT                                                                                  CRE010
      *****************************************************************                       CRE010
      *                                                               *                       CRE010
      *  SRReadFFAC - Subroutine that Reads Through FFACMVD           *                       CRE010
      *                                                               *                       CRE010
      *****************************************************************                       CRE010
     C     SRReadFFAC    BEGSR                                                                CRE010
                                                                                              CRE010
     C     KAccnt        SETLL     FFACMV3                                                    CRE010
     C     KAccnt        READE     FFACMV3                                                    CRE010
                                                                                              CRE010
     C                   IF        NOT(%EOF(FFACMV3)) AND VUDT <= BJRDNB AND                  CRE010
     C                             WkRSAC = 'N'                                               CRE010
     C                   EXSR      SRWriteTrnH                                                CRE010
     C                   ENDIF                                                                CRE010
                                                                                              CRE010
     C                   DOW       NOT(%EOF(FFACMV3)) AND VUDT <= BJRDNB                      CRE010
     C                   EVAL      WkFrACMV = 'Y'                                             CRE010
     C                   EXSR      SRWriteTrnD                                                CRE010
     C     KAccnt        READE     FFACMV3                                                    CRE010
     C                   ENDDO                                                                CRE010
                                                                                              CRE010
     C                   ENDSR                                                                CRE010
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInitFld - Subroutine that Initialises Report Fields        *
      *                                                               *
      *****************************************************************
     C     SRInitFld     BEGSR

     C                   EVAL      R1ACNO = *BLANKS
     C                   EVAL      R1CURR = *BLANKS
     C                   EVAL      R1CLBL = *BLANKS
     C                   EVAL      R1CLBLX = *BLANKS                                         BUG4596
     C                   EVAL      R1OVEX = *BLANKS
     C                   EVAL      R1OVAM = *BLANKS
     C                   EVAL      R1HELD = *BLANKS
     C                   EVAL      R1BCOA = *BLANKS
     C                   EVAL      R1AVBL = *BLANKS
     C                   EVAL      R1TYPE = *BLANKS
     C                   EVAL      R1REFR = *BLANKS
     C                   EVAL      R1PSTA = *BLANKS
     C                   EVAL      R1NARR = *BLANKS
     C                   EVAL      R1PROJ = *BLANKS
     C                   EVAL      R1MINB = *BLANKS                                          BUG4596
     C                   EVAL      WkAvBalM = *ZEROS
     C                   EVAL      WkAvBalA = *ZEROS
     C                   EVAL      WkAvBalX = *ZEROS                                         BUG4596
     C                   EVAL      WkRSAC = 'N'                                               CRE010
     C                   EVAL      WkFrACMV = 'N'                                             CRE010

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetRTrnD - Subroutine to Setup Report Details of the       *
      *               Transaction                                     *
      *                                                               *
      *****************************************************************
     C     SRSetRTrnD    BEGSR

      ** Determine Transaction Types
     C                   MOVEL     TNMR          WkTNMR                                       CRE010

     C**********         SELECT                                                               CRE010
      **********                                                                              CRE010
      ***Common*                                                                              CRE010
     C**********         WHEN      TRYP = 'OP' OR TRYP = 'PI' OR TRYP = 'SI' OR               CRE010
     C**********                   TRYP = 'SC' OR TRYP = 'TS' OR TRYP = 'CI'                  CRE010
      **********                                                                              CRE010
     C**********         EXSR      SRChkCommon                                                CRE010
      **********                                                                              CRE010
      ***Journal Entries                                                                      CRE010
     C**********         WHEN      TRYP = 'ME'                                                CRE010
     C**********         EVAL      R1TYPE = TArr(1)                                           CRE010
      **********                                                                              CRE010
      ***FX*Deal                                                                              CRE010
     C**********         WHEN      TRYP = 'FP' OR TRYP = 'FS' OR TRYP = 'CX' OR               CRE010
     C**********                   TRYP = 'OP' OR TRYP = 'OT' OR TRYP = 'SW' OR               CRE010
     C**********                   TRYP = 'SI' OR TRYP = 'PI'                                 CRE010
     C**********         EVAL      R1TYPE = TArr(2)                                           CRE010
      **********                                                                              CRE010
      ***MM*Deal                                                                              CRE010
     C**********         WHEN      TRYP = 'IT' OR TRYP = 'IP' OR TRYP = 'TD' OR               CRE010
     C**********                   TRYP = 'TI' OR TRYP = 'CI' OR TRYP = 'CD' OR               CRE010
     C**********                   TRYP = 'CL' OR TRYP = 'DL' OR TRYP = 'FL' OR               CRE010
     C**********                   TRYP = 'FT' OR TRYP = 'DT' OR TRYP = 'LT' OR               CRE010
     C**********                   TRYP = 'DP' OR TRYP = 'LP'                                 CRE010
     C**********         EVAL      R1TYPE = TArr(3)                                           CRE010
      **********                                                                              CRE010
      ***NA*Purchase                                                                          CRE010
     C**********         WHEN      TRYP = 'C1' OR TRYP = 'C2' OR TRYP = 'BP' OR               CRE010
     C**********                   TRYP = 'BD' OR TRYP = 'TB' OR TRYP = 'DA' OR               CRE010
     C**********                   TRYP = 'TA'                                                CRE010
     C**********         EVAL      R1TYPE = TArr(4)                                           CRE010
      **********                                                                              CRE010
      ***NA*Sold                                                                              CRE010
     C**********         WHEN      TRYP = 'CS' OR TRYP = 'BS' OR TRYP = 'BR' OR               CRE010
     C**********                   TRYP = 'TS' OR TRYP = 'RA' OR TRYP = 'TR'                  CRE010
     C**********         EVAL      R1TYPE = TArr(5)                                           CRE010
      **********                                                                              CRE010
      ***Deal*Amendment                                                                       CRE010
     C**********         WHEN      TRYP = 'PI' OR TRYP = 'PD' OR TRYP = 'SC' OR               CRE010
     C**********                   TRYP = 'SI' OR TRYP = 'CI'                                 CRE010
     C**********         EVAL      R1TYPE = TArr(6)                                           CRE010
      **********                                                                              CRE010
      ***Manual*Repayment                                                                     CRE010
     C**********         WHEN      TRYP = 'MR'                                                CRE010
     C**********         EVAL      R1TYPE = TArr(7)                                           CRE010
      **********                                                                              CRE010
      ***Scheduled Repayment                                                                  CRE010
     C**********         WHEN      TRYP = 'RE'                                                CRE010
     C**********         EVAL      R1TYPE = TArr(8)                                           CRE010
      **********                                                                              CRE010
      ***Incoming Payment                                                                     CRE010
     C**********         WHEN      TRYP = 'IN'                                                CRE010
     C**********         EVAL      R1TYPE = TArr(9)                                           CRE010
      **********                                                                              CRE010
      ***Outgoing Payment                                                                     CRE010
     C**********         WHEN      TRYP = 'OP'                                                CRE010
     C**********         EVAL      R1TYPE = TArr(10)                                          CRE010
      **********                                                                              CRE010
      ***Request for Transfer                                                                 CRE010
     C**********         WHEN      TRYP = 'RI' OR TRYP = 'RO'                                 CRE010
     C**********         EVAL      R1TYPE = TArr(11)                                          CRE010
      **********                                                                              CRE010
      ***Customer Credit Transfer                                                             CRE010
     C**********         WHEN      TRYP = 'BI' OR TRYP = 'BO'                                 CRE010
     C**********         EVAL      R1TYPE = TArr(12)                                          CRE010
      **********                                                                              CRE010
      ***Customer Exchanges                                                                   CRE010
     C**********         WHEN      TRYP = 'CE'                                                CRE010
     C**********         EVAL      R1TYPE = TArr(13)                                          CRE010
      **********                                                                              CRE010
      ***Standing Orders                                                                      CRE010
     C**********         WHEN      TRYP = 'SO'                                                CRE010
     C**********         EVAL      R1TYPE = TArr(14)                                          CRE010
      **********                                                                              CRE010
      ***Caps,*Collars and Floors                                                             CRE010
     C**********         WHEN      TRYP = 'RF' OR TRYP = 'RP' OR TRYP = 'RR'                  CRE010
     C**********         EVAL      R1TYPE = TArr(15)                                          CRE010
      **********                                                                              CRE010
      ***Forward Rate Agreement                                                               CRE010
     C**********         WHEN      TRYP = 'FR'                                                CRE010
     C**********         EVAL      R1TYPE = TArr(16)                                          CRE010
      **********                                                                              CRE010
      ***Cross*Currency Interest Rate Swaps                                                   CRE010
     C**********         WHEN      TRYP = 'RX'                                                CRE010
     C**********         EVAL      R1TYPE = TArr(17)                                          CRE010
      **********                                                                              CRE010
      ***Single*Currency Interest Rate Swaps                                                  CRE010
     C**********         WHEN      TRYP = 'RS'                                                CRE010
     C**********         EVAL      R1TYPE = TArr(18)                                          CRE010
      **********                                                                              CRE010
      ***Loans**                                                                              CRE010
     C**********         WHEN      TRYP = 'HT' OR TRYP = 'HD' OR TRYP = 'HC' OR               CRE010
     C**********                   TRYP = 'HP' OR TRYP = 'HS' OR TRYP = 'HA' OR               CRE010
     C**********                   TRYP = 'HR' OR TRYP = 'HG' OR TRYP = 'HB' OR               CRE010
     C**********                   TRYP = 'HE' OR TRYP = 'HF' OR TRYP = 'HH'                  CRE010
     C**********         EVAL      R1TYPE = TArr(19)                                          CRE010
      **********                                                                              CRE010
      ***Loan*Amendment                                                                       CRE010
     C**********         WHEN      TRYP = 'PI' OR TRYP = 'BC' OR TRYP = 'SC' OR               CRE010
     C**********                   TRYP = 'SA' OR TRYP = 'LS'                                 CRE010
     C**********         EVAL      R1TYPE = TArr(20)                                          CRE010
      **********                                                                              CRE010
      ***Fees***                                                                              CRE010
     C**********         WHEN      TRYP = 'F1' OR TRYP = 'F2'                                 CRE010
     C**********         EVAL      R1TYPE = TArr(21)                                          CRE010
      **********                                                                              CRE010
      ***Trades*                                                                              CRE010
     C**********         WHEN      TRYP = 'TS' OR TRYP = 'TP'                                 CRE010
     C**********         EVAL      R1TYPE = TArr(22)                                          CRE010
      **********                                                                              CRE010
      ***'Catchall' - Other                                                                   CRE010
     C**********         OTHER                                                                CRE010
     C**********         EVAL      R1TYPE = TArr(25)                                          CRE010
      **********                                                                              CRE010
     C**********         ENDSL                                                                CRE010
                                                                                              CRE010
      ** Journal Entries                                                                      CRE010
     C                   IF        TRYP = 'ME'                                                CRE010
     C                   EVAL      R1TYPE = TArr(1)                                           CRE010
     C                   ENDIF                                                                CRE010
                                                                                              CRE010
      ** Repos, Pledge Deposits and Bond Lending                                              CRE010
     C                   IF        TRYP = 'RP' OR TRYP = 'RR' OR                              CRE010
     C                             TRYP = 'PD' OR TRYP = 'BL'                                 CRE010
     C                   EVAL      R1TYPE = TArr(2)                                           CRE010
     C                   ENDIF                                                                CRE010
                                                                                              CRE010
      ** FX Deal                                                                              CRE010
     C                   IF        TRYP = 'FP' OR TRYP = 'FS' OR TRYP = 'CX' OR               CRE010
     C                             TRYP = 'OP' OR TRYP = 'OT' OR TRYP = 'SW' OR               CRE010
     C                             TRYP = 'SI' OR TRYP = 'PI'                                 CRE010
     C     WkTNMR        CHAIN     FXDEALLL                                                   CRE010
     C                   IF        NOT(%EOF(FXDEALLL))                                        CRE010
     C                   EVAL      R1TYPE = TArr(3)                                           CRE010
     C                   ENDIF                                                                CRE010
     C                   ENDIF                                                                CRE010
                                                                                              CRE010
      ** MM Deal                                                                              CRE010
     C                   IF        TRYP = 'IT' OR TRYP = 'IP' OR TRYP = 'TD' OR               CRE010
     C                             TRYP = 'TI' OR TRYP = 'CI' OR TRYP = 'CD' OR               CRE010
     C                             TRYP = 'CL' OR TRYP = 'DL' OR TRYP = 'FL' OR               CRE010
     C                             TRYP = 'FT' OR TRYP = 'DT' OR TRYP = 'LT' OR               CRE010
     C                             TRYP = 'DP' OR TRYP = 'LP'                                 CRE010
     C     WkTNMR        CHAIN     MMDEALLL                                                   CRE010
     C                   IF        NOT(%EOF(MMDEALLL))                                        CRE010
     C                   EVAL      R1TYPE = TArr(4)                                           CRE010
     C                   ENDIF                                                                CRE010
     C                   ENDIF                                                                CRE010
                                                                                              CRE010
      ** NA Purchase                                                                          CRE010
     C                   IF        TRYP = 'C1' OR TRYP = 'C2' OR TRYP = 'BP' OR               CRE010
     C                             TRYP = 'BD' OR TRYP = 'TB' OR TRYP = 'DA' OR               CRE010
     C                             TRYP = 'TA'                                                CRE010
     C                   EVAL      R1TYPE = TArr(5)                                           CRE010
     C                   ENDIF                                                                CRE010
                                                                                              CRE010
      ** NA Sold                                                                              CRE010
     C                   IF        TRYP = 'CS' OR TRYP = 'BS' OR TRYP = 'BR' OR               CRE010
     C                             TRYP = 'TS' OR TRYP = 'RA' OR TRYP = 'TR'                  CRE010
     C     WkTNMR        CHAIN     MMDEALLL                                                   CRE010
     C                   IF        NOT(%EOF(MMDEALLL))                                        CRE010
     C                   EVAL      R1TYPE = TArr(6)                                           CRE010
     C                   ENDIF                                                                CRE010
     C                   ENDIF                                                                CRE010
                                                                                              CRE010
      ** Deal Amendment                                                                       CRE010
     C                   IF        TRYP = 'PI' OR TRYP = 'PD'                                 CRE010
     C     WkTNMR        CHAIN     DEAMSD                                                     CRE010
     C                   IF        NOT(%EOF(DEAMSD))                                          CRE010
     C                   EVAL      R1TYPE = TArr(7)                                           CRE010
     C                   ENDIF                                                                CRE010
     C                   ENDIF                                                                CRE010
                                                                                              CRE010
      ** Manual Repayment                                                                     CRE010
     C                   IF        TRYP = 'MR'                                                CRE010
     C                   EVAL      R1TYPE = TArr(8)                                           CRE010
     C                   ENDIF                                                                CRE010
                                                                                              CRE010
      ** Scheduled Repayment                                                                  CRE010
     C                   IF        TRYP = 'RE'                                                CRE010
     C                   EVAL      R1TYPE = TArr(9)                                           CRE010
     C                   ENDIF                                                                CRE010
                                                                                              CRE010
      ** Incoming Payment                                                                     CRE010
     C                   IF        TRYP = 'IN'                                                CRE010
     C                   EVAL      R1TYPE = TArr(10)                                          CRE010
     C                   ENDIF                                                                CRE010
                                                                                              CRE010
      ** Outgoing Payment                                                                     CRE010
     C                   IF        TRYP = 'OP' AND FUND <> *BLANKS                            CRE010
     C                   EVAL      R1TYPE = TArr(11)                                          CRE010
     C                   ENDIF                                                                CRE010
                                                                                              CRE010
      ** Request for Transfer                                                                 CRE010
     C                   IF        TRYP = 'RI' OR TRYP = 'RO'                                 CRE010
     C                   EVAL      R1TYPE = TArr(12)                                          CRE010
     C                   ENDIF                                                                CRE010
                                                                                              CRE010
      ** Customer Credit Transfer                                                             CRE010
     C                   IF        TRYP = 'BI' OR TRYP = 'BO'                                 CRE010
     C                   EVAL      R1TYPE = TArr(13)                                          CRE010
     C                   ENDIF                                                                CRE010
                                                                                              CRE010
      ** Customer Exchanges                                                                   CRE010
     C                   IF        TRYP = 'CE'                                                CRE010
     C                   EVAL      R1TYPE = TArr(14)                                          CRE010
     C                   ENDIF                                                                CRE010
                                                                                              CRE010
      ** Standing Orders                                                                      CRE010
     C                   IF        TRYP = 'SO'                                                CRE010
     C                   EVAL      R1TYPE = TArr(15)                                          CRE010
     C                   ENDIF                                                                CRE010
                                                                                              CRE010
      ** Caps, Collars and Floors                                                             CRE010
     C                   IF        TRYP = 'RF' OR TRYP = 'RP' OR TRYP = 'RR'                  CRE010
     C     WkTNMR        CHAIN     DLDLDGLE                                                   CRE010
     C                   IF        NOT(%EOF(DLDLDGLE))                                        CRE010
     C                   EVAL      R1TYPE = TArr(16)                                          CRE010
     C                   ENDIF                                                                CRE010
     C                   ENDIF                                                                CRE010
                                                                                              CRE010
      ** Forward Rate Agreement                                                               CRE010
     C                   IF        TRYP = 'FR'                                                CRE010
     C                   EVAL      R1TYPE = TArr(17)                                          CRE010
     C                   ENDIF                                                                CRE010
                                                                                              CRE010
      ** Cross Currency Interest Rate Swaps                                                   CRE010
     C                   IF        TRYP = 'RX'                                                CRE010
     C                   EVAL      R1TYPE = TArr(18)                                          CRE010
     C                   ENDIF                                                                CRE010
                                                                                              CRE010
      ** Single Currency Interest Rate Swaps                                                  CRE010
     C                   IF        TRYP = 'RS'                                                CRE010
     C                   EVAL      R1TYPE = TArr(19)                                          CRE010
     C                   ENDIF                                                                CRE010
                                                                                              CRE010
      ** Loans/Parts Purchase/Sold                                                            CRE010
     C                   IF        TRYP1 = 'H' OR TRYP1 = 'J' OR TRYP1 = 'K'                  CRE010
     C                   EVAL      R1TYPE = TArr(20)                                          CRE010
     C                   ENDIF                                                                CRE010
                                                                                              CRE010
      ** Loan Amendment                                                                       CRE010
     C                   IF        TRYP = 'PI'                                                CRE010
     C*****WkTNMR        CHAIN     LOAMSOM4                                            CRE010 CLE148
     C     TNMR          CHAIN     LOAMSOM4                                                   CLE148
     C                   IF        NOT(%EOF(LOAMSOM4))                                        CRE010
     C                   EVAL      R1TYPE = TArr(21)                                          CRE010
     C                   ENDIF                                                                CRE010
     C                   ENDIF                                                                CRE010
                                                                                              CRE010
      ** Fees                                                                                 CRE010
     C                   IF        TRYP = 'F1' OR TRYP = 'F2'                                 CRE010
     C                   EVAL      R1TYPE = TArr(22)                                          CRE010
     C                   ENDIF                                                                CRE010
                                                                                              CRE010
      ** Trades                                                                               CRE010
     C                   IF        TRYP = 'TS' OR TRYP = 'TP'                                 CRE010
     C     TNMR          CHAIN     SETRADL3                                                   CRE010
     C                   IF        NOT(%EOF(SETRADL3))                                        CRE010
     C                   EVAL      R1TYPE = TArr(23)                                          CRE010
     C                   ENDIF                                                                CRE010
     C                   ENDIF                                                                CRE010
                                                                                              CRE010
      ** Exchange Traded Instruments                                                          CRE010
     C                   IF        (TRYP = ' P' OR TRYP = ' S') AND                           CRE010
     C                             WkFrACMV = 'Y'                                             CRE010
     C                   EVAL      R1TYPE = TArr(24)                                          CRE010
     C                   ENDIF                                                                CRE010
                                                                                              CRE010
      ** OTCs                                                                                 CRE010
     C                   IF        (TRYP = ' P' OR TRYP = ' S') AND                           CRE010
     C                             WkFrACMV = 'N'                                             CRE010
     C                   EVAL      R1TYPE = TArr(25)                                          CRE010
     C                   ENDIF                                                                CRE010
      *                                                                                       CAP204
      ** Retail Account Transfer                                                              CAP204
     C                   IF        CAP204 = 'Y' AND TRYP = 'ZT'                               CAP204
     C                   EVAL      R1TYPE = TArr(27)                                          CAP204
     C                   ENDIF                                                                CAP204
                                                                                              CRE010
      ** 'Catchall' - Other                                                                   CRE010
     C                   IF        R1TYPE = *BLANKS                                           CRE010
     C                   EVAL      R1TYPE = TArr(26)                                          CRE010
     C                   ENDIF                                                                CRE010

     C                   IF        FUND <> *BLANKS
     C                   MOVEL     FUND          R1REFR
     C                   ELSE
     C                   IF        CAP204 = 'Y' AND TRYP = 'ZT'                               CAP204
     C                   MOVEL     OTR1          R1REFR                                       CAP204
     C                   ELSE                                                                 CAP204
     C                   MOVEL     TNMR          R1REFR
     C                   ENDIF                                                                CAP204
     C                   ENDIF

      ** Format Movement Amount
     C                   EVAL      PFld15 = MVAM
     C                   EXSR      SRFmtAmt
     C                   MOVE      ZOut21        WkAmt
     C                   IF        DORC = 1
     C                   EVAL      WkInd = 'CR'
     C                   ELSE
     C                   EVAL      WkInd = 'DR'
     C                   ENDIF

     C                   MOVEL     NRTD          R1NARR

      ** Compute and Format Project Available Amount
     C                   IF        DORC = 1
     C                   ADD       MVAM          WkAvBalA
     C                   ELSE
     C                   SUB       MVAM          WkAvBalA
     C                   ENDIF

     C                   EVAL      PFld15 = WkAvBalA
     C                   EXSR      SRFmtAmt
     C                   EVAL      R1PROJ = ZOut21

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CRE010
      **********                                                      *                       CRE010
      ***SRChkCommon - Subroutine to Sort Out Common Transaction      *                       CRE010
      **********       Types                                          *                       CRE010
      **********                                                      *                       CRE010
      *****************************************************************                       CRE010
     C*****SRChkCommon   BEGSR                                                                CRE010
      **********                                                                              CRE010
     C**********         MOVEL     TNMR          WkTNMR                                       CRE010
     C**********         MOVEA     '1111111'     *IN(30)                                      CRE010
      **********                                                                              CRE010
     C**********         IF        TRYP = 'OP' AND FUND <> *BLANKS                            CRE010
     C**********         EVAL      *IN30 = *OFF                                               CRE010
     C**********         ENDIF                                                                CRE010
     C**********         IF        TRYP = 'OP' OR TRYP = 'SI' OR TRYP = 'PI'                  CRE010
     C*****WkTNMR        CHAIN     FXDEALLL                           31                      CRE010
     C**********         ENDIF                                                                CRE010
     C**********         IF        TRYP = 'TS'                                                CRE010
     C*****WkTNMR        CHAIN     MMDENSP0                           32                      CRE010
     C**********         ENDIF                                                                CRE010
     C**********         IF        TRYP = 'CI'                                                CRE010
     C*****WkTNMR        CHAIN     MMDELDP0                           33                      CRE010
     C**********         ENDIF                                                                CRE010
     C**********         IF        TRYP = 'PI' OR TRYP = 'CI' OR TRYP = 'SC' OR               CRE010
     C**********                   TRYP = 'SI'                                                CRE010
     C*****WkTNMR        CHAIN     DEAMSD                             34                      CRE010
     C**********         ENDIF                                                                CRE010
     C**********         IF        TRYP = 'PI' OR TRYP = 'SC'                                 CRE010
     C*****WkTNMR        CHAIN     LOAMSOM4                           35                      CRE010
     C**********         ENDIF                                                                CRE010
     C**********         IF        TRYP = 'TS'                                                CRE010
     C*****TNMR          CHAIN     SETRADL3                           36                      CRE010
     C**********         ENDIF                                                                CRE010
      **********                                                                              CRE010
     C**********         SELECT                                                               CRE010
     C**********         WHEN      *IN30 = *OFF                                               CRE010
     C**********         EVAL      R1TYPE = TArr(10)                                          CRE010
     C**********         WHEN      *IN31 = *OFF                                               CRE010
     C**********         EVAL      R1TYPE = TArr(2)                                           CRE010
     C**********         WHEN      *IN32 = *OFF                                               CRE010
     C**********         EVAL      R1TYPE = TArr(5)                                           CRE010
     C**********         WHEN      *IN33 = *OFF                                               CRE010
     C**********         EVAL      R1TYPE = TArr(3)                                           CRE010
     C**********         WHEN      *IN34 = *OFF                                               CRE010
     C**********         EVAL      R1TYPE = TArr(6)                                           CRE010
     C**********         WHEN      *IN35 = *OFF                                               CRE010
     C**********         EVAL      R1TYPE = TArr(20)                                          CRE010
     C**********         WHEN      *IN36 = *OFF                                               CRE010
     C**********         EVAL      R1TYPE = TArr(22)                                          CRE010
     C**********         OTHER                                                                CRE010
     C**********         EVAL      R1TYPE = TArr(25)                                          CRE010
     C**********         ENDSL                                                                CRE010
      **********                                                                              CRE010
     C**********         ENDSR                                                                CRE010
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetRAccD - Subroutine to Setup Report Details of the       *
      *               Account                                         *
      *                                                               *
      *****************************************************************
     C     SRSetRAccD    BEGSR

     C                   MOVE      ACNO          R1ACNO

     C                   EVAL      R1CURR = CCY

      ** Format Cleared Balance
     C                   EVAL      PCcy = CCY
     C                   EXSR      SRGetCurrD
     C                   EVAL      PDecs = A6NBDP
     C                   EVAL      PFld15 = CLBL
     C                   EXSR      SRFmtAmt
     C                   EVAL      R1CLBL = ZOut21
                                                                                             BUG4596
      ** Attach 'DR' or 'CR' to the amount for clarity                                       BUG4596
     C                   IF        CLBL < 0                                                  BUG4596
     C                   MOVE      'D'           R1CLBL                                      BUG4596
     C                   EVAL      R1CLBLX = R1CLBL + 'R'                                    BUG4596
     C                   ENDIF                                                               BUG4596
     C                   IF        CLBL > 0                                                  BUG4596
     C                   MOVE      'C'           R1CLBL                                      BUG4596
     C                   EVAL      R1CLBLX = R1CLBL + 'R'                                    BUG4596
     C                   ENDIF                                                               BUG4596

      ** Format Overdraft Expiry Date
     C                   EVAL      PDayNo = ODED
     C                   EXSR      SRFmtDate
     C                   MOVE      PDateN        R1OVEX

      ** Format Overdraft Amount
     C**********         EVAL      PFld15 = ODLN                                             BUG4596
     C                   EVAL      PFld15 = WkODLN                                           BUG4596
     C                   EXSR      SRFmtAmt
     C                   EVAL      R1OVAM = ZOut21

      ** Format Held Amount
     C                   EVAL      PFld15 = HELD
     C                   EXSR      SRFmtAmt
     C                   EVAL      R1HELD = ZOut21

      ** Format Blocked Collateral Amount
     C                   EVAL      PFld15 = BCOA
     C                   EXSR      SRFmtAmt
     C                   EVAL      R1BCOA = ZOut21

      ** Format Available Balance
     C                   EVAL      PFld15 = WkAvBalA
     C                   EXSR      SRFmtAmt
     C                   EVAL      R1AVBL = ZOut21
                                                                                             BUG4596
      ** Format Minumum Balance                                                              BUG4596
     C                   EVAL      PFld15 = WkMINB                                           BUG4596
     C                   EXSR      SRFmtAmt                                                  BUG4596
     C                   EVAL      R1MINB = ZOut21                                           BUG4596

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtAmt - Subroutine that Formats Amount                    *
      *                                                               *
      *****************************************************************
     C     SRFmtAmt      BEGSR

     C                   CALL      'ZSEDIT'
     C                   PARM                    PFld15
     C                   PARM                    PDecs
     C                   PARM      'J'           PECode
     C                   PARM      *BLANKS       Zout21

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtDate - Subroutine that Formats Date                     *
      *                                                               *
      *****************************************************************
     C     SRFmtDate     BEGSR

     C                   CALL      'ZDATE2'
     C                   PARM                    PDayNo
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         PDateN
     C                   PARM      *BLANKS       PDateA

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetBrchD - Subroutine that Retrieves Branch Details        *
      *                                                               *
      *****************************************************************
     C     SRGetBrchD    BEGSR

      ** Call Access Program for Branch Details.
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PBrca
     C     SDBRCH        PARM      SDBRCH        DSSDY

      ** Handle Database Error.
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBKEY = PBrca
     C                   EVAL      DBASE = 4
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetCurrD - Subroutine that Retrieves Currency Details      *
      *                                                               *
      *****************************************************************
     C     SRGetCurrD    BEGSR

     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCcy
     C     SDCURR        PARM      SDCURR        DSSDY

     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY = PCcy
     C                   EVAL      DBASE = 5
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWriteTrnH - Subroutine to Write Text Headers of the        *
      *                Transaction to the Report                      *
      *                                                               *
      *****************************************************************
     C     SRWriteTrnH   BEGSR

      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
     C                   Z-ADD     3             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C                   IF        DIFLN1 <= RQDLN1
     C                   WRITE     RE000012R0
     C                   EXSR      SRWriteAccD
     C                   ENDIF

      ** Write out Detail Record.
     C                   WRITE     RE000012R2

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWriteAccD - Subroutine to Write Relevant Detail Record of  *
      *                the Account to the Report                      *
      *                                                               *
      *****************************************************************
     C     SRWriteAccD   BEGSR

      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
     C**********         Z-ADD     1             RQDLN1                                      BUG4596
     C                   Z-ADD     2             RQDLN1                                      BUG4596
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C                   IF        DIFLN1 <= RQDLN1
     C                   WRITE     RE000012R0
     C                   ENDIF

      ** Write out Detail Record.
     C                   EXSR      SRSetRAccD
     C                   WRITE     RE000012R1

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWriteTrnD - Subroutine to Write Relevant Detail Record of  *
      *                the Transaction to the Report                  *
      *                                                               *
      *****************************************************************
     C     SRWriteTrnD   BEGSR

      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
     C                   Z-ADD     1             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C                   IF        DIFLN1 <= RQDLN1
     C                   WRITE     RE000012R0
     C                   EXSR      SRWriteAccD
     C                   EXSR      SRWriteTrnH
     C                   ENDIF

      ** Write out Detail Record.
     C                   EXSR      SRSetRTrnD
     C                   WRITE     RE000012R3

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWriteEnd - Subroutine to Write End of Report               *
      *                                                               *
      *****************************************************************
     C     SRWriteEnd    BEGSR

      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
     C**********         Z-ADD     6             RQDLN1                                      BUG4596
     C                   Z-ADD     7             RQDLN1                                      BUG4596
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C                   IF        DIFLN1 <= RQDLN1
     C                   WRITE     RE000012R0
     C                   WRITE     RE000012R1
     C                   WRITE     RE000012R2
     C                   ENDIF

      ** Write out Total Format.
     C                   WRITE     RE000012R4

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Subroutine to Output Audit report and End Program  *
      *                                                               *
      *  Called By: Main Processing, PROCES, *PSSR                    *
      *  Calls: None.                                                 *
      *                                                               *
      *****************************************************************
     C     SRAudit       BEGSR

      ** Output Report Header and File Controls.
     C                   WRITE     HEADAU
     C                   WRITE     CONTROL

      ** If there is a DB Error, Output the DB Error Information.
     C                   IF        *INU7 = *ON
     C                   WRITE     DBERROR
     C                   ELSE

      ** Or, if no records read, Output "No Details" message.
     C     RCOUNT        IFEQ      0
     C                   WRITE     NODTLS
     C                   ENDIF

     C                   ENDIF

      ** End Program and Return.
     C                   MOVE      *ON           *INLR

     C                   RETURN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Error control subroutine                            *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

      ** Check to see that *PSSR has not already been called.
     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   DUMP
     C                   EXSR      SRAudit
     C                   ENDIF

      ** If *PSSR already run, then just end the program here.
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   RETURN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRCFProc - Subroutine to register Printer File via RCF      *
      *                                                               *
      *****************************************************************
     C     SRRCFProc     BEGSR

     C                   CALL      'ZSFILE'
     C                   PARM                    PSequ
     C                   PARM                    PEnty
     C                   PARM                    PSFile
     C                   PARM                    PZSNum
     C                   PARM      *BLANKS       PZSErr

      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
     C                   IF        PZSErr = 'Y'
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
**  CPY@
(c)Finastra International Limited 2004
**  TArr
Journal Entries
Repos/Pledge Dep./Bond Lend.                                                                  CRE010
FX Deal
MM Deal
NA Purchase
NA Sold
Deal Amendment
Manual Repayment
Scheduled Repayment
Incoming Payment
Outgoing Payment
Request for Transfer
Customer Credit Transfer
Customer Exchanges
Standing Orders
Caps, Collars & Floors
Forward Rate Agreement
Cross Currency IRS
Single Currency IRS
Loans/Parts Purchase/Sold                                                                     CRE010
Loan Amendment
Fees
Trades
Exchange Traded Instruments
Over the Counter
Other
Account Transfer                                                                              CAP204
