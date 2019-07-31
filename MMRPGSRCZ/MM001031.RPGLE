     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Interest Calculation Method 9 Processing')    *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MM001031 - Interest Calculation Method 9 Processing          *
      *                                                               *
      *  Function:  This program calculates interest when Interest    *
      *             Calculation Method is 9 - Actual/Actual (AFB)     *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CDL093  *CREATE    Date 15May14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL093 - MM Interest calculation type 9.                     *
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
      *
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      * Copy source for formatting dates for Feb29 checking
     D/COPY ZSRSRC,ZDATE9Z1LE
     D/COPY ZSRSRC,ZDATE9Z2LE
     D/COPY ZSRSRC,ZFEB29Z1LE
      *
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
 
      ** Map variable names to indicators to allow use of names instead
      ** of numbers; base the following data structure on a pointer to
      ** the indicator array.
     D Indicators      DS                  BASED(pIndicator)
 
      ** Set the indicator array pointer
     D pIndicator      S               *   INZ(%Addr(*In))
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Start date of period received as an input parameter
     D ZZBEG           S              5P 0
      ** End date of period received as an input parameter
     D ZZEND           S              5P 0
      ** Next Interest Payment date received as an input parameter
     D ZZNXT           S              5P 0
      ** Interest Calculation Method received as an input parameter
     D ZZCALC          S              1A
      ** Interest Payment Frequency received as an input parameter
     D ZZIPFQ          S              1A
      ** Principal amount received as an input parameter
     D ZZAMT           S             15P 0
      ** Interest Rate received as an input parameter
     D ZZRATE          S             11P 7
      ** Round Down Facility Indicator received as an input parameter
     D ZZRDFC          S              1A
      ** First/last day interest received as an input parameter
     D ZZFLID          S              1A
      ** First/last day interest received as an input parameter
     D ZZIPDM          S              2P 0
      ** Interest Pay Day in Month
     D @@INTR          S             15P 0
 
      ** Adjusted number of interest days
     D ZZINDY          S              5P 0
      *
     D WDATE9          DS             6
     D  WDD9                   1      2  0
     D  WMM9                   3      4  0
     D  WYY9                   5      6  0
 
      ** variables
     D ZZBEG9          S              5  0 INZ(*ZEROS)
     D ZZEND9          S              5  0 INZ(*ZEROS)
     D @@Rtn           S              1A
     D NxtFeb29        S              1A
     D NxtF29          S              1A
     D @@DAYN          S              5  0 INZ(*ZEROS)
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D* FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D*
 
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
 
      *  MM001031 - Calculate Interest for Method 9                   *
      *                                                               *
      *  CALLS MM001032 -  Calculate Interest                         *
      *                                                               *
      *  FIELDS INPUT ZZBEG  - Start date of period 5,0               *
      *               ZZEND  - End date of period 5,0                 *
      *               ZZNXT  - Next interest payment date 5,0         *
      *               ZZCALC - Interest calculation method  1A        *
      *               ZZAMT  - Principal amount  15,0                 *
      *               ZZRATE - Interest rate 11,7                     *
      *               ZZRDFC - Round down facility indicator 1A       *
      *               ZZFLID - First/last day interest 1A             *
      *                                                               *
      *  FIELDS OUTPUT @@INTR - Calculated Interest 15,0              *
      *                                                               *
      *                                                               *
      *****************************************************************
      *
      *
     C                   EVAL      NxtFeb29 = ' '
     C     CALC9_TAG     TAG
      * If interest calc method 9 and for a fixed term deal calculate interest
      * for each interest period separately, as when a Feb 29 exists this impacts
      * the days used in the interest calculation (366 for the interest period
      * over 29Feb and 365 for all other periods)
     C                   IF        NxtFeb29 = ' '
     C                   Z-ADD     ZZBEG         PIPD9             5 0
     C                   Z-ADD     ZZNXT         NIPD9             5 0
     C                   Z-ADD     0             @@INTR
     C                   ENDIF
      *
      * Check to see if a Feb29 in the first interest payment date, if not
      * process through all interest payment dates to find when Feb29 will
      * appear
     C                   EVAL      #29Feb = 'N'
     C                   Z-ADD     PIPD9         @@DAYN
     C                   EXSR      ZDATE9
     C                   Z-ADD     @@VDT         ZZStartDate
      *
     C                   Z-ADD     NIPD9         NIPD9P            5 0
      *
