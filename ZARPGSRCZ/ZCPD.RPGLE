     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZS Calculate a period date')
      *****************************************************************
      *                                                               *
      *  Midas - Standard Subroutines                                 *
      *                                                               *
      *  ZCPD - Calculate a period date DDMMYY                        *
      *                                                               *
      *  Function:    This module converts Midas Date into            *
      *               DDMMYY or MMDDYY format                         *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CAP076             Date 26Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP076 - Lending API enhancements - Rollover details         *
      *                                                               *
      ****************************************************************
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      **
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
     D ZYMD            DS
     D* DS for use with ZCPD - Calculate a Period Date
     D  ZYYYY                  1      4  0
     D  ZMM                    5      6  0
     D  ZDD                    7      8  0
      *                                                               *
      ** Midas Day number
     D @@DAYN          S              5P 0
 
      ** Formatted date field for use in the parameter list
     D @@VDT           S              8S 0
      *                                                               *
     D ZFMD            S              2  0 DIM(12) CTDATA PERRCD(12)
     C*****************************************************************
     C*                                                               *
     C*  ZCPD - Calculate the Period Date from a given Date implied   *
     C*         by a given number of years, months and days.  The     *
     C*         date is the actual date ie. no checks are made for    *
     C*         holidays/working days.                                *
     C*                                                               *
     C*  CALLS:      ZDATE9 - Convert Midas Day No. to YYYYMMDD       *
     C*              ZDATE10 - Convert YYYYMMDD to Midas Day No.      *
     C*              ZDATE2 - Convert Midas Day No. to DDMMMYY/MMMDDYY*
     C*                                                               *
     C*  INPUT:      ZINDT     INPUT DATE (5,0)                       *
     C*              ZNYR      NUMBER OF YEARS (2,0)                  *
     C*              ZNMN      NUMBER OF MONTHS (2,0)                 *
     C*              ZNDY      NUMBER OF DAYS (2,0)                   *
     C*                                                               *
     C*  OUTPUT:     ZPDNO     PERIOD DATE (5,0)                      *
     C*              ZPDTE     PERIOD DATE (7A)                       *
     C*                                                               *
     C*  USES:       ZYMD      DS name - YYYYMMDD                     *
     C*              ZYYYY     DS subfield of ZYMD - Year             *
     C*              ZMM       DS subfield of ZYMD - Month            *
     C*              ZDD       DS subfield of ZYMD - Day              *
     C*              ZMY       Number of years from months            *
     C*              ZWRK2     Last day in month                      *
     C*              ZFMD      Array - number of days in each month   *
     C*              ZNLYR     Leap year if equal to 0                *
     C*              @@DAYN    Input to ZDATE9 - Midas Day No.        *
     C*              @@VDT     Output from ZDATE9 - YYYYMMDD          *
     C*              ZZDTIN    Input to ZDATE10 - YYYYMMDD            *
     C*              ZZMDNO    Output from ZDATE10 - Midas Day No.    *
     C*              ZDAYNO    Input to ZDATE2 - Midas Day No.        *
     C*              ZADATE    Output from ZDATE2 - DDMMMYY/MMMDDYY   *
     C*                                                               *
     C*****************************************************************
     C*
     C**
     C********************************************************************
     C*
     C* Define fields
     C                   Z-ADD     ZINDT         ZINDT             5 0
     C                   Z-ADD     ZNYR          ZNYR              2 0
     C                   Z-ADD     ZNMN          ZNMN              2 0
     C                   Z-ADD     ZNDY          ZNDY              2 0
     C*
     C* Convert input Date to YYYYMMDD format
     C                   Z-ADD     ZINDT         @@DAYN
     C                   EXSR      ZDATE9
     C                   MOVEL     @@VDT         ZYMD
     C*
     C* Process Number of Years
     C* -----------------------
     C*
     C* if Number of Years greater than zero then add onto years
     C     ZNYR          IFGT      0
     C     ZYYYY         ADD       ZNYR          ZYYYY
     C                   END
     C*
     C* Process Number of Months
     C* ------------------------
     C*
     C* if Number of Months greater than zero then add onto months
     C* (ZMM + ZNMN could be >99 so use 3,0 work field then re-set ZMM)
     C     ZNMN          IFGT      0
     C     ZMM           ADD       ZNMN          ZMM3              3 0
     C*
     C* if months is now greater than 12 then divide by 12 and
     C* keep the remainder in ZMM
     C     ZMM3          IFGT      12
     C     ZMM3          DIV       12            ZMY               1 0
     C                   MVR                     ZMM3
     C*
     C* if months now equal to zero (ie. divided by 12 exactly) then
     C* month should be December - set months to 12 and subtract 1
     C* from year to compensate
     C     ZMM3          IFEQ      0
     C     ZMY           SUB       1             ZMY
     C                   Z-ADD     12            ZMM3
     C                   END
     C*
     C* increment years appropriately
     C     ZYYYY         ADD       ZMY           ZYYYY
     C                   END
     C*
     C                   Z-ADD     ZMM3          ZMM
     C                   END
     C*
     C* Adjust Days in Months, if necessary
     C* -----------------------------------
     C*
     C* if days now exceeds the number of days possible in that month
     C* then adjust days to indicate the last day in that month.
     C* eg. 31st January, 1991 with an indicated period of 1 month
     C* will give the 28th February, 1991
     C*
     C* bypass this processing if days not greater than 28 since every
     C* month must have at least 28 days
     C     ZDD           IFGT      28
     C*
     C* look up number of days possible in month
     C                   MOVE      ZFMD(ZMM)     ZWRK2             2 0
     C*
     C*   if February
     C     ZMM           IFEQ      2
     C*
     C*     and a leap year
     C     ZYYYY         DIV       4             ZLYR              2 0
     C                   MVR                     ZNLYR             1 0
     C     ZNLYR         IFEQ      0
     C*
     C*     set number of days to 29
     C                   Z-ADD     29            ZWRK2
     C                   END
     C*
     C                   END
     C*
     C* if current days is greater than possible days in month
     C* then set to last possible day in month
     C     ZDD           IFGT      ZWRK2
     C                   Z-ADD     ZWRK2         ZDD
     C                   END
     C*
     C                   END
     C*
     C* Convert YYYYMMDD to Midas Day No.
     C* ---------------------------------
     C*
     C                   MOVEL     ZYMD          ZZDTIN
     C                   EXSR      ZDATE10
     C                   Z-ADD     ZZMDNO        ZPDNO
     C*
     C* Process Number of Days
     C* ----------------------
     C*
     C* if Number of Days greater than zero then add onto Midas Day No.
     C     ZNDY          IFGT      0
     C     ZPDNO         ADD       ZNDY          ZPDNO             5 0
     C                   END
     C*
     C* convert Midas Day No. to DDMMMYY/MMMDDYY
     C                   Z-ADD     ZPDNO         ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZADATE        ZPDTE             7
     C*
     C                   RETURN
     C*
     C*****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZDATE2 - Format a date for output                             *
      *                                                               *
      *****************************************************************
     C     ZDATE2        BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
 
     C                   ENDSR
     C********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZDATE9 - Convert day number to YYYYMMDD format                *
      *                                                               *
      *****************************************************************
     C     ZDATE9        BEGSR
 
     C                   CALLB     'ZDATE9'
     C                   PARM                    @@DAYN
     C                   PARM                    @@VDT
     C                   PARM                    @@RTN             1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZDAT10 - Convert day number to YYYYMMDD format                *
      *                                                               *
      *****************************************************************
     C     ZDATE10       BEGSR
 
     C                   CALLB     'ZDATE10'
     C                   PARM                    ZZDTIN            8
     C                   PARM                    ZZMDNO            5 0
 
     C                   ENDSR
     C*****************************************************************
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
 
     C     *ENTRY        PLIST                                                  Entry parameter
      *
      * INPUTS
      *
     C                   PARM                    ZINDT                          Input date
     C                   PARM                    ZNYR                           Number of years
     C                   PARM                    ZNMN                           Number of months
     C                   PARM                    ZNDY                           Number of months
     C                   PARM                    BJDFIN            1            Date Format Indic.
      *
      * OUTPUTS
      *
     C                   PARM                    ZPDNO                          Period date
     C                   PARM                    ZPDTE                          Period date
 
 
     C                   ENDSR
     C*****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
** CPY@
(c) Finastra International Limited 2002
**   ZFMD  -  NUMBER OF DAYS IN THE MONTH
312831303130313130313031
