     H DEBUG
      *****************************************************************
/***D ***RPG***********************************************************   CAP002
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Deal sub-types')
     F********************************************************************
     F*                                                                  *
     F*  Midas  ACCESS OBJECTS
     F*                                                                  *
     F*     AODLSTR0 - DEAL SUB-TYPES                                    *
     F*                                                                  *
      *  (c) Finastra International Limited 2001                      *
     F*                                                                  *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002             Date 01May98               *
     F*                    S01461             DATE 11FEB94               *
     F*                    S01392             DATE 20JUL92               *
     F*                    S01230             DATE 09/01/90              *S01230
     F*                    S01230             DATE 23/11/89              *S01230
     F*                    S01230             DATE 06/11/89              *S01230
     F*                    E01168             DATE 14/02/89              *E01168
     F*                                                                  *
     F********************************************************************
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data                    *
      *  CAP002 - Member converted from an OPM program to an ILE      *
      *           module and an ILE *PGM member of the same name has  *
      *           been created (in AOPGMSRC).                         *
      *           ILE modules can make a bound call to the module.    *
      *           OPM programs can make a dynamic call to the *PGM.   *
     F*     S01461 - RECOMPILED OVER CHANGED SDDLSTPD.                   *
     F*     S01392 - JAP.SUB-MODULE INCORPORATION (CORE)                 *
     F*              PROGRAM RECOMPILED AS NEW FIELDS (ASFUID/ASFLID) ADDED
     F*     S01230 - STANDARDISE ACCESS PROGRAM & COPYRIGHT ADDED        *S01230
     F********************************************************************S01230
     F*                                                                  *
     F*        D F C H L   FUNCTION INDICATOR                            *
     F*                                                                  *
     F*        01     INITIALISATION                                     *
     F*        90     FILE ERROR                                         *
     F*        91     FILE OPEN ERROR                                    *
     F*        92     FILE CLOSE ERROR                                   *
     F*        93     FILE EMPTY                                         *
     F*        94     END OF FILE                                        *
     F*        95     NO RECORD FOUND                                    *
     F*        96     OPTION ERROR                                       *
     F*        97     NO SELECTION                                       *
     F*        98     ERROR ON CALL OF SELECTION PROGRAM(SDMISRR)        *
     F*                                                                  *
     F********************************************************************
      /EJECT
     F*FSTART
      ************************************************************
     FSDDLSTL1  IF   E           K DISK    USROPN
      * IN  - @ASRECO Deal Sub-types   (KEY)
     FGPDLSTL1  IF   E           K DISK    USROPN                                             CSD031
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
     D********D@FMT     E DSSDDLSTD0                                      S01230
     D D@FMT         E DS                  EXTNAME(SDDLSTPD)                    S01230
      * @ASRECO - Deal Sub-types record format data structure
      *
     D P@FMT         E DS                  EXTNAME(DSFDY)                       S01230
     D* External Data structure to hold the outgoing record format        S01230
     D* of the file.                                                      S01230
      *                                                                   S01230
     D*********P@FMT       DS                                             S01230
     D*********                               1  36 P@DMMY                S01230
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSD031
      ** Switchable Features file                                                             CSD031
      *                                                                                       CSD031
     D P@DSTC          DS
      * Key slicing data structure (for Record Selection)
     D  W@SL01                 1      1
     D  W@SL02                 2      2
      *
      ************************************************************
      /EJECT
     C*CSTART
      *****************************************************
     C     *ENTRY        PLIST
     C     W@RTCD        PARM                    P@RTCD            7            B:Return code
     C                   PARM                    P@OPTN            7            I:Option
     C*                    PARM           P@DSTC  2        I:Dl sub-typ cdE01168
     C                   PARM                    P@DSTC                         I:Dl sub-typ cdE0116
     C                   PARM                    P@FMT                          O:Format
      *****************************************************
      *MAIN
      *
     C     P@OPTN        IFEQ      '*SAME  '
     C     *IN01         COMP      '0'                                    91
     C                   GOTO      T@SKIP
     C                   END
      *
     C                   SETOFF                                       909192     ¦ Reset
     C                   SETOFF                                       939495     ¦ error
     C                   SETOFF                                       969798     ¦ indicators
      *                                                                                       CSD031
      ** Check if Enhanced Centralised Static Data is installed                               CSD031
      *                                                                                       CSD031
     C                   CALL      'AOSARDR0'                                                 CSD031
     C                   PARM      *BLANKS       PRTCD             7                          CSD031
     C                   PARM      '*VERIFY'     POPTN             7                          CSD031
     C                   PARM      'CSD031'      PSAR              6                          CSD031
     C     SCSARD        PARM      SCSARD        P@FMT                                        CSD031
      *                                                                                       CSD031
     C     PRTCD         IFEQ      *BLANKS                                                    CSD031
     C                   MOVE      'Y'           CSD031            1                          CSD031
     C                   ELSE                                                                 CSD031
     C                   MOVE      'N'           CSD031                                       CSD031
     C                   ENDIF                                                                CSD031
     C*
      *
      * First call - open file :
      *
     C     *IN01         IFEQ      '0'                                          IF 1 FIRST TIME
     C                   SETON                                        01          Set ind.
     C     CSD031        IFEQ      'Y'                                                        CSD031
     C     *INU1         ANDEQ     *ON                                                        CSD031
     C                   OPEN      GPDLSTL1                             91                    CSD031
     C                   ELSE                                                                 CSD031
     C                   OPEN      SDDLSTL1                             91        Open file
     C                   ENDIF                                                                CSD031
     C     *IN91         CABEQ     '1'           T@SKIP                   LR      Open error
     C                   END                                                    FI 1
      *
      * Last call - close file and terminate program :
      *
     C     P@OPTN        IFEQ      '*FREE  '                                    IF 2 FREE PGM
     C     CSD031        IFEQ      'Y'                                                        CSD031
     C     *INU1         ANDEQ     *ON                                                        CSD031
     C                   CLOSE     GPDLSTL1                             92                    CSD031
     C                   ELSE                                                                 CSD031
     C                   CLOSE     SDDLSTL1                             92        Close file
     C                   ENDIF                                                                CSD031
     C     *IN92         CABEQ     '1'           T@SKIP                   LR      Close error
     C                   SETON                                        LR          Set ind.
     C                   END                                                    FI 2
      *
      * Caller requests first record :
      *
     C     P@OPTN        IFEQ      '*FIRST '                                    IF 3 FIRST REC
     C     CSD031        IFEQ      'Y'                                                        CSD031
     C     *INU1         ANDEQ     *ON                                                        CSD031
     C     *LOVAL        SETLL     SDDLSTD0                           9390                    CSD031
     C                   ELSE                                                                 CSD031
     C     *LOVAL        SETLL     @ASRECO                            9390        Set file
     C                   ENDIF                                                                CSD031
     C     *IN93         CABEQ     '1'           T@SKIP                           Empty file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      '*NEXT  '     P@OPTN                           Force *Next
     C                   END                                                    FI 3
      *
      * Caller requests next record :
      *
     C     P@OPTN        IFEQ      '*NEXT  '                                    IF 4 NEXT REC
     C     CSD031        IFEQ      'Y'                                                        CSD031
     C     *INU1         ANDEQ     *ON                                                        CSD031
     C                   READ      SDDLSTD0                             9094                  CSD031
     C                   ELSE                                                                 CSD031
     C                   READ      @ASRECO                              9094      Read record
     C                   ENDIF                                                                CSD031
     C     *IN94         CABEQ     '1'           T@SKIP                           End of file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 4
      *
      * Caller requests last record :
      *
     C     P@OPTN        IFEQ      '*LAST  '                                    IF 5 LAST REC
     C     CSD031        IFEQ      'Y'                                                        CSD031
     C     *INU1         ANDEQ     *ON                                                        CSD031
     C     *HIVAL        SETGT     SDDLSTD0                             90                    CSD031
     C                   ELSE                                                                 CSD031
     C     *HIVAL        SETGT     @ASRECO                              90        Set file
     C                   ENDIF                                                                CSD031
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      '*PREV  '     P@OPTN                           Force *Prev
     C                   END                                                    FI 5
      *
      * Caller requests previous record :
      *
     C     P@OPTN        IFEQ      '*PREV  '                                    IF 6 PREV.REC
     C     CSD031        IFEQ      'Y'                                                        CSD031
     C     *INU1         ANDEQ     *ON                                                        CSD031
     C                   READP     SDDLSTD0                             9094                  CSD031
     C                   ELSE                                                                 CSD031
     C                   READP     @ASRECO                              9094      Read record
     C                   ENDIF                                                                CSD031
     C     *IN94         CABEQ     '1'           T@SKIP                           End of file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 6
      *
      * Caller requests record indicated by key :
      *
     C     P@OPTN        IFEQ      '*KEY   '                                    IF 7 KEY ACCESS
     C     P@OPTN        OREQ      '*VERIFY'                                     OR
     C     W@SL01        IFEQ      '?'                                          IF 8 SELECT
     C     W@SL02        OREQ      '?'                                           OR
     C*********************CALL 'SDMISRR'              98    <SELECT>     S01230
     C                   CALL      'SD0250S'                            98        <SELECT>     S0123
     C                   PARM      *BLANK        P@RTC2            7              B:Return code
     C                   PARM      *BLANK        P@DSTC                           B:Key
     C     P@RTC2        COMP      *BLANK                             97          No selection
     C     *IN97         CABEQ     '1'           T@SKIP                           No selection
     C     *IN98         CABEQ     '1'           T@SKIP                           Program error
     C                   END                                                    FI 8
     C     CSD031        IFEQ      'Y'                                                        CSD031
     C     *INU1         ANDEQ     *ON                                                        CSD031
     C     P@DSTC        CHAIN     SDDLSTD0                           9590                    CSD031
     C                   ELSE                                                                 CSD031
     C     P@DSTC        CHAIN     @ASRECO                            9590        Get record
     C                   ENDIF                                                                CSD031
     C     *IN95         CABEQ     '1'           T@SKIP                           No rec found
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 7
      *
     C     P@OPTN        IFNE      '*KEY   '                                    IF 8 NOT KEYED
     C     P@OPTN        ANDNE     '*NEXT  '                                     AND NOT SEQ.
     C     P@OPTN        ANDNE     '*PREV  '                                     AND
     C     P@OPTN        ANDNE     '*VERIFY'                                     AND
     C     P@OPTN        ANDNE     '*FREE  '                                     AND
     C                   SETON                                          96        Parm error
     C                   END                                                    FI 8
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
     C   94              MOVE      '*EOF   '     P@RTCD                         End of file
     C   95              MOVE      '*NRF   '     P@RTCD                         No record found
     C   96              MOVE      '*OPTION'     P@RTCD                         Option error
     C   97              MOVE      '*NOSEL '     P@RTCD                         No selection
     C   98              MOVE      '*CALL  '     P@RTCD                         Called Pgm.err.
      *
      * Caller requests message sent to program queue :
      *
     C     W@RTCD        IFEQ      '*MSG   '                                    IF 9 SEND MSG
     C     P@RTCD        ANDNE     *BLANK                                        AND ERROR
     C   90              MOVE      'ACO1001'     P@MGID                           File error
     C   91              MOVE      'ACO1002'     P@MGID                           Open error
     C   92              MOVE      'ACO1003'     P@MGID                           Close error
     C   93              MOVE      'ACO1004'     P@MGID                           Empty file
     C   94              MOVE      'ACO1005'     P@MGID                           End of file
     C   95              MOVE      'ACO1006'     P@MGID                           No rec found
     C   96              MOVE      'ACO1007'     P@MGID                           Option error
     C   97              MOVE      'ACO1009'     P@MGID                           No selection
     C   98              MOVE      'ACO1010'     P@MGID                           Call error
     C                   CALLB     'ZASNMG'                                       <SEND MSG>
     C                   PARM      *BLANK        W@RTCD            7              B:Return code
     C                   PARM      PGNAME        P@PGNM           10              I:Pgm name
     C                   PARM      '*PRV'        P@DEST            5              I:Destination
     C                   PARM                    P@MGID            7              I:Message ID
     C                   PARM      *BLANK        P@MSGF           10              I:Msg file
     C                   PARM      *BLANK        P@MGKY            4              O:Message key
     C                   PARM                    P@MGDA                           I:Msg data
     C                   PARM      '*DIAG'       P@MGTP            7              I:Msg type
     C                   END                                                    FI 9
      *
      * Caller requests DB error handling
      *
     C     W@RTCD        IFEQ      '*DBERR '                                    IF 10
     C     P@RTCD        ANDNE     *BLANK                                        AND
     C                   DUMP
     C                   CALLB     'DBERRCTL'
     C                   END                                                    FI 10
      *
     C     P@OPTN        IFNE      '*VERIFY'                                    IF 11
     C     P@OPTN        ANDNE     '*FREE  '                                     AND
     C*          P@OPTN    ANDNE'*OPTION'                   AND           E01168
     C     P@RTCD        ANDNE     '*OPTION'                                     AND           E0116
     C                   MOVEL     D@FMT         P@FMT
     C                   END                                                    FI 11
      *
      * Return to caller :
      *
     C                   RETURN
      *
      *****************************************************
      *ENDMAIN
**CTDATA @MG
SDDLSTL1  AODLSTR0  Deal sub-type codes
**CTDATA CPY@
(c) Finastra International Limited 2001
