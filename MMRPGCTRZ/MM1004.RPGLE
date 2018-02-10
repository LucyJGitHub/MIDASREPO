     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Calculate the next interest payment date')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MM1004 - Calculate next interest payment date                *
      *                                                               *
      *  Function:  This module calculates the next interest payment  *
      *             date, given start and maturity dates, the payment *
      *             day in the month, and the frequency.              *
      *             It is a converted version of the subroutine       *
      *             MM1004, which was hard coded in MM0026, MM0027    *
      *             and MM0028 (at least).                            *
      *                                                               *
      *  Component of:
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
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 01Aug97               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP002 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
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
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
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
 
      **  DATA STRUCTURE FOR SR. MM1004 - MANIPULATE DATE INPUT
     D @@WKDS          DS
     D  @@WKDT                 1      8  0
     D  @@WKYY                 1      4  0
     D  @@WKY                  3      4  0
     D  @@WKM                  5      6  0
     D  @@WKD                  7      8  0
 
      **  ARRAY FOR SR. MM1004 - DAYS IN A MONTH (COMPILE TIME ARRAY)
     D @M              S              2  0 DIM(12) CTDATA PERRCD(12)
 
      ** External DS for NOSTRO Details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
 
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Return code for ZDATE9
     D @@RTN           S              1A
 
      ** Returned date for ZDATE9
     D @@VDT           S              8S 0
 
      ** Holiday indicator from ZCHKH
     D ZIND            S              1A
 
      ** Location code for ZCHKH
     D ZLOC            S              3A
 
      ** Nostro location (2,0P, received from caller)
     D @@RSTM          S              2P 0
 
      ** Receipt - our nostro (2A, received from caller)
     D @@RONS          S              2A
 
      ** Work date field
     D @@DNO           S              5P 0
     D @KEYC           S             10A                                                      CGL029
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C********************************************************************
     C*
     C* MM1004 - CALCULATE THE NEXT INTEREST PAYMENT DATE
     C*
     C* CALLED BY :
     C*
     C* CALLS :  ZA0830, A COMMON ROUTINE TO DETERMINE WHETHER A DATE
     C*          IS A WORKING DAY OR A HOLIDAY.
     C*       :  ZDAT10, A COMMON ROUTINE TO CONVERT DATE IN YYYYMMDD     056095
     C*          FORMAT TO MIDAS DAY NUMBER.
     C*       :  ZDATE9, A COMMON ROUTINE TO CONVERT MIDAS DAY NUMBER     056095
     C*          TO DATE FORMAT OF YYYYMMDD.
     C*
     C* INPUT  : @@STRT START DATE                           (8N)
     C*          @@FREQ PAYMENT FREQUENCY                    (1A)
     C*          @@CCY  CURRENCY CODE                        (3A)
     C*          @@MDAY INTEREST PAYMENT DAY IN THE MONTH    (2N)
     C*          @@MDAT MATURITY DATE                        (8N)
     C*
     C* OUTPUT : @@NDAT NEXT PAYMENT DATE (MIDAS DAY NUMBER) (8N)
     C*
     C* USES :
     C*          ZZMDNO MIDAS DAY NUMBER FROM    SR ZDAT10   (5N)         056095
     C*          @@MNO  DAY NUMBER PASSED TO     SR ZA0830   (5N)
     C*          @@HIND HOLIDAY/WORKING DAY IND. SR ZA0830   (1A)
     C*          @@DAYN DAY NUMBER PASSED TO     SR ZDATE9   (5N)         056095
     C*          @@VDT  DATE IN FORMAT YYYYMMDD  SR ZDATE9   (8N)         056095
     C*          @@DNO  WORK FIELD - DAY NUMBER              (5N)
     C*          @@CCY  CURRENCY CODE                        (3A)
     C*          @@WF16 WORK FIELD - # DAYS IN THE MONTH     (2N)
     C*          @@HWIN WORK FIELD - HOLIDAY/WORK INDICATOR  (1A)
     C*          @@WKDT WORK FIELDS DS TO MANIPULATE DATE    (8N)
     C*          @@WKYY WORK FIELDS DS  - YEAR FIELD YYYY    (4N)
     C*          @@WKY  WORK FIELDS DS  - YEAR FIELD   YY    (2N)
     C*          @@WKM  WORK FIELDS DS  - MONTH FIELD        (2N)
     C*          @@WKD  WORK FIELDS DS  - DAY FIELD          (2N)
     C*          @@WKD2 WORK FIELDS - MAXIMUM DAYS IN MONTH  (2N)
     C*          @@REM2 LEAP YEAR CALCS - REMAINDER FIELD    (3N)
     C*
     C********************************************************************
 
     C** Re-set the indicators used within this subroutine.
     C                   MOVE      '0'           *IN80
     C                   MOVE      '0'           *IN82
     C*
     C** Move the start date input into a working fields DS.
     C                   MOVE      @@STRT        @@WKDS
     C*
     C** IF     the interest payment day in month is blank
     C**        THEN     substitue day from start date into that field.
     C** END
     C*
     C     @@MDAY        IFEQ      0                                            B1
     C                   Z-ADD     @@WKD         @@MDAY            2 0          *1
     C                   END                                                    E1
     C*
     C** IF     the payment frequency is blank
     C**        THEN next interest date is set to maturity date
     C** END
     C*
     C     @@FREQ        IFEQ      *BLANK                                       B1
     C                   Z-ADD     @@MDAT        @@NDAT                         *1
     C                   GOTO      M10049                                       *1
     C                   END                                                    E1
     C*
     C** IF     the payment frequency is monthly
     C**        THEN     increment the month by 1.
     C** END
     C     @@FREQ        IFEQ      'M'                                          B1
     C                   ADD       1             @@WKM                          *1
     C                   END                                                    E1
     C*
     C** IF     the payment frequency is quarterly.
     C**        THEN     increment the month by 3.
     C** END
     C     @@FREQ        IFEQ      'Q'                                          B1
     C                   ADD       3             @@WKM                          *1
     C                   END                                                    E1
     C*
     C** IF     the payment frequency is six-monthly
     C**        THEN     increment the month by 6.
     C** END
     C     @@FREQ        IFEQ      'X'                                          B1
     C                   ADD       6             @@WKM                          *1
     C                   END                                                    E1
     C*
     C** IF     the payment frequency is yearly
     C**        THEN     increment the year by 1.
     C** END
     C     @@FREQ        IFEQ      'Y'                                          B1
     C                   ADD       1             @@WKYY                         *1
     C                   END                                                    E1
     C*
     C** Substitute day in month into the day field.
     C*
     C                   Z-ADD     @@MDAY        @@WKD
     C*
     C** IF     the new month now exceeds 12
     C**        THEN     subtract 12 from the month
     C**                 increment the year by 1
     C** END
     C*
     C     @@WKM         IFGT      12                                           B1
     C     @@WKM         SUB       12            @@WKM                          *1
     C                   ADD       1             @@WKYY                         *1
     C                   END                                                    E1
     C*
     C** IF     the days now exceed the number of days for that month
     C**        THEN     substitue the maximum # of days to that field
     C**              IF     leap year and month is February
     C**                     THEN     add an extra day to the day field
     C**              END
     C** END
     C*
     C                   MOVE      @M(@@WKM)     @@WKD2            2 0    80
     C     @@WKD         IFGT      @@WKD2                                       E1
     C                   Z-ADD     @@WKD2        @@WKD                          *1
     C*
     C** Test for leap year, and turn of century leap year.
     C** NB: only every 400 years is a leap year.
     C     @@WKY         IFEQ      0                                            B*2
     C     @@WKYY        DIV       400           @@WF16            3 0          **2
     C                   MVR                     @@REM2            3 0    82    **2
     C                   ELSE                                                   X*2
     C     @@WKYY        DIV       4             @@WF16                         **2
     C                   MVR                     @@REM2                   82    **2
     C                   END                                                    E*2
     C*
     C     *IN82         IFEQ      '1'                                          B*2
     C     @@WKM         IFEQ      2                                            B**3
     C                   ADD       1             @@WKD                          ***3
     C                   END                                                    E**3
     C                   END                                                    E*2
     C*
     C                   END                                                    E1
     C*
     C** Convert payment date to midas format.
 
     C                   CALLB     'ZDATE10'                                                   05609
     C                   PARM                    @@WKDT
     C                   PARM                    @@DNO
 
     C*  Set up location used by ZCHKH - if Our Receive Settlement        S01195
     C*  Method is a nostro then use nostro code and currency to find     S01195
     C*  Nostro Location                                                  S01195
     C     @@RSTM        IFEQ      01                                           B1             S0119
     C     @@RSTM        OREQ      02                                           B1             S0119
     C     @@RSTM        OREQ      07                                           B1             S0119
     C     @@RSTM        OREQ      08                                           B1             S0119
     C     @@RSTM        OREQ      12                                           B1             S0119
     C*                                                                   S01195
     C*                                                                   S01195
      ***Set up key to chain to Nostro file for Nostro Location           S01195
      *  (database error handling done in access program)                 S01194
     C                   CALL      'AONOSTR0'                                   *1             S0119
     C                   PARM      '*DBERR '     @RTCD             7            *1             S0119
     C                   PARM      '*KEY   '     @OPTN             7            *1             S0119
     C                   PARM      *BLANKS       @KEYA             6            *1             S0119
     C                   PARM      @@CCY         @KEYB             3            *1             S0119
     C**********         PARM      *BLANKS       @KEYC             4            *1      S0119 CGL029
     C                   PARM      *BLANKS       @KEYC                                        CGL029
     C                   PARM      *BLANKS       @KEYD             2            *1             S0119
     C                   PARM      @@RONS        @KEYE             2            *1             S0119
     C                   PARM      *BLANKS       @BRCD             3                           S0119
     C                   PARM      *BLANKS       @CSSN            10                           S0119
     C                   PARM      *BLANKS       @PNOI             1                           S0119
     C     SDNOST        PARM      SDNOST        DSFDY                          *1             S0119
     C*                                                                   S01194
     C                   MOVE      A7NOSN        ZLOC                           *1             S0119
     C*                                                                   S01195
     C                   ELSE                                                   X1             S0119
     C                   MOVE      *BLANKS       ZLOC                           *1             S0119
     C                   END                                                    E1             S0119
     C*                                                                   S01195
     C** DOWHILE     payment date is NOT a valid woking day
     C**             increment the day number
     C** WEND
     C*
     C     @@HWIN        DOUEQ     'W'                                          B1
 
     C                   CALLB     'ZCHKH'
     C                   PARM                    @@DNO
     C                   PARM                    @@CCY
     C                   PARM                    ZLOC
     C                   PARM                    ZIND
 
     C                   MOVE      ZIND          @@HWIN            1            *1             S0119
     C     @@HWIN        IFNE      'W'                                          B*2
     C                   ADD       1             @@DNO                          **2
     C                   END                                                    E**2
     C                   END                                                    E1
     C*
     C** Convert payment day number back to YYYYMMDD format.
     C*
     C                   Z-ADD     @@DNO         @@DAYN            5 0
 
     C                   CALLB     'ZDATE9'
     C                   PARM                    @@DAYN
     C                   PARM                    @@VDT
     C                   PARM                    @@RTN
 
     C                   Z-ADD     @@VDT         @@NDAT            8 0
     C                   GOTO      M10049
     C*
     C**  Unexecuted code to define fields
     C                   MOVEL     @@FREQ        @@FREQ            1
     C                   MOVEL     @@STRT        @@STRT            8 0
     C                   MOVEL     @@MDAT        @@MDAT            8 0
     C                   MOVEL     @@CCY         @@CCY             3
 
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
     C     M10049        TAG                                                    *** M10049 ***
 
     C                   RETURN
 
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
 
     C     *entry        PLIST
      ** Incoming return code (10A, returned to caller)
     C                   PARM                    RetCodeIn
      ** Next payment date (8,0P, returned to caller)
     C                   PARM                    @@NDAT
      ** Start date (8,0P, from caller)
     C                   PARM                    @@STRT
      ** Payment frequency (1A, from caller)
     C                   PARM                    @@FREQ
      ** Currency (3A, from caller)
     C                   PARM                    @@CCY
      ** Interest payment day in the month (2,0P from caller)
     C                   PARM                    @@MDAY
      ** Maturity date (8,0P, from caller)
     C                   PARM                    @@MDAT
      ** Nostro location (2,0P, from caller)
     C                   PARM                    @@RSTM
      ** Receipt - our nostro (2A, from caller)
     C                   PARM                    @@RONS
 
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
** @M  USED BY SR. MM1004 - DAYS IN A MONTH
312831303130313130313031
