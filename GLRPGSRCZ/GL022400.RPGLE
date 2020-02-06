     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Account Transfer Update LEFCENPD')            *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL022400 - Midas GL Account Transfer Update LEFCENPD         *
      *                                                               *
      *  Function:  This program updates the Midas LE Facility        *
      *             Activity File with the new account detail from    *
      *             Account Transfer Selected Accounts File, GLSLACPD.*
      *             It also will write an audit trail record for each *
      *             update of LEFCENL1.                               *
      *                                                               *
      *  Called By: GL003600                                          *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      *                 BUG28073 *CREATE   Date 26Aug10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  BUG28073 - Add missing files in ATU                          *
      *                                                               *
      *****************************************************************
      *  Function of Indicators                                       *
      *                                                               *
      *   90          Error in AOBANKR0                               *
      *                                                               *
      *****************************************************************
 
     FLEFCENL1  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     RENAME(LEFCEND0:LEFCENF1)
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
     D WKLNRF          S              6A
     D WKADAT          S              5A
 
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
     C                   EXSR      XMFCEN
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  XMFCEN - Maintain LE Facility activity file                  *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls:     XSAUDT                                            *
      *                                                               *
      *****************************************************************
 
     C     XMFCEN        BEGSR
 
     C     KFCEN         SETLL     LEFCENF1
     C     KFCEN         READE     LEFCENF1
 
     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'LEFCENL1'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     001           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Delete and Write Records until End of File for Selected Account
 
     C                   DOW       NOT %EOF(LEFCENL1)
     C                   DELETE    LEFCENF1
 
     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'LEFCENL1'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     002           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      RABR = DSTBRC
     C                   EVAL      RACU = DSTCNU
     C                   EVAL      RACY = DSTCCY
     C                   MOVEL     DSTACO        RACD
     C                   MOVEL     DSTACS        RASQ
 
     C                   WRITE     LEFCENF1
 
     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'LEFCENL1'
     C                   EVAL      DBKEY = DSKITE
     C                   Z-ADD     003           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   CLEAR                   GLAUTFD0
     C                   EVAL      AULFIL = 'LEFCENL1'
     C                   EXSR      XSAUDT
 
     C     KFCEN         READE     LEFCENF1
 
     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'LEFCENL1'
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
      *  Called By: XMFCEN                                            *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
 
     C     XSAUDT        BEGSR
 
     C                   EVAL      AURFNO = P@RFNO
     C                   EVAL      AUFILE = 'LEFCENPD'
     C                   EVAL      AUFBRC = DSFBRC
     C                   EVAL      AUFCNU = DSFCNU
     C                   EVAL      AUFACO = DSFACO
     C                   EVAL      AUFACS = DSFACS
     C                   EVAL      AUTBRC = DSTBRC
     C                   EVAL      AUTCNU = DSTCNU
     C                   EVAL      AUTACO = DSTACO
     C                   EVAL      AUTACS = DSTACS
     C                   MOVE      *BLANKS       WKLNRF
     C                   MOVE      *BLANKS       WKADAT
     C                   MOVE      LNRF          WKLNRF
     C                   MOVE      ADAT          WKADAT
     C     WKLNRF        CAT(P)    WKADAT:1      AUTEXT
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
 
     C     KFCEN         KLIST
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
(c) Finastra International Limited 2010
