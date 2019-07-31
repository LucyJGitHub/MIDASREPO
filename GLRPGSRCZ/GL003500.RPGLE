     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL ATU Delete Selected Accounts')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL003500 - Midas GL ATU Delete Selected Accounts             *
      *                                                               *
      *  Function:  This program deletes Setected Accounts for        *
      *             a given reference.                                *
      *                                                               *
      *  Called By: GLC003500                                         *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. BUG27769           Date 09Jun10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CGL114  *CREATE    Date 04Jan10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG27769 - Incorrect error code                              *
      *  CGL114 - Account Transfer Utility                            *
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
     FGLSLACPD  UP   E           K DISK    INFSR(*PSSR)
      *
     FGLSLACL5  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLSLACD0:SLAC5)
      *
     FGL003500P1O    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOL1)
     F                                     OFLIND(*IN81)
      *
      /EJECT
      *
      ** File Information Data Structure for GL003500P1
      *
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
      *
      /SPACE 3
      *
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
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
     D PSDS           SDS
      *
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
     D WRQDLN          S              3  0
     D WDIFLN          S              3  0
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
     C                   EXSR      PSSLAC
      *
     CLR                 EXSR      LRTTL
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  PSSLAC - Process Selected Accounts.                          *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls:     XDSLAC, XWP1, XVSLAC                              *
      *                                                               *
      *****************************************************************
      *
     C     PSSLAC        BEGSR
      *
      ** Delete Selected Accounts File
      *
     C                   EXSR      XDSLAC
      *
      ** Produce Report
      *
     C                   EXSR      XWP1
      *
      ** Validate Duplicate Acounts.
      *
     C                   EXSR      XVSLAC
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  XDSLAC - Delete Selected Account Record.                     *
      *                                                               *
      *  Called By: PSSLAC                                            *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
      *
     C     XDSLAC        BEGSR
      *
     C                   DELETE    GLSLACD0                             21
      *
     C     *IN21         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     'GLSLACPD'    DBFILE
     C                   MOVEL     SLRFNO        DBKEY
     C                   Z-ADD     010           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  XWP1 - Write details of all successful to report P1.         *
      *                                                               *
      *  Called By: PSSLAC                                            *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
      *
     C     XWP1          BEGSR
      *
      ** Set output fields.
      *
     C                   MOVEL     SLRFNO        P1RFNO
     C                   MOVEL     SLDESC        P1DESC
     C                   MOVEL     SLSTAT        P1STAT
     C                   MOVEL     SLCRTD        P1CRTD
     C                   MOVEL     SLFBRC        P1FBRC
     C                   MOVEL     SLFCNU        P1FCNU
     C                   MOVEL     SLFACO        P1FACO
     C                   MOVEL     SLFACS        P1FACS
     C                   MOVEL     SLCCY         P1CCY
     C                   MOVEL     SLACNO        P1ACNO
     C                   MOVEL     SLACOC        P1ACOC
     C                   MOVEL     SLATYP        P1ATYP
     C                   MOVEL     SLCOLC        P1COLC
     C                   MOVEL     SLTBRC        P1TBRC
     C                   MOVEL     SLTCNU        P1TCNU
     C                   MOVEL     SLTACO        P1TACO
     C                   MOVEL     SLTACS        P1TACS
      *
      ** Print Detail Lines.
      *
     C     *IN81         IFEQ      *ON
     C                   MOVE      *OFF          *IN81
     C                   WRITE     HEADP1                               21
     C                   MOVEL     'Y'           WKP1OP
      *
     C     *IN21         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     'GL003500P1'  DBFILE
     C                   MOVEL     'HEADP1'      DBKEY
     C                   Z-ADD     020           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
     C                   WRITE     DETAILP1                             21
      *
     C     *IN21         IFEQ      *ON
     C                   MOVEL     'GL003500P1'  DBFILE
     C                   MOVEL     'DETAILP1'    DBKEY
     C                   Z-ADD     030           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  XVSLAC - Validate Duplicate Selected Account Record.         *
      *                                                               *
      *  Called By: PSSLAC                                            *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
      *
     C     XVSLAC        BEGSR
      *
      ** Validate if a Duplicate Account is no longer a duplicate if
      ** the to Account has changed.
      *
     C                   MOVE      SLFCNU        #006              6
     C                   MOVE      SLFACO        #010A            10
     C                   MOVE      SLFACS        #002              2
     C                   MOVE      SLFBRC        #003              3
     C                   MOVE      SLRFNO        #010             10
     C                   MOVE      SLTCNU        KCUSN
     C                   MOVE      SLCCY         KCCY
     C                   MOVE      SLTACO        KACOD
     C                   MOVE      SLTACS        KACSQ
     C                   MOVE      SLTBRC        KBRCA
     C                   MOVEL     'CR'          KSTAT
      *
     C     KSLA5         SETLL     GLSLACL5                               22
     C     *IN22         IFEQ      *OFF
     C                   MOVEL     'DU'          KSTAT
     C     KSLA5         SETLL     GLSLACL5                               22
     C     KSLA5         READE     GLSLACL5                               22
      *
     C     *IN22         DOWEQ     *OFF
     C     #003          IFNE      SLFBRC
     C     #006          ORNE      SLFCNU
     C     #010A         ORNE      SLFACO
     C     #002          ORNE      SLFACS
     C     #010          ORNE      SLRFNO
     C                   MOVEL     'CR'          SLSTAT
     C                   UPDATE    SLAC5
     C                   LEAVE
      *
     C                   ENDIF
     C     KSLA5         READE     GLSLACL5                               22
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  LRTTL - Last Record Total Time.                              *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
      *
     C     LRTTL         BEGSR
      *
      ** If printer if P1 open write End of Report.
      *
     C     WKP1OP        IFEQ      'Y'
      *
     C                   EVAL      WRQDLN = 4
     C                   EVAL      WDIFLN = OFLLN1 - PRTLN1
     C                   IF        WDIFLN < WRQDLN
     C                   WRITE     HEADP1
     C                   ENDIF
      *
     C                   WRITE     TRAILP1
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initialise and define fields                        *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *DTAARA       DEFINE                  LDA
      *
     C     *LIKE         DEFINE    SLFBRC        KBRCA
     C     *LIKE         DEFINE    SLCCY         KCCY
     C     *LIKE         DEFINE    SLFACO        KACOD
     C     *LIKE         DEFINE    SLFCNU        KCUSN
     C     *LIKE         DEFINE    SLFACS        KACSQ
     C     *LIKE         DEFINE    SLSTAT        KSTAT
      *
      ** Key Lists.
      *
     C     KSLA5         KLIST
     C                   KFLD                    KBRCA
     C                   KFLD                    KCUSN
     C                   KFLD                    KCCY
     C                   KFLD                    KACOD
     C                   KFLD                    KACSQ
     C                   KFLD                    KSTAT
      *
     C     *LOCK         IN        LDA
     C                   CLEAR                   LDA
     C                   MOVEL     'GL003500'    DBPGM
     C                   OUT       LDA
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
     C                   Z-ADD     050           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVE      *ON           *IN81
     C                   MOVEL     'N'           WKP1OP            1
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
