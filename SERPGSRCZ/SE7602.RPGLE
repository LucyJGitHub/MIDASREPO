     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Allocation per dividend payment summary')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SE7602 - Midas SE Allocations per Dividend Payment Summary   *
      *           Report                                              *
      *                                                               *
      *  Function:  This module will list out all allocations per     *
      *             dividend payment.                                 *
      *                                                               *
      *  Component of: SEC0302 - Midas SE Full List (On Request)      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSE071             Date 19Jul05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 193312             Date 18May01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 190204             Date 31May01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 189201             Date 25Jan01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 186107             Date 08Nov00               *
      *                 186043             Date 02Nov00               *
      *                 185735             Date 25Oct00               *
      *                 CSE023  *CREATE    Date 12Jul00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  193312 - To avoid Database Error if if event is created      *
      *           by using position settelement I/C option            *
      *           In this case, evnet does not exist in file SEDEVD   *
      *  190204 - Changed Dividend per Unit format from 9N0 to 13N8.  *
      *  189201 - Additional selection fields                         *
      *  186107 - Add a column for nominal in SE7602P1                *
      *  186043 - Remove Beneficial Owner                             *
      *  185735 - Database error occured if position settlement has   *
      *           no tax basket attached to it                        *
      *  CSE023 - Treaty Withholding Tax                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         Printing spaces in report                       *
      *    02         End of file for SDWTCSL3                        *
      *    03         Error while reading file SDWTCSL3               *
      *    04         Record not found in SECTY                       *         186107
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRPrnt - Print details                                        *
      * SREnd - Write trailer in report                               *
      * SRAudt - Write audit report                                   *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Position Settlement by Depot and Tax Basket Details
     FPOSETW7   IF   E           K DISK    INFSR(*PSSR)
     FSECED     IF   E           K DISK    INFSR(*PSSR)
     FSECORFLC  IF   E           K DISK    INFSR(*PsSR)
     FSECODVL2  IF   E           K DISK    INFSR(*PsSR)
     FSECTY     IF   E           K DISK    INFSR(*PSSR)                         186107
 
      ** Allocation per Dividend Payment Summary - Detail
     FSE7602P1  O    E             PRINTER INFDS(SPOOL1)
     F                                     USROPN
 
      ** Allocation per Dividend Payment Summary - Audit
     FSE7602AU  O    E             PRINTER INFDS(SPOOLU)
     F                                     USROPN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
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
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D SPOOL1          DS
      *
      ***  File Information Data Structure for SE7602P1.
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0
 
     D SPOOLU          DS
      *
      ***  File Information Data Structure for SE7602AU.
     D   SFILEU               83     92
     D   SFNUMU              123    124B 0
 
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Externally described DS for customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** DS for access programs - short data structure
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D  #DFAC1       E                     EXTFLD(QQDFAC)                                     CGL029
 
      ** Externally described DS for currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** DS for access objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** DS for access objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D PData           DS           100
     D   PSect                 1     10
     D   PVlDt                11     15  0
     D   PEvTp                16     17
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PPSeq           S              5
     D PMode           S              1
 
      ** Parameter list for Access Objects
     D PRtcd           S              7
     D POptn           S              7
     D PCust           S             10
     D PKySt           S              7
     D PCurr           S              3
     D PBrch           S              3A
 
      ** Parameter list for ZDATE2
     D PVDat           S              5  0
     D PFDat           S              6  0
     D PZDat           S              7
 
      ** Parameter list for ZSEDITF
     D ZFld15          S             15  0
     D ZDecs           S              1  0
     D ZECode          S              1
     D ZEChar          S              1
     D ZOut21          S             21
      *
     D WRun            S              1
     D WCtr            S              1
     D WPrtFlg         S              1
     D WOpen           S              1    INZ('N')
     D WBrca           S              3
     D WSect           S             10
     D WNMDP           S              1P 0                                      186107
     D WVDat           S              5  0
     D WVDte           S              5
     D WEvnt           S              2
     D*WDepot***       S              6  0                                                    CSD027
     D WDepot          S              6A                                                      CSD027
     D WRRate          S             13A
     D WCpRte          S             11P 7 INZ(*ZERO)
     D WPrtRec         S              1A   INZ('Y')
     D WPrnt           S              1    INZ('N')
     D WPevt           S              2A
     D WDate           S              5A
     D RQDLN1          S              2  0
     D DIFLN1          S              2  0
     D SENTY           S              3
     D ZSERR           S              1
     D ZSNUM           S              6  0
     D ZSNUMU          S              6  0
     D OldPBCA         S              3A
 
     D WNDIV           S             13  0
     D WTNOML          S             15  0                                      186107
     D WTGRDV          S             15  0
     D WTNTDV          S             15  0
     D WTTXSR          S             15  0
     D WTTXUR          S             15  0
      *
      ** Parameters for AOTXBSR0
     D PIRTCD          S              7A
     D PIOPTN          S              7A
     D PICRTT          S              2A
     D PITXBS          S              2A
     D PIDATE          S              5P 0
     D PINARR          S             15A
     D PIRATE          S              6P 4
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
     C                   EVAL      WBrca = *BLANKS
     C                   EVAL      WSect = *BLANKS
     C                   EVAL      WVdat = 0
     C                   EVAL      WEvnt = *BLANKS
     C**********         EVAL      WDepot = 0                                                 CSD027
     C                   EVAL      WDepot = *BLANKS                                           CSD027
     C                   EVAL      WCtr = 'N'
     C                   EVAL      WPrtFlg = 'N'
 
     C                   EXSR      SRProc
     C                   EXSR      SREnd
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProc - Read file and process details                       *
      *                                                               *
      *****************************************************************
     C     SRProc        BEGSR
 
     C     *LOVAL        SETLL     POSETW7
     C                   READ      POSETW7                              0102
 
     C                   DOW       *IN02 = '0'
 
     C                   IF        *IN01
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBFILE = 'POSETW7'
     C                   EVAL      DBASE = 003
     C                   OUT       LDA
     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        (*IN02 = *OFF AND RECI <> '*' AND
     C***********                  Pmode = '2') OR                                            189201
     C                             Pmode = '2' AND PDUD = AGRDNB) OR                          189201
     C                             (*IN02 = *OFF AND RECI <> '*' AND
     C                             Pmode = '1' AND PSSH = PSect AND
     C                             PDUD = PVlDt AND PEVT = PEvTp)
 
     C                   EVAL      WCtr = 'Y'
     C                   EVAL      WPrtFlg = 'Y'
     C                   EXSR      SRChkPrc
      *
      ** If branch changes, then print heading.
     C                   IF        OldPBCA <> PBCA
     C                   EVAL      OldPBCA = PBCA
     C                   EXSR      SRRtvBrDt
     C                   ENDIF
     C                   EXSR      SRRtvTXRT
 
      ** Process Report Lines.
 
     C                   IF        WPrtRec = 'Y'
     C                   EXSR      SRPrnt
     C                   ENDIF
 
     C                   ENDIF
 
     C                   READ      POSETW7                              0102
 
     C                   ENDDO
 
      ** No record in POSETW7
 
     C                   IF        WPrtFlg = 'N'
     C                   EXSR      SRAudt
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrnt - Print details                                       *
      *                                                               *
      *****************************************************************
     C     SRPrnt        BEGSR
 
     C                   IF        WOpen <> 'Y'
     C                   EVAL      WOpen = 'Y'
     C                   OPEN      SE7602P1
 
      ** Ensure Detail Spool File recorded by RCF.
 
     C                   EVAL      ZSNUM = SFNUM1
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    PPSEQ
     C                   PARM      *BLANKS       SENTY
     C                   PARM                    SFILE1
     C                   PARM                    ZSNUM
     C                   PARM      *BLANK        ZSERR
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
 
     C     ZSERR         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
     C
     C                   ENDIF
 
     C                   EVAL      RQDLN1 = 2
     C                   EVAL      DIFLN1 = OFLLN1 - PRTLN1
 
      ** Overflow, change in security, change in payment date or change in event type
      *
     C                   IF        DIFLN1 <= RQDLN1
     C                   WRITE     HEAD1
     C                   ENDIF
 
     C                   EVAL      WPrnt = 'N'
     C                   IF        WBrca <> PBCA  AND  *IN37 = '1'  OR
     C                             WSect <> PSSH  OR
     C                             WVDat <> PDUD  OR
     C                             WEvnt <> PEVT
 
     C                   IF        WSect <> *BLANKS  AND
     C                             WVDat <> 0  AND
     C                             WEvnt <> *BLANKS
     C                   EXSR      SRFmtT
     C                   WRITE     TRAIL1
     C                   EVAL      WPrnt = 'Y'
     C                   ENDIF
 
     C                   EVAL      WBrca = PBCA
     C                   EVAL      WSect = PSSH
     C                   EVAL      WVDat = PDUD
     C                   EVAL      WEvnt = PEVT
 
     C                   EXSR      SRFmtH
 
      ** Write Header
     C                   WRITE     HEAD1
     C                   WRITE     HEAD2
     C                   IF        WDepot = PCPY
     C                   WRITE     HEAD3
     C                   ENDIF
     C                   ENDIF
 
      ** Change in Depot
     C                   IF        WDepot <> PCPY  AND
     C                             WSect = PSSH  AND
     C                             WVDat = PDUD  AND
     C                             WEvnt = PEVT
 
      ** Write Total
     C**********         IF        WDepot <> 0  AND                                           CSD027
     C                   IF        WDepot <> *BLANKS  AND                                     CSD027
     C                             WPrnt = 'N'
     C                   EXSR      SRFmtT
     C                   WRITE     TRAIL1
     C                   ENDIF
 
     C                   EVAL      WDepot = PCPY
     C                   EXSR      SRDepot
     C                   WRITE     HEAD3
     C                   ENDIF
 
     C                   EXSR      SRFmtD
 
      ** Write Detail
     C                   WRITE     DETAIL1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkPrc - Format header for output.                         *
      *                                                               *
      *****************************************************************
     C     SRChkPrc      BEGSR
 
     C                   EVAL      WPrtRec = 'Y'
     C                   IF        PEVT = 'CP' OR
     C                             PEVT = 'DV'
      *                                                                                       193312
      * Check if date generated is zero. In this case record does not exists                  193312
      * in diary events file                                                                  193312
      *                                                                                       193312
     C     PDTG          IFEQ      0                                                          193312
     C                   EXSR      SRpos                                                      193312
      *                                                                                       193312
     C                   EVAL      WPevt = PEVT                                               193312
      *                                                                                       193312
     C                   ELSE                                                                 193312
      *                                                                                       193312
     C     WKey2         CHAIN     SECED                              03
 
     C                   IF        *IN03 AND
     C                             PEVT = 'CP'
     C                   EVAL      WPevt = PEVT
     C                   EVAL      PEVT = 'CG'
     C     WKey2         CHAIN     SECED                              03
     C                   EVAL      PEVT = WPevt
     C                   ENDIF
 
     C                   IF        *IN03
     C                   MOVEL     PDUD          WVDte
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = PSSH + WVDte + PEVT
     C                   EVAL      DBFILE = 'SECED'
     C                   EVAL      DBASE = 006
     C                   OUT       LDA
     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   EXSR      *PSSR
     C                   ELSE
 
     C                   IF        PEVT = 'CP'
     C                   EVAL      WCpRte = SNCR
     C                   ELSE
     C                   EVAL      WCpRte = SDVA
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                                193312
     C                   ELSE
      *
     C                   IF        PEVT <> 'MT'
     C     WKey2         CHAIN     SECORFLC                           03
     C                   IF        NOT *IN03
     C     MACORF        CHAIN     SECODVL2                           03
     C                   IF        NOT *IN03
     C**********         EVAL      WCpRte = MDDIVU                                            190204
     C                   EVAL      WCpRte = MDDIV1                                            190204
     C                   ELSE
     C                   EVAL      WPrtRec = 'N'
     C                   ENDIF
     C                   ELSE
     C                   EVAL      WPrtRec = 'N'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRtvBrDt - Retrieve branch name.                            *
      *                                                               *
      *****************************************************************
      *
     C     SRRtvBrDt     BEGSR
 
     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM                    PRtCd
     C                   PARM      '*KEY     '   POptn
     C                   PARM      PBCA          PBrch
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 006
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBKEY = PBCA
     C                   OUT       LDA
     C                   EXSR      *PsSR
     C                   ELSE
     C                   EVAL      RBRCD = A8BRCD
     C                   EVAL      RBRNM = A8BRNM
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRtvTXRT - Subroutine to retrive tax rate.                  *
      *                                                               *
      *****************************************************************
      *
     C     SRRtvTXRT     BEGSR
 
     C                   IF        TXBS <> *BLANKS                              185735
                                                                                185735
     C                   CALL      'AOTXBSR0'
     C                   PARM      *BLANKS       PIRTCD
     C                   PARM      '*KEY   '     PIOPTN
     C                   PARM      CRTX          PICRTT
     C                   PARM      TXBS          PITXBS
     C                   PARM      PDUD          PIDATE
     C                   PARM      *BLANKS       PINARR
     C                   PARM      *ZEROS        PIRATE
 
     C                   IF        PIRTCD <> *BLANKS AND
     C                             PIRTCD <> '*NRF   '
     C                   MOVEL     PDUD          WDate
     C                   EVAL      DBKEY  = CRTX + TXBS + WDate
     C                   EVAL      DBFILE = 'SDTXBSPD'
     C                   EVAL      DBASE  = 007
     C                   EXSR      *PSSR
     C                   ENDIF
     C                                                                          185735
     C                   ELSE                                                   185735
     C                   EVAL      PIRATE = 0                                   185735
     C                   ENDIF                                                  185735
 
     C                   IF        PIRTCD = *BLANKS
     C                   EVAL      ZECode = ' '
     C                   MOVE      *BLANKS       ZFld15
     C                   MOVE      PIRATE        ZFld15
     C                   EVAL      ZDecs = 4
     C                   EXSR      SRFmtA
     C                   MOVE      ZOut21        RTXRT
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtH - Format header for output.                           *
      *                                                               *
      *****************************************************************
     C     SRFmtH        BEGSR
      *                                                                         186107
      ** Get security's nominal decimal places.                                 186107
      *                                                                         186107
     C     PSSH          CHAIN     SECTY                              04        186107
     C                   IF        *IN04 = *ON                                  186107
     C     *LOCK         IN        LDA                                          186107
     C                   EVAL      DBKEY = PSSH                                 186107
     C                   EVAL      DBFILE = 'SECTY  '                           186107
     C                   EVAL      DBASE = 8                                    186107
     C                   OUT       LDA                                          186107
     C                   EVAL      *INU7 = '1'                                  186107
     C                   EVAL      *INU8 = '1'                                  186107
     C                   EXSR      *PSSR                                        186107
     C                   ENDIF                                                  186107
      *                                                                         186107
     C                   Z-ADD     NMDP          WNMDP                          186107
 
     C                   EVAL      RSECT = PSSH
     C                   EVAL      RCCY = PNCY
     C                   EXSR      SRCurr
     C                   EVAL      REVNT = PEVT
 
     C                   EVAL      PVDat = PDUD
 
      ** Format date of payment
     C                   CALLB     'ZDATE2'
     C                   PARM                    PVDat
     C                   PARM                    BJDFIN
     C                   PARM                    PFDat
     C                   PARM                    PZDat
 
     C                   EVAL      RDATE = PFDat
 
      ** Format coupon rate
     C                   EVAL      ZDecs = 7
     C                   EVAL      ZECode = ' '
     C                   MOVE      WCpRte        Zfld15
 
     C                   EXSR      SRFmtA
     C                   MOVE      ZOut21        WRRate
     C                   MOVEL     WRRate        RRATE
 
     C                   IF        PEVT = 'MT'
     C                   MOVE      *BLANKS       RRATE
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtD - Format details for output.                          *
      *                                                               *
      *****************************************************************
     C     SRFmtD        BEGSR
 
     C                   EVAL      RNOML = *BLANKS                              186107
     C                   EVAL      RGSCP = *BLANKS
     C                   EVAL      RTXSR = *BLANKS
     C                   EVAL      RTXUR = *BLANKS
     C                   EVAL      RNTCP = *BLANKS
     C***********        EVAL      RBENN = BNFO                                 186043
     C                   EVAL      RTXBT = TXBS
      *                                                                         186107
      ** Nominal                                                                186107
     C                   EVAL      ZECode = 'J'                                 186107
     C                   EVAL      ZFLD15 = 0                                   186107
     C                   EVAL      ZDecs = WNMDP                                186107
     C                   EVAL      WTNOML = WTNOML + PNMP                       186107
     C                   EVAL      ZFLD15 = PNMP                                186107
     C                   EXSR      SRFmtA                                       186107
     C                   MOVE      ZOut21        RNOML                          186107
      *                                                                         186107
     C                   EVAL      ZDecs = A6NBDP
 
      ** Gross Dividend
     C                   EVAL      ZECode = 'J'
     C                   EVAL      ZFLD15 = 0
 
     C                   IF        PEVT = 'MT'
     C                   EVAL      WTGRDV = WTGRDV + DAMT
     C                   EVAL      ZFLD15 = DAMT
     C                   ELSE
     C                   EVAL      WTGRDV = WTGRDV + PAMD
     C                   EVAL      ZFLD15 = PAMD
     C                   ENDIF
 
     C                   EXSR      SRFmtA
     C                   MOVE      ZOut21        RGSCP
 
      ** Withholding Tax by Source
     C                   EVAL      WTTXSR = WTTXSR + TASO
     C                   EVAL      ZFLD15 = 0
     C                   EVAL      ZFLD15 = TASO
     C                   EXSR      SRFmtA
     C                   MOVE      ZOut21        RTXSR
 
      ** Withholding Tax by Source
     C                   EVAL      WTTXUR = WTTXUR + TAUS
     C                   EVAL      ZFLD15 = 0
     C                   EVAL      ZFLD15 = TAUS
     C                   EXSR      SRFmtA
     C                   MOVE      ZOut21        RTXUR
 
      ** Net Dividend
 
     C                   IF        PEVT = 'MT'
     C                   EVAL      WNDIV = DAMT - (TASO + TAUS)
     C                   ELSE
     C                   EVAL      WNDIV = PAMD - (TASO + TAUS)
     C                   ENDIF
 
     C                   EVAL      WTNTDV = WTNTDV + WNDIV
     C                   EVAL      ZFLD15 = 0
     C                   EVAL      ZFLD15 = WNDIV
     C                   EXSR      SRFmtA
     C                   MOVE      ZOut21        RNTCP
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtT - Format trailer for output.                          *
      *                                                               *
      *****************************************************************
     C     SRFmtT        BEGSR
 
     C                   EVAL      RTNOM = *BLANKS                              186107
     C                   EVAL      RTGCP = *BLANKS
     C                   EVAL      RTTSR = *BLANKS
     C                   EVAL      RTTUR = *BLANKS
     C                   EVAL      RTNCP = *BLANKS
                                                                                186107
      ** Total Nominal                                                          186107
     C                   EVAL      ZECode = 'J'                                 186107
     C                   EVAL      ZFLD15 = 0                                   186107
     C                   EVAL      ZDecs = WNMDP                                186107
     C                   EVAL      ZFLD15 = WTNOML                              186107
     C                   EXSR      SRFmtA                                       186107
     C                   MOVE      ZOut21        RTNOM                          186107
                                                                                186107
     C                   EVAL      ZDecs = A6NBDP
 
      ** Total Gross Dividend
     C                   EVAL      ZECode = 'J'
     C                   EVAL      ZFLD15 = 0
     C                   EVAL      ZFLD15 = WTGRDV
     C                   EXSR      SRFmtA
     C                   MOVE      ZOut21        RTGCP
 
      ** Total Withholding Tax by Source
     C                   EVAL      ZFLD15 = 0
     C                   EVAL      ZFLD15 = WTTXSR
     C                   EXSR      SRFmtA
     C                   MOVE      ZOut21        RTTSR
 
      ** Total Withholding Tax by Source
     C                   EVAL      ZFLD15 = 0
     C                   EVAL      ZFLD15 = WTTXUR
     C                   EXSR      SRFmtA
     C                   MOVE      ZOut21        RTTUR
 
      ** Total Net Dividend
     C                   EVAL      ZFLD15 = 0
     c                   EVAL      ZFLD15 = WTNTDV
     C                   EXSR      SRFmtA
     C                   MOVE      ZOut21        RTNCP
 
     C                   EVAL      WTNOML = 0                                   186107
     C                   EVAL      WTGRDV = 0
     C                   EVAL      WTTXSR = 0
     C                   EVAL      WTTXUR = 0
     c                   EVAL      WTNTDV = 0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDepot - Access customer details file for depot name.       *
      *                                                               *
      *****************************************************************
     C     SRDepot       BEGSR
 
     C                   EVAL      PCust = *BLANKS
     C                   MOVE      PCPY          PCust
     C                   EVAL      RDPNM = *BLANKS
 
      ** Access customer details file
 
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCust
     C                   PARM                    PKySt
     C     SDCUST        PARM      SDCUST        DSSDY
 
      ** Database error.
 
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = PCust
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBASE = 002
     C                   OUT       LDA
     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      RDPNM = BBCSSN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtA - Format amount for output.                           *
      *                                                               *
      *****************************************************************
     C     SRFmtA        BEGSR
 
     C                   CALLB     'ZSEDITF'
     C                   PARM                    ZFld15
     C                   PARM                    ZDecs
     C                   PARM                    ZECode
     C                   PARM      *BLANKS       ZEChar
     C                   PARM      *BLANKS       ZOut21
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCurr - Get currency details                                *
      *                                                               *
      *****************************************************************
     C     SRCurr        BEGSR
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      PNCY          PCurr
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** Database error.
 
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = PCurr
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 005
     C                   OUT       LDA
     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREnd - Write trailer in report                              *
      *                                                               *
      *****************************************************************
     C     SREnd         BEGSR
      *
      ** Print total at the end of the report if record was printed
      *
     C                   IF        WPrtRec = 'Y'
     C                   EXSR      SRFmtT
     C                   WRITE     TRAIL1
     C                   ENDIF
 
     C                   EVAL      RQDLN1 = 4
     C                   EVAL      DIFLN1 = OFLLN1 - PRTLN1
     C                   IF        DIFLN1 <= RQDLN1
     C                   WRITE     HEAD1
     C                   WRITE     HEAD2
     C                   ENDIF
 
      ** Write out report trailer.
 
     C                   WRITE     TRAIL2
     C                   EVAL      *INLR = '1'
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudt - Write audit report                                  *
      *                                                               *
      *****************************************************************
     C     SRAudt        BEGSR
 
     C                   OPEN      SE7602AU
 
      ** Ensure Audit Spool File recorded by RCF.
 
     C                   EVAL      ZSNUMU = SFNUMU
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    PPSEQ
     C                   PARM      *BLANKS       SENTY
     C                   PARM                    SFILEU
     C                   PARM                    ZSNUMU
     C                   PARM      *BLANK        ZSERR
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
 
     C     ZSERR         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
 
     C                   WRITE     HEADAU
 
      ** If there is a DB Error, Output the DB Error Information.
 
     C                   IF        *INU7
     C                   WRITE     DBERROR
     C                   ELSE
 
      ** Or, if no records read, Output "No Details" message.
 
     C                   IF        WCtr ='N'
     C                   WRITE     NODTLS
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      *INLR ='1'
     C                   RETURN
 
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
 
     C     *ENTRY        PLIST
     C                   PARM                    PPSEQ
     C                   PARM                    PMode
     C                   PARM                    PDATA
 
     C                   IF        PEvTp = 'MA'
     C                   EVAL      PEvTp = 'MT'
     C                   ENDIF
 
      ** Read in Installation Data
 
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C     *DTAARA       DEFINE                  LDA
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA
      *
     C                   IF        AGMBIN = 'Y'
     C                   EVAL      *IN37 = '1'
     C                   ELSE
     C                   EVAL      *IN37 = '0'
     C                   ENDIF
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error.
 
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   OUT       LDA
     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Report Work fields.
 
     C                   EVAL      RQDLN1 = 0
     C                   EVAL      DIFLN1 = 0
     C                   EVAL      OFLLN1 = 0
     C                   EVAL      PRTLN1 = 0
 
      ** Key fields for SECED
     C     WKEY2         KLIST
     C                   KFLD                    PSSH
     C                   KFLD                    PDUD
     C                   KFLD                    PEVT
 
     C                   ENDSR
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   EXSR      SRAudt
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *********************************************************************                   193312
      /EJECT                                                                                  193312
      *********************************************************************                   193312
      *                                                                   *                   193312
      * SRpos  - Subroutine to retrieve values needed by pgm if           *                   193312
      *          diary event does not exist                               *                   193312
      *                                                                   *                   193312
      * Called by:  SRChkPrc                                              *                   193312
      *                                                                   *                   193312
      * Calls: None                                                       *                   193312
      *                                                                   *                   193312
      *********************************************************************                   193312
     C     SRpos         BEGSR                                                                193312
                                                                                              193312
     C     PSSH          CHAIN     SECTY                              41                      193312
     C                   IF        *IN41                                                      193312
     C     *LOCK         IN        LDA                                                        193312
     C                   EVAL      DBKEY = PSSH                                               193312
     C                   EVAL      DBFILE = 'SECTY'                                           193312
     C                   EVAL      DBASE = 009                                                193312
     C                   OUT       LDA                                                        193312
     C                   EVAL      *INU7 = '1'                                                193312
     C                   EVAL      *INU8 = '1'                                                193312
     C                   EXSR      *PSSR                                                      193312
     C                   ELSE                                                                 193312
     C                   IF        PEVT = 'CP'                                                193312
     C                   EVAL      CPNR = SNCR                                                193312
     C                   EVAL      WCpRte = SNCR                                              193312
     C                   END                                                                  193312
                                                                                              193312
     C                   IF        PEVT = 'DV'                                                193312
     C     PAMD          DIV       PNMP          SDVA                                         193312
     C                   EVAL      WCpRte = SDVA                                              193312
     C                   END                                                                  193312
     C                   END                                                                  193312
                                                                                              193312
     C                   ENDSR                                                                193312
                                                                                              193312
