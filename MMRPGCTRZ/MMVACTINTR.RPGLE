     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate Actual Interest Rate')               *
      *****************************************************************
      *                                                               *
      *  Midas - Common Validation Routine                            *
      *                                                               *
      *  MMVACTINTR - Validate Actual Interest Rate                   *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             Actual Interest Rate and confirms if it is valid. *
      *             If it is valid the 10A return code will be blank; *
      *             if it is not it will contain 'Error'.             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD023416           Date 16Nov13               *
      *  Prev Amend No. MD023121           Date 05Nov13               *
      *                 AR891660           Date 12Jan12               *
      *                 AR876535           Date 12Dec11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 247452             Date 12Jul07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 BUG5169            Date 04Oct06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG9166            Date 05Dec05               *
      *                 BUG10809           Date 10Mar06               *
      *                 BUG4837            Date 26Oct04               *
      *                 CDL020  *CREATE    Date 03Feb04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD023416 - Calculated actual interest is incorrect for deal  *
      *             with base rate and spread                         *
      *  MD023121 - Actual interest rate inputted is not picked up    *
      *             and used by the system                            *
      *  AR891660 - Actual interest rate fails on amend               *
      *  AR876535 - Error in Actual Interest Rate as affected by Base *
      *             Rate and rounding details                         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  247452 - Incorrect total interest calculated.                *
      *  BUG5169- Get correct base rate at Value Date. (CDL020)       *
      *  BUG9166- Use the correct work field for the signed value.    *
      *           (Similar to BUG10809)                               *
      *  BUG10809 - Negative sign of Actual Interest Rate suppressed  *
      *  BUG4837- Change actual interest rate to display only because *
      *           CDL020 is totally flawed.                           *
      *  CDL020 - Apply Base Rate at Value Date                       *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +----------------------------+
      ** ¦ Manually Included F-Specs  ¦
      ** ¦ =========================  ¦
      ** +----------------------------+
      **
      ** +-----------------------------------+
      ** ¦ End of Manually Included F-Specs  ¦
      ** ¦ ================================  ¦
      ** +-----------------------------------+
      **
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
 
      ** Program, procedure and module names for parameters
      ** ==================================================
 
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
 
     D INFDS           DS
      **  Data structure for file status of MM deals file.
 
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)
      ** External DS for Base Rate details
 
     D SDBSHS        E DS                  EXTNAME(SDBSHSPD)
      ** External DS for Historic Base Rate details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** External data structure for access programs (short)
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** External data structure for access programs (long)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Error message code 1 received as a parameter
     D Msgid1          S                   LIKE(#MSGID)
 
      ** Interest Rate/Spread received as a parameter
     D DDAIR           S             12A
 
      ** Analytical Accounting Installed Indicator (from SDMMODPD)
      ** received as a parameter
     D BGN0ST          S              1A
 
      ** Decimal separator from SDDEALPD received as a parameter
     D BNDCSP          S              1A
 
      ** Currency received as a parameter
     D DDCCY           S              3A
 
      ** Base Rate received as a parameter
     D DDBSRC          S              2A
 
      ** Value Date received as a parameter
     D ValDate         S              5  0
 
      ** Run Date received as a parameter
     D BJRDNB          S              5  0
 
      ** Interest Rate/Spread received as a parameter
     D IKSPRD          S             11  7
 
      ** Interest Rate returned to caller
     D IKINTR          S             11  7
 
      ** Fields used in call to Module ZA0840
 
      ** Alpha field for numeric validation
     D @@ALPH          S             16A
      ** Millions/Thousands id (Y=function on)
     D @@MTID          S              1A
      ** Amount calculation field
     D @@AMT           S             15  0
      ** Error code
     D @@ERCD          S              1  0
      ** Number of decimal places
     D @@IDP           S              3  0
      ** Number of integers
     D @@IINT          S              3  0
 
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
 
      ** Reset the error flag to prevent problems on subsequent calls
     C                   RESET                   ErrorFound
     C                   RESET                   Msgid1
      *
      *  *-------------------------------*
      *  * Validate Actual Interest Rate *
      *  *-------------------------------*
      *
     C*****DDBSRC        IFNE      *BLANKS                                           BUG4837 BUG5169
     C**********         Z-ADD     0             PAmtIn                              BUG4837 BUG5169
     C**********         MOVE      IKINTR        PAmtIn                              BUG4837 BUG5169
     C**********         Z-ADD     7             PNoOfDecPl                          BUG4837 BUG5169
     C**********         CALLB     'ZA0921'                                          BUG4837 BUG5169
     C**********         PARM      *BLANK        RetCodeIn                           BUG4837 BUG5169
     C**********         PARM                    PAmtIn           15 0               BUG4837 BUG5169
     C**********         PARM                    PNoOfDecPl        1 0               BUG4837 BUG5169
     C**********         PARM                    BNDCSP                              BUG4837 BUG5169
     C**********         PARM      *BLANK        PAmtOutS         16                 BUG4837 BUG5169
     C**********         PARM      *BLANK        PAmtOutU         17                 BUG4837 BUG5169
     C**********         MOVE      PAmtOutS      DDAIR                              BUG4837 BUG10809
     C**********         MOVE      PAmtOutU      DDAIR                              BUG10809 BUG5169
     C**********         ELSE                                                        BUG4837 BUG5169
     C**********         MOVE      *BLANK        DDAIR                               BUG4837 BUG5169
     C**********         ENDIF                                                       BUG4837 BUG5169
      **********                                                                     BUG4837 BUG5169
     C**********         GOTO      BYPASS                                            BUG4837 BUG5169
 
      ** Save Input field DDAIR to work field                                                BUG5169
                                                                                             BUG5169
     C                   MOVEL     *BLANKS       WWAIR                                      MD023416
     C     DDAIR         IFNE      *BLANKS                                                  MD023416
     C                   MOVEL     DDAIR         WWAIR            12                         BUG5169
     C                   ENDIF                                                              MD023416
      *                                                                                     MD023416
     C                   Z-ADD     *ZEROS        WkBaseRate       11 7                       BUG5169
     C                   MOVE      *BLANKS       @RETURN                                     BUG5169
                                                                                             BUG5169
      ** Actual Interest Rate can not be amended if Base Rate Code is blank
      ** Actual Interest Rate must be blank if Base Rate Code is blank                       BUG5169
 
     C     DDBSRC        IFEQ      *BLANKS
 
     C     DDAIR         IFNE      *BLANKS
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0352'     Msgid1
     C                   ENDIF
 
      ** Actual Interest Rate is only valid if Base Rate Code entered
     C                   ELSE
 
      ***If*Actual*Interest*Rate*is*Blank,*then*default*base*rate******                      BUG5169
      **********                                                                             BUG5169
     C*****DDAIR         IFEQ      *BLANKS                                                   BUG5169
 
      ** Access Current Base Rate
 
     C                   CALL      'AOBSRTR0'
     C                   PARM      *BLANKS       @RETURN           7
     C                   PARM      '*KEY   '     @OPTION           7
     C                   PARM      DDCCY         @CURRCY           3
     C                   PARM      DDBSRC        @ALPHBSRC         2
     C     SDBSRT        PARM      SDBSRT        DSSDY
 
      ** Get Historic Base Rate or Current Base Rate depending on
      ** Value Date of the Deal
 
     C     @RETURN       IFEQ      *BLANKS                                                   BUG5169
                                                                                             BUG5169
     C     ValDate       IFGE      BAVDRC
     C     ValDate       ORGE      BAVDNR                                                    BUG5169
 
      ** Determine actual base rate
 
     C     ValDate       IFLT      BAVDNR
     C                   Z-ADD     BACBSR        WkBaseRate       11 7
     C                   ELSE
     C                   Z-ADD     BANBRT        WkBaseRate
     C                   ENDIF
 
      ** Access Historic Base Rates
     C                   ELSE
     C                   Z-ADD     0             @BSRT             2 0
     C                   MOVE      DDBSRC        @BSRT
 
     C                   CALL      'AOBSHSR0'
     C                   PARM      *BLANKS       @RETURN
     C                   PARM      '*KEY   '     @OPTION
     C                   PARM      DDCCY         @CURRCY
     C                   PARM      @BSRT         @DEFFNDRT         2 0
     C                   PARM      ValDate       @HISTDATE         5 0
     C     SDBSHS        PARM      SDBSHS        DSFDY
 
     C     @RETURN       IFEQ      *BLANKS                                                   BUG5169
                                                                                             BUG5169
     C     BAVDNR        IFGE      G0HIDT                                                    BUG5169
     C     BAVDNR        ANDLE     Valdate                                                   BUG5169
     C                   Z-ADD     BANBRT        WkBaseRate                                  BUG5169
     C                   ELSE                                                                BUG5169
     C                   Z-ADD     G0CBSR        WkBaseRate
     C                   ENDIF                                                               BUG5169
                                                                                             BUG5169
      ** Get current base rate if not found on Base Rate History file                        BUG5169
                                                                                             BUG5169
     C                   ELSE                                                                BUG5169
                                                                                             BUG5169
     C     ValDate       IFLT      BAVDNR                                                    BUG5169
     C                   Z-ADD     BACBSR        WkBaseRate       11 7                       BUG5169
     C                   ELSE                                                                BUG5169
     C                   Z-ADD     BANBRT        WkBaseRate                                  BUG5169
     C                   ENDIF                                                               BUG5169
                                                                                             BUG5169
     C                   ENDIF                                                               BUG5169
 
     C                   ENDIF
                                                                                             BUG5169
     C                   ENDIF                                                  @RETURN      BUG5169
     C                   ENDIF                                                  DDBSRC       BUG5169
 
      ** Compute Actual Interest Rate from Base Rate and Spread                              BUG5169
                                                                                             BUG5169
      ** Always clear Actual Interest Rate field                                            AR876535
     C                   IF        WkBaseRate <> 0                                          AR876535
     C**********         EVAL      WWAIR = *BLANKS                                 AR876535 MD023121
     C                   EVAL      DDAIR = *BLANKS                                          AR876535
     C                   ENDIF                                                              AR876535
      *                                                                                     AR876535
     C     @RETURN       IFEQ      *BLANKS
     C     DDBSRC        ANDNE     *BLANKS                                                   BUG5169
     C     DDAIR         ANDEQ     *BLANKS                                                   BUG5169
                                                                                             BUG5169
     C     WkBaseRate    ADD       IKSPRD        IKINTR
     C     WkBaseRate    ADD       IKSPRD        WAIR             11 7
     C                   Z-ADD     0             PAmtIn
     C                   MOVE      WAIR          PAmtIn
     C                   Z-ADD     7             PNoOfDecPl
     C                   CALLB     'ZA0921'
     C                   PARM      *BLANK        RetCodeIn
     C                   PARM                    PAmtIn           15 0
     C                   PARM                    PNoOfDecPl        1 0
     C                   PARM                    BNDCSP
     C                   PARM      *BLANK        PAmtOutS         16
     C                   PARM      *BLANK        PAmtOutU         17
      *
     C**********         MOVE      PAmtOutS      DDAIR                                        247452
     C**********         MOVE      PAmtOutU      DDAIR                               247452 AR891660
     C                   MOVE      PAmtOutS      DDAIR                                      AR891660
      *
     C**********         ELSE                                                                BUG5169
     C**********         MOVE      *BLANKS       DDAIR                                       BUG5169
     C                   ENDIF
 
      ****Actual*Interest*Rate*is*not*Blank****************************                      BUG5169
     C**********         ELSE                                                                BUG5169
      *
      ** The Actual Interest Rate can be Base Rate plus spread rate                          BUG5169
      **   or the user can override the computed value.                                      BUG5169
                                                                                             BUG5169
     C     WWAIR         IFNE      *BLANKS                                                   BUG5169
     C                   MOVE      WWAIR         DDAIR                                       BUG5169
      **  Check it is a valid figure with 7 decimal places max.
     C                   Z-ADD     7             @@IDP
     C                   Z-ADD     4             @@IINT
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVE      DDAIR         @@ALPH
     C                   MOVE      'N'           @@MTID            1
     C**********         CALLB     'ZA0840'                                                   247452
     C                   CALLB     'ZA0841'                                                   247452
     C                   PARM                    RetCodeIn
     C                   PARM                    @@ALPH
     C                   PARM                    @@IDP
     C                   PARM                    @@IINT
     C                   PARM                    @@MTID
     C                   PARM                    @@Ercd
     C                   PARM                    @@Amt
     C                   PARM                    BNDCSP
      *
     C     @@Ercd        IFNE      0
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0422'     Msgid1
     C                   ENDIF
      *
      **  If the spread/rate is valid, determine the Actual Interest Rate
      **  and output it.
     C     ErrorFound    IFNE      'Y'
     C     DDAIR         IFNE      *BLANKS
     C     @@Amt         DIV       10000000      IKINTR
     C                   MOVE      @@ALPH        DDAIR
     C                   ELSE
     C                   Z-ADD     0             IKINTR
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
     C**********         ENDIF                                                               BUG5169
 
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
                                                                                             BUG4837
     C     BYPASS        TAG                                                                 BUG4837
 
     C                   SETON                                        LR                    MD023416
     C                   RETURN
 
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
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    Msgid1
     C                   PARM                    DDAIR
     C                   PARM                    BGN0ST
     C                   PARM                    BNDCSP
     C                   PARM                    DDCCY
     C                   PARM                    DDBSRC
     C                   PARM                    ValDate
     C                   PARM                    BJRDNB
     C                   PARM                    IKSPRD
     C                   PARM                    IKINTR
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2004