D1   C                   DOW       #29Feb <> 'Y'
      *
     C                   Z-ADD     NIPD9         @@DAYN
     C                   EXSR      ZDATE9
     C                   Z-ADD     @@VDT         ZZEndDate
 
     C                   EXSR      #FEB29
      *
B1   C                   IF        #29Feb = 'N'
      *
     C                   Z-ADD     NIPD9         ZDAYN
      * Calculate next interest payment date
      * First convert next interest payment date to DDMMYY format
     C                   CallB     'ZDATE2'
     C                   Parm                    ZDAYN             5 0
     C                   Parm      'D'           WDFMT9            1
     C                   Parm      *ZERO         ZDATE             6 0
     C                   Parm      *BLANK        ZADATE            7
     C                   Move      ZDATE         WDATE9
      *
      * When not processing the first interest repayment date, need to set
      * the day to be interest payment day number
     C     NIPD9         IFGT      ZZNXT
     C                   Z-ADD     ZZIPDM        WDD9
     C                   ENDIF
      *
      * Check to see if last day of the month
      * Need to check Interest Payment Day isn't higher than number of
      * days in month so ensure to set payment date to be correct for
      * the month
     C                   MOVE      'N'           WEOM9             1
     C                   SELECT
     C                   WHEN      WMM9 = 01 OR WMM9 = 03 OR
     C                             WMM9 = 05 OR WMM9 = 07 OR
     C                             WMM9 = 08 OR WMM9 = 10 OR
     C                             WMM9 = 12
B2   C                   IF        WDD9 = 31
     C                   EVAL      WEOM9 = 'Y'
E2   C                   ENDIF
     C                   WHEN      WMM9 = 04 OR WMM9 = 06 OR
     C                             WMM9 = 09 OR WMM9 = 11
B2   C*****              IF        WDD9 = 30
B2   C                   IF        WDD9 >= 30
     C                   EVAL      WDD9 = 30
     C                   EVAL      WEOM9 = 'Y'
E2   C                   ENDIF
     C                   WHEN      WMM9 = 02
     C     WYY9          DIV       4             WLeapYr2
     C                   MVR                     WLeapYr1
B2   C                   IF        (WLeapYr1 = 0 AND
     C****                         WDD9 = 29)
     C                             WDD9 >= 29)
     C                             OR (WLeapYr1 <> 0 AND
     C****                         WDD9 = 28)
     C                             WDD9 >= 28)
B2   C                   IF        WLeapYr1 = 0
     C                   EVAL      WDD9 = 29
     C                   ELSE
     C                   EVAL      WDD9 = 28
     C                   ENDIF
     C                   EVAL      WEOM9 = 'Y'
E2   C                   ENDIF
      *
     C                   ENDSL
 
      * Increment month and year based on interest payment frequency
     C                   SELECT
     C                   WHEN      ZZIPFQ = 'N'
     C                   EVAL      WMM9 = WMM9 + 1
     C                   WHEN      ZZIPFQ = 'M'
     C                   EVAL      WMM9 = WMM9 + 1
     C                   WHEN      ZZIPFQ = 'Q'
     C                   EVAL      WMM9 = WMM9 + 3
     C                   WHEN      ZZIPFQ = 'X'
     C                   EVAL      WMM9 = WMM9 + 6
     C                   WHEN      ZZIPFQ = 'Y'
     C                   EVAL      WYY9 = WYY9 + 1
     C                   ENDSL
      *
B2   C                   IF        WMM9 > 12
     C                   EVAL      WMM9 = WMM9 - 12
     C                   EVAL      WYY9 = WYY9 + 1
