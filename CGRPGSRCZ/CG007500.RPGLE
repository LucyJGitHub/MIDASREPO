      *****************************************************************
     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas CG Overdraft Reminder Letter - Driver')          *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG007500 - RE Overdraft Reminder Letter - Driver             *
      *                                                               *
      *  Function:  This program reads the Account Maintenance        *
      *             Extension file and calls the extract program for  *
      *             each reminder required.                           *
      *                                                               *
      *  Called By: CGC007500 - RE Overdraft Reminder Letter - Driver *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      *  Prev Amend No. CER055  *CREATE    Date 06Dec10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  CER055 - Penalty Interest on Exceeding Overdraft Limit       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Indicator usage                                              *
      *                                                               *
      *  99   -    Read fail.                                         *
      *                                                               *
      *****************************************************************
     FACCNTBY0  IF   E           K DISK
     F                                     INFSR(SRFILE)
      *
      ** Account Maintenance Master File
      *
     D/SPACE 5
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D/COPY CGCPYSRC,SRERRDLE
      *
     D/SPACE 5
     D DSPARM        E DS                  EXTNAME(ACCNTBY0)
      *
      ** External DS for parameter passed to CG007510
      *
     D CPYR            DS
      *
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** External DS for Bank details
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Second DS for access programs, long data structure
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** First DS for access programs, short data structure
      *
     D SDCLND        E DS                  EXTNAME(SDCLNDPD)
      *
      ** Customer lending ICD
      *
     D W0FMT         E DS                  EXTNAME(CGUDTAPD)
      *
      ** Rundate
      *
     D RUNDAT        E DS
      *
      ** Data Area to Read Previous RUN DATE
      *
     D JNSTAT          DS           200
     D  PRUN                 103    105P 0
      *
      ** Record format of PF/CGUDTAPD for use as a parameter
      *
     D WPDArray        S              3  0 DIM(8) ASCEND
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** Data structure for AOSVALR0 string
      *
      ** Parameter fields
     D W0RTCD          S              7
     D W0CMT           S              3
     D W0COPD          S              1
     D W0RTN           S              7
     D W0ACT           S              8
     D W0RSQN          S              5
     D W0PATH          S            256
     D W1RTN           S              7
     D W1ACT           S              8
     D W1RSQN          S              5
     D PRtnCode        S              7
     D POption         S              7
      *
      ** Work Variables
     D WIdx            S              1  0
     D WOffSet         S              3  0
     D Q               S              5  0
     D ##DREC          S              5  0
     D/COPY CGCPYSRC,CGAUDTDLE
     C/SPACE 5
      *****************************************************************
      *  Process     -  MAINLINE                                      *
      *  Function    -  Mainline processing                           *
      *                                                               *
      *  Called by   -  None                                          *
      *  Calls       -  SRINIT - Initialise Fields on Each Invocation *
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
      ** Initialisation processing
      *
     C                   EXSR      SRINIT
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
     C/SPACE 5
      *****************************************************************
      *  Subroutine  -  SRMAIN                                        *
      *  Function    -  Main processing                               *
      *                                                               *
      *  Called by   -  Mainline                                      *
      *  Calls       -  CG007510 - Reminder Letter Extract            *
      *****************************************************************
     C     SRMAIN        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRMAIN'      @STK(Q)
      *
      ** Read from the Account Details Extension File
      *
     C     *LOVAL        SETLL     ACCNTBY0
     C                   READ      ACCNTBY0                               99    *
      *
      ** Read until End of File
      *
     C                   DOW       *IN99 = '0'
      *
     C                   EVAL      WIdx = %LOOKUPLT(ATNDYE:WPDArray)
     C                   IF        WIdx > 0 and
     C                             WPDArray(WIdx) > 0
     C                   EVAL      WOffset = AGRDNB - PRUN
      *
      ** Produce Statement if the number of days in excess is more than the number of days
      ** defined in Lending ICD.
      *
     C                   IF        ATNDYE - WOffset <= WPDArray(WIdx)
      *
     C                   CALL      'CG007510'
     C                   PARM      *BLANKS       W0RTCD
     C                   PARM      W0CMT         W0CMT
     C                   PARM                    DSPARM
      *
      ** Error in called program.
      *
     C                   IF        W0RTCD <> *BLANK
      *
     C                   EXSR      SRAUDT
      *
      ** Database error
      *
     C                   MOVEL     'CG007510'    W0FILE                         ***************
     C                   MOVEL     W0RTCD        W0KEY                          * DB ERROR 01 *
     C                   Z-ADD     1             W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ADD       1             ##DREC
      *
      ** Read next record from ACCNTBY0
      *
     C                   READ      ACCNTBY0                               99    *
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
     C/SPACE 5
      *****************************************************************
      *  Subroutine  -  SRINIT                                        *
      *  Function    -  Initialise Fields on Program Invocation       *
      *                                                               *
      *  Called by   -  Mainline                                      *
      *  Calls       -  CGZAUDIT - Audit Processing                   *
      *****************************************************************
     C     SRINIT        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRINIT'      @STK(Q)
      *
      ** Retrieve data area
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  JNSTAT
     C                   IN        RUNDAT
     C                   IN        JNSTAT
      *
      ** Call access program for Bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM      '*FIRST  '    POption
     C     SDBANK        PARM      SDBANK        DSSDY
      *
     C                   IF        PRtnCode <> *BLANKS
      *
      ** Database error
      *
     C                   EVAL      W0File = 'AOBANKR0'
     C                   EVAL      W0Key = POption
     C                   EVAL      W0ErNb = 1
     C                   EVAL      W0MsgD = 'MEM5003'
     C                   EVAL      W0MsgF = 'MIDAS'
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ***  Retrieve Lending ICD to get the Past Due Notice Days
      *
     C                   CALL      'AOCLNDR0'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM      '*FIRST '     POption
     C*****SDCLND        PARM      SDCLND        DSFDY                                        CLE134
     C     SDCLND        PARM      SDCLND        DSSDY                                        CLE134
      *
     C                   IF        PRtnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '*FIRST'      DBKEY
     C                   MOVEL     'SDCLNDPD'    DBFILE
     C                   Z-ADD     2             DBASE
     C                   OUT       LDA
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   EVAL      WPDArray(1) = BPPND1
     C                   EVAL      WPDArray(2) = BPPND2
     C                   EVAL      WPDArray(3) = BPPND3
     C                   EVAL      WPDArray(4) = BPPND4
     C                   EVAL      WPDArray(5) = BPPND5
     C                   EVAL      WPDArray(6) = BPPND6
     C                   EVAL      WPDArray(7) = BPPND7
     C                   EVAL      WPDArray(8) = BPPND8
     C                   SORTA     WPDArray
      *
      ** Open the Audit Print File.
      *
     C                   CLEAR                   I#DTA
     C                   MOVEL     'CG007510AU'  I#SPLN
     C                   MOVEL     'CG007510'    I#REF
     C                   MOVE      'CGD3011'     I#TITL
     C                   MOVE      'CGD3012'     I#TUL
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
     C/SPACE 5
      *****************************************************************
      *  Subroutine  -  SRAUDT                                        *
      *  Function    -  Audit Report Processing                       *
      *                                                               *
      *  Called by   -  Mainline                                      *
      *  Calls       -  CGZAUDIT - Audit Processing                   *
      *                 CG9020   - Write Data to UDC Data             *
      *                            Files - Audit                      *
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
     C                   MOVEL     'CG007510'    I#REF
     C                   MOVE      'CGD3011'     I#TITL
     C                   MOVE      'CGD3012'     I#TUL
     C                   MOVEL     'CGUSRMSG'    I#FILE
     C                   MOVE      '*LINE   '    W1ACT
     C                   MOVE      *BLANKS       I#SUB
     C                   MOVEL     'ACCNTBY0'    I#SUB
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
     C                   PARM      *BLANK        W0RTCD
     C                   PARM      '*AUDIT  '    W0ACT
     C                   PARM      *BLANKS       W0PATH
     C                   PARM                    W0FMT
     C                   PARM      'CGD3011'     I#TITL
     C                   PARM      'CGD3012'     I#TUL
     C                   PARM                    W0CMT
      *
      ** Close the Audit Print File.
      *
     C                   CLEAR                   I#DTA
     C                   MOVEL     'CG007510'    I#REF
     C                   MOVE      'CGD3011'     I#TITL
     C                   MOVE      'CGD3012'     I#TUL
     C                   MOVEL     'CGUSRMSG'    I#FILE
      *
     C                   CALL      'CGZAUDIT'
     C                   PARM      *BLANKS       W0RTCD
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
     C/SPACE 5
     C/COPY CGCPYSRC,SRERRPSSRL
     C/SPACE 5
     C/COPY CGCPYSRC,SRERRCLE
     O/SPACE 5
