     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Account Transfer Update SDSTMDPD')            *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL019107 - Midas GL Account Transfer Update SDSTMDPD         *
      *                                                               *
      *  Function:  This program updates the Midas Stamp Tax Historic *
      *             Details with the new account details from Account *
      *             Transfer Selected Accounts File, GLSLACPD. It also*
      *             will write an audit trail record for each update  *
      *             of SDSTMDPD.                                      *
      *                                                               *
      *  Called By: GL003600                                          *
      *                                                               *
      *  (c) Finastra International Limited 2023                      *
      *                                                               *
      *  Last Amend No. MD060037*CREATE    Date 25May23               *
      *  Prev Amend No. nnnnnn             Date ddMmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD060037 - Stamp Tax Historic Details (SDSTMDPD) not updated *
      *             by Account Transfer Utility.                      *
      *                                                               *
      *****************************************************************
      *  Function of Indicators                                       *
      *                                                               *
      *  01 - 19      Input Control.                                  *
      *  20 - 29      I/O Conditioning (ie. CHAIN, LOKUP etc...)      *
      *  20           Record Not Found                                *
      *  21           File Error Occurred                             *
      *  22           Start/End Of File Reached                       *
      *  25           Lookup/Scan.                                    *
      *  30 - 39      Program Work Indicators                         *
      *  40 - 49      Output Control.                                 *
      *  50 - 89      Output Conditioning (ie. Cursor Positioning)    *
      *  90 - 99      Error Control.                                  *
      *****************************************************************
      *
     FSDSTMDLJ  UF A E           K DISK    INFSR(*PSSR)
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
     D  KCNUM                  1      6
     D  KCCY                   7      9
     D  KACOD                 10     19  0
     D  KACSQ                 20     21  0
     D  KBRCA                 22     24
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
     C                   EXSR      XVSTMP
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  XVSTMP - Validate Midas Stamp Tax Historic Details File      *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls:     XSIV01, XMSTMP                                    *
      *                                                               *
      *****************************************************************
      *
     C     XVSTMP        BEGSR
      *
      ** Check if 'To' details already exist on SDSTMDPD
      *
     C                   MOVEL     DSTCNU        KCNUM
     C                   MOVEL     DSTCCY        KCCY
     C                   MOVEL     DSTACO        KACOD
     C                   MOVEL     DSTACS        KACSQ
     C                   MOVEL     DSTBRC        KBRCA
     C     KSTMP         SETLL     SDSTMDLJ                             2122
      *
     C     *IN21         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     'SDSTMDLJ'    DBFILE
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
     C                   EXSR      XMSTMP
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
      *  XMSTMP - Maintain Midas Stamp Tax Historic Detais File       *
      *                                                               *
      *  Called By: XVSTMP                                            *
      *                                                               *
      *  Calls:     XSAUDT                                            *
      *                                                               *
      *****************************************************************
      *
     C     XMSTMP        BEGSR
      *
     C     KSTMP         SETLL     SDSTMDLJ
     C     KSTMP         READE     SDSTMDLJ                             2122
      *
     C     *IN21         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     '002'         DBASE
     C                   MOVEL     'SDSTMDLJ'    DBFILE
     C                   MOVEL     DSKITE        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Delete and Write Records until End of File for Selected Account
      *
     C     *IN22         DOWEQ     *OFF
     C                   DELETE    SDSTMDLJ                             21
      *
     C     *IN21         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     '003'         DBASE
     C                   MOVEL     'SDSTMDLJ'    DBFILE
     C                   MOVEL     DSKITE        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVEL     DSTCNU        T2CNUM
     C                   MOVEL     DSTCCY        T2CCY
     C                   MOVEL     DSTACO        T2ACOD
     C                   MOVEL     DSTACS        T2ACSQ
     C                   MOVEL     DSTBRC        T2BRCA
     C                   WRITE     @STMDP0                              21
      *
     C     *IN21         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     '004'         DBASE
     C                   MOVEL     'SDSTMDLJ'    DBFILE
     C                   MOVEL     DSKITE        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EXSR      XSAUDT
      *
     C     KSTMP         READE     SDSTMDLJ                             2122
      *
     C     *IN21         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     '005'         DBASE
     C                   MOVEL     'SDSTMDLJ'    DBFILE
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
      *  Called By: XMSTMP                                            *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
      *
     C     XSAUDT        BEGSR
      *
     C                   MOVEL     P@RFNO        AURFNO
     C                   MOVEL     'SDSTMDPD'    AUFILE
     C                   MOVEL     'SDSTMDLJ'    AULFIL
     C                   MOVEL     DSFBRC        AUFBRC
     C                   MOVEL     DSFCNU        AUFCNU
     C                   MOVEL     DSFACO        AUFACO
     C                   MOVEL     DSFACS        AUFACS
     C                   MOVEL     DSTBRC        AUTBRC
     C                   MOVEL     DSTCNU        AUTCNU
     C                   MOVEL     DSTACO        AUTACO
     C                   MOVEL     DSTACS        AUTACS
     C                   MOVEL     T2KEY         WKKEY            10
     C                   MOVEL     T2TYPE        WKTYPE            4
     C     WKKEY         CAT(P)    WKTYPE:1      AUTEXT           50
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
      *  Called By: XVSTMP                                            *
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
     C     @RTCD         ORNE      *BLANKS
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
     C     KSTMP         KLIST
     C                   KFLD                    KCNUM
     C                   KFLD                    KCCY
     C                   KFLD                    KACOD
     C                   KFLD                    KACSQ
     C                   KFLD                    KBRCA
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
(c) Finastra International Limited 2023
