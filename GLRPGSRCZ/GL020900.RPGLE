     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Account Transfer Update DLCHISPD')            *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL020900 - Midas GL Account Transfer Update DLCHISPD         *
      *                                                               *
      *  Function:  This program updates the Midas DL Historic MM     *
      *             Loan Deals file, DLCHISPD with the new account    *
      *             detail from the Account Transfer Selected         *
      *             Accounts File, GLSLACPD.  It also will write an   *
      *             audit trail record for each update of DLCHISPD.   *
      *                                                               *
      *  Called By: GL003600                                          *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 MD046248           Date 27Oct17               *
      *                 BUG28033 *CREATE   Date 12Aug10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG28033 - Add missing files in ATU                          *
      *                                                               *
      *****************************************************************
      *  Function of Indicators                                       *
      *                                                               *
      *   90          Error in AOBANKR0                               *
      *                                                               *
      *****************************************************************
      *
     FDLCHISL2  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     RENAME(DLCHISD0:DLCHISF2)
     FDLCHISL3  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     RENAME(DLCHISD0:DLCHISF3)
     FDLCHISL4  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     RENAME(DLCHISD0:DLCHISF4)
     FDLCHISL5  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     RENAME(DLCHISD0:DLCHISF5)
     FDLCHISL6  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     RENAME(DLCHISD0:DLCHISF6)
     FDLCHISL7  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     RENAME(DLCHISD0:DLCHISF7)
     FDLCHISL8  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     RENAME(DLCHISD0:DLCHISF8)
     FDLCHISL9  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     RENAME(DLCHISD0:DLCHISF9)
     FDLCHISLA  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     RENAME(DLCHISD0:DLCHISFA)
     FDLCHISLB  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     RENAME(DLCHISD0:DLCHISFB)
     FDLCHISLC  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     RENAME(DLCHISD0:DLCHISFC)
     FDLCHISLD  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     RENAME(DLCHISD0:DLCHISFD)
     FGLAUTFPD  O    E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     FGLSLACL1  IF   E           K DISK    INFSR(*PSSR)

      /EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D WKZERO          C                   CONST('0000000000  ')

      ** Array containing Copyright statement

      /SPACE 3
     D LDA           E DS           256    EXTNAME(LDA)

     D NOSTD         E DS             8    EXTNAME(NOSTD)

      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE

     D SDBANK        E DS                  EXTNAME(SDBANKPD)

     D DSFDY         E DS                  EXTNAME(DSFDY)

     D DSFRAC          DS
     D  DSFCNU                 1      6
     D  DSFCCY                 7      9
     D  DSFACO                10     19
     D  DSFACS                20     21
     D  DSFBRC                22     24

     D DSTOAC          DS
     D  DSTCNU                 1      6
     D  DSTCCY                 7      9
     D  DSTACO                10     19
     D  DSTACS                20     21
     D  DSTBRC                22     24

     D DSKITE          DS            90
     D  KDLIN                  1     18
     D  KCCY                  19     21
     D  KBRCA                 22     24

     D DSKIT2          DS            90
     D  KDLIN2                 1     18
     D  KCCY2                 19     21
     D  KBRCA2                22     24

     D DSKIT3          DS            90
     D  KSFCNU                 1      6
     D  KSFCCY                 7      9
     D  KSFACO                10     19
     D  KSFACS                20     21
     D  KSFBRC                22     24
     D  KSRFNO                25     34

     D WNOST           DS
      ** External Data Area for Nostro Details
     D  WWCCY                  1      3
     D  WWNOSN                 4      5
     D  WWBRCH                 6      8

      ** Data Area giving Installation Control Details

     D PSDS           SDS

      ** Program Status Data Structure

     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263

     D @RUN            S              1A
     D WKCCYY          S              4S 0
     D WKDFMT          S              9A
     D WKYEAR          S              2S 0
     D CPY2@           S             80A
     D @RTCD           S              7A
     D @OPTN           S              7A
     D P@PRCD          S              4A
     D P@RFNO          S             10A
     D P@FRAC          S             24A
     D P@TOAC          S             24A
     D P@RTCD          S              1A
     D KDLIN3          S             18A
     D WNOST2          S              5A
     D WKDLNO          S              6A
     D WKDDAT          S              5A

      *****************************************************************
      /EJECT
      *****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    P@PRCD
     C                   PARM                    P@RFNO
     C     DSFRAC        PARM                    P@FRAC
     C     DSTOAC        PARM                    P@TOAC
     C                   PARM                    P@RTCD

     C                   EXSR      SRINIT

     C                   IF        P@PRCD = '*LR '
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF

     C                   EXSR      XSIV01
     C                   EXSR      XMDEAL

     C                   IF        DSTBRC <> DSFBRC  AND
     C                             KDLIN2 <> *BLANKS AND
     C                             KDLIN2 <> WKZERO
     C                   EXSR      XMDEA2
     C                   ENDIF

     C                   IF        WNOST <> *BLANKS
     C                   EXSR      XMDEA3
     C                   ENDIF

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  XMDEAL - Maintain DEALSDC records.                           *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls:     XSAUDT                                            *
      *                                                               *
      *****************************************************************

     C     XMDEAL        BEGSR

     C     KDEAL         SETLL     DLCHISF2
     C     KDEAL         READE     DLCHISF2

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISL2'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     001           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Delete and Write Records until End of File for Selected Account

     C                   DOW       NOT %EOF(DLCHISL2)
     C                   DELETE    DLCHISF2

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISL2'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     002           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      OSDA = WKDLIN
     C                   EVAL      POBR = DSTBRC
     C                   EVAL      CCY  = DSTCCY

     C                   WRITE     DLCHISF2

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISL2'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     003           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   CLEAR                   GLAUTFD0
     C                   EVAL      AULFIL = 'DLCHISL2'
     C                   EXSR      XSAUDT

     C     KDEAL         READE     DLCHISF2

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISL2'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     004           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDDO

     C     KDEAL         SETLL     DLCHISF3
     C     KDEAL         READE     DLCHISF3

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISL3'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     001           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Delete and Write Records until End of File for Selected Account

     C                   DOW       NOT %EOF(DLCHISL3)
     C                   DELETE    DLCHISF3

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISL3'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     002           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      OSDA = WKDLIN
     C                   EVAL      CCY  = DSTCCY
     C                   EVAL      ROBR = DSTBRC

     C                   WRITE     DLCHISF3

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISL3'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     003           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   CLEAR                   GLAUTFD0
     C                   EVAL      AULFIL = 'DLCHISL3'
     C                   EXSR      XSAUDT

     C     KDEAL         READE     DLCHISF3

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISL3'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     004           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDDO

     C     KDEAL         SETLL     DLCHISF4
     C     KDEAL         READE     DLCHISF4

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISL4'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     001           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Delete and Write Records until End of File for Selected Account

     C                   DOW       NOT %EOF(DLCHISL4)
     C                   DELETE    DLCHISF4

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISL4'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     002           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      OMDA = WKDLIN
     C                   EVAL      CCY  = DSTCCY
     C                   EVAL      POBR = DSTBRC

     C                   WRITE     DLCHISF4

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISL4'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     003           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   CLEAR                   GLAUTFD0
     C                   EVAL      AULFIL = 'DLCHISL4'
     C                   EXSR      XSAUDT

     C     KDEAL         READE     DLCHISF4

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISL4'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     004           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDDO

     C     KDEAL         SETLL     DLCHISF5
     C     KDEAL         READE     DLCHISF5

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISL5'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     001           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Delete and Write Records until End of File for Selected Account

     C                   DOW       NOT %EOF(DLCHISL5)
     C                   DELETE    DLCHISF5

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISL5'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     002           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      OMDA = WKDLIN
     C                   EVAL      CCY  = DSTCCY
     C                   EVAL      ROBR = DSTBRC

     C                   WRITE     DLCHISF5

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISL5'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     003           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   CLEAR                   GLAUTFD0
     C                   EVAL      AULFIL = 'DLCHISL5'
     C                   EXSR      XSAUDT

     C     KDEAL         READE     DLCHISF5

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISL5'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     004           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDDO

     C     KDEAL         SETLL     DLCHISF6
     C     KDEAL         READE     DLCHISF6

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISL6'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     001           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Delete and Write Records until End of File for Selected Account

     C                   DOW       NOT %EOF(DLCHISL6)
     C                   DELETE    DLCHISF6

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISL6'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     002           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      RONS = WKDLIN
     C                   EVAL      ROBR = DSTBRC
     C                   EVAL      CCY  = DSTCCY

     C                   WRITE     DLCHISF6

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISL6'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     003           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   CLEAR                   GLAUTFD0
     C                   EVAL      AULFIL = 'DLCHISL6'
     C                   EXSR      XSAUDT

     C     KDEAL         READE     DLCHISF6

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISL6'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     004           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDDO

     C     KDEAL         SETLL     DLCHISF7
     C     KDEAL         READE     DLCHISF7

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISL7'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     001           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Delete and Write Records until End of File for Selected Account

     C                   DOW       NOT %EOF(DLCHISL7)
     C                   DELETE    DLCHISF7

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISL7'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     002           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      PONS = WKDLIN
     C                   EVAL      CCY  = DSTCCY
     C                   EVAL      POBR = DSTBRC

     C                   WRITE     DLCHISF7

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISL7'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     003           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   CLEAR                   GLAUTFD0
     C                   EVAL      AULFIL = 'DLCHISL7'
     C                   EXSR      XSAUDT

     C     KDEAL         READE     DLCHISF7

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISL7'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     004           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  XMDEA2 - Maintain DEALSDC records.                           *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
      *
     C     XMDEA2        BEGSR

     C     KDEAL2        SETLL     DLCHISF2
     C     KDEAL2        READE     DLCHISF2

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISL2'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     001           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Delete and Write Records until End of File for Selected Account

     C                   DOW       NOT %EOF(DLCHISL2)
     C                   DELETE    DLCHISF2

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISL2'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     002           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      POBR = DSTBRC

     C                   WRITE     DLCHISF2

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISL2'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     003           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   CLEAR                   GLAUTFD0
     C                   EVAL      AULFIL = 'DLCHISL2'
     C                   EXSR      XSAUDT

     C     KDEAL2        READE     DLCHISF2

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISL2'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     004           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDDO

     C     KDEAL2        SETLL     DLCHISF3
     C     KDEAL2        READE     DLCHISF3

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISL3'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     001           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Delete and Write Records until End of File for Selected Account

     C                   DOW       NOT %EOF(DLCHISL3)
     C                   DELETE    DLCHISF3

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISL3'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     002           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      ROBR = DSTBRC

     C                   WRITE     DLCHISF3

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISL3'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     003           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   CLEAR                   GLAUTFD0
     C                   EVAL      AULFIL = 'DLCHISL3'
     C                   EXSR      XSAUDT

     C     KDEAL2        READE     DLCHISF3

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISL3'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     004           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDDO

     C     KDEAL2        SETLL     DLCHISF4
     C     KDEAL2        READE     DLCHISF4

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISL4'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     001           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Delete and Write Records until End of File for Selected Account

     C                   DOW       NOT %EOF(DLCHISL4)
     C                   DELETE    DLCHISF4

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISL4'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     002           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      POBR = DSTBRC

     C                   WRITE     DLCHISF4

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISL4'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     003           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   CLEAR                   GLAUTFD0
     C                   EVAL      AULFIL = 'DLCHISL4'
     C                   EXSR      XSAUDT

     C     KDEAL2        READE     DLCHISF4

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISL4'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     004           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDDO

     C     KDEAL2        SETLL     DLCHISF5
     C     KDEAL2        READE     DLCHISF5

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISL5'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     001           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Delete and Write Records until End of File for Selected Account

     C                   DOW       NOT %EOF(DLCHISL5)
     C                   DELETE    DLCHISF5

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISL5'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     002           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      ROBR = DSTBRC

     C                   WRITE     DLCHISF5

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISL5'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     003           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   CLEAR                   GLAUTFD0
     C                   EVAL      AULFIL = 'DLCHISL5'
     C                   EXSR      XSAUDT

     C     KDEAL2        READE     DLCHISF5

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISL5'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     004           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDDO

     C     KDEAL2        SETLL     DLCHISF6
     C     KDEAL2        READE     DLCHISF6

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISL6'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     001           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Delete and Write Records until End of File for Selected Account

     C                   DOW       NOT %EOF(DLCHISL6)
     C                   DELETE    DLCHISF6

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISL6'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     002           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      ROBR = DSTBRC

     C                   WRITE     DLCHISF6

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISL6'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     003           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   CLEAR                   GLAUTFD0
     C                   EVAL      AULFIL = 'DLCHISL6'
     C                   EXSR      XSAUDT

     C     KDEAL2        READE     DLCHISF6

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISL6'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     004           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDDO

     C     KDEAL2        SETLL     DLCHISF7
     C     KDEAL2        READE     DLCHISF7

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISL7'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     001           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Delete and Write Records until End of File for Selected Account

     C                   DOW       NOT %EOF(DLCHISL7)
     C                   DELETE    DLCHISF7

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISL7'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     002           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      POBR = DSTBRC

     C                   WRITE     DLCHISF7

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISL7'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     003           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   CLEAR                   GLAUTFD0
     C                   EVAL      AULFIL = 'DLCHISL7'
     C                   EXSR      XSAUDT

     C     KDEAL2        READE     DLCHISF7

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISL7'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     004           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  XMDEA3 - Maintain DEALSDC records (Nostro)                   *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
      *
     C     XMDEA3        BEGSR
      *
     C                   EVAL      KDLIN3 = WWNOSN
     C                   EVAL      WNOST2 = WNOST

     C     KDEAL3        SETLL     DLCHISF8
     C     KDEAL3        READE     DLCHISF8

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISL8'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     001           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Delete and Write Records until End of File for Selected Account

     C                   DOW       NOT %EOF(DLCHISL8)

     C                   EVAL      POBR = WWBRCH

     C                   UPDATE    DLCHISF8

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISL8'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     003           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   CLEAR                   GLAUTFD0
     C                   EVAL      AULFIL = 'DLCHISL8'
     C                   EXSR      XSAUDT

     C     KDEAL3        READE     DLCHISF8

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISL8'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     004           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDDO

     C     KDEAL3        SETLL     DLCHISF9
     C     KDEAL3        READE     DLCHISF9

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISL9'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     001           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Delete and Write Records until End of File for Selected Account

     C                   DOW       NOT %EOF(DLCHISL9)

     C                   EVAL      ROBR = WWBRCH

     C                   UPDATE    DLCHISF9

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISL9'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     003           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   CLEAR                   GLAUTFD0
     C                   EVAL      AULFIL = 'DLCHISL9'
     C                   EXSR      XSAUDT

     C     KDEAL3        READE     DLCHISF9

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISL9'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     004           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDDO

     C     KDEAL3        SETLL     DLCHISFA
     C     KDEAL3        READE     DLCHISFA

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISLA'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     001           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Delete and Write Records until End of File for Selected Account

     C                   DOW       NOT %EOF(DLCHISLA)

     C                   EVAL      POBR = WWBRCH

     C                   UPDATE    DLCHISFA

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISLA'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     003           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   CLEAR                   GLAUTFD0
     C                   EVAL      AULFIL = 'DLCHISLA'
     C                   EXSR      XSAUDT

     C     KDEAL3        READE     DLCHISFA

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISLA'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     004           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDDO

     C     KDEAL3        SETLL     DLCHISFB
     C     KDEAL3        READE     DLCHISFB

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISLB'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     001           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Delete and Write Records until End of File for Selected Account

     C                   DOW       NOT %EOF(DLCHISLB)

     C                   EVAL      ROBR = WWBRCH

     C                   UPDATE    DLCHISFB

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISLB'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     003           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   CLEAR                   GLAUTFD0
     C                   EVAL      AULFIL = 'DLCHISLB'
     C                   EXSR      XSAUDT

     C     KDEAL3        READE     DLCHISFB

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISLB'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     004           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDDO

     C     KDEAL3        SETLL     DLCHISFC
     C     KDEAL3        READE     DLCHISFC

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISLC'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     001           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Delete and Write Records until End of File for Selected Account

     C                   DOW       NOT %EOF(DLCHISLC)

     C                   EVAL      ROBR = WWBRCH

     C                   UPDATE    DLCHISFC

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISLC'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     003           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   CLEAR                   GLAUTFD0
     C                   EVAL      AULFIL = 'DLCHISLC'
     C                   EXSR      XSAUDT

     C     KDEAL3        READE     DLCHISFC

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISLC'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     004           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDDO

     C     KDEAL3        SETLL     DLCHISFD
     C     KDEAL3        READE     DLCHISFD

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISLD'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     001           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Delete and Write Records until End of File for Selected Account

     C                   DOW       NOT %EOF(DLCHISLD)

     C                   EVAL      POBR = WWBRCH

     C                   UPDATE    DLCHISFD

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISLD'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     003           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   CLEAR                   GLAUTFD0
     C                   EVAL      AULFIL = 'DLCHISLD'
     C                   EXSR      XSAUDT

     C     KDEAL3        READE     DLCHISFD

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLCHISLD'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     004           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDDO


     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  XSAUDT - Set Audit records                                   *
      *                                                               *
      *  Called By: XMDEAL, XMDEA2                                    *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************

     C     XSAUDT        BEGSR

     C                   EVAL      AURFNO = P@RFNO
     C                   EVAL      AUFILE = 'DLCHISPD'
     C                   EVAL      AUFBRC = DSFBRC
     C                   EVAL      AUFCNU = DSFCNU
     C                   EVAL      AUFACO = DSFACO
     C                   EVAL      AUFACS = DSFACS
     C                   EVAL      AUTBRC = DSTBRC
     C                   EVAL      AUTCNU = DSTCNU
     C                   EVAL      AUTACO = DSTACO
     C                   EVAL      AUTACS = DSTACS
     C                   MOVEL     DLNO          WKDLNO
     C                   MOVEL     DDAT          WKDDAT
     C     WKDLNO        CAT       WKDDAT:1      AUTEXT
     C                   EVAL      AUCRTD = WKDFMT
     C                   WRITE     GLAUTFD0

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'GLAUTFPD'
     C                   EVAL      DBKEY = AURFNO
     C                   Z-ADD     005           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  XSIV01 - Set up initial values                               *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
      *
     C     XSIV01        BEGSR
      *
     C                   MOVEL     DSFCCY        KCCY
     C                   MOVEL     DSFBRC        KBRCA
     C     DSFCNU        CAT       DSFACO:0      KDLIN
     C                   CAT       DSFACS:0      KDLIN
     C                   MOVEL     DSFCNU        KSFCNU
     C                   MOVEL     DSFCCY        KSFCCY
     C                   MOVEL     DSFACO        KSFACO
     C                   MOVEL     DSFACS        KSFACS
     C                   MOVEL     DSFBRC        KSFBRC
     C                   MOVEL     P@RFNO        KSRFNO
      *
     C     KSLAC         CHAIN     GLSLACL1                           3031
      *
     C     *IN30         IFEQ      *ON
     C     *IN31         OREQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     '026'         DBASE
     C                   MOVEL     'GLSLACL1'    DBFILE
     C                   MOVEL     DSKIT3        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVEL     DSFCCY        KCCY2
     C                   MOVEL     DSFBRC        KBRCA2
     C                   MOVEL     SLACNO        KDLIN2
      *
     C     DSTCNU        CAT       DSTACO:0      WKDLIN           18
     C                   CAT       DSTACS:0      WKDLIN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT - Initialise and define fields                        *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************

     C     SRINIT        BEGSR

      ** Set up copyright parameter

     C                   MOVEA     CPY@          CPY2@            80

     C     *DTAARA       DEFINE                  LDA
     C     *DTAARA       DEFINE                  NOSTD

      ** Check nostro account changes

     C                   EVAL      WNOST = *BLANKS
     C     *LOCK         IN        NOSTD
     C                   MOVE      DANOST        WNOST
     C                   OUT       NOSTD

      ** Retrieve Run Date.

     C                   CALL      'AOBANKR0'                           9090
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY

      ** If return with an error (LR seton in called program) then
      ** process for database error.

     C                   IF        *IN90 = '1' OR
     C                             @RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'AOBANKR0'
     C                   EVAL      DBKEY = '*FIRST'
     C                   Z-ADD     006           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      WKDFMT = BJMRDT
     C                   MOVE      BJMRDT        WKYEAR

     C                   IF        WKYEAR < 72
     C                   EVAL      WKCCYY = WKYEAR + 2000
     C                   ELSE
     C                   EVAL      WKCCYY = WKYEAR + 1900
     C                   ENDIF

     C                   MOVE      WKCCYY        WKDFMT
     C                   EVAL      KDLIN = *BLANKS
     C                   EVAL      WKDLIN = *BLANKS

     C     KDEAL         KLIST
     C                   KFLD                    KDLIN
     C                   KFLD                    KCCY
     C                   KFLD                    KBRCA

     C     KDEAL2        KLIST
     C                   KFLD                    KDLIN2
     C                   KFLD                    KCCY2
     C                   KFLD                    KBRCA2

     C     KDEAL3        KLIST
     C                   KFLD                    KDLIN3
     C                   KFLD                    WWCCY

     C     KSLAC         KLIST
     C                   KFLD                    KSFBRC
     C                   KFLD                    KSFCNU
     C                   KFLD                    KSFCCY
     C                   KFLD                    KSFACO
     C                   KFLD                    KSFACS
     C                   KFLD                    KSRFNO

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C                   EVAL      P@RTCD = 'F'
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   SETON                                        U7U8LR
     C                   RETURN

     C                   ENDSR

      ********************************************************************
**  CPY@
(c) Finastra International Limited 2010
