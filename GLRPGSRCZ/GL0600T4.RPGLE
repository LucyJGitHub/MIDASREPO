     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GL Trailers Update for GL0600')                  *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL0600T4 - Midas GL Trailers update for GL0600               *
      *                                                               *
      *  Function:  Update ACCNTAC, SYSOPZX, CLEARZZ and REOUTLPT     *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD038510           Date 20Jun16               *
      *                 MD036707           Date 26Apr16               *
      *                 MD031057           Date 24Feb15               *
      *                 CGL142  *CREATE    Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD038510 - Statement for system generatd accounts not        *
      *             produced. Rewrite processing STMTAH.              *
      *  MD036707 - GLC0600T4 fail. Correct the retrieval of CRE023   *
      *             Applied for MD037302.                             *
      *  MD031057 - REC002008 00001 failed due to FOOB                *
      *  CGL142 - Tactical COB changes GL                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Function of indicators                                       *
      *  ----------------------                                       *
      *                                                               *
      *     99 - Indicator for read                                   *
      *                                                               *
      *  U7+U8 - Database error                                       *
      *                                                               *
      *****************************************************************
 
      ** Midas GL Accounts Master Trailer
     FACCNTAC   UF   E             DISK    INFSR(*PSSR) COMMIT
     F                                     PREFIX(AC_)
 
      ** Midas GL Accounts Master Trailer Work file
     FGLACCTAC  IF   E             DISK    INFSR(*PSSR)
 
      ** Midas GL A/C Opened by the System Trailer
     FSYSOPZX   UF   E             DISK    INFSR(*PSSR) COMMIT
     F                                     PREFIX(SY_)
 
      ** Midas GL Ac Opened by the System Trailer Work file
     FGLSYSOZX  IF   E             DISK    INFSR(*PSSR)
 
      ** Midas GL Items in Clearing Trailer
     FCLEARZZ   UF   E             DISK    INFSR(*PSSR) COMMIT
     F                                     PREFIX(CL_)
 
      ** Midas GL Items in Clearing Trailer Work file
     FGLCLEAZZ  IF   E             DISK    INFSR(*PSSR)
 
      ** Midas RE Outward Clearing File - Trailer
     FREOUTLPT  UF   E             DISK    INFSR(*PSSR) COMMIT
     F                                     PREFIX(RE_)
 
      ** Midas RE Outward Clearing File - Trailer Work file
     FGLOUTLPT  IF   E             DISK    INFSR(*PSSR)
 
     FSTMTZX    UF   E             DISK    INFSR(*PSSR) COMMIT                              MD038510
     F                                     PREFIX(ST_)                                      MD038510
     FGLSTMTZX  IF   E             DISK    INFSR(*PSSR)                                     MD038510
                                                                                            MD038510
      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA)
 
      ** Program Status Data Structure
     D PSDS           SDS
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
 
      ** Program Variables
     D PostNum         S              1
     D TotHwnd         S             18  0
     D TotHwnc         S             18  0
     D TotHwnd2        S             18  0
     D TotHwnc2        S             18  0
     D TotNore         S              5  0
     D TotNoam         S              5  0
     D TotNocl         S              5  0
     D TotNoau         S              5  0
     D TotNinp         S              5  0
     D TotNord         S              5  0
     D TotNocf         S              5  0
     D TotNamp         S              5  0
     D TotNaup         S              5  0
     D TotNret         S              5  0
     D TotHrwn         S             18  0
     D TotHrwn2        S             18  0
     D TotHwnp         S             18  0
     D TotHwnt         S             18  0
     D TotHwnp2        S             18  0
     D TotHwnt2        S             18  0
 
      ** AOSARDR0 parameters                                                                MD031057
                                                                                            MD031057
     D PRtcd           S              7A                                                    MD031057
     D POption         S              7A                                                    MD031057
     D PSard           S              6A                                                    MD031057
     D DSFDY         E DS                  EXTNAME(DSFDY)                                   MD031057
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                MD031057
                                                                                            MD031057
      ** Switcheable Features Flag                                                          MD031057
                                                                                            MD031057
     D CRE023          S              1A                                                    MD031057
                                                                                            MD031057
      ** Main Processing
 
     C     *ENTRY        PLIST
     C                   PARM                    PostNum
 
      ** Process GLACCTAC and update ACCNTAC
 
     C                   Z-ADD     0             TotHwnd
     C                   Z-ADD     0             TotHwnc
     C                   Z-ADD     0             TotHwnd2
     C                   Z-ADD     0             TotHwnc2
     C                   Z-ADD     0             TotNore
     C                   Z-ADD     0             TotNoam
     C                   Z-ADD     0             TotNocl
     C                   Z-ADD     0             TotNoau
     C                   Z-ADD     0             TotNinp
     C                   Z-ADD     0             TotNord
     C                   Z-ADD     0             TotNocf
     C                   Z-ADD     0             TotNamp
     C                   Z-ADD     0             TotNaup
     C                   Z-ADD     0             TotNret
 
     C                   READ      GLACCTAC                               99
 
     C                   DOW       *IN99 = *OFF
 
     C     NOCL          ADD       TOTNOCL       TOTNOCL
     C     NINP          ADD       TOTNINP       TOTNINP
     C     NORD          ADD       TOTNORD       TOTNORD
     C     NOCF          ADD       TOTNOCF       TOTNOCF
     C     NAMP          ADD       TOTNAMP       TOTNAMP
     C     NAUP          ADD       TOTNAUP       TOTNAUP
     C                   EVAL      TotHwnd = TotHwnd + (HWND * 1000) + HDCD
     C                   EVAL      TotHwnc = TotHwnc + (HWNC * 1000) + HDCC
 
     C                   READ      GLACCTAC                               99
     C                   ENDDO
 
     C     1             CHAIN     ACCNTAC                            99
     C                   IF        *IN99 = *ON
     C                   MOVE      'ACCNTAC'     DBFILE
     C                   Z-ADD     001           DBASE
     C                   EXSR      *PSSR
     C                   ELSE
 
     C     TOTNOCL       ADD       AC_NOCL       AC_NOCL
     C     TOTNINP       ADD       AC_NINP       AC_NINP
     C     TOTNORD       ADD       AC_NORD       AC_NORD
     C     TOTNOCF       ADD       AC_NOCF       AC_NOCF
     C     TOTNAMP       ADD       AC_NAMP       AC_NAMP
 
     C     PostNum       IFEQ      '1'
     C     AC_NOOA       ADD       AC_NINU       AC_NAUP
     C                   ENDIF
     C     TOTNAUP       ADD       AC_NAUP       AC_NAUP
 
     C                   EVAL      TotHwnd2 = (AC_HWND * 1000) + AC_HDCD
     C     TOTHWND       ADD       TOTHWND2      TOTHWND2
     C                   EVAL      AC_HWND = (TotHwnd2 / 1000)
     C                   EVAL      AC_HDCD = TotHwnd2 - (AC_HWND * 1000)
 
     C                   EVAL      TotHwnc2 = (AC_HWNC * 1000) + AC_HDCC
     C     TOTHWNC       ADD       TOTHWNC2      TOTHWNC2
     C                   EVAL      AC_HWNC = (TotHwnc2 / 1000)
     C                   EVAL      AC_HDCC = TotHwnc2 - (AC_HWNC * 1000)
 
     C                   UPDATE    ACCNTACF
 
     C                   ENDIF
 
      ** Process GLSYSOZX AND Update SYSOPZX
 
     C                   Z-ADD     0             TotNore
     C                   READ      GLSYSOZX                               99
     C                   DOW       *IN99 = *OFF
     C     NORE1         ADD       TOTNORE       TOTNORE
     C                   READ      GLSYSOZX                               99
     C                   ENDDO
 
     C     1             CHAIN     SYSOPZX                            99
     C                   IF        *IN99 = *ON
     C                   MOVE      'SYSOPZX'     DBFILE
     C                   Z-ADD     002           DBASE
     C                   EXSR      *PSSR
     C                   ELSE
     C     TOTNORE       ADD       SY_NORE1      SY_NORE1
     C                   UPDATE    SYSOPZXF
     C                   ENDIF
 
      ** Process GLCLEAZZ AND Update CLEARZZ
 
     C                   IF        *INU5 = *ON
     C                   Z-ADD     0             TotHrwn
     C                   Z-ADD     0             TotHrwn2
     C                   Z-ADD     0             TotNore
 
     C                   READ      GLCLEAZZ                               99
     C                   DOW       *IN99 = *OFF
     C     NORE1         ADD       TOTNORE       TOTNORE
     C                   EVAL      TotHrwn  = TotHrwn + (HRWN * 1000) + HRDC
     C                   READ      GLCLEAZZ                               99
     C                   ENDDO
 
     C     1             CHAIN     CLEARZZ                            99
     C     *IN99         IFEQ      *ON
     C                   MOVE      'CLEARZZ'     DBFILE
     C                   Z-ADD     003           DBASE
     C                   EXSR      *PSSR
     C                   ELSE
 
     C     TOTNORE       ADD       CL_NORE1      CL_NORE1
 
     C                   EVAL      TotHrwn2 = (CL_HRWN * 1000) + CL_HRDC
     C     TOTHRWN       ADD       TOTHRWN2      TOTHRWN2
     C                   EVAL      CL_HRWN = (TotHrwn2 / 1000)
     C                   EVAL      CL_HRDC = TotHrwn2 - (CL_HRWN * 1000)
 
     C                   UPDATE    APOSTZZF
 
     C                   ENDIF
     C                   ENDIF
 
      ** Process GLOUTLPT and update REOUTLPT
 
     C******INU4*        IFEQ      *ON                                                      MD031057
     C                   IF        PostNum = '1' and CRE023 = 'Y'                           MD031057
     C                   Z-ADD     0             TotHwnp
     C                   Z-ADD     0             TotHwnt
     C                   Z-ADD     0             TotHwnp2
     C                   Z-ADD     0             TotHwnt2
     C                   Z-ADD     0             TotNore
 
     C                   READ      GLOUTLPT                               99
 
     C                   DOW       *IN99 = *OFF
     C     GNREC         ADD       TOTNORE       TOTNORE
     C                   EVAL      TotHwnp  = TotHwnp + (GHWNP * 1000) + GHDCP
     C                   EVAL      TotHwnt  = TotHwnt + (GHWNT * 1000) + GHDCT
     C                   READ      GLOUTLPT                               99
     C                   ENDDO
 
     C     1             CHAIN     REOUTLPT                           99
     C                   IF        *IN99 = *ON
     C                   MOVE      'REOUTLPT'    DBFILE
     C                   Z-ADD     004           DBASE
     C                   EXSR      *PSSR
     C                   ELSE
 
     C     TOTNORE       ADD       RE_GNREC      RE_GNREC
 
     C                   EVAL      TotHwnp2 = (RE_GHWNP * 1000) + RE_GHDCP
     C     TOTHWNP       ADD       TOTHWNP2      TOTHWNP2
     C                   EVAL      RE_GHWNP = (TotHwnp2 / 1000)
     C                   EVAL      RE_GHDCP = TotHwnp2 - (RE_GHWNP * 1000)
 
     C                   EVAL      TotHwnt2 = (RE_GHWNT * 1000) + RE_GHDCT
     C     TOTHWNT       ADD       TOTHWNT2      TOTHWNT2
     C                   EVAL      RE_GHWNT = (TotHwnt2 / 1000)
     C                   EVAL      RE_GHDCT = TotHwnt2 - (RE_GHWNT * 1000)
 
     C                   UPDATE    REOUTLT0
 
     C                   ENDIF
     C                   ENDIF
      *                                                                                     MD038510
      ** Process GLSTMTZX and update STMTZX                                                 MD038510
      *                                                                                     MD038510
     C                   Z-ADD     0             TotNore                                    MD038510
     C                   READ      GLSTMTZX                               99                MD038510
     C                   DOW       *IN99 = *OFF                                             MD038510
     C     NORE1         ADD       TOTNORE       TOTNORE                                    MD038510
     C                   READ      GLSTMTZX                               99                MD038510
     C                   ENDDO                                                              MD038510
                                                                                            MD038510
     C     1             CHAIN     STMTZX                             99                    MD038510
     C                   IF        *IN99 = *ON                                              MD038510
     C                   MOVE      'STMTZX '     DBFILE                                     MD038510
     C                   Z-ADD     005           DBASE                                      MD038510
     C                   EXSR      *PSSR                                                    MD038510
     C                   ELSE                                                               MD038510
     C     TOTNORE       ADD       ST_NORE1      ST_NORE1                                   MD038510
     C                   UPDATE    STMTZXF                                                  MD038510
     C                   ENDIF                                                              MD038510
 
     C                   COMMIT
 
     C                   SETON                                        LR
     C                   RETURN
      *****************************************************************
      /EJECT                                                                                MD031057
      *****************************************************************                     MD031057
      *                                                               *                     MD031057
      *  *INZSR - Initialization Routine                              *                     MD031057
      *           Called automatically during program startup         *                     MD031057
      *****************************************************************                     MD031057
     C     *INZSR        BEGSR                                                              MD031057
                                                                                            MD031057
     C                   CALL      'AOSARDR0'                                               MD031057
     C                   PARM      *BLANKS       PRtCd                                      MD031057
     C                   PARM      '*VERIFY'     POption                                    MD031057
     C                   PARM      'CRE023'      PSard                                      MD031057
     C     SCSARD        PARM      SCSARD        DSFDY                                      MD031057
                                                                                            MD031057
     C                   EVAL      CRE023 = 'N'                                             MD031057
     C                   IF        PRtCd <> *BLANKS AND PRtCd <> '*NRF'                     MD031057
     C                   EVAL      DBFILE = 'SCSARDPD'                                      MD031057
     C                   EVAL      DBASE = 5                                                MD031057
     C                   EVAL      DBKEY = 'CRE023'                                         MD031057
     C                   EXSR      *PSSR                                                    MD031057
     C**********         ELSE                                                      MD031057 MD036707
     C                   ENDIF                                                              MD036707
      *                                                                                     MD036707
     C                   IF        PRtCd = *BLANKS                                          MD036707
     C                   EVAL      CRE023 = 'Y'                                             MD031057
     C                   ENDIF                                                              MD031057
                                                                                            MD031057
     C                   ENDSR                                                              MD031057
      *****************************************************************                     MD031057
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
