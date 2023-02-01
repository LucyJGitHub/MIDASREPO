     H DEBUG
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas CG Lending LIBOR confirmation - Driver')         *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG6090 - Lending LIBOR confirmation - Driver                 *
      *                                                               *
      *  Function:  This program will extracts interst confirmation   *
      *    (CoB)    for ARR.                                          *
      *                                                               *
      *  Called By: CGC6007 - Lending LIBOR confirmation              *
      *                                                               *
      *  (c) Finastra International Limited 2021                      *
      *                                                               *
      *  Last Amend No. MD060830           Date 17Jan23               *
      *  Prev Amend No. MD058517           Date 17Oct22               *
      *                 MD059320 *CREATE   Date 06Dec2021             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD060830 - Do not update spool file flag                     *
      *  MD058517 - CLE172 LIBOR Lending- Change Control CC3.1        *
      *             Interest Projection Using Known Rates.            *
      *             CC10 CLE172 Spool File Correspondence (MD059817)  *
      *  MD059320 - CLE172 - LIBOR Lending - Correspondence Manager   *
      *                                                               *
      *****************************************************************
     D/EJECT
     D*****************************************************************
     D*
     D**  Copyright array.
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D W0FMT         E DS                  EXTNAME(CGUDTAPD)
     D SDRTKN        E DS                  EXTNAME(SDRTKNTD)                                MD058517
     D XLNRF           S              6
     D XADDI           S              1
     D XMDAT           S              5  0
     D XCINPDT         S              5  0
     D XCINPSD         S              5  0
     D XCINPED         S              5  0
     D XINTA           S             13  7
     D XVDAT           S              5  0
     D XREPT           S              1  0
     I/COPY CGCPYSRC,SRERRDLE
     I/COPY CGCPYSRC,CGAUDTDLE
     I*****************************************************************
     C/EJECT
     C*****************************************************************
     C* Process     :  MAINLINE                                       *
     C* Function    :  Mainline processing                            *
     C*                                                               *
     C*****************************************************************

      **  Parameter list for current program invocation.
     C     *ENTRY        PLIST
     C                   PARM                    W0RTN
     C                   PARM                    W0CMT             3

      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'MAIN'        @STK(Q)

      **  Initial processing - Once Only
     C     ##INIT        IFEQ      *BLANK
     C                   EXSR      SRINIT
     C                   MOVE      'Y'           ##INIT            1
     C                   ENDIF

      **  Initialisation processing
     C                   EXSR      SRINZ

      **  Main processing
     C                   EXSR      SRMAIN
      *
      **  Audit Processing
     C                   EXSR      SRAUDT

      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q

      **  Terminate program
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * Subroutine  :  SRMAIN                                         *
      * Function    :  Main processing                                *
      *                                                               *
      *****************************************************************
     C     SRMAIN        BEGSR

      **  Set up subroutine stack name
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRMAIN'      @STK(Q)

      ** select loans having Backward Looking Rate = Y and Calculation Method not Manual
     C/EXEC SQL
     C+ declare ACursor insensitive scroll cursor for
     C+ select LNRF, ADDI, MDAT, REPT from CLOANCL
     C+ where BLRT = 'Y' and CALM <> 'MANL'
     C/END-EXEC

     C/EXEC SQL
     C+ open ACursor
     C/END-EXEC

     C/EXEC SQL
     C+ fetch next from ACursor into :XLNRF, :XADDI, :XMDAT, :XREPT
     C/END-EXEC

      **  Process until End of valid records.

     C     SQLCODE       DOWEQ     0

      ** Check if an interest event created today exists in HISTSHP
     C**********/EXEC SQL                                                                   MD058517
     C**********+ SELECT INTA, VDAT into :XINTA, :XVDAT                                     MD058517
     C**********+ from HISTSHP                                                              MD058517
     C**********+ where AMTP = 'MA' and LNRF = :XLNRF and LCD = :BJRDNB                     MD058517
     C**********+ or    AMTP = 'IN' and LNRF = :XLNRF and LCD = :BJRDNB                     MD058517
     C**********+ or    AMTP = 'RE' and LNRF = :XLNRF and LCD = :BJRDNB and :XREPT <> 2     MD058517
     C**********/END-EXEC                                                                   MD058517
      **  If no interest if found, skip                                                     MD058517
     C*****SQLCODE       IFEQ      100                                                      MD058517
     C**********         else                                                               MD058517
      ****************************************************************                      MD058517
      ** Here below are the initial conditions for the extract...                           MD058517
      ****Call extract program if one of the 3 conditions (a or b or c) is satisfied        MD058517
      **********                                                                            MD058517
     C**********/exec SQL                                                                   MD058517
     C**********+ select CINPDT, CINPSD, CINPED  into :XCINPDT, :XCINPSD, :XCINPED          MD058517
     C**********+ from SDHSDRTD                                                             MD058517
     C**********+ where CMODID = 'LE' and CTRNID = :XLNRF                                   MD058517
     C**********+ and (CINPDT + CINPDY - 1 = CINPED or CINPDT = CINPED)                     MD058517
     C**********+ ORDER BY CINPDT desc                                                      MD058517
     C**********+ fetch first row only                                                      MD058517
     C**********/end-exec                                                                   MD058517
      **********
      ****a.*if*Additional Day Indicator = B and latest Interest Period Date = MDAT
     C**********         if        SQLCODE = 0
     C**********                   and XADDI = 'B'
     C**********                   and XCINPDT = XMDAT
      **********
      ****b.*if*Additional Day Indicator <> B and latest Interest Period Date + 1 = MDAT
     C**********                   or SQLCODE = 0
     C**********                   and XADDI <> 'B'
     C**********                   and XCINPDT + 1 = XMDAT
      **********
      ****c.*latest Interest Period Date + 1 < MDAT
      *******and [latest Interest Period Date + 1 = rundate
      **********  or
      **********  latest Interest Period Date + 1 > rundate but < BJDNWD]
      *******and Interest was found in HISTSHP
     C**********                   or SQLCODE = 0
     C**********                   and XCINPDT + 1 < XMDAT
     C**********                   and XCINPDT + 1 = BJRDNB
     C**********                   or SQLCODE = 0
     C**********                   and XCINPDT + 1 < XMDAT
     C**********                   and XCINPDT + 1 > BJRDNB
     C**********                   and XCINPDT + 1 < BJDNWD
     C**********                   and XCINPED + 1 = XVDAT
     C**********                   or SQLCODE = 0
     C**********                   and XCINPDT + 1 < XMDAT
     C**********                   and XCINPDT + 1 > BJRDNB
     C**********                   and XCINPDT + 1 < BJDNWD
     C**********                   and XCINPED     = XVDAT
      ** ... since the interest is retrieved now from HISTSHP, these can be simplified
     C/exec SQL                                                                             MD058517
     C+ select * into :SDRTKN                                                               MD058517
     C+   from   SDRTKNTD                                                                   MD058517
     C+  where  ( KTRNID = :XLNRF )                                                         MD058517
     C+    and  ( (KRTKNI = 'Y' and KCORMP <> 'Y')                                          MD058517
     C+     or    (KRTKNI = 'Y' and KCINTA <> KPINTA) )                                     MD058517
     C/end-exec                                                                             MD058517

     C                   If        SQLCODE = 0
     C**********         If        XCINPED + 1 = XVDAT                                      MD058517
     C**********                   or XCINPED = XVDAT                                       MD058517

     C                   CALL      'CG6091'
     C                   PARM      *BLANKS       ##RTCD            7
     C                   PARM      W0CMT         ##CMT             3
     C                   PARM      *BLANK        ##COPD            1
     C                   PARM                    XLNRF
     C**********         PARM                    XCINPSD                                    MD058517
     C                   PARM                    KCINTA                                     MD058517

      **  Error in called program.
     C     ##RTCD        IFNE      *BLANK
     C                   EXSR      SRAUDT
      ** Database error
     C                   MOVEL     'CG6091'      W0FILE                         ***************
     C                   MOVEL     ##RTCD        W0KEY                          * DB ERROR 01 *
     C                   Z-ADD     01            W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END

     C                   IF        ##COPD = 'Y'                                             MD060830
     C/exec SQL                                                                             MD058517
     C+ update SDRTKNTD                                                                     MD058517
     C*****set KCORMP  = 'Y', KSPLFP = 'Y',                                        MD058517 MD060830
     C+    set KCORMP  = 'Y',                                                               MD060830
     C+        KPINTA = KCINTA                                                              MD058517
     C+  where KTRNID = :XLNRF                                                              MD058517
     C/end-exec                                                                             MD058517
     C                   ENDIF                                                              MD060830

     C**********         Endif                                                              MD058517

     C**********         Endif                                                              MD058517
     C                   Endif
     C/EXEC SQL
     C+ fetch next from ACursor into :XLNRF, :XADDI, :XMDAT, :XREPT
     C/END-EXEC

     C                   ENDDO

     C     EXMAIN        TAG

     C/EXEC SQL
     C+ close ACursor
     C/END-EXEC

      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q

     C                   ENDSR
     C/EJECT
      *****************************************************************
      * Subroutine  :  SRINZ                                          *
      * Function    :  Initialise Fields on Program Invocation        *
      *                                                               *
      *****************************************************************
     C     SRINZ         BEGSR

      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'SRINZ '      @STK(Q)

      **  Open the Audit Print File.
     C                   CLEAR                   I#DTA
     C                   MOVEL     'CG6090AU'    I#SPLN
     C                   MOVEL     'CG6090  '    I#REF
     C                   MOVEL     'CGD2731'     I#TITL
     C                   MOVEL     'CGD2732'     I#TUL
     C                   MOVEL     'CGUSRMSG'    I#FILE

     C                   CALL      'CGZAUDIT'
     C                   PARM      *BLANKS       W0RTN             7
     C                   PARM      '*OPEN   '    W0ACT             8
     C                   PARM                    I#DTA
     C                   PARM                    W0RSQN            5

     C     EXINZ         TAG

      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q

     C                   ENDSR
      *****************************************************************
      /SPACE
      *****************************************************************
      * Subroutine  :  SRINIT                                         *
      * Function    :  Initial processing - First Call Only           *
      *                                                               *
      * Called by   :  Mainline                                       *
      * Calls       :  None                                           *
      *****************************************************************
     C     SRINIT        BEGSR

      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'SRINIT'      @STK(Q)

      **  Initialise work fields
     C                   Z-ADD     *ZEROS        ##SREC            5 0
     C                   MOVEL     *BLANKS       #SCUTX          135

      **  Copyright
     C                   MOVEA     CPY@          ACT@             80
      *  Extract bank details
      *
     C                   CALL      'AOBANKR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      '*FIRST '     P@OPTN            7            I:Option
     C     SDBANK        PARM      *BLANKS       DSFDY

      *  If return with an error (LR seton in called program) then
      *  process for database error.

     C     *IN90         IFEQ      '1'
     C     P@RTCD        OREQ      '*ERROR*'
     C                   MOVEL     'AOBANKR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ***************
     C                   Z-ADD     10            W0ERNB                         * DB ERROR 10 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END

     C     EXINIT        TAG

      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Subroutine  :  SRAUDT                                         *
      * Function    :  Audit Report Processing                        *
      *                                                               *
      * Called by   :  Mainline                                       *
      * Calls       :  CGZAUDIT - Audit Processing                    *
      *                CG9020   - Write Data to UDC Data Files - Audit*
      *****************************************************************
     C     SRAUDT        BEGSR

      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'SRAUDT'      @STK(Q)

      **  Output the Count of records read
     C                   CLEAR                   I#DTA
     C                   MOVEL     'CG6090'      I#REF
     C                   MOVE      'CGD2731'     I#TITL
     C                   MOVE      'CGD2732'     I#TUL
     C                   MOVEL     'CGUSRMSG'    I#FILE
     C                   MOVE      '*LINE   '    W1ACT
     C                   MOVE      *BLANKS       I#SUB
     C                   MOVEL     'CLOAN   '    I#SUB
     C                   MOVEL     'CAD1021'     I#TEXT
     C                   Z-ADD     ##SREC        I#QTY
     C                   Z-ADD     *ZERO         I#DECS
     C                   MOVE      '1'           I#EDIT

     C                   CALL      'CGZAUDIT'
     C                   PARM                    W1RTN             7
     C                   PARM                    W1ACT             8
     C                   PARM                    I#DTA
     C                   PARM                    W1RSQN            5

      **  Skip a line.
     C                   MOVE      '*SKIP   '    W1ACT

     C                   CALL      'CGZAUDIT'
     C                   PARM                    W1RTN             7
     C                   PARM                    W1ACT             8
     C                   PARM                    I#DTA
     C                   PARM                    W1RSQN            5

      **  Produce the Audit Report.
     C                   CALL      'CG9020'
     C                   PARM      *BLANK        ##RTCD
     C                   PARM      '*AUDIT  '    W0ACT
     C                   PARM      *BLANKS       W0PATH          256
     C                   PARM                    W0FMT
     C                   PARM      'CGD2731'     W0TITL            7
     C                   PARM      'CGD2732'     W0ULIN            7
     C                   PARM                    W0CMT

      **  Close the Audit Print File.
     C                   CLEAR                   I#DTA
     C                   MOVEL     'CG6090'      I#REF
     C                   MOVEL     'CGD2731'     I#TITL
     C                   MOVEL     'CGD2732'     I#TUL
     C                   MOVEL     'CGUSRMSG'    I#FILE

     C                   CALL      'CGZAUDIT'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*CLOSE  '    W0ACT             8
     C                   PARM                    I#DTA
     C                   PARM                    W0RSQN            5

     C     EXAUDT        TAG

     C**  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q

     C                   ENDSR
     C*****************************************************************
     C/EJECT
     C/COPY CGCPYSRC,SRERRPSSRL
     C/EJECT
     C/COPY CGCPYSRC,SRERRCLE
** CPY@  **      OBJECT COPYRIGHT
(c) Finastra International Limited 2021
