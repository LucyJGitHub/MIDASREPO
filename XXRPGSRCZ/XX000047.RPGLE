     H DEBUG
      *****************************************************************
/*S*D****RPGBASE*******************************************************                       LUC109
/*STD *  RPGBASEBND                                                   *                       LUC109
/*EXI *  TEXT('Calculate interest between 2 dates')                   *                       LUC109
      *****************************************************************
      *                                                               *
      *  Midas - Interface to Head Office Reporting                   *
      *                                                               *
      ***GLM047*-*Calculate*interest*between*2*dates*******************                       LUC109
      *  XX000047 - Calculate interest between 2 dates                *                       LUC109
      *                                                               *                       LUC109
  ?   *****************************************************************
  ?   * *** THIS PROGRAM MUST BE COMPILED WITH XXINTFLIB AT THE TOP   *
  ?   * OF LIBL ***                                                   *
  ?   *****************************************************************
      *                                                               *
      ***(C)*COPYRIGHT*MKI*LIMITED*1998********************************                       LUC109
      *  (c) Finastra International Limited 2016                      *                       LUC109
      *                                                               *
      *  Last Amend No. LUC109             Date 21Sep16               *
      *  Prev Amend No. MUI009             Date 16Feb04               *
      *                 MMI043  *Create    Date 16Dec98               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *
      *  MUI009 - R4.1 Upgrade:                                       *
      *           Added I specs requireds by ZCBDYS                   *
      *           Added ZDATE9 which is now required by ZCBDYS        *
      *           Added ZDATE10 which is now required by ZCBDYS       *
      *  MMI043 - Head Office Reporting                               *
      *                                                               *
      *****************************************************************
      *STANDARD SUBROUTINE - ZDLINT
      *~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      *
      *Purpose:
      *~~~~~~~~
      *Purpose:
      *~~~~~~~~
      *To calculate the Interest Accruing between two Dates.
      *(Dealing version).
      *
      *Input:
      *~~~~~~
      *ZDLAMT (13,0) Principal Amount
      *ZDLRAT (13,9) Effective Interest Rate
      *ZCBSDT ( 5,0) Start Date         }
      *ZCBEDT ( 5,0) End Date           }{for SR/ZCBDYS}
      *ZCBCBS ( 1,0) Calculation Basis  }
      *
      *Output:
      *~~~~~~~
      *ZDLOUT (13,0) Interest Amount
      *
      *****************************************************************
      *
      *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  #INIT  - Initial Processing                                  *
      *  #TERM  - Program termination                                 *
      *                                                               *
      *****************************************************************
      *
     FSDBANKPD  IF   E             DISK    INFSR(*PSSR)                                       LUC109
     F                                     USROPN                                             LUC109
      * E Specs
      ***/C*PY*ZSRSRC,ZDATE2Z1                                                                LUC109
     D/COPY ZSRSRC,ZDATE2Z1LE                                                                 LUC109
     D***/C*PY*ZSRSRC,ZDATE9Z1                                                         MUI009 LUC109
     D/COPY ZSRSRC,ZDATE9Z1LE                                                                 LUC109
      ***/C*PY*ZSRSRC,ZDAYSZ1                                                                 LUC109
     D/COPY ZSRSRC,ZDAYSZ1LE                                                                  LUC109
      *
      *                                                                                       LUC109
      ** Data structure for data-base error processing                                        LUC109
      *                                                                                       LUC109
     D DBERR           DS           256                                                       LUC109
     D  DBFILE               134    141                                                       LUC109
     D  DBKEY                142    170                                                       LUC109
     D  DBPGM                171    180                                                       LUC109
     D  DBASE                181    183  0                                                    LUC109
      *
     D RUNDT           DS
     D*
     D* External DTAARA for run-date
     D*
     D  RUNA                   1      7
     D  RUND                   8     10P 0
     D  SSF                   11     11
     D  DATF                  12     12
     D  MBIN                  13     13
      *                                                                   MUI009
     I***/C*PY*ZSRSRC,ZCBDYSZ2                                                         MUI009 LUC109
      *                                                                                       LUC109
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
     I***/C*PY*ZSRSRC,ZDATE9Z2                                                         MUI009 LUC109
     I/COPY ZSRSRC,ZDATE9Z2LE                                                                 LUC109
     I***/C*PY*ZSRSRC,ZDAT10Z1                                                                LUC109
     I/COPY ZSRSRC,ZDAT10Z1LE                                                                 LUC109
      *
      *****************************************************************
      *
     C                   EXSR      #INIT                                        Housekeeping
      *
     C                   EXSR      ZDLINT                                       Main process
      *
     C                   EXSR      #TERM                                        Return
      *
     C* Subroutines
      ***/C*PY*ZSRSRC,ZCBDYSZ1                                                                LUC109
     C/COPY ZSRSRC,XCBDYSZ1LE                                                                 LUC109
      ***/C*PY*ZSRSRC,ZDATE2Z2                                                                LUC109
     C/COPY ZSRSRC,ZDATE2Z2LE                                                                 LUC109
     C***/C*PY*ZSRSRC,ZDATE9Z3                                                         MUI009 LUC109
     C***/C*PY*ZSRSRC,ZDAT10Z2                                                         MUI009 LUC109
     C/COPY ZSRSRC,ZDAT10Z2LE                                                                 LUC109
      ***/C*PY*ZSRSRC,ZDLINTZ1                                                                LUC109
     C/COPY ZSRSRC,ZDLINTZ1LE
     C**
      *****************************************************************
      *                                                               *
      *  INIT - Program initialisation.                               *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     #INIT         BEGSR                                                  Initialisation
      *
      ** Entry parameters
      *
     C     *ENTRY        PLIST                                                  Parameters
     C                   PARM                    @DLAMT           13 0          Deal Amt
     C                   PARM                    @DLRAT           13 9          Int Rate
     C                   PARM                    @CBSDT            5 0          Start Date
     C                   PARM                    @CBEDT            5 0          End Date
     C                   PARM                    @CBCBS            1            Calc Basis
     C                   PARM                    @DLOUT           13 0          Int Amt Output
      *
     C                   Z-ADD     @DLAMT        ZDLAMT
     C                   Z-ADD     @DLRAT        ZDLRAT
     C                   Z-ADD     @CBSDT        ZCBSDT
     C                   Z-ADD     @CBEDT        ZCBEDT
     C                   MOVE      @CBCBS        ZCBCBS
      * Define data area
     C     *DTAARA       DEFINE    RUNDAT        RUNDT
     C                   IN        RUNDT
      * Check system date format, DDMMYY OR MMDDYY.
     C     DATF          COMP      'M'                                    98    MMDDYY, 98 ON
      *                                                                                       LUC109
      ** Data definition                                                                      LUC109
     C     *DTAARA       DEFINE    LDA           WLDA            256                          LUC109
     C                   MOVE      'N'           @@PSSR            1            *PSSR Control LUC109
      *                                                                                       LUC109
     C                   OPEN      SDBANKPD                                                   LUC109
     C     1             CHAIN     SDBANKPD                           88                      LUC109
     C                   CLOSE     SDBANKPD                                                   LUC109
      *                                                                                       LUC109
     C     *IN88         IFEQ      *ON                                                        LUC109
     C                   MOVEL     '001'         DBASE                          **************LUC109
     C                   MOVEL     'SDBANKPD'    DBFILE                         * DB ERR  001 LUC109
     C                   MOVE      *BLANKS       DBKEY                          **************LUC109
     C                   EXSR      *PSSR                                                      LUC109
     C                   ENDIF                                                                LUC109
     C                   ENDSR                                                                LUC109
      *
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
     C                   Z-ADD     ZDLOUT        @DLOUT
      *
     C                   RETURN                                                 Return control
      *
     C                   ENDSR
      ****************************************************************
      *                                                               *                       LUC109
      *  *PSSR  - Program Error Processing Subroutine.                *                       LUC109
      *                                                               *                       LUC109
      *  Called By: Various                                           *                       LUC109
      *  #AUDIT - Produce #AUDIT Report and End Program               *                       LUC109
      *                                                               *                       LUC109
      *****************************************************************                       LUC109
      *                                                                                       LUC109
     C     *PSSR         BEGSR                                                  *** *PSSR  ***LUC109
      *                                                                                       LUC109
      ** Prevent recursive call                                                               LUC109
      *                                                                                       LUC109
     C     @@PSSR        IFEQ      'N'                                          Recursive callLUC109
      *                                                                                       LUC109
     C                   MOVE      'Y'           @@PSSR                         *PSSR ExecutedLUC109
      *                                                                                       LUC109
      ** Update local data area                                                               LUC109
      *                                                                                       LUC109
     C     DBPGM         IFEQ      *BLANKS                                                    LUC109
     C                   MOVEL     'XX000047'    DBPGM                          Set program idLUC109
     C                   ENDIF                                                                LUC109
      *                                                                                       LUC109
     C     *LOCK         IN        WLDA                                                       LUC109
     C                   MOVEL     DBERR         WLDA                                         LUC109
     C                   OUT       WLDA                                                       LUC109
      *                                                                                       LUC109
     C                   MOVE      *ON           *INU7                                        LUC109
     C                   MOVE      *ON           *INU8                                        LUC109
     C                   DUMP                                                                 LUC109
      *                                                                                       LUC109
     C                   EXSR      #TERM                                                      LUC109
      *                                                                                       LUC109
     C                   ENDIF                                                                LUC109
      *                                                                                       LUC109
     C                   ENDSR                                                                LUC109
      /EJECT                                                                                  LUC109
      *****************************************************************                       LUC109
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
**   @YD  - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
00366007310109601461
**   @MD  - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
00000000310005900090001200015100181002120024300273003040033400365
**   ZF29 DAY NOS OF FEB 29 TO 2096 (INCLUDING 2000)
0006001521029820444305904073650882610287117481320914670161311759219053
2051421975234362489726358278192928030741322023366335124365853804639507
40968424294389045351
