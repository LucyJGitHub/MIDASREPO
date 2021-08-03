     H DEBUG
      *****************************************************************
/*S*D****RPGBASE*******************************************************                       LUC109
/*STD *  RPGBASEBND                                                   *                       LUC109
/*EXI *  TEXT('Date Conversion Utility')                              *                       LUC109
      *****************************************************************
      *                                                               *
      *  Midas - Midas Interface.                                     *
      *                                                               *
      ***GLM053*-*Date*Conversion*Utility******************************                       LUC109
      *  XX000053 - Date Conversion Utility                           *                       LUC109
      *  (Copy of IBM002 - CAR ICM003)                                *
      *                                                               *                       LUC109
  ?   *****************************************************************
  ?   * *** THIS PROGRAM MUST BE COMPILED WITH XXINTFLIB AT THE TOP   *
  ?   * OF LIBL ***                                                   *
  ?   *****************************************************************
      *                                                               *
      *  Function:  This program converts a Midas day number into     *
      *             YYYYMMDD format or a given date into a Midas      *
      *             day number.                                       *
      *                                                               *
      *                                                               *
      *  Called By:                                                   *
      *                                                               *
      ***(C)*Copyright*Midas-Kapiti*International*Ltd.*1998************                       LUC109
      *  (c) Finastra International Limited 2016                      *                       LUC109
      *                                                               *
      *  Last Amend No. LUC109             Date 20Sep16               *
      *  Prev Amend No. MMI043  *CREATE    Date 01Dec99               *
      *                 XXXXXX             Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *
      *  MMI043 - Bank of Italy Head Office Reporting                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  SUBROUTINE INDEX                                             *
      *                                                               *
      *  #IINIT - Initial Processing.                                 *
      *  #ICONV - Date conversion subroutine.                         *
      *  #IVLDT - Date validation subroutine.                         *
      *                                                               *
     F*****************************************************************
     F*                                                               *
     F*  F U N C T I O N   O F   I N D I C A T O R S                  *
     F*                                                               *
     F*   90  - ON if the entered month is a 30 day month.            *
     F*   99  - ON if the date is invalid.                            *
     F*   LR  - Last Record Indicator                                 *
     F*                                                               *
     F*****************************************************************
      /EJECT
      *****************************************************************
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      ** Array containing Copyright statement
      *
     D***/C*PY*ZSRSRC,ZDATE9Z1                                                                LUC109
     D/COPY ZSRSRC,ZDATE9Z1LE                                                                 LUC109
      ** Arrays for ZDATE9 containing the cumulative days for a 4 year
      ** period and for a year per month.
      *
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
      *
     D PSDS           SDS
      *
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
     I*
     I***/C*PY*ZSRSRC,ZDATE9Z2                                                                LUC109
     I/COPY ZSRSRC,ZDATE9Z2LE                                                                 LUC109
      ** DS for fields @@Z71Y and @@VDT in SR. ZDATE9
      *
     I*
     I***/C*PY*ZSRSRC,ZDAT10Z1                                                                LUC109
     I/COPY ZSRSRC,ZDAT10Z1LE                                                                 LUC109
      ** DS for ZZDTIN (date input) in SR. ZDAT10
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            MAIN     - Control Processing.                     *
      *                                                               *
      * CALLS      #IINIT   - Initial Processing.                     *
      *            #ICONV   - Date Conversion Processing.             *
      *                                                               *
      * CALLED BY         -                                           *
      *                                                               *
      *                                                               *
      *****************************************************************
      *
     C*
     C**  Initial processing
     C                   EXSR      #IINIT
      *
     C**  Convert user input (Day number or Date).
     C                   EXSR      #ICONV
      *
     C                   RETURN
     C                   MOVE      *ON           *INLR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            #IINIT - Initial Processing                        *
      *                                                               *
      * CALLS                                                         *
      *                                                               *
      * CALLED BY  MAIN   - Control Process                           *
      *                                                               *
      *****************************************************************
     C     #IINIT        BEGSR                                                  ** #IINIT **
      *
     C                   MOVEA     CPY@          CPY2@            80
      ** Set up copyright parameter
      *
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT
      ** Read in Installation Data
      *
     C                   MOVE      *OFF          *IN99
      ** Initialise error indicator to OFF.
      *
      ** Define parameter list for IBM002.
      *
     C     *ENTRY        PLIST
     C                   PARM                    P@DAY             5 0
     C                   PARM                    P@DATE            8 0
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            #ICONV   - Convert day number into a date or an    *
      *                       entered date into a Midas Day Number.   *
      *                                                               *
      * CALLS      #IVLDT - Validate date subroutine.                 *
      *                                                               *
      * CALLED BY  MAIN   - Control Process                           *
      *                                                               *
      *****************************************************************
     C     #ICONV        BEGSR                                                  ** #ICONV **
      *
      ** If the day number is not 0, call the subroutine to convert
      ** it to a YYYYMMDD date format.
     C     P@DAY         IFNE      0
     C                   Z-ADD     P@DAY         @@DAYN            5 0
     C                   EXSR      ZDATE9
     C                   Z-ADD     @@VDT         P@DATE
      *
      ** Otherwise, check that the given date is valid and continue
      ** to convert it into a Midas day number.
     C                   ELSE
     C                   Z-ADD     P@DATE        ZZDTIN
     C                   EXSR      #IVLDT
     C     *IN99         IFEQ      *ON
     C                   Z-ADD     0             P@DAY
     C                   ELSE
     C                   EXSR      ZDAT10
     C                   Z-ADD     ZZMDNO        P@DAY
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            #IVLDT   - Validate date processing.               *
      *                                                               *
      * CALLS                                                         *
      *                                                               *
      * CALLED BY  #ICONV - Date Conversion subroutine.               *
      *                                                               *
      *****************************************************************
     C     #IVLDT        BEGSR                                                  ** #IVLDT **
      *
      ** Check that the month and day numbers are within a valid
      ** range.
     C     ZWMTH         IFLE      0
     C     ZWDAY         ORLE      0
     C     ZWDAY         ORGT      31
     C                   MOVE      *ON           *IN99
      *
      ** If they are, check that the day number is valid for the
      ** entered month.
     C                   ELSE
     C     ZWMTH         IFEQ      4
     C     ZWMTH         OREQ      6
     C     ZWMTH         OREQ      9
     C     ZWMTH         OREQ      11
     C                   MOVE      *ON           *IN90
     C                   ENDIF
      *
      ** Check that for the 30-day months the day number is not
      ** greater than 30.
     C     ZWDAY         IFGT      30
     C     *IN90         ANDEQ     *ON
     C                   MOVE      *ON           *IN99
     C                   ENDIF
      *
      ** Check if the given year is a leap year.
     C     ZWYYYY        ADD       28            UEWRK             2 0
     C     UEWRK         DIV       4             UEWRK
     C                   MVR                     ZWREM             1 0
      *
      ** If it is, need to do further checks involving the
      ** number of days in February.
     C     ZWREM         IFEQ      0
     C     ZWMTH         ANDEQ     2
     C     ZWDAY         ANDGT     29
     C     ZWREM         ORNE      0
     C     ZWMTH         ANDEQ     2
     C     ZWDAY         ANDGT     28
     C                   MOVE      *ON           *IN99
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
     C***/C*PY*ZSRSRC,ZDATE9Z3                                                                LUC109
     C/COPY ZSRSRC,ZDATE9Z3LE                                                                 LUC109
      ** Subroutine to convert a Midas Day Number into a YYYYMMDD
      ** date format.
      *
     C***/C*PY*ZSRSRC,ZDAT10Z2                                                                LUC109
     C/COPY ZSRSRC,ZDAT10Z2LE                                                                 LUC109
      ** Subroutine to convert a date into a Midas Day Number.
      *
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2016
     X/COPY ZSRSRC,ZDATE9Z4
