     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Account Transfer - Selected Acct Maint')      *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL003100 - Midas GL Account Transfer - Selected Accounts     *
      *             Maintenance                                       *
      *                                                               *
      *  Function:  This program enables the maintenance of each      *
      *             individual account selected for transfer.         *
      *                                                               *
      *  Called By:                                                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      *  Last Amend No. CRE075             Date 06Dec10               *
      *  Prev Amend No. BUG27769           Date 09Jun10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG27219           Date 16Mar10               *
      *                 CGL114  *CREATE    Date 04Jan10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  BUG27769 - Incorrect error code                              *
      *  BUG27219- Format for message IDs in GBGLUSRMSG are for       *
      *            non-core                                           *
      *  CGL114 - Account Transfer Utility                            *
      *                                                               *
      *****************************************************************
      *  Function of Indicators                                       *
      *                                                               *
      *  01 / 02      Roll Up/Down Summary Screen (GL003100S1)        *
      *  10           SFLEND for message file                         *
      *  11           SFLNXTCHG for subfile GL003100S1                *
      *  20           Record Not Found                                *
      *  21           File Error Occurred                             *
      *  22           Start/End Of File Reached                       *
      *  25           DEM Payment to Look-up                          *
      *  70           Invalid Option entered on GL003100S1 screen     *
      *  71           Invalid Option entered on GL003100C1 screen     *
      *  72           Invalid Customer Number entered                 *
      *  81           SFLDSPCTL for subfile GL003100S1                *
      *  82           SFLCLR for subfile GL003100S1                   *
      *  82           SFLDSP for subfile GL003100S1                   *
      *  82           ERASE for subfile GL003100S1                    *
      *  83           SFLEND for subfile GL003100S1                   *
      *****************************************************************
      *
     FGL003100DFCF   E             WORKSTN INFSR(*PSSR)
     F                                     INFDS(D@WKS)
     F                                     SFILE(GL003100S1:SCRRN1)
      *
     FGLSLACPD  UF   E           K DISK    INFSR(*PSSR)
      *
     FGLSLACL5  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLSLACD0:SLAC5)
      *
     FGLSLACL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLSLACD0:SLAC0)
      *
     FGLSLACL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLSLACD0:SLAC1)
      *
     FGLSLACL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLSLACD0:SLAC2)
      *
     FGLSLACL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLSLACD0:SLAC3)
      *
     FGLSLACL4  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLSLACD0:SLAC4)
      /EJECT
      *
      ** Array containing Copyright statement
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
      ** Data Area giving Installation Control Details
      *
     D PSDS           SDS
      *
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
     D D@WKS         E DS                  EXTNAME(D@WKS)
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
     D SDACCT        E DS                  EXTNAME(ACCNTAB)
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
     D SDACOD        E DS                  EXTNAME(SDACODPD)
      *
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
      *
     D SDACOF        E DS                  EXTNAME(SDACOFPD)
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D QQDFAC1       E                     EXTFLD(QQDFAC)
      *
     D DSDF10          DS            44
     D  SLRFNO                 1     10
     D  SLFBRC                11     13
     D  SLFCNU                14     19
     D  SLCCY                 20     22
     D  SLFACO                23     32
     D  SLFACS                33     34
     D  SLGLKY                11     34
     D  SLACNO                35     44
      *
     D WKSKEY          DS            44
     D  WKSRFN                 1     10
     D  WKSBRC                11     13
     D  WKSCNU                14     19
     D  WKSCY                 20     22
     D  WKSACO                23     32
     D  WKSACS                33     34
     D  WKSCNO                35     44
      *
     D WKEKEY          DS            44
     D  WKERFN                 1     10
     D  WKEBRC                11     13
     D  WKECNU                14     19
     D  WKECY                 20     22
     D  WKEACO                23     32
     D  WKEACS                33     34
     D  WKECNO                35     44
      *
     D SLFKEY          DS            24
     D  S1BRCA                 1      3
     D  S1CUST                 4      9
     D  S1CCY                 10     12
     D  S1ACOD                13     22
     D  S1ACSQ                23     24
      * Named Constants
     D C@NUMR          C                   CONST('1234567890 ')
     D C@STCP          C                   CONST('Completed  ')
     D C@STCR          C                   CONST('Created    ')
     D C@STFA          C                   CONST('Failed     ')
     D C@STDL          C                   CONST('Deleted    ')
     D C@STDU          C                   CONST('Duplicate  ')
     D C@STRV          C                   CONST('Reversed   ')
     D C@STRC          C                   CONST('Rev/Crt    ')
      *
     D WCOUNT2         S             13A
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
     C     *INLR         DOWEQ     '0'
     C                   EXSR      XCPMSQ
      *
     C     *INKC         CASEQ     *ON           PFKEXT
     C     *INKD         CASEQ     *ON           PFKPRM
     C     *INKE         CASEQ     *ON           PFKREF
     C     *INKL         CASEQ     *ON           PFKPRV
     C     D@FMTN        CASEQ     'GL003100C1'  PDFC1
     C     D@FMTN        CASEQ     'GL003100D1'  PDFD1
     C                   CAS                     XSDFS1
     C                   ENDCS
      *
     C  NLR              READ      GL003100DF                             LR
     C                   ENDDO
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  PFKEXT - Process Function Key 3 - Exit.                      *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
      *
     C     PFKEXT        BEGSR
      *
     C                   MOVE      *ON           *INLR
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  PFKPRM - Process Function Key 4 - Prompt                     *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls:     XRBRCH, XRCUST, XRACOD, XSDFD1                    *
      *                                                               *
      *****************************************************************
      *
     C     PFKPRM        BEGSR
      *
     C                   Z-ADD     *ZERO         WKERR
     C                   CLEAR                   WKLINE
     C                   CLEAR                   WKCOLM
     C     D@CRSR        DIV       256           WKLINE            2 0
     C                   MVR                     WKCOLM            2 0
      *
      ** Detail Screen
      *
     C                   MOVEA     '00000000'    *IN(40)
     C                   MOVEA     '000'         *IN(48)
     C                   MOVEA     '00000000'    *IN(54)
     C                   MOVEA     '00000'       *IN(62)
     C                   MOVEA     '00'          *IN(73)
     C                   MOVEA     '000'         *IN(78)
     C                   MOVE      *BLANKS       WKMSID
      *
      ** If To Branch Code prompted, call selection screen
      *
     C     WKLINE        IFEQ      18
     C     WKCOLM        ANDGE     37
     C     WKCOLM        ANDLE     39
     C                   MOVEL     '?      '     WKBRCH
     C                   EXSR      XRBRCH
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     WKBRCH        S2TBRC
      *
     C                   ENDIF
     C                   MOVEL     '1'           *IN48
      *
     C                   ENDIF
      *
      ** If To Customer prompted, call selection screen
      *
     C     WKLINE        IFEQ      19
     C     WKCOLM        ANDGE     37
     C     WKCOLM        ANDLE     42
     C                   MOVEL     '?      '     WKCUS
     C                   EXSR      XRCUST
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     WKCUS         S2TCNU
      *
     C                   ENDIF
     C                   MOVEL     '1'           *IN49
      *
     C                   ENDIF
      *
      ** If To Acc Code prompted, call selection screen
      *
     C     WKLINE        IFEQ      20
     C     WKCOLM        ANDGE     37
     C     WKCOLM        ANDLE     40
     C                   MOVE      *BLANKS       WKACC
     C                   MOVEL     '?      '     WKACC
     C                   EXSR      XRACOD
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     WKACC         S2TACO
      *
     C                   ENDIF
     C                   MOVEL     '1'           *IN50
      *
     C                   ENDIF
      *
     C                   EXSR      XSDFD1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  PFKREF - Process Function Key 5 - Refresh Screen.            *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls:     XCPMSQ, XRSLAC, XCPMSQ, XSDFD1                    *
      *                                                               *
      *****************************************************************
      *
     C     PFKREF        BEGSR
      *
     C                   EXSR      XCPMSQ
      *
     C                   EXSR      XRSLAC
     C                   MOVEL     SLRFNO        S2RFNO
     C                   MOVEL     SLDESC        S2DESC
     C                   MOVE      SLFBRC        S2BRCA
     C                   MOVE      SLFCNU        S2CNU1
     C                   MOVE      SLCCY         S2CCY
     C                   MOVE      SLFACO        S2ACO1
     C                   MOVE      SLFACS        S2ACSQ
     C                   MOVE      SLACNO        S2ACN1
     C                   MOVE      SLACOC        S2ACOC
     C                   MOVE      SLATYP        S2ATYP
     C                   MOVE      SLCOLC        S2COLC
     C                   MOVE      SLTBRC        S2TBRC
     C                   MOVE      SLTCNU        S2TCNU
     C                   MOVE      SLTACO        S2TACO
     C                   MOVE      SLTACS        S2TACS
     C                   EXSR      XCPMSQ
     C                   EXSR      XSDFD1
     C                   MOVE      *BLANKS       SCOPTN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  PFKPRV - Process Function Key 12 - Previous Screen.          *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls:     XCPMSQ                                            *
      *                                                               *
      *****************************************************************
      *
     C     PFKPRV        BEGSR
      *
     C                   EXSR      XCPMSQ
     C                   WRITE     GL003100F1
     C                   WRITE     MSGCTL
     C                   WRITE     GL003100C1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  PDFC1 - Process Display Format - Subfile Control (C1).       *
      *                                                               *
      *  Called By: Main  Processing                                  *
      *                                                               *
      *  Calls:     XVDFC1, XSPMSQ, XVDFC1, XSDFS1, PDFS1             *
      *                                                               *
      *****************************************************************
      *
     C     PDFC1         BEGSR
      *
     C                   SELECT
      *
     C     SCOPTN        WHENNE    *BLANKS
      *
     C     SCOPTN        IFEQ      'A '
     C     SCOPTN        OREQ      ' A'
     C     SCOPTN        OREQ      'D '
     C     SCOPTN        OREQ      ' D'
     C     SCOPTN        OREQ      'E '
     C     SCOPTN        OREQ      ' E'
     C                   EXSR      XVDFC1
     C                   ELSE
      *
     C                   MOVE      *ON           *IN71
     C                   ADD       1             WKERR
      **********         MOVEL     'XX00016'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0016'     WKMSID                                     BUG27219
     C                   EXSR      XSPMSQ
     C                   WRITE     GL003100F1
     C                   WRITE     MSGCTL
     C                   WRITE     GL003100C1
     C                   ENDIF
      *
     C     SCPOS1        WHENNE    *BLANKS
     C     SCPOS2        ORNE      *BLANKS
     C     SCPOS3        ORNE      *BLANKS
     C                   EXSR      XVDFC1
     C     WKERR         IFEQ      *ZERO
     C                   EXSR      XSDFS1
     C                   ENDIF
      *
     C     *IN01         WHENEQ    *ON
     C     *IN02         OREQ      *ON
     C                   EXSR      XSDFS1
      *
     C     *IN82         WHENEQ    *OFF
     C                   EXSR      PDFS1
     C                   ENDSL
      *
     C                   CLEAR                   WKERR
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  PDFD1 - Process Display Format - Detail (D1).                *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls:     XVDFD1, XRACCT, XUSLAC, XDSLAC, XSDFS1, XRSLAC,   *
      *             XCPMSQ, XSDFD1, XSPMSQ,                           *
      *                                                               *
      *****************************************************************
      *
     C     PDFD1         BEGSR
      *
      ** Process Detail Screen.
      *
     C                   MOVEA     '00000000'    *IN(54)
     C                   MOVEA     '00000'       *IN(62)
     C                   MOVEA     '00'          *IN(73)
     C                   MOVEA     '000'         *IN(78)
     C                   MOVE      *BLANKS       WKMSID
      *
      ** If Amend, Validate Input
      *
     C                   SELECT
     C     WKOPTN        WHENEQ    'A '
     C     WKOPTN        OREQ      ' A'
     C                   EXSR      XVDFD1
      *
     C                   ENDSL
      *
      ** If Amend Update Details
      *
     C     WKOPTN        IFEQ      'A '
     C     WKERR         ANDEQ     0
     C     WKOPTN        OREQ      ' A'
     C     WKERR         ANDEQ     0
      *
     C     S2TBRC        IFEQ      *BLANKS
     C                   MOVEL     S2BRCA        S2TBRC
     C                   ENDIF
      *
     C     S2TCNU        IFEQ      *BLANKS
     C                   MOVEL     S2CNU1        S2TCNU
     C                   ENDIF
      *
     C     S2TACO        IFEQ      *BLANKS
     C                   MOVEL     S2ACO1        S2TACO
     C                   ENDIF
      *
     C     S2TACS        IFEQ      *BLANKS
     C                   MOVEL     S2ACSQ        S2TACS
     C                   ENDIF
      *
      ** Save To Account.
      *
     C                   MOVE      SLTBRC        #003              3
     C                   MOVE      SLTCNU        #006              6
     C                   MOVE      SLTACO        #010             10
     C                   MOVE      SLTACS        #002              2
      *
      ** Validate if the 'To Account' has already been selected.
      *
     C                   MOVEL     'CR'          WKSTAT
     C                   MOVE      S2TCNU        KCUSN
     C                   MOVE      SLCCY         KCCY
     C                   MOVE      S2TACO        KACOD
     C                   MOVE      S2TACS        KACSQ
     C                   MOVE      S2TBRC        KBRCA
      *
     C     KSLA3         SETLL     GLSLACL3                             2122
     C     *IN21         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     'GLSLACL3'    DBFILE
     C                   MOVEL     'To a/c'      DBKEY
     C                   Z-ADD     020           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     *IN22         IFEQ      *ON
     C     #003          IFNE      S2TBRC
     C     #006          ORNE      S2TCNU
     C     #010          ORNE      S2TACO
     C     #002          ORNE      S2TACS
     C                   MOVEL     'DU'          WKSTAT
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Validate if the 'To Account' has already exist.
      *
     C                   MOVEL     S2TBRC        @BRCA
     C                   MOVE      S2TCNU        @CNUM
     C                   MOVE      SLCCY         @CUCD
     C                   MOVE      S2TACO        @ACCD
     C                   MOVE      S2TACS        @ACSQ
     C                   EXSR      XRACCT
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'FA'          WKSTAT
     C                   ENDIF
      *
      ** Update Details.
      *
     C                   MOVEL     WKSTAT        SLSTAT
     C                   MOVEL     S2TBRC        SLTBRC
     C                   MOVEL     S2TCNU        SLTCNU
     C                   MOVEL     S2TACO        SLTACO
     C                   MOVEL     S2TACS        SLTACS
     C                   MOVEL     WKDFMT        SLCRTD
     C                   MOVE      *BLANKS       WKOPTN
     C                   EXSR      XUSLAC
      *
      ** Validate if a Duplicate Account is no longer a duplicate if the
      ** To Account has changed.
      *
     C     #003          IFNE      SLTBRC
     C     #006          ORNE      SLTCNU
     C     #010          ORNE      SLTACO
     C     #002          ORNE      SLTACS
     C                   MOVEL     #003          KBRCA
     C                   MOVEL     #006          KCUSN
     C                   MOVEL     #010          KACOD
     C                   MOVEL     #002          KACSQ
     C                   MOVEL     'CR'          KSTAT
     C     KSLA5         SETLL     GLSLACL5                               22
     C     *IN22         IFEQ      *OFF
     C                   MOVEL     'DU'          KSTAT
     C     KSLA5         SETLL     GLSLACL5                               22
     C     KSLA5         READE     GLSLACL5                               22
      *
     C     *IN22         DOWEQ     *OFF
     C     S2BRCA        IFNE      SLFBRC
     C     S2CNU1        ORNE      SLFCNU
     C     S2ACO1        ORNE      SLFACO
     C     S2ACSQ        ORNE      SLFACS
     C     S2RFNO        ORNE      SLRFNO
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
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If Delete Remove Details
      *
     C     WKOPTN        IFEQ      'D '
     C     WKOPTN        OREQ      ' D'
     C                   MOVE      *BLANKS       WKOPTN
      *
     C                   EXSR      XDSLAC
      *
      ** Validate if a Duplicate Account is no longer a duplicate if the
      ** To Account has changed.
      *
     C                   MOVE      SLTCNU        KCUSN
     C                   MOVE      SLCCY         KCCY
     C                   MOVE      SLTACO        KACOD
     C                   MOVE      SLTACS        KACSQ
     C                   MOVE      SLTBRC        KBRCA
     C                   MOVEL     'CR'          KSTAT
     C     KSLA5         SETLL     GLSLACL5                               22
     C     *IN22         IFEQ      *OFF
     C                   MOVEL     'DU'          KSTAT
     C     KSLA5         SETLL     GLSLACL5                               22
     C     KSLA5         READE     GLSLACL5                               22
      *
     C     *IN22         DOWEQ     *OFF
     C     S2BRCA        IFNE      SLFBRC
     C     S2CNU1        ORNE      SLFCNU
     C     S2ACO1        ORNE      SLFACO
     C     S2ACSQ        ORNE      SLFACS
     C     S2RFNO        ORNE      SLRFNO
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
     C                   ENDIF
      *
      ** If there are options queued on the subfile,
      ** validate them, set screen data items and display detail screen.
      ** Otherwise, redisplay selection list.
      *
     C     WKERR         IFEQ      0
     C                   READC     GL003100S1                             22
      *
     C     *IN22         DOWEQ     *OFF
     C     S1OPTN        ANDEQ     *BLANKS
     C                   MOVE      *OFF          *IN70
     C                   UPDATE    GL003100S1
     C                   READC     GL003100S1                             22
     C                   ENDDO
      *
      ** For all records which have been selected with a valid option,
      ** set screen data items and display the detail screen
      ** Otherwise, redisplay selection list.
      *
     C                   SELECT
     C     *IN22         WHENEQ    *ON
     C                   EXSR      XSDFS1
      *
     C     S1OPTN        WHENEQ    'E '
     C     S1OPTN        OREQ      ' E'
     C                   MOVE      S1OPTN        WKOPTN
     C                   MOVE      *BLANKS       S1OPTN
     C                   UPDATE    GL003100S1
     C                   MOVEL     S1RFNO        SLRFNO
     C                   EXSR      XRSLAC
     C                   MOVEL     SLRFNO        S2RFNO
     C                   MOVEL     SLDESC        S2DESC
     C                   MOVE      SLFBRC        S2BRCA
     C                   MOVE      SLFCNU        S2CNU1
     C                   MOVE      SLCCY         S2CCY
     C                   MOVE      SLFACO        S2ACO1
     C                   MOVE      SLFACS        S2ACSQ
     C                   MOVE      SLACNO        S2ACN1
     C                   MOVE      SLACOC        S2ACOC
     C                   MOVE      SLATYP        S2ATYP
     C                   MOVE      SLCOLC        S2COLC
     C                   MOVE      SLTBRC        S2TBRC
     C                   MOVE      SLTCNU        S2TCNU
     C                   MOVE      SLTACO        S2TACO
     C                   MOVE      SLTACS        S2TACS
      *
     C                   EXSR      XCPMSQ
     C                   MOVEA     '11'          *IN(76)
     C                   EXSR      XSDFD1
      *
     C     S1OPTN        WHENEQ    'A '
     C     S1OPTN        OREQ      ' A'
     C                   MOVEL     S1RFNO        SLRFNO
     C                   EXSR      XRSLAC
     C     SLSTAT        IFEQ      'CR'
     C     SLSTAT        OREQ      'FA'
     C     SLPRCD        ANDEQ     *BLANKS
     C     SLSTAT        OREQ      'DU'
     C     SLPRCD        ANDEQ     *BLANKS
     C                   MOVE      S1OPTN        WKOPTN
     C                   MOVE      *BLANKS       S1OPTN
     C                   UPDATE    GL003100S1
     C                   MOVEL     SLRFNO        S2RFNO
     C                   MOVEL     SLDESC        S2DESC
     C                   MOVE      SLFBRC        S2BRCA
     C                   MOVE      SLFCNU        S2CNU1
     C                   MOVE      SLCCY         S2CCY
     C                   MOVE      SLFACO        S2ACO1
     C                   MOVE      SLFACS        S2ACSQ
     C                   MOVE      SLACNO        S2ACN1
     C                   MOVE      SLACOC        S2ACOC
     C                   MOVE      SLATYP        S2ATYP
     C                   MOVE      SLCOLC        S2COLC
     C                   MOVE      SLTBRC        S2TBRC
     C                   MOVE      SLTCNU        S2TCNU
     C                   MOVE      SLTACO        S2TACO
     C                   MOVE      SLTACS        S2TACS
      *
     C                   EXSR      XCPMSQ
     C                   MOVE      '1'           *IN76
     C                   EXSR      XSDFD1
      *
     C                   ELSE
     C                   MOVE      *ON           *IN70
     C                   UPDATE    GL003100S1
      **********         MOVEL     'XX00010'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0010'     WKMSID                                     BUG27219
     C                   EXSR      XSPMSQ
     C                   ADD       1             WKERR
     C                   WRITE     GL003100F1
     C                   WRITE     MSGCTL
     C                   WRITE     GL003100C1
     C                   ENDIF
      *
     C     S1OPTN        WHENEQ    'D '
     C     S1OPTN        OREQ      ' D'
     C                   MOVEL     S1RFNO        SLRFNO
     C                   EXSR      XRSLAC
     C     SLSTAT        IFEQ      'CR'
     C     SLSTAT        OREQ      'FA'
     C     SLPRCD        ANDEQ     *BLANKS
     C     SLSTAT        OREQ      'DU'
     C     SLPRCD        ANDEQ     *BLANKS
     C                   MOVE      S1OPTN        WKOPTN
     C                   MOVE      *BLANKS       S1OPTN
     C                   UPDATE    GL003100S1
     C                   MOVEA     '111'         *IN(75)
     C                   MOVE      SLRFNO        S2RFNO
     C                   MOVEL     SLDESC        S2DESC
     C                   MOVE      SLFBRC        S2BRCA
     C                   MOVE      SLFCNU        S2CNU1
     C                   MOVE      SLCCY         S2CCY
     C                   MOVE      SLFACO        S2ACO1
     C                   MOVE      SLFACS        S2ACSQ
     C                   MOVE      SLACNO        S2ACN1
     C                   MOVE      SLACOC        S2ACOC
     C                   MOVE      SLATYP        S2ATYP
     C                   MOVE      SLCOLC        S2COLC
     C                   MOVE      SLTBRC        S2TBRC
     C                   MOVE      SLTCNU        S2TCNU
     C                   MOVE      SLTACO        S2TACO
     C                   MOVE      SLTACS        S2TACS
     C                   EXSR      XSDFD1
      *
     C                   ELSE
     C                   MOVE      *ON           *IN70
     C                   UPDATE    GL003100S1
      **********         MOVEL     'XX00010'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0010'     WKMSID                                     BUG27219
     C                   EXSR      XSPMSQ
     C                   ADD       1             WKERR
     C                   WRITE     GL003100F1
     C                   WRITE     MSGCTL
     C                   WRITE     GL003100C1
     C                   ENDIF
      *
     C                   OTHER
     C                   MOVE      *ON           *IN70
     C                   UPDATE    GL003100S1
      **********         MOVEL     'XX00016'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0016'     WKMSID                                     BUG27219
     C                   EXSR      XSPMSQ
     C                   WRITE     GL003100F1
     C                   WRITE     MSGCTL
     C                   WRITE     GL003100C1
     C                   ENDSL
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  XVDFD1 - Validate Detail Screen Input                        *
      *                                                               *
      *  Called By: PDFD1                                             *
      *                                                               *
      *  Calls:     XRBRCH, XSPMSQ, XRCUST, XRACOD, XSDFD1            *
      *                                                               *
      *****************************************************************
      *
     C     XVDFD1        BEGSR
      *
     C                   Z-ADD     0             WKERR
      *
      ** 'To Branch Code', if entered, must be a valid Branch
      *
     C                   SELECT
     C     S2TBRC        WHENNE    *BLANKS
     C                   MOVEL     S2TBRC        WKBRCH
     C                   EXSR      XRBRCH
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      *BLANKS       S2TBRN
      **********         MOVEL     'XX00036'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0036'     WKMSID                                     BUG27219
     C                   EXSR      XSPMSQ
     C                   ADD       1             WKERR
     C                   MOVE      *ON           *IN62
      *
     C                   ELSE
     C                   MOVEL     A8BRNM        S2TBRN
     C                   ENDIF
      *
     C                   ENDSL
      *
      ** 'To Customer', if entered, must be a valid Customer
      *
     C     S2TCNU        IFNE      *BLANKS
     C                   MOVEL     S2TCNU        WKCUS
     C                   EXSR      XRCUST
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      *BLANKS       S2TCRN
      **********         MOVEL     'XX00038'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0038'     WKMSID                                     BUG27219
     C                   EXSR      XSPMSQ
     C                   ADD       1             WKERR
     C                   MOVE      *ON           *IN63
      *
     C                   ELSE
     C                   MOVEL     BBCRNM        S2TCRN
     C                   ENDIF
     C                   ENDIF
      *
      ** 'To Acc Code', if entered, must be a valid Account Code
      *
     C     S2TACO        IFNE      *BLANKS
     C                   MOVEL     S2TACO        WKACC
     C                   EXSR      XRACOD
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      *BLANKS       S2TACC
      **********         MOVEL     'XX00041'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0041'     WKMSID                                     BUG27219
     C                   EXSR      XSPMSQ
     C                   ADD       1             WKERR
     C                   MOVE      *ON           *IN64
      *
     C                   ELSE
     C                   MOVEL     A5ACCN        S2TACC
      *
     C     WKACTY        IFNE      A5ACTY
      **********         MOVEL     'XX00051'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0051'     WKMSID                                     BUG27219
     C                   EXSR      XSPMSQ
     C                   ADD       1             WKERR
     C                   MOVE      *ON           *IN64
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** 'To Account Seq' must be a number between 1 and 99
      *
     C                   SELECT
     C     S2TACS        WHENNE    *BLANKS
     C     S2TACS        IFLT      '01'
     C     S2TACS        ORGT      '99'
      **********         MOVEL     'XX00044'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0044'     WKMSID                                     BUG27219
     C                   EXSR      XSPMSQ
     C                   ADD       1             WKERR
     C                   MOVE      *ON           *IN(65)
     C                   ENDIF
     C                   ENDSL
      *
      ** At least one of the Transfer Details must be entered
      *
     C     S2TBRC        IFEQ      *BLANKS
     C     S2TCNU        ANDEQ     *BLANKS
     C     S2TACO        ANDEQ     *BLANKS
     C     S2TACS        ANDEQ     *BLANKS
      **********         MOVEL     'XX00046'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0046'     WKMSID                                     BUG27219
     C                   EXSR      XSPMSQ
     C                   ADD       1             WKERR
     C                   MOVEA     '1111'        *IN(62)
     C                   ENDIF
      *
      ** If there are any errors, redisplay detail screen,
      ** otherwise update the file and return to subfile screen.
      *
     C     WKERR         IFGT      0
     C                   MOVE      *ON           *IN76
     C                   EXSR      XSDFD1
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  PDFS1 - Process Display Format - Subfile (S1).               *
      *                                                               *
      *  Called By: PDFC1                                             *
      *                                                               *
      *  Calls:     XSDFS1, XRSLAC, XCPMSQ, XSDFD1, XSPMSQ            *
      *                                                               *
      *****************************************************************
      *
     C     PDFS1         BEGSR
      *
     C                   READC     GL003100S1                             22
      *
     C     *IN22         DOWEQ     *OFF
     C     S1OPTN        ANDEQ     *BLANKS
     C                   MOVE      *OFF          *IN70
     C                   UPDATE    GL003100S1
     C                   READC     GL003100S1                             22
     C                   ENDDO
      *
      ** For all records which have been selected with a valid option (E),
      ** set screen data items and display the detail screen
      ** Otherwise, redisplay selection list.
      *
     C                   SELECT
     C     *IN22         WHENEQ    *ON
     C                   EXSR      XSDFS1
      *
     C     S1OPTN        WHENEQ    'E '
     C     S1OPTN        OREQ      ' E'
     C                   MOVE      S1OPTN        WKOPTN
     C                   MOVE      *BLANKS       S1OPTN
     C                   UPDATE    GL003100S1
     C                   MOVE      *ON           *IN77
     C                   MOVEL     S1RFNO        SLRFNO
     C                   EXSR      XRSLAC
     C                   MOVEL     SLRFNO        S2RFNO
     C                   MOVEL     SLDESC        S2DESC
     C                   MOVE      SLFBRC        S2BRCA
     C                   MOVE      SLFCNU        S2CNU1
     C                   MOVE      SLCCY         S2CCY
     C                   MOVE      SLFACO        S2ACO1
     C                   MOVE      SLFACS        S2ACSQ
     C                   MOVE      SLACNO        S2ACN1
     C                   MOVE      SLACOC        S2ACOC
     C                   MOVE      SLATYP        S2ATYP
     C                   MOVE      SLCOLC        S2COLC
     C                   MOVE      SLTBRC        S2TBRC
     C                   MOVE      SLTCNU        S2TCNU
     C                   MOVE      SLTACO        S2TACO
     C                   MOVE      SLTACS        S2TACS
     C                   EXSR      XCPMSQ
     C                   MOVEA     '11'          *IN(76)
     C                   EXSR      XSDFD1
      *
     C     S1OPTN        WHENEQ    'A '
     C     S1OPTN        OREQ      ' A'
     C                   MOVEL     S1RFNO        SLRFNO
     C                   EXSR      XRSLAC
     C     SLSTAT        IFEQ      'CR'
     C     SLSTAT        OREQ      'FA'
     C     SLPRCD        ANDEQ     *BLANKS
     C     SLSTAT        OREQ      'DU'
     C     SLPRCD        ANDEQ     *BLANKS
     C                   MOVE      S1OPTN        WKOPTN
     C                   MOVE      *BLANKS       S1OPTN
     C                   UPDATE    GL003100S1
     C                   MOVEL     SLRFNO        S2RFNO
     C                   MOVEL     SLDESC        S2DESC
     C                   MOVE      SLFBRC        S2BRCA
     C                   MOVE      SLFCNU        S2CNU1
     C                   MOVE      SLCCY         S2CCY
     C                   MOVE      SLFACO        S2ACO1
     C                   MOVE      SLFACS        S2ACSQ
     C                   MOVE      SLACNO        S2ACN1
     C                   MOVE      SLACOC        S2ACOC
     C                   MOVE      SLATYP        S2ATYP
     C                   MOVE      SLCOLC        S2COLC
     C                   MOVE      SLTBRC        S2TBRC
     C                   MOVE      SLTCNU        S2TCNU
     C                   MOVE      SLTACO        S2TACO
     C                   MOVE      SLTACS        S2TACS
     C                   EXSR      XCPMSQ
     C                   MOVE      '1'           *IN76
     C                   EXSR      XSDFD1
      *
     C                   ELSE
     C                   MOVE      *ON           *IN70
     C                   UPDATE    GL003100S1
      **********         MOVEL     'XX00010'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0010'     WKMSID                                     BUG27219
     C                   EXSR      XSPMSQ
     C                   ADD       1             WKERR
     C                   WRITE     GL003100F1
     C                   WRITE     MSGCTL
     C                   WRITE     GL003100C1
     C                   ENDIF
      *
     C     S1OPTN        WHENEQ    'D '
     C     S1OPTN        OREQ      ' D'
     C                   MOVEL     S1RFNO        SLRFNO
     C                   EXSR      XRSLAC
     C     SLSTAT        IFEQ      'CR'
     C     SLSTAT        OREQ      'FA'
     C     SLPRCD        ANDEQ     *BLANKS
     C     SLSTAT        OREQ      'DU'
     C     SLPRCD        ANDEQ     *BLANKS
     C                   MOVE      S1OPTN        WKOPTN
     C                   MOVE      *BLANKS       S1OPTN
     C                   UPDATE    GL003100S1
     C                   MOVEL     SLRFNO        S2RFNO
     C                   MOVEL     SLDESC        S2DESC
     C                   MOVE      SLFBRC        S2BRCA
     C                   MOVE      SLFCNU        S2CNU1
     C                   MOVE      SLCCY         S2CCY
     C                   MOVE      SLFACO        S2ACO1
     C                   MOVE      SLFACS        S2ACSQ
     C                   MOVE      SLACNO        S2ACN1
     C                   MOVE      SLACOC        S2ACOC
     C                   MOVE      SLATYP        S2ATYP
     C                   MOVE      SLCOLC        S2COLC
     C                   MOVE      SLTBRC        S2TBRC
     C                   MOVE      SLTCNU        S2TCNU
     C                   MOVE      SLTACO        S2TACO
     C                   MOVE      SLTACS        S2TACS
     C                   MOVEA     '111'         *IN(75)
     C                   EXSR      XSDFD1
      *
     C                   ELSE
     C                   MOVE      *ON           *IN70
     C                   UPDATE    GL003100S1
      **********         MOVEL     'XX00010'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0010'     WKMSID                                     BUG27219
     C                   EXSR      XSPMSQ
     C                   ADD       1             WKERR
     C                   WRITE     GL003100F1
     C                   WRITE     MSGCTL
     C                   WRITE     GL003100C1
     C                   ENDIF
      *
     C                   OTHER
     C                   MOVE      *ON           *IN70
     C                   UPDATE    GL003100S1
      **********         MOVEL     'XX00017'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0017'     WKMSID                                     BUG27219
     C                   EXSR      XSPMSQ
     C                   WRITE     GL003100F1
     C                   WRITE     MSGCTL
     C                   WRITE     GL003100C1
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  XVDFC1 - Validate Input to Subfile Control Screen (C1)       *
      *                                                               *
      *  Called By: PDFC1                                             *
      *                                                               *
      *  Calls:     XSPMSQ, XRSLAC, XCPMSQ, XSDFD1, XRSLAC            *
      *                                                               *
      *****************************************************************
      *
     C     XVDFC1        BEGSR
      *
     C                   Z-ADD     0             WKERR             5 0
     C                   MOVEA     '00'          *IN(54)
      *
     C     SCOPTN        IFNE      *BLANKS
     C                   SELECT
      *
     C     SCPOS1        WHENEQ    *BLANKS
     C     SCPOS2        OREQ      *BLANKS
      **********         MOVEL     'XX00018'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0018'     WKMSID                                     BUG27219
     C                   EXSR      XSPMSQ
     C                   ADD       1             WKERR
     C                   MOVE      *ON           *IN54
      *
     C     SCPOS1        IFEQ      *BLANKS
      **********         MOVEL     'XX00005'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0005'     WKMSID                                     BUG27219
     C                   EXSR      XSPMSQ
     C                   ADD       1             WKERR
     C                   MOVE      *ON           *IN54
     C                   ENDIF
      *
     C     SCPOS2        IFEQ      *BLANKS
      **********         MOVEL     'XX00006'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0006'     WKMSID                                     BUG27219
     C                   EXSR      XSPMSQ
     C                   ADD       1             WKERR
     C                   MOVE      *ON           *IN55
     C                   ENDIF
      *
     C     SCOPTN        WHENEQ    'E '
     C     SCOPTN        OREQ      ' E'
     C                   MOVEL     SCPOS1        SLRFNO
     C                   MOVEL     SCPOS2        SLFKEY
     C                   EXSR      XRSLAC
     C     *IN20         IFEQ      *ON
      **********         MOVEL     'XX00018'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0018'     WKMSID                                     BUG27219
     C                   EXSR      XSPMSQ
     C                   ADD       1             WKERR
     C                   MOVEA     '11'          *IN(54)
     C                   ELSE
      *
     C                   MOVEL     SLRFNO        S2RFNO
     C                   MOVEL     SLDESC        S2DESC
     C                   MOVE      SLFBRC        S2BRCA
     C                   MOVE      SLFCNU        S2CNU1
     C                   MOVE      SLCCY         S2CCY
     C                   MOVE      SLFACO        S2ACO1
     C                   MOVE      SLFACS        S2ACSQ
     C                   MOVE      SLACNO        S2ACN1
     C                   MOVE      SLACOC        S2ACOC
     C                   MOVE      SLATYP        S2ATYP
     C                   MOVE      SLCOLC        S2COLC
     C                   MOVE      SLTBRC        S2TBRC
     C                   MOVE      SLTCNU        S2TCNU
     C                   MOVE      SLTACO        S2TACO
     C                   MOVE      SLTACS        S2TACS
     C                   EXSR      XCPMSQ
     C                   MOVEA     '11'          *IN(76)
     C                   EXSR      XSDFD1
     C                   MOVE      *BLANKS       SCOPTN
     C                   ENDIF
      *
     C     SCOPTN        WHENEQ    'A '
     C     SCOPTN        OREQ      ' A'
     C                   MOVE      SCOPTN        WKOPTN
     C                   MOVEL     SCPOS1        SLRFNO
     C                   MOVEL     SCPOS2        SLFKEY
     C                   EXSR      XRSLAC
     C     SLSTAT        IFNE      'CR'
     C     SLSTAT        OREQ      'FA'
     C     SLPRCD        ANDNE     *BLANKS
     C     SLSTAT        OREQ      'DU'
     C     SLPRCD        ANDNE     *BLANKS
      **********         MOVEL     'XX00010'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0010'     WKMSID                                     BUG27219
     C                   EXSR      XSPMSQ
     C                   ADD       1             WKERR
     C                   MOVE      *ON           *IN54
     C                   MOVE      *ON           *IN55
     C                   ELSE
      *
     C     *IN20         IFEQ      *ON
      **********         MOVEL     'XX00018'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0018'     WKMSID                                     BUG27219
     C                   EXSR      XSPMSQ
     C                   ADD       1             WKERR
     C                   MOVE      *ON           *IN54
     C                   MOVE      *ON           *IN55
     C                   ELSE
      *
     C                   MOVEL     SLRFNO        S2RFNO
     C                   MOVEL     SLDESC        S2DESC
     C                   MOVE      SLFBRC        S2BRCA
     C                   MOVE      SLFCNU        S2CNU1
     C                   MOVE      SLCCY         S2CCY
     C                   MOVE      SLFACO        S2ACO1
     C                   MOVE      SLACNO        S2ACN1
     C                   MOVE      SLACOC        S2ACOC
     C                   MOVE      SLATYP        S2ATYP
     C                   MOVE      SLCOLC        S2COLC
     C                   MOVE      SLTBRC        S2TBRC
     C                   MOVE      SLTCNU        S2TCNU
     C                   MOVE      SLTACO        S2TACO
     C                   MOVE      SLTACS        S2TACS
     C                   EXSR      XCPMSQ
     C                   MOVE      '1'           *IN76
     C                   EXSR      XSDFD1
     C                   MOVE      *BLANKS       SCOPTN
     C                   ENDIF
     C                   ENDIF
      *
     C     SCOPTN        WHENEQ    'D '
     C     SCOPTN        OREQ      ' D'
     C                   MOVE      SCOPTN        WKOPTN
     C                   MOVEL     SCPOS1        SLRFNO
     C                   MOVEL     SCPOS2        SLFKEY
     C                   EXSR      XRSLAC
     C     SLSTAT        IFNE      'CR'
     C     SLSTAT        OREQ      'FA'
     C     SLPRCD        ANDNE     *BLANKS
     C     SLSTAT        OREQ      'DU'
     C     SLPRCD        ANDNE     *BLANKS
      **********         MOVEL     'XX00010'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0010'     WKMSID                                     BUG27219
     C                   EXSR      XSPMSQ
     C                   ADD       1             WKERR
     C                   MOVE      *ON           *IN54
     C                   MOVE      *ON           *IN55
     C                   ELSE
      *
     C     *IN20         IFEQ      *ON
      **********         MOVEL     'XX00018'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0018'     WKMSID                                     BUG27219
     C                   EXSR      XSPMSQ
     C                   ADD       1             WKERR
     C                   MOVE      *ON           *IN54
     C                   MOVE      *ON           *IN55
     C                   ELSE
      *
     C                   MOVEL     SLRFNO        S2RFNO
     C                   MOVEL     SLDESC        S2DESC
     C                   MOVE      SLFBRC        S2BRCA
     C                   MOVE      SLFCNU        S2CNU1
     C                   MOVE      SLCCY         S2CCY
     C                   MOVE      SLFACO        S2ACO1
     C                   MOVE      SLFACS        S2ACSQ
     C                   MOVE      SLACNO        S2ACN1
     C                   MOVE      SLACOC        S2ACOC
     C                   MOVE      SLATYP        S2ATYP
     C                   MOVE      SLCOLC        S2COLC
     C                   MOVE      SLTBRC        S2TBRC
     C                   MOVE      SLTCNU        S2TCNU
     C                   MOVE      SLTACO        S2TACO
     C                   MOVE      SLTACS        S2TACS
     C                   EXSR      XCPMSQ
     C                   MOVEA     '111'         *IN(75)
     C                   EXSR      XSDFD1
     C                   MOVE      *BLANKS       SCOPTN
     C                   ENDIF
     C                   ENDIF
      *
     C                   OTHER
     C                   MOVE      *ON           *IN71
     C                   ADD       1             WKERR
      **********         MOVEL     'XX00016'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0016'     WKMSID                                     BUG27219
     C                   EXSR      XSPMSQ
     C                   ENDSL
     C                   ELSE
      *
      ** Check if Reference # is requested.
      *
     C                   SELECT
     C     SCPOS1        WHENNE    *BLANKS
     C                   MOVEL     'SCPOS1'      WKPOSN            6
      *
      ** Check if GL Account positioning is requested.
      *
     C     SCPOS2        WHENNE    *BLANKS
     C                   MOVEL     'SCPOS2'      WKPOSN
      *
      ** Check if Retail positioning is requested.
      *
     C     SCPOS3        WHENNE    *BLANKS
     C                   MOVEL     'SCPOS3'      WKPOSN
      *
     C                   OTHER
     C                   MOVEL     *BLANKS       WKPOSN
      *
     C                   ENDSL
     C                   ENDIF
      *
      ** If errors have been found redisplay Subfile Control Screen.
      *
     C     WKERR         IFGT      *ZERO
     C                   WRITE     GL003100F1
     C                   WRITE     MSGCTL
     C                   WRITE     GL003100C1
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  XSDFS1 - Initialise Data Items & Subfile.                    *
      *                                                               *
      *  Called By: Main Processing, PDFC1, PDFD1, PDFS1              *
      *                                                               *
      *  Calls:     XPSLAC, XSSLAC,                                   *
      *                                                               *
      *****************************************************************
      *
     C     XSDFS1        BEGSR
      *
     C                   Z-ADD     12            WKS1MX            2 0
     C                   CLEAR                   DSDF10
      *
     C                   MOVEA     '01'          *IN(81)
     C                   WRITE     GL003100C1
     C                   MOVEA     '11'          *IN(81)
      *
      ** Initialise field for positioning.
      *
     C                   CLEAR                   SLRFNO
     C                   CLEAR                   SLFBRC
     C                   CLEAR                   SLFCNU
     C                   CLEAR                   SLCCY
     C                   CLEAR                   SLFACO
     C                   CLEAR                   SLFACS
     C                   CLEAR                   SLACNO
      *
      ** (Page Down)
      *
     C                   SELECT
     C     *IN01         WHENEQ    *ON
     C                   MOVE      WKEKEY        DSDF10
     C                   EXSR      XPSLAC
     C                   EXSR      XSSLAC
      *
     C     *IN22         IFEQ      *ON
     C                   CLEAR                   WKSKEY
     C                   ELSE
     C                   MOVE      DSDF10        WKSKEY
     C                   ENDIF
      *
      ** (Page Up)
      *
     C     *IN02         WHENEQ    *ON
     C                   MOVE      WKSKEY        DSDF10
     C                   EXSR      XPSLAC
      *
     C                   DO        WKS1MX
     C                   MOVE      'P'           WKREAD            1
     C                   EXSR      XSSLAC
      *
     C     *IN22         IFEQ      *ON
     C                   CLEAR                   WKSKEY
     C                   LEAVE
     C                   ENDIF
      *
     C                   MOVE      DSDF10        WKSKEY
     C                   ENDDO
      *
      ** Positioning - Reference Number.
      *
     C     SCPOS1        WHENNE    *BLANKS
     C                   MOVEL     SCPOS1        SLRFNO
     C                   MOVEL     SCPOS2        SLGLKY
     C                   MOVE      DSDF10        WKSKEY
      *
      ** Positioning - GL Account.
      *
     C     SCPOS2        WHENNE    *BLANKS
     C                   MOVEL     SCPOS2        SLGLKY
     C                   MOVE      DSDF10        WKSKEY
      *
      ** Positioning - Retail Number.
      *
     C     SCPOS3        WHENNE    *BLANKS
     C                   MOVEL     SCPOS3        SLACNO
     C                   MOVE      DSDF10        WKSKEY
      *
     C                   ENDSL
      *
      ** Clear Positioning Fields.
      *
     C                   CLEAR                   SCPOS1
     C                   CLEAR                   SCPOS2
     C                   CLEAR                   SCPOS3
      *
      ** Position File to Start Key.
      *
     C                   MOVE      WKSKEY        DSDF10
     C                   EXSR      XPSLAC
      *
      ** Set subfile with the next group of records.
      ** i.e. Read the Sel Accs and for each Reference
      ** - write details to the subfile
      *
     C                   DO        WKS1MX        SCRRN1
     C                   EXSR      XSSLAC
      *
     C     *IN22         IFEQ      *ON
     C                   LEAVE
     C                   ENDIF
      *
     C                   MOVE      *BLANKS       S1OPTN
     C                   MOVE      SLRFNO        S1RFNO
      *
     C                   SELECT
     C     SLSTAT        WHENEQ    'CP'
     C                   MOVEL     C@STCP        S1STAT
      *
     C     SLSTAT        WHENEQ    'CR'
     C                   MOVEL     C@STCR        S1STAT
      *
     C     SLSTAT        WHENEQ    'FA'
     C                   MOVEL     C@STFA        S1STAT
      *
     C     SLSTAT        WHENEQ    'DL'
     C                   MOVEL     C@STDL        S1STAT
      *
     C     SLSTAT        WHENEQ    'DU'
     C                   MOVEL     C@STDU        S1STAT
      *
     C     SLSTAT        WHENEQ    'RV'
     C                   MOVEL     C@STRV        S1STAT
      *
     C     SLSTAT        WHENEQ    'RC'
     C                   MOVEL     C@STRC        S1STAT
      *
     C                   OTHER
     C                   MOVE      *BLANKS       S1STAT
     C                   ENDSL
      *
     C                   MOVEL     SLFBRC        S1BRCA
     C                   MOVEL     SLFCNU        S1CUST
     C                   MOVEL     SLCCY         S1CCY
     C                   MOVEL     SLFACO        S1ACOD
     C                   MOVEL     SLFACS        S1ACSQ
     C                   MOVEL     SLACNO        S1ACNO
     C                   MOVEL     SLTBRC        S1TBRC
     C                   MOVEL     SLTCNU        S1TCUS
     C                   MOVEL     SLTACO        S1TACO
     C                   MOVEL     SLTACS        S1TACS
      *
      ** Write Sub File.
      *
     C                   WRITE     GL003100S1
      *
      ** Position File to Start Key.
      *
     C     SCRRN1        IFEQ      1
     C                   MOVE      DSDF10        WKSKEY
     C                   MOVE      *OFF          *IN82
     C                   ENDIF
     C                   ENDDO
      *
      ** Evaluate if last record on file.
      *
     C     *IN22         IFEQ      *OFF
     C                   EXSR      XSSLAC
     C                   ENDIF
      *
     C     *IN22         IFEQ      *ON
     C                   MOVE      *OFF          *IN83
     C                   ELSE
     C                   MOVE      *ON           *IN83
     C                   ENDIF
     C                   MOVE      DSDF10        WKEKEY
      *
     C                   Z-ADD     1             SCRRN1
     C                   Z-ADD     0             WCOUNT           10 0
     C     *LOVAL        SETLL     GLSLACL4
     C                   READ      GLSLACL4
      *
     C                   DOW       NOT %EOF(GLSLACL4)
     C     SLSTAT        IFEQ      'CR'
     C                   ADD       1             WCOUNT
     C                   ENDIF
     C                   READ      GLSLACL4
     C                   ENDDO
     C                   EVAL      WCOUNT2 = %EDITC(WCOUNT:'J')
      *
      ** Display Screen
      *
     C                   WRITE     GL003100F1
     C                   WRITE     MSGCTL
     C                   WRITE     GL003100C1
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  XSDFD1 - Set Display Format - Detail Screen (D1).            *
      *                                                               *
      *  Called By: PFKPRM, PFKREF, PDFD1, XVDFD1, PDFS1, XVDFC1      *
      *                                                               *
      *  Calls:     XRBRCH, XRCUST, XRACOD, XRCCY, XRACO, XRCTR       *
      *                                                               *
      *****************************************************************
      *
     C     XSDFD1        BEGSR
      *
      ** Set Sel Accs Details.
      *
     C                   MOVE      *BLANKS       SCPOS1
     C                   MOVE      *BLANKS       SCPOS2
     C                   MOVE      *BLANKS       SCPOS3
     C                   MOVE      *BLANKS       S2BRNM
     C                   MOVE      *BLANKS       S2CCRN
     C                   MOVE      *BLANKS       S2ACCN
     C                   MOVE      *BLANKS       S2CYNM
     C                   MOVE      *BLANKS       S2ACON
     C                   MOVE      *BLANKS       S2CNNM
     C                   MOVE      *BLANKS       S2TBRN
     C                   MOVE      *BLANKS       S2TCRN
     C                   MOVE      *BLANKS       S2TACC
      *
      ** Set Branch Description
      *
     C     S2BRCA        IFNE      *BLANKS
     C                   MOVEL     S2BRCA        WKBRCH
     C                   EXSR      XRBRCH
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     A8BRNM        S2BRNM
     C                   ENDIF
     C                   ENDIF
      *
      ** Set Customer Description
      *
     C     S2CNU1        IFNE      *BLANKS
     C                   MOVEL     S2CNU1        WKCUS
     C                   EXSR      XRCUST
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     BBCRNM        S2CCRN
     C                   ENDIF
     C                   ENDIF
      *
      ** Set Account Code Description
      *
     C     S2ACO1        IFNE      *BLANKS
     C                   MOVEL     S2ACO1        WKACC
     C                   EXSR      XRACOD
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     A5ACCN        S2ACCN
     C                   MOVEL     A5ACTY        WKACTY            1
     C                   ENDIF
     C                   ENDIF
      *
      ** Set Currency Description
      *
     C     S2CCY         IFNE      *BLANKS
     C                   MOVEL     S2CCY         WKCUR
     C                   EXSR      XRCCY
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     A6CYNM        S2CYNM
     C                   ENDIF
     C                   ENDIF
      *
      ** Set Acccount Officer Description
      *
     C     S2ACOC        IFNE      *BLANKS
     C                   MOVEL     S2ACOC        WKACO
     C                   EXSR      XRACO
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     AZACON        S2ACON
     C                   ENDIF
     C                   ENDIF
      *
      ** Set Country Description
      *
     C     S2COLC        IFNE      *BLANKS
     C                   MOVEL     S2COLC        WKCTR
     C                   EXSR      XRCTR
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     A4CNNM        S2CNNM
     C                   ENDIF
     C                   ENDIF
      *
      ** Set To Branch Description
      *
     C     S2TBRC        IFNE      *BLANKS
     C                   MOVEL     S2TBRC        WKBRCH
     C                   EXSR      XRBRCH
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     A8BRNM        S2TBRN
     C                   ENDIF
     C                   ENDIF
      *
      ** Set To Customer Description
      *
     C     S2TCNU        IFNE      *BLANKS
     C                   MOVEL     S2TCNU        WKCUS
     C                   EXSR      XRCUST
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     BBCRNM        S2TCRN
     C                   ENDIF
     C                   ENDIF
      *
      ** Set To Account Code Description
      *
     C     S2TACO        IFNE      *BLANKS
     C                   MOVEL     S2TACO        WKACC
     C                   EXSR      XRACOD
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     A5ACCN        S2TACC
     C                   ENDIF
     C                   ENDIF
      *
      ** Display Detail Screen.
      *
     C                   WRITE     GL003100F2
     C                   WRITE     MSGCTL
     C                   WRITE     GL003100D1
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  XSSLAC - Retrieve Selected Details to load Subfile.          *
      *                                                               *
      *  Called By: XSDFS1                                            *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
      *
     C     XSSLAC        BEGSR
      *
     C                   SELECT
     C     WKPOSN        WHENEQ    'SCPOS2'
     C     WKREAD        IFEQ      'P'
     C                   READP     GLSLACL1                             2122
     C                   ELSE
     C                   READ      GLSLACL1                             2122
     C                   ENDIF
      *
     C     WKPOSN        WHENEQ    'SCPOS3'
     C     WKREAD        IFEQ      'P'
     C                   READP     GLSLACL2                             2122
     C                   ELSE
     C                   READ      GLSLACL2                             2122
     C                   ENDIF
      *
     C                   OTHER
     C     WKREAD        IFEQ      'P'
     C                   READP     GLSLACL0                             2122
     C                   ELSE
     C                   READ      GLSLACL0                             2122
     C                   ENDIF
      *
     C                   ENDSL
      *
     C     *IN21         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     'GLSLACPD'    DBFILE
     C     WKPOSN        CAT       WKREAD:1      DBKEY
     C                   Z-ADD     010           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVE      *BLANKS       WKREAD
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  XPSLAC - Position Key.                                       *
      *                                                               *
      *  Called By: XSDFS1                                            *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
      *
     C     XPSLAC        BEGSR
      *
     C                   SELECT
      *
     C     WKPOSN        WHENEQ    'SCPOS2'
     C     KSLA1         SETLL     GLSLACL1
      *
     C     WKPOSN        WHENEQ    'SCPOS3'
     C     KSLA2         SETLL     GLSLACL2
      *
     C                   OTHER
     C     KSLAC         SETLL     GLSLACPD
     C     KSLA0         SETLL     GLSLACL0
     C                   ENDSL
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  XCPMSQ - Clear Program Message Queue.                        *
      *                                                               *
      *  Called By: Main Processing, PFKREF, PFKPRV, PDFD1, PDFS1     *
      *             XVDFC1                                            *
      *                                                               *
      *  Calls:     Y2CLMSC                                           *
      *                                                               *
      *****************************************************************
      *
     C     XCPMSQ        BEGSR
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      W@PGMN        WKPGMQ           10
     C                   PARM      '*SAME'       WKPGRL            5
      *
     C                   MOVEA     '00000000'    *IN(40)
     C                   MOVEA     '000'         *IN(48)
     C                   MOVEA     '00000000'    *IN(54)
     C                   MOVEA     '00000'       *IN(62)
     C                   MOVEA     '00000000'    *IN(70)
     C                   MOVEA     '000'         *IN(78)
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  XRSLAC - Retrieve Selected Account Details                   *
      *                                                               *
      *  Called By: PFKREF, PDFD1, PDFS1, XVDFC1                      *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
      *
     C     XRSLAC        BEGSR
      *
     C     KSLAC         CHAIN     GLSLACPD                           2021
      *
     C     *IN21         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     'GLSLACPD'    DBFILE
     C                   MOVEL     'KSLAC'       DBKEY
     C                   Z-ADD     020           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  XRACCT - Retrieve/Select Account Details                     *
      *                                                               *
      *  Called By: PDFD1                                             *
      *                                                               *
      *  Calls:     AOACCTR0                                          *
      *                                                               *
      *****************************************************************
      *
     C     XRACCT        BEGSR
      *
      ** Retrieve Account Details.
      *
     C                   CALL      'AOACCTR0'                           21
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM                    @RETL            10
     C                   PARM                    @CNUM             6
     C                   PARM                    @CUCD             3
     C                   PARM                    @ACCD            10
     C                   PARM                    @ACSQ             2
     C                   PARM                    @BRCA             3
     C     SDACCT        PARM      SDACCT        DSSDY
      *
     C     *IN21         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     'ACCNTAB'     DBFILE
     C                   MOVEL     SDACCT        DBKEY
     C                   Z-ADD     030           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  XRBRCH - Retrieve/Select Branch Code.                        *
      *                                                               *
      *  Called By: PFKPRM, XVDFD1, XSDFD1                            *
      *                                                               *
      *  Calls:     AOBRCHR0                                          *
      *                                                               *
      *****************************************************************
      *
     C     XRBRCH        BEGSR
      *
      ** Retrieve/Select Branch Code. If the Branch Code field
      ** contains a ? then a selection list is displayed.
      *
     C                   CALL      'AOBRCHR0'                           21
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      WKBRCH        WKBRCH
     C     SDBRCH        PARM      SDBRCH        DSFDY
      *
     C     *IN21         IFEQ      *ON
     C     @RTCD         ORNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBRCHPD'    DBFILE
     C                   MOVEL     SDBRCH        DBKEY
     C                   Z-ADD     040           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  XRCUST - Retrieve/Select Customer Code                       *
      *                                                               *
      *  Called By: PFKPRM, XVDFD1, XSDFD1                            *
      *                                                               *
      *  Calls:     AOCUSTR0                                          *
      *                                                               *
      *****************************************************************
      *
     C     XRCUST        BEGSR
      *
      ** Retrieve/Select Customer. If the Customer field
      ** contains a ? then a selection list is displayed.
      *
     C                   CALL      'AOCUSTR0'                           21
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      WKCUS         WKCUS            10
     C                   PARM                    @KYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C     *IN21         IFEQ      *ON
     C     @RTCD         ORNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCUSTPD'    DBFILE
     C                   MOVEL     SDCUST        DBKEY
     C                   Z-ADD     050           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  XRCCY - Retrieve/Select Currency Code.                       *
      *                                                               *
      *  Called By: XSDFD1                                            *
      *                                                               *
      *  Calls:     AOCURRR0                                          *
      *                                                               *
      *****************************************************************
      *
     C     XRCCY         BEGSR
      *
      ** Retrieve/Select Currency Code. If the Currency Code field
      ** contains a ? then a selection list is displayed.
      *
     C                   CALL      'AOCURRR0'                           21
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      WKCUR         WKCUR
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     *IN21         IFEQ      *ON
     C     @RTCD         ORNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     SDCURR        DBKEY
     C                   Z-ADD     060           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  XRACOD - Retrieve/Select Account Code.                       *
      *                                                               *
      *  Called By: PFKPRM, XVDFD1, XSDFD1                            *
      *                                                               *
      *  Calls:     AOACODR0                                          *
      *                                                               *
      *****************************************************************
      *
     C     XRACOD        BEGSR
      *
     C                   CALL      'AOACODR0'                           21
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      WKACC         WKACC
     C     SDACOD        PARM      SDACOD        DSSDY
      *
     C     *IN21         IFEQ      *ON
     C     @RTCD         ORNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDACODPD'    DBFILE
     C                   MOVEL     SDACOD        DBKEY
     C                   Z-ADD     070           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  XRACO - Retrieve/Select Account Officer                      *
      *                                                               *
      *  Called By: XSDFD1                                            *
      *                                                               *
      *  Calls:     AOACOFR0                                          *
      *                                                               *
      *****************************************************************
      *
     C     XRACO         BEGSR
      *
      ** Retrieve/Select Account Officer. If the Account Officer field
      ** contains a ? then a selection list is displayed.
      *
     C                   CALL      'AOACOFR0'                           21
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      WKACO         WKACO
     C     SDACOF        PARM      SDACOF        DSFDY
      *
     C     *IN21         IFEQ      *ON
     C     @RTCD         ORNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDACOFPD'    DBFILE
     C                   MOVEL     SDACOF        DBKEY
     C                   Z-ADD     080           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  XRCTR - Retrieve/Select Country Code.                        *
      *                                                               *
      *  Called By: XSDFD1                                            *
      *                                                               *
      *  Calls:     AOCTRYR0                                          *
      *                                                               *
      *****************************************************************
      *
     C     XRCTR         BEGSR
      *
      ** Retrieve/Select Country Code. If the Country Code field
      ** contains a ? then a selection list is displayed.
      *
     C                   CALL      'AOCTRYR0'                           21
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      WKCTR         WKCTR
     C     SDCTRY        PARM      SDCTRY        DSFDY
      *
     C     *IN21         IFEQ      *ON
     C     @RTCD         ORNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCTRYPD'    DBFILE
     C                   MOVEL     SDCTRY        DBKEY
     C                   Z-ADD     090           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  XUSLAC - Update Sel Accs Details                             *
      *                                                               *
      *  Called By: PDFD1                                             *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
      *
     C     XUSLAC        BEGSR
      *
     C                   UPDATE    GLSLACD0                             21
      *
     C     *IN21         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     'GLSLACPD'    DBFILE
     C                   MOVEL     'UPDATE'      DBKEY
     C                   Z-ADD     100           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  XDSLAC - Delete Selected Account Details                     *
      *                                                               *
      *  Called By: PDFD1                                             *
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
     C                   MOVEL     'DELETE'      DBKEY
     C                   Z-ADD     110           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  XSPMSQ - Send Messages to Program Message Queue.             *
      *                                                               *
      *  Called By: PDFC1, PDFD1, XVDFD1, PDFS1, XVDFC1               *
      *                                                               *
      *  Calls:     Y2SNMGC                                           *
      *                                                               *
      *****************************************************************
      *
     C     XSPMSQ        BEGSR
      *
     C                   CALL      'Y2SNMGC'
     C                   PARM                    WKPGMQ           10
     C                   PARM      *BLANKS       WKPGRL            5
     C                   PARM                    WKMSID            7
     C                   PARM      'GLUSRMSG'    WKMSGF           10
     C                   PARM      *BLANKS       WKMSDA          132
     C                   PARM      *BLANKS       WKMSTP            7
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initial Routine.                                    *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls:     AOBANKR0                                          *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *DTAARA       DEFINE                  LDA
      *
     C     *LIKE         DEFINE    SLSTAT        WKSTAT
     C     *LIKE         DEFINE    S1OPTN        WKOPTN
     C     *LIKE         DEFINE    S2BRCA        WKBRCH
     C     *LIKE         DEFINE    S2CCY         WKCUR
     C     *LIKE         DEFINE    S2ACO1        WKACC
     C     *LIKE         DEFINE    S2ACOC        WKACO
     C     *LIKE         DEFINE    S2COLC        WKCTR
     C     *LIKE         DEFINE    S2TBRC        WKBRC
     C     *LIKE         DEFINE    S2TBRC        KBRCA
     C     *LIKE         DEFINE    S2CCY         KCCY
     C     *LIKE         DEFINE    S2TACO        KACOD
     C     *LIKE         DEFINE    S2TCNU        KCUSN
     C     *LIKE         DEFINE    S2TACS        KACSQ
     C     *LIKE         DEFINE    SLSTAT        KSTAT
      *
      ** Key Lists.
      *
     C     KSLAC         KLIST
     C                   KFLD                    SLRFNO
     C                   KFLD                    S1BRCA
     C                   KFLD                    S1CUST
     C                   KFLD                    S1CCY
     C                   KFLD                    S1ACOD
     C                   KFLD                    S1ACSQ
      *
     C     KSLA0         KLIST
     C                   KFLD                    SLRFNO
     C                   KFLD                    SLFBRC
     C                   KFLD                    SLFCNU
     C                   KFLD                    SLCCY
     C                   KFLD                    SLFACO
     C                   KFLD                    SLFACS
      *
     C     KSLA1         KLIST
     C                   KFLD                    SLFBRC
     C                   KFLD                    SLFCNU
     C                   KFLD                    SLCCY
     C                   KFLD                    SLFACO
     C                   KFLD                    SLFACS
     C                   KFLD                    SLRFNO
      *
     C     KSLA2         KLIST
     C                   KFLD                    SLACNO
      *
     C     KSLA3         KLIST
     C                   KFLD                    KBRCA
     C                   KFLD                    KCUSN
     C                   KFLD                    KCCY
     C                   KFLD                    KACOD
     C                   KFLD                    KACSQ
      *
     C     KSLA5         KLIST
     C                   KFLD                    KBRCA
     C                   KFLD                    KCUSN
     C                   KFLD                    KCCY
     C                   KFLD                    KACOD
     C                   KFLD                    KACSQ
     C                   KFLD                    KSTAT
      *
     C                   MOVEL     'GL003100'    W@PGMN           10
     C     *LOCK         IN        LDA
     C                   CLEAR                   LDA
     C                   MOVEL     W@PGMN        DBPGM
     C                   OUT       LDA
      *
      ** Retrieve Run Date.
      *
     C                   CALL      'AOBANKR0'                           9090
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      *BLANKS       DSFDY
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
     C                   Z-ADD     120           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVE      BJMRDT        SCDATE
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
     C                   MOVE      *ON           *IN10
     C                   MOVE      WSID          SCWSID
     C                   MOVE      USER          SCUSER
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
     C                   CALL      'DBERRCTL'
     C                   END
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
