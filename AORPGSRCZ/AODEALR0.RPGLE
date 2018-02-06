     H DEBUG
      *****************************************************************
/***D ***RPG***********************************************************   CAP002
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Dealing ICD access object')
     F*****************************************************************
     F*                                                               *
     F*  Midas  ACCESS OBJECTS                                        *
     F*                                                               *
     F*     AODEALR0 - READ ACCESS TO DEALING DATA CODES FILE         *
     F*                I.C.D. RECORD - ONLY ONE RECORD IN FILE        *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CAS005             Date 16Dec02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001             Date 23Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CDL006             Date 26Apr99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002             Date 01May98               *
     F*                 CDL002             Date 26Feb97               *
     F*                    CCM002             DATE 11AUG95            *
     F*                    S01434             DATE 11OCT93            *
     F*                    S01443             DATE 11OCT93            *
     F*                    S01440             DATE 11OCT93            *
     F*                    S01319             DATE 12SEP91            *   S01230
     F*                    S01230             DATE 23/11/89           *   S01230
     F*                    S01230             DATE 06/11/89           *   S01230
     F*                                                               *   S01230
     F*                                                               *
     F*****************************************************************
     F*                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *           (Recompiled over changed SDDEALPD)                  *
      *  CDL006 - Dealing Fiduciary (Recompiled)                      *
      *  CAP002 - Member converted from an OPM program to an ILE      *
      *           module and an ILE *PGM member of the same name has  *
      *           been created (in AOPGMSRC).                         *
      *           ILE modules can make a bound call to the module.    *
      *           OPM programs can make a dynamic call to the *PGM.   *
     F*     CDL002 - FX Netting:                                      *
     F*            - Recompile over extended SDDEALPD.                *
     F*     CCM002 - City Dealer Phases 5/6:                          *
     F*              - Recompiled over changed SDDEALL1.              *
     F*     S01434 - Added new field "Number of Working Days Before   *
     F*              Maturity Date" to SDDEALPD.                      *
     F*     S01443 - Added new field "Loans/Deposits Interest Rate    *
     F*              Tolerance Percentage" to SDDEALPD.               *
     F*     S01440 - Added new field "Accruals on Interest Outrights" *
     F*              to SDDEALPD.                                     *   S01230
     F*     S01319 - Recompiled due to SDDEALPD change                *   S01230
     F*     S01230 - STANDARDISE ACCESS PROGRAM & COPYRIGHT ADDED     *   S01230
     F*
     F* ID F  C  H  L     FUNCTION OF INDICATORS
     F*
     F*       01       OPEN FILE - SDDEALL1
     F*       90       FILE ERROR
     F*       91       OPEN ERROR
     F*       92       CLOSE ERROR
     F*       93       EMPTY FILE
     F*       96       OPTION ERROR
     F*
     F********************************************************************
      /EJECT
     F*FSTART
      ************************************************************
     FSDDEALL1  IF   E           K DISK    USROPN
      * IN  - @BNREEI Dealing Data Cde(DLDA)
      ************************************************************
      /EJECT
     D*ESTART
      ************************************************************
     D*                                                                   S01230
      * Description     : Copyright notice for inclusion in all programs
     D********************************************************************S01230
      ************************************************************
      /EJECT
     D*ISTART
      ************************************************************
      * Description     : Copyright notice for inclusion in all programs
     D*                                                                   S01230
     D A@CPY           DS                                                       S01230
      * Copyright array
     D  CPY@                   1     80                                         S01230
     D                                     DIM(1) CTDATA PERRCD(1)
     D*                                                                   S01230
     D P@MGDA          DS
     D  @MG                    1     50
     D                                     DIM(1) CTDATA PERRCD(1)
      *
     D PGMDS          SDS
      * Program Status data structure
     D  PGNAME                 1     10
     D  PGLIBR                81     90
     D  PGJBNM               244    253
     D  PGUSER               254    263
     D  PGJBNO               264    269  0
      *
     D***********D@FMT     E DSSDDEALD0                                   S01230
     D D@FMT         E DS                  EXTNAME(SDDEALPD)                    S01230
      * @BNREEI - Dealing Data Record Format Data Structure
      *
     D P@FMT         E DS                  EXTNAME(DSFDY)                       S01230
     I* External Data structure to hold the outgoing record format        S01230
     I* of the file.                                                      S01230
      *                                                                   S01230
     I********P@FMT       DS                             67               S01230
     I********                               67  67 P@DMMY                S01230
      *
      * Copy of Record Format Data Structure to be Passed Back
      * to the Calling Program After 1st Call.
      *
      *
      ************************************************************
      /EJECT
     C*CSTART
      *****************************************************
     C     *ENTRY        PLIST
     C     W@RTCD        PARM                    P@RTCD            7            B:Return code
     C                   PARM                    P@OPTN            7            I:Option
     C                   PARM      D@FMT         P@FMT                          O:Format
      *****************************************************
      *MAIN
     C                   SETOFF                                       909192     ¦ Reset
     C                   SETOFF                                       9396       ¦ error flags
      *
      * First call - open file - read record - close file
      *
      * Subsequent calls will return the format.
      *
     C     P@OPTN        IFEQ      '*FIRST  '                                   IF 1  VALID
     C     P@OPTN        OREQ      '*NEXT   '                                         OPTION
     C     P@OPTN        OREQ      '*PREV   '                                         HAS
     C     P@OPTN        OREQ      '*LAST   '                                         BEEN
     C     P@OPTN        OREQ      '*KEY    '                                         ENTERED
     C     P@OPTN        OREQ      '*FREE   '
     C     P@OPTN        OREQ      '*SAME   '
     C     P@OPTN        OREQ      '*VERIFY '
     C     *IN01         IFEQ      '0'                                          IF 2 FIRST TIME
     C                   SETON                                        01          Set ind.
     C                   OPEN      SDDEALL1                             91        Open file
     C     *IN91         CABEQ     '1'           T@SKIP                   LR      Open error
     C                   READ      @BNREEI                              9093      Read record
     C                   CLOSE     SDDEALL1                             92        Close file
     C     *IN92         CABEQ     '1'           T@SKIP                   LR      Close error
     C     *IN93         CABEQ     '1'           T@SKIP                   LR      Empty error
     C                   SETON                                        LR          Set ind.
     C                   END                                                    FI 2
     C                   ELSE
     C                   SETON                                        96
     C                   END                                                    FI 1
      *
      * No record found or End of file - return error code :
      *          _____________
     C     T@SKIP        TAG                                                    +++ SKIP +++
      *          ~~~~~~~~~~~~~
     C                   MOVE      *BLANK        P@RTCD                         No Errors
     C   90              MOVE      '*ERROR '     P@RTCD                         File error
     C   91              MOVE      '*OPEN  '     P@RTCD                         Open error
     C   92              MOVE      '*CLOSE '     P@RTCD                         Close error
     C   93              MOVE      '*EMPTY '     P@RTCD                         Empty file
     C   96              MOVE      '*OPTION'     P@RTCD                         OPTION INVALID
      *
      * Caller requests message sent to program queue :
      *
     C     W@RTCD        IFEQ      '*MSG   '                                    IF 9 SEND MSG
     C     P@RTCD        ANDNE     *BLANK                                        AND ERROR
     C   90              MOVE      'ACO1001'     P@MGID                           File error
     C   91              MOVE      'ACO1002'     P@MGID                           Open error
     C   92              MOVE      'ACO1003'     P@MGID                           Close error
     C   93              MOVE      'ACO1004'     P@MGID                           Empty file
     C   96              MOVE      'ACO1007'     P@MGID                           OPTION INVAL
     C                   CALLB     'ZASNMG'                                       <SEND MSG>
     C                   PARM      *BLANK        W@RTCD            7              B:Return code
     C                   PARM      PGNAME        P@PGNM           10              I:Prog name
     C                   PARM      '*PRV'        P@DEST            5              I:Destination
     C                   PARM                    P@MGID            7              I:Msg ID
     C                   PARM      *BLANK        P@MSGF           10              I:Msg file
     C                   PARM      *BLANK        P@MGKY            4              O:Msg key
     C                   PARM                    P@MGDA           50              I:Msg data
     C                   PARM      '*DIAG'       P@MGTP            7              I:Msg type
     C                   END                                                    FI 9
      *
      * Caller Requests DB Error Handling
      *
     C     W@RTCD        IFEQ      '*DBERR '                                    IF
     C     P@RTCD        ANDNE     *BLANK                                         AND
     C                   DUMP
     C                   CALLB     'DBERRCTL'
     C                   END                                                    FI
      *
      * Return to caller :
      *
     C                   RETURN
      *
      *****************************************************
      *ENDMAIN
**CTDATA @MG
SDDEALPD  AODEALR0  Dealing Data Codes
**CTDATA CPY@
(c) Finastra International Limited 2001
