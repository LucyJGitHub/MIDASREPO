     H
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas CG Interest Scale Reports - Driver')             *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG7290 - Interest Scale Report (Driver)                      *
      *                                                               *
      *  Function:  This program reads the Interest Scale DL/LE       *
      *  (COB)      header file and runs the extract program for      *
      *             for each valid record.                            *
      *                                                               *
      *  Called By: CGC7290                                           *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      *                 AR822166           Date 30Aug11               *
      *                 CER042 *CREATE     Date 13May11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  AR822166 - Component CGC2050 00031 failed in error but the   *
      *             status is Completed (Child: AR822167)             *
      *  CER042 - Interest Scale Report Correspondence                *
      *           (Upgrade of FGE178/179)                             *
      *                                                               *
      *---------------------------------------------------------------*
      *  Interest Scale DL/LE Header file
     FCGISDRL0  IP   E             DISK
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  Copyright array.
     D ##CPY           S             80    DIM(1) CTDATA PERRCD(1)
      *
      *  Subroutine stack array
      /COPY CGCPYSRC,SRERRDLE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Parameter fields
     D W0RTN           S              7A
     D W0CMT           S              3A
      *
      ** Work fields
     D Q               S              5P 0
     D ##MKI           S             80A
     D ##RTCD          S              7A
      *
      *  Data structure to define the passed parameter to extract
     D DSPARM        E DS                  EXTNAME(CGISDRPD)
      *
      *  Data Structure for Compilation - Copyright Insertion
     D CPYR            DS
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  Main routine - main controling subroutine
      *
      *  Called by :  none
      *  Calls     :  none
      *
      **  Parameter list for current program invocation.
     C     *ENTRY        PLIST
     C                   PARM                    W0RTN
     C                   PARM                    W0CMT
      *
     C     *DTAARA       DEFINE                  LDA
      *
      *  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'MAIN'        @STK(Q)
      *
      *  Copyright
     C                   MOVEA     ##CPY         ##MKI
      *
      *  Ignore the record if there is an error flag set
     C     Z5ERRI        IFNE      'Y'
      *
      *  Set up the parameters and call the Extract program.
     C                   CALL      'CG7300'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM                    W0CMT
     C                   PARM                    DSPARM
      *
      *  Error in called program.
     C     ##RTCD        IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   Z-ADD     1             DBASE
     C                   MOVEL     ##PGM         DBPGM                          ***************
     C                   MOVEL     'CG7300  '    DBFILE                         *DB ERROR 001 *
     C                   MOVEL     '*FIRST'      DBKEY                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
      *  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
      *  Logical end of the program
      *****************************************************************
      /EJECT
      *****************************************************************
      * *PSSR  - File exception/ error subroutine
      *
      * Called by: Main routine - Main controlling subroutine
      * Calls:     None
      *
     C     *PSSR         BEGSR
      **********                                                                            AR822166
      ***If*a*database*error*set*on*u8                                                      AR822166
      **********                                                                            AR822166
     C*****DBFILE        IFNE      *BLANK                                                   AR822166
     C                   MOVE      *ON           *INU8
     C**********         ENDIF                                                              AR822166
      *
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INLR
     C                   DUMP
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
      /EJECT
      *****************************************************************
      *
      *  Compile time array data
      *
** ##CPY  **      OBJECT COPYRIGHT
(c) Finastra International Limited 2011
