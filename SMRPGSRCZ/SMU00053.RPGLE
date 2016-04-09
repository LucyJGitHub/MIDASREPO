     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2007')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Setup flds (MABK,MACU,CUUN.. on TRANSD')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00053 - Installation of FF/PM Interface R10               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. BG26993            Date 26Jan10               *
      *  Prev Amend No. S71062             Date 05Mar96               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  BG26993 - Delivery of upgrade programs to core.              *
      *          - Renamed program CPM00302.                          *
      *  S71062  - FF/PM Interface R10                                *
      *                                                               *
      *****************************************************************
     FTRANS2    UF   E           K DISK
     FTRSET     IF   E           K DISK
     FCLOSTTM   IF   E           K DISK
      /EJECT
      *****************************************************************
      **
      **  Local Data Area for database errors
     D LDA             DS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for modules
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** External DS for modules
     D SDPLCS        E DS                  EXTNAME(SDPLCSPD)
      ** Portfolio Customer Details Accessed Via Access Program
     D DSFDY         E DS                  EXTNAME(DSFDY)
      /EJECT
      *****************************************************************
      *
      * RECI FROM TRANSD & TRSETD RENAMED IN RECIT & RECID TO AVOID UPDATE
      * OF RECI FROM TRANSD TO RECI FROM TABLETJ
      *
     ITRANSDF
     I              RECI                        RECIT
     ITRSETDF
     I              RECI                        RECID
     ICLOSTTF
     I              RECI                        RECIX
     I              CLON                        CLONX
     I              TNBR                        TNBRX
     I              NCCL                        NCCLX
     I              TRSD                        TRSDX
     I              TRTY                        TRTYX
     I              FCLI                        FCLIX
      ** First DS for access programs, short data structure
      /EJECT
      ********************************************************************
      *
      * MAIN PROCESSING
      *
     C                   EXSR      INIT
      *
     C     *LOVAL        SETLL     TRANS2
     C                   READ      TRANS2                                 LR
      *
     C     *INLR         DOWEQ     *OFF
      *
     C     BGPFMG        IFEQ      'Y'
     C     PTFR          IFEQ      *BLANKS
     C                   MOVEL     CUSC          WWCUSC           10
      *
     C                   CALL      'AOPLCSR0'
     C                   PARM      *BLANKS       WWRTCD
     C                   PARM      '*KEY   '     WWOPTN
     C                   PARM      WWCUSC        WWKY10           10
     C     SDPLCS        PARM      SDPLCS        DSFDY
      *
      ** RECORD IS FOUND (CUSTOMER IS A LIVE PORTFOLIO CUSTOMER)
     C     WWRTCD        IFEQ      *BLANKS
     C     QBRECI        ANDEQ     'D'
     C                   MOVE      '9997'        PTFR
     C                   END
     C                   END
      *
     C     PTFR          IFNE      *BLANKS
     C     RECIT         ANDEQ     'D'
     C     NOCO          ANDEQ     *ZEROS
     C     MHEX          ANDEQ     *BLANKS
      *
     C     TNBR          CHAIN     CLOSTTM                            61
      *
     C     *IN61         IFEQ      '1'
     C                   MOVE      'Y'           MHEX
     C                   END
     C                   END
      *
     C                   END
      *
      ** SETUP REVERSAL INDICATOR
     C     RECIT         IFEQ      'D'
      **
      ** SETUP ACCOUNTING INDICATOR
     C     TRSD          IFLT      BJRDNB
     C                   MOVE      'Y'           ACNI
     C                   ELSE
     C                   MOVE      'N'           ACNI
     C                   ENDIF
      *
     C                   ELSE
     C                   MOVE      'N'           ACNI
     C                   ENDIF
      **
     C     TNBR          CHAIN     TRSET                              70
      **
     C                   Z-ADD     *ZEROS        WWAMT1           13 0
     C                   Z-ADD     *ZEROS        WWAMT2           13 0
      **
     C     *IN70         IFEQ      '0'
      **
     C     CMAR          IFNE      *ZEROS
     C     CMAR          MULT      NOCO          WWAMT1
     C     WWAMT1        DIV(H)    NUCO          WWAMT1
     C                   Z-ADD     WWAMT1        MACU
     C                   ELSE
     C                   Z-ADD     *ZEROS        MACU
     C                   END
      **
     C     BMAR          IFNE      *ZEROS
     C     BMAR          MULT      NOBO          WWAMT2
     C     WWAMT2        DIV(H)    NUCO          WWAMT2
     C                   Z-ADD     WWAMT2        MABK
     C                   ELSE
     C                   Z-ADD     *ZEROS        MABK
     C                   END
      **
     C                   ELSE
     C                   Z-ADD     *ZEROS        MABK
     C                   Z-ADD     *ZEROS        MACU
     C                   END
      **
     C                   UPDATE    TRANSDF
      *
     C                   READ      TRANS2                                 LR
     C                   ENDDO
      *
     C                   RETURN
      *
      /EJECT
      ********************************************************************
      *
     C     INIT          BEGSR
      *
      **  Prepare LDA
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVEL     *BLANK        DBFILE
     C                   MOVEL     *BLANK        DBKEY
     C                   MOVEL     'FFTRANSD'    DBPGM
     C                   Z-ADD     *ZEROS        DBASE
     C                   OUT       LDA
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       WWRTCD            7
     C                   PARM      '*FIRST '     WWOPTN            7
     C     SDBANK        PARM      SDBANK        DSFDY
     C     WWRTCD        IFNE      *BLANKS
     C     *LOCK         IN        LDA                                          ***************
     C                   Z-ADD     1             DBASE                          * DB ERROR 01 *
     C                   MOVE      'SDBANKPD'    DBFILE                         ***************
     C                   MOVE      *BLANKS       DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       WWRTCD
     C                   PARM      '*FIRST '     WWOPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
     C     WWRTCD        IFNE      *BLANKS
     C     *LOCK         IN        LDA                                          ***************
     C                   Z-ADD     2             DBASE                          * DB ERROR 02 *
     C                   MOVE      'SDMMODPD'    DBFILE                         ***************
     C                   MOVE      *BLANKS       DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *
     C                   ENDSR
      *
      /EJECT
     C*****************************************************************
      **                                                   ***************
     C     *PSSR         BEGSR                                                  * *PSSR BEGSR *
      **                                                   ***************
     C                   DUMP
      **
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
      **
     C                   RETURN
      **                                                   ***************
     C                   ENDSR                                                  * *PSSR ENDSR *
      **                                                   ***************
     C*****************************************************************
