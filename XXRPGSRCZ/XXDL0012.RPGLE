     H DEBUG
      *****************************************************************
/*S*D****RPGBASE*******************************************************             LUC109
/*STD *  RPGBASEBND                                                   *             LUC109
      *****************************************************************
      *                                                               *
      *  Midas - Interface to Head Office Reporting                   *
      *                                                               *
      ***DLM012*-*Extract*Dealing*Today's*Events***********************             LUC109
      *  XXDL0012 - Midas HOR Extract Dealing Today's Events          *             LUC109
      *****************************************************************
      * *** THIS PROGRAM MUST BE COMPILED WITH XXINTFLIB AT THE TOP   *
      * OF LIBL ***                                                   *
      *****************************************************************
      *                                                               *
      *  Function: To extract Principal Changes and Interest Payments *
      *            for Loans/Deposits, Negotiable Assets Purchased    *
      *            and FRA/IRS Deals from today's Account Keys.       *
      *                                                               *
      ***Called*By:*GLCM048*-*HOR*Extract******************************             LUC109
      *  Called By: XXC000048 - HOR Extract                           *             LUC109
      *                                                               *
      ***(c)*Misys*2004************************************************             LUC109
      *  (c) Finastra International Limited 2016                      *             LUC109
      *                                                               *
      *  Last Amend No. LUC109             Date 16Sep16               *
      *  Prev Amend No. MUI011  *CREATE    Date 04Jun04               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  LUC109 - HO Reporting (Upgrade to FBM 2.1)                   *
      *  MUI011 - ALMS changes to HOR                                 *
      *                                                               *
      *****************************************************************
      *
     FDLACKRPD  IF   E             DISK
     FDEALALL   IF   E           K DISK
     FSDGELRPP  IF   E             DISK
     FDLMPEVPP  O    E             DISK
      *
      * Account Key data structure
      *
     D                 DS
     D  AKEY                   1     10
     D  AKEY01                 1      2
     D  AKEY03                 3      3
     D  AKEY06                 6      6
     D  AKEY09                 9     10
     D  AKEY10                10     10
      *
      *****************************************************************
      *                                                               *
      *  MAINLINE  - Main processing                                  *
      *                                                               *
      *  Called By:                                                   *
      *  Calls: SELECT - Process Account Key                          *
      *                                                               *
      *****************************************************************
      *
      *
      * Read HOR ICD for today's date
      *
     C     1             SETLL     SDGELRPP
     C                   READ      SDGELRPP                               01
     C                   READ      DLACKRPD                               01
      *
     C     *IN01         DOWEQ     *OFF
     C                   EXSR      SELECT
     C                   READ      DLACKRPD                               01
     C                   ENDDO
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      *  SELECT - Process each Account Key and determine if output to *
      *           history file is required                            *
      *                                                               *
      *  Called By: MAINLINE                                          *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     SELECT        BEGSR
      *
      * Exclude Margin Keys and zero amounts
      *
     C     EAMT          IFNE      *ZERO
     C     AKEY06        ANDEQ     *BLANK
      *
      * Check Deal Type
      *
     C                   MOVE      ' '           RCDT
      *
     C     DLNO          CHAIN     DEALALL                            02
      *
     C     RCDT          IFEQ      'C'
     C     RCDT          OREQ      'D'
     C     RCDT          OREQ      'G'
     C*
     C     RCDT          IFEQ      'G'
     C                   MOVE      'U'           RCDT
     C                   ENDIF
      *
      * Principal Increase - excluding Value Date
      *
     C                   Z-ADD     1             SIGN              1 0
      *
     C     RCDT          IFEQ      'C'
     C     AKEY03        ANDEQ     'V'
     C     AKEY09        ANDEQ     ' IA'
     C                   EXSR      OUTPRI
     C                   ENDIF
      *
      * Principal Decrease
      *
     C     RCDT          IFEQ      'C'
     C     AKEY03        ANDEQ     'M'
     C     AKEY09        ANDEQ     'DA'
     C                   Z-SUB     1             SIGN
     C                   EXSR      OUTPRI
     C                   ENDIF
      *
      * Interest Payment
      *
     C     AKEY03        IFEQ      'I'
     C     AKEY03        OREQ      'M'
     C     AKEY03        OREQ      'V'
     C     AKEY10        IFEQ      'I'
     C     AKEY09        IFEQ      'RI'
     C                   MOVE      'T'           RCDT
     C                   ENDIF
     C                   EXSR      OUTINT
     C                   ENDIF
     C                   ENDIF
      *
      * Interest Capitalisation
      *
     C     AKEY03        IFEQ      'I'
     C     AKEY09        IFEQ      ' C'
     C     AKEY09        OREQ      'PC'
     C     AKEY09        OREQ      'RC'
     C     AKEY09        IFEQ      'RC'
     C                   MOVE      'T'           RCDT
     C                   ENDIF
     C                   EXSR      OUTINT
     C                   EXSR      OUTPRI
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  OUTPRI - Output Principal Change                             *
      *                                                               *
      *  Called By: SELECT                                            *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     OUTPRI        BEGSR
      *
     C                   CLEAR                   DLMPEVP0
      *
     C                   MOVE      DLNO          HDLNO
     C                   MOVE      RCDT          HRCDT
     C                   MOVE      'PRI'         HOUTF
     C                   Z-ADD     EDAT          HEDAT
     C     SIGN          MULT      EAMT          HEAMT
     C                   MOVE      'PRI'         HOUTF
     C                   Z-ADD     MLACD         HORED
      *
     C                   WRITE     DLMPEVP0
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  OUTINT - Output Interest Payment                             *
      *                                                               *
      *  Called By: SELECT                                            *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     OUTINT        BEGSR
      *
     C                   CLEAR                   DLMPEVP0
      *
     C                   MOVE      DLNO          HDLNO
     C                   MOVE      RCDT          HRCDT
     C                   MOVE      'INT'         HOUTF
     C                   Z-ADD     EDAT          HEDAT
     C                   Z-ADD     EAMT          HEAMT
     C                   MOVE      IPFR          HIPFR
     C     RCDT          IFEQ      'U'
     C                   MOVE      UIPFR         HIPFR
     C                   ENDIF
     C     RCDT          IFEQ      'T'
     C                   MOVE      TIPFR         HIPFR
     C                   ENDIF
     C                   Z-ADD     MLACD         HORED
      *
     C                   WRITE     DLMPEVP0
      *
     C                   ENDSR
