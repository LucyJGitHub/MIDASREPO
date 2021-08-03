     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD055891
/*STD *  RPGSQLBND                                                    *                     MD055891
/*EXI *  TEXT('Midas CB Set up todays run conditions')                *
     F*****************************************************************
     F*                                                               *
     F*  Midas - Close of Business Processing                     *
     F*                                                               *
     F*  CB0800 - SET UP TODAY'S RUN CONDITIONS                       *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. MD055891           Date 01Sep20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 AR674247           Date 18Dec14               *
      *                 CSC051             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CER001             Date 25Apr05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 133648             Date 15Apr98               *
      *                 114010             Date 14Apr97               *
     F*                 097337             DATE 11APR97               *
     F*                 S01502             DATE 11DEC94               *
     F*                 S01488             DATE 15APR94               *
     F*                                                               *
     F*****************************************************************
      *                                                               *
      *  MD055891 - Deliverable Data Split for COB                    *
      *  MD046248 - Finastra Rebranding                               *
      *  AR674247 - Introduce calendar year end run condition 81.     *
      *           - Applied for MD031576                              *
      *  CSC051 - Frequent run of COB historic drop components        *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  133648 - Add Run Condition for Every Monday, Tuesday etc.    *
      *  114010 - Spot Revals being posted twice. Run condition 09    *
      *           (used for GLC35B) should only happen on non-accrual *
      *           days.  i.e. when ACCR = 1.                          *
      *  097337 - Run condition 24 not conditioned on EOM.            *
      *  S01502 - BLI Telekurs Processing.                            *
      *           Recompiled as SESTAT increased to 133 long          *
      *  S01488 - CREATED FOR COB RUN CONDITIONS ENHANCEMENTS         *
      *                                                               *
     F*****************************************************************
     F*                                                               *
     F*CBRUNCL1* IF   E           K DISK                                                    MD055891
      /EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D*
     D** Array containing Copyright statement
     D*
     D FRQ             S              1    DIM(99)                              Run conditions
     D/COPY WNCPYSRC,CB0800E001
     D DLSTAT        E DS                  EXTNAME(DLSTAT)
     D  DLCONT       E                     EXTFLD(DLACKEY)
     D  ZZ10DL       E                     EXTFLD(ZZ10)
     D  FRPRDL       E                     EXTFLD(FRPR)
      *
      *    Revaluation and Hong Kong interest flags
      *
     D GLSTAT        E DS                  EXTNAME(GLSTAT)
      *
      *    Spot revaluations required flag
      *
     D SDSTAT        E DS                  EXTNAME(SDSTAT)
      *
      *    Type of end of day
      *
     D SESTAT        E DS                  EXTNAME(SESTAT)
      *
      *    Securities Trading options flags
      *
     D  EOMSE        E                     EXTFLD(EOM)
     D/COPY WNCPYSRC,CB0800I001
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *                                                                                       CER001
      ** Switchable features file                                                             CER001
      *                                                                                       CER001
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *                                                                                       CER001
      ** First DS for access programs, short data structure                                   CER001
      *                                                                                       CER001
     D LDA             DS           256
      *                                                                                       CER001
      ** Local data area for database error details                                           CER001
      ** *LOCK IN LDA immediately before and OUT LDA immediately                              CER001
      ** after each database error handling.                                                  CER001
      *                                                                                       CER001
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
     D CBRUNC        E DS                  EXTNAME(CBRUNJW0)                                MD055891
      *                                                                                       CER001
     C     *ENTRY        PLIST
      *
      *    Initialise run condition string to pass to CBRUN
      *
     C                   PARM                    FRQLST           99
     C                   MOVE      'N'           FRQ
     C*
     C** Set up copyright parameter
     C*
     C                   MOVEA     CPY@          BIS@             80
      *                                                                                       CER001
      ** Prepare LDA                                                                          CER001
      *                                                                                       CER001
     C     *DTAARA       DEFINE                  LDA
      *                                                                                       CER001
     C                   MOVE      'N'           ULX043            1
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'ULX043'      WSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CER001
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF    '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE                         ***************
     C                   Z-ADD     01            DBASE                          * DB ERROR 01 *
     C                   MOVEL     'ULX043'      DBKEY                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CER001
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           ULX043
     C                   ENDIF
      *
      *    Retrieve flags from data areas then unlock to prevent errors
      *
     C     *DTAARA       DEFINE                  DLSTAT
     C     *DTAARA       DEFINE                  GLSTAT
     C     *DTAARA       DEFINE                  SDSTAT
     C     *DTAARA       DEFINE                  SESTAT
     C                   IN        DLSTAT
     C                   IN        GLSTAT
     C                   IN        SDSTAT
     C                   IN        SESTAT
     C                   UNLOCK    *DTAARA
      *
      *    Run conditions 01 to 31 must always be checked for
      *
     C                   EXSR      RCON01
     C                   EXSR      RCON02
     C                   EXSR      RCON03
     C                   EXSR      RCON04
     C                   EXSR      RCON05
     C                   EXSR      RCON06
     C                   EXSR      RCON07
     C                   EXSR      RCON08
     C                   EXSR      RCON09
     C                   EXSR      RCON10
     C                   EXSR      RCON11
     C                   EXSR      RCON12
     C                   EXSR      RCON13
     C                   EXSR      RCON14
     C                   EXSR      RCON15
     C                   EXSR      RCON16
     C                   EXSR      RCON17
     C                   EXSR      RCON18
     C                   EXSR      RCON19
     C                   EXSR      RCON20
     C                   EXSR      RCON21
     C                   EXSR      RCON22
     C                   EXSR      RCON23
     C                   EXSR      RCON25
     C                   EXSR      RCON32                                                      13364
     C                   EXSR      RCON40
      *                                                                   133648
      *****Run*conditions*32*-*99*are*not*yet*defined.*The*following*code 133648
      *****allows*for*their*later*introduction.*32*to*79*are*reserved*for 133648
      *    Run conditions 39 - 99 are not yet defined. The following code 133648
      *    allows for their later introduction. 39 to 79 are reserved for 133648
      *    core use and 80 to 99 are reserved for client/regional use.
      *
     C***********          MOVE '32'      RUNCKY  2                       133648
     C                   MOVE      '39'          RUNCKY            2                           13364
     C*****RUNCKY        SETLL     CBRUNCL1                                                 MD055891
     C**********         READ      CBRUNCL1                               90                MD055891
     C/EXEC SQL                                                                             MD055891
     C+ declare RCursor insensitive scroll cursor for                                       MD055891
     C+ select * from CBRUNJW0                                                              MD055891
     C+ where ANRUNC >= :RUNCKY                                                             MD055891
     C+ order by ANRUNC                                                                     MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ open RCursor                                                                        MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from RCursor into :CBRUNC                                                MD055891
     C/END-EXEC                                                                             MD055891
     C******IN90         DOWEQ     '0'                                                      MD055891
     C                   DOW       SQLCODE = 0                                              MD055891
      *
      *    If run condition is defined check if conditions have been met
      *
      ***        ANRUNC    CASEQ'xx'      RCONxx
     C     ANRUNC        CASEQ     '80'          RCON80
     C     ANRUNC        CASEQ     '81'          RCON81
     C     ANRUNC        CASEQ     '82'          RCON82
     C     ANRUNC        CASEQ     '83'          RCON83
     C     ANRUNC        CASEQ     '84'          RCON84
     C     ANRUNC        CASEQ     '85'          RCON85
     C     ANRUNC        CASEQ     '86'          RCON86
     C     ANRUNC        CASEQ     '87'          RCON87
     C     ANRUNC        CASEQ     '88'          RCON88
     C     ANRUNC        CASEQ     '89'          RCON89
     C     ANRUNC        CASEQ     '90'          RCON90
     C     ANRUNC        CASEQ     '91'          RCON91
     C     ANRUNC        CASEQ     '92'          RCON92
     C     ANRUNC        CASEQ     '93'          RCON93
     C     ANRUNC        CASEQ     '94'          RCON94
     C     ANRUNC        CASEQ     '95'          RCON95
     C     ANRUNC        CASEQ     '96'          RCON96
     C     ANRUNC        CASEQ     '97'          RCON97
     C     ANRUNC        CASEQ     '98'          RCON98
     C     ANRUNC        CASEQ     '99'          RCON99
     C                   ENDCS
     C**********         READ      CBRUNCL1                               90                MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from RCursor into :CBRUNC                                                MD055891
     C/END-EXEC                                                                             MD055891
     C                   ENDDO
      *
      *    Return run condition string to parameter
      *
     C                   MOVEA     FRQ           FRQLST
     C                   SETON                                        LR
     C                   RETURN
      *
      *******************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   END
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR     '*CANCL'
      *
      *******************************************************************
      /EJECT
      *******************************************************************
      *
      *    RCON01 SR - To set up run condition 01
      *
     C     RCON01        BEGSR
      *
     C                   MOVEA     'Y'           FRQ(1)
      *
     C                   ENDSR
      *
      *******************************************************************
      *
      *    RCON02 SR - To set up run condition 02
      *
     C     RCON02        BEGSR
      *
     C     ACCR          IFEQ      '2'
     C     ACCR          OREQ      '3'
     C                   MOVEA     'Y'           FRQ(2)
     C                   ENDIF
      *
     C                   ENDSR
      *
      *******************************************************************
      *
      *    RCON03 SR - To set up run condition 03
      *
     C     RCON03        BEGSR
      *
     C     ACCR          IFEQ      '3'
     C                   MOVEA     'Y'           FRQ(3)
     C                   ENDIF
      *
     C                   ENDSR
      *
      *******************************************************************
      *
      *    RCON04 SR - To set up run condition 04
      *
     C     RCON04        BEGSR
      *
      *    Not currently used in core Midas
      *
     C                   ENDSR
      *
      *******************************************************************
      *
      *    RCON05 SR - To set up run condition 05
      *
     C     RCON05        BEGSR
      *
     C     HKINT         IFEQ      'Y'
     C                   MOVEA     'Y'           FRQ(5)
     C                   ENDIF
      *
     C                   ENDSR
      *
      *******************************************************************
      *
      *    RCON06 SR - To set up run condition 06
      *
     C     RCON06        BEGSR
      *
     C     ACCR          IFEQ      '3'
     C     HKINT         ANDEQ     'Y'
     C                   MOVEA     'Y'           FRQ(6)
     C                   ENDIF
      *
     C                   ENDSR
      *
      *******************************************************************
      *
      *    RCON07 SR - To set up run condition 07
      *
     C     RCON07        BEGSR
      *
     C     FREVAL        IFEQ      'Y'
     C     FREVLP        ANDEQ     'Y'
     C                   MOVEA     'Y'           FRQ(7)
     C                   ENDIF
      *
     C                   ENDSR
      *
      *******************************************************************
      *
      *    RCON08 SR - To set up run condition 08
      *
     C     RCON08        BEGSR
      *
     C     FREVAL        IFEQ      'Y'
     C     FREVLP        ANDEQ     'N'
     C                   MOVEA     'Y'           FRQ(8)
     C                   ENDIF
      *
     C                   ENDSR
      *
      *******************************************************************
      *
      *    RCON09 SR - To set up run condition 09
      *
     C     RCON09        BEGSR
      *
     C     SREVAL        IFEQ      'Y'
     C     ACCR          ANDEQ     '1'                                                         11401
     C                   MOVEA     'Y'           FRQ(9)
     C                   ENDIF
     C/COPY WNCPYSRC,CB0800C001
      *
     C                   ENDSR
      *
      *******************************************************************
      *
      *    RCON10 SR - To set up run condition 10
      *
     C     RCON10        BEGSR
      *
     C                   CALL      'SD2000'
     C                   PARM      ' '           RUN               1
     C                   PARM      ' '           EOY               1
     C                   PARM      ' '           RTN               1
     C     RTN           CASEQ     'Y'           *PSSR
     C                   ENDCS
     C     RUN           IFEQ      'Y'
     C                   MOVE      'Y'           EOM               1
     C                   MOVEA     'Y'           FRQ(10)
     C                   ENDIF
      *
     C                   ENDSR
      *
      *******************************************************************
      *
      *    RCON11 SR - To set up run condition 11
      *
     C     RCON11        BEGSR
      *
     C     EOM           IFEQ      'Y'
     C     ACCR          IFEQ      '2'
     C     ACCR          OREQ      '3'
     C                   MOVEA     'Y'           FRQ(11)
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *
      *******************************************************************
      *
      *    RCON12 SR - To set up run condition 12
      *
     C     RCON12        BEGSR
      *
     C                   CALL      'CB0812'
     C                   PARM      ' '           BOM               1
     C                   PARM      'F'           RTN               1
     C     RTN           CASEQ     'F'           *PSSR
     C                   ENDCS
     C     BOM           IFEQ      'Y'
     C                   MOVEA     'Y'           FRQ(12)
     C     *LOCK         IN        GLSTAT
     C                   MOVE      'Y'           BOMI
     C                   OUT       GLSTAT
     C                   ENDIF
      *
     C                   ENDSR
      *
      *******************************************************************
      *
      *    RCON13 SR - To set up run condition 13
      *
     C     RCON13        BEGSR
      *
     C     EOM           IFEQ      'Y'
     C     ACCR          ANDEQ     '2'
     C                   MOVEA     'Y'           FRQ(13)
     C                   ENDIF
      *
     C                   ENDSR
      *
      *******************************************************************
      *
      *    RCON14 SR - To set up run condition 14
      *
     C     RCON14        BEGSR
      *
     C     EOM           IFEQ      'Y'
     C     ACCR          ANDEQ     '3'
     C                   MOVEA     'Y'           FRQ(14)
     C                   ENDIF
      *
     C                   ENDSR
      *
      *******************************************************************
      *
      *    RCON15 SR - To set up run condition 15
      *
     C     RCON15        BEGSR
      *
     C     BIOS          IFEQ      'Y'
     C                   MOVEA     'Y'           FRQ(15)
     C                   ENDIF
      *
     C                   ENDSR
      *
      *******************************************************************
      *
      *    RCON16 SR - To set up run condition 16
      *
     C     RCON16        BEGSR
      *
     C     AUOS          IFEQ      'Y'
     C                   MOVEA     'Y'           FRQ(16)
     C                   ENDIF
      *
     C                   ENDSR
      *
      *******************************************************************
      *
      *    RCON17 SR - To set up run condition 17
      *
     C     RCON17        BEGSR
      *
     C     PFPL          IFEQ      'Y'
     C                   MOVEA     'Y'           FRQ(17)
     C                   ENDIF
      *
     C                   ENDSR
      *
      *******************************************************************
      *
      *    RCON18 SR - To set up run condition 18
      *
     C     RCON18        BEGSR
      *
     C     PT9L          IFEQ      'Y'
     C                   MOVEA     'Y'           FRQ(18)
     C                   ENDIF
      *
     C                   ENDSR
      *
      *******************************************************************
      *
      *    RCON19 SR - To set up run condition 19
      *
     C     RCON19        BEGSR
      *
     C     PFPL          IFEQ      'Y'
     C     ACCR          ANDEQ     '3'
     C                   MOVEA     'Y'           FRQ(19)
     C                   ENDIF
      *
     C                   ENDSR
      *
      *******************************************************************
      *
      *    RCON20 SR - To set up run condition 20
      *
     C     RCON20        BEGSR
      *
     C     PT9L          IFEQ      'Y'
     C     ACCR          ANDEQ     '3'
     C                   MOVEA     'Y'           FRQ(20)
     C                   ENDIF
      *
     C                   ENDSR
      *
      *******************************************************************
      *
      *    RCON21 SR - To set up run condition 21
      *
     C     RCON21        BEGSR
      *
     C                   MOVE      '1'           RUN               1
     C                   CALL      'CB0821'
     C**********           PARM ' '       RUN     1                                           CSC051
     C                   PARM                    RUN
     C                   PARM      'F'           RTN               1
     C     RTN           CASEQ     'F'           *PSSR
     C                   ENDCS
     C     RUN           IFEQ      'Y'
     C                   MOVEA     'Y'           FRQ(21)
     C                   ENDIF
      *
     C                   ENDSR
      *
      *******************************************************************
      *
      *    RCON22 SR - To set up run condition 22
      *
     C     RCON22        BEGSR
      *
     C                   CALL      'SD2001'
     C                   PARM      ' '           RUN               1
     C                   PARM      ' '           RTN               1
     C     RTN           CASEQ     'Y'           *PSSR
     C                   ENDCS
     C     RUN           IFEQ      'Y'
     C                   MOVEA     'Y'           FRQ(22)
     C                   ENDIF
      *
     C                   ENDSR
      *
      *******************************************************************
      *
      *    RCON23 SR - To set up run conditions 23 and 24
      *
     C     RCON23        BEGSR
      *
     C                   CALL      'CB0823'
     C                   PARM      ' '           RUN               1
     C                   PARM      'F'           RTN               1
     C     RTN           CASEQ     'F'           *PSSR
     C                   ENDCS
     C     RUN           IFEQ      'Y'
     C                   MOVEA     'Y'           FRQ(23)
     C                   ENDIF
     C     RUN           IFEQ      'N'
     C     EOM           ANDEQ     'Y'                                                         09733
     C                   MOVEA     'Y'           FRQ(24)
     C                   ENDIF
      *
     C                   ENDSR
      *
      *******************************************************************
      *
      *    RCON25 SR - To set up run conditions 25 to 31
      *
     C     RCON25        BEGSR
      *
     C                   CALL      'CB0825'
     C                   PARM      ' '           RUN               1
     C                   PARM      'F'           RTN               1
     C     RTN           CASEQ     'F'           *PSSR
     C                   ENDCS
     C     RUN           IFEQ      '1'
     C                   MOVEA     'Y'           FRQ(25)
     C                   ENDIF
     C     RUN           IFEQ      '2'
     C                   MOVEA     'Y'           FRQ(26)
     C                   ENDIF
     C     RUN           IFEQ      '3'
     C                   MOVEA     'Y'           FRQ(27)
     C                   ENDIF
     C     RUN           IFEQ      '4'
     C                   MOVEA     'Y'           FRQ(28)
     C                   ENDIF
     C     RUN           IFEQ      '5'
     C                   MOVEA     'Y'           FRQ(29)
     C                   ENDIF
     C     RUN           IFEQ      '6'
     C                   MOVEA     'Y'           FRQ(30)
     C                   ENDIF
     C     RUN           IFEQ      '7'
     C                   MOVEA     'Y'           FRQ(31)
     C                   ENDIF
      *
     C                   ENDSR
      *
      *******************************************************************
      *                                                                   133648
      *    RCON32 SR - To set up run conditions 32 - 38                   133648
      *                                                                   133648
     C     RCON32        BEGSR                                                                 13364
     C*                                                                   133648
     C                   CALL      'CB0832'                                                    13364
     C                   PARM                    DAYNAM            3                           13364
     C*                                                                   133648
     C     DAYNAM        IFEQ      'MON'                                                       13364
     C                   MOVEA     'Y'           FRQ(32)                                       13364
     C                   ENDIF                                                                 13364
     C*                                                                   133648
     C     DAYNAM        IFEQ      'TUE'                                                       13364
     C                   MOVEA     'Y'           FRQ(33)                                       13364
     C                   ENDIF                                                                 13364
     C*                                                                   133648
     C     DAYNAM        IFEQ      'WED'                                                       13364
     C                   MOVEA     'Y'           FRQ(34)                                       13364
     C                   ENDIF                                                                 13364
     C*                                                                   133648
     C     DAYNAM        IFEQ      'THU'                                                       13364
     C                   MOVEA     'Y'           FRQ(35)                                       13364
     C                   ENDIF                                                                 13364
     C*                                                                   133648
     C     DAYNAM        IFEQ      'FRI'                                                       13364
     C                   MOVEA     'Y'           FRQ(36)                                       13364
     C                   ENDIF                                                                 13364
      *                                                                   133648
     C     DAYNAM        IFEQ      'SAT'                                                       13364
     C                   MOVEA     'Y'           FRQ(37)                                       13364
     C                   ENDIF                                                                 13364
      *                                                                   133648
     C     DAYNAM        IFEQ      'SUN'                                                       13364
     C                   MOVEA     'Y'           FRQ(38)                                       13364
     C                   ENDIF                                                                 13364
      *                                                                   133648
     C                   ENDSR                                                                 13364
      *                                                                   133648
      ******************************************************************* 133648
      /EJECT
      *******************************************************************                     CSC051
      *                                                                 *                     CSC051
      * RCON40 - Process RC 40 (Day followed by non-working day)        *                     CSC051
      * Calls     : None                                                *                     CSC051
      * Called by : Main                                                *                     CSC051
      *                                                                 *                     CSC051
      *******************************************************************                     CSC051
     C     RCON40        BEGSR
      *                                                                                       CSC051
     C                   MOVE      'A'           RUN
     C                   CALL      'CB0821'
     C                   PARM                    RUN
     C                   PARM      'F'           RTN
     C     RTN           CASEQ     'F'           *PSSR
     C                   ENDCS
     C     RUN           IFEQ      'Y'
     C                   MOVEA     'Y'           FRQ(40)
     C                   ENDIF
      *                                                                                       CSC051
     C                   ENDSR
      *                                                                                       CSC051
     C     RCON80        BEGSR
      /COPY CBCPYSRC,CB0800C80
      *                                                                                       CER001
     C     ULX043        IFEQ      'Y'
      *                                                                                       CER001
      ** IF NOT EOM OR ( EOM AND ACCR <> 3 )                                                  CER001
      *                                                                                       CER001
     C                   SELECT
      *                                                                                       CER001
     C     EOM           WHENNE    'Y'
     C                   MOVEA     'Y'           FRQ(80)
      *                                                                                       CER001
     C     EOM           WHENEQ    'Y'
     C     ACCR          ANDNE     '3'
     C                   MOVEA     'Y'           FRQ(80)
      *                                                                                       CER001
     C                   ENDSL
      *                                                                                       CER001
     C                   ENDIF
      *                                                                                       CER001
     C                   ENDSR
      *
     C     RCON81        BEGSR
      /COPY CBCPYSRC,CB0800C81
     C                   CALL      'SD2002'
     C                   PARM      ' '           RUN               1
     C                   PARM      ' '           RTN               1
     C     RTN           CASEQ     'Y'           *PSSR
     C                   ENDCS
     C     RUN           IFEQ      'Y'
     C                   MOVEA     'Y'           FRQ(81)
     C                   ENDIF
     C                   ENDSR
      *
     C     RCON82        BEGSR
      /COPY CBCPYSRC,CB0800C82
     C                   ENDSR
      *
     C     RCON83        BEGSR
      /COPY CBCPYSRC,CB0800C83
     C                   ENDSR
      *
     C     RCON84        BEGSR
      /COPY CBCPYSRC,CB0800C84
     C                   ENDSR
      *
     C     RCON85        BEGSR
      /COPY CBCPYSRC,CB0800C85
     C                   ENDSR
      *
     C     RCON86        BEGSR
      /COPY CBCPYSRC,CB0800C86
     C                   ENDSR
      *
     C     RCON87        BEGSR
      /COPY CBCPYSRC,CB0800C87
     C                   ENDSR
      *
     C     RCON88        BEGSR
      /COPY CBCPYSRC,CB0800C88
     C                   ENDSR
      *
     C     RCON89        BEGSR
      /COPY CBCPYSRC,CB0800C89
     C                   ENDSR
      *
     C     RCON90        BEGSR
      /COPY CBCPYSRC,CB0800C90
     C                   ENDSR
      *
     C     RCON91        BEGSR
      /COPY CBCPYSRC,CB0800C91
     C                   ENDSR
      *
     C     RCON92        BEGSR
      /COPY CBCPYSRC,CB0800C92
     C                   ENDSR
      *
     C     RCON93        BEGSR
      /COPY CBCPYSRC,CB0800C93
     C                   ENDSR
      *
     C     RCON94        BEGSR
      /COPY CBCPYSRC,CB0800C94
     C                   ENDSR
      *
     C     RCON95        BEGSR
      /COPY CBCPYSRC,CB0800C95
     C                   ENDSR
      *
     C     RCON96        BEGSR
      /COPY CBCPYSRC,CB0800C96
     C                   ENDSR
      *
     C     RCON97        BEGSR
      /COPY CBCPYSRC,CB0800C97
     C                   ENDSR
      *
     C     RCON98        BEGSR
      /COPY CBCPYSRC,CB0800C98
     C                   ENDSR
      *
     C     RCON99        BEGSR
      /COPY CBCPYSRC,CB0800C99
     C                   ENDSR
**  CPY@
(c) Finastra International Limited 2001
