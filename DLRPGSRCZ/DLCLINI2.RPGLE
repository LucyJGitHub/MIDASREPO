     H DEBUG
     H COPYRIGHT('(C) Copyright Finastra International Limited, 2005')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas DL Set class on transactions')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DLCLINI2 - Set class on transactions                         *
      *             (Dealing initialisation program)                  *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 MD046248           Date 27Oct17               *
      *                 CDL099             Date 06Oct17               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CSW212             Date 03May12               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG25189           Date 27Jul09               *
      *                 BUG24989           Date 23Jul09               *
      *                 CER054             Date 07Apr09               *
      *                 CER048             Date 19May08               *
      *                 CER020             Date 19May08               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 04May06               *
      *                 CDL038  *CREATE    Date 10May05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  CSW212 - SWIFT 2012 Changes (Recompile)                      *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG25189 - MARG field on DLCHISPD contains invalid data after*
      *             the close of business (Recompile)                 *
      *  BUG24989 - Limit Utilisation Enq - Decimal Data error        *
      *             (Recompile)                                       *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CSD027A- Conversion of customer number to alpha. Recompile.  *
      *  CDL038 - Extended Deal Sub Type                              *
      *                                                               *
      *****************************************************************
 
     FSDTCLDPD  IP   E             DISK
 
     FDEALSDB   UF   E             DISK
     FDLBHISPD  UF   E             DISK
     FFXDEALPP  UF   E             DISK
     FABDEALPP  UF   E             DISK
 
     FDEALSDC   UF   E             DISK
     FDLCHISPD  UF   E             DISK
     FMMDELDPP  UF   E             DISK
 
     FDEAMSDI   UF   E             DISK
     FMMDEAMPP  UF   E             DISK
 
     FDEALSDD   UF   E             DISK
     FDLDHISPD  UF   E             DISK
     FMMDENBPP  UF   E             DISK
 
     FDEALSDE   UF   E             DISK
     FDLEHISPD  UF   E             DISK
     FMMDENSPP  UF   E             DISK
 
     FDEALSDG   UF   E             DISK
     FDLGHISPD  UF   E             DISK
 
     FQSYSPRT   O    F  132        PRINTER USROPN
 
     D DB              S              2    DIM(10) CTDATA PERRCD(10)
     D DC              S              2    DIM(30) CTDATA PERRCD(30)
     D DD              S              2    DIM(30) CTDATA PERRCD(30)
     D DE              S              2    DIM(30) CTDATA PERRCD(30)
     D DG              S              2    DIM(30) CTDATA PERRCD(30)
 
 
     C                   EXSR      P_DEALSDB
     C                   EXSR      P_DLBHISPD
     C                   EXSR      P_FXDEALPP
     C                   EXSR      P_ABDEALPP
 
     C                   EXSR      P_DEALSDC
     C                   EXSR      P_DLCHISPD
     C                   EXSR      P_MMDELDPP
 
     C                   EXSR      P_DEAMSDI
     C                   EXSR      P_MMDEAMPP
 
     C                   EXSR      P_DEALSDD
     C                   EXSR      P_DLDHISPD
     C                   EXSR      P_MMDENBPP
 
     C                   EXSR      P_DEALSDE
     C                   EXSR      P_DLEHISPD
     C                   EXSR      P_MMDENSPP
 
     C                   EXSR      P_DEALSDG
     C                   EXSR      P_DLGHISPD
 
     C                   ADD       1             Count             3 0
 
     CLR                 EXSR      FINISH
      /SPACE 5
      ********************************************************************
     C     P_DEALSDB     BEGSR
     C                   EVAL      R_FILE= 'DEALSDB'
     C                   READ      DEALSDB                                99
     C     *IN99         DOWEQ     *OFF
     C                   EVAL      R_DTYP= DTYP
     C                   EXSR      CHECK_DTYP
     C                   EVAL      CLAS = DBCLAS
     C     R_DTYP        IFEQ      'NX'
     C                   EVAL      CLAS = NXCLAS
     C                   ENDIF
     C                   EXCEPT    DEALSDBO
     C                   READ      DEALSDB                                99
     C                   ENDDO
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     P_DLBHISPD    BEGSR
     C                   EVAL      R_FILE= 'DLBHISPD'
     C                   READ      DLBHISPD                               99
     C     *IN99         DOWEQ     *OFF
     C                   EVAL      R_DTYP= DTYP
     C                   EXSR      CHECK_DTYP
     C                   EVAL      CLAS = DBCLAS
     C     R_DTYP        IFEQ      'NX'
     C                   EVAL      CLAS = NXCLAS
     C                   ENDIF
     C                   EXCEPT    DLBHISPDO
     C                   READ      DLBHISPD                               99
     C                   ENDDO
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     P_FXDEALPP    BEGSR
     C                   EVAL      R_FILE= 'FXDEALPP'
     C                   READ      FXDEALPP                               99
     C     *IN99         DOWEQ     *OFF
     C                   EVAL      R_DTYP= FHTYPE
     C                   EXSR      CHECK_DTYP
     C                   EVAL      FHCLAS = DBCLAS
     C                   EXCEPT    FXDEALPPO
     C                   READ      FXDEALPP                               99
     C                   ENDDO
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     P_ABDEALPP    BEGSR
     C                   EVAL      R_FILE= 'ABDEALPP'
     C                   READ      ABDEALPP                               99
     C     *IN99         DOWEQ     *OFF
     C                   EVAL      R_DTYP= JPMDTY
     C                   EXSR      CHECK_DTYP
     C                   EVAL      JPCLAS = DBCLAS
     C                   EXCEPT    ABDEALPPO
     C                   READ      ABDEALPP                               99
     C                   ENDDO
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     P_DEALSDC     BEGSR
     C                   EVAL      R_FILE= 'DEALSDC'
     C                   READ      DEALSDC                                99
     C     *IN99         DOWEQ     *OFF
     C                   EVAL      R_DTYP= DTYP
     C                   EXSR      CHECK_DTYP
     C                   EVAL      CLAS = DCCLAS
     C                   EXCEPT    DEALSDCO
     C                   READ      DEALSDC                                99
     C                   ENDDO
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     P_DLCHISPD    BEGSR
     C                   EVAL      R_FILE= 'DLCHISPD'
     C                   READ      DLCHISPD                               99
     C     *IN99         DOWEQ     *OFF
     C                   EVAL      R_DTYP= DTYP
     C                   EXSR      CHECK_DTYP
     C                   EVAL      CLAS = DCCLAS
     C                   EXCEPT    DLCHISPDO
     C                   READ      DLCHISPD                               99
     C                   ENDDO
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     P_MMDELDPP    BEGSR
     C                   EVAL      R_FILE= 'MMDELDPP'
     C                   READ      MMDELDPP                               99
     C     *IN99         DOWEQ     *OFF
     C                   EVAL      R_DTYP= HKMTYP
     C                   EXSR      CHECK_DTYP
     C                   EVAL      HKCLAS = DCCLAS
     C                   EXCEPT    MMDELDPPO
     C                   READ      MMDELDPP                               99
     C                   ENDDO
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     P_DEAMSDI     BEGSR
     C                   EVAL      R_FILE= 'DEAMSDI'
     C                   READ      DEAMSDI                                99
     C     *IN99         DOWEQ     *OFF
     C                   EVAL      R_DTYP= DTYP
     C                   EXSR      CHECK_DTYP
     C                   EVAL      CLAS = DCCLAS
     C                   EXCEPT    DEAMSDIO
     C                   READ      DEAMSDI                                99
     C                   ENDDO
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     P_MMDEAMPP    BEGSR
     C                   EVAL      R_FILE= 'MMDEAMPP'
     C                   READ      MMDEAMPP                               99
     C     *IN99         DOWEQ     *OFF
     C                   EVAL      R_DTYP= HNOMDT
     C                   EXSR      CHECK_DTYP
     C                   EVAL      HNCLAS = DCCLAS
     C                   EXCEPT    MMDEAMPPO
     C                   READ      MMDEAMPP                               99
     C                   ENDDO
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     P_DEALSDD     BEGSR
     C                   EVAL      R_FILE= 'DEALSDD'
     C                   READ      DEALSDD                                99
     C     *IN99         DOWEQ     *OFF
     C                   EVAL      R_DTYP= DTYP
     C                   EXSR      CHECK_DTYP
     C                   EVAL      CLAS = DDCLAS
     C                   EXCEPT    DEALSDDO
     C                   READ      DEALSDD                                99
     C                   ENDDO
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     P_DLDHISPD    BEGSR
     C                   EVAL      R_FILE= 'DLDHISPD'
     C                   READ      DLDHISPD                               99
     C     *IN99         DOWEQ     *OFF
     C                   EVAL      R_DTYP= DTYP
     C                   EXSR      CHECK_DTYP
     C                   EVAL      CLAS = DDCLAS
     C                   EXCEPT    DLDHISPDO
     C                   READ      DLDHISPD                               99
     C                   ENDDO
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     P_MMDENBPP    BEGSR
     C                   EVAL      R_FILE= 'MMDENBPP'
     C                   READ      MMDENBPP                               99
     C     *IN99         DOWEQ     *OFF
     C                   EVAL      R_DTYP= HLMTYP
     C                   EXSR      CHECK_DTYP
     C                   EVAL      HLCLAS = DDCLAS
     C                   EXCEPT    MMDENBPPO
     C                   READ      MMDENBPP                               99
     C                   ENDDO
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     P_DEALSDE     BEGSR
     C                   EVAL      R_FILE= 'DEALSDE'
     C                   READ      DEALSDE                                99
     C     *IN99         DOWEQ     *OFF
     C                   EVAL      R_DTYP= DTYP
     C                   EXSR      CHECK_DTYP
     C                   EVAL      CLAS = DECLAS
     C                   EXCEPT    DEALSDEO
     C                   READ      DEALSDE                                99
     C                   ENDDO
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     P_DLEHISPD    BEGSR
     C                   EVAL      R_FILE= 'DLEHISPD'
     C                   READ      DLEHISPD                               99
     C     *IN99         DOWEQ     *OFF
     C                   EVAL      R_DTYP= DTYP
     C                   EXSR      CHECK_DTYP
     C                   EVAL      CLAS = DECLAS
     C                   EXCEPT    DLEHISPDO
     C                   READ      DLEHISPD                               99
     C                   ENDDO
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     P_MMDENSPP    BEGSR
     C                   EVAL      R_FILE= 'MMDENSPP'
     C                   READ      MMDENSPP                               99
     C     *IN99         DOWEQ     *OFF
     C                   EVAL      R_DTYP= HMMTYP
     C                   EXSR      CHECK_DTYP
     C                   EVAL      HMCLAS = DECLAS
     C                   EXCEPT    MMDENSPPO
     C                   READ      MMDENSPP                               99
     C                   ENDDO
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     P_DEALSDG     BEGSR
     C                   EVAL      R_FILE= 'DEALSDG'
     C                   READ      DEALSDG                                99
     C     *IN99         DOWEQ     *OFF
     C                   EVAL      R_DTYP= DTYP
     C                   EXSR      CHECK_DTYP
     C                   EVAL      CLAS = DGCLAS
     C                   EXCEPT    DEALSDGO
     C                   READ      DEALSDG                                99
     C                   ENDDO
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     P_DLGHISPD    BEGSR
     C                   EVAL      R_FILE= 'DLGHISPD'
     C                   READ      DLGHISPD                               99
     C     *IN99         DOWEQ     *OFF
     C                   EVAL      R_DTYP= DTYP
     C                   EXSR      CHECK_DTYP
     C                   EVAL      CLAS = DDCLAS
     C                   EXCEPT    DLGHISPDO
     C                   READ      DLGHISPD                               99
     C                   ENDDO
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     CHECK_DTYP    BEGSR
     C                   SETOFF                                       99
     C                   Z-ADD     1             X                 2 0
     C                   SELECT
     C     R_FILE        WHENEQ    'DEALSDB'
     C     R_FILE        OREQ      'DLBHISPD'
     C     R_FILE        OREQ      'FXDEALPP'
     C     R_FILE        OREQ      'ABDEALPP'
     C     R_DTYP        LOOKUP    DB(X)                                  99
     C     R_FILE        WHENEQ    'DEALSDC'
     C     R_FILE        OREQ      'DLCHISPD'
     C     R_FILE        OREQ      'MMDELDPP'
     C     R_FILE        OREQ      'DEAMSDI'
     C     R_FILE        OREQ      'MMDEAMPP'
     C     R_DTYP        LOOKUP    DC(X)                                  99
     C     R_FILE        WHENEQ    'DEALSDD'
     C     R_FILE        OREQ      'DLDHISPD'
     C     R_FILE        OREQ      'MMDENBPP'
     C     R_DTYP        LOOKUP    DD(X)                                  99
     C     R_FILE        WHENEQ    'DEALSDE'
     C     R_FILE        OREQ      'DLEHISPD'
     C     R_FILE        OREQ      'MMDENSPP'
     C     R_DTYP        LOOKUP    DE(X)                                  99
     C     R_FILE        WHENEQ    'DEALSDG'
     C     R_FILE        OREQ      'DLGHISPD'
     C     R_DTYP        LOOKUP    DG(X)                                  99
     C                   OTHER
     C                   ENDSL
     C     *IN99         IFEQ      *OFF
     C                   OPEN      QSYSPRT
     C                   EXCEPT    DTYPERR
     C                   CLOSE     QSYSPRT
     C                   SETON                                        LRU8
     C                   RETURN
     C                   ENDIF
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     FINISH        BEGSR
     C                   OPEN      QSYSPRT
 
      * Report error or completion
 
     C     Count         IFNE      1
     C                   EXCEPT    ERR
     C                   SETON                                        U8
     C                   ELSE
     C                   EXCEPT    FIN
     C                   ENDIF
 
     C                   CLOSE     QSYSPRT
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     *INZSR        BEGSR
     C                   MOVEL     *BLANK        R_FILE           10
     C                   MOVEL     *BLANK        R_DTYP            2
     C                   ENDSR
      ********************************************************************
     OQSYSPRT   E            ERR         1
     O                                           26 'PROGRAM ERROR - SDTCLDPD'
     O          E            FIN         1
     O                                           26 'PROGRAM COMPLETED NORMALLY'
     O          E            DTYPERR
     O                                            4 'FILE'
     O                       R_FILE              15
     O                                           36 'HAS INVALID DEAL TYPE'
     O                       R_DTYP              39
     ODEALSDBF  E            DEALSDBO
     O                       CLAS
     ODLBHISD0  E            DLBHISPDO
     O                       CLAS
     OFXDEALP0  E            FXDEALPPO
     O                       FHCLAS
     OABDEALP0  E            ABDEALPPO
     O                       JPCLAS
     ODEALSDCF  E            DEALSDCO
     O                       CLAS
     ODLCHISD0  E            DLCHISPDO
     O                       CLAS
     OMMDELDP0  E            MMDELDPPO
     O                       HKCLAS
     ODEAMSDIF  E            DEAMSDIO
     O                       CLAS
     OMMDEAMP0  E            MMDEAMPPO
     O                       HNCLAS
     ODEALSDDF  E            DEALSDDO
     O                       CLAS
     ODLDHISD0  E            DLDHISPDO
     O                       CLAS
     OMMDENBP0  E            MMDENBPPO
     O                       HLCLAS
     ODEALSDEF  E            DEALSDEO
     O                       CLAS
     ODLEHISD0  E            DLEHISPDO
     O                       CLAS
     OMMDENSP0  E            MMDENSPPO
     O                       HMCLAS
     ODEALSDGF  E            DEALSDGO
     O                       CLAS
     ODLGHISD0  E            DLGHISPDO
     O                       CLAS
      ********************************************************************
      /SPACE 5
** DB - DEALSDB DTYP
FPFSPISICXSWOPOTPSNX
** DC - DEALSDC DTYP
IPTICLLNDLITTDCDCIILIDFLDPLPFTDTLT
** DD - DEALSDD DTYP
C1C2BPBDTBDATA
** DE - DEALSDE DTYP
CSBSBRTSRATR
** DG - DEALSDG DTYP
FRRSRXRPRRRF
