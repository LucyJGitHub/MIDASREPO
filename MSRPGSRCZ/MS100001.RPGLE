     H DEBUG
     F*****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas MS PAYPlus Outgoing file Compression')           *
      *****************************************************************
      *                                                               *
      *  Midas DBA - SWIFT DIRECT LINK                                *
      *                                                               *
      *  MS100001 - SWIFT MS OUTGOING FILE COMPRESSION                *
      *                                                               *
      *  (c) Finastra International Limited 2023                      *
      *                                                               *
      *  This program is based on the compression program written for *
      *  ST400  communication at SMH Frankfurt.                       *
      *  This program only works for MERVA/ESA File Transfer          *
      *  According to the bank specifications the file could not be   *
      *  greater than 3,000 characters.                               *
      *                                                               *
      *   Last Amend No. CSW101  *CREATE   Date 07Feb23               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *   CSW101 - PAYplus interface -                                *
      *                                                               *
      *****************************************************************
     FMGOREFL3  UF   E           K DISK
     FMGOMSGPD  IF   E           K DISK
     FSDBANKPD  IF   E             DISK
     FMS2780PD  O  A E             DISK
     FMS100001AUO    E             PRINTER USROPN
      *
      * ID F  C  H  L    Function of indicators
      * 10               EOF MGOREFL3
      * 15               EOF MGOMSGPD
      * 30               MS100001AU open
      * 31               LOKUP error
      * 99               EOF SDBANKPD
      * U7U8LR           DB error
      *
     D IMSG            S              1    DIM(256)                             incoming msg
     D OMSG            S              1    DIM(4000)                            compressed msg
     D TMSG            S              1    DIM(4000)
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
     D MSSTAT          DS           256
     D  PDEIND                24     24
      **  MSSTAT data structure
      *
     D LDA             DS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
      **  Local data area data structure
      *
     D                 DS
     D  NWDS                  24     43
     D  @WK4                  32     35
     D  @WK3                  33     35
     D  @WL3                  32     34
     D  @WK1                  35     35
      **  Destination address data structure
      *
     D                 DS
     D  @SW2                   1     49
     D  TXT1                   1      6
     D  @SND2                  7     18
     D  SWK4                  15     18
     D  SWK3                  16     18
     D  SWK2                  17     18
     D  SWK1                  18     18
     D  @TNG                  14     14
     D  TXT2                  19     33
     D  MTPY                  34     36
     D  @DST2                 37     48
     D  MPRY                  49     49
      **  SWIFT II message header
      *
     D                 DS
     D  MTAG                   1      5
     D  @WL1                   5      5
      **  Field tag data structure
      *
     C/EJECT
      *****************************************************************
      *                   Index to subroutines                        *
      *   main process                                                *
      *   INIT  - initial process                                     *
      *   REPT  - process error report                                *
      *   WRIT  - output record                                       *
      *   *PSSR - error handling                                      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      *   main process                                                *
      *   Calls - INIT initial process                                *
      *           REPT  - process error report                        *
      *           WRIT  - output record                               *
      *           *PSSR - error handling                              *
      *****************************************************************
      *
      **  Execute initial process
     C                   EXSR      INIT
      *
      **  Read message reference file
     C     *LOVAL        SETLL     MGOREFL3                           U8
     C                   READ      MGOREFL3                               10
      *
      **  Do until EOF message reference file
     C     *IN10         DOWEQ     '0'
      *
      ** Only process the first part of message for multiple messages
      ** just update message status and status grp for rest of multiple
      *
     C     TRNF          IFEQ      *BLANKS
      *
      **  Process message
     C     TRNO          SETLL     MGOMSGPD
     C     PTDL          DOUNE     'D'
     C     *IN15         OREQ      '1'
     C     TRNO          READE     MGOMSGPD                               15
     C                   END
      *
     C     *IN15         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      'MGOMSGPD'    DBFILE
     C                   MOVEL     TRNO          DBKEY                          * DB ERROR 02 *
     C                   Z-ADD     02            DBASE
     C                   OUT       LDA
     C                   OPEN      MS100001AU
     C                   WRITE     HEADER
     C                   WRITE     DBERROR
     C                   EXSR      *PSSR
     C                   END
      *
      **  Expand address to 12 characters with Xs
     C     @WK4          IFEQ      '    '
     C                   MOVEL     NWDS          @DST2
     C                   MOVE      'XXXX'        @DST2
     C                   ELSE
     C     @WK3          IFEQ      '   '
     C                   MOVEL     NWDS          @DST2
     C                   MOVE      'XXX'         @DST2
     C                   ELSE
     C     @WK1          IFEQ      ' '
     C                   MOVEL     'X'           @WL4              4
     C                   MOVE      @WL3          @WL4
     C                   MOVEL     NWDS          @DST2
     C                   MOVE      @WL4          @DST2
     C                   ELSE
     C                   MOVEL     NWDS          @DST2
     C                   END
     C                   END
     C                   END
      *
      **  Reset array to write new message into
     C                   MOVEA     *BLANK        OMSG
     C                   Z-ADD     1             O
      *
     C                   MOVEL     NWSN          @SND2
      *
      **  Expand address to 12 characters with Xs
     C     SWK4          IFEQ      '    '
     C                   MOVEL     NWSN          @SND2
     C                   MOVE      'XXXX'        @SND2
     C                   ELSE
     C     SWK3          IFEQ      '   '
     C                   MOVEL     NWSN          @SND2
     C                   MOVE      'XXX'         @SND2
     C                   ELSE
     C     SWK2          IFEQ      '  '
     C                   MOVEL     NWSN          @SND2
     C                   MOVE      'XX'          @SND2
     C                   ELSE
     C     SWK1          IFEQ      ' '
     C                   MOVEL     NWSN          @SND2
     C                   MOVE      'X'           @SND2
     C                   ELSE
     C                   MOVEL     NWSN          @SND2
     C                   END
     C                   END
     C                   END
     C                   END
      *
     C                   MOVEA     @SW2          OMSG(O)
     C                   ADD       49            O
      *
      **  Write delivery notification to message array if not blank
     C     DELC          IFNE      *BLANKS
     C                   MOVE      DELC          OMSG(O)
     C                   ADD       1             O
     C                   END
     C                   MOVEA     TXT3          OMSG(O)
     C                   ADD       6             O
      *
      **  Process rest
     C     *IN15         DOWEQ     '0'
      *
      **  Write field tag to message array if not blank
     C     MTAG          IFNE      *BLANKS
     C                   MOVEA     MTAG          OMSG(O)
     C     @WL1          IFEQ      *BLANKS
     C                   ADD       4             O
     C                   ELSE
     C                   ADD       5             O
     C                   END
     C                   END
      *
      **  Write all non blank characters in field to message array
     C     MFLD          IFNE      *BLANKS
     C                   MOVE      *BLANKS       IMSG
     C                   MOVEA     MFLD          IMSG
     C                   Z-ADD     50            I                 4 0
     C     IMSG(I)       DOWEQ     ' '
     C                   SUB       1             I
     C                   END
     C                   ELSE
     C                   Z-ADD     0             I
     C                   ENDIF
      *
     C                   Z-ADD     I             S                 4 0
     C                   Z-ADD     1             I
     C     S             DOWGE     I
     C                   MOVE      IMSG(I)       OMSG(O)
     C                   ADD       1             I
     C                   ADD       1             O
     C                   END
      *
      **  Write CRLF to message array if not blank
     C     CTRC          IFNE      *BLANKS
     C                   MOVEA     CTRC          OMSG(O)
     C                   ADD       2             O
     C                   END
      *
      **  Read outgoing messages file but ignore deleted parts.
     C     PTDL          DOUNE     'D'
     C     *IN15         OREQ      '1'
     C     TRNO          READE     MGOMSGPD                               15
     C                   END
     C                   END
      *
      **  Write end of text block
     C                   MOVEA     '-}'          OMSG(O)
     C                   ADD       2             O
      *
      **  Add trailer block (block 5)
      **  PDE (possible duplicate) trailer...
     C                   SETOFF                                       14
      *
     C     *DTAARA       DEFINE                  MSSTAT
     C                   IN        MSSTAT
     C     PDEIND        IFEQ      'Y'
     C                   SETON                                        14
     C                   MOVEA     '{5:'         OMSG(O)
     C                   ADD       3             O
     C                   MOVEA     '{PDE:}'      OMSG(O)
     C                   ADD       6             O
     C                   END
      *
      **  ...and TNG (training) trailer as required
     C     @TNG          IFEQ      '0'
     C     *IN14         IFEQ      '0'
     C                   MOVEA     '{5:'         OMSG(O)
     C                   ADD       3             O
     C                   END
     C                   SETON                                        14
     C                   MOVEA     '{TNG:}'      OMSG(O)
     C                   ADD       6             O
     C                   END
      *
      **  End trailer block
     C     *IN14         IFEQ      '1'
     C                   MOVE      '}'           OMSG(O)
     C                   ADD       1             O
     C                   END
      *
      **  If compressed msg is greater than 3000 bytes output report
     C     O             IFGT      3000
     C                   EXSR      REPT
     C                   END
      *
      **  Output records
     C                   EXSR      WRIT
      *
     C                   ENDIF
      *
      **  Update status on Message Reference file
     C                   MOVE      'PEND'        MGST
     C                   MOVE      '2'           MGSG
     C                   UPDATE    MGOREFD0
     C                   COMMIT
      *
      **  Read message reference file
     C                   READ      MGOREFL3                               10
     C                   END
      *
     C                   SETON                                        LR
     C/EJECT
      *****************************************************************
      *   INIT - inital process                                       *
      *   Called by - main process                                    *
      *****************************************************************
      *
     C     INIT          BEGSR
      *
     C                   MOVEA     CPY@          BIS@             80
      *
      **  Set up LDA
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVE      *BLANKS       DBFILE
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVEL     'MS100001'    DBPGM
     C                   MOVE      *BLANKS       DBASE
     C                   OUT       LDA
      *
      **  Access SDBANKL0 to find run date
     C                   READ      SDBANKPD                               99
      *
     C     *IN99         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      'SDBANKPD'    DBFILE
     C                   MOVEL     'FIRST'       DBKEY                          * DB ERROR 01 *
     C                   Z-ADD     01            DBASE
     C                   OUT       LDA
     C                   OPEN      MS100001AU
     C                   WRITE     HEADER
     C                   WRITE     DBERROR
     C                   EXSR      *PSSR
     C                   END
      *
      **  Initialise 'CR' and 'LF' fields
     C                   MOVE      *LOVAL        CR                1
     C                   BITON     '457'         CR
     C                   MOVE      *LOVAL        LF                1
     C                   BITON     '257'         LF
     C                   MOVEL     CR            CRLF              2
     C                   MOVE      LF            CRLF
      *
      **  Initialise text fields
     C                   MOVE      '{1:F01'      TXT1
     C                   MOVEL     '99999999'    TXT2
     C                   MOVE      '99}{2:I'     TXT2
     C                   MOVEL     '}{4:'        TXT3
     C                   MOVE      CRLF          TXT3              6
      *
     C                   Z-ADD     1             O                 4 0
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *   WRIT - output record                                        *
      *   Called by - main process                                    *
      *****************************************************************
      *
     C     WRIT          BEGSR
      *
     C                   MOVEA     OMSG          FIELD
     C                   WRITE     MS2780F
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *   REPT - process error report                                 *
      *   Called by - main process                                    *
      *****************************************************************
      *
     C     REPT          BEGSR
      *
      **  Update message reference record to 'A' if message > 2000
     C                   MOVE      'AMND'        MGST
     C                   MOVE      '1'           MGSG
     C                   UPDATE    MGOREFD0
     C                   COMMIT
      *
      * Output error report
     C                   OPEN      MS100001AU                           30
     C                   WRITE     HEADER
     C                   WRITE     DETAIL
     C                   CLOSE     MS100001AU
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *   *PSSR - error handling                                      *
      *   Called by - main process                                    *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   RETURN
      *
     C                   ENDSR
** CPY@   **      OBJECT COPYRIGHT
(c) Finastra International Limited 2023
