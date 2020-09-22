     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ME MT941/2 Generation Schedules-Scr Validat°')
      *****************************************************************
      *                                                               *
      *  Midas - Messages Generation Module                           *
      *                                                               *
      *  RPGLE/ME002440 - Midas ME Generation Schedules Description   *
      *                   Maintenance (Key & Details Screen           *
      *                   Validation)                                 *
      *                                                               *
      *  Function:  This module validates the fields of a Generation  *
      *             Schedule record.                                  *
      *             Note that this module should only be called for   *
      *             "Insert".                                         *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD051648           Date 11Sep20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 CGL013  *CREATE    Date 25Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD051648 - Network AC MT942 Schedules Maint. -wrong formatted*
      *             start and end time.                               *
      *             Convert time attribute from alpha-numeric to      *
      *             numeric.                                          *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  CGL013 - MT94x Message Generation                            *
      *                                                               *
      *****************************************************************

     FGLGS94L1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLGS94D0:GLGS94D1)
      ** Midas GL Generation Schedules - Retrieval
      *
      *****************************************************************
      *                                                               *
      * Use of Indicators                                             *
      *                                                               *
      * Error Indicators                                              *
      *                                                               *
      * 40 - General Error Indicator                                  *
      * 41 - Start Date                                               *
      * 42 - End Date                                                 *
      * 43 - Period                                                   *
      * 44 - Start Time                                               *
      * 45 - End Time                                                 *
      * (The DS IN40_TO_70 is used to cover the whole set of reserved *
      *  error indicators)                                            *
      *                                                               *
      * Database Error Indicators                                     *
      *                                                               *
      * U7 - Abnormal Completion                                      *
      * U8 - File Out of Balance                                      *
      * U7 + U8 - Database Error                                      *
      *                                                               *
      * Other Indicators                                              *
      *                                                               *
      * 98 - Date format flag (*On if MDY / *Off if DMY)              *
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

     D NewFilRcd     E DS                  EXTNAME(GLGS94PD)
      ** New Generation Schedule File Record (i.e. new state after amendments)
      *

     D ScrLayout     E DS                  EXTNAME(ME002420DF:ME002420F1)
      ** Key & Details Screen Layout
      *

     D RUNDAT        E DS                  EXTNAME(RUNDAT) DTAARA(RUNDAT)
      ** Rundat DS
      *

     D                 DS                                                                   MD051648
     D  DSHH                   1      2S 0                                                  MD051648
     D  DSCHAR3                3      3A                                                    MD051648
     D  DSMN                   4      5S 0                                                  MD051648
     D  DSHHMN                 1      5A                                                    MD051648
      ** Data structure for time format 'HH:MN'                                             MD051648
      *                                                                                     MD051648
     D DSTIME          DS                                                                   MD051648
     D  DSTIMEHH               1      2S 0                                                  MD051648
     D  DSTIMEMN               3      4S 0                                                  MD051648
      ** Data structure for time format 'HHMN'                                              MD051648
      *                                                                                     MD051648

      ** Declared variables
      ** ------------------
      *

      ** Key fields
      *
     D KWSDTE          S                   LIKE(GSSDTE)

      ** Working fields
      *
     D WWHour          S              2  0
     D WWMinute        S              2  0
     D WWDate          S              5  0
     D WWSMinTot       S              5  0
     D WWEMinTot       S              5  0
     D WF1STIM         S              4  0                                                  MD051648
     D WF1ETIM         S              4  0                                                  MD051648

      ** Error Indicators Array
      *
     D IN40_TO_70      S              1    DIM(31)

      *------------------------------------------------------------------------*
      ** C Spec. Declaratives
      ** ====================
      *

      ** Entry Parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    RetCodeOut
     C                   PARM                    CallerIn         10
     C                   PARM                    ScrLayout
     C                   PARM                    IN40_TO_70
     C                   PARM                    NewFilRcd

      ** Key lists
      *
     C     KGLGS94L1     KLIST
     C                   KFLD                    GSNWRK
     C                   KFLD                    GSBRCA
     C                   KFLD                    GSCNUM
     C                   KFLD                    GSCCY
     C                   KFLD                    GSACCD
     C                   KFLD                    GSACSQ
     C                   KFLD                    GSNATY
     C                   KFLD                    GSDSTN
     C                   KFLD                    GSMTPY
     C                   KFLD                    KWSDTE
     C**********         KFLD                    F1STIM                                     MD051648
     C                   KFLD                    WF1STIM                                    MD051648

      *========================================================================*
      *              M  A  I  N     P  R  O  C  E  S  S  I  N  G               *
      *========================================================================*

      ** Init processing uses the standard *INZSR SR

      *------------------------------------------------------------------------*
      *                         Key Fields Validation                          *
      *------------------------------------------------------------------------*

      ** Start Date
      *
      ** -- The field is mandatory
      *
 B1  C                   IF        F1SDTE = 0
     C                   MOVE      'ME00034'     ZAMSID
     C                   MOVE      *On           *IN41
      *
      ** -- The value must be valid and greater than or equal to the Run Date
      *
 X1  C                   ELSE
     C                   MOVEL(P)  F1SDTE        @IDate
      *
     C                   CALLB     'ZDATCVT'
     C                   PARM                    @IDate           10
     C                   PARM      *IN98         @IDatTyp          1
     C                   PARM      *Blanks       @IFmt             7
     C                   PARM      '*MIDAS'      @OFmt             7
     C                   PARM      '*NONE'       @OSep             5
     C                   PARM                    @ODate           10
     C                   PARM                    @RtnCod           1
      *
 B2  C                   IF        @RtnCod <> '0'
     C                   MOVE      'ME00047'     ZAMSID
     C                   MOVE      *On           *IN41
 X2  C                   ELSE
     C                   MOVEL     @ODate        KWSDTE
      *
 B3  C                   IF        KWSDTE < AGRDNB
     C                   MOVE      'ME00048'     ZAMSID
     C                   MOVE      *On           *IN41
 E3  C                   ENDIF
      *
 E2  C                   ENDIF
      *
 E1  C                   ENDIF
      *
      ** -- If an error was found
      *
     C                   IF        *IN41
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End Start Date

      ** Start Time
      *
      ** -- The field must contain a valid Hour/Minute time,
      **    or the special value 99:99
      *
     C**********         MOVEL     F1STIM        WWHour                                     MD051648
     C**********         MOVE      F1STIM        WWMinute                                   MD051648
      ** Convert time from 'HH:MN:' to 'HHMN'                                               MD051648
      *                                                                                     MD051648
     C                   EVAL      DSHHMN = F1STIM                                          MD051648
     C                   EVAL      DSTIMEHH = DSHH                                          MD051648
     C                   EVAL      DSTIMEMN = DSMN                                          MD051648
     C                   EVAL      WWHour   = DSHH                                          MD051648
     C                   EVAL      WWMinute = DSMN                                          MD051648
     C                   MOVE      DSTIME        WF1STIM                                    MD051648
      *
     C**********         IF        F1STIM <> 9999 AND                                       MD051648
     C                   IF        WF1STIM <> 9999 AND                                      MD051648
     C                             (WWHour   < 0 OR WWHour   > 23 OR
     C                              WWMinute < 0 OR WWMinute > 59)
     C                   MOVE      'ME00088'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN44
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** -- Compute the value of Start Time in minutes
      *
     C**N40*****         IF        F1STIM <> 9999                                           MD051648
     C  N40              IF        WF1STIM <> 9999                                          MD051648
     C                   EVAL      WWSMinTot = (WWHour * 60) + WWMinute
     C                   ENDIF
      *
      ** End Start Time

      ** End the module if any error encountered
      *
     C   40              EXSR      $ExitMod

      *------------------------------------------------------------------------*
      *                  Database Keys Consistency Validation                  *
      *------------------------------------------------------------------------*

      ** Check if the key already exists in the database
      *
     C     KGLGS94L1     SETLL     GLGS94D1                               99

      ** -- The record already exists ==> error
      *
     C                   IF        *IN99
     C                   MOVE      'ME00041'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   MOVE      *On           *IN40
     C                   MOVE      *On           *IN41
     C                   MOVE      *On           *IN44
     C                   EXSR      $ExitMod
     C                   ENDIF

      *------------------------------------------------------------------------*
      *                       Details Fields Validation                        *
      *------------------------------------------------------------------------*

      ** End Date
      *
      ** -- If entered,
      **    the value must be valid and greater than or equal to the Start Date
      *
 B1  C                   IF        F1EDTE <> 0
     C                   MOVEL(P)  F1EDTE        @IDate
      *
     C                   CALLB     'ZDATCVT'
     C                   PARM                    @IDate
     C                   PARM      *IN98         @IDatTyp
     C                   PARM      *Blanks       @IFmt
     C                   PARM      '*MIDAS'      @OFmt
     C                   PARM      '*NONE'       @OSep
     C                   PARM                    @ODate
     C                   PARM                    @RtnCod
      *
 B2  C                   IF        @RtnCod <> '0'
     C                   MOVE      'ME00047'     ZAMSID
     C                   MOVE      *On           *IN42
 X2  C                   ELSE
     C                   MOVEL     @ODate        WWDate
      *
 B3  C                   IF        WWDate < KWSDTE
     C                   MOVE      'ME00089'     ZAMSID
     C                   MOVE      *On           *IN42
 E3  C                   ENDIF
      *
 E2  C                   ENDIF
      *
 E1  C                   ENDIF
      *
      ** -- If an error was found
      *
     C                   IF        *IN42
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End End Date

      ** Period
      *
      ** -- Can't be entered if the start time is 99:99
      *
     C**********         IF        F1SPRD <> 0 AND F1STIM = 9999                            MD051648
     C                   IF        F1SPRD <> 0 AND WF1STIM = 9999                           MD051648
     C                   MOVE      'ME00095'     ZAMSID
     C                   MOVE      *On           *IN43
     C                   ENDIF
      *
      ** -- Can't be less than zero
      *
     C                   IF        F1SPRD < 0
     C                   MOVE      'ME00090'     ZAMSID
     C                   MOVE      *On           *IN43
     C                   ENDIF
      *
      ** -- If an error was found
      *
     C                   IF        *IN43
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** -- Compute the minimum value for end time, in minutes
      *
     C  N40              EVAL      WWSMinTot = WWSMinTot + F1SPRD
      *
      ** End Period

      ** End Time
      *
      ** Convert time from 'HH:MN:' to 'HHMN'                                               MD051648
      *                                                                                     MD051648
     C                   EVAL      DSHHMN = F1ETIM                                          MD051648
     C                   EVAL      DSTIMEHH = DSHH                                          MD051648
     C                   EVAL      DSTIMEMN = DSMN                                          MD051648
     C                   EVAL      WWHour   = DSHH                                          MD051648
     C                   EVAL      WWMinute = DSMN                                          MD051648
     C                   MOVE      DSTIME        WF1ETIM                                    MD051648
                                                                                            MD051648
 B1  C                   SELECT
      *
      ** -- The field must be left to zeros if no Period is entered
      *
 X1  C                   WHEN      F1SPRD = 0
      *
 B2  C**********         IF        F1ETIM <> 0                                              MD051648
 B2  C                   IF        WF1ETIM <> 0                                             MD051648
     C                   MOVE      'ME00091'     ZAMSID
     C                   MOVE      *On           *IN45
 E2  C                   ENDIF
      *
      ** -- If a Period is entered, the field must be a valid hour/minute time,
      **    and greater or equal to Start Time + Period
      *
 X1  C                   OTHER
      *
     C                   MOVEL     F1ETIM        WWHour
     C                   MOVE      F1ETIM        WWMinute
      *
 B2  C                   IF        (WWHour   < 0 OR WWHour   > 23 OR
     C                              WWMinute < 0 OR WWMinute > 59)
     C                   MOVE      'ME00092'     ZAMSID
     C                   MOVE      *On           *IN45
 X2  C                   ELSE
     C                   EVAL      WWEMinTot = (WWHour * 60) + WWMinute
      *
 B3  C                   IF        WWEMinTot < WWSMinTot
     C                   MOVE      'ME00093'     ZAMSID
     C                   MOVE      *On           *IN45
 E3  C                   ENDIF
      *
 E2  C                   ENDIF
      *
 E1  C                   ENDSL
      *
      ** -- If an error was found
      *
     C                   IF        *IN45
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End End Time

      ** End of the module
      *
     C                   EXSR      $ExitMod

      *========================================================================*
      *                    S  U  B  R  O  U  T  I  N  E  S                     *
      *========================================================================*

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
      ** Return the current values of the error indicators
      *
     C                   MOVEA     *IN(40)       IN40_TO_70

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
     C     AGDFF         COMP      'M'                                    98

      ** Initialize error indicators with the values passed by the caller
      *
     C                   MOVEA     IN40_TO_70    *IN(40)

      ** Reset general error indicator
      *
     C                   MOVE      *OFF          *IN40

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
(c) Finastra International Limited 2002
