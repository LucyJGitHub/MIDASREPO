     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas MS Calculate PAYplus message drop date')         *
      *****************************************************************
      *                                                               *
      *  Midas - General utility                                      *
      *                                                               *
      *  MS100002 - Calculate PAYplus message drop date               *
      *                                                               *
      *  (c) Finastra International Limited 2023                      *
      *                                                               *
      *  Last Amend No. CSW101  *CREATE    Date 07Feb23               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW101 - PAYplus interface                                   *
      *                                                               *
      *****************************************************************
      /EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D*
     D** Array containing Copyright statement
     D*
     D SDMGME        E DS                  EXTNAME(SDMGMEPD)
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      *  EXTERNAL DATA STRUCTURE FOR ACCESS PROGRAM FORMAT
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
     D** FIRST DATA STRUCTURE FOR ACCESS PROGRAM, SHORT DATA STRUCTURE
     D*
     D LDA           E DS           256    EXTNAME(LDA)
      *
     D                 DS
      *
      *    Month of run date
      *
     D  RUNDAT                 1      7
     D  MON1                   3      5
     D                 DS
      *
      *    Month of one week hence
      *
     D  ZADATE                 1      7
     D  MON2                   3      5
     C     *ENTRY        PLIST
     C                   PARM                    RTN               1
     C                   PARM                    DAYAFT            6
     C                   MOVEA     CPY@          BIS@             80
     C     *DTAARA       DEFINE                  LDA
      *
      *    Use access program to obtain record from SDBANKPD
      *    Use access program to obtain record from SDBANKPD
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     P@RTCD            7
     C                   PARM      '*FIRST '     P@OPTN            7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      *    Database error if blank return code not received from access pgm
      *
     C     P@RTCD        IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   Z-ADD     1             DBASE                          ***************
     C                   MOVEL     'SDBANKPD'    DBFILE                         *DB ERROR 01  *
     C                   MOVEL     'MS000002'    DBPGM                          ***************
     C                   OUT       LDA
     C                   RETURN
     C                   END
      *
     C                   CALL      'AOMGMER0'
     C                   PARM      '*MSG   '     P@RTCD            7
     C                   PARM      '*FIRST '     P@OPTN            7
     C     SDMGME        PARM      SDMGME        DSFDY
      *
      *    Database error if blank return code not received from access pgm
      *
     C     P@RTCD        IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   Z-ADD     1             DBASE                          ***************
     C                   MOVEL     'SDMGMEPD'    DBFILE                         *DB ERROR 01  *
     C                   MOVEL     'MS000002'    DBPGM                          ***************
     C                   OUT       LDA
     C                   RETURN
     C                   END
      *
      *
      *
      *    Sub Nr Of day before drop SWIFT-Messages from RUNDATE
     C     BJRDNB        SUB       ENDSMN        ZDAYNO
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO            5 0          Value date
     C                   PARM      BJDFIN        ZDATFM            1            Date format ind
     C                   PARM                    ZDATE             6 0          Value date
     C                   PARM                    ZADATE            7            Run-date in DDM
      *
     C                   MOVE      ZDATE         DAYAFT
      *
      *
      *    Set blank return code and end program
      *
     C                   MOVE      ' '           RTN
     C                   SETON                                        LR
     C                   RETURN
** CPY@   OBJECT COPYRIGHT
(c) Misys International Banking Systems Ltd. 2023
