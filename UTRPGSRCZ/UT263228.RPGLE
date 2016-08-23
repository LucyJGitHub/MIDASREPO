     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('FIX - Correct Interest Rate (INTR)')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  UT263228 - Correct Interest Rate (INTR)                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. CLE141             Date 08Feb16               *
      *  Prev Amend No. 263228  *CREATE    Date 01Aug12               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CLE141 - Currency and Location Business Day Convention       *
      *           (Recompile)                                         *
      *  263228 - Incorrect interest rate value                       *
      *                                                               *
      *****************************************************************
     FCLOAN     UP   E           K DISK    INCLUDE(CLOANCLF)

     D/EJECT

     D                 DS
     D LTYP
     D  DSLTYP1                1      1A

      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC

      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Main Processing Control

      ** Process Request.

     C                   IF        INTR = 0
     C                             AND (DSLTYP1 = 'X'
     C                             OR DSLTYP1 = 'Y'
     C                             OR DSLTYP1 = 'Z')
     C                   EXSR      SRCLOANCL
     C                   ENDIF
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  SRCLOANCL - Process Loan Details.                            *
      *****************************************************************
     C     SRCLOANCL     BEGSR

      ** Set Spread Indicator.

     C                   IF        SPIN = *BLANKS
     C                   IF        BRTE <> 0
     C                             OR RTSP <> 0
     C                   EVAL      SPIN = 'A'
     C                   ENDIF
     C                   ENDIF

      ** Set Interest Rate.

     C                   SELECT
     C                   WHEN      SPIN = 'A'
     C     BRTE          ADD       RTSP          INTR
     C                   ENDSL

      ** Update Loan Details.

     C                   IF        INTR <> 0
     C                   UPDATE(E) CLOANCLF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
     C/SPACE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2012
