     H DEBUG
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas CG Dealing LIBOR confirmation - Driver')         *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG6092 - Dealing LIBOR confirmation - Driver                 *
      *                                                               *
      *  Function:  This program will extracts interst confirmation   *
      *    (CoB)    for ARR.                                          *
      *                                                               *
      *  Called By: CGC6007 - Dealing LIBOR confirmation              *
      *                                                               *
      *  (c) Finastra International Limited 2021                      *
      *                                                               *
      *  Last Amend No. MD059367 *CREATE   Date 24Dec2021             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD059367 - CDL102 - LIBOR Dealing - Correspondence Manager   *
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
     D XDLNO           S              6  0
     D XADDI           S              1
     D XMDAT           S              5  0
     D XCINPDT         S              5  0
     D XCINPSD         S              5  0
     D XCINPED         S              5  0
     D NumRec          S              5  0
     D XDTYP           S              2
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

      ** select deals having Backward Looking Rate = Y and Calculation Method not Manual
     C/EXEC SQL
     C+ declare ACursor insensitive scroll cursor for
     C+ select DLNO, MDAT, DTYP from DEALSDC
     C+ where BLRT = 'Y' and CALM <> 'MANL'
     C+ order by DLNO
     C/END-EXEC

     C/EXEC SQL
     C+ open ACursor
     C/END-EXEC

     C/EXEC SQL
     C+ fetch next from ACursor into :XDLNO, :XMDAT, :XDTYP
     C/END-EXEC

      **  Process until End of valid records.

     C     SQLCODE       DOWEQ     0

     C                   eval      NumRec = 0
      **  Call extract program if interest key has been generated
     C                   select
     C                   when      XDTYP = 'CD' or XDTYP = 'TD'
     C/exec SQL
     C+ select count(*) into :NumRec
     C+ from DLKYLBPD
     C+ where DLNO = :XDLNO and (substr(AKEY,3,1) = 'I'
     C+ or substr(AKEY,3,1) = 'M')
     C/end-exec
     C                   other
     C/exec SQL
     C+ select count(*) into :NumRec
     C+ from DLKYLBPD
     C+ where DLNO = :XDLNO and (substr(AKEY,3,1) = 'I'
     C+ or substr(AKEY,3,1) = 'M')
     C+ and substr(AKEY,10,1) = 'I'
     C/end-exec
     C                   endsl

      **  If no interest is found, skip
     C     NumRec        IFEQ      0
     C                   else

     C/exec SQL
     C+ select CINPDT, CINPSD, CINPED  into :XCINPDT, :XCINPSD, :XCINPED
     C+ from SDHSDRTD
     C+ where CMODID = 'DL' and CTRNID = :XDLNO
     C+ and (CINPDT + CINPDY - 1 = CINPED or CINPDT = CINPED)
     C+ ORDER BY CINPDT desc
     C+ fetch first row only
     C/end-exec

      * set variable to retrieve interest amount from account key
     C                   eval      KEY3 = 'I'
     C                   If        XCINPDT = XMDAT or  XCINPDT + 1 = XMDAT
     C                   eval      KEY3 = 'M'
     C                   ENDIF

     C                   CALL      'CG6093'
     C                   PARM      *BLANKS       ##RTCD            7
     C                   PARM      W0CMT         ##CMT             3
     C                   PARM      *BLANK        ##COPD            1
     C                   PARM                    XDLNO
     C                   PARM                    XCINPSD
     C                   PARM                    KEY3              3

      **  Error in called program.
     C     ##RTCD        IFNE      *BLANK
     C                   EXSR      SRAUDT
      ** Database error
     C                   MOVEL     'CG6093'      W0FILE                         ***************
     C                   MOVEL     ##RTCD        W0KEY                          * DB ERROR 01 *
     C                   Z-ADD     01            W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END

     C                   Endif

     C/EXEC SQL
     C+ fetch next from ACursor into :XDLNO, :XMDAT, :XDTYP
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
     C                   MOVEL     'CG6092AU'    I#SPLN
     C                   MOVEL     'CG6092  '    I#REF
     C                   MOVEL     'CGD2733'     I#TITL
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
     C                   MOVEL     'CG6092'      I#REF
     C                   MOVE      'CGD2733'     I#TITL
     C                   MOVE      'CGD2732'     I#TUL
     C                   MOVEL     'CGUSRMSG'    I#FILE
     C                   MOVE      '*LINE   '    W1ACT
     C                   MOVE      *BLANKS       I#SUB
     C                   MOVEL     'DEALSDC'     I#SUB
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
     C                   PARM      'CGD2733'     W0TITL            7
     C                   PARM      'CGD2732'     W0ULIN            7
     C                   PARM                    W0CMT

      **  Close the Audit Print File.
     C                   CLEAR                   I#DTA
     C                   MOVEL     'CG6092'      I#REF
     C                   MOVEL     'CGD2733'     I#TITL
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
