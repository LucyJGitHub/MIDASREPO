     H DEBUG DATEDIT(*DMY)
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas CG Interest Scale Exception Report')             *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG7330 - CG Interest Scale exception report                  *
      *                                                               *
      *  Called By: CGC7330                                           *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      *                 CER042             Date 11May11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CER042 - Interest Scale Report Correspondence                *
      *           (Upgrade of FGE178/179)                             *
      *                                                               *
      *---------------------------------------------------------------*
 
      *  Interest Scale Extract - header
     FCGISDRPD  IP   E             DISK
 
      *  Interest Scale Extract - exception report
     FCG7330P1  O    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLP)
 
      ** Arrays
     D @CD             S             30    DIM(1) CTDATA PERRCD(1)              Error codes
 
      ** Data structure for definition of bank specific details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Data structure for definition of long dummy data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Data area for database error details
     D LDA           E DS           256    EXTNAME(LDA)
 
      ** Installation control details DS
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
 
      *  Program status data structure
     D PSDS           SDS
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      ** Program status data structure
     D SPOOLP          DS
     D  PZFILE                83     92
     D  PZFNUM               123    124B 0
 
     D  PZSEQ          S              5A
     D  PZENTRY        S              3A
     D  PZSNUM         S              6P 0
     D  ZSERR          S              1A
 
      *---------------------------------------------------------------*
      *  Main Routine - Main Controlling subroutine
      *
      *  Called by :  None
      *  Calls     :  First  - Initial houskeeping
      *            :  Last   - Final houskeeping
      *---------------------------------------------------------------*
      ** If not already done, perform initial housekeeping
     C     @FIRST        IFNE      'YES'
     C                   EXSR      FIRST
     C                   ENDIF
 
      ** If exception record, error flag is set
     C     Z5ERRI        IFEQ      'Y'
 
      ** Set up the print fields
      ** Reference details
     C                   SELECT
 
      ** For Dealing, use the short reference
     C     Z5REFT        WHENEQ    'D'
     C                   MOVE      *BLANKS       F2REFN
     C                   MOVE      Z5REFN        @SREF             6
     C                   MOVE      @SREF         F2REFN
     C                   MOVE      'Deal  '      F2TYPE
 
      ** For Lending, use the short reference
     C     Z5REFT        WHENEQ    'L'
     C                   MOVE      *BLANKS       F2REFN
     C                   MOVE      Z5REFN        @SREF
     C                   MOVE      @SREF         F2REFN
     C                   MOVE      'Loan  '      F2TYPE
 
      ** Retail use the long reference
     C     Z5REFT        WHENEQ    'R'
     C                   MOVE      Z5REFN        F2REFN
     C                   MOVE      'Retail'      F2TYPE
     C                   ENDSL
 
      ** Interest from date
     C                   CALL      'ZDATE2'
     C                   PARM      Z5INFD        ZDAYNO            5 0
     C                   PARM      *BLANKS       ZDATFM            1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   MOVE      ZADATE        F2INFD
 
      ** Interest to date
     C                   CALL      'ZDATE2'
     C                   PARM      Z5INCD        ZDAYNO
     C                   PARM      *BLANKS       ZDATFM
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
     C                   MOVE      ZADATE        F2INTD
 
      ** The error description
     C                   Z-ADD     Z5ERRC        @S                3 0
     C                   MOVE      @CD(@S)       F2REAS
 
      ** Output to the report
     C     *IN89         IFEQ      *ON
     C                   WRITE     CG7330H1                             89
     C                   ENDIF
     C                   WRITE     CG7330D1                             89
 
      ** Set the flag to say a record has been written
     C                   MOVE      'YES'         @READ             3
     C                   ENDIF
 
      ** If end of file perform final housekeeping
     CLR                 EXSR      LAST
 
      *  Logical end of the program
 
      *---------------------------------------------------------------*
      *
      *  Initial Processing
      *
      *  Calls     :  None
      *
      *---------------------------------------------------------------*
     C     *INZSR        BEGSR
      *
     C     *DTAARA       DEFINE                  LDA
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
 
      ** Access bank details via an access program
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSSDY
 
      ** Error, record not found
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   Z-ADD     1             DBASE
     C                   MOVEL     PGM           DBPGM
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '*FIRST'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *---------------------------------------------------------------*
      *
      *  FIRST SR. - Initial Processing
      *
      *  Called by :  Main Routine
      *  Calls     :  None
      *
      *---------------------------------------------------------------*
     C     FIRST         BEGSR
 
      ** Get the month and year of the next working day
     C                   CALL      'ZDATE2'
     C                   PARM      BJDNWD        ZDAYNO            5 0
     C                   PARM      *BLANKS       ZDATFM            1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   Z-ADD     ZDATE         MONTH             4 0
 
      ** Set indicator to force overflow first time through
     C                   MOVE      *ON           *IN89
 
     C                   EVAL      PZSNUM = PZFNUM
     C                   CALL      'ZSFILE'
     C                   PARM                    PZSEQ
     C                   PARM      *BLANKS       PZENTRY
     C                   PARM                    PZFILE
     C                   PARM                    PZSNUM
     C                   PARM                    ZSERR
 
     C                   IF        ZSERR = 'Y'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Set the flag to say the routine has been run
     C                   MOVE      'YES'         @FIRST            3
 
     C                   ENDSR
      *---------------------------------------------------------------*
      *  LAST SR. - Final housekeeping
      *
      *  Called by :  Main routine
      *  Calls     :  none
      *---------------------------------------------------------------*
     C     LAST          BEGSR
 
      ** If no record has been written write no details
     C     @READ         IFNE      'YES'
     C                   WRITE     CG7330H1                             89
     C                   WRITE     CG7330D2                             89
     C                   WRITE     CG7330F1                             89
 
      ** If record has been read write end of report
     C                   ELSE
     C     *IN89         IFEQ      *ON
     C                   WRITE     CG7330H1                             89
     C                   ENDIF
     C                   WRITE     CG7330F1                             89
     C                   ENDIF
 
     C                   ENDSR
      *---------------------------------------------------------------*
      *
      * *PSSR  - File exception/ error subroutine
      *
      * Called by: Main routine - Main controlling subroutine
      * Calls:     None
      *
      *---------------------------------------------------------------*
     C     *PSSR         BEGSR
 
      ** If a database error set on U8
     C     DBFILE        IFNE      *BLANK
     C                   MOVE      *ON           *INU8
     C                   ENDIF
 
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INLR
     C                   DUMP
     C                   RETURN
 
     C                   ENDSR
      *  Compile time array data
** @CD
Beyond history period
