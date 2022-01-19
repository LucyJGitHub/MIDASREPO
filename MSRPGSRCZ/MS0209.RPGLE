     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas MS 2780 outgoing message compression')           *
      *****************************************************************
      *                                                               *
      *  Midas - SWIFT Direct Link Module                             *
      *                                                               *
      *   MS0209 - Outgoing Message Compression (2780 Protocol)       *
      *            Specifically for Corona Interface                  *
      *                                                               *
      *  (c) Finastra International Limited 2021                      *
      *                                                               *
      *  Last Amend No. CGL094   *CREATE   Date 02Nov21               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CGL094 - MT940 Interface to Corona (External Network         *
      *           Destination)                                        *
      *         - MT940 messages specified with a Destination of      *
      *           Corona are extracted in MS2780 format for the       *
      *           Corona system.                                      *
      *         - Allow details from field :86: to be the second      *
      *           line for field :61:                                 *
      *         - Ref. number is truncated on MS2780C (now MS940XPD)  *
      *           when it is on the second record on MGOMSGPD         *
      *         - Data base error if no records for CORONA            *
      *         - This program is a copy of the MS0208 modified for   *
      *           the General Bank system including the specials      *
      *           characters and record layout for the PC DOS file    *
      *           Midas MT940 Interface to CORONA                     *
      *         - Chg 'ä' to '{' and 'ü' to '}'.                      *
      *                                                               *
      *****************************************************************
     FMGOREF11  UF   E           K DISK
     FMGOMSGPD  IF   E           K DISK
     FSDBANKPD  IF   E             DISK
     FMS940XPD  UF A E             DISK
     FMS0209AU  O    E             PRINTER INFDS(SPOOLU)
     F                                     USROPN
      *****************************************************************
      *   Index to subroutines                                        *
      *   INIT  - Initial process                                     *
      *   REPT  - Process error report                                *
      *   WRIT  - Output record                                       *
      *   *PSSR - Error handling                                      *
      *****************************************************************
      * ID F  C  H  L    Function of indicators
      * 10               EOF MGOREF11
      * 15               EOF MGOMSGPD
      * 16               1 Record written to MS940XPD
      * 30               MS0209AU open
      * 99               EOF SDBANKPD
      * U7U8LR           DB error
      *
      ********************************************************************
     D FLDA            S              1    DIM(398)
     D IMSG            S              1    DIM(256)                             Incoming msg
     D OMSG            S              1    DIM(9999)                            Compressed msg
     D TMSG            S              1    DIM(9999)
     D AFD             S              1    DIM(50)                              Corona work array
     D AFB             S              1    DIM(51)                              Corona work array
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D ARH             S             80    DIM(3) CTDATA PERRCD(1)
      ********************************************************************
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      **  SAR File Details Accessed via Access Program AOSARDR0
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D* FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
      *
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
      ** File Information DS
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
     D  @DST1                 32     43
     D  @WK4                  40     43
     D  @WK3                  41     43
     D  @WL3                  40     42
     D  @WK1                  43     43
      **  Destination address data structure
      *
     D                 DS
     D  @SW2                   1     49
     D  TXT1                   1      6
     D  @SND2                  7     18
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
      **  Fields for CORONA records
     D                 DS
     D  RECZ                   1     84
     D  Z1                     1      5
     D  Z2                     5     80
     D  Z2MLP                  5     80
     D  Z2A                    6     80
     D  Z2B                    1     80
     D  Z3                    81     82
     D  Z4                    83     84
      *
     D                 DS
     D  COM1                   1     55
     D  IAZ                    1      5
     D  IFD                    6     55
     D  NY3                   16     55
      *
     D                 DS
     D  COM2                   1     55
     D  ZAZ                    1      5
     D  Z2Z                    6     55
      *
      *****************************************************************
      **  Execute initial process
     C                   EXSR      INIT
      *
      **  Read message reference file
     C     *LOVAL        SETLL     MGOREF11
     C                   READ      MGOREF11                               10
      *
      **  Do until EOF message reference file
     C     *IN10         DOWEQ     '0'
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
     C                   MOVEL     TRNO          DBKEY
     C                   Z-ADD     02            DBASE
     C                   OUT       LDA
     C                   WRITE     DBERROR
     C                   EXSR      *PSSR
     C                   END
      *
      **  Expand address to 12 characters with Xs
     C                   MOVEL     NWDS          @DST1
     C     @WK4          IFEQ      '    '
     C                   MOVE      @DST1         @DST2
     C                   MOVE      'XXXX'        @DST2
     C                   ELSE
     C     @WK3          IFEQ      '   '
     C                   MOVE      @DST1         @DST2
     C                   MOVE      'XXX'         @DST2
     C                   ELSE
     C     @WK1          IFEQ      ' '
     C                   MOVEL     'X'           @WL4              4
     C                   MOVE      @WL3          @WL4
     C                   MOVE      @DST1         @DST2
     C                   MOVE      @WL4          @DST2
     C                   ELSE
     C                   MOVE      @DST1         @DST2
     C                   END
     C                   END
     C                   END
      *
      **  Write SWIFT II header to message array
     C                   MOVEL     NWSN          @SND2
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
     C                   MOVE      *BLANKS       IMSG
     C     MFLD          IFNE      *BLANKS
     C                   MOVEA     MFLD          IMSG
     C                   Z-ADD     50            I                 4 0
     C     IMSG(I)       DOWEQ     ' '
     C                   SUB       1             I
     C                   END
     C                   ELSE
     C                   Z-ADD     0             I
     C                   END
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
      *
     C                   EXSR      COROSR
      *
      **  Read outgoing messages file but ignore deleted parts.
     C     PTDL          DOUNE     'D'
     C     *IN15         OREQ      '1'
     C     TRNO          READE     MGOMSGPD                               15
     C                   END
     C                   END
      *
      **  Write end of text block
     C                   MOVEA     '-ü'          OMSG(O)
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
     C                   MOVEA     'ä5:'         OMSG(O)
     C                   ADD       3             O
     C                   MOVEA     'äPDE:ü'      OMSG(O)
     C                   ADD       6             O
     C                   END
      *
      **  ...and TNG (training) trailer as required
     C     @TNG          IFEQ      '0'
     C     *IN14         IFEQ      '0'
     C                   MOVEA     'ä5:'         OMSG(O)
     C                   ADD       3             O
     C                   END
     C                   SETON                                        14
     C                   MOVEA     'äTNG:ü'      OMSG(O)
     C                   ADD       6             O
     C                   END
      *
      **  End trailer block
     C     *IN14         IFEQ      '1'
     C                   MOVE      'ü'           OMSG(O)
     C                   ADD       1             O
     C                   END
      *
      **  Add hash
     C                   MOVEA     HSH           OMSG(O)
     C     O             DIV       398           Y                 2 0
     C                   ADD       1             O
      *
      **  If compressed msg is greater than 2000 bytes output report
     C     O             IFGT      8100
     C                   EXSR      REPT
     C                   END
      *
      **  If ready output records
     C     Y             IFGT      0
     C                   EXSR      WRIT
     C                   END
      *
      **  Update status on Message Reference file
     C                   MOVE      'TRAN'        MGST
     C                   MOVE      '3'           MGSG
     C                   UPDATE    MGOREFD0
      *
      **  Read message reference file
     C                   READ      MGOREF11                               10
     C                   ENDDO
      *
      **  Output remaining record
     C     O             IFGT      1
     C                   Z-ADD     1             Y
     C                   EXSR      WRIT
     C                   END
      *
      ** If *IN16 is off, no records output to MS940XPD, Set on U8 to
      ** ensure CL does not transmit empty file
      *
     C                   SETON                                        LR
      *
      *  Trailer record for Corona
      *
     CLR 16              READ      MS940XPD                               33
     CLR 16              CLEAR                   MSREC
     CLR 16              MOVEL     '-}'          MSREC
     CLR 16              WRITE     MS940XD0
     CLR                 WRITE     ENDRPT
     CLR 30              CLOSE     MS0209AU
     CLR                 RETURN
      *
      *****************************************************************
      *   INIT - inital process                                       *
      *   Called by - main process                                    *
      *****************************************************************
     C     INIT          BEGSR
      *
     C                   MOVEA     CPY@          BIS@             80
      *
      **  Set up LDA
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVE      *BLANKS       DBFILE
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVEL     'MS0209'      DBPGM
     C                   MOVE      *BLANKS       DBASE
     C                   OUT       LDA
      *
      **  Access SDBANKL0 to find run date
     C                   READ      SDBANKPD                               99
     C                   MOVE      BJURPT        #URPT            53
     C                   MOVE      BJMRDT        #MRDT             7
      *
      ** Ensure audit report is recorded by RCF
     C                   EXSR      RECRCF
      *
     C     *IN99         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      'SDBANKPD'    DBFILE
     C                   MOVEL     'FIRST'       DBKEY
     C                   Z-ADD     01            DBASE
     C                   OUT       LDA
     C                   WRITE     DBERROR
     C                   EXSR      *PSSR
     C                   END
      *
      **  Initialise 'CR' and 'LF' fields
     C                   MOVE      *LOVAL        CR                1
     C                   BITON     '457'         CR
     C                   MOVE      *LOVAL        LF                1
     C                   BITON     '257'         LF
     C                   MOVE      *LOVAL        HSH               1
     C                   BITON     '13467'       HSH
     C                   MOVEL     CR            CRLF              2
     C                   MOVE      LF            CRLF
      *
      **  Initialise X'00' field
     C                   BITOFF    '01234567'    #00               1
      *
      **  Initialise text fields
     C                   MOVE      'ä1:F01'      TXT1
     C                   MOVEL     '99999999'    TXT2
     C                   MOVE      '99üä2:I'     TXT2
     C                   MOVEL     'üä4:'        TXT3              4
      *
     C                   Z-ADD     1             O                 4 0
      *
      * Access SAR details to see if CSW001 is switched on
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CSW001'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   MOVE      *BLANKS       CSW001            1
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CSW001
     C                   ELSE
     C     @RTCD         IFNE      '*NRF   '                                    B2
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
     C                   MOVEL     '*VERIFY'     DBKEY                          * DBERR 03 *
     C                   MOVE      '03'          DBASE                          ************
     C                   OUT       LDA
     C                   WRITE     DBERROR
     C                   EXSR      *PSSR
     C                   ENDIF                                                  E2
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  RECRCF - RCF processing                                      *
      *                                                               *
      *****************************************************************
     C     RECRCF        BEGSR
      *
     C                   OPEN      MS0209AU                             30
     C                   WRITE     HEADER
      *
      ** Ensure Detail Spool File recorded by RCF.
      *
     C                   Z-ADD     SFNUMU        ZSNUMU            6 0
     C                   CALL      'ZSFILE'
     C                   PARM                    PSEQ              5
     C                   PARM                    PENTY             3
     C                   PARM                    SFILEU
     C                   PARM                    ZSNUMU
     C                   PARM      *BLANK        ZSERR             1
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
      *
     C     ZSERR         IFEQ      'Y'
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *   WRIT - output record                                        *
      *   Called by - main process                                    *
      *****************************************************************
     C     WRIT          BEGSR
      *
     C                   DO        Y
      *
      **  Move remaining data forward in array
      *
     C                   MOVEA     *BLANKS       TMSG
     C                   MOVEA     OMSG(399)     TMSG
     C                   MOVEA     *BLANKS       OMSG
     C                   MOVEA     TMSG          OMSG
     C                   SUB       398           O
     C                   END
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *   REPT - process error report                                 *
      *   Called by - main process                                    *
      *****************************************************************
     C     REPT          BEGSR
      *
      **  Update message reference record to 'A' if message > 2000
     C                   MOVE      'AMND'        MGST
     C                   MOVE      '1'           MGSG
     C                   UPDATE    MGOREFD0
      *
      * Output error report
     C                   WRITE     DETAIL
      *
     C                   ENDSR
      *****************************************************************
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
      ********************************************************************
      * IGM002 Oct 98 MKI/Belgium - Corona File Creation
      *
      * This routine is written specifically for GENERAL BANK in KOLN.
      * The format used for record layout is MERVE . To copy this file
      * CORONA Pc only one procedure is permitted the FTP not in Binary
      * mode .
      * If this program is modified again take care to the CCSID 273 in
      * Germany country the EBCDIC value is different than the original.
      *
      ********************************************************************
     C     COROSR        BEGSR
      *
     C     *IN35         IFEQ      *ON
     C                   CLEAR                   AFD
     C                   CLEAR                   AFB
     C                   Z-ADD     1             WW                2 0
     C                   Z-ADD     1             YY                2 0
     C                   MOVEA     MFLD          AFD
     C                   MOVEL     Z2Z           MLPFL1           51
     C                   MOVEA     MLPFL1        AFB
     C     AFB(YY)       DOWNE     *BLANK
     C                   ADD       1             YY
     C                   ENDDO
     C     YY            SUB       1             YY
     C     WW            DOWLE     50
     C     AFD(WW)       IFNE      *BLANKS
     C                   ADD       1             YY
     C                   MOVE      AFD(WW)       AFB(YY)
     C     YY            IFEQ      51
     C                   Z-ADD     50            WW
     C                   ENDIF
     C                   ENDIF
     C                   ADD       1             WW
     C                   ENDDO
     C                   MOVEA     AFB           Z2MLP
     C                   MOVE      *ON           *IN36
     C                   MOVE      RECZ          MSREC
     C                   WRITE     MS940XD0
     C                   MOVE      '1'           *IN16
     C                   CLEAR                   RECZ
     C                   ENDIF
     C                   MOVE      *OFF          *IN35
      *
     C     *IN36         IFEQ      *OFF
      *  HEADER
     C     *IN17         IFEQ      *ON
     C     MTAG          ANDEQ     ':20:'
     C                   MOVEL     *BLANKS       OLTTAG
     C                   MOVEL     ARH(3)        RECZ
     C                   READ      MS940XPD                               18
     C                   MOVEL     RECZ          MSREC
     C                   WRITE     MS940XD0
     C                   MOVE      '1'           *IN16
     C                   CLEAR                   RECZ
      *
     C                   MOVEL     ARH(2)        RECZ
     C                   MOVE      '{4'          Z3
     C                   MOVEL     ':'           Z4
     C                   READ      MS940XPD                               18
     C                   MOVEL     RECZ          MSREC
     C                   WRITE     MS940XD0
     C                   CLEAR                   RECZ
     C                   ENDIF
     C     *IN17         IFEQ      *OFF
     C                   CLEAR                   RECZ
     C                   MOVE      *ON           *IN17
     C                   MOVEL     ARH(1)        RECZ
     C                   MOVE      '{4'          Z3
     C                   MOVEL     ':'           Z4
     C                   READ      MS940XPD                               18
     C                   MOVEL     RECZ          MSREC
     C                   WRITE     MS940XD0
     C                   ENDIF
     C                   MOVE      MTAG          IAZ
     C                   MOVE      MFLD          IFD
      *
      *  No blank characters bewteen the fields are allowed.
      *  The message fields cannot begin with special characters .
      *
     C     COM1          IFNE      COM2
     C                   CLEAR                   RECZ
     C                   MOVE      *OFF          *IN34
     C                   MOVEL     MTAG          TTAG              4
     C                   MOVEL     MFLD          TMF               3
     C     TTAG          IFEQ      ':86:'
     C     TMF           ANDEQ     '///'
     C                   MOVE      *ON           *IN34
     C                   MOVE      TTAG          OLTTAG            4
     C                   ENDIF
     C     OLTTAG        IFEQ      ':86:'
     C     TTAG          ANDEQ     '    '
     C                   MOVE      *ON           *IN34
     C                   END
     C     *IN34         IFEQ      *OFF
     C                   READ      MS940XPD                               18
     C                   MOVEL     *BLANKS       OLTTAG
     C                   CLEAR                   Z2
     C                   CLEAR                   Z2A
     C                   CLEAR                   Z2B
     C                   MOVE      MTAG          Z1
     C                   MOVEL     MTAG          Z0                1
     C                   MOVE      MTAG          Z000              1
     C                   MOVE      MTAG          ZWK               2
     C                   MOVEL     ZWK           Z00               1
     C     Z0            IFEQ      ':'
     C     Z00           ANDEQ     ':'
     C                   MOVEL     MFLD          Z2
     C                   MOVEL     Z2            TIR               1
     C     TIR           IFEQ      '-'
     C                   MOVEL     '.'           Z2
     C                   ENDIF
     C                   ENDIF
     C     Z0            IFEQ      ':'
     C     Z000          ANDEQ     ':'
     C                   MOVEL     MFLD          Z2A
     C                   MOVEL     Z2A           TIR
     C     TIR           IFEQ      '-'
     C                   MOVEL     '.'           Z2A
     C                   ENDIF
     C                   ENDIF
     C     Z2            IFEQ      *BLANK
     C     Z2A           ANDEQ     *BLANK
     C                   CLEAR                   AFD
     C                   CLEAR                   AFB
     C                   Z-ADD     *ZERO         WW                2 0
     C                   Z-ADD     *ZERO         YY                2 0
     C                   MOVEA     MFLD          AFD
     C                   ADD       1             WW
     C     WW            DOWLE     50
     C     AFD(WW)       IFNE      *BLANKS
     C                   ADD       1             YY
     C                   MOVE      AFD(WW)       AFB(YY)
     C                   ENDIF
     C                   ADD       1             WW
     C                   ENDDO
     C                   MOVEA     AFB           Z2B
     C                   MOVEL     Z2B           TIR
     C     TIR           IFEQ      '-'
     C                   MOVEL     '.'           Z2B
     C                   ENDIF
     C                   ENDIF
     C                   MOVE      MFLD          Z2Z
     C                   MOVEL     MTAG          ZAZ
     C                   CLEAR                   Z3
      *  COMPLEMENT
     C     TTAG          IFEQ      ':61:'
     C     CTRC          ANDEQ     *BLANK
     C                   MOVE      *ON           *IN35
     C                   ENDIF
      *  TRAILER
     C     *IN35         IFEQ      *OFF
     C                   MOVEL     RECZ          MSREC
     C                   WRITE     MS940XD0
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      * Reset Indicator
     C                   MOVE      *OFF          *IN36
      *
     C                   ENDSR
      ********************************************************************
** CPY@   **      OBJECT COPYRIGHT
(C) Copyright Finastra International Limited 2021
** HEADER RECORD FOR CORONA
{1:F01HELAUS33AXXX0000000000}{2:O9401214991207HELAUS33AXXX00000000009912071214N}
{1:F01HELAUS33AXXX0000000000}{2:O9401214991207HELAUS33AXXX00000000009912071214N}
-}