E2   C                   ENDIF
 
      * If interest payment set to last day of the month, re-set
      * according to number of days in new month
B2   C                   IF        WEOM9 = 'Y'
     C                   SELECT
     C                   WHEN      WMM9 = 01 OR WMM9 = 03 OR
     C                             WMM9 = 05 OR WMM9 = 07 OR
     C                             WMM9 = 08 OR WMM9 = 10 OR
     C                             WMM9 = 12
     C                   EVAL      WDD9 = 31
     C                   WHEN      WMM9 = 04 OR WMM9 = 06 OR
     C                             WMM9 = 09 OR WMM9 = 11
     C                   EVAL      WDD9 = 30
     C                   WHEN      WMM9 = 02
     C     WYY9          DIV       4             WLeapYr2          2 0
     C                   MVR                     WLeapYr1          1 0
B3   C                   IF        WLeapYr1 = 0
     C                   EVAL      WDD9 = 29
     C                   ELSE
     C                   EVAL      WDD9 = 28
E3   C                   ENDIF
      *
     C                   ENDSL
E2   C                   ENDIF
      *
      * Save previous next interest date value
     C                   Z-ADD     NIPD9         NIPD9P            5 0
      *
      * Convert Next Interest Payment Date from DDMMYY format to Midas run day
     C                   MOVE      WDATE9        DateIn
     C                   CALLB     'ZDATE1'
     C                   PARM                    DateIn            6
     C                   PARM                    DayNoOut          5 0
     C                   Parm      'D'           WDFMT9            1
     C                   PARM                    ErrorFound        1
     C                   Z-ADD     DayNoOut      NIPD9
E1   C                   ENDIF
      *
      * Check if next interest date calculated is non-working day
     C                   EXSR      SRNWDCHK
      *
     C                   ENDDO
 
     C                   Z-ADD     NIPD9P        NIPD9
     C                   Z-ADD     PIPD9         PSTART
     C                   Z-ADD     NIPD9         PEND
     C     PIPD9         DOWLT     ZZEND
     C                   CALLB     'MM001032'
     C                   PARM                    PSTART            5 0
     C                   PARM                    PEND              5 0
     C                   PARM                    ZZCALC
     C                   PARM                    ZZAMT
     C                   PARM                    ZZRATE
     C                   PARM      'N'           W@RDFC            1
     C                   PARM      *ZEROS        W@INTR           15 0
     C                   ADD       W@INTR        @@INTR
     C*
      * Set up start of next interest period
     C                   Z-ADD     NIPD9         PIPD9
      *
      * Calculate next interest payment date
      * First convert next interest payment date to DDMMYY format
     C                   CallB     'ZDATE2'
     C                   Parm      NIPD9         ZDAYN             5 0
     C                   Parm      'D'           WDFMT9            1
     C                   Parm      *ZERO         ZDATE             6 0
     C                   Parm      *BLANK        ZADATE            7
     C                   Move      ZDATE         WDATE9
      *
      * Set the day to be interest payment day number
     C                   Z-ADD     ZZIPDM        WDD9
      *
      * Check to see if last day of the month
      * Need to check Interest Payment Day isn't higher than number of
      * days in month so ensure to set payment date to be correct for
      * the month
     C                   MOVE      'N'           WEOM9             1
     C                   MOVE      'N'           WEFEB             1
     C                   SELECT
     C                   WHEN      WMM9 = 01 OR WMM9 = 03 OR
     C                             WMM9 = 05 OR WMM9 = 07 OR
     C                             WMM9 = 08 OR WMM9 = 10 OR
     C                             WMM9 = 12
     C                   IF        WDD9 = 31
     C                   EVAL      WEOM9 = 'Y'
     C                   ENDIF
     C                   WHEN      WMM9 = 04 OR WMM9 = 06 OR
     C                             WMM9 = 09 OR WMM9 = 11
