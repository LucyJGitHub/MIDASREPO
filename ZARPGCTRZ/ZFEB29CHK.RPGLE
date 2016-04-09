     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Check for Feb 29 within a period')
      *****************************************************************
      *                                                               *
      *  Midas - Standard routines                                    *
      *                                                               *
      *  ZFEB29CHK - Check for the existence of Feb 29 within a       *
      *              period.                                          *
      *                                                               *
      *  Function:  This module checks for the existence of Feb 29    *
      *             within a period.                                  *
      *             Start date and end date must be in the format     *
      *             YYYYMMDD.                                         *
      *             Flag #29FEB is set to 'Y' if a Feb 29 occurs      *
      *             during the period, otherwise it is set to 'N'.    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CIR013  *CREATE    Date 11Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CIR013 - Additional Calculation Method for FRA/IRS/CCF       *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
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
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D ZZStartDate     S              8S 0
     D ZZEndDate       S              8S 0
     D ZZ#29Feb        S              1A
 
     D                 DS
     D WkStartDate             1      8  0
     D WkCCYY1                 1      4  0
     D WkYY1                   3      4  0
     D WkMM1                   5      6  0
     D WkMMDD1                 5      8  0
 
     D                 DS
     D WkEndDate               1      8  0
     D WkCCYY2                 1      4  0
     D WkYY2                   3      4  0
     D WkMM2                   5      6  0
     D WkMMDD2                 5      8  0
 
     D                 DS
     D WkCCYY                  1      4  0
     D WkYY                    3      4  0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   Eval      ZZ#29Feb = 'N'
 
      ** Check for a Feb 29 within the start and end dates
     C                   If        ZZStartDate <= ZZEndDate
 
     C                   Eval      WkStartDate = ZZStartDate
     C                   Eval      WkEndDate = ZZEndDate
 
      ** If the start date year is divisible by 4 (or by 400 for a year
      ** ending in 00) ie. a leap year, and start date on/before 29 Feb and
      ** end date on/after 29 Feb for that year, set flag to 'Y'.
     C                   If        ((WkYY1 <> 0 and %Rem(WkCCYY1:4) = 0) or
     C                              (WkYY1 = 0 and %Rem(WkCCYY1:400) = 0))
     C                             and WkMM1 <= 2 and (WkCCYY2 > WkCCYY1 or
     C                             (WkCCYY1 = WkCCYY2 and WkMMDD2 >= 0229))
     C                   Eval      ZZ#29Feb = 'Y'
 
     C                   Elseif    WkCCYY2 > WkCCYY1
     C                   Eval      WkCCYY = WkCCYY1 + 1
 
      ** If end date year > start date year, check each year upto period end
     C                   DoU       WkCCYY > WkCCYY2
 
      ** If the year is divisible by 4 (or by 400 for a year ending in 00)
      ** ie. a leap year, and end date on/after 29 Feb for that year, set
      ** flag to 'Y'.
     C                   If        ((WkYY <> 0 and %Rem(WkCCYY:4) = 0) or
     C                              (WkYY = 0 and %Rem(WkCCYY:400) = 0))
     C                             and (WkCCYY2 > WkCCYY or
     C                             (WkCCYY2 = WkCCYY and WkMMDD2 >= 0229))
     C                   Eval      ZZ#29Feb = 'Y'
     C                   Leave
     C                   Endif
 
     C                   Eval      WkCCYY += 1
     C                   Enddo
 
     C                   Endif
     C                   Endif
 
     C                   Return
 
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
 
     C     *entry        Plist
      ** Start date (8,0S,format YYYYMMDD, from caller)
     C                   Parm                    ZZStartDate
      ** End date (8,0S,format YYYYMMDD, from caller)
     C                   Parm                    ZZEndDate
      ** Feb 29 flag (1A, value Y/N, returned to caller)
     C                   Parm                    ZZ#29Feb
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
