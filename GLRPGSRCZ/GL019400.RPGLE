     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Account Transfer Update SDNOSRQD')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL019400 - Midas Account Transfer Update SDNOSRQD            *
      *                                                               *
      *  Function:  This program updates the Midas SD Nostro Extension*
      *             files, SDNOSRQD with the new account details from *
      *             Account Transfer Selected Accounts File, GLSLACPD.*
      *                                                               *
      *             It will also write an audit trail record for each *
      *             update of SDNOSRQD                                *
      *                                                               *
      *  Called By: GL003600                                          *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. BUG27769           Date 09Jun10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG27222 *CREATE   Date 15Mar10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG27769 - Incorrect error code                              *
      *  BUG27222 - ATU Additional updates programs                   *
      *                                                               *
      *****************************************************************
      *  Function of Indicators                                       *
      *                                                               *
      *  01 - 19      Input Control.                                  *
      *  20 - 29      I/O Conditioning (ie. CHAIN, LOKUP etc...)      *
      *   20          Record Not Found                                *
      *   21          File Error Occurred                             *
      *   22          Start/End Of File Reached                       *
      *   25          Lookup/Scan.                                    *
      *  30 - 39      Program Work Indicators                         *
      *  40 - 49      Output Control.                                 *
      *  50 - 89      Output Conditioning (ie. Cursor Positioning)    *
      *  90 - 99      Error Control.                                  *
      *****************************************************************
      *
     FSDNOSRQL0 UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     FGLAUTFPD  O    E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      /EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Array containing Copyright statement
      *
      /SPACE 3
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
     D DSFRAC          DS
     D  DSFCNU                 1      6
     D  DSFCCY                 7      9
     D  DSFACO                10     19
     D  DSFACS                20     21
     D  DSFBRC                22     24
      *
     D DSTOAC          DS
     D  DSTCNU                 1      6
     D  DSTCCY                 7      9
     D  DSTACO                10     19
     D  DSTACS                20     21
     D  DSTBRC                22     24
      *
     D DSKITE          DS            90
     D  KCNUM                  1     20
     D  KCCY                  21     23
     D  KACOD                 24     33
     D  KACSQ                 34     35
     D  KBRCA                 36     38
      *
      ** Data Area giving Installation Control Details
      *
     D PSDS           SDS
      *
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *****************************************************************
      /EJECT
      *****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    P@PRCD            4
     C                   PARM                    P@RFNO           10
     C     DSFRAC        PARM                    P@FRAC           24
     C     DSTOAC        PARM                    P@TOAC           24
     C                   PARM                    P@RTCD            1
      *
     C                   EXSR      SRINIT
      *
     C     P@PRCD        IFEQ      '*LR '
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDIF
      *
     C                   EXSR      XVACCN
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  XVACCN - Validate Midas SD Nostro Extension File             *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls:     XSIV01, XMACCN                                    *
      *                                                               *
      *****************************************************************
      *
     C     XVACCN        BEGSR
      *
      ** Check if 'To' details already exist on SDNOSRQD
      *
     C                   MOVEL     DSTCNU        KCNUM
     C                   MOVEL     DSTCCY        KCCY
     C                   MOVEL     DSTACO        KACOD
     C                   MOVEL     DSTACS        KACSQ
     C                   MOVEL     DSTBRC        KBRCA
     C     KACCN         SETLL     SDNOSRD0                             2122
      *
     C     *IN21         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     'SDNOSRQL0'   DBFILE
     C                   MOVEL     DSKITE        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Process each Primary file record. The corresponding posting
      ** records are retrieved and updated.
      *
     C     *IN22         IFEQ      *OFF
     C                   EXSR      XSIV01
     C                   EXSR      XMACCN
      *
     C                   ELSE
     C                   MOVE      'F'           P@RTCD
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  XMACCN - Maintain Midas SD Nostro Extension File             *
      *                                                               *
      *  Called By: XVACCN                                            *
      *                                                               *
      *  Calls:     XSAUDT                                            *
      *                                                               *
      *****************************************************************
      *
     C     XMACCN        BEGSR
      *
     C     KACCN         SETLL     SDNOSRQL0
     C     KACCN         READE     SDNOSRQL0                            2122
      *
     C     *IN21         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     '002'         DBASE
     C                   MOVEL     'SDNOSRQL0'   DBFILE
     C                   MOVEL     DSKITE        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Delete and Write Records until End of File for Selected Account
      *
     C     *IN22         DOWEQ     *OFF
     C                   DELETE    SDNOSRD0                             21
      *
     C     *IN21         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     '003'         DBASE
     C                   MOVEL     'SDNOSRQL0'   DBFILE
     C                   MOVEL     DSKITE        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVEL     DSTCNU        DDCUSN
     C                   MOVEL     DSTCCY        DDCCY
     C                   MOVEL     DSTACO        DDACOD
     C                   MOVEL     DSTACS        DDACSQ
     C                   MOVEL     DSTBRC        DDBRCA
     C                   WRITE     SDNOSRD0                             21
      *
     C     *IN21         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     '004'         DBASE
     C                   MOVEL     'SDNOSRQL0'   DBFILE
     C                   MOVEL     DSKITE        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EXSR      XSAUDT
      *
     C     KACCN         READE     SDNOSRQL0                            2122
      *
     C     *IN21         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     '005'         DBASE
     C                   MOVEL     'SDNOSRQL0'   DBFILE
     C                   MOVEL     DSKITE        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  XSAUDT - Set Audit records                                   *
      *                                                               *
      *  Called By: XMACCN                                            *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
      *
     C     XSAUDT        BEGSR
      *
     C                   MOVEL     P@RFNO        AURFNO
     C                   MOVEL     'SDNOSRQD'    AUFILE
     C                   MOVEL     'SDNOSRQL0'   AULFIL
     C                   MOVEL     DSFBRC        AUFBRC
     C                   MOVEL     DSFCNU        AUFCNU
     C                   MOVEL     DSFACO        AUFACO
     C                   MOVEL     DSFACS        AUFACS
     C                   MOVEL     DSTBRC        AUTBRC
     C                   MOVEL     DSTCNU        AUTCNU
     C                   MOVEL     DSTACO        AUTACO
     C                   MOVEL     DSTACS        AUTACS
     C     COFRID        CAT(P)    DDNONB:1      AUTEXT           50
     C                   MOVEL     WKDFMT        AUCRTD
     C                   WRITE     GLAUTFD0                             21
      *
     C     *IN21         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     '006'         DBASE
     C                   MOVEL     'GLAUTFPD'    DBFILE
     C                   MOVEL     AURFNO        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  XSIV01 - Set up initial values                               *
      *                                                               *
      *  Called By: XVACCN                                            *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
      *
     C     XSIV01        BEGSR
      *
     C                   MOVEL     DSFBRC        KBRCA
     C                   MOVEL     DSFCNU        KCNUM
     C                   MOVEL     DSFCCY        KCCY
     C                   MOVEL     DSFACO        KACOD
     C                   MOVEL     DSFACS        KACSQ
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
      *
     C     SRINIT        BEGSR
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
     C     *DTAARA       DEFINE                  LDA
      *
      ** Retrieve Run Date.
      *
     C                   CALL      'AOBANKR0'                           9090
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** If return with an error (LR seton in called program) then
      ** process for database error.
      *
     C     *IN90         IFEQ      '1'
     C*****@RTCD         OREQ      '*ERROR*'                                                BUG27769
     C     @RTCD         ORNE      *BLANKS                                                  BUG27769
     C     *LOCK         IN        LDA
     C                   MOVEL     'AOBANKR0'    DBFILE
     C                   MOVEL     '*FIRST'      DBKEY
     C                   Z-ADD     007           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVEL     BJMRDT        WKDFMT            9
     C                   MOVE      BJMRDT        WKYEAR            2 0
      *
     C     WKYEAR        IFLT      72
     C     WKYEAR        ADD       2000          WKCCYY            4 0
     C                   ELSE
     C     WKYEAR        ADD       1900          WKCCYY
     C                   ENDIF
      *
     C                   MOVE      WKCCYY        WKDFMT            9
      *
     C     KACCN         KLIST
     C                   KFLD                    KBRCA
     C                   KFLD                    KCCY
     C                   KFLD                    KACOD
     C                   KFLD                    KACSQ
     C                   KFLD                    KCNUM
      *
     C                   ENDSR
      *
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
      *
     C     *PSSR         BEGSR
      *
     C                   MOVE      'F'           P@RTCD
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   END
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2010
