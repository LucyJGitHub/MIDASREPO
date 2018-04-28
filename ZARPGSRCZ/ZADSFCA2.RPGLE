     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Discount Factor Calculation')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Standard Subprocedures                               *
      *                                                               *
      *  ZADSFCA2 - Midas ZA Discount Factor Calculation              *
      *                                                               *
      *  Function: This program retrieves a discount factor or rate   *
      *            for a specific date for a Yield Curve/Currency/    *
      *            Interest Calculation Method. If it does not find   *
      *            one for that date, it retrieves the interpolated   *
      *            discount factor or rate using ZADSFRTV. If it ret- *
      *            reives an interpolated rate, it is converted to a  *
      *            discount factor using program ZADSFCON.            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. 245132  *CREATE    Date 19Jan11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  245132 - Amended to improve runtime. Copied from ZADSFCAL.   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators:                                           *
      *                                                               *
      *  70             End-of-file indicator                         *
      *  LR             End Call of program                           *
      *  U7-U8          Error handling                                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Subroutine Index:                                            *
      *                                                               *
      *  *PSSR - Error Subroutine                                     *
      *                                                               *
      *****************************************************************
 
      ** Yield Rates File
 
     FSDYLDRL2  IF   E           K DISK
 
      ** Yield Curves File
 
     FSDYLDCL1  IF   E           K DISK
 
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
 
      ** Local date area for database error
 
     D DBERR           DS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
 
     C     *ENTRY        PLIST
     C                   PARM                    PIRTCD            7
     C                   PARM                    PIPRTC            5
     C                   PARM                    PIPYLD            5
     C                   PARM                    PIPCCY            3
     C                   PARM                    PIPINC            1
     C                   PARM                    PIPFDT            5 0
     C                   PARM                    PIPDF            13 9
     C                   PARM                    CAS008            1
     C                   PARM                    CIR004            1
     C                   PARM                    ZNPSDT            5 0
 
      ** Key Lists for the Discount factors file
 
     C     KRATE1        KLIST
     C                   KFLD                    PIPYLD
     C                   KFLD                    PIPCCY
     C                   KFLD                    PIPINC
     C                   KFLD                    PIPFDT
 
      ** Initialise fields.
 
     C                   MOVEA     CPY@          BIS@             80
     C                   MOVE      *BLANKS       PIPRTC
     C                   Z-ADD     1             PIPDF
 
      ** If a discount factor exists for Yield Curve, Currency, Interest
      ** Calculation Method and Date, no further processing is required.
 
     C     KRATE1        CHAIN     SDYLDRL2
 
     C                   IF        %FOUND()
     C                   Z-ADD     FSDSCF        PIPDF
     C                   ELSE
 
      ** Retrieve Interpolation Method
 
     C     PIPYLD        CHAIN     SDYLDCL1
 
     C                   IF        %FOUND()
 
     C                   SELECT
 
      ** Exponential Interpolation between given Yield Rates using actual
      ** days.  Retrieve Rate then convert to Discount Factor.
 
     C                   WHEN      FSINTP = 'R'
     C                   MOVE      'YRATE'       PIPRTC
 
      ** Exponential Interpolation between Discount Factors using actual
      ** days.
 
     C                   WHEN      FSINTP = 'E'
     C                   MOVE      'DISCF'       PIPRTC
 
      ** Straight Line Interpolation between given Yield Rates using
      ** actual days.  Retrieve Rate then convert to Discount Factor.
 
     C                   WHEN      FSINTP = 'Y'
     C                   MOVE      'YRATE'       PIPRTC
 
      ** Straight Line Interpolation between Discount Factors using
      ** actual days.
 
     C                   WHEN      FSINTP = 'S'
     C                   MOVE      'DISCF'       PIPRTC
 
     C                   ENDSL
 
      ** Retrieve Discount Factor or Rate
 
     C                   CALL      'ZADSFRT2'
     C                   PARM      *BLANKS       PIRTCD            7
     C                   PARM                    PIPRTC            5
     C                   PARM                    PIPYLD            5
     C                   PARM                    PIPCCY            3
     C                   PARM                    PIPINC            1
     C                   PARM                    PIPFDT            5 0
     C                   PARM      *ZERO         PIPDF            13 9
     C                   PARM                    CAS008
     C                   PARM                    ZNPSDT
 
     C                   IF        PIRTCD = '*ERROR '
     C                   MOVE      'ZADSFRTV'    DBFILE
     C                   Z-ADD     001           DBASE
     C                   MOVEL     PIPYLD        DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** If no record was found for yield, currency and int. calculation
      ** method, search for rates for all currencies.
 
     C                   IF        PIRTCD = '*NRF   '
 
     C                   MOVE      *BLANKS       PIRTCD
     C                   MOVE      *BLANKS       PIPCCY
 
     C     KRATE1        CHAIN     SDYLDRL2
 
     C                   IF        %FOUND()
     C                   Z-ADD     FSDSCF        PIPDF
     C                   MOVE      'E'           FSINTP
 
     C                   ELSE
 
     C                   SELECT
     C                   WHEN      FSINTP = 'R'
     C                   MOVE      'YRATE'       PIPRTC
     C                   WHEN      FSINTP = 'E'
     C                   MOVE      'DISCF'       PIPRTC
     C                   WHEN      FSINTP = 'Y'
     C                   MOVE      'YRATE'       PIPRTC
     C                   WHEN      FSINTP = 'S'
     C                   MOVE      'DISCF'       PIPRTC
     C                   ENDSL
 
     C                   CALL      'ZADSFRT2'
     C                   PARM      *BLANKS       PIRTCD
     C                   PARM                    PIPRTC
     C                   PARM                    PIPYLD
     C                   PARM                    PIPCCY
     C                   PARM                    PIPINC
     C                   PARM                    PIPFDT
     C                   PARM      *ZERO         PIPDF
     C                   PARM                    CAS008
     C                   PARM                    ZNPSDT
 
     C                   IF        PIRTCD = '*ERROR '
     C                   MOVE      'ZADSFRTV'    DBFILE
     C                   Z-ADD     002           DBASE
     C                   MOVEL     PIPYLD        DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      **  Convert Yield Rate to Discount Factor
 
     C                   IF        FSINTP = 'Y' OR FSINTP = 'R'
 
     C                   MOVE      PIPRTC        PNPRTC            5
     C                   MOVE      PIPYLD        PNPYLD            5
     C                   MOVE      PIPCCY        PNPCCY            3
     C                   MOVE      PIPINC        PNPINC            1
     C                   Z-ADD     PIPFDT        PNPFDT            5 0
     C                   Z-ADD     PIPDF         PRATE            13 9
     C                   Z-ADD     *ZERO         PNPDF            13 9
 
     C                   CALL      'ZADSFCO2'
     C                   PARM      *BLANKS       PNRTCD            7
     C                   PARM                    PNPRTC            5
     C                   PARM                    PNPYLD            5
     C                   PARM                    PNPCCY            3
     C                   PARM                    PNPINC            1
     C                   PARM                    PNPFDT            5 0
     C                   PARM                    PRATE            13 9
     C                   PARM                    PNPDF            13 9
     C                   PARM                    CAS008            1
     C                   PARM                    CIR004            1
     C                   PARM                    ZNPSDT
 
     C                   IF        PNRTCD = '*ERROR '
     C                   MOVE      'ZADSFCON'    DBFILE
     C                   Z-ADD     003           DBASE
     C                   MOVEL     PIPYLD        DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   Z-ADD     PNPDF         PIPDF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *                                                               *
      * *PSSR - Error Subroutine                                      *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
     C                   EVAL      PIRTCD = '*ERROR '
     C                   EVAL      *INU7  = *ON
     C                   EVAL      *INU8  = *ON
     C                   DUMP
     C                   EVAL      *INLR  = *ON
     C                   RETURN
     C                   ENDSR
     C********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2011
