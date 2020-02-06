     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL ATU Generate Accounts to be Reversed')        *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL003400 - Midas GL ATU Generate Accounts to be Reversed     *
      *                                                               *
      *  Function:  This program generates the accounts to be         *
      *             reversed and outputs these to the Accounts        *
      *             Transferd Selected file.                          *
      *             Two reports are produced to show successful and   *
      *             and failed accounts generations.                  *
      *                                                               *
      *  Called By: GLC003400                                         *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CRE075             Date 06Dec10               *
      *                 BUG27769           Date 09Jun10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CGL114  *CREATE    Date 04Jan10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  BUG27769 - Incorrect error code                              *
      *  CGL114 - Account Transfer Utility                            *
      *                                                               *
      *****************************************************************
      *  Function of Indicators                                       *
      *                                                               *
      *   20          Record Not Found                                *
      *   21          File Error Occurred                             *
      *   22          Start/End Of File Reached                       *
      *****************************************************************
      *
     FGLSLACPD  UP A E           K DISK    INFSR(*PSSR)
      *
     FGLACRFPD  UF   E           K DISK    INFSR(*PSSR)
      *
     FGLSLACL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLSLACD0:GLSLACV3)
      *
     FGL003400P1O    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOL1) USROPN
     F                                     OFLIND(*IN81)
      *
     FGL003400P2O    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOL2) USROPN
     F                                     OFLIND(*IN82)
      *
      /EJECT
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
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
     D SDACCT        E DS                  EXTNAME(ACCNTAB)
      *
     D PSDS           SDS
      *
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
      *
     D SPOOL2          DS
     D  SFILE2                83     92
     D  SFNUM2               123    124B 0
     D  OFLLN2               188    189B 0
     D  PRTLN2               367    368B 0
      *
     D WRQDLN          S              3  0
     D WDIFLN          S              3  0
      *****************************************************************
      /EJECT
      *****************************************************************
      *
     C                   EXSR      PSSLAC
      *
     CLR                 EXSR      PLRTTL
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  PSSLAC - Process Accounts to be reversed.                    *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls:     XSSLAC, XWP1, XWP2                                *
      *                                                               *
      *****************************************************************
      *
     C     PSSLAC        BEGSR
      *
      ** Set Work Selected Accounts Status
      *
     C                   MOVEL     'CR'          WKSLST
      *
      ** Validate if the 'From Account' has already been selected.
      *
     C                   MOVE      SLFCNU        KCUSN
     C                   MOVE      SLCCY         KCCY
     C                   MOVE      SLFACO        KACOD
     C                   MOVE      SLFACS        KACSQ
     C                   MOVE      SLFBRC        KBRCA
      *
     C     KSLAC3        SETLL     GLSLACV3                             2122
      *
     C     *IN21         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     'GLSLACL3'    DBFILE
     C                   MOVEL     'Fr a/c'      DBKEY
     C                   Z-ADD     020           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     *IN22         IFEQ      *ON
     C                   MOVEL     'RP'          WKACST
     C                   MOVEL     'DU'          WKSLST
     C                   ENDIF
      *
      ** Validate if the 'From Account' exist
      ** Retrieve Account Details.
      *
     C                   CALL      'AOACCTR0'                           21
     C                   PARM      '*BLANKS'     @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM                    @RETL            10
     C                   PARM      SLFCNU        @CNUM             6
     C                   PARM      SLCCY         @CUCD             3
     C                   PARM      SLFACO        @ACCD            10
     C                   PARM      SLFACS        @ACSQ             2
     C                   PARM      SLFBRC        @BRCA             3
     C     SDACCT        PARM      SDACCT        DSSDY
      *
     C     *IN21         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     'ACCNTAB'     DBFILE
     C                   MOVEL     SDACCT        DBKEY
     C                   Z-ADD     010           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'RP'          WKACST
     C                   MOVEL     'FA'          WKSLST
     C                   ENDIF
      *
      ** Set Status on the Selected Accounts file.
      *
     C                   UPDATE    GLSLACD0
      *
      ** Set Selected Accounts File Details.
      *
     C                   EXSR      XSSLAC
      *
      ** Write to Selected Accounts File.
      *
     C                   MOVEL     WKSLST        SLSTAT
     C                   WRITE     GLSLACD0                             21
      *
     C     *IN21         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     'GLSLACPD'    DBFILE
     C                   MOVEL     'WRITE'       DBKEY
     C                   Z-ADD     030           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Produce Reports.
      *
     C     WKSLST        IFEQ      'CR'
     C                   EXSR      XWP1
     C                   ELSE
     C                   EXSR      XWP2
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  XSSLAC - Set field for output to GLSLACPD - Selected Accounts*
      *                                                               *
      *  Called By: PSSLAC                                            *
      *                                                               *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     XSSLAC        BEGSR
      *
     C                   MOVEL     WKSLST        SLSTAT
     C                   MOVEL     WKDFMT        SLCRTD
     C                   MOVEL     *BLANKS       SLPRCD
     C                   MOVEL     SLFBRC        #003              3
     C                   MOVEL     SLTBRC        SLFBRC
     C                   MOVEL     #003          SLTBRC
     C                   MOVEL     SLFCNU        #006              6
     C                   MOVEL     SLTCNU        SLFCNU
     C                   MOVEL     #006          SLTCNU
     C                   MOVEL     SLFACO        #010             10
     C                   MOVEL     SLTACO        SLFACO
     C                   MOVEL     #010          SLTACO
     C                   MOVEL     SLFACS        #002              2
     C                   MOVEL     SLTACS        SLFACS
     C                   MOVEL     #002          SLTACS
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
     C                   IF        WOPEN1 = 'N'
     C                   OPEN      GL003400P1
     C                   MOVEL     'Y'           WOPEN1
     C                   ENDIF
      *
      ** Set output fields.
      *
     C                   MOVEL(P)  SLRFNO        P1RFNO
     C                   MOVEL(P)  SLFCNU        P1FCNU
     C                   MOVEL(P)  SLCCY         P1FCCY
     C                   MOVEL(P)  SLFACO        P1FACO
     C                   MOVEL(P)  SLFACS        P1FACS
     C                   MOVEL(P)  SLFBRC        P1FBRC
     C                   MOVEL(P)  SLACNO        P1ACNO
     C                   MOVEL(P)  SLACOC        P1ACOC
     C                   MOVEL(P)  SLATYP        P1ATYP
     C                   MOVEL(P)  SLCOLC        P1COLC
     C                   MOVEL(P)  SLTBRC        P1TBRC
     C                   MOVEL(P)  SLCCY         P1TCCY
     C                   MOVEL(P)  SLTCNU        P1TCNU
     C                   MOVEL(P)  SLTACO        P1TACO
     C                   MOVEL(P)  SLTACS        P1TACS
     C                   MOVEL(P)  SLSTAT        P1STAT
      *
      ** Print Detail Lines.
      *
     C     *IN81         IFEQ      *ON
     C                   MOVE      *OFF          *IN81
     C                   WRITE     HEADP1                               21
     C                   MOVEL     'Y'           WKP1OP
     C                   ENDIF
      *
     C                   WRITE     DETAILP1                             21
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  XWP2 - Write details of all successful to report P2.         *
      *                                                               *
      *  Called By: PSSLAC                                            *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
      *
     C     XWP2          BEGSR
      *
     C                   IF        WOPEN2 = 'N'
     C                   OPEN      GL003400P2
     C                   MOVEL     'Y'           WOPEN2
     C                   ENDIF
      *
      ** Set output fields.
      *
     C                   MOVEL(P)  SLRFNO        P2RFNO
     C                   MOVEL(P)  SLFCNU        P2FCNU
     C                   MOVEL(P)  SLCCY         P2FCCY
     C                   MOVEL(P)  SLFACO        P2FACO
     C                   MOVEL(P)  SLFACS        P2FACS
     C                   MOVEL(P)  SLFBRC        P2FBRC
     C                   MOVEL(P)  SLACNO        P2ACNO
     C                   MOVEL(P)  SLACOC        P2ACOC
     C                   MOVEL(P)  SLATYP        P2ATYP
     C                   MOVEL(P)  SLCOLC        P2COLC
     C                   MOVEL(P)  SLTBRC        P2TBRC
     C                   MOVEL(P)  SLCCY         P2TCCY
     C                   MOVEL(P)  SLTCNU        P2TCNU
     C                   MOVEL(P)  SLTACO        P2TACO
     C                   MOVEL(P)  SLTACS        P2TACS
     C                   MOVEL(P)  SLSTAT        P2STAT
      *
      ** Print Detail Lines.
      *
     C     *IN82         IFEQ      *ON
     C                   MOVE      *OFF          *IN82
     C                   WRITE     HEADP2                               21
     C                   MOVEL     'Y'           WKP2OP
     C                   ENDIF
      *
     C                   WRITE     DETAILP2                             21
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  PLRTTL - Last Record Total Time.                             *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls:     XRACRF                                            *
      *                                                               *
      *****************************************************************
      *
     C     PLRTTL        BEGSR
      *
      ** If printer if P1 open write End of Report.
      *
     C     WKP1OP        IFEQ      'Y'
     C                   EVAL      WRQDLN = 4
     C                   EVAL      WDIFLN = OFLLN1 - PRTLN1
     C                   IF        WDIFLN < WRQDLN
     C                   WRITE     HEADP1
     C                   ENDIF
     C                   WRITE     TRAILP1
     C                   ENDIF
      *
      ** If printer if P2 open write End of Report.
      *
     C     WKP2OP        IFEQ      'Y'
     C                   EVAL      WRQDLN = 4
     C                   EVAL      WDIFLN = OFLLN2 - PRTLN2
     C                   IF        WDIFLN < WRQDLN
     C                   WRITE     HEADP2
     C                   ENDIF
     C                   WRITE     TRAILP2
     C                   ENDIF
      *
      ** Retrieve Account Selection Criteria Record.
      *
     C                   EXSR      XRACRF
      *
      ** Set Status on the Accounts Criteria file.
      *
     C                   MOVEL     WKACST        ACSTAT
      *
     C                   UPDATE    GLACRFD0
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  XRACRF - Retrieve Account Transfer Citeria.                  *
      *                                                               *
      *  Called By: PLRTTL                                            *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
      *
     C     XRACRF        BEGSR
      *
      ** Retrieve Account Transfer Criteria Record.
      *
     C                   MOVEL     SLRFNO        KREFN
     C     KREF          CHAIN     GLACRFPD                           2021
      *
     C     *IN20         IFEQ      *ON
     C     *IN21         OREQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     'GLSLACPD'    DBFILE
     C                   MOVEL     SLRFNO        DBKEY
     C                   Z-ADD     040           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
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
     C     KREF          KLIST
     C                   KFLD                    KREFN
      *
     C     KSLAC3        KLIST
     C                   KFLD                    KBRCA
     C                   KFLD                    KCUSN
     C                   KFLD                    KCCY
     C                   KFLD                    KACOD
     C                   KFLD                    KACSQ
      *
     C     *LIKE         DEFINE    ACRFNO        KREFN
     C     *LIKE         DEFINE    SLFBRC        KBRCA
     C     *LIKE         DEFINE    SLFCNU        KCUSN
     C     *LIKE         DEFINE    SLCCY         KCCY
     C     *LIKE         DEFINE    SLFACO        KACOD
     C     *LIKE         DEFINE    SLFACS        KACSQ
     C     *LIKE         DEFINE    ACSTAT        WKACST
     C     *LIKE         DEFINE    SLSTAT        WKSLST
      *
     C     *LOCK         IN        LDA
     C                   CLEAR                   LDA
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
     C                   MOVEL     BJMRDT        WKDFMT            9
     C                   MOVE      BJMRDT        WKYEAR            2 0
      *
     C     WKYEAR        IFLT      72
     C     WKYEAR        ADD       2000          WKCCYY            4 0
     C                   ELSE
     C     WKYEAR        ADD       1900          WKCCYY
     C                   ENDIF
      *
     C                   MOVE      WKCCYY        WKDFMT
      *
      ** Initialise parameters, work fields, etc.
      *
     C                   MOVEL     'RC'          WKACST
      *
     C                   MOVE      *ON           *IN81
     C                   MOVE      *ON           *IN82
      *
     C                   MOVEL     'N'           WKP1OP            1
     C                   MOVEL     'N'           WKP2OP            1
     C                   MOVEL     'N'           WOPEN1            1
     C                   MOVEL     'N'           WOPEN2            1
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
