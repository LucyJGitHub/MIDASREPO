     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Determine next coupon date')
      *****************************************************************
      *                                                               *
      *  Midas - Copy Source converted into ILE procedures            *
      *                                                               *
      *  ZNCD1   -   Determine first coupon date                      *
      *                                                               *
      *  This module is an ILE/RPG IV conversion of the ZNCD          *
      *  subroutine.  The subroutine consists of three /COPY member.  *
      *  Each of these has been converted to ILE RPG and copied into  *
      *  this member.  Necessary code to make this compileable has    *
      *  been added (entry and exit points and some declares).  The   *
      *  existing code has not been changed except to remove dead     *
      *  lines, and the boundaries of the original /COPY members have *
      *  been marked, to facilitate future maintenance of both the    *
      *  old members and this one.  If this member has to change, the *
      *  change should ALMOST CERTAINLY be implemented by changing    *
      *  the old /COPY member, reconverting it using CVTRPGSRC, and   *
      *  copying it into this member, replacing the existing section. *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSE071             Date 19Jul05               *
      *                 CSE035 *C *CREATE  Date 22Apr02               *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSE071 - Multiple Holidays Re Securities                     *
      *  CSE035 - NX/NNX Coupon Payment Processing.                   *
      *           conversion of ZNCD                                  *
      *                                                               *
      *****************************************************************
 
      ** +-----------------------------------------------------------------+
      ** Declares for variables that were defined externally for the
      ** original copy members
      ** +-----------------------------------------------------------------+
 
      ** Parameters
      ** Initial Date of the security
     D  ITLD           S              5P 0
      ** First Coupon Date of the security
     D  FCPN           S              5P 0
      ** Maturity Date
     D  MATY           S              5P 0
      ** Last Coupon Date of the security
     D  LCPN           S              5P 0
      ** Coupon Dates array
     D  CDArr          S             48A
      ** Coupon Rates Indicator array
     D  CRArr          S             12A
      ** Event Control Date
     D ECD             S              5P 0
      ** Date format indicator passed as a parameter from calling program.
     D  BJDFIN         S              1A
 
      ** Others
      ** MIDAS day number passed in as parameter from calling program
     D  ZDAYNO         S              5P 0
      **  Date field returned from ZDATE2 after conversion from MIDAS day number.
     D  ZADATE         S              7A
      ** Numerical date format after conversion from MIDAS day number from ZDATE2
     D  ZDATE          S              6P 0
      ** Character date used as input in conversion program ZDATE1
     D  ZDATEA         S              6A
                                                                                              CSE071
      ** CSE071 currencies                                                                    CSE071
     D  HCY1           S              3                                                       CSE071
     D  HCY2           S              3                                                       CSE071
     D  HCY3           S              3                                                       CSE071
     D  HCY4           S              3                                                       CSE071
     D  HCY5           S              3                                                       CSE071
     D  HCY6           S              3                                                       CSE071
     D  HCY7           S              3                                                       CSE071
     D  HCY8           S              3                                                       CSE071
     D  HCY9           S              3                                                       CSE071
                                                                                              CSE071
      ** +-----------------------------------------------------------------+
 
      ** +--- The converted ZNCDZ1 and ZNCDZ2 start here ----------------+
     D CDDS            DS
     D  CD01                   1      4  0
     D  CD02                   5      8  0
     D  CD03                   9     12  0
     D  CD04                  13     16  0
     D  CD05                  17     20  0
     D  CD06                  21     24  0
     D  CD07                  25     28  0
     D  CD08                  29     32  0
     D  CD09                  33     36  0
     D  CD10                  37     40  0
     D  CD11                  41     44  0
     D  CD12                  45     48  0
     D  CD                     1     48  0
     D                                     DIM(12)                              CD01-12 ARRAY
     D CRDS            DS
     D  CR01                   1      1
     D  CR02                   2      2
     D  CR03                   3      3
     D  CR04                   4      4
     D  CR05                   5      5
     D  CR06                   6      6
     D  CR07                   7      7
     D  CR08                   8      8
     D  CR09                   9      9
     D  CR10                  10     10
     D  CR11                  11     11
     D  CR12                  12     12
     D  CR                     1     12
     D                                     DIM(12)                              CR01-12 ARRAY
      ** +--- The converted ZNCDZ1 and ZNCDZ2 end here ------------------+
 
      * Set indicator 98 from BJDFIN
 
     C     BJDFIN        IFEQ      'M'
     C                   SETON                                        98
     C                   ELSE
     C                   SETOFF                                       98
     C                   END
 
      ** Set up coupon indicator and date arrays
 
     C                   MOVE      CDarr         CDDS
     C                   MOVE      CRarr         CRDS
 
      ** Execute the standard subroutine
     C                   EXSR      ZNCD1
 
     C                   RETURN
      /EJECT
 
      ** +--- The converted ZNCDZ3 starts here --------------------------+
     C********************************************************************
     C*    SUBROUTINE- ZNCD
     C*    DETERMINE NEXT COUPON DATE
     C*
     C**
     C**  INPUT - CD ARRAY - COUPON DATES - SECTYD SECURITY FILE
     C**          CR ARRAY - RATE/PAYT INDICS - SECTYD SECURITY FILE
     C**          FCPN - FIRST COUPON DATE - SECTYD SECURITY FILE
     C**          MATY - MATURITY DATE - SECTYD SECURITY FILE
     C**          ECD - EVENT CONTROL DTAE - ZEVCD PROCESS
     C**          *IN98 - DATE FORMAT - FROM RUNDAT VIA PROGRAM           S01117
     C**
     C**  OUTPUT - NCD1 (5,0) - NEXT COUPON DATE                                              CSE035
     C**
     C**  CALLS  - ZDATE1
     C**           ZDATE2
     C********************************************************************
     C**                                                                 *
     C**   LAST AMEND NO. 100228                  DATE 30MAY96           *
     C**   PREV AMEND NO. 091254                  DATE 20OCT95           *
     C**                  061823                  DATE 20OCT95           *
     C**                  S01117                  DATE 18JAN91           *
     C**                  E20085                  DATE 06NOV89           *
     C**                  E17876                  DATE 11/04/89          *
     C**                  E17704                  DATE 31/03/89          *
     C**                                                                 *
     C**-----------------------------------------------------------------*
     C**                                                                 *
     C**   100228 - Process added to allow 29Feb to be used in the       *
     C**            the coupon array in the Securities detail.           *
     C**   091254 - When the first coupon date do not correspond  to     *
     C**            a coupon date in the coupon date array, the next     *
     C**            coupon date will be incorrect if the ECD is equal    *
     C**            to first coupon date.                                *
     C**   061823 - If the First Coupon Date = Event Control Date, use   *
     C**            this date for the Next Coupon Date.                  *
     C**            This caters for the case where the coupon date would *
     C**            fall on a holiday, so the First Coupon Date has been *
     C**            input as the next working day.  However, no coupon   *
     C**            was generated on this day.                           *
     C**   S01117 - Multibranching Release 10.                           *
     C**   E20085 - INTEREST AND COUPONS CALCULATIONS REWRITE  -         *
     C**            - If Event Control Date is less than the Initial     *E20085
     C**              date of the Security, use Initial Date as the      *E20085
     C**              date for the calculation of Next Coupon Date.      *E20085
     C**            - First Coupon is not a mandatory field, so          *E20085
     C**              only do the check against it if it is not zero.    *E20085
     C**            - Next Coupon date is today if today is a coupon     *E20085
     C**              date - reverse of E17876.                          *E20085
     C**   E17876 - REMOVE E17704, CAUSES SE2100 LOOP IN ALL TEST SYS'S. *E17876
     C**   E17704 - NEXT COUPON DATE IS TODAY IF TODAY IS A COUPON DATE. *E17704
     C**                                                                 *
     C********************************************************************
     C*
     C     ZNCD1         BEGSR                                                  *** ZNCD   ***CSE035
      *                                                                                       CSE031
      **  Save value of NCD for compare later                                                 CSE031
     C                   Z-ADD     NCD           UUNCD             5 0                        CSE031
     C*
     C* CALL ZDATE2 TO OBTAIN MMDD FOR EVENT CONTROL DATE
     C***  Use the greater of ECD and ITLD as basis for the calculation   E20085
     C*                                                                   E20085
     C     ECD           IFGE      ITLD                                                        E2008
     C                   Z-ADD     ECD           ZDAYNO
     C                   ELSE                                                                  E2008
     C                   Z-ADD     ITLD          ZDAYNO                                        E2008
     C                   END                                                                   E2008
     C*
     C                   EXSR      ZDATE2
     C                   MOVEL     ZDATE         ZZECD4            4 0
     C     *IN98         IFEQ      '0'
     C                   MOVEL     ZZECD4        ZZWRKD
     C                   MOVE      ZZECD4        ZZWRKM
     C                   Z-ADD     ZZWRKD        ZZECD4
     C                   MOVEL     ZZWRKM        ZZECD4
     C                   END
      *
      * IF DATE FORMAT IS DDMMYY TURN ROUND ARRAY OF COUPON DATES TO MMDD
     C     *IN98         IFEQ      '0'
     C                   DO        12            X                 2 0
     C                   MOVE      CD(X)         ZZWRKM            2 0
     C                   MOVEL     CD(X)         ZZWRKD            2 0
     C                   Z-ADD     ZZWRKD        CD(X)
     C                   MOVEL     ZZWRKM        CD(X)
     C                   END
     C                   END
      * GET YEAR FOR ECD
     C                   MOVE      ZDATE         ZECDYR            2 0
      *
      * FIND NEXT COUPON DATE FROM ARRAYS -
      *  IF RATE/PAYT INDS ALL BLANK NCD = MATURITY DATE
     C                   Z-ADD     MATY          NCD               5 0
     C     CRDS          IFNE      *BLANKS
      *  IF RATE/PAYT INDS NOT ALL BLANK -
      *    SEARCH FOR NEXT HIGHEST COUPON
     C                   MOVE      '0'           ZFOUND            1
     C                   Z-ADD     0             TX                2 0                         10022
     C                   DO        12            X
     C     CR(X)         IFEQ      'P'
     C     CR(X)         OREQ      'C'
     C*                                                                   100228
     C** If 29Feb is used in the coupon array, then there is a need to    100228
     C** check if the current year is a leap year. If it is not,          100228
     C** the coupon date is changed to 28. But there is a need to store   100228
     C** the date so that it can be restored back after the check.        100228
     C*                                                                   100228
     C                   MOVE      CD(X)         ZZWRKD                                        10022
     C                   MOVEL     CD(X)         ZZWRKM                                        10022
     C     ZZWRKM        IFEQ      2                                                           10022
     C     ZZWRKD        ANDEQ     29                                                          10022
     C                   Z-ADD     ZECDYR        ZZYR              2 0                         10022
     C     ZZYR          ADD       28            ZZYR                                          10022
     C     ZZYR          DIV       4             ZZYR                                          10022
     C                   MVR                     ZMVR              1 0                         10022
     C     ZMVR          IFGT      0                                                           10022
     C                   Z-ADD     X             TX                                            10022
     C                   MOVE      '28'          CD(X)                                         10022
     C                   END                                                                   10022
     C                   END                                                                   10022
     C*                                                                   100228
     C     ZZECD4        IFLT      CD(X)                                                       09125
     C                   MOVE      '1'           ZFOUND
     C                   GOTO      ZNCD00
     C                   ELSE                                                                  09125
     C     ZZECD4        IFEQ      CD(X)                                                       09125
     C                   Z-ADD     ZECDYR        ZDATE                                         09125
     C                   MOVEL     CD(X)         ZDATE                                         09125
     C     *IN98         IFEQ      '0'                                                         09125
     C                   MOVEL     ZDATE         ZZWRK             4 0                         09125
     C                   MOVE      ZZWRK         ZZWRKM                                        09125
     C                   MOVEL     ZZWRK         ZZWRKD                                        09125
     C                   Z-ADD     ZZWRKD        ZZWRK                                         09125
     C                   MOVEL     ZZWRKM        ZZWRK                                         09125
     C                   MOVEL     ZZWRK         ZDATE                                         09125
     C                   END                                                                   09125
     C                   EXSR      ZDATE1                                                      09125
     C                   Z-ADD     ZDAYNO        NCD                                           09125
     C     NCD           IFGT      FCPN                                                        09125
     C     NCD           SUB       FCPN          @DDIF             5 0                         09125
     C     @DDIF         IFGT      10                                                          09125
     C                   MOVE      '1'           ZFOUND                                        09125
     C                   GOTO      ZNCD00                                                      09125
     C                   END                                                                   09125
     C                   END                                                                   09125
     C                   END                                                                   09125
     C                   END
     C                   END
     C                   END
      *      FOUND - ADD ECD'S YY TO FORM DATE
     C     ZNCD00        TAG                                                    ZNCD00 TAG
     C     ZFOUND        IFEQ      '1'
     C                   Z-ADD     ZECDYR        ZDATE
     C                   MOVEL     CD(X)         ZDATE
      *      NOT FOUND - USE FIRST COUPON
      *                  ADD NEXT YEAR'S YY TO FORM DATE
     C                   ELSE
     C                   DO        12            X
     C     CR(X)         IFEQ      'P'
     C     CR(X)         OREQ      'C'
     C*                                                                   100228
     C** If 29Feb is used in the coupon array, then there is a need to    100228
     C** check if the current year is a leap year. If it is not,          100228
     C** the coupon date is changed to 28. But there is a need to store   100228
     C** the date so that it can be restored back after the check.        100228
     C*                                                                   100228
     C     TX            IFNE      0                                                           10022
     C                   MOVE      '29'          CD(TX)                                        10022
     C                   Z-ADD     0             TX                                            10022
     C                   END                                                                   10022
     C*                                                                   100228
     C                   MOVE      CD(X)         ZZWRKD                                        10022
     C                   MOVEL     CD(X)         ZZWRKM                                        10022
     C     ZZWRKM        IFEQ      2                                                           10022
     C     ZZWRKD        ANDEQ     29                                                          10022
     C     ZECDYR        ADD       1             ZZYR                                          10022
     C     ZZYR          ADD       28            ZZYR                                          10022
     C     ZZYR          DIV       4             ZZYR                                          10022
     C                   MVR                     ZMVR              1 0                         10022
     C     ZMVR          IFGT      0                                                           10022
     C                   Z-ADD     X             TX                                            10022
     C                   MOVE      '28'          CD(X)                                         10022
     C                   END                                                                   10022
     C                   END                                                                   10022
     C*                                                                   100228
     C                   Z-ADD     ZECDYR        ZDATE
     C                   ADD       1             ZDATE
     C                   MOVEL     CD(X)         ZDATE
     C                   MOVE      '1'           ZFOUND
     C                   GOTO      ZNCD01
     C                   END
     C                   END
     C                   END
     C     ZNCD01        TAG                                                    ZNCD01 TAG
      *
      * CONVERT DATE TO DAY NO USING ZDATE1
      * (NOT DONE IF NO RATE/PAYT IND IS P OR C)
      * IF DDMMYY FORMAT TURN ROUND TO MMDDYY
     C     ZFOUND        IFEQ      '1'
     C     *IN98         IFEQ      '0'
     C                   MOVEL     ZDATE         ZZWRK             4 0
     C                   MOVE      ZZWRK         ZZWRKM
     C                   MOVEL     ZZWRK         ZZWRKD
     C                   Z-ADD     ZZWRKD        ZZWRK
     C                   MOVEL     ZZWRKM        ZZWRK
     C                   MOVEL     ZZWRK         ZDATE
     C                   END
     C                   EXSR      ZDATE1
     C                   Z-ADD     ZDAYNO        NCD
     C                   END
      *                                                                                       CSE035
      ** Move the value of NCD (Next coupon date from the array)                              CSE035
      ** to NCD1.                                                                             CSE035
      *                                                                                       CSE035
     C                   MOVE      NCD           NCD1                                         CSE035
      *
      * IF NCD > MATURITY DATE , RESET NCD = MATURITY DATE
     C     NCD           IFGT      MATY
     C                   Z-ADD     MATY          NCD
     C                   END
     C                   END
     C*
     C* If the First Coupon Date is not zero, then                        E20085
     C* IF NCD < 1ST COUPON DATE , RESET NCD = 1ST COUPON DATE
     C*                                                                   E20085
     C     FCPN          IFNE      *ZEROS                                                      E2008
     C     NCD           IFLE      FCPN                                                        09125
     C     ECD           ORLE      FCPN                                                        09125
     C                   Z-ADD     FCPN          NCD
     C                   END                                                                   09125
     C                   END
     C*                                                                   100228
     C** Restore 29Feb to the array if it is changed.                     100228
     C*                                                                   100228
     C     TX            IFNE      0                                                           10022
     C                   MOVE      '29'          CD(TX)                                        10022
     C                   END                                                                   10022
      *                                                                   061823
      ** If the First Coupon date is not zero, and is equal to the        061823
      ** Event Control Date, set the Next Coupon date to this date.       061823
      *                                                                   061823
     C     FCPN          IFNE      *ZEROS                                                      06182
     C     FCPN          ANDEQ     ECD                                                         06182
     C                   Z-ADD     FCPN          NCD                                           06182
     C                   END                                                                   06182
      *
      * IF DATE FORMAT IS DDMMYY TURN BACK ARRAY OF COUPON DATES TO DD/MM
     C     *IN98         IFEQ      '0'
     C                   DO        12            X                 2 0
     C                   MOVEL     CD(X)         ZZWRKM            2 0
     C                   MOVE      CD(X)         ZZWRKD            2 0
     C                   Z-ADD     ZZWRKM        CD(X)
     C                   MOVEL     ZZWRKD        CD(X)
     C                   END
     C                   END
      *                                                                                       180707
      ** At this stage, the field NCD holds details of real Last Coupon                       180707
      ** Date. Save this field into work field ZZNCD for use in SE2100.                       180707
      *                                                                                       180707
     C                   Z-ADD     NCD           ZZNCD             5 0                        180707
      **                                                                                      CSE005
      ** If BCNV is not blank then call SE0045                                                CSE005
      ** OR BCNV is not 'N' then call SE0045                                                  CSE031
      **                                                                                      CSE005
     C     BCNV          IFNE      ' '                                                        CSE005
     C     BCNV          ANDNE     'N'                                                        CSE031
     C                   MOVE      'N'           NCI               1                          CSE005
     C                   CALL      'SE0045'                                                   CSE005
     C                   PARM                    SITP                                         CSE005
     C                   PARM                    ECD                                          CSE005
     C                   PARM                    ITLD                                         CSE005
     C                   PARM                    FCPN                                         CSE005
     C                   PARM                    CD                                           CSE005
     C                   PARM                    CR                                           CSE005
     C                   PARM                    NMCY                                         CSE005
     C                   PARM                    NCD                                          CSE005
     C                   PARM                    NCI                                          CSE005
     C                   PARM                    BCNV                                         CSE005
     C                   PARM                    MATY                                         CSE005
     C                   PARM                    LCPN                                         CSE031
     C                   PARM                    HCY1                                         CSE071
     C                   PARM                    HCY2                                         CSE071
     C                   PARM                    HCY3                                         CSE071
     C                   PARM                    HCY4                                         CSE071
     C                   PARM                    HCY5                                         CSE071
     C                   PARM                    HCY6                                         CSE071
     C                   PARM                    HCY7                                         CSE071
     C                   PARM                    HCY8                                         CSE071
     C                   PARM                    HCY9                                         CSE071
      *                                                                                       CSE031
      ** Check if feature CSE031 is on                                                        CSE031
     C                   CALLB     'AOSARDR0'                                                 CSE031
     C                   PARM                    URTNCD            7                          CSE031
     C                   PARM      '*VERIFY'     UOPTN             7                          CSE031
     C                   PARM      'CSE031'      UUKEY             6                          CSE031
     C                   PARM                    UDSFDY           76                          CSE031
      *                                                                                       CSE071
     C                   MOVE      'N'           CSE031            1                          CSE071
     C     URTNCD        IFEQ      *BLANKS                                                    CSE071
     C                   MOVE      'Y'           CSE031                                       CSE071
     C                   ENDIF                                                                CSE071
      *                                                                                       CSE071
      ** Check if feature CSE071 is on                                                        CSE071
     C                   CALL      'AOSARDR0'                                                 CSE071
     C                   PARM                    URTNCD                                       CSE071
     C                   PARM      '*VERIFY'     UOPTN                                        CSE071
     C                   PARM      'CSE071'      UUKEY                                        CSE071
     C                   PARM                    UDSFDY                                       CSE071
      *                                                                                       CSE071
     C                   MOVE      'N'           CSE071            1                          CSE071
     C     URTNCD        IFEQ      *BLANKS                                                    CSE071
     C                   MOVE      'Y'           CSE071                                       CSE071
     C                   ENDIF                                                                CSE071
      *                                                                                       CSE031
      ** If CSE031 feature is on                                                              CSE031
      ** or CSE071 feature is on                                                              CSE071
     C**** URTNCD        IFEQ      *BLANKS                                              CSE031CSE071
     C     CSE031        IFEQ      'Y'                                                        CSE071
     C     CSE071        OREQ      'Y'                                                        CSE071
      *                                                                                       CSE031
      ** Set NCD to next coupon date on file SECTYD if it is greater                          CSE031
      ** than the event control date.                                                         CSE031
     C     UUNCD         IFGE      ECD                                                        CSE031
     C                   Z-ADD     UUNCD         NCD                                          CSE031
     C                   ENDIF                                                                CSE031
     C                   ENDIF                                                                CSE031
      *                                                                                       CSE031
     C                   ENDIF                                                                CSE005
     C*                                                                                       CSE005
     C*
     C                   ENDSR
     C*****************************************************************
      ** +--- The converted ZNCDZ3 ends here ----------------------------+
 
      /EJECT
      **********************************************************************
      *                                                                    *
      *  This subroutine is to cater for the fact that standard subroutine *
      *   ZNCD in this module executes another standard subroutine,        *
      *   ZDATE1, which has also been converted to a module.               *
      *  This subroutine is also called ZDATE1 and simply does a CALLB to  *
      *   the module that contains subroutine ZDATE1                       *
      *                                                                    *
     C     ZDATE1        BEGSR
      *
     C                   MOVE      ZDATE         ZDATEA
      *
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATEA
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFLag         1
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
      *                                                                    *
      *  This subroutine is to cater for the fact that standard subroutine *
      *   ZNCD in this module executes another standard subroutine,        *
      *   ZDATE2, which has also been converted to a module.               *
      *  This subroutine is also called ZDATE2 and simply does a CALLB to  *
      *   the module that contains subroutine ZDATE2                       *
      *                                                                    *
     C     ZDATE2        BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
 
     C                   ENDSR
      **********************************************************************
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
 
     C     *entry        PLIST
 
      * INPUTS
 
      ** Security details
     C                   PARM                    ITLD
     C                   PARM                    FCPN
     C                   PARM                    MATY
     C                   PARM                    CDArr
     C                   PARM                    CRArr
      *
      ** Event Control Date
      ** Date Format
     C                   PARM                    ECD
     C                   PARM                    BJDFIN
 
      ** Nominal Currency
      ** Security Investment Type
      ** Effect on Holidays on Coupon Dates
     C                   PARM                    NMCY              3
     C                   PARM                    SITP              3
     C                   PARM                    BCNV              1
 
      ** Last Coupon Date
     C                   PARM                    LCPN
      ** Effect of Holidays on Dates                                                          CSE071
     C                   PARM                    HCY1                                         CSE071
     C                   PARM                    HCY2                                         CSE071
     C                   PARM                    HCY3                                         CSE071
     C                   PARM                    HCY4                                         CSE071
     C                   PARM                    HCY5                                         CSE071
     C                   PARM                    HCY6                                         CSE071
     C                   PARM                    HCY7                                         CSE071
     C                   PARM                    HCY8                                         CSE071
     C                   PARM                    HCY9                                         CSE071
 
      * OUTPUTS
 
      ** Next Coupon Date
     C                   PARM                    NCD1              5 0
 
     C                   ENDSR
 
      *****************************************************************
