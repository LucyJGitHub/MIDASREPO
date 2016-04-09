     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Account Transfer Update REGAMXPD')            *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL022900 - Midas GL Account Transfer Update REGAMXPD         *
      *                                                               *
      *  Function:  This program updates the Midas RE Group Account   *
      *             Member Extension File with the new account        *
      *             detail from Account Transfer Selected Accounts    *
      *             File, GLSLACPD. It also will write an audit trail *
      *             record for each update of REGAMXL2, REGAMXL3,     *
      *             REGAMXL4 and REGAMXL5.                            *
      *                                                               *
      *  Called By: GL003600                                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      *  Last Amend No. BUG28073 *CREATE   Date 12Aug10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG28073 - Add missing files in ATU                          *
      *                                                               *
      *****************************************************************
      *  Function of Indicators                                       *
      *                                                               *
      *   90          Error in AOBANKR0                               *
      *                                                               *
      *****************************************************************
 
     FREGAMXL2  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     RENAME(REGAMXD0:REGAMXF2)
     FREGAMXL3  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     RENAME(REGAMXD0:REGAMXF3)
     FREGAMXL4  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     RENAME(REGAMXD0:REGAMXF4)
     FREGAMXL5  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     RENAME(REGAMXD0:REGAMXF5)
     FGLAUTFPD  O    E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      /EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
 
      ** Array containing Copyright statement
 
      /SPACE 3
     D LDA           E DS           256    EXTNAME(LDA)
 
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
     D  KBRCA                  1      3
     D  KCNUM                  4      9
     D  KCCY                  10     12
     D  KACOD                 13     22  0
     D  KACSQ                 23     24  0
 
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
     D WKMEID          S              9A
 
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
     C                   EXSR      XMGAMX
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  XMGAMX - RE Group Account Member Extension Details           *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls:     XSAUDT                                            *
      *                                                               *
      *****************************************************************
 
     C     XMGAMX        BEGSR
 
     C     KGAMX         SETLL     REGAMXF2
     C     KGAMX         READE     REGAMXF2
 
     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'REGAMXL2'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     001           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Delete and Write Records until End of File for Selected Account
 
     C                   DOW       NOT %EOF(REGAMXL2)
     C                   DELETE    REGAMXF2
 
     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'REGAMXL2'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     002           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      GMCBRC = DSTBRC
     C                   EVAL      GMCCUS = DSTCNU
     C                   EVAL      GMCCCY = DSTCCY
     C                   MOVEL     DSTACO        GMCACD
     C                   MOVEL     DSTACS        GMCASN
 
     C                   WRITE     REGAMXF2
 
     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'REGAMXL2'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     003           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   CLEAR                   GLAUTFD0
     C                   EVAL      AULFIL = 'REGAMXL2'
     C                   EXSR      XSAUDT
 
     C     KGAMX         READE     REGAMXF2
 
     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'REGAMXL2'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     004           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDDO
 
     C     KGAMX         SETLL     REGAMXF3
     C     KGAMX         READE     REGAMXF3
 
     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'REGAMXL3'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     005           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Delete and Write Records until End of File for Selected Account
 
     C                   DOW       NOT %EOF(REGAMXL3)
     C                   DELETE    REGAMXF3
 
     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'REGAMXL3'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     006           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      GMTBRC = DSTBRC
     C                   EVAL      GMTCUS = DSTCNU
     C                   EVAL      GMTCCY = DSTCCY
     C                   MOVEL     DSTACO        GMTACD
     C                   MOVEL     DSTACS        GMTASN
 
     C                   WRITE     REGAMXF3
 
     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'REGAMXL3'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     007           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   CLEAR                   GLAUTFD0
     C                   EVAL      AULFIL = 'REGAMXL3'
     C                   EXSR      XSAUDT
 
     C     KGAMX         READE     REGAMXF3
 
     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'REGAMXL3'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     008           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDDO
 
     C     KGAMX         SETLL     REGAMXF4
     C     KGAMX         READE     REGAMXF4
 
     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'REGAMXL4'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     009           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Delete and Write Records until End of File for Selected Account
 
     C                   DOW       NOT %EOF(REGAMXL4)
     C                   DELETE    REGAMXF4
 
     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'REGAMXL4'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     010           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      GMIBRC = DSTBRC
     C                   EVAL      GMICUS = DSTCNU
     C                   EVAL      GMICCY = DSTCCY
     C                   MOVEL     DSTACO        GMIACD
     C                   MOVEL     DSTACS        GMIASN
 
     C                   WRITE     REGAMXF4
 
     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'REGAMXL4'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     011           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   CLEAR                   GLAUTFD0
     C                   EVAL      AULFIL = 'REGAMXL4'
     C                   EXSR      XSAUDT
 
     C     KGAMX         READE     REGAMXF4
 
     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'REGAMXL4'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     012           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDDO
 
     C     KGAMX         SETLL     REGAMXF5
     C     KGAMX         READE     REGAMXF5
 
     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'REGAMXL5'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     013           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Delete and Write Records until End of File for Selected Account
 
     C                   DOW       NOT %EOF(REGAMXL5)
     C                   DELETE    REGAMXF5
 
     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'REGAMXL5'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     014           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      GMEBRC = DSTBRC
     C                   EVAL      GMECUS = DSTCNU
     C                   EVAL      GMECCY = DSTCCY
     C                   MOVEL     DSTACO        GMEACD
     C                   MOVEL     DSTACS        GMEASN
 
     C                   WRITE     REGAMXF5
 
     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'REGAMXL5'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     015           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   CLEAR                   GLAUTFD0
     C                   EVAL      AULFIL = 'REGAMXL5'
     C                   EXSR      XSAUDT
 
     C     KGAMX         READE     REGAMXF5
 
     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'REGAMXL5'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     016           DBASE
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
      *  Called By: XMGAMX                                            *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
 
     C     XSAUDT        BEGSR
 
     C                   EVAL      AURFNO = P@RFNO
     C                   EVAL      AUFILE = 'REGAMXPD'
     C                   EVAL      AUFBRC = DSFBRC
     C                   EVAL      AUFCNU = DSFCNU
     C                   EVAL      AUFACO = DSFACO
     C                   EVAL      AUFACS = DSFACS
     C                   EVAL      AUTBRC = DSTBRC
     C                   EVAL      AUTCNU = DSTCNU
     C                   EVAL      AUTACO = DSTACO
     C                   EVAL      AUTACS = DSTACS
     C                   MOVEL     GMEID         WKMEID
     C     GMCBRC        CAT(P)    WKMEID:1      AUTEXT
     C                   CAT(P)    GMCBRC:1      AUTEXT
     C                   CAT(P)    GMCCUS:1      AUTEXT
     C                   CAT(P)    GMCCCY:1      AUTEXT
     C                   EVAL      AUCRTD = WKDFMT
     C                   WRITE     GLAUTFD0
 
     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'GLAUTFPD'
     C                   EVAL      DBKEY = AURFNO
     C                   Z-ADD     017           DBASE
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
 
     C     XSIV01        BEGSR
 
     C                   EVAL      KBRCA = DSFBRC
     C                   EVAL      KCNUM = DSFCNU
     C                   EVAL      KCCY  = DSFCCY
     C                   MOVEL     DSFACO        KACOD
     C                   MOVEL     DSFACS        KACSQ
 
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
 
     C                   MOVEA     CPY@          CPY2@
 
     C     *DTAARA       DEFINE                  LDA
 
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
     C                   Z-ADD     018           DBASE
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
 
     C     KGAMX         KLIST
     C                   KFLD                    KBRCA
     C                   KFLD                    KCNUM
     C                   KFLD                    KCCY
     C                   KFLD                    KACOD
     C                   KFLD                    KACSQ
 
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
(c) Misys International Banking Systems Ltd. 2010
