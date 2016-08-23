     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas CB Task split component report')
      *****************************************************************
      *                                                               *
      *  Midas - CoB module                                           *
      *                                                               *
      *  CB0550 - Task split component report                         *
      *                                                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CPK016  *CREATE    Date 14Apr03               *
      *  Prev Amend No. xxxxxx             Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *  CPK016 - Release 5 packaging                                 *
      *                                                               *
      *****************************************************************
      *
      *  File containing task splits
     FCBTPGML0  IF   E           K DISK
      *  File containing CoB components
     FCBCMPNL0  IF   E           K DISK
      *  Task split report
     FCB0550P1  O    E             PRINTER INFDS(SPOOL)
      *
     D/COPY ZACPYSRC,PSDS
      *
      * Data queue name and library
     DSPOOL            DS
     D SpoolFile              83     92
     D SpoolFileNo           123    124B 0
     D OverflowLine          188    189B 0
     D PrintLine             367    368B 0
      *
     D StartSplitComp  C                   'Start split component :'
     D ServerComp      C                   'Server component      :'
     D SubtaskComp     C                   'Sub-task component    :'
     D EndProcessComp  C                   'End process component :'
     D EndSubtaskComp  C                   'End sub-task component:'
     D EndSplitComp    C                   'End split component   :'
      *
     D RemainingLines  S              2  0
     D Wrun            S              1
      *
      *****************************************************************
      *                                                               *
      *  List of indicators                                           *
      *                                                               *
      *  01 - General validation error message                        *
      *                                                               *
      *****************************************************************
      *
      * Build key for component file
     C     CoBComponent  KLIST
     C                   KFLD                    KComponent       10
     C                   KFLD                    KSequence         5
      *
     C                   EVAL      WSID = PSJoBName
     C                   EVAL      USER = PSUser
      *
      * Write header record.
     C                   WRITE     HEADH
      *
      * Read first record for task split
     C     *LOVAL        SETLL     CBTPGML0
     C                   READ      CBTPGML0                               20
      *
     C                   DOU       *IN20 = *ON
      *
      * Check how many lines are left and print header if necessary.
     C     OverflowLine  SUB       PrintLine     RemainingLines
     C                   IF        RemainingLines <= 7
     C                   WRITE     HEADH
     C                   ENDIF
      *
      * Start building detail record and write first line.
     C                   EVAL      @OLDP = CBOLDP
     C                   EVAL      @OLDS = CBOLDS
     C                   WRITE     COMPDTL
      *
      * Build rest of detail information.
     C                   EVAL      KComponent = CBSTRP
     C                   EVAL      KSequence  = CBSTRS
     C     CoBComponent  CHAIN     CBCMPNL0
     C                   EVAL      @TEXT = StartSplitComp
     C                   EVAL      @COMP = CBSTRP
     C                   EVAL      @CSEQ = CBSTRS
     C                   EVAL      @RUNC = DHCFRQ
     C                   EVAL      @DESC = DHCTXT
     C                   WRITE     SPLTDTL
      *
     C                   EVAL      KComponent = CBSRVP
     C                   EVAL      KSequence  = CBSRVS
     C     CoBComponent  CHAIN     CBCMPNL0
     C                   EVAL      @TEXT = ServerComp
     C                   EVAL      @COMP = CBSRVP
     C                   EVAL      @CSEQ = CBSRVS
     C                   EVAL      @RUNC = DHCFRQ
     C                   EVAL      @DESC = DHCTXT
     C                   WRITE     SPLTDTL
      *
     C                   EVAL      KComponent = CBSTSK
     C                   EVAL      KSequence  = CBSTKS
     C     CoBComponent  CHAIN     CBCMPNL0
     C                   EVAL      @TEXT = SubtaskComp
     C                   EVAL      @COMP = CBSTSK
     C                   EVAL      @CSEQ = CBSTKS
     C                   EVAL      @RUNC = DHCFRQ
     C                   EVAL      @DESC = DHCTXT
     C                   WRITE     SPLTDTL
      *
     C                   EVAL      KComponent = CBEPRC
     C                   EVAL      KSequence  = CBEPRS
     C     CoBComponent  CHAIN     CBCMPNL0
     C                   EVAL      @TEXT = EndProcessComp
     C                   EVAL      @COMP = CBEPRC
     C                   EVAL      @CSEQ = CBEPRS
     C                   EVAL      @RUNC = DHCFRQ
     C                   EVAL      @DESC = DHCTXT
     C                   WRITE     SPLTDTL
      *
     C                   EVAL      KComponent = CBESTK
     C                   EVAL      KSequence  = CBESTS
     C     CoBComponent  CHAIN     CBCMPNL0
     C                   EVAL      @TEXT = EndSubtaskComp
     C                   EVAL      @COMP = CBESTK
     C                   EVAL      @CSEQ = CBESTS
     C                   EVAL      @RUNC = DHCFRQ
     C                   EVAL      @DESC = DHCTXT
     C                   WRITE     SPLTDTL
      *
     C                   EVAL      KComponent = CBESPT
     C                   EVAL      KSequence  = CBESPS
     C     CoBComponent  CHAIN     CBCMPNL0
     C                   EVAL      @TEXT = EndSplitComp
     C                   EVAL      @COMP = CBESPT
     C                   EVAL      @CSEQ = CBESPS
     C                   EVAL      @RUNC = DHCFRQ
     C                   EVAL      @DESC = DHCTXT
     C                   WRITE     SPLTDTL
      *
     C                   READ      CBTPGML0                               20
      *
     C                   ENDDO
      *
      * Check how many lines are left and print header if necessary.
     C     OverflowLine  SUB       PrintLine     RemainingLines
     C                   IF        RemainingLines <= 3
     C                   WRITE     HEADH
     C                   ENDIF
     C                   WRITE     TRAILP
      *
     C     EndProgram    TAG
     C                   SETON                                        LR
     C                   RETURN
      *
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        Wrun = *BLANK
     C                   EVAL      Wrun = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
