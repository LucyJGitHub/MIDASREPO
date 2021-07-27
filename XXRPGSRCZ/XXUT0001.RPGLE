     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*S*D****RPGBASE*******************************************************                       LUC109
/*STD *  RPGBASEBND                                                   *                       LUC109
/*EXI *  TEXT('Daily Setup of SDGELRPP File.')                        *                       LUC109
      *****************************************************************
      *                                                               *
      *  Midas - Interface to Head Office Reporting                   *
      *                                                               *
      ***UTIL01**-*Initial*setup of**SDGELRPP File.********************                       LUC109
      *  XXUT0001 - Initial setup of SDGELRPP File.                   *                       LUC109
  ?   *****************************************************************
  ?   * *** THIS PROGRAM MUST BE COMPILED WITH XXINTFLIB AT THE BOTTOM*
  ?   * OF LIBL ***                                                   *
  ?   *****************************************************************
      *                                                               *
      *                                                               *
      *  CALLED BY  XXXXXXXX- XXXXXXXXXXXXXXXXXXXXXXXX                *
      *             Frequency: Automatically in Close of Business     *
      *                                                               *
      ***(C)*COPYRIGHT*MKI*LIMITED*1998********************************                       LUC109
      *  (c) Finastra International Limited 2016                      *                       LUC109
      *                                                               *
      *  Last Amend No. LUC109             Date 22Sep16               *
      *  Prev Amend No. MUI009             Date 16Feb04               *
      *                 MMI043 *Create     Date 12Jan99               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *
      *  MUI009 - R4.1 Upgrade:                                       *
      *           Added I specs requireds by ZCBDYS                   *
      *  MMI043 - Head Office Reporting                               *
      *                                                               *
      *****************************************************************
      *
     FSDGELRPP  UF A E             DISK    INFSR(*PSSR)
     FSDGELRPD  IF   E             DISK    INFSR(*PSSR)
     FSDBANKPD  IF   E             DISK    INFSR(*PSSR)
     F***UTIL01AU  O    E             PRINTER INFDS(SPOOL)                                    LUC109
     FXXUT0001AUO    E             PRINTER INFDS(SPOOL)                                       LUC109
      *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   88 - General chain indicator                                *
      *                                                               *
      *                                                               *
      *  U7+U8    Database Error                                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  #INIT  - Initial Processing                                  *
      *  #READ  - Read DEALSDC File                                   *
      *  #PROC  - Process DEALSDC Record                             *
      *  #CRTCX - Create DEALSCX0 Record                              *
      *  #TERM  - Program termination                                 *
      *  *PSSR  - Abnormal termination                                *
      *                                                               *
      *****************************************************************
      * COMPILE TIME ARRAYS                                           *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)              Copyright
      ***/C*PY*ZSRSRC,ZHOLE                                                                   LUC109
     D/COPY ZSRSRC,ZHOLELE                                                                    LUC109
      *
      ***/C*PY*ZSRSRC,ZDATE2Z1                                                                LUC109
     D/COPY ZSRSRC,ZDATE2Z1LE                                                                 LUC109
      ***/C*PY*ZSRSRC,ZDAYSZ1                                                                 LUC109
     D/COPY ZSRSRC,ZDAYSZ1LE                                                                  LUC109
      ***/C*PY*ZSRSRC,ZDATE9Z1                                                                LUC109
     D/COPY ZSRSRC,ZDATE9Z1LE                                                                 LUC109
      *
      ***/C*PY*ZSRSRC,ZHOLI                                                                   LUC109
     D/COPY ZSRSRC,ZHOLILE                                                                    LUC109
      ***/C*PY*ZSRSRC,ZDATE9Z2                                                                LUC109
     D/COPY ZSRSRC,ZDATE9Z2LE                                                                 LUC109
      ***/C*PY*ZSRSRC,ZDAT10Z1                                                                LUC109
     D/COPY ZSRSRC,ZDAT10Z1LE                                                                 LUC109
     D***/C*PY*ZSRSRC,ZCBDYSZ2                                                         MUI009 LUC109
      ** Data structure for subroutine ZCBDYS                                                 LUC109
     D                 DS                                                                     LUC109
     D  ZZDAT1                 1      8  0                                                    LUC109
     D  ZZYYA                  1      4  0                                                    LUC109
     D  ZZMMA                  5      6  0                                                    LUC109
     D  ZZDDA                  7      8  0                                                    LUC109
      *                                                                                       LUC109
     D                 DS                                                                     LUC109
     D  ZZDAT2                 1      8  0                                                    LUC109
     D  ZZYYB                  1      4  0                                                    LUC109
     D  ZZMMB                  5      6  0                                                    LUC109
     D  ZZDDB                  7      8  0                                                    LUC109
      *                                                                                       LUC109
     D SPOOL           DS
     D  WWOFL1               188    189B 0
     D  WWPTL1               367    368B 0
      *
      *
      ** Data structure for data-base error processing
      *
     D DBERR           DS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
      *
     D                 DS
     D  YMD                    1      8  0
     D  YYYY                   1      4  0
     D  MM                     5      6  0
     D  DD                     7      8  0
      ***/C*PY*ZSRSRC,ZHOLDS                                                                  LUC109
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     LUC109
      * Second DS for access programs, Long data structure                                    LUC109
      *****************************************************************
      *
     C                   EXSR      #INIT                                        Housekeeping
      *
     C                   EXSR      #UPDAT                                       Update File
      *
     C                   EXSR      #TERM                                        Termination
      *
      *****************************************************************
      *                                                               *
      *  INIT   - Subroutine to do Program Initialisation.            *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     #INIT         BEGSR                                                  Initialisation
      *
      * Careful cause this indicator is used in date routines
      *
     C     BJDFIN        IFEQ      'D'
     C                   MOVE      *OFF          *IN98
     C                   ELSE
     C                   MOVE      *ON           *IN98
     C                   END
      *
      ** Data definition
      *
     C     *DTAARA       DEFINE    LDA           WLDA            256
      *
      ** Initial housekeeping
      *
     C                   MOVEA     CPY@          BIS@             80            Copyright
     C                   MOVE      'N'           @@PSSR            1            *PSSR Control
     C                   MOVE      *OFF          *IN88
      *
     C                   READ      SDBANKPD                               88
      *
     C     *IN88         IFEQ      *ON                                          Ended in error
     C                   MOVEL     '001'         DBASE                          ***************
     C                   MOVEL     'SDBANKPD'    DBFILE                         * DB ERR  001 *
     C                   MOVE      *BLANKS       DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   READ      SDGELRPD                               88
      *
     C     *IN88         IFEQ      *ON                                          Ended in error
     C                   MOVEL     '003'         DBASE                          ***************
     C                   MOVEL     'SDGELRPD'    DBFILE                         * DB ERR  001 *
     C                   MOVE      *BLANKS       DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * Get YYYYMMDD Format for Midas day Number
      *
     C                   Z-ADD     BJRDNB        @@DAYN            5 0
     C                   EXSR      ZDATE9
     C                   MOVE      @@VDT         MIDDAT            8
      *
      * Is it End of Month processing
      *
     C                   CALL      'GLM057'
     C                   PARM      *BLANK        ENDMTH            1
     C                   PARM      *BLANK        EOY               1
     C                   PARM      *BLANK        ERR               1
      *
      * Set End of Quarter Flag
      *
     C                   MOVE      'N'           ENDQTR            1
     C     ENDMTH        IFEQ      'Y'
     C                   MOVE      MIDDAT        YMD
     C     MM            IFEQ      03
     C     MM            OREQ      06
     C     MM            OREQ      09
     C     MM            OREQ      12
     C                   MOVE      'Y'           ENDQTR            1
     C                   ENDIF
     C                   ENDIF
      *
      * Is it Beginning of Month processing
      *
     C                   CALL      'CB0812'
     C                   PARM      *BLANK        BEGMTH            1
     C                   PARM      *BLANK        ERR               1
      *
      * Set Beginning of Quarter Flag
      *
     C                   MOVE      'N'           BEGQTR            1
     C     BEGMTH        IFEQ      'Y'
     C                   MOVE      MIDDAT        YMD
     C     MM            IFEQ      01
     C     MM            OREQ      04
     C     MM            OREQ      07
     C     MM            OREQ      10
     C                   MOVE      'Y'           BEGQTR            1
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  #READ  -  Read File                                          *
      *                                                               *
      *  Called By: Main line                                         *
      *  Calls: S200                                                  *
      *                                                               *
      *****************************************************************
      *
     C     #UPDAT        BEGSR
      *
     C                   READ      SDGELRPP                               88
      *
      *
      * Previous End of Month
      *
      * ... get first day of this month and convert to day number
     C                   MOVE      MIDDAT        YMD
     C                   Z-ADD     01            DD
     C                   MOVE      YMD           ZZDTIN
     C                   EXSR      ZDAT10
      * ... find previous working day and convert to YYYYMMDD
     C                   Z-ADD     ZZMDNO        ZDAYNO
     C                   MOVE      BJCYCD        ZCCY
     C                   MOVE      *BLANKS       ZLOC
     C                   Z-ADD     1             ZNRDYS
     C                   EXSR      ZBKDT
     C                   Z-ADD     ZDYNBR        @@DAYN            5 0
     C                   EXSR      ZDATE9
      * ... update fields on SDGELRPP
     C                   Z-ADD     ZDYNBR        MPEMB
     C                   MOVE      @@VDT         MPEMD
      *
      * Last Working Day of Month
      *
      * ... get first day of next month and convert to day number
     C                   MOVE      MIDDAT        YMD
     C                   Z-ADD     1             DD
     C                   ADD       1             MM
     C     MM            IFGT      12
     C                   Z-ADD     1             MM
     C                   ADD       1             YYYY
     C                   ENDIF
     C                   MOVE      YMD           ZZDTIN
     C                   EXSR      ZDAT10
      * ... find previous working day and convert to YYYYMMDD
     C                   Z-ADD     ZZMDNO        ZDAYNO
     C                   MOVE      BJCYCD        ZCCY
     C                   MOVE      *BLANKS       ZLOC
     C                   Z-ADD     1             ZNRDYS
     C                   EXSR      ZBKDT
     C                   Z-ADD     ZDYNBR        @@DAYN            5 0
     C                   EXSR      ZDATE9
      * ... update fields on SDGELRPP
     C                   Z-ADD     ZDYNBR        MMDNB
     C                   MOVE      @@VDT         MMDAT
      *
      * Prev Day Number
      *
      * ... find previous working day and convert to YYYYMMDD
     C                   Z-ADD     BJRDNB        ZDAYNO
     C                   MOVE      BJCYCD        ZCCY
     C                   MOVE      *BLANKS       ZLOC
     C                   Z-ADD     1             ZNRDYS
     C                   EXSR      ZBKDT
     C                   Z-ADD     ZDYNBR        @@DAYN
     C                   EXSR      ZDATE9
      * ... update fields on SDGELRPP
     C                   Z-ADD     ZDYNBR        MPDNB
     C                   MOVE      @@VDT         MPDAT
      *
      * Last Accounting Date
      *
      * ... convert to YYYYMMDD
     C                   Z-ADD     BKAPDT        @@DAYN
     C                   EXSR      ZDATE9
      * ... update fields on SDGELRPP
     C                   Z-ADD     BJRDNB        MLACD
     C                   MOVE      MIDDAT        MLACT
      *
      * End of Quarter - Day Number.
      *
      * ... get first day of next quarter and convert to day number
     C                   MOVE      MIDDAT        YMD
     C                   Z-ADD     1             DD
      *
     C     MM            IFGE      1
     C     MM            ANDLE     3
     C                   Z-ADD     4             MM
     C                   ELSE
      *
     C     MM            IFGE      4
     C     MM            ANDLE     6
     C                   Z-ADD     7             MM
     C                   ELSE
      *
     C     MM            IFGE      7
     C     MM            ANDLE     9
     C                   Z-ADD     10            MM
     C                   ELSE
      *
     C     MM            IFGE      10
     C     MM            ANDLE     12
     C                   Z-ADD     01            MM
     C                   ADD       1             YYYY
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVE      YMD           ZZDTIN
     C                   EXSR      ZDAT10
      * ... find previous working day and convert to YYYYMMDD
     C                   Z-ADD     ZZMDNO        ZDAYNO
     C                   MOVE      BJCYCD        ZCCY
     C                   MOVE      *BLANKS       ZLOC
     C                   Z-ADD     1             ZNRDYS
     C                   EXSR      ZBKDT
     C                   Z-ADD     ZDYNBR        @@DAYN
     C                   EXSR      ZDATE9
      * ... update fields on SDGELRPP
     C                   Z-ADD     ZDYNBR        MEOQB
     C                   MOVE      @@VDT         MEOQD
      *
      * Previous End of Quarter - Day Number.
      *
      * ... get first day of this quarter and convert to day number
     C                   MOVE      MEOQD         YMD
     C                   Z-ADD     1             DD
     C                   SUB       2             MM
     C     MM            IFLT      1
     C                   Z-ADD     12            MM
     C                   SUB       1             YYYY
     C                   ENDIF
      *
     C                   MOVE      YMD           ZZDTIN
     C                   EXSR      ZDAT10
      * ... find previous working day and convert to YYYYMMDD
     C                   Z-ADD     ZZMDNO        ZDAYNO
     C                   MOVE      BJCYCD        ZCCY
     C                   MOVE      *BLANKS       ZLOC
     C                   Z-ADD     1             ZNRDYS
     C                   EXSR      ZBKDT
     C                   Z-ADD     ZDYNBR        @@DAYN
     C                   EXSR      ZDATE9
      * ... update fields on SDGELRPP
     C                   Z-ADD     ZDYNBR        MPEQB
     C                   MOVE      @@VDT         MPEQD
      *
      * Previous Beginning of Quarter
      *
      * ... get first day of Prev quarter and convert to day number
     C                   MOVE      MPEQD         YMD
     C                   Z-ADD     1             DD
     C                   SUB       2             MM
     C     MM            IFLT      1
     C                   Z-ADD     12            MM
     C                   SUB       1             YYYY
     C                   ENDIF
      *
     C                   MOVE      YMD           ZZDTIN
     C                   EXSR      ZDAT10
      * ... update fields on SDGELRPP
     C                   Z-ADD     ZZMDNO        MPBQB
     C                   MOVE      YMD           MPBQD
      *
      * First Day of Month Processing. Y or N.
      *
     C                   MOVE      BEGMTH        MFSTM
      *
      * First Day of Quarter Processing. Y or N.
      *
     C                   MOVE      BEGQTR        MFSTQ
      *
      * Last Day of Month Processing. Y or N.
      *
     C                   MOVE      ENDMTH        MENDM
      *
      * Last Day of Quarter Processing. Y or N.
      *
     C                   MOVE      ENDQTR        MENDQ
      *
      * Update SDGELRPP File.
      *
     C     *IN88         IFEQ      *ON
     C                   WRITE     SDGELRP0
     C                   ELSE
     C                   UPDATE    SDGELRP0
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *    #TERM     - Program termination                            *
      *                                                               *
      *    CALLED BY - #PROC, *PSSR                                   *
      *    CALLS     - NONE                                           *
      *                                                               *
      *****************************************************************
      *
     C     #TERM         BEGSR
      *
      *
     C     *INU7         IFEQ      *ON                                          Database error
      *
      ** Print audit report & stop run
      *
     C                   WRITE     HEADAU                                       Report header
      *
     C                   WRITE     DBERROR                                      Report error
      *
     C                   ENDIF
      *
     C                   MOVE      *ON           *INLR                          Last record
     C                   RETURN                                                 Return control
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Error Processing Subroutine.                *
      *                                                               *
      *  Called By: Various                                           *
      *  #AUDIT - Produce #AUDIT Report and End Program               *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  *** *PSSR  ***
      *
      ** Prevent recursive call
      *
     C     @@PSSR        IFEQ      'N'                                          Recursive call
      *
     C                   MOVE      'Y'           @@PSSR                         *PSSR Executed
      *
      ** Update local data area
      *
     C     DBPGM         IFEQ      *BLANKS
     C                   MOVEL     'UTIL01'      DBPGM                          Set program id
     C                   ENDIF
      *
     C     *LOCK         IN        WLDA
     C                   MOVEL     DBERR         WLDA
     C                   OUT       WLDA
      *
     C                   MOVE      *ON           *INU7                          Database error
     C                   MOVE      *ON           *INU8                          Database error
     C                   DUMP                                                   Dump system var
      *
     C                   EXSR      #TERM                                        Stop run
      *
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      ***/C*PY*ZSRSRC,ZCBDYSZ1                                                                LUC109
     C/COPY ZSRSRC,XCBDYSZ1LE                                                                 LUC109
      ***/C*PY*ZSRSRC,ZDATE2Z2                                                                LUC109
     C/COPY ZSRSRC,ZDATE2Z2LE                                                                 LUC109
      ***/C*PY*ZSRSRC,ZDLINTZ1                                                                LUC109
     C/COPY ZSRSRC,ZDLINTZ1LE                                                                 LUC109
      ***/C*PY*ZSRSRC,ZACCH                                                                   LUC109
     C/COPY ZSRSRC,ZACCHLE                                                                    LUC109
      ***/C*PY*ZSRSRC,ZBKDT                                                                   LUC109
     C/COPY ZSRSRC,ZBKDT_ILE                                                                  LUC109
      ***/C*PY*ZSRSRC,ZDATE9Z3                                                                LUC109
     C/COPY ZSRSRC,ZDATE9Z3LE                                                                 LUC109
      ***/C*PY*ZSRSRC,ZDAT10Z2                                                                LUC109
     C/COPY ZSRSRC,ZDAT10Z2LE                                                                 LUC109
      ***
**  CPY@
(c) Finastra International Limited 2016
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
**   ZF29 DAY NOS OF FEB 29 TO 2096 (INCLUDING 2000)
0006001521029820444305904073650882610287117481320914670161311759219053
2051421975234362489726358278192928030741322023366335124365853804639507
40968424294389045351
** @YD  USED BY SR. ZDATE9 - YEARS, IN DAYS, CUMULATIVE IN 4 YEAR SPAN
00366007310109601461
** @MD  USED BY SR. ZDATE9 - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
00000000310005900090001200015100181002120024300273003040033400365
