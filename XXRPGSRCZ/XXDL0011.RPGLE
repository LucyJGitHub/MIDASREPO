     H DEBUG
      *****************************************************************
/*S*D****RPGBASE*******************************************************             LUC109
/*STD *  RPGBASEBND                                                   *             LUC109
      *****************************************************************
      *                                                               *
      *  Midas - Interface to Head Office Reporting                   *
      *                                                               *
      ***DLM011*-*Extract*Dealing*Past*Events**************************             LUC109
      *  XXDL0011 - Midas HOR Extract Dealing Past Events             *             LUC109
      *****************************************************************
      * *** THIS PROGRAM MUST BE COMPILED WITH XXINTFLIB AT THE TOP   *
      * OF LIBL ***                                                   *
      *****************************************************************
      *                                                               *
      *  Function: To extract rate changes, initial records and end   *
      *            of month accruals for Loans/Deposits, Negotiable   *
      *            Assets Purchased and FRA/IRS Deals.                *
      *                                                               *
      ***Called*By:*GLCM048*- HOR*Extract******************************             LUC109
      *  Called By: XXC000048 - HOR Extract                           *             LUC109
      *                                                               *
      ***(c)*Misys*2004************************************************             LUC109
      *  (c) Finastra International Limited 2016                      *             LUC109
      *                                                               *
      *  Last Amend No. LUC109             Date 16Sep16               *
      *  Prev Amend No. 240520             Date 16Jun06               *
      *                 230946             Date 29Dec04               *
      *                 MUI011  *CREATE         03Jun04               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  LUC109 - HO Reporting (Upgrade to FBM 2.1)                   *
      *  240520 - Handle fixed rate changes.                          *
      *  230946 - Duplicate records on TAS file for our side of IRS.  *
      *  MUI011 - ALMS changes to HOR                                 *
      *                                                               *
      *****************************************************************
      *
     FDEALSDC   IF   E             DISK
     FDEALSDD   IF   E             DISK
     FDEALSDG   IF   E             DISK
     FDLMPEVV0  UF A E           K DISK
     FSDGELRPP  IF   E             DISK
      *
     C     KHV0          KLIST
     C                   KFLD                    DLNO
     C                   KFLD                    RCDT
     C                   KFLD                    OUTF              3
      *
      *****************************************************************
      *                                                               *
      *  MAINLINE  - Main processing                                  *
      *                                                               *
      *  Called By:                                                   *
      *  Calls: MONEYM - Process Money Market Deals                   *
      *         FRAIRS - Process FRA/IRS Deals                        *
      *                                                               *
      *****************************************************************
      *
     C                   READ      DEALSDC                                01
      *
     C     *IN01         DOWEQ     *OFF
     C                   EXSR      MONEYM
     C                   READ      DEALSDC                                01
     C                   ENDDO
      *
     C                   READ      DEALSDD                                01
      *
     C     *IN01         DOWEQ     *OFF
     C                   Z-ADD     FVAL          PCPL
     C                   Z-ADD     *ZERO         BRTT
     C                   EXSR      MONEYM
     C                   READ      DEALSDD                                01
     C                   ENDDO
      *
     C                   READ      DEALSDG                                01
      *
     C     *IN01         DOWEQ     *OFF
     C                   EXSR      FRAIRS
     C                   READ      DEALSDG                                01
     C                   ENDDO
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      *  MONEYM - Process Loans/Deposits and NAPs                     *
      *                                                               *
      *  Called By: MAINLINE                                          *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     MONEYM        BEGSR
      *
      * If no records on history fle, output initial information
      *
     C     DLNO          CHAIN     DLMPEVV0                           02
      *
     C     *IN02         IFEQ      *ON
      *
      * Starting Amount
      *
     C                   CLEAR                   DLMPEVP0
     C                   MOVE      DLNO          HDLNO
     C                   MOVE      RCDT          HRCDT
     C                   MOVE      'PRI'         HOUTF
     C                   Z-ADD     VDAT          HEDAT
     C                   Z-ADD     PCPL          HEAMT
     C                   Z-ADD     MLACD         HORED
     C                   WRITE     DLMPEVP0
      *
      * Starting Rate
      *
     C                   MOVE      'TAS'         HOUTF
     C                   Z-ADD     *ZERO         HEAMT
     C                   Z-ADD     BRTT          HBRTT
     C                   Z-ADD     RTSP          HRTSP
     C                   Z-ADD     INTR          HINTR
     C                   WRITE     DLMPEVP0
      *
      * Last Interest Payment
      *
     C     SLID          IFNE      *ZERO
     C     SLID          ANDNE     VDAT
     C     SLID          ANDLT     MLACD
     C                   MOVE      'INT'         HOUTF
     C                   Z-ADD     SLID          HEDAT
     C                   Z-ADD     *ZERO         HEAMT
     C                   MOVE      IPFR          HIPFR
     C                   WRITE     DLMPEVP0
     C                   ENDIF
      *
     C                   ENDIF
      *
      * Access last rate on history file and if necessary output
      * current information
      *
     C                   MOVE      'TAS'         OUTF
      *
     C     KHV0          SETGT     DLMPEVP0                           03
     C     KHV0          READPE    DLMPEVP0                               03
      *
     C     BRTT          IFNE      HBRTT
     C     RTSP          ORNE      HRTSP
     C     INTR          ORNE      HINTR
     C                   CLEAR                   DLMPEVP0
     C                   MOVE      DLNO          HDLNO
     C                   MOVE      RCDT          HRCDT
     C                   MOVE      'TAS'         HOUTF
     C                   Z-ADD     DLRC          HEDAT
     C                   Z-ADD     BRTT          HBRTT
     C     RTSP          IFLT      *ZERO
     C                   MOVE      'S'           HSPIN
     C                   Z-SUB     RTSP          HRTSP
     C                   ELSE
     C                   MOVE      'A'           HSPIN
     C                   Z-ADD     RTSP          HRTSP
     C                   ENDIF
     C                   Z-ADD     INTR          HINTR
     C                   Z-ADD     MLACD         HORED
     C                   WRITE     DLMPEVP0
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  FRAIRS - Process FRA/IRS Deals                               *
      *                                                               *
      *  Called By: MAINLINE                                          *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     FRAIRS        BEGSR
      *
      * If no records on history fle, output initial information
      *
     C     DLNO          CHAIN     DLMPEVV0                           02
      *
     C     *IN02         IFEQ      *ON
      *
      * Starting Amount - Ours
      *
     C                   CLEAR                   DLMPEVP0
     C                   MOVE      DLNO          HDLNO
     C                   MOVE      'U'           HRCDT
     C                   MOVE      'PRI'         HOUTF
     C                   Z-ADD     VDAT          HEDAT
     C                   Z-ADD     UPAMT         HEAMT
     C                   Z-ADD     MLACD         HORED
     C                   WRITE     DLMPEVP0
      *
      * Starting Amount - Theirs
      *
     C                   MOVE      'T'           HRCDT
     C                   Z-ADD     TPAMT         HEAMT
     C                   WRITE     DLMPEVP0
      *
      * Starting/Last Rate - Ours
      *
     C                   MOVE      'U'           HRCDT
     C                   MOVE      'TAS'         HOUTF
     C                   Z-ADD     VDAT          HEDAT
     C     UIACD         IFGT      VDAT
     C                   Z-ADD     UIACD         HEDAT
     C                   ENDIF
     C                   Z-ADD     *ZERO         HEAMT
     C                   Z-ADD     UBRTT         HBRTT
     C                   Z-ADD     URTSP         HRTSP
     C                   Z-ADD     UEINR         HINTR
     C                   MOVE      USPIN         HSPIN
     C                   Z-ADD     UFRFD         HFRFD
     C                   Z-ADD     *ZERO         HINFD
     C                   MOVE      UICFR         HICFR
     C                   WRITE     DLMPEVP0
      *
      * Starting/Last Rate - Theirs
      *
     C                   MOVE      'T'           HRCDT
     C                   Z-ADD     VDAT          HEDAT
     C     TIACD         IFGT      VDAT
     C                   Z-ADD     TIACD         HEDAT
     C                   ENDIF
     C                   Z-ADD     TBRTT         HBRTT
     C                   Z-ADD     TRTSP         HRTSP
     C                   Z-ADD     TEINR         HINTR
     C                   MOVE      TSPIN         HSPIN
     C                   Z-ADD     TFRFD         HFRFD
     C                   Z-ADD     *ZERO         HINFD
     C                   MOVE      TICFR         HICFR
     C                   WRITE     DLMPEVP0
      *
      * Last Interest Payment - Ours
      *
     C     USLIP         IFNE      *ZERO
     C     USLIP         ANDNE     VDAT
     C     USLIP         ANDLT     MLACD
     C                   MOVE      'U'           HRCDT
     C                   MOVE      'INT'         HOUTF
     C                   Z-ADD     USLIP         HEDAT
     C                   Z-ADD     *ZERO         HEAMT
     C                   MOVE      UIPFR         HIPFR
     C                   WRITE     DLMPEVP0
     C                   ENDIF
      *
      * Last Interest Payment - Theirs
      *
     C     TSLIP         IFNE      *ZERO
     C     TSLIP         ANDNE     VDAT
     C     TSLIP         ANDLT     MLACD
     C                   MOVE      'T'           HRCDT
     C                   MOVE      'INT'         HOUTF
     C                   Z-ADD     TSLIP         HEDAT
     C                   Z-ADD     *ZERO         HEAMT
     C                   MOVE      TIPFR         HIPFR
     C                   WRITE     DLMPEVP0
     C                   ENDIF
      *
     C                   ENDIF
      *
      * Access last rate on history file and if necessary output
      * current information
      *
     C                   MOVE      DLNO          HDLNO                                         23094
     C                   MOVE      'TAS'         OUTF
     C                   MOVE      'U'           RCDT
      *
     C     KHV0          SETGT     DLMPEVP0                           03
     C     KHV0          READPE    DLMPEVP0                               03
      *
     C     UBRTT         IFNE      HBRTT
     C     URTSP         ORNE      HRTSP
     C     UEINR         ORNE      HINTR
     C     USPIN         ORNE      HSPIN
     C                   CLEAR                   DLMPEVP0
     C                   MOVE      DLNO          HDLNO
     C                   MOVE      'U'           HRCDT
     C                   MOVE      'TAS'         HOUTF
     C                   Z-ADD     ULPCD         HEDAT
     C     ULPCD         IFEQ      *ZERO                                                       24052
     C                   Z-ADD     USLIP         HEDAT                                         24052
     C                   ENDIF                                                                 24052
     C                   Z-ADD     UBRTT         HBRTT
     C                   Z-ADD     URTSP         HRTSP
     C                   Z-ADD     UEINR         HINTR
     C                   MOVE      USPIN         HSPIN
     C                   Z-ADD     UFRFD         HFRFD
     C                   Z-ADD     UINFD         HINFD
     C                   MOVE      UICFR         HICFR
     C                   Z-ADD     MLACD         HORED
     C                   WRITE     DLMPEVP0
     C                   ENDIF
      *
     C                   MOVE      'T'           RCDT
      *
     C     KHV0          SETGT     DLMPEVP0                           03
     C     KHV0          READPE    DLMPEVP0                               03
      *
     C     TBRTT         IFNE      HBRTT
     C     TRTSP         ORNE      HRTSP
     C     TEINR         ORNE      HINTR
     C     TSPIN         ORNE      HSPIN
     C                   CLEAR                   DLMPEVP0
     C                   MOVE      DLNO          HDLNO
     C                   MOVE      'T'           HRCDT
     C                   MOVE      'TAS'         HOUTF
     C                   Z-ADD     TLPCD         HEDAT
     C     TLPCD         IFEQ      *ZERO                                                       24052
     C                   Z-ADD     TSLIP         HEDAT                                         24052
     C                   ENDIF                                                                 24052
     C                   Z-ADD     TBRTT         HBRTT
     C                   Z-ADD     TRTSP         HRTSP
     C                   Z-ADD     TEINR         HINTR
     C                   MOVE      TSPIN         HSPIN
     C                   Z-ADD     TFRFD         HFRFD
     C                   Z-ADD     TINFD         HINFD
     C                   MOVE      TICFR         HICFR
     C                   Z-ADD     MLACD         HORED
     C                   WRITE     DLMPEVP0
     C                   ENDIF
      *
      * At end of month, output a record containing the accrued
      * interest so far. This will be used by GLM042 to work out
      * fields C9858 and C9859 (interest accrued in current month).
      *
     C     MENDM         IFEQ      'Y'
      *
     C                   MOVE      'EOM'         OUTF
     C                   MOVE      'U'           RCDT
      *
     C     KHV0          CHAIN     DLMPEVP0                           04
     C                   CLEAR                   DLMPEVP0
     C                   MOVE      DLNO          HDLNO
     C                   MOVE      'U'           HRCDT
     C                   MOVE      'EOM'         HOUTF
     C                   Z-ADD     UAIPD         HEAMT
     C                   Z-ADD     MLACD         HORED
     C     *IN04         IFEQ      *ON
     C                   WRITE     DLMPEVP0
     C                   ELSE
     C                   UPDATE    DLMPEVP0
     C                   ENDIF
      *
     C                   MOVE      'T'           RCDT
      *
     C     KHV0          CHAIN     DLMPEVP0                           04
     C                   CLEAR                   DLMPEVP0
     C                   MOVE      DLNO          HDLNO
     C                   MOVE      'T'           HRCDT
     C                   MOVE      'EOM'         HOUTF
     C                   Z-ADD     TAIPD         HEAMT
     C                   Z-ADD     MLACD         HORED
     C     *IN04         IFEQ      *ON
     C                   WRITE     DLMPEVP0
     C                   ELSE
     C                   UPDATE    DLMPEVP0
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initial subroutine                                  *
      *                                                               *
      *  Called By: automatically                                     *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     1             SETLL     SDGELRPP
     C                   READ      SDGELRPP                               01
      *
     C                   ENDSR
