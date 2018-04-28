     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Nostro details access object')                *
      *****************************************************************
      *                                                               *
      *  Midas - Access Object Module                                 *
      *                                                               *
      *  AONOSTR1  - Read Access to Nostro Details File               *
      *                                                               *
      *  Function:This module will read or access the Nostro Details  *
      *           in consideration of the additional fields which the *
      *           original AONOSTR0 cannot hold. This program uses an *
      *           external data structure DSSDY defined as 800 in     *
      *           length as compared to the  DSFDY which is 200 in    *
      *           length.                                             *
      *                                                               *
      *           *NOTE: Newly developed or amended programs accessing*
      *                  Nostro Details should use this module as a   *
      *                  replacement for the old access object.       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. CDL094  *CREATE    Date 30May14               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Functions of Indicators                                      *
      *                                                               *
      *       01      OFF 1ST TIME ROUND                              *
      *       26      QUESTION MARK IN KEY FIELDS                     *
      *       90      FILE ERROR                                      *
      *       91      FILE OPEN ERROR                                 *
      *       92      ERROR ON FILE CLOSE                             *
      *       93      FILE EMPTY                                      *
      *       94      EOF                                             *
      *       95      NO RECORD FOUND                                 *
      *       96      PARAMETER ERROR                                 *
      *       LR      LAST RECORD                                     *
      *                                                               *
      *****************************************************************
      /EJECT
     F*FSTART
      *
     FSDNOSTL0  IF   E           K DISK    USROPN
      * IN  - @A7REBE Nostros          (CYCD¦NONB)
     FSDNOSTL2  IF   E           K DISK    USROPN
      * IN  - @NOSTBH Nostros          (CUST¦CYCD¦ACCD¦ACSN¦BRCD)
     FSDNOSTL6  IF   E           K DISK    USROPN
      * IN  - @NOSTIG                  (CUST¦CYCD¦PNOI)
      ************************************************************
      /EJECT
     D*DSTART
     D @QM             S              1    DIM(5) ASCEND
      *
      * Description     : Copyright notice for inclusion in all programs
     D A@CPY           DS
      * Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
      *
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
     D D@FMT         E DS                  EXTNAME(SDNOSTPD)
      * @A7REBE - Nostro record format data structure
      *
     D P@FMT         E DS                  EXTNAME(DSSDY)
      *
     D P@ACSN          DS
      * Account Sequence character->zoned conversion data structure
      *
     D  W@ACSN                 1      2  0
      *
     D P@KEYS          DS
     D  WUCYCD                 1      3
     D  WUNONB                 4      5
      *
      ************************************************************
      /EJECT
     C*CSTART
      *****************************************************
     C     *ENTRY        PLIST
     C     W@RTCD        PARM                    P@RTCD            7            B:Return code
     C                   PARM                    P@OPTN            7            I:Option
     C                   PARM                    P@CUST            6            I:Customer No
     C                   PARM                    P@CYCD            3            I:Currency
     C                   PARM                    P@ACCD           10
     C                   PARM                    P@ACSN            2            I:A/c Seq
     C                   PARM                    P@NONB            2            I:Nostro No
     C                   PARM                    P@BRCD            3            I:Branch Code
     C                   PARM                    P@CSSN           10            I:Cust ShortN
     C                   PARM                    P@PNOI            1            I:Prime Nost In
     C                   PARM                    P@FMT                          O:Format
      *****************************************************
      *MAIN
     C     K@CSPN        KLIST
     C                   KFLD                    P@CSSN                           Cust ShNam
     C                   KFLD                    P@CYCD                           Currency
     C                   KFLD                    P@PNOI                           Prime Nost In
      *
     C     K@A7RE        KLIST                                                  Nostro ID
     C                   KFLD                    P@CYCD                           Currency
     C                   KFLD                    P@NONB                           Nostro No.
      *                                                                   S01230
     C     K@NOST        KLIST                                                  Account ID
     C                   KFLD                    P@CUST                           Customer
     C                   KFLD                    P@CYCD                           Currency
     C                   KFLD                    P@ACCD                           Acc.code
     C                   KFLD                    W@ACSN                           Acc.seq.
     C                   KFLD                    P@BRCD                           Branch code
      *
     C/COPY WNCPYSRC,AONOSTR1C1
      *
      * Access Option *SAME input
      *
     C     P@OPTN        IFEQ      '*SAME '
     C     *IN01         COMP      '0'                                    91
     C     *IN02         IFEQ      '1'
     C                   SETOFF                                       91
     C                   END
     C                   GOTO      T@SKIP
     C                   END
      *
     C                   SETOFF                                       506070     ¦
     C                   SETOFF                                       909192     ¦ Reset
     C                   SETOFF                                       939495     ¦ error
     C                   SETOFF                                       969798     ¦ indicators
      *
      *
      * Check file to use :
      *
     C     P@CUST        IFNE      *BLANK                                       IF    ¦FULL
     C     P@CYCD        ANDNE     *BLANK                                        AND  ¦ACCOUNT
     C     P@ACCD        ANDNE     *BLANK                                        AND  ¦ID
     C     P@ACSN        ANDNE     *BLANK                                        AND
     C     P@BRCD        ANDNE     *BLANK                                        AND
     C                   SETON                                        50          Set ind.
     C                   END                                                    FI
      *
     C     *IN50         IFNE      '1'                                          IF 1 --.
     C     P@CYCD        IFNE      *BLANK                                       IF 2 -.NOSTRO
     C     P@NONB        ANDNE     *BLANK                                        AND  ¦ID
     C                   SETON                                        60          Set ind.
     C                   END                                                    FI 2 -'¦
     C                   END                                                    FI 1 --'
      *
     C     *IN50         IFNE      '1'                                          IF 1
     C     *IN60         ORNE      '1'
     C     P@CSSN        IFNE      *BLANK                                       IF 2 -.
     C     P@CYCD        ANDNE     *BLANK                                        AND  ¦
     C                   SETON                                        70          Set ind.
     C                   END                                                    FI 2 -'
     C                   END                                                    FI 1
      *                                                                   S01230
     C     P@OPTN        IFEQ      '*KEY   '                                    IF 1
     C     *IN50         IFEQ      '0'                                            IF 2
     C     *IN60         ANDEQ     '0'
     C     *IN70         ANDEQ     '0'
     C                   SETON                                        97
     C                   GOTO      T@SKIP
     C                   END                                                      FI 2
     C                   END                                                    FI 1
      *                                                                   S01230
     C     P@OPTN        IFNE      '*KEY   '                                    IF NOT KEYED
     C     P@OPTN        ANDNE     '*VERIFY'                                      OR
     C                   SETOFF                                       5070
     C                   SETON                                        60
     C                   END                                                    FI
      *
      * First call - open file :
      *
     C     *IN01         IFEQ      '0'                                          IF   FIRST TIME
     C     *IN50         ANDEQ     '1'                                           AND ACC.ACCESS
     C                   SETON                                        01          Set ind.
     C                   OPEN      SDNOSTL2                             91        Open file
     C     *IN91         CABEQ     '1'           T@SKIP                   LR      Open error
     C                   END                                                    FI
      *
     C     *IN02         IFEQ      '0'                                          IF   FIRST TIME
     C     *IN60         ANDEQ     '1'                                           AND NOSTRO ACC
     C                   SETON                                        02          Set ind.
     C                   OPEN      SDNOSTL0                             91        Open file
     C     *IN91         CABEQ     '1'           T@SKIP                   LR      Open error
     C                   END                                                    FI
      *                                                                   S01230
     C     *IN03         IFEQ      '0'                                          IF   FIRST TIME
     C     *IN70         ANDEQ     '1'                                           AND ACC ACCESS
     C                   SETON                                        03          Set ind.
     C                   OPEN      SDNOSTL6                             91        Open file
     C     *IN91         CABEQ     '1'           T@SKIP                   LR      Open error
     C                   END                                                    FI
      *
      * Last call - close files and terminate program :
      *
     C     P@OPTN        IFEQ      '*FREE  '                                    IF FREE PROGORD
     C   01              CLOSE     SDNOSTL2                             92        Close file
     C     *IN92         CABEQ     '1'           T@SKIP                   LR      Close error
     C   02              CLOSE     SDNOSTL0                             92        Close file
     C     *IN92         CABEQ     '1'           T@SKIP                   LR      Close error
     C   03              CLOSE     SDNOSTL6                             92        Close file
     C     *IN92         CABEQ     '1'           T@SKIP                   LR      Close error
     C                   SETON                                        LR          Set ind.
     C                   END                                                    FI
      *
      * Caller requests first record :
      *
     C     P@OPTN        IFEQ      '*FIRST '                                    IF FIRST RECORD
     C     *LOVAL        SETLL     @A7REBE                            9390        Set file
     C/COPY WNCPYSRC,AONOSTR1C2
     C     *IN93         CABEQ     '1'           T@SKIP                           Empty file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      '*NEXT  '     P@OPTN                           Force *Next
     C                   END                                                    FI
      *
      * Caller requests next record :
      *
     C     P@OPTN        IFEQ      '*NEXT  '                                    IF NEXT RECORD
     C                   READ      @A7REBE                              9094      Read record
     C     *IN94         CABEQ     '1'           T@SKIP                           End of file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI
      *
      * Caller requests last record :
      *
     C     P@OPTN        IFEQ      '*LAST  '                                    IF LAST RECORD
     C     *HIVAL        SETGT     @A7REBE                              90        Set file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      '*PREV  '     P@OPTN                           Force *Prev
     C                   END                                                    FI
      *
      * Caller requests previous record :
      *
     C     P@OPTN        IFEQ      '*PREV  '                                    IF PREV.RECORD
     C                   READP     @A7REBE                              9094      Read record
     C/COPY WNCPYSRC,AONOSTR1C3
     C     *IN94         CABEQ     '1'           T@SKIP                           End of file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI
      *
      * Caller requests record indicated by key :
      *
     C     P@OPTN        IFEQ      '*KEY   '                                    IF 7 KEYED ACCESS
     C     P@OPTN        OREQ      '*VERIFY'                                    OR
     C                   MOVEL     P@CYCD        WUCYCD
     C                   MOVEL     P@NONB        WUNONB
     C                   MOVEA     P@KEYS        @QM
     C                   MOVEL     '?'           QMCHK             1
     C     QMCHK         LOOKUP    @QM                                    26      CHECK ?
     C     *IN26         IFEQ      '1'                                          IF 8 selection
     C                   CALL      'SD0151S'                            98        <SELECT>
     C                   PARM      *BLANK        P@RTC2            7              B:Return code
     C                   PARM      *BLANK        P@CYCD                           B:Currency
     C                   PARM      *BLANK        P@NONB                           B:Nostro No
     C     P@RTC2        COMP      *BLANK                             97          No selection
     C     *IN97         CABEQ     '1'           T@SKIP                           No selection
     C     *IN98         CABEQ     '1'           T@SKIP                           Program error
     C                   END
     C   60K@A7RE        CHAIN     @A7REBE                            9590        Get record
     C   50K@NOST        CHAIN     @NOSTBH                            9590        Get record
     C   70K@CSPN        CHAIN     @NOSTIG                            9590        Get record
     C     *IN95         CABEQ     '1'           T@SKIP                           No record found
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C/COPY WNCPYSRC,AONOSTR1C4
     C                   END                                                    FI 7
      *
      * Check option :
      *
     C     P@OPTN        IFNE      '*KEY   '                                    IF 10 NOT KEYED
     C     P@OPTN        ANDNE     '*NEXT  '                                     AND NOT SEQ.
     C     P@OPTN        ANDNE     '*PREV  '                                     AND
     C     P@OPTN        ANDNE     '*VERIFY'                                     AND
     C     P@OPTN        ANDNE     '*FREE  '                                     AND
     C                   SETON                                          96        Parameter error
     C                   END                                                    FI 10
      *          _____________
     C     T@SKIP        TAG                                                    +++ SKIP +++
      *          ~~~~~~~~~~~~~
      * No record found or End of file - return error code :
      *
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
     C     W@RTCD        IFEQ      '*MSG   '                                    IF 11 SEND MSG.
     C     P@RTCD        ANDNE     *BLANK                                        AND ERROR
     C   90              MOVE      'ACO1001'     P@MGID                           File error
     C   91              MOVE      'ACO1002'     P@MGID                           Open error
     C   92              MOVE      'ACO1003'     P@MGID                           Close error
     C   93              MOVE      'ACO1004'     P@MGID                           Empty file
     C   94              MOVE      'ACO1005'     P@MGID                           End of file
     C   95              MOVE      'ACO1006'     P@MGID                           No record found
     C   96              MOVE      'ACO1007'     P@MGID                           Option error
     C   97              MOVE      'ACO1009'     P@MGID                           No selection
     C   98              MOVE      'ACO1010'     P@MGID                           Call error
     C                   CALLB     'ZASNMG'                                       <SEND MESSAGE>
     C                   PARM      *BLANK        W@RTCD            7              B:Return code
     C                   PARM      PGNAME        P@PGNM           10              I:Program name
     C                   PARM      '*PRV'        P@DEST            5              I:Destination
     C                   PARM                    P@MGID            7              I:Message ID
     C                   PARM      *BLANK        P@MSGF           10              I:Message file
     C                   PARM      *BLANK        P@MGKY            4              O:Message key
     C                   PARM                    P@MGDA           50              I:Message data
     C                   PARM      '*DIAG'       P@MGTP            7              I:Message type
     C                   END                                                    FI 11
      *
      * Caller Requests DB Error Handling
      *
     C     W@RTCD        IFEQ      '*DBERR '                                    IF
     C     P@RTCD        ANDNE     *BLANK                                         AND
     C                   DUMP
     C                   CALLB     'DBERRCTL'
     C                   END                                                    FI
      *
     C     P@OPTN        IFNE      '*VERIFY'                                    IF 13
     C     P@OPTN        ANDNE     '*FREE  '                                      AND
     C     P@RTCD        ANDNE     '*OPTION'                                      AND
     C                   MOVEL     D@FMT         P@FMT                          FI 13
     C                   END
      *
      *
      * Return to caller :
      *
     C                   RETURN
      *
      *****************************************************
      *ENDMAIN
**CTDATA @MG
SDNOSTPD  AONOSTR1  Nostro Details
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2014
