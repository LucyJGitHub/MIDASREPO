      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas CG NAHO Tax Advice - Driver')                    *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG7430 - CG NAHO Tax Advice - Driver                         *
      *                                                               *
      *  Function: This program reads the customer tax advice header  *
      *            file and calls the extract program for each        *
      *            statement required.                                *
      *                                                               *
      *  Called By: CGC7430 - CG NAHO Tax Advice (COB)                *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR784693 *CREATE   Date 17Jun11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR784693 - No tax advice was generated for primary acccount  *
      *             defined as NAH                                    *
      *                                                               *
      *****************************************************************
      *
      ** Midas SD Interest Payment History File
      *
     FSDINPHL1  UF   E           K DISK
     F                                     INFSR(SRFILE)
      *
      ** Copyright array.
      *
     D/COPY CGCPYSRC,SRERRDLE
      *
     D DSPARM        E DS                  EXTNAME(SDINPHPD)
      *
      ** External DS for parameter passed to CG7440
      *
     D CPYR            DS
      *
      ** Data Structure for Compilation - Copyright Insertion
      *
     D  ##CPY                  1     80
     D                                     DIM(1) CTDATA PERRCD(1)
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** First DS for access programs, short data structure
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** External DS for Bank details
      *
     D W0FMT         E DS                  EXTNAME(CGUDTAPD)
      *
      ** Parameter fields
      *
     D ##RTCD          S              7
     D ##CMT           S              3
     D W0CMT           S              3
     D ##COPD          S              1
     D W0ACT           S              8
     D W0RSQN          S              5
     D ##OPTN          S              7
     D W1RTN           S              7
     D W1ACT           S              8
     D W1RSQN          S              5
      *
      ** Work fields
      *
     D ##INIT          S              1A
     D Q               S              5  0
     D ##DREC          S              5  0
     D ##BIS           S             80
     D W0PATH          S            256
     D W0TITL          S              7
     D W0ULIN          S              7
      *
      ** Record format of PF/CGUDTAPD for use as a parameter
      *
     D/COPY CGCPYSRC,CGAUDTDLE
      *****************************************************************
      *  Process     -  MAINLINE                                      *
      *  Function    -  Mainline processing                           *
      *                                                               *
      *  Called by   -  None                                          *
      *  Calls       -  SRINIT - Initial Processing - On First Call   *
      *                 SRINZ  - Initialise Fields on Each Invocation *
      *                 SRMAIN - Main Processing                      *
      *                 SRAUDT - Audit Report Processing              *
      *****************************************************************
      *
      ** Parameter list for current program invocation.
      *
     C     *ENTRY        PLIST
     C                   PARM                    W0RTN
     C                   PARM                    W0CMT
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'MAIN'        @STK(Q)
      *
      ** Initial processing - Once Only
      *
     C     ##INIT        IFEQ      *BLANK
     C                   EXSR      SRINIT
     C                   MOVE      'Y'           ##INIT
     C                   ENDIF
      *
      ** Initialisation processing
      *
     C                   EXSR      SRINZ
      *
      ** Main processing
      *
     C                   EXSR      SRMAIN
      *
      ** Audit processing
      *
     C                   EXSR      SRAUDT
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
      ** Terminate program
      *
     C                   RETURN
      *****************************************************************
      *  Subroutine  -  SRMAIN                                        *
      *  Function    -  Main processing                               *
      *                                                               *
      *  Called by   -  Mainline                                      *
      *  Calls       -  CG7440  - Withholding Tax Statements          *
      *****************************************************************
     C     SRMAIN        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRMAIN'      @STK(Q)
      *
      ** Read from the Customer Advice Header file
      *
     C     *LOVAL        SETLL     SDINPHL1
     C                   READ      SDINPHL1                               99
      *
      ** Read until End of File
      *
     C     *IN99         DOWEQ     '0'
      *
      ** Increment the count of SDINPHPD records read.
      *
     C                   ADD       1             ##DREC
      *
      ** If Statement required
      *
     C     TISTRQ        IFEQ      'Y'
      *
      ** Produce Statement
      *
     C                   CALL      'CG7440 '
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      W0CMT         ##CMT
     C                   PARM      *BLANK        ##COPD
     C                   PARM                    DSPARM
      *
      ** Error in called program.
      *
     C     ##RTCD        IFNE      *BLANK
      *
     C                   EXSR      SRAUDT
      *
      ** Database error
      *
     C                   MOVEL     'CG7440  '    W0FILE
     C                   MOVEL     ##RTCD        W0KEY
     C                   Z-ADD     1             W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ** Statement Produced?
      *
     C     ##COPD        IFNE      'N'
      *
      ** Update Last Statement Number on SDINPHPD
      *
     C     TIPGNO        ADD       1             TIPGNO
      *
      ** Update Last Generation Date on SDINPHPD
      *
     C                   Z-ADD     BJRDNB        TILSSD
      *
     C                   UPDATE    SDINPHD0
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Read next record from SDINPHL1
      *
     C                   READ      SDINPHL1                               99
     C                   ENDDO
      *
     C     EXMAIN        TAG
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  Subroutine  -  SRINZ                                         *
      *  Function    -  Initialise Fields on Program Invocation       *
      *                                                               *
      *  Called by   -  Mainline                                      *
      *  Calls       -  CGZAUDIT - Audit Processing                   *
      *****************************************************************
     C     SRINZ         BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRINZ '      @STK(Q)
      *
      ** Open the Audit Print File.
      *
     C                   CLEAR                   I#DTA
     C                   MOVEL     'CG7430AU'    I#SPLN
     C                   MOVEL     'CG7430 '     I#REF
     C                   MOVE      'CGD3006'     I#TITL
     C                   MOVE      'CGD1123'     I#TUL
     C                   MOVEL     'CGUSRMSG'    I#FILE
      *
     C                   CALL      'CGZAUDIT'
     C                   PARM      *BLANKS       W0RTN
     C                   PARM      '*OPEN   '    W0ACT
     C                   PARM                    I#DTA
     C                   PARM                    W0RSQN
      *
     C     EXINZ         TAG
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  Subroutine  -  SRINIT                                        *
      *  Function    -  Initial processing - First Call Only          *
      *                                                               *
      *  Called by   -  Mainline                                      *
      *  Calls       -  None                                          *
      *****************************************************************
     C     SRINIT        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRINIT'      @STK(Q)
      *
      ** Call access program for bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*FIRST  '    ##OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     ##RTCD        IFNE      *BLANK
      *
      ** Database error
      *
     C                   MOVEL     'AOBANKR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY
     C                   Z-ADD     02            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      ** Initialise work fields
      *
     C                   Z-ADD     *ZEROS        ##DREC
      *
      ** Copyright
      *
     C                   MOVEA     ##CPY         ##BIS
      *
     C     EXINIT        TAG
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  Subroutine  :  SRAUDT                                        *
      *  Function    :  Audit Report Processing                       *
      *                                                               *
      *  Called by   :  Mainline                                      *
      *  Calls       :  CGZAUDIT - Audit Processing                   *
      *                 CG9020   - Write Data to UDC Data Files -     *
      *                 Audit                                         *
      *****************************************************************
     C     SRAUDT        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRAUDT'      @STK(Q)
      *
      ** Output the Count of records read
      *
     C                   CLEAR                   I#DTA
     C                   MOVEL     'CG7430 '     I#REF
     C                   MOVE      'CGD3006'     I#TITL
     C                   MOVE      'CGD1123'     I#TUL
     C                   MOVEL     'CGUSRMSG'    I#FILE
     C                   MOVE      '*LINE   '    W1ACT
     C                   MOVE      *BLANKS       I#SUB
     C                   MOVEL     'SDINPHL1'    I#SUB
     C                   MOVEL     'CGD3003'     I#TEXT
     C                   Z-ADD     ##DREC        I#QTY
     C                   Z-ADD     *ZERO         I#DECS
     C                   MOVE      '1'           I#EDIT
      *
     C                   CALL      'CGZAUDIT'
     C                   PARM                    W1RTN
     C                   PARM                    W1ACT
     C                   PARM                    I#DTA
     C                   PARM                    W1RSQN
      *
      ** Skip a line.
      *
     C                   MOVE      '*SKIP   '    W1ACT
      *
     C                   CALL      'CGZAUDIT'
     C                   PARM                    W1RTN
     C                   PARM                    W1ACT
     C                   PARM                    I#DTA
     C                   PARM                    W1RSQN
      *
      ** Produce the Audit Report.
      *
     C                   CALL      'CG9020'
     C                   PARM      *BLANK        ##RTCD
     C                   PARM      '*AUDIT  '    W0ACT
     C                   PARM      *BLANKS       W0PATH
     C                   PARM                    W0FMT
     C                   PARM      'CGD3006'     W0TITL
     C                   PARM      'CGD1123'     W0ULIN
     C                   PARM                    W0CMT
      *
      ** Close the Audit Print File.
      *
     C                   CLEAR                   I#DTA
     C                   MOVEL     'CG7430 '     I#REF
     C                   MOVE      'CGD3006'     I#TITL
     C                   MOVE      'CGD1123'     I#TUL
     C                   MOVEL     'CGUSRMSG'    I#FILE
      *
     C                   CALL      'CGZAUDIT'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*CLOSE  '    W0ACT
     C                   PARM                    I#DTA
     C                   PARM                    W0RSQN
      *
     C     EXAUDT        TAG
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
     C/COPY CGCPYSRC,SRERRPSSRL
     C/COPY CGCPYSRC,SRERRCLE
**CTDATA ##CPY
(c) Finastra International Limited 2011
