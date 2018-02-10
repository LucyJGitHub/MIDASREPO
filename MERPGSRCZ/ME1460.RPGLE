     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ME BIC database converter')
      *****************************************************************
      *                                                               *
      *  Midas - Message Management Module                            *
      *                                                               *
      *  ME1460 - BIC Database Converter                              *
      *                                                               *
      *  Function - This program reads all the records on the         *
      *             Download  MEBICPPD, concatenates the fields: BIC, *
      *             institution, location, CHIPS, and clearing code;  *
      *             and write the result into a single field on the   *
      *             BIC search index file MEBICIPD.                   *
      *                                                               *
      *  Called By: MEC1460 - BIC Database Converter                  *
      *                                                               *
      *  (c) Finastra International Limited 2007                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. BUG21300           Date 14Oct08               *
      *                 CFT040             Date 15Sep08               *
      *                 CFT035  *Create    Date 22Jan07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG21300 - Address field error                               *
      *  CFT040 - BIC Plus IBAN                                       *
      *  CFT035 - BIC Database Changes                                *
      *                                                               *
      *****************************************************************
     FMEDWHDPD  IF   F 1248        DISK
     FMEDWCTPD  IF   F 1248        DISK
     FMEDWFIPD  IF   F 1248        DISK
     FMEDWISPD  IF   F 1248        DISK                                                       CFT040
     FMETICVPD  UF A E             DISK
     FMETICCPD  UF A E             DISK
     FMETICPPD  UF A E             DISK
     FMETICBPD  UF A E             DISK    PREFIX(A_)                                         CFT040
     FMETICSPD  UF A E             DISK                                                       CFT040
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *    F U N C T I O N   O F   I N D I C A T O R S                *
      *                                                               *
      *       64  End of file MEDWISPD                                *                       CFT040
      *       U1  Invalid data CT file                                *                       CFT040
      *       U2  Invalid data BI file                                *                       CFT040
      *       U3  Invalid data IS file                                *                       CFT040
      *                                                               *
      *****************************************************************
      /EJECT
      *
     D
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Array containing Copyright statement
      *
     D ARRAY           S              1    DIM(1248)
     D RECORD          S              1    DIM(1248)
     D LEFT            S              1    DIM(1248)
     D FIELD           S              1    DIM(1248)
     D PSARD           S              6A                                                      CFT040
     D MOVE            S              1A                                                      CFT040
     D CFT040          S              1A                                                      CFT040
     D DATA            S            250    DIM(90)
     D CR              C                   CONST(X'0D')
     D LF              C                   CONST(X'25')
     D TB              C                   CONST(X'05')
      *
      ** Data Structure for Conversion Data
      *
     D                 DS
     D  W#CONV                 1   1248
      *                                                                                       CFT040
     D INHDR         E DS                  EXTNAME(INHDR)                                     CFT040
      ** Version date data area                                                               CFT040
      *                                                                                       CFT040
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CFT040
      ** External DS for SAR Details                                                          CFT040
      *                                                                                       CFT040
     D BICPlusIBAN   E DS                  EXTNAME(METICBPD)                                  CFT040
     D                                     PREFIX(A_)                                         CFT040
      ** BIC Plus IBAN                                                                        CFT040
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short data structure for access objects
      *
     D LDA             DS           256
      ** Local data area for database error details
      *
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
     D  DBTXT                184    256
      *
     IMEDWFIPD  FI
     I                                  1 1248  DWFI
     IMEDWCTPD  CT
     I                                  1 1248  DWCT
     IMEDWHDPD  HD
     I                                  1 1248  DWHD
     IMEDWISPD  IS                                                                            CFT040
     I                                  1 1248  DWIS                                          CFT040
      *
     I@TICVPD
     I              BCFIL5                      BVFIL5
      /EJECT
      *****************************************************************
      *                                                               *
      *                   Index to subroutines                        *
      *  Main routine                                                 *
      *  SRINIT  -  Initial processing                                *
      *  SRDETL  -  Detail processing                                 *
      *  SRCONV  -  Convert ASCII record to EBCDIC                    *
      *  SRMOVE  -  Move data into arrays of fields                   *
      *  WRITEH  -  Write record to header                            *
      *  WRITEC  -  Write record to country                           *
      *  WRITEB  -  Write record to BIC                               *
      *  WRITES  -  Write record to IBAN structure                    *                       CFT040
      *  WRITEI  -  Write record to BIC Database plus                 *                       CFT040
      *  WRITEP  -  Write BIC Database plus record                    *                       CFT040
      *  SREND   -  End program                                       *
      *  *PSSR   -  Error handling subroutine                         *
      *                                                               *
      *****************************************************************
      *
      ** Main Program
      *
      *
      ** Perform initial processing
      *
     C                   EXSR      SRINIT
      *
      ** Perform different detailed processing
      *
     C                   EXSR      SRDETL
      *
      ** Terminate program
      *
     C                   EXSR      SREND
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT  -  Initial Processing                                *
      *  Called by: Main routine                                      *
      *  Calls    : AOBANKR0 - Access Bank Details                    *
      *                                                               *
      *****************************************************************
      *
     C     SRINIT        BEGSR
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Define LDA
      *
     C     *DTAARA       DEFINE                  LDA
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'ME1460'      DBPGM
     C                   MOVE      *BLANKS       DBFILE
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVE      *BLANKS       DBTXT
     C                   Z-ADD     0             DBASE
     C                   OUT       LDA
      *
      ** Retrieve bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*FIRST  '    POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     1             DBASE                          ***************
     C                   MOVEL     'SDBANKPD'    DBFILE                         *DB ERROR 001 *
     C                   MOVEL     '*FIRST  '    DBKEY                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CFT040
      ** Check if CFT040 is enabled                                                           CFT040
      *                                                                                       CFT040
     C                   CALL      'AOSARDR0'                                                 CFT040
     C                   PARM      *BLANKS       Prtcd                                        CFT040
     C                   PARM      '*VERIFY'     Poptn                                        CFT040
     C                   PARM      'CFT040'      Psard                                        CFT040
     C     SCSARD        PARM      SCSARD        Dsfdy                                        CFT040
      *                                                                                       CFT040
     C                   IF        Prtcd = *BLANKS                                            CFT040
     C                   EVAL      CFT040 = 'Y'                                               CFT040
     C                   ELSE                                                                 CFT040
      *                                                                                       CFT040
     C                   EVAL      CFT040 = 'N'                                               CFT040
     C                   IF        Prtcd <> '*NRF   '                                         CFT040
     C     *LOCK         IN        LDA                                                        CFT040
     C                   EVAL      DBFile = 'SCSARDPD'                                        CFT040
     C                   EVAL      DBKey = Poptn                                              CFT040
     C                   EVAL      DBase = 5                                                  CFT040
     C                   OUT       LDA                                                        CFT040
     C                   EXSR      *PSSR                                                      CFT040
     C                   ENDIF                                                                CFT040
     C                   ENDIF                                                                CFT040
      *
      ** Initialise work fields and indicators
      *
     C                   MOVEL     *BLANKS       W#DATA         1248
     C                   MOVEL     *BLANKS       W#CONV         1248
     C                   MOVE      *OFF          *IN98
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDETL  -  Detail Processing                                 *
      *  Called by: Main routine                                      *
      *  Calls    : SRCONV, SRHEAD, SRPOST, SRSPOT                    *
      *                                                               *
      *****************************************************************
      *
     C     SRDETL        BEGSR
      *
      ** Process header record
      *
     C**********         READ      MEDWHDPD                               60                  CFT040
      *                                                                                       CFT040
     C******IN60         IFEQ      '1'                                                        CFT040
     C******LOCK         IN        LDA                                                        CFT040
     C**********         Z-ADD     2             DBASE                         ***************CFT040
     C**********         MOVEL     'MEDWHDPD'    DBFILE                        *DB ERROR 002 *CFT040
     C**********         MOVEL     '*FIRST  '    DBKEY                         ***************CFT040
     C**********         OUT       LDA                                                        CFT040
     C**********         EXSR      *PSSR                                                      CFT040
     C**********         ELSE                                                                 CFT040
     C**********         MOVEL     'H'           MOVE              1                          CFT040
     C******IN60         DOWEQ     '0'                                                        CFT040
     C**********         MOVEL     DWHD          W#DATA                                       CFT040
     C**********         EXSR      SRCONV                                                     CFT040
     C**********         EXSR      SRMOVE                                                     CFT040
     C**********         READ      MEDWHDPD                               60                  CFT040
     C**********         ENDDO                                                                CFT040
     C**********         ENDIF                                                                CFT040
      *                                                                                       CFT040
     C     *DTAARA       DEFINE                  INHDR                                        CFT040
     C                   IN        INHDR                                                      CFT040
     C     INHDRS        IFEQ      *Blanks                                                    CFT040
     C     *LOCK         IN        LDA                                                        CFT040
     C                   Z-ADD     8             DBASE                                        CFT040
     C                   MOVEL     'INHDR'       DBFILE                                       CFT040
     C                   MOVEL     '*FIRST  '    DBKEY                                        CFT040
     C                   OUT       LDA                                                        CFT040
     C                   EXSR      *PSSR                                                      CFT040
     C                   ENDIF                                                                CFT040
      *                                                                                       CFT040
     C                   EVAL      BVTAG = 'HD'                                               CFT040
     C                   EVAL      BVRBLD = INHDRS                                            CFT040
     C                   EVAL      BVRDAT = INHDRS                                            CFT040
     C                   EVAL      BVVERS = '_VERSION'                                        CFT040
     C                   EVAL      BVNNN = '001'                                              CFT040
     C                   EVAL      BVFIL1 = *Blanks                                           CFT040
     C                   EVAL      BVFIL2 = *Blanks                                           CFT040
     C                   EVAL      BVFIL3 = *Blanks                                           CFT040
     C                   EVAL      BVFIL4 = *Blanks                                           CFT040
     C                   EVAL      BCFIL5 = *Blanks                                           CFT040
      *                                                                                       CFT040
     C                   WRITE     @TICVPD                                                    CFT040
      *
      ** Process country record
      *
     C                   READ      MEDWCTPD                               61
      *
     C     *IN61         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     3             DBASE                          ***************
     C                   MOVEL     'MEDWCTPD'    DBFILE                         *DB ERROR 003 *
     C                   MOVEL     '*FIRST  '    DBKEY                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVEL     'C'           MOVE
     C                   MOVE      '1'           *INU1                                        CFT040
     C                   MOVEA     *BLANKS       LEFT
     C     *IN61         DOWEQ     '0'
     C                   MOVEL     DWCT          W#DATA
     C                   EXSR      SRCONV
     C                   EXSR      SRMOVE
     C                   READ      MEDWCTPD                               61
     C                   ENDDO
     C                   ENDIF
      *
      ** Process BIC record
      *
     C                   READ      MEDWFIPD                               62
      *
     C     *IN62         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     4             DBASE                          ***************
     C                   MOVEL     'MEDWFIPD'    DBFILE                         *DB ERROR 004 *
     C                   MOVEL     '*FIRST  '    DBKEY                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C**********         MOVEL     'B'           MOVE                                         CFT040
     C                   IF        CFT040 = 'Y'                                               CFT040
     C                   MOVEL     'I'           MOVE                                         CFT040
     C                   ELSE                                                                 CFT040
     C                   MOVEL     'P'           MOVE                                         CFT040
     C                   ENDIF                                                                CFT040
     C                   MOVE      '1'           *INU2                                        CFT040
      *                                                                                       CFT040
     C                   MOVEA     *BLANKS       LEFT
     C     *IN62         DOWEQ     '0'
     C                   MOVEL     DWFI          W#DATA
     C                   MOVE      *BLANKS       W#CONV                                       CFT040
     C                   MOVE      *BLANKS       DATA                                         CFT040
     C                   EXSR      SRCONV
     C                   EXSR      SRMOVE
     C                   READ      MEDWFIPD                               62
     C                   ENDDO
     C                   ENDIF
      *                                                                                       CFT040
     C                   IF        CFT040 = 'Y'                                               CFT040
      *                                                                                       CFT040
      ** Process IBAN Structure                                                               CFT040
      *                                                                                       CFT040
     C                   READ      MEDWISPD                               64                  CFT040
      *                                                                                       CFT040
     C     *IN64         IFEQ      '1'                                                        CFT040
     C     *LOCK         IN        LDA                                                        CFT040
     C                   Z-ADD     7             DBASE                                        CFT040
     C                   MOVEL     'MEDWISPD'    DBFILE                                       CFT040
     C                   MOVEL     '*FIRST  '    DBKEY                                        CFT040
     C                   OUT       LDA                                                        CFT040
     C                   EXSR      *PSSR                                                      CFT040
     C                   ELSE                                                                 CFT040
     C                   MOVEL     'S'           MOVE                                         CFT040
     C                   MOVE      '1'           *INU3                                        CFT040
     C                   MOVEA     *BLANKS       LEFT                                         CFT040
     C     *IN64         DOWEQ     '0'                                                        CFT040
     C                   MOVE      *BLANKS       W#DATA                                       CFT040
     C                   MOVE      *BLANKS       W#CONV                                       CFT040
     C                   MOVE      *BLANKS       DATA                                         CFT040
     C                   MOVEL     DWIS          W#DATA                                       CFT040
     C                   EXSR      SRCONV                                                     CFT040
     C                   EXSR      SRMOVE                                                     CFT040
     C                   READ      MEDWISPD                               64                  CFT040
     C                   ENDDO                                                                CFT040
     C                   ENDIF                                                                CFT040
     C                   ENDIF                                                                CFT040
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCONV  -  Convert ASCII record to EBCDIC                    *
      *  Called by: SRDETL                                            *
      *  Calls    : QDCXLATE - Standard program to convert ASCII      *
      *                        to EBCDIC                              *
      *                                                               *
      *****************************************************************
      *
     C     SRCONV        BEGSR
      *
      ** Call standard QDCXLATE to convert IAT from ASCII to EBCDIC
      *
     C                   CALL      'QDCXLATE'
      *
     C                   PARM      1248          P#LEN             5 0
     C                   PARM      W#DATA        P#DTA          1248
     C                   PARM      'QTCPEBC'     P#TAB            10
     C                   PARM      'QUSRSYS'     P#LIB            10
      *
      ** Set converted EBCDIC IAT Data
      *
     C                   MOVEL     P#DTA         W#CONV
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMOVE  -  Move data into arrays                             *
      *  Called by: SRDETL                                            *
      *  Calls    : WRITEH                                            *
      *                                                               *
      *****************************************************************
      *
     C     SRMOVE        BEGSR
      *
     C                   Z-ADD     0             ENDPOS            5 0
     C                   Z-ADD     1             E                 5 0
     C                   Z-ADD     1             F                 5 0
     C                   MOVEA     *BLANKS       ARRAY
     C                   MOVEA     W#CONV        ARRAY
      *
      ** Look up CRLF in the converted data
      *
     C     CR            LOOKUP    ARRAY(E)                               50
     C     E             ADD       1             F
      *
     C     LEFT(1)       IFNE      *BLANKS
     C     LEFT(2)       ANDNE     *BLANKS
     C     ARRAY(1)      ANDEQ     LF
     C                   Z-ADD     1             E
     C                   Z-ADD     1             F
     C                   ENDIF
      *
     C     *IN50         DOWEQ     '1'
     C     F             ANDLE     1248
     C     LF            ANDEQ     ARRAY(F)
     C
     C                   MOVEA     *BLANKS       RECORD
     C                   Z-ADD     1             J                 5 0
     C     LEFT(1)       IFNE      *BLANKS
     C     LEFT(2)       ORNE      *BLANKS
     C                   Z-ADD     1             I
     C     I             DOWLE     LEN
     C                   MOVEA     LEFT(I)       RECORD(J)
     C                   ADD       1             I
     C                   ADD       1             J
     C                   ENDDO
     C                   MOVEA     *BLANKS       LEFT
     C                   ENDIF
     C     1             ADD       ENDPOS        I                 5 0
     C     I             DOWLT     E
     C                   MOVE      ARRAY(I)      RECORD(J)
     C                   ADD       1             I
     C                   ADD       1             J
     C                   ENDDO
     C                   Z-ADD     F             ENDPOS
     C                   Z-ADD     0             TABPOS            5 0
      *
      ** Look up Tab in the converted data
      *
     C                   Z-ADD     1             T                 5 0
     C                   Z-ADD     1             D                 5 0
     C     TB            LOOKUP    RECORD(T)                              51
     C     *IN51         DOWEQ     '1'
     C     1             ADD       TABPOS        I                 5 0
     C                   Z-ADD     1             J                 5 0
     C                   MOVEA     *BLANKS       FIELD
     C     I             DOWLT     T
     C                   MOVE      RECORD(I)     FIELD(J)
     C                   ADD       1             I
     C                   ADD       1             J
     C                   ENDDO
     C                   MOVEA     FIELD         DATA(D)
     C                   ADD       1             D
     C                   Z-ADD     T             TABPOS
     C                   ADD       1             T
     C     TB            LOOKUP    RECORD(T)                              51
     C                   ENDDO
     C     1             ADD       TABPOS        I                 5 0
     C                   Z-ADD     1             J                 5 0
     C                   MOVEA     *BLANKS       FIELD
     C     I             DOWLE     1248
     C                   MOVE      RECORD(I)     FIELD(J)
     C                   ADD       1             I
     C                   ADD       1             J
     C                   ENDDO
     C                   MOVEA     FIELD         DATA(D)
     C                   ADD       1             D
     C                   ADD       2             E
      *
     C     DATA(1)       IFNE      'TAG'
     C     DATA(1)       ANDNE     *BLANKS
     C     MOVE          IFEQ      'H'
     C                   EXSR      WRITEH
     C                   ENDIF
     C     MOVE          IFEQ      'C'
     C                   EXSR      WRITEC
     C                   ENDIF
     C     MOVE          IFEQ      'B'
     C                   EXSR      WRITEB
     C                   ENDIF
     C     MOVE          IFEQ      'I'                                                        CFT040
     C                   EXSR      WRITEI                                                     CFT040
     C                   ENDIF                                                                CFT040
     C     MOVE          IFEQ      'S'                                                        CFT040
     C                   EXSR      WRITES                                                     CFT040
     C                   ENDIF                                                                CFT040
     C     MOVE          IFEQ      'P'                                                        CFT040
     C                   EXSR      WRITEP                                                     CFT040
     C                   ENDIF                                                                CFT040
     C                   ENDIF
     C     E             IFLE      1248
     C     CR            LOOKUP    ARRAY(E)                               50
     C                   ELSE
     C                   MOVEL     '0'           *IN50
     C                   ENDIF
     C     E             ADD       1             F
     C                   ENDDO
     C*
     C     1             ADD       ENDPOS        I
     C                   Z-ADD     1             J
     C                   MOVEA     *BLANKS       LEFT
     C     1248          SUB       ENDPOS        LEN               5 0
     C     I             DOWLE     1248
     C     ARRAY(I)      IFNE      CR
     C     ARRAY(I)      ANDNE     LF
     C                   MOVE      ARRAY(I)      LEFT(J)
     C                   ENDIF
     C                   ADD       1             I
     C                   ADD       1             J
     C                   ENDDO
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  WRITEH  -  Wrtie Header Record                               *
      *  Called by: SRMOVE                                            *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     WRITEH        BEGSR
      *
     C                   MOVEL     DATA(1)       BVTAG
     C                   MOVEL     DATA(2)       BVRBLD
     C                   MOVEL     DATA(3)       BVRDAT
     C                   MOVEL     DATA(4)       BVVERS
     C                   MOVEL     DATA(5)       BVNNN
     C                   WRITE     @TICVPD
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  WRITEC  -  Wrtie Country Record                              *
      *  Called by: SRMOVE                                            *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     WRITEC        BEGSR
      *
     C                   MOVEL     DATA(1)       BCTAG
     C                   MOVEL     DATA(2)       BCFLAG
     C                   MOVEL     DATA(3)       BCCNTC
     C                   MOVEL     DATA(4)       BCCNTY
     C                   WRITE     @BICCPD
     C                   MOVE      '0'           *INU1                                        CFT040
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************                       CFT040
      *                                                               *                       CFT040
      *  WRITEI  -  Write BIC Record                                  *                       CFT040
      *  Called by: SRMOVE                                            *                       CFT040
      *  Calls    : None                                              *                       CFT040
      *                                                               *                       CFT040
      *****************************************************************                       CFT040
      *                                                                                       CFT040
     C     WRITEI        BEGSR                                                                CFT040
      *                                                                                       CFT040
     C                   MOVEL     DATA(1)       A_BITAG                                      CFT040
     C                   MOVEL     DATA(2)       A_BIFLAG                                     CFT040
     C                   MOVEL     DATA(3)       A_BIKEY                                      CFT040
     C                   MOVEL     DATA(4)       A_BIINST                                     CFT040
     C                   MOVEL     DATA(5)       A_BICITY                                     CFT040
     C                   MOVEL     DATA(6)       A_BIBINF                                     CFT040
     C                   MOVEL     DATA(7)       A_BIBICC                                     CFT040
     C                   MOVEL     DATA(8)       A_BIBRCD                                     CFT040
     C                   MOVEL     DATA(9)       A_BIUBIC                                     CFT040
     C                   MOVEL     DATA(10)      A_BIUBRC                                     CFT040
     C                   MOVEL     DATA(11)      A_BIIBIC                                     CFT040
     C                   MOVEL     DATA(12)      A_BIIBRC                                     CFT040
     C                   MOVEL     DATA(13)      A_BIRBIC                                     CFT040
     C                   MOVEL     DATA(14)      A_BIRBRC                                     CFT040
     C                   MOVEL     DATA(15)      A_BIPBCD                                     CFT040
     C                   MOVEL     DATA(16)      A_BICTCD                                     CFT040
     C                   MOVEL     DATA(17)      A_BINATI                                     CFT040
     C                   MOVEL     DATA(18)      A_BIUNTI                                     CFT040
     C                   MOVEL     DATA(19)      A_BIICTY                                     CFT040
     C                   MOVEL     DATA(20)      A_BIINAT                                     CFT040
     C                   MOVEL     DATA(21)      A_BIUIND                                     CFT040
     C                   MOVEL     DATA(22)      A_BIOND1                                     CFT040
     C                   MOVEL     DATA(23)      A_BIOND2                                     CFT040
     C                   MOVEL     DATA(24)      A_BICHIP                                     CFT040
     C                   MOVEL     DATA(25)      A_BISTYP                                     CFT040
     C                   MOVEL     DATA(26)      A_BISERV                                     CFT040
     C                   MOVEL     DATA(27)      A_BIBRQA                                     CFT040
     C                   MOVEL     DATA(28)      A_BISPCD                                     CFT040
     C                   MOVEL     *BLANKS       TEMPA                                        CFT040
     C                   MOVEL     *BLANKS       TEMPB                                        CFT040
     C                   MOVEL     *BLANKS       TEMPC                                        CFT040
     C                   MOVEL     *BLANKS       TEMPD                                        CFT040
     C                   MOVEL     *BLANKS       TEMPY                                        CFT040
     C                   MOVEL     *BLANKS       TEMPZ                                        CFT040
     C                   MOVEL     DATA(29)      TEMPA                                        CFT040
     C                   MOVEL     DATA(30)      TEMPB                                        CFT040
     C                   MOVEL     DATA(31)      TEMPC                                        CFT040
     C                   MOVEL     DATA(32)      TEMPD                                        CFT040
     C**********         EVAL      TEMPY = (%TRIM(TEMPA) + ' ' +                     CFT040 BUG21300
     C**********                           %TRIM(TEMPB))                             CFT040 BUG21300
     C**********         EVAL      TEMPZ = (%TRIM(TEMPC) + ' ' +                     CFT040 BUG21300
     C**********                           %TRIM(TEMPD))                             CFT040 BUG21300
     C**********         EVAL      A_BIADDR = (%TRIM(TEMPY) + ' ' +                  CFT040 BUG21300
     C**********                              %TRIM(TEMPZ))                          CFT040 BUG21300
     C     TEMPA         CAT       TEMPB         TEMPY                                      BUG21300
     C     TEMPC         CAT       TEMPD         TEMPZ                                      BUG21300
     C     TEMPY         CAT       TEMPZ         A_BIADDR                                   BUG21300
      *                                                                                       CFT040
     C                   MOVEL     DATA(33)      A_BIZIP                                      CFT040
     C                   MOVEL     DATA(34)      A_BILOCN                                     CFT040
     C                   MOVEL     DATA(35)      A_BICNTY                                     CFT040
     C                   MOVEL     DATA(36)      A_BIPOBN                                     CFT040
     C                   MOVEL     DATA(37)      A_BIPOBZ                                     CFT040
     C                   MOVEL     DATA(38)      A_BIPLOC                                     CFT040
     C                   MOVEL     DATA(39)      A_BIPCNT                                     CFT040
     C                   MOVEL     DATA(40)      A_BINDED                                     CFT040
     C                   MOVEL     DATA(41)      A_BIUDAT                                     CFT040
     C                   MOVEL     DATA(42)      A_BIFIL1                                     CFT040
     C                   WRITE     MEBICBD0                                                   CFT040
     C                   MOVE      '0'           *INU2                                        CFT040
      *                                                                                       CFT040
     C                   ENDSR                                                                CFT040
      *****************************************************************                       CFT040
      /EJECT                                                                                  CFT040
      *****************************************************************                       CFT040
      *                                                               *                       CFT040
      *  WRITES  -  Write IBAN Structure                              *                       CFT040
      *  Called by: SRMOVE                                            *                       CFT040
      *  Calls    : None                                              *                       CFT040
      *                                                               *                       CFT040
      *****************************************************************                       CFT040
      *                                                                                       CFT040
     C     WRITES        BEGSR                                                                CFT040
      *                                                                                       CFT040
     C                   MOVEL     DATA(1)       ISTAG                                        CFT040
     C                   MOVEL     DATA(2)       ISFLAG                                       CFT040
     C                   MOVEL     DATA(3)       ISCCOD                                       CFT040
     C                   MOVEL     DATA(4)       ISCPOS                                       CFT040
     C                   MOVEL     DATA(5)       ISCLEN                                       CFT040
     C                   MOVEL     DATA(6)       ISDPOS                                       CFT040
     C                   MOVEL     DATA(7)       ISDLEN                                       CFT040
     C                   MOVEL     DATA(8)       ISBIDP                                       CFT040
     C                   MOVEL     DATA(9)       ISBIDL                                       CFT040
     C                   MOVEL     DATA(10)      ISCIDP                                       CFT040
     C                   MOVEL     DATA(11)      ISCIDL                                       CFT040
     C                   MOVEL     DATA(12)      ISINDL                                       CFT040
     C                   MOVEL     DATA(13)      ISACNP                                       CFT040
     C                   MOVEL     DATA(14)      ISACNL                                       CFT040
     C                   MOVEL     DATA(15)      ISIBNL                                       CFT040
     C                   MOVEL     DATA(16)      ISFIL1                                       CFT040
     C                   MOVEL     DATA(17)      ISFIL2                                       CFT040
     C                   MOVEL     DATA(18)      ISFIL3                                       CFT040
     C                   MOVEL     DATA(19)      ISFIL4                                       CFT040
     C                   MOVEL     DATA(20)      ISFIL5                                       CFT040
     C                   WRITE     MEBICSD0                                                   CFT040
     C                   MOVE      '0'           *INU3                                        CFT040
      *                                                                                       CFT040
     C                   ENDSR                                                                CFT040
      *****************************************************************                       CFT040
      /EJECT                                                                                  CFT040
      *****************************************************************                       CFT040
      *                                                               *                       CFT040
      *  WRITEP  -  Write BIC Plus IBAN Record                        *                       CFT040
      *  Called by: SRMOVE                                            *                       CFT040
      *  Calls    : None                                              *                       CFT040
      *                                                               *                       CFT040
      *****************************************************************                       CFT040
      *                                                                                       CFT040
     C     WRITEP        BEGSR                                                                CFT040
      *                                                                                       CFT040
     C                   MOVEL     DATA(1)       A_BITAG                                      CFT040
     C                   MOVEL     DATA(2)       A_BIFLAG                                     CFT040
     C                   MOVEL     DATA(3)       A_BIKEY                                      CFT040
     C                   MOVEL     DATA(4)       A_BIINST                                     CFT040
     C                   MOVEL     DATA(5)       A_BICITY                                     CFT040
     C                   MOVEL     DATA(6)       A_BIBINF                                     CFT040
     C                   MOVEL     DATA(7)       A_BIBICC                                     CFT040
     C                   MOVEL     DATA(8)       A_BIBRCD                                     CFT040
     C                   MOVEL     DATA(9)       A_BIUBIC                                     CFT040
     C                   MOVEL     DATA(10)      A_BIUBRC                                     CFT040
     C                   MOVEL     DATA(11)      A_BIIBIC                                     CFT040
     C                   MOVEL     DATA(12)      A_BIIBRC                                     CFT040
     C                   MOVEL     DATA(13)      A_BIRBIC                                     CFT040
     C                   MOVEL     DATA(14)      A_BIRBRC                                     CFT040
     C                   MOVEL     DATA(15)      A_BIPBCD                                     CFT040
     C                   MOVEL     DATA(16)      A_BICTCD                                     CFT040
     C                   MOVEL     DATA(17)      A_BINATI                                     CFT040
     C                   MOVEL     DATA(18)      A_BIUNTI                                     CFT040
     C                   MOVEL     DATA(19)      A_BIICTY                                     CFT040
     C                   MOVEL     DATA(20)      A_BIINAT                                     CFT040
     C                   MOVEL     DATA(21)      A_BIUIND                                     CFT040
     C                   MOVEL     DATA(22)      A_BIOND1                                     CFT040
     C                   MOVEL     DATA(23)      A_BIOND2                                     CFT040
     C                   MOVEL     DATA(24)      A_BICHIP                                     CFT040
     C                   MOVEL     DATA(25)      A_BISTYP                                     CFT040
     C                   MOVEL     DATA(26)      A_BISERV                                     CFT040
     C                   MOVEL     DATA(27)      A_BIBRQA                                     CFT040
     C                   MOVEL     DATA(28)      A_BISPCD                                     CFT040
     C                   MOVEL     *BLANKS       TEMPA                                        CFT040
     C                   MOVEL     *BLANKS       TEMPB                                        CFT040
     C                   MOVEL     *BLANKS       TEMPC                                        CFT040
     C                   MOVEL     *BLANKS       TEMPD                                        CFT040
     C                   MOVEL     *BLANKS       TEMPY                                        CFT040
     C                   MOVEL     *BLANKS       TEMPZ                                        CFT040
     C                   MOVEL     DATA(29)      TEMPA                                        CFT040
     C                   MOVEL     DATA(30)      TEMPB                                        CFT040
     C                   MOVEL     DATA(31)      TEMPC                                        CFT040
     C                   MOVEL     DATA(32)      TEMPD                                        CFT040
     C**********         EVAL      TEMPY = (%TRIM(TEMPA) + ' ' +                     CFT040 BUG21300
     C**********                           %TRIM(TEMPB))                             CFT040 BUG21300
     C**********         EVAL      TEMPZ = (%TRIM(TEMPC) + ' ' +                     CFT040 BUG21300
     C**********                           %TRIM(TEMPD))                             CFT040 BUG21300
     C**********         EVAL      A_BIADDR = (%TRIM(TEMPY) + ' ' +                  CFT040 BUG21300
     C**********                              %TRIM(TEMPZ))                          CFT040 BUG21300
     C     TEMPA         CAT       TEMPB         TEMPY                                      BUG21300
     C     TEMPC         CAT       TEMPD         TEMPZ                                      BUG21300
     C     TEMPY         CAT       TEMPZ         A_BIADDR                                   BUG21300
     C                   MOVEL     DATA(33)      A_BIZIP                                      CFT040
     C                   MOVEL     DATA(34)      A_BILOCN                                     CFT040
     C                   MOVEL     DATA(35)      A_BICNTY                                     CFT040
     C                   MOVEL     DATA(36)      A_BIPOBN                                     CFT040
     C                   MOVEL     DATA(37)      A_BIPOBZ                                     CFT040
     C                   MOVEL     DATA(38)      A_BIPLOC                                     CFT040
     C                   MOVEL     DATA(39)      A_BIPCNT                                     CFT040
     C                   MOVEL     DATA(40)      A_BINDED                                     CFT040
     C                   MOVEL     DATA(41)      A_BIUDAT                                     CFT040
     C                   MOVEL     DATA(42)      A_BIFIL1                                     CFT040
      *                                                                                       CFT040
     C                   EVAL      BITAG = A_BITAG                                            CFT040
     C                   EVAL      BIFLAG = A_BIFLAG                                          CFT040
     C                   EVAL      BIBIC = A_BIUBIC                                           CFT040
     C                   EVAL      BIINST = A_BIINST                                          CFT040
     C                   EVAL      BIBNCH = A_BIBINF                                          CFT040
     C                   EVAL      BICITY = A_BICITY                                          CFT040
     C                   EVAL      BISTYP = A_BISTYP                                          CFT040
     C                   EVAL      BISERV = A_BISERV                                          CFT040
     C                   EVAL      BIXINF = A_BIBRQA                                          CFT040
     C                   EVAL      BIADDR = A_BIADDR                                          CFT040
     C                   EVAL      BIZIP = A_BIZIP                                            CFT040
     C                   EVAL      BILOCN = A_BILOCN                                          CFT040
     C                   EVAL      BICNTY = A_BICNTY                                          CFT040
     C                   EVAL      BIPOBN = A_BIPOBN                                          CFT040
     C                   EVAL      BIPOBZ = A_BIPOBZ                                          CFT040
     C                   EVAL      BIPOBL = A_BIPLOC                                          CFT040
     C                   EVAL      BIPOBC = A_BIPCNT                                          CFT040
     C                   EVAL      BISRCI = *BLANKS                                           CFT040
     C                   EVAL      BISPEC = *BLANKS                                           CFT040
     C                   MOVE      A_BIUDAT      BIUPDT                                       CFT040
     C                   EVAL      BIORIG = *BLANKS                                           CFT040
     C                   EVAL      BIKEY = A_BIKEY                                            CFT040
     C                   EVAL      BICHCK = *BLANKS                                           CFT040
     C                   EVAL      BICHIP = A_BICHIP                                          CFT040
     C                   EVAL      BINATI = A_BINATI                                          CFT040
     C                   EVAL      BIACTD = *BLANKS                                           CFT040
     C                   EVAL      BIDCTD = *BLANKS                                           CFT040
     C                   EVAL      BIUNDC = *BLANKS                                           CFT040
     C                   EVAL      BIUNDN = *BLANKS                                           CFT040
     C                   EVAL      BINKEY = *BLANKS                                           CFT040
     C                   EVAL      BICFLG = *BLANKS                                           CFT040
     C                   EVAL      BICINS = *BLANKS                                           CFT040
     C                   EVAL      BIUSER = *BLANKS                                           CFT040
     C                   EVAL      BICBI1 = A_BIOND1                                          CFT040
     C                   EVAL      BICBI2 = A_BIOND2                                          CFT040
     C                   EVAL      BICBI3 = *BLANKS                                           CFT040
     C                   EVAL      BICBI4 = *BLANKS                                           CFT040
     C                   EVAL      BICBD1 = *BLANKS                                           CFT040
     C                   EVAL      BICBD2 = *BLANKS                                           CFT040
     C                   EVAL      BIMFLG = *BLANKS                                           CFT040
     C                   EVAL      BIMMTH = *BLANKS                                           CFT040
     C                   EVAL      BIMRLT = *BLANKS                                           CFT040
     C                   EVAL      BIFILL = *BLANKS                                           CFT040
      *                                                                                       CFT040
     C                   WRITE     @BICPPD                                                    CFT040
     C                   MOVE      '0'           *INU2                                        CFT040
      *                                                                                       CFT040
     C                   ENDSR                                                                CFT040
      *                                                                                       CFT040
      /EJECT                                                                                  CFT040
      *****************************************************************
      *                                                               *
      *  WRITEB  -  Write BIC Record                                  *
      *  Called by: SRMOVE                                            *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     WRITEB        BEGSR
      *
     C                   MOVEL     DATA(1)       BITAG
     C                   MOVEL     DATA(2)       BIFLAG
     C*
     C                   MOVEL     *BLANKS       TEMP8             8
     C                   MOVEL     *BLANKS       TEMP3             3
     C                   MOVEL     DATA(3)       TEMP8
     C                   MOVEL     DATA(4)       TEMP3
     C                   MOVEL     TEMP8         BIBIC
     C                   MOVE      TEMP3         BIBIC
     C*
     C                   MOVEL     DATA(5)       BIINST
     C                   MOVEL     DATA(6)       BIBNCH
     C                   MOVEL     DATA(7)       BICITY
     C                   MOVEL     DATA(8)       BISTYP
     C                   MOVEL     DATA(9)       BISERV
     C                   MOVEL     DATA(10)      BIXINF
     C*
     C                   MOVEL     *BLANKS       TEMPA            35
     C                   MOVEL     *BLANKS       TEMPB            35
     C                   MOVEL     *BLANKS       TEMPC            35
     C                   MOVEL     *BLANKS       TEMPD            35
     C                   MOVEL     *BLANKS       TEMPY            70
     C                   MOVEL     *BLANKS       TEMPZ            70
     C                   MOVEL     DATA(11)      TEMPA
     C                   MOVEL     DATA(12)      TEMPB
     C                   MOVEL     DATA(13)      TEMPC
     C                   MOVEL     DATA(14)      TEMPD
     C     TEMPA         CAT       TEMPB         TEMPY
     C     TEMPC         CAT       TEMPD         TEMPZ
     C     TEMPY         CAT       TEMPZ         BIADDR
     C*
     C                   MOVEL     DATA(15)      BIZIP
     C                   MOVEL     DATA(16)      BILOCN
     C                   MOVEL     DATA(17)      BICNTY
     C                   MOVEL     DATA(18)      BIPOBN
     C                   MOVEL     DATA(19)      BIPOBZ
     C                   MOVEL     DATA(20)      BIPOBL
     C                   MOVEL     DATA(21)      BIPOBC
     C                   MOVEL     DATA(22)      BISRCI
     C                   MOVEL     DATA(23)      BISPEC
     C                   MOVEL     DATA(24)      BIUPDT
     C                   MOVEL     DATA(25)      BIORIG
     C                   MOVEL     DATA(26)      BIKEY
     C                   MOVEL     DATA(27)      BICHCK
     C                   MOVEL     DATA(28)      BICHIP
     C                   MOVEL     DATA(29)      BINATI
     C                   MOVEL     DATA(30)      BIACTD
     C                   MOVEL     DATA(31)      BIDCTD
     C                   MOVEL     DATA(32)      BIUNDC
     C                   MOVEL     DATA(33)      BIUNDN
     C                   MOVEL     DATA(34)      BINKEY
     C                   MOVEL     DATA(35)      BICFLG
     C                   MOVEL     DATA(36)      BICINS
     C                   MOVEL     DATA(37)      BIUSER
     C                   MOVEL     DATA(38)      BICBI1
     C                   MOVEL     DATA(39)      BICBI2
     C                   MOVEL     DATA(40)      BICBI3
     C                   MOVEL     DATA(41)      BICBI4
     C                   MOVEL     DATA(42)      BICBD1
     C                   MOVEL     DATA(43)      BICBD2
     C                   MOVEL     DATA(44)      BIMFLG
     C                   MOVEL     DATA(45)      BIMMTH
     C                   MOVEL     DATA(46)      BIMRLT
     C                   MOVEL     DATA(47)      BIFILL
     C                   WRITE     @BICPPD
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREND   -  End Program                                       *
      *  Called by: Main routine                                      *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     SREND         BEGSR
      *
     C                   MOVE      '1'           *INLR
     C                   RETURN
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR   -  File Exception/Error Handling Subroutine          *
      *  Called by: Various                                           *
      *  Calls    : DBERRCTL - DB Error Control                       *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   SETON                                        U7U8
     C                   EXSR      SREND
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Finastra International Limited 2007
