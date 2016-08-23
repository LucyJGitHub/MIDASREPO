     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ME MT941/2 Message Requests Generator')
      *****************************************************************
      *                                                               *
      *  Midas - Messages Generation Module                           *
      *                                                               *
      *  RPGLE/ME002561 - Midas ME MT941/2 Message Requests Maint.    *
      *                   (Database Update - Requests Generator)      *
      *                                                               *
      *  Function:  This module is used to generate message requests, *
      *             according to the values of a generation schedule  *
      *             record received as parameter.                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      *  Prev Amend No. CGL029             Date 01Sep03               *
      *                 217556             Date 30May03               *
      *                 CGL013   *CREATE   Date 06May02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  217556 - MT942 not generated according schedule              *
      *  CGL013 - MT94x Messages Generation                           *
      *                                                               *
      *****************************************************************
 
     FGLMR94L0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Midas GL MT941/2 Message Requests - Update
      *
 
     FGLMR94L4  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLMR94D0:GLMR94D4)
      ** Midas GL MT941/2 Message Requests - Duplicates Retrieve
      *
      *****************************************************************
      *                                                               *
      * Use of Indicators                                             *
      *                                                               *
      * Database Access Indicators                                    *
      *                                                               *
      * 27 - Access GLMR94L0                                          *
      *                                                               *
      * Database Error Indicators                                     *
      *                                                               *
      * U7 - Abnormal Completion                                      *
      * U8 - File Out of Balance                                      *
      * U7 + U8 - Database Error                                      *
      *                                                               *
      * Other Indicators                                              *
      *                                                               *
      * 99 - Multi-purpose                                            *
      *                                                               *
      *****************************************************************
 
      ** Automatically included D-specs
      ** ==============================
      *
 
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
 
      ** Manually included D-specs
      ** =========================
      *
 
      ** Named constants
      ** ---------------
      *
 
      ** Arrays and Data Structures
      ** --------------------------
      *
 
     D SchRcd        E DS                  EXTNAME(GLGS94PD)
      ** Generation Schedule File Record
      *
 
     D RUNDAT        E DS                  EXTNAME(RUNDAT) DTAARA(RUNDAT)
      ** Rundat DS
      *
 
     D WWHHMM          DS                                                                     217556
      ** Data structure to define control time                                                217556
     D WWHH                           2S 0                                                    217556
     D WWMM                           2S 0                                                    217556
      *                                                                                       217556
 
      ** Declared variables
      ** ------------------
      *
     D WWTime          S               T   TIMFMT(*ISO)
     D WWEndTime       S               T   TIMFMT(*ISO)
     D WWTime6N0       S              6P 0
     D WWTime4A        S              4A
     D WWCtlDateTime   S               Z                                                      217556
     D WWEndDateTime   S               Z                                                      217556
 
      *------------------------------------------------------------------------*
      ** C Spec. Declaratives
      ** ====================
      *
 
      ** Entry Parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    RetCodeOut
     C                   PARM                    CallerIn         10
     C                   PARM                    SchRcd
     C                   PARM                    @2FLD            15 0
     C                   PARM                    @2FLC            15 0
 
      ** Key lists
      *
     C     KGLMR94L4     KLIST
     C                   KFLD                    MRNWRK
     C                   KFLD                    MRBRCA
     C                   KFLD                    MRCNUM
     C                   KFLD                    MRCCY
     C                   KFLD                    MRACCD
     C                   KFLD                    MRACSQ
     C                   KFLD                    MRNATY
     C                   KFLD                    MRDSTN
     C                   KFLD                    MRMTPY
     C                   KFLD                    MRRDTE
     C                   KFLD                    MRSRTIM
 
      *========================================================================*
      *              M  A  I  N     P  R  O  C  E  S  S  I  N  G               *
      *========================================================================*
 
      ** Init processing uses the standard *INZSR subroutine
 
      ** Generates the message requests for the current date
      ** if it is between the start and end date of the schedule
      *
 B1  C                   IF        GSSDTE <= AGRDNB AND
     C                             (GSEDTE = 0 OR GSEDTE >= AGRDNB)
 
      ** Initialize the time of the first request to be generated
      *
 B2  C                   IF        GSSTIM <> 9999
     C                   EVAL      WWTime6N0 = GSSTIM * 100
     C                   MOVEL     WWTime6N0     WWTime
 E2  C                   ENDIF
 
      ** Two cases
      *
 B2  C                   SELECT
 
      ** If no period is passed, output only one request
      ** (the test on GSSTIM is a security, for future use. For the moment,
      **  we can't have GSSPRD <> 0 and GSSTIM = 9999)
      *
 X2  C                   WHEN      GSSPRD = 0 OR GSSTIM = 9999
     C                   EXSR      $GenRqs
 
      ** Otherwise, generates several requests from start time to end time,
      ** the interval between two of them being equal to the period (in minutes)
      *
 X2  C                   OTHER
      *
      ** Generate the request for only one day.                                               217556
      ** Rmk: The initial value of date is not important, the processing uses a timestamp     217556
      **      fields only to know when the date change. This avoid a loop in the generation   217556
      *       when the start time + the periods will not be the end time.                     217556
      *                                                                                       217556
     C                   CLEAR                   WWCtlDateTime                                217556
     C                   MOVE      GSSTIM        WWHHMM                                       217556
     C                   ADDDUR    WWHH:*H       WWCtlDateTime                                217556
     C                   ADDDUR    WWMM:*MN      WWCtlDateTime                                217556
      *                                                                                       217556
     C                   CLEAR                   WWEndDateTime                                217556
     C                   MOVE      GSETIM        WWHHMM                                       217556
     C                   ADDDUR    WWHH:*H       WWEndDateTime                                217556
     C                   ADDDUR    WWMM:*MN      WWEndDateTime                                217556
      *                                                                                       217556
     C                   EVAL      WWTime6N0 = GSETIM * 100
     C                   MOVEL     WWTime6N0     WWEndTime
 
 B3  C*********          DOW       WWTime <= WWEndTime                                        217556
 B3  C                   DOW       WWCtlDateTime <= WWEndDateTime                             217556
     C                   EXSR      $GenRqs
     C                   ADDDUR    GSSPRD:*MN    WWTime
     C                   ADDDUR    GSSPRD:*MN    WWCtlDateTime                                217556
 E3  C                   ENDDO
 
 E2  C                   ENDSL
 
 E1  C                   ENDIF
 
      ** End of the module
      *
     C                   EXSR      $ExitMod
 
      *========================================================================*
      *                    S  U  B  R  O  U  T  I  N  E  S                     *
      *========================================================================*
 
      *========================================================================*
      * $GenRqs   : Generates a message request                                *
      *------------------------------------------------------------------------*
     C     $GenRqs       BEGSR
      *    ----------    ------
     C                   CLEAR                   GLMR94D0
 
      ** Key fields
      *
     C                   EVAL      MRNWRK = GSNWRK
     C                   EVAL      MRBRCA = GSBRCA
     C                   EVAL      MRCNUM = GSCNUM
     C                   EVAL      MRCCY  = GSCCY
     C                   EVAL      MRACCD = GSACCD
     C                   EVAL      MRACSQ = GSACSQ
     C                   EVAL      MRNATY = GSNATY
     C                   EVAL      MRDSTN = GSDSTN
     C                   EVAL      MRMTPY = GSMTPY
     C                   EVAL      MRSORQ = 'SCHEDULE'
     C                   EVAL      MRSDTE = GSSDTE
     C                   EVAL      MRSTIM = GSSTIM
     C                   EVAL      MRRDTE = AGRDNB
 
     C                   IF        GSSTIM <> 9999
     C                   MOVEL     WWTime        WWTime6N0
     C                   MOVEL     WWTime6N0     MRSRTIM
     C                   ELSE
     C                   EVAL      MRSRTIM = 'IMED'
     C                   ENDIF
 
      ** Request status
      *
     C                   TIME                    WWTime6N0
     C                   MOVEL     WWTime6N0     WWTime4A
 
     C     KGLMR94L4     SETLL     GLMR94D4                               99
 
 B1  C                   SELECT
 
      ***Status "EXPIRED" if the current system time is greater than                          217556
      ***the request time                                                                     217556
      *                                                                                       217556
 X1  C*********          WHEN      MRSRTIM <> 'IMED' AND MRSRTIM < WWTime4A                   217556
     C*********          EVAL      MRSTAT = 'EXPIRED'                                         217556
 
      ** Status "DUPLICATE" if there is another request for the same destination,
      ** message type, request date and time, with a status "WAITING" or "SUBMITTED"
      *
 X1  C                   WHEN      *IN99
     C                   EVAL      MRSTAT = 'DUPLICATE'
 
      ** Status "WAITING" otherwise
      *
 X1  C                   OTHER
     C                   EVAL      MRSTAT = 'WAITING'
 E1  C                   ENDSL
 
      ** Floor limit debit and credit if MT942
      *
     C                   IF        MRMTPY = '942'
     C                   EVAL      MR2FLD = @2FLD
     C                   EVAL      MR2FLC = @2FLC
     C                   ENDIF
 
      ***Write*the*record*if*necessary*****                                                   217556
      *
     C******             IF        MRSTAT = 'WAITING'                                         217556
     C                   WRITE     GLMR94D0
     C******             ENDIF                                                                217556
      *    ----------    ------
     C     @GenRqs       ENDSR
 
      *========================================================================*
      * $ZaSndMsg : Send message to the program message queue                  *
      *------------------------------------------------------------------------*
     C     $ZaSndMsg     BEGSR
      *    ----------    ------
 
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGM
     C                   PARM                    ZAPGRL
     C                   PARM                    ZAMSID
     C                   PARM                    ZAMSGF
     C                   PARM                    ZAMSDA
     C                   PARM                    ZAMSTP
      *    ----------    ------
     C     @ZaSndMsg     ENDSR
 
      *========================================================================*
      * $ExitMod  : Exit from the module                                       *
      *------------------------------------------------------------------------*
     C     $ExitMod      BEGSR
      *    ----------    ------
     C                   MOVE      *On           *INLR
     C                   RETURN
      *    ----------    ------
     C     @ExitMod      ENDSR
 
      *========================================================================*
      * *INZSR    : Init Processing                                            *
      *========================================================================*
     C     *INZSR        BEGSR
      *    ----------    ------
      ** Initialise Copyright Array
      *
     C                   MOVEA     CPY@          CPY@@            80
 
      ** Define fields used by the message sending function
      *
      ** -- If no named caller --> set-up ZAPGM with the current program name
      *
     C                   IF        CallerIn = *Blanks
     C                   MOVEL     PSProcPgm     ZAPGM            10
 
      ** -- Otherwise set-up ZAPGM with the caller name
      *
     C                   ELSE
     C                   MOVEL     CallerIn      ZAPGM
     C                   ENDIF
 
     C                   MOVEL     'MEMSG'       ZAMSGF           10
     C                   MOVEL     '*SAME'       ZAPGRL            5
     C                   MOVEL     *Blanks       ZAMSID            7
     C                   MOVEL     *Blanks       ZAMSDA          132
     C                   MOVEL     *Blanks       ZAMSTP            7
 
      ** Retrieve RUNDAT
      *
     C                   IN        RUNDAT
 
      ** Clear the return code
      *
     C                   EVAL      RetCodeOut = *Blanks
      *    ----------    ------
     C     @INZSR        ENDSR
 
      *========================================================================*
      * *PSSR     : Program exception error subroutine                         *
      *------------------------------------------------------------------------*
     C     *PSSR         BEGSR
      *    ----------    ------
     C                   DUMP
 
     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
 
     C                   CALLB     'DBERRCTL'                           99
 
     C                   MOVEL(P)  '*ERROR'      RetCodeOut
     C                   EXSR      $ExitMod
      *    ----------    ------
     C     @PSSR         ENDSR
 
      *========================================================================*
**  CPY@
(c) Misys International Banking Systems Ltd. 2002
