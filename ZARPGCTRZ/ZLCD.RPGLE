     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Determine last coupon date')
      *****************************************************************
      *                                                               *
      *  Midas - Copy Source converted into ILE procedures            *
      *                                                               *
      *  ZLCD    -   Determine last coupon date                       *
      *                                                               *
      *  This module is an ILE/RPG IV conversion of the ZLCD          *
      *  subroutine.  The subroutine consists of one /COPY member.    *
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
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD034630           Date 10Nov15               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11193           Date 02May06               *
      *                 BUG11009           Date 30Mar06               *
      *                 CSE071             Date 19Jul05               *
      *                 CSE035             Date 22Apr02               *
      *                 206316             Date 19Jul02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE031             Date 15Nov01               *
      *                 183891             Date 22Sep00               *
      *                 168141             Date 29Sep99               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CSE005             Date 19Jun00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 149184             Date 07Dec98               *
      *                 CAP002  *CREATE    Date 21Apr98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD034630 - Multiple calls of UTCHOBJEX inside GOC0020        *
      *  BUG11193 - Purchased Interest not calculated on BackValued   *
      *             Trade.                                            *
      *  BUG11009 - Wrong calculation of purchased interest.          *
      *             Applied fix 231841.                               *
      *  CSE071 - Multiple Holidays Re Securities                     *
      *  CSE035 - NX/NNX Coupon Payment Processing.                   *
      *  206316 - ZDAYNO is incorrect for Interest calculations if    *
      *           CSE031 is switched on.                              *
      *  CSE031 - Coupon Fixing for Floating Rate Notes               *
      *  183891 - If BCNV is non-blank, call SE0045 BEFORE deciding   *
      *           that the Last Coupon Date has been found.           *
      *  168141 - Switchable feature CSE005 introduced the ability    *
      *           to use next working day as last coupon date if that *
      *           date was a non working day. Therefore need to est-  *
      *           ablish real coupon date to stop looping.Have agreed *
      *           with core management (Keith Eagle) that since this  *
      *           will not effect any other program than SE2235 will  *
      *           do not need to recompile all programs using this    *
      *           sub routine. Program therefore saves REAL LAST      *
      *           COUPON DATE before calling SE0045. T Sales 29/9/99  *
      *  CSE005 - Effect of holidays on FRN coupon dates.            **
      *  149184 - Apply core fix 130862 to ZLCDZ1                     *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
 
      ** +-----------------------------------------------------------------+
      ** Declares for variables that were defined externally for the
      ** original copy members
      ** +-----------------------------------------------------------------+
 
      ** Parameters
      ** Issue Date of the security
     D  ISSD           S              5P 0
      ** Initial Date of the security
     D  ITLD           S              5P 0
      ** First Coupon Date of the security
     D  FCPN           S              5P 0
      ** Maturity Date
     D  MATY           S              5P 0
      ** Last Coupon Date of the security                                                     CSE031
     D  LCPN           S              5P 0                                                    CSE031
      ** Coupon Dates array
     D  CDArr          S             48A
      ** Coupon Rates Indicator array
     D  CRArr          S             12A
      ** Date format indicator.
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
      ** These are part of a different standard SR but are needed here
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
                                                                                              CSE035
                                                                                              CSE035
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSE035
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CSE035
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE                                   CSE035
      *                                                                                     MD034630
      ** AOSARDR0 Parameter                                                                 MD034630
     D  URTNCD         S              7A                                                    MD034630
     D  UOPTN          S              7A                                                    MD034630
     D  UUKEY          S              6A                                                    MD034630
     D  UDSFDY         S             76A                                                    MD034630
     D  CSE031         S              1A                                                    MD034630
     D  CSE071         S              1A                                                    MD034630
 
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
     C                   EXSR      ZLCD
 
     C                   RETURN
      /EJECT
 
      ** +--- The converted ZLCDZ1 starts here --------------------------+
      *****************************************************************
      **                                                             **
      ** ZLCD   - Subroutine to calculate the Last Coupon Date prior **
      **          to an Event Control Date (For Example: the Value   **
      **          Date of a Trade).                                  **
      **                                                             **
      ** INPUT - CD ARRAY - Coupon Dates from PF/SECTYD              **
      **         CR ARRAY - Rate/Payment indicators from PF/SECTYD   **
      **         ITLD   (5,0) Initial Date from PF/SECTYD            **
      **         FCPN   (5,0) First Coupon Date from PF/SECTYD       **
      **         ZECD   (5,0) Event Control Date                     **
      **         *IN98        Date Format from RUNDAT via program    **   S01117
      **                                                             **
      ** OUTPUT - ZZLCD (5,0) Last Coupon Date before Control Date   **
      **                                                             **
      ** CALLS  - ZDATE1                                             **
      **          ZDATE2                                             **
      **          SE0045 - Effect of holidays on FRN coupon dates    **
      **                                                             **
      *****************************************************************
      **                                                             **
      ** Last Amend no. 149184 (130862)    Date 16Oct98              **
      **                100228             DATE 30MAY96              **
      **                091254             DATE 20OCT95              **
      **                079952             DATE 20OCT95              **
      **                072688             DATE 20OCT95              **
      **                E27092             DATE 04SEP91              **
      **                S01117             DATE 18JAN91              **
      **                E21616             DATE 03APR90              **
      **                E20085             DATE 03NOV89              **
      **                                                             **
      *---------------------------------------------------------------*
      **                                                             **
      ** 149184 - Last and next coupon dates should be the same as   **
      **          Rundate when rundate = first coupon date.          **
      **          (Same as fix 130862 in non-API version)            **
      ** CSE005 - Effect of holidays on FRN coupon dates.            **
      ** 100228 - Process added to allow 29Feb to be used in the     **
      **          the coupon array in the Securities detail.         **
      ** 091254 - When the first coupon date do not correspond  to   **
      **          a coupon date in the coupon date array, the last   **
      **          coupon date for the second period is incorrect.    **
      ** 079952 - Fix last coupon date for 072688                    **
      **          When the first coupon date do not corresponde to   **
      **          a coupon date array, the last coupon date for the  **
      **          second period is incorrect. This is because fix    **
      **          072688 is incomplete.                              **
      ** 072688 - If ECD is less/equal to 1st coupon date            **
      **          then the last coupon date equals 1st coupon date.  **
      ** E27092 - IF ECD IS MATURITY DATE THIS SHOULD BE THE LAST    **
      **          COUPON DATE                                        **
      ** S01117 - Release 10 multibranching.                         **
      ** E21616 - If the Subroutine has to find the latest Coupon in **   E21616
      **          the previous year, it subtracts 1 from ZECDYR. If  **   E21616
      **          the year is '2000', we get '00 - 1', ie.'-1'.      **   E21616
      **          Add an IF to cater for ZECDYR = 00.                **   E21616
      ** E20085 - Created for Interest and Coupons calculations      **   E20085
      **          rewrite.                                           **   E20085
      **                                                             **
      *****************************************************************
      *
     C     ZLCD          BEGSR                                                  *** ZLCD   ***
      *
      ***  Define fields:
      *
     C*********************Z-ADDECD       ECD     50       DEFINED 072688 079952
     C                   Z-ADD     ZECD          ZECD              5 0
     C                   Z-ADD     *ZEROS        ZZLCD             5 0
      *                                                                   E27092
      ***  if event control date is maturity date this is last coupon dateE27092
      *                                                                   E27092
     C***********ZECD      IFEQ MATY                               E27092 091254
     C     ZECD          IFGE      MATY                                                        09125
     C***********          Z-ADDZECD      ZZLCD                    E27092 091254
     C                   Z-ADD     MATY          ZZLCD                                         09125
     C                   GOTO      EZLCD                                                       E2709
     C                   END                                                                   E2709
      *                                                                   149184
      **  If Today is first coupon day then it must also be last          149184
      **  coupon day.                                                     149184
      *                                                                   149184
     C     ZECD          IFEQ      FCPN                                                       149184
     C                   Z-ADD     FCPN          ZZLCD                                        149184
     C                   GOTO      EZLCD                                                      149184
     C                   ENDIF                                                                149184
      *
      ***  Call ZDATE2 to obtain MMDD for the Control Date
      *
     C                   Z-ADD     ZECD          ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZDATE         ZZECD4            4 0
     C     *IN98         IFEQ      '0'
     C                   MOVEL     ZZECD4        ZZWRKD
     C                   MOVE      ZZECD4        ZZWRKM
     C                   Z-ADD     ZZWRKD        ZZECD4
     C                   MOVEL     ZZWRKM        ZZECD4
     C                   END
      *
      ***  If the Date Format is DDMMYY, then turn the array of Coupon
      ***  Dates around to MMDD format.
      *
     C     *IN98         IFEQ      '0'
     C                   DO        12            X                 2 0
     C                   MOVE      CD(X)         ZZWRKM            2 0
     C                   MOVEL     CD(X)         ZZWRKD            2 0
     C                   Z-ADD     ZZWRKD        CD(X)
     C                   MOVEL     ZZWRKM        CD(X)
     C                   END
     C                   END
      *
      ***  Get year of Control Date
     C                   MOVE      ZDATE         ZECDYR            2 0
      *
      ***  Find the Prior Coupon Date from the Arrays:
      ***  If the Rate/Payment Indicators are all blank, then ZZLCD
      ***  will equal Initial Date. (SHOULDN'T OCCUR)
      *
     C                   Z-ADD     ITLD          ZZLCD
      *                                                                                CSE031 206316
      ***As*SE0045*has*been*changed*to*always*return*the*Last*Coupon                   CSE031 206316
      ***Date*as*is*on*the*file,*for*Interest*calculations*we*need*to                  CSE031 206316
      ***set*LCPN*to*zero*at*this*point*so*that*SE0045*will*calculate                  CSE031 206316
      ***the*Last*Coupon*Date*according*to*the*array.                                  CSE031 206316
      *                                                                                CSE031 206316
     C*******************Z-ADD     LCPN          UULCPN            5 0                 CSE031 206316
     C*******************Z-ADD     *ZERO         LCPN                                  CSE031 206316
      *
     C     CRDS          IFNE      *BLANKS
     C                   MOVE      '0'           ZFOUND            1
     C                   Z-ADD     0             TX                2 0                         10022
     C                   Z-ADD     12            X
      *
     C     X             DOWGT     0
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
     C     ZZECD4        IFGE      CD(X)
      *                                                                                       183891
      ** If BCNV is not blank then call SE0045 before exiting the loop.                       183891
      ***  Set up Coupon Date                                                                 183891
      **                                                                                      183891
     C     BCNV          IFNE      ' '                                                        183891
     C     BCNV          ANDNE     'N'                                                        CSE031
     C                   Z-ADD     ZECDYR        ZDATE                                        183891
     C                   MOVEL     CD(X)         ZDATE                                        183891
      *                                                                                       183891
      ***  Convert the Coupon Date to Midas Day Number using ZDATE1                           183891
      ***  If DDMMYY format, turn it around to MMDDYY format                                  183891
      *                                                                                       183891
     C     *IN98         IFEQ      '0'                                                        183891
     C                   MOVEL     ZDATE         ZZWRK             4 0                        183891
     C                   MOVE      ZZWRK         ZZWRKM                                       183891
     C                   MOVEL     ZZWRK         ZZWRKD                                       183891
     C                   Z-ADD     ZZWRKD        ZZWRK                                        183891
     C                   MOVEL     ZZWRKM        ZZWRK                                        183891
     C                   MOVEL     ZZWRK         ZDATE                                        183891
     C                   END                                                                  183891
      *                                                                                       183891
     C                   EXSR      ZDATE1                                                     183891
     C                   Z-ADD     ZDAYNO        ZZLCD                                        183891
     C                   Z-ADD     ZZLCD         ZZREAL                                       183891
      *                                                                                       183891
     C                   MOVE      'L'           NCI               1                          183891
     C                   CALL      'SE0045'                                                   183891
     C                   PARM                    SITP                                         183891
     C                   PARM                    ZECD                                         183891
     C                   PARM                    ITLD                                         183891
     C                   PARM                    FCPN                                         183891
     C                   PARM                    CD                                           183891
     C                   PARM                    CR                                           183891
     C                   PARM                    NMCY                                         183891
     C                   PARM                    ZZLCD                                        183891
     C                   PARM                    NCI                                          183891
     C                   PARM                    BCNV                                         183891
     C                   PARM                    MATY                                         183891
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
      *                                                                                       183891
      ***  Call ZDATE2 to obtain MMDD for the new Last Coupon Date                            183891
      *                                                                                       183891
     C                   Z-ADD     ZZLCD         ZDAYNO                                       183891
     C                   EXSR      ZDATE2                                                     183891
     C                   MOVEL     ZDATE         ZZNEW4            4 0                        183891
     C     *IN98         IFEQ      '0'                                                        183891
     C                   MOVEL     ZZNEW4        ZZWRKD                                       183891
     C                   MOVE      ZZNEW4        ZZWRKM                                       183891
     C                   Z-ADD     ZZWRKD        ZZNEW4                                       183891
     C                   MOVEL     ZZWRKM        ZZNEW4                                       183891
     C                   END                                                                  183891
     C*                                                                                       183891
     C                   Z-ADD     ZZREAL        ZZLCD                                        183891
     C*                                                                                       183891
     C     ZZECD4        IFGE      ZZNEW4                                                     183891
     C                   MOVE      '1'           ZFOUND                                       183891
     C                   GOTO      ZLCD00                                                     183891
     C                   END                                                                  183891
     C                   ELSE                                                                 183891
     C                   MOVE      '1'           ZFOUND
     C                   GOTO      ZLCD00
     C                   END                                                                  183891
     C                   END
     C                   END
     C                   SUB       1             X
     C                   END
      *
     C     ZLCD00        TAG                                                    ZLCD00 TAG
      *                                                                                CSE031 206316
      ***Restore*the*Last*Coupon*Date*(LCPN)                                           CSE031 206316
      *                                                                                CSE031 206316
     C*******************Z-ADD     UULCPN        LCPN                                  CSE031 206316
      *
      ***  If found, add the Control Date's YY to form Coupon Date
      *
     C     ZFOUND        IFEQ      '1'
     C                   Z-ADD     ZECDYR        ZDATE
     C                   MOVEL     CD(X)         ZDATE
      *
      *** Else if not found, find the Last Coupon of the previous year
      *
     C                   ELSE
     C                   Z-ADD     12            X
      *
     C     X             DOWGT     0
     C     CR(X)         IFEQ      'P'
     C     CR(X)         OREQ      'C'
      *                                                                   E21616
      ***  Check for the year 2000.                                       E21616
     C     ZECDYR        IFEQ      0                                                           E2161
     C                   Z-ADD     99            ZDATE                                         E2161
     C                   ELSE                                                                  E2161
     C                   Z-ADD     ZECDYR        ZDATE
     C                   SUB       1             ZDATE
     C                   END                                                                   E2161
      *                                                                   E21616
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
     C     ZECDYR        SUB       1             ZZYR                                          10022
     C     ZZYR          ADD       28            ZZYR                                          10022
     C     ZZYR          DIV       4             ZZYR                                          10022
     C                   MVR                     ZMVR              1 0                         10022
     C     ZMVR          IFGT      0                                                           10022
     C                   Z-ADD     X             TX                                            10022
     C                   MOVE      '28'          CD(X)                                         10022
     C                   END                                                                   10022
     C                   END                                                                   10022
     C*                                                                   100228
     C                   MOVEL     CD(X)         ZDATE
     C                   MOVE      '1'           ZFOUND
     C                   GOTO      ZLCD01
     C                   END
     C                   SUB       1             X
     C                   END
      *
     C     ZLCD01        TAG                                                    ZLCD01 TAG
     C                   END
      *
      ***  Convert the Coupon Date to Midas Day Number using ZDATE1
      ***  (Not done if no Rate/ Payment Indicators are P or C)
      ***  If DDMMYY format, turn it around to MMDDYY format
      *
     C     ZFOUND        IFEQ      '1'
      *
     C     *IN98         IFEQ      '0'
     C                   MOVEL     ZDATE         ZZWRK             4 0
     C                   MOVE      ZZWRK         ZZWRKM
     C                   MOVEL     ZZWRK         ZZWRKD
     C                   Z-ADD     ZZWRKD        ZZWRK
     C                   MOVEL     ZZWRKM        ZZWRK
     C                   MOVEL     ZZWRK         ZDATE
     C                   END
      *
     C                   EXSR      ZDATE1
     C                   Z-ADD     ZDAYNO        ZZLCD
     C                   END
      *                                                                                       CSE035
      ** Should check if rundate is prior to first coupon date of                             CSE035
      ** Security.  If so, use initial date as last coupon date.                              CSE035
      *                                                                                       CSE035
     C     ITLD          IFNE      *ZEROS                                                     CSE035
     C     ZECD          IFLE      ITLD                                                       CSE035
     C     ZECD          ORLT      FCPN                                                       CSE035
     C     ZECD          ANDGE     ITLD                                                       CSE035
     C                   Z-ADD     ITLD          ZZLCD                                        CSE035
     C                   ENDIF                                                                CSE035
     C                   ENDIF                                                                CSE035
      *                                                                                       CSE035
     C     CSE035        IFNE      'Y'                                                        CSE035
                                                                                              CSE035
      *                                                                                       206316
      ** If CSE031 is on, SE0045 will always return the Last Coupon                           206316
      ** Date as is on the file. Therefore, at this point, for                                206316
      ** Interest calculations, ZDAYNO is incorrect as it uses the                            206316
      ** Coupon array to calculate the Last Coupon Date. We need to                           206316
      ** Set ZDAYNO to LCPN if CSE031 is on.                                                  206316
      *                                                                                       206316
      ** Check if feature CSE031 is on                                                        206316
     C**********         CALLB     'AOSARDR0'                                        206316 MD034630
     C**********         PARM                    URTNCD            7                 206316 MD034630
     C**********         PARM      '*VERIFY'     UOPTN             7                 206316 MD034630
     C**********         PARM      'CSE031'      UUKEY             6                 206316 MD034630
     C**********         PARM                    UDSFDY           76                 206316 MD034630
      *                                                                                       CSE071
     C**********         MOVE      'N'           CSE031            1                 CSE071 MD034630
     C*****URTNCD        IFEQ      *BLANKS                                           CSE071 MD034630
     C**********         MOVE      'Y'           CSE031                              CSE071 MD034630
     C**********         ENDIF                                                       CSE071 MD034630
      *                                                                                       CSE071
      ** Check if feature CSE071 is on                                                        CSE071
     C**********         CALL      'AOSARDR0'                                        CSE071 MD034630
     C**********         PARM                    URTNCD                              CSE071 MD034630
     C**********         PARM      '*VERIFY'     UOPTN                               CSE071 MD034630
     C**********         PARM      'CSE071'      UUKEY                               CSE071 MD034630
     C**********         PARM                    UDSFDY                              CSE071 MD034630
      *                                                                                       CSE071
     C**********         MOVE      'N'           CSE071            1                 CSE071 MD034630
     C*****URTNCD        IFEQ      *BLANKS                                           CSE071 MD034630
     C**********         MOVE      'Y'           CSE071                              CSE071 MD034630
     C**********         ENDIF                                                       CSE071 MD034630
      *                                                                                       206316
      ** If CSE031 feature is on                                                              206316
      ** or CSE071 feature is on                                                              CSE071
     C**** URTNCD        IFEQ      *BLANKS                                              206316CSE071
     C     CSE031        IFEQ      'Y'                                                        CSE071
     C     CSE071        OREQ      'Y'                                                        CSE071
     C     BCNV          IFNE      ' '                                                        206316
     C     BCNV          ANDNE     'N'                                                        206316
     C     LCPN          ANDNE     *ZEROS                                                     206316
     C     LCPN          ANDGE     ZZLCD                                                    BUG11193
     C     LCPN          ANDLT     ZECD                                                     BUG11193
     C                   Z-ADD     LCPN          ZDAYNO                                       206316
     C                   Z-ADD     LCPN          ZZLCD                                        206316
     C                   ENDIF                                                                206316
     C                   ENDIF                                                                206316
      *
      ***  If the Initial Date on the Security record is not zero, then
      ***  If the resultant Prior Coupon Date is less than the Initial
      ***  Date or First Coupon, set Prior Coupon Date = Initial Date.
      *
     C     ITLD          IFNE      *ZEROS
      *
      ** Made conditioning changes to allow fix 149184.                   149184
      ** (First coupon date should be = initial date when rundate is      149184
      ** between initial and first coupon date.)                          149184
      *                                                                   149184
     C***********ZZLCD     IFLT ITLD                                      149184
     C***********ZZLCD     ORLT FCPN                                      079952
     C***********ZECD      ORLT FCPN                               079952 149184
     C     ZECD          IFLE      ITLD                                                       149184
     C     ZECD          ORLT      FCPN                                                       149184
     C     ZECD          ANDGE     ITLD                                                       149184
     C                   Z-ADD     ITLD          ZZLCD
     C*                                                                   149184
     C                   ELSE                                                                  09125
     C*                                                                   091254
     C*** IF Last coupon date is *LE 1st_Coupon_Date                      091254
     C***    and *GT initial date                                         091254
     C*                                                                   091254
     C     FCPN          IFNE      *ZEROS                                                      09125
     C     ZZLCD         ANDGT     ITLD                                                        09125
     C     ZZLCD         ANDLE     FCPN                                                        09125
     C                   Z-ADD     FCPN          ZZLCD                                         09125
     C                   ELSE                                                                  09125
     C     ZZLCD         SUB       FCPN          @DDIF             5 0                         09125
     C     @DDIF         IFLT      10                                                          09125
     C                   Z-ADD     FCPN          ZZLCD                                         09125
     C                   END                                                                   09125
     C                   END                                                                   09125
     C                   END
      *
      *** IF Event_Control_Date is *LE 1st_Coupon_Date                    072688
     C     FCPN          IFNE      *ZEROS                                                      07268
     C***********ECD       ANDLEFCPN                               072688 079952
     C     ZZLCD         ANDGT     ITLD                                                        07995
     C     ZZLCD         ANDLE     FCPN                                                        07995
     C                   Z-ADD     FCPN          ZZLCD                                         07268
     C                   END                                                                   07268
      *                                                                   072688
      ***  If the Initial Date on the Security record is zero, then if
      ***  the resultant Prior Coupon Date is less than the Issue Date
      ***  or First Coupon, set Prior Coupon Date = Issue Date.
      *
     C                   ELSE
      *
     C     ZZLCD         IFLT      ISSD
     C***********ZZLCD     ORLT FCPN                                      079952
     C     ZECD          ORLT      FCPN                                                        07995
     C                   Z-ADD     ISSD          ZZLCD
     C                   ELSE                                                                  09125
     C*                                                                   091254
     C*** IF Last Coupon Date is *LE 1st_Coupon_Date                      091254
     C***    and *GT issue date                                           091254
     C     FCPN          IFNE      *ZEROS                                                      09125
     C     ZZLCD         ANDGT     ISSD                                                        09125
     C     ZZLCD         ANDLE     FCPN                                                        09125
     C                   Z-ADD     FCPN          ZZLCD                                         09125
     C                   ELSE                                                                  09125
     C     ZZLCD         SUB       FCPN          @DDIF                                         09125
     C     @DDIF         IFLT      10                                                          09125
     C                   Z-ADD     FCPN          ZZLCD                                         09125
     C                   END                                                                   09125
     C                   END                                                                   09125
     C                   END
      *** IF Event_Control_Date is *LE 1st_Coupon_Date                    072688
     C     FCPN          IFNE      *ZEROS                                                      07268
     C***********ECD       ANDLEFCPN                               072688 079952
     C     ZZLCD         ANDGT     ISSD                                                        07995
     C     ZZLCD         ANDLE     FCPN                                                        07995
     C                   Z-ADD     FCPN          ZZLCD                                         07268
     C                   END                                                                   07268
      *                                                                   072688
      *
     C                   END
      *                                                                                       CSE035
     C                   ENDIF                                                                CSE035
      *                                                                                       CSE035
     C                   END
     C*                                                                   100228
     C**  Restore 29Feb to the array if it is changed.                    100228
     C*                                                                   100228
     C     TX            IFNE      0                                                           10022
     C                   MOVE      '29'          CD(TX)                                        10022
     C                   END                                                                   10022
      *
      ***  If the Date Format is DDMMYY, then return the Array
      ***  of Coupon Dates to it's former state of DDMM.
      *
     C     *IN98         IFEQ      '0'
     C                   DO        12            X                 2 0
     C                   MOVEL     CD(X)         ZZWRKM            2 0
     C                   MOVE      CD(X)         ZZWRKD            2 0
     C                   Z-ADD     ZZWRKM        CD(X)
     C                   MOVEL     ZZWRKD        CD(X)
     C                   END
     C                   END
      *                                                                                       168141
      * At this stage the field ZZLCD holds details of REAL LAST COUPON                       168141
      * DATE save this field into work field ZZREAL for use in SE2235.                        168141
      *                                                                                       168141
     C                   Z-ADD     ZZLCD         ZZREAL            5 0                        168141
      *
      ** If BCNV is not blank then call SE0045                                                CSE005
      ** OR BCNV is not 'N' then call SE0045                                                  CSE031
      **                                                                                      CSE005
     C     BCNV          IFNE      ' '                                                        CSE005
     C     BCNV          ANDNE     'N'                                                        CSE031
     C                   MOVE      'L'           NCI               1                          CSE005
     C                   CALL      'SE0045'                                                   CSE005
     C                   PARM                    SITP                                         CSE005
     C                   PARM                    ZECD                                         CSE005
     C                   PARM                    ITLD                                         CSE005
     C                   PARM                    FCPN                                         CSE005
     C                   PARM                    CD                                           CSE005
     C                   PARM                    CR                                           CSE005
     C                   PARM                    NMCY                                         CSE005
     C                   PARM                    ZZLCD                                        CSE005
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
     C                   ENDIF                                                                CSE005
      *                                                                                       CSE005
     C     EZLCD         ENDSR
      *
      *****************************************************************
      ** +--- The converted ZLCDZ1 ends here ----------------------------+
 
      /EJECT
      **********************************************************************
      *                                                                    *
      *  This subroutine is to cater for the fact that standard subroutine *
      *   ZLCD in this module executes another standard subroutine,        *
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
     C                   PARM                    ErrorFlag         1
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
      *                                                                    *
      *  This subroutine is to cater for the fact that standard subroutine *
      *   ZLCD in this module executes another standard subroutine,        *
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
 
      * Security details
     C                   PARM                    ISSD
     C                   PARM                    ITLD
     C                   PARM                    FCPN
     C                   PARM                    MATY
     C                   PARM                    CDArr
     C                   PARM                    CRArr
     C                   PARM                    LCPN                                       BUG11009
      *
      ** Event Control Date
      ** Date Format
     C                   PARM                    ZECD
     C                   PARM                    BJDFIN
 
      ** Nominal Currency                                                                     CSE005
      ** Security Investment Type                                                             CSE005
      ** Effect on Holidays on Coupon Dates                                                   CSE005
     C                   PARM                    NMCY              3                          CSE005
     C                   PARM                    SITP              3                          CSE005
     C                   PARM                    BCNV              1                          CSE005
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
                                                                                              CSE005
      * OUTPUTS
 
      ** Last Coupon Date before Control Date
     C                   PARM                    ZZLCD
 
     C                   CALLB     'AOSARDR0'                                                 CSE035
     C                   PARM      *BLANKS       @RTCD             7                          CSE035
     C                   PARM      '*VERIFY'     @OPTN             7                          CSE035
     C                   PARM      'CSE035'      @SARD             6                          CSE035
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE035
      *                                                                                       CSE035
     C     @RTCD         IFEQ      *BLANK                                                     CSE035
     C                   MOVEL     'Y'           CSE035            1                          CSE035
     C                   ELSE                                                                 CSE035
     C                   MOVEL     'N'           CSE035                                       CSE035
     C                   ENDIF                                                                CSE035
      *                                                                                     MD034630
     C     CSE035        IFNE      'Y'                                                      MD034630
      *                                                                                     MD034630
      ** Check if feature CSE031 is on                                                      MD034630
     C                   CALLB     'AOSARDR0'                                               MD034630
     C                   PARM                    URTNCD                                     MD034630
     C                   PARM      '*VERIFY'     UOPTN                                      MD034630
     C                   PARM      'CSE031'      UUKEY                                      MD034630
     C                   PARM                    UDSFDY                                     MD034630
      *                                                                                     MD034630
     C                   MOVE      'N'           CSE031                                     MD034630
     C     URTNCD        IFEQ      *BLANKS                                                  MD034630
     C                   MOVE      'Y'           CSE031                                     MD034630
     C                   ENDIF                                                              MD034630
      *                                                                                     MD034630
      ** Check if feature CSE071 is on                                                      MD034630
     C                   CALL      'AOSARDR0'                                               MD034630
     C                   PARM                    URTNCD                                     MD034630
     C                   PARM      '*VERIFY'     UOPTN                                      MD034630
     C                   PARM      'CSE071'      UUKEY                                      MD034630
     C                   PARM                    UDSFDY                                     MD034630
      *                                                                                     MD034630
     C                   MOVE      'N'           CSE071                                     MD034630
     C     URTNCD        IFEQ      *BLANKS                                                  MD034630
     C                   MOVE      'Y'           CSE071                                     MD034630
     C                   ENDIF                                                              MD034630
      *                                                                                     MD034630
     C                   ENDIF                                                              MD034630
      *                                                                                     MD034630
     C                   ENDSR
      *****************************************************************
