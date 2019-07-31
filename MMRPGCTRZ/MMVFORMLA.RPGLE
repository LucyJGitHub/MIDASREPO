     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate Schedule Formula')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Module                                  *
      *                                                               *
      *  MMVFORMLA - Midas MM Validate Schedule Formula               *
      *                                                               *
      *  Function:  Validation program that will validate the         *
      *             schedule formula.                                 *
      *                                                               *
      *  Called By: MMLDNIVU - Midas MM Loans/deposits validate and   *
      *                        Update                                 *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR1096664          Date 27Mar13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL033  *CREATE    Date 10Feb05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR1096664 - Serious midas error encountered                  *
      *  CLD033 - Floating Rate CD Issued                             *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  ValFormula - Routine to validate formula                     *
      *  SRZDATE2   - Convert Midas Day Number                        *
      *  SRGenDates - Routine to generate dates                       *
      *  ZASNMS - Send message to program's message queue.            *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Midas Local Data Area for database error reporting; based on
      ** external file
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc
 
     D/SPACE 3
 
      ** API DUMP Information Data Area for database error reporting;
      ** based on external file
     D APDUMP        E DS                  EXTNAME(APDUMP) DTAARA(APDUMP)
 
     D/SPACE 3
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Whether or not *PSSR has been run previously
     D RunBefore       S              1A
 
      ** Return Code
     D ReturnCode      S             10A
 
      ** Module-wide flag to show that errors have occurred in the
      ** current module
     D ErrorFound      S              1A   INZ('N')
 
      ** Module-wide flag to show that warnings have occurred in the
      ** current module
     D WarnFound       S              1A   INZ('N')
 
      ** Global flag to show that warnings have occurred early on in
      ** the suite of validation modules
     D WarnGlobal      S              1A
 
      ** Module-wide flag to show that database errors have occurred
      ** in the current module
     D DBErrFound      S              1A   INZ('N')
 
      ** Message ID
     D #MsgID          S              7A
 
      ** Message file
     D #MsgFile        S             10A
 
      ** Message file library
     D #MsgFLib        S             10A
 
      ** Message data  S
     D #MsgData        S             45A
 
      ** Name of field being processed
     D FieldName       S             10A
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** True and False can be used for indicators being on or off.
     D True            C                   *On
     D False           C                   *Off
 
      ** The name of the database error handler
     D DBErrCtl        C                   CONST('DBERRCTL')
 
      ** The name of the message handling module
     D HandleMsg       C                   CONST('ZAMSGHNDLE')
 
      ** The array size for the array of message files.
     D MsgFArrMax      C                   CONST(5)
 
      ** +--------------------------------------+
      ** ¦ Data Structures and Arrays           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
 
      ** Array of message files to check
     D MsgFArray       S             10A   DIM(MsgFArrMax)
 
      **
     D DatesInArr      S              5  0 DIM(600)
 
      **
     D Lett            S              1A   DIM(7) CTDATA PERRCD(7)
 
      **
     DPSDS            SDS
 
      ** Procedure name
     D PSProcName        *PROC
 
      ** Status code
     D PSPgmStat         *STATUS
 
      ** Previous status
     D PSPrvStat              16     20S 0
 
      ** Source listing line number
     D PSLineNum              21     28
 
      ** Routine name
     D PSRoutine         *ROUTINE
 
      **  Number of passed parameters
     D PSNoOfParm        *PARMS
 
      **  Exception type
     D PSExcpType             40     42
 
      **  Exception number
     D PSExcpNo               43     46
 
      **  Program library
     D PSPgmLib               81     90
 
      **  Exception data
     D PSExcpData             91    170
 
      **  Exception Id
     D PSExcpID              171    174
 
      **  Date (*DATE format)
     D PSDate                191    198
 
      ** Year (*YEAR format)
     D PSYear                199    200S 0
 
      ** Last file used
     D PSLastFile            201    208
 
      ** File error information
     D PSFileInfo            209    243
 
      ** Job name
     D PSJobName             244    253
 
      ** User name
     D PSUser                254    263
 
      ** Job number
     D PSJobNo               264    269S 0
 
      ** Date (UDATE format)
     D PSJobDate             270    275S 0
 
      ** Run date (UDATE format)
     D PSRunDate             276    281S 0
 
      ** Run time (UDATE format)
     D PSRunTime             282    287S 0
 
      ** Creation date
     D PSCrtDate             288    293
 
      ** Creation time
     D PSCrtTime             294    299
 
      ** Compiler level
     D PSCompLvl             300    303
 
      ** Source file
     D PSSrcfile             304    313
 
      ** Source file library
     D PSSrcLib              314    323
 
      ** Source file member
     D PSSrcMbr              324    333
 
      ** Program containing procedure
     D PSProcPgm             334    343
 
      ** Module containing procedure
     D PSProcMod             344    353
      *
      ** Internally described data structure for ZDATE
     D DateDS          DS             6
     D  DteMth                 1      2A
     D  DteDay                 3      4A
     D  DteYr                  5      6A
      **
     D PFormula        DS
     D  SFORM                  1      7
     D  SWRK1                  1      1
     D  SWRK2                  2      2
     D  SWRK1_2                1      2
     D  SWRK3                  3      3
     D  SWRK4                  4      4
     D  SWRK5                  5      5
     D  SDN2                   4      5
     D  SWRK6                  6      6
     D  S456                   4      6
     D  SWRK7                  7      7
 
     D                 DS
     D  WCharA                 1      3A
     D***WNumP**                1      3P 0                                                AR1096664
     D  WNumP                  1      3P 0 INZ(0)                                          AR1096664
 
      ** The maximum size of the error arrays
     D ArrayMax        C                   CONST(75)
 
      ** +--------------------------------------+
      ** ¦ Arrays                               ¦
      ** ¦ ==
      ** +--------------------------------------+
 
      ** Array of Fields in error.
     D FldNamArr       S             10A   DIM(ArrayMax)
      ** Array of error message IDs
     D MsgIDArr        S                   DIM(ArrayMax)
     D                                     LIKE(#MsgID)
 
      ** Entry parameters definitions
     D RetRnCode       S              7A
     D PFrequency      S              1A
     D PControlDate    S              5  0
     D PMaturityDate   S              5  0
     D PCurrency       S              3A
     D ValDateIn       S           1800A
     D Idx             S              3P 0
 
     D WDate           S                   Like(PFDay)
     D ZDATE           S              6P 0
     D ZDAYNO          S              5P 0
 
     D #N              S              5S 0 Inz(0)
     D #X              S                   Like(#N)
     D #Y              S                   Like(#N)
      *
      /EJECT
      ***************************************************************
      *                                                             *
      *                   MAIN PROCESSING                           *
      *                                                             *
      ***************************************************************
      *
      ** Verify if frequency is monthly, quarterly, semi-annual or
      ** annual.
      *
     C                   If        PFrequency='M' or PFrequency='Q'
     C                             or PFrequency='X' or PFrequency='Y'
      *
     C                   Exsr      ValFormula
      *
      ** No errors from ValFormula
      *
     C                   IF        Idx=0 And PFormula <> *BLANKS
      *
      ** Execute subroutine SRGenDates
      *
     C                   Exsr      SRGenDates
      *
      ** No error, replace records from ValDateIn with the new dates
      ** on DatesInArr.
      *
     C                   Do        600           #X
     C                   EVAL      #Y = ((#X - 1) * 3) + 1
     C                   MoveA     DatesInArr(#X)Wnump
     C                   EVAL      %SUBST(ValDateIn:#Y:3) = WCharA
     C*                  Eval      ValDateIn = %Trim(ValDateIN)+%Trim(WCharA)
     C                   IF        DatesInArr(#X) = 0
     C                   LEAVE
     C                   ENDIF
     C                   Enddo
      *
     C                   Endif
      *
     C                   Endif
      *
      ** Return to calling program
      *
     C                   Seton                                        LR
     C                   Return
      /EJECT
      *****************************************************************
      *  ValFormula - Routine to validate formula                     *
      *****************************************************************
      *
     C     ValFormula    BEGSR
      *
      ** Formula must be specified
      *
     C                   If        PFormula = *Blanks
      *
     C                   Add       1             Idx
     C                   Movel     'DLM0153'     MsgIDArr(Idx)
     C                   Eval      FldNamArr (Idx) = 'SFORM'
      *
     C                   Else
      *
      ** Date must be a formula
      *
     C                   EVAL      *IN89=*OFF
      *
      ** Validate first two positions
      ** First two positions are mandatory
      *
     C                   IF        (SWRK1 = *BLANK) OR (SWRK2 = *BLANK)
     C                   EVAL      *IN89=*ON
     C                   ENDIF
      *
      ** Are positions 1&2 numeric  ?
      *
     C                   TESTN                   SWRK1_2              24
      *
      ** If SWRK1_2 is numeric
      *
     C                   IF        *IN24=*ON
     C                   MOVE      SWRK1_2       WRK2N             2 0
      *
      ** Number must be between 1 and 28, or be 31.
      *
     C                   IF        WRK2N > 28 AND SWRK1_2 <> '31'
     C                             OR WRK2N < 1
     C                   EVAL      *IN89=*ON
     C                   ENDIF
      *
      ** If not numeric
      *
     C                   ELSE
      *
      ** If position 2 is not numeric, then position 1 should be 1, 2, 3, 4.
      *
     C                   IF        SWRK1 < '1' OR SWRK1 > '4'
     C                   EVAL      *IN89=*ON
     C                   ENDIF
      *
      ** 1st character valid (1 to 4) - check 2ND is in array of day in week
      ** codes.
      *
     C     SWRK2         LOOKUP    LETT                                   24
     C                   IF        *IN24 = *OFF
     C                   EVAL      *IN89=*ON
     C                   ENDIF
      *
      ** End of non-numeric validation
      *
     C                   ENDIF
      *
      ** Validate position 3
      *
      ** If position 1/2 is 31, pos 3 must be blank, or 4,5,6 have
      ** entry.If position 1 and 2 are not '31' pos.3 must be '+'
      ** or '-'.
      *
     C                   IF        SWRK1_2 = '31' AND SWRK3 <> *BLANK
     C                             AND S456 = *BLANK
     C                   EVAL      *IN89=*ON
     C                   ENDIF
      *
     C                   IF        SWRK1_2 <> '31' AND SWRK3 <> '+'
     C                             AND SWRK3 <> '-'
     C                   EVAL      *IN89=*ON
     C                   ENDIF
      *
     C                   IF        SWRK1_2 = '31' AND SWRK3 <> '+'
     C                             AND SWRK3 <> '-' AND SWRK3 <> ' '
     C                   EVAL      *IN89=*ON
     C                   ENDIF
      *
      ** Validate positions 4 and 5
      ** If entered must be numeric, between 1 and 28 inclusive
      *
     C                   IF        SDN2 <> *BLANK
      *
     C                   MOVE      0             WRK3A             3
     C                   MOVEL     SDN2          WRK3A
     C                   TESTN                   WRK3A                24
      *
      ** Not valid numeric
      *
     C                   IF        *IN24 = *OFF
     C                   EVAL      *IN89=*ON
     C                   ELSE
      *
      ** Valid number, check range
      *
     C                   MOVE      SDN2          WRK2N
     C                   IF        WRK2N < 1 OR WRK2N > 28
     C                   EVAL      *IN89=*ON
     C                   ENDIF
     C                   ENDIF
      *
      ** End of numeric validation for pos 4/5
      *
     C                   ENDIF
      *
      ** Validate position 6
      ** If positions 4 and 5 are entered pos.6 must be A,B or C
      *
     C                   IF        SDN2 <> *BLANK AND SWRK6 <> 'A'
     C                             AND SWRK6 <> 'B' AND SWRK6 <> 'C'
     C                   EVAL      *IN89=*ON
     C                   ENDIF
      *
      **  Validate position 7
      **  If position 6 is 'A' then pos 7 must be '+' or'-'
      **  otherwise it must be blank.
      *
     C                   IF        SWRK6 = 'A'
     C                   IF        SWRK7 <> '+' AND SWRK7 <> '-'
     C                   EVAL      *IN89=*ON
     C                   ENDIF
      *
     C                   ELSE
     C                   IF        SWRK7 <> ' '
     C                   EVAL      *IN89=*ON
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   IF        *IN89=*ON
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIDArr(Idx) = 'DLM0154'
     C                   EVAL      FldNamArr (Idx) = 'SFORM'
     C                   ENDIF
      *
      **  Get DD/MM/YY format of date, and month and year
      *
     C                   IF        PControlDate <> 0 AND Idx=0
     C                   EVAL      ZDAYNO = PControlDate
     C                   EXSR      SRZDATE2
     C                   ELSE
      *   If no start date present, formula cannot be used
     C                   Z-ADD     *ZERO         Pyear
     C                   Z-ADD     *ZERO         Pmonth
     C                   ADD       1             Idx
     C                   MOVEL     'DLM0155'     MsgIDArr(Idx)
     C                   EVAL      FldNamArr (Idx) = 'SFORM'
     C                   ENDIF
     C                   ENDIF
     C                   ENDSR
      /EJECT
      ****************************************************************
      *                                                              *
      *  SRZDATE2  - Convert Midas Day Number                        *
      *                                                              *
      ****************************************************************
 
     C     SRZDATE2      BEGSR
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        ZDATE
     C                   PARM      *BLANKS       ZADATE            7
 
     C                   MOVEL     ZDATE         DateDS
 
     C     BJDFIN        IFEQ      'M'
     C                   MOVE      DteMth        Pmonth
     C                   ELSE
     C                   MOVE      DteDay        Pmonth
     C                   ENDIF
     C                   MOVE      DteYr         Pyear
     C                   ENDSR
 
      ****************************************************************
      *  SRGenDates - Routine to generate dates                      *
      ****************************************************************
     C     SRGenDates    Begsr
      *
      ** Move input dates to work array and get the latest date from the
      ** list of input dates
     C                   EVAL      WDate = PControlDate
     C                   Do        600           #X
     C                   EVAL      #Y = ((#X - 1) * 3) + 1
     C                   EVAL      WCharA = %SUBST(ValDateIn:#Y:3)
     C                   IF        WCharA = *BLANKS                                        AR1096664
     C                   LEAVE                                                             AR1096664
     C                   ENDIF                                                             AR1096664
     C                   Z-ADD     WNumP         DatesInArr(#X)
     C                   IF        DatesInArr(#X) = 0
     C                   LEAVE
     C                   ENDIF
     C                   If        DatesInArr(#X) > WDate
     C                   EVAL      WDate = DatesInArr(#X)
     C                   Endif
     C                   Enddo
      *
     C                   Eval      Pmonth = 0
     C                   Eval      Pyear = 0
     C                   EVAL      #Y = #X
     C                   Eval      Plocation = *Blanks
      *
      *
     C                   EVAL      ZDAYNO = WDate
     C                   EXSR      SRZDATE2
      *
     C                   Dow       WDate < PMaturityDate
      *
 
     C                   CALLB     'FFDATE'
 
      ** Return code (10A, returned to caller)
 
     C                   PARM      *Blanks       PreturnCOde      10
      *
      ** Working day (5,0P)
      *
     C                   PARM      WDate         PFDay             5 0
 
      *
      ** Parameters received from caller
      ** -------------------------------
      ** Date formula (7A)
      *
     C                   PARM      PFormula      PdateC            7
      *
      ** Month of required date (2,0P)
      *
     C                   PARM                    Pmonth            2 0
      *
      ** Year of required date (2,0P)
      *
     C                   PARM                    Pyear             2 0
      *
      ** Currency (3A)
      *
     C                   PARM                    Pcurrency
      *
      ** Location (3A)
      *
     C                   PARM                    Plocation         3
      *
      ** Instrument currency (3A)
      *
     C                   PARM      *Blanks       Pcurrency2        3
      *
      ** Other currency (3A)
      *
     C                   PARM      *Blanks       Pcurrency3        3
      *
      ** Date format indicator (1A, from RUNDAT or SDBANKPD)
      *
     C                   PARM                    BJDFIN            1
 
     C                   Eval      WDate = PFDay
 
     C                   IF        WDate < PMaturityDate And
     C                             WDate >= PControlDate
 
     C     Wdate         LOOKUP    DatesInArr                             01
     C                   If        *IN01 = *OFF
     C                   Z-ADD     WDate         DatesInArr(#Y)
     C                   Add       1             #Y
     C                   Endif
     C                   Endif
      *
      ** Update year/month according to frequency
      *
     C                   Select
     C                   When      PFrequency = 'M'
     C                   Add       1             Pmonth
     C                   When      PFrequency = 'Q'
     C                   Add       3             Pmonth
     C                   When      PFrequency = 'X'
     C                   Add       6             Pmonth
     C                   When      PFrequency = 'Y'
     C                   Add       12            Pmonth
     C                   Endsl
      *
      ** If past end of year
      *
     C                   If        Pmonth > 12
     C                   Add       1             Pyear
     C                   Sub       12            Pmonth
     C                   Endif
      *
     C                   Enddo
     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *                                                               *
      *****************************************************************
      *
     C     *Inzsr        Begsr
      *
     C     *Entry        Plist
      ** Input
     C                   Parm                    ReturnCode
     C                   Parm                    PFrequency
     C                   Parm                    PFormula
     C                   Parm                    PControlDate
     C                   Parm                    PMaturityDate
     C                   Parm                    PCurrency
     C                   Parm                    BJDFIN
      ** Output
     C                   Parm                    ValDateIn
     C                   Parm                    FldNamArr
     C                   Parm                    MsgIdArr
     C                   Parm                    Idx
      *
     C                   Endsr
      *
      *****************************************************************
      *                                                               *
      *  ZASNMS - Send message to program's message queue.            *
      *                                                               *
      *****************************************************************
      *
     C     ZASNMS        BEGSR
      *
     C     ZAPGM         IFEQ      *BLANK
     C                   MOVEL     'MMVFORMLA'   ZAPGM            10
     C                   ENDIF
      *
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGM
     C                   PARM                    ZAPGRL            5
     C                   PARM                    ZAMSID            7
     C                   PARM                    ZAMSGF           10
     C                   PARM                    ZAMSDA          132
     C                   PARM                    ZAMSTP            7
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  *PSSR - Database Error Handling Subroutine                   *
      *                                                               *
      ******************************************** ********************
      *
     C     *PSSR         BEGSR
      *
     C     RunBefore     IFEQ      *BLANK
     C                   MOVE      'Y'           RunBefore
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   ENDIF
      *
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
     C                   ENDSR
      *
      ****************************************************************
      /EJECT
** CPY@
(c) Finastra International Limited 2005
** LETT - Letters for days to validate date formulas
MUWTFSX