B2   C*****              IF        WDD9 = 30
B2   C                   IF        WDD9 >= 30
     C                   EVAL      WEOM9 = 'Y'
     C                   ENDIF
     C                   WHEN      WMM9 = 02
     C     WYY9          DIV       4             WLeapYr2
     C                   MVR                     WLeapYr1
     C                   IF        (WLeapYr1 = 0 AND
     C****                         WDD9 = 29)
     C                             WDD9 >= 29)
     C                             OR (WLeapYr1 <> 0 AND
     C****                         WDD9 = 28)
     C                             WDD9 >= 28)
B2   C                   IF        WLeapYr1 = 0
     C                   EVAL      WDD9 = 29
     C                   ELSE
     C                   EVAL      WDD9 = 28
     C                   ENDIF
     C                   EVAL      WEOM9 = 'Y'
     C                   EVAL      WEFEB = 'Y'
     C                   ENDIF
      *
     C                   ENDSL
 
      * Increment month and year based on interest payment frequency
     C                   SELECT
     C                   WHEN      ZZIPFQ = 'N'
     C                   EVAL      WMM9 = WMM9 + 1
     C                   WHEN      ZZIPFQ = 'M'
     C                   EVAL      WMM9 = WMM9 + 1
     C                   WHEN      ZZIPFQ = 'Q'
     C                   EVAL      WMM9 = WMM9 + 3
     C                   WHEN      ZZIPFQ = 'X'
     C                   EVAL      WMM9 = WMM9 + 6
     C                   WHEN      ZZIPFQ = 'Y'
     C                   EVAL      WYY9 = WYY9 + 1
     C                   ENDSL
      *
     C                   IF        WMM9 > 12
     C                   EVAL      WMM9 = WMM9 - 12
     C                   EVAL      WYY9 = WYY9 + 1
     C                   ENDIF
 
      * If interest payment set to last day of the month, re-set
      * according to number of days in new month
     C                   IF        WEOM9 = 'Y'
     C                   SELECT
     C                   WHEN      WMM9 = 01 OR WMM9 = 03 OR
     C                             WMM9 = 05 OR WMM9 = 07 OR
     C                             WMM9 = 08 OR WMM9 = 10 OR
     C                             WMM9 = 12
     C                   EVAL      WDD9 = 31
     C                   WHEN      WMM9 = 04 OR WMM9 = 06 OR
     C                             WMM9 = 09 OR WMM9 = 11
     C                   EVAL      WDD9 = 30
     C                   WHEN      WMM9 = 02
     C     WYY9          DIV       4             WLeapYr2          2 0
     C                   MVR                     WLeapYr1          1 0
     C                   IF        WLeapYr1 = 0
     C                   EVAL      WDD9 = 29
     C                   ELSE
     C                   EVAL      WDD9 = 28
     C                   ENDIF
      *
     C                   ENDSL
     C                   ENDIF
      *
      * Convert Next Interest Payment Date from DDMMYY format to Midas run day
     C                   MOVE      WDATE9        DateIn
     C                   CALLB     'ZDATE1'
     C                   PARM                    DateIn            6
     C                   PARM                    DayNoOut          5 0
     C                   Parm      'D'           WDFMT9
     C                   PARM                    ErrorFound        1
     C                   Z-ADD     DayNoOut      NIPD9
      *
      * Check if next interest date calculated is non-working day
     C                   EXSR      SRNWDCHK
      *
      * Check if there is still a Feb 29 between current start of period date
      * (+1 to ensure Feb 29 is not counted twice if interest paid at end of
      * month) to maturity
     C                   Z-ADD     PIPD9         @@DAYN
     C                   IF        WEFEB = 'Y'
     C                   ADD       1             @@DAYN
     C                   ENDIF
     C                   EXSR      ZDATE9
     C                   Z-ADD     @@VDT         ZZStartDate
      *
     C                   Z-ADD     ZZEND         @@DAYN
     C                   EXSR      ZDATE9
     C                   Z-ADD     @@VDT         ZZEndDate
 
     C                   EXSR      #FEB29
 
      * If Next Interest Payment Date GT maturity date, re-set to Maturity Date
      * or if no Feb29 within the remaining period set to Maturity Date
     C                   IF        NIPD9 > ZZEND
     C                             OR #29Feb <> 'Y'
     C                   EVAL      NIPD9 = ZZEND
      *
      * If first and last day interest flag is Y add 1 to maturity date
     C                   IF        ZZFLID = 'Y'
     C                   EVAL      NIPD9 = NIPD9 + 1
     C                   ENDIF
     C                   ENDIF
      *
      * If processed end of feb   interest payments, add 1 to start and end
      * of period dates to ensure Feb29 is not considered in 2 payments by
      * MM001032
     C                   IF        WEFEB = 'Y'
     C                   EVAL      PEND = NIPD9 +1
     C                   EVAL      PSTART = PIPD9 + 1
     C                   ELSE
     C                   EVAL      PEND = NIPD9
     C                   EVAL      PSTART = PIPD9
     C                   ENDIF
      *
      * If there is another 29Feb between now and Maturity Date, perform
      * all the same processing again (i.e. calculate interest from this
      * period up to and including the period before the 29th Feb period
     C                   IF        #29Feb = 'Y'
     C                   MOVE      'Y'           NxtFeb29
     C                   GOTO      CALC9_TAG
     C                   ENDIF
      *
      * If there is another 29Feb between now and Maturity Date, perform
      * all the same processing again (i.e. calculate interest from this
      * period up to and including the period before the 29th Feb period
     C                   IF        #29FEB = 'Y'
     C                   EVAL      NXTF29 = 'Y'
     C                   GOTO      CALC9_TAG
     C                   ENDIF
      *
     C                   ENDDO
      *
     C     ZZRDFC        IFEQ      'Y'
     C     @@INTR        DIV       100           @@INTR
     C                   ELSE
     C     @@INTR        DIV(H)    100           @@INTR
     C                   END
      *
     C                   SETON                                        LR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRNWDCHK - Non-working day check                              *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRNWDCHK      BEGSR
      *
     C                   CALLB     'ZCHKH'
     C                   PARM                    NIPD9
     C                   PARM                    BJLCCY
     C                   PARM      *BLANKS       BJSLCD
     C                   PARM      *BLANKS       HolInd            1
      *
      * If Holiday, get next working day
     C                   IF        HolInd = 'X'
     C                   Z-ADD     1             DAYFWD
     C                   CALL      'ZFWDT'
     C                   PARM                    NIPD9
     C                   PARM                    DAYFWD            2 0
     C                   PARM                    NXTWDAY           5 0
     C                   PARM                    BJLCCY
     C                   PARM                    BJSLCD
      *
     C                   Z-ADD     NXTWDAY       NIPD9
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *entry        PLIST
     C                   PARM                    ZZBEG
     C                   PARM                    ZZEND
     C                   PARM                    ZZNXT
     C                   PARM                    ZZCALC
     C                   PARM                    ZZIPFQ
     C                   PARM                    ZZAMT
     C                   PARM                    ZZRATE
     C                   PARM                    ZZRDFC
     C                   PARM                    ZZFLID
     C                   PARM                    ZZIPDM
     C                   PARM                    @@INTR
      *
      ** Access Bank details via access program
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * If interest day in month is 0 and interest frequency is not 'N'
      * end program
     C                   IF        ZZIPDM = 0
     C                             AND ZZIPFQ <> 'N'
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
 
      * It is assumed that this program is being called when Feb29
      * is found withing the date range of the deal
     C                   MOVE      'Y'           #29FEB
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *
     C/COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR                                                  *** InzEnd ***
      *
      *****************************************************************
      * Other subroutines contained in a Copy source
      *****************************************************************
     C/COPY ZSRSRC,ZFEB29Z2LE
     C/COPY ZSRSRC,ZDATE9Z3LE
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2014
     X/COPY ZSRSRC,ZDATE9Z4
