     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Account Transfer Criteria Maintenance')       *
      *****************************************************************
      *                                                               *
      *  Midas     -  General Ledger Module                           *
      *                                                               *
      *  GL019000  -  Midas GL Account Transfer Criteria Maintenance  *
      *                                                               *
      *  Function:  This program enables the creation of Account      *
      *             Transfer Criteria which are used to generate      *
      *             accounts for transfer details.                    *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD040242A          Date 02Sep16               *
      *                 MD040242           Date 09Sep16               *
      *                 CRE075             Date 06Dec10               *
      *                 BUG27769           Date 09Jun10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG27219           Date 16Mar10               *
      *                 239243             Date 04Jan10               *
      *                 239121             Date 04Jan10               *
      *                 238581             Date 04Jan10               *
      *                 238380             Date 04Jan10               *
      *                 CGL114  *CREATE    Date 04Jan10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD040242A - Send error message when no account exists for    *
      *              entered selection criteria.                      *
      *            - Applied for MD040318A.                           *
      *  MD040242 - Reference does not appear in 'Selected Account    *
      *             Maintenance'. Add check to make sure at least     *
      *             one account exists.                               *
      *            - Applied for MD040318.                            *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  BUG27769 - Incorrect error code                              *
      *  BUG27219- Format for message IDs in GBGLUSRMSG are for       *
      *            non-core                                           *
      *  239243 - DB error on the second access to ATCM due to lock.  *
      *  239121 - Account Codes and Account Type must all match.      *
      *  238581 - Closed Retail Account should not be allowed to be   *
      *           transferred.                                        *
      *  238380 - Account Codes should not be Title Only              *
      *  CGL114 - Account Transfer Utility                            *
      *                                                               *
      *****************************************************************
      *  Indicator    Description                                     *
      *  ---------    -----------                                     *
      *                                                               *
      *  01 / 02      Roll Up/Down Summary Screen (GL019000S1)        *
      *  10           SFLEND for message file                         *
      *  11           SFLNXTCHG for subfile GL019000S1                *
      *                                                               *
      *  20           Record Not Found                                *
      *  21           File Error Occurred                             *
      *  22           Start/End Of File Reached                       *
      *  25           DEM Payment to Look-up                          *
      *                                                               *
      *  69           Reversal Option entered on GL019000S1 screen    *
      *  70           Invalid Option entered on GL019000S1 screen     *
      *  71           Invalid Option entered on GL019000C1 screen     *
      *  72           Invalid Customer Number entered                 *
      *                                                               *
      *  81           SFLDSPCTL for subfile GL019000S1                *
      *  82           SFLCLR       "                                  *
      *  82           SFLDSP       "                                  *
      *  82           ERASE        "                                  *
      *  83           SFLEND       "                                  *
      *                                                               *
      *  U7           Program Error                                   *
      *                                                               *
      *   Routine      Description                                    *
      *   -------      -----------                                    *
      *                                                               *
      *  PFKEXT       Process Function Key 03 (Exit)                  *
      *  PFKPRM       Process Function Key 04 (Prompt)                *
      *  PFKREF       Process Function Key 05 (Refresh)               *
      *  PFKPRV       Process Function Key 12 (Previous Screen)       *
      *                                                               *
      *  PDFC1        Process Display Format - Subfile Control (C1)   *
      *  PDFS1        Process Display Format - Subfile (S1)           *
      *  PDFD1        Process Display Format - Detail (D1)            *
      *  XSDFS1       Set Display Format - Subfile (S1)               *
      *  XSDFD1       Set Display Format - Detail (D1)                *
      *  XVDFC1       Validate Display Format - Subfile Control (C1)  *
      *  XVDFD1       Validate Display Format - Detail Screen (D1)    *
      *                                                               *
      *  XRACRF       Retrieve Criteria Details                       *
      *  XRACO        Retrieve Account Officer Details                *
      *  XRACOD       Retrieve Account Code Details                   *
      *  XRBRCH       Retrieve Branch Details                         *
      *  XRCCY        Retrieve Currency Details                       *
      *  XRCTR        Retrieve Country Details                        *
      *  XRCUST       Retrieve Customer Details                       *
      *  XUSLAC       Reverse Selected Accounts Records               *
      *                                                               *
      *  XCPMSQ       Clear Messages from Program Message Queue       *
      *  XSPMSQ       Send Messages to Program Message Queue          *
      *                                                               *
      *  *INZSR       Initial Routine                                 *
      *  @DEFN        Definitions, key lists, etc....                 *
      *  *PSSR        Error Handling Routine                          *
      *****************************************************************
     F/EJECT
 
     FGL019000DFCF   E             WORKSTN INFSR(*PSSR)
     F                                     INFDS(D@WKS)
     F                                     SFILE(GL019000S1:SCRRN1)
 
     FGLACRFPD  UF A E           K DISK                                                       239243
     F                                     INFDS(INFDS1)                                      239243
 
     FGLACRFL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLACRFD0:ACRF0)
 
     FACNUM     IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ACCNTABF:ACNUMABF)
 
     FGLACNTL6  IF   E           K DISK    INFSR(*PSSR)                                     MD040242
                                                                                            MD040242
     D/SPACE 5
 
     D ATY             S              1    DIM(6) CTDATA PERRCD(6)
 
     D/EJECT
 
     D D@PGM         ESDS                  EXTNAME(D@PGM)
 
      ** Program Information Area.
 
     D D@WKS         E DS                  EXTNAME(D@WKS)
 
      ** Workstation Device Feedback.
 
     D LDA           E DS           256    EXTNAME(LDA)
 
      ** First DS for Access Programs, short data structure
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Access Object Data Feedback.
 
      ** Second DS for Access Programs, long data structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Definition: Bank Details accessed via access program.
 
      ** Branch Details
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** Currency Details
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Account Code Details
 
     D SDACOD        E DS                  EXTNAME(SDACODPD)
 
     D SDACCT        E DS                  EXTNAME(ACCNTAB)                                   238581
     D  W#ATYP       E                     EXTFLD(ATYP)                                       238581
     D  W#ACST       E                     EXTFLD(ACST)                                       238581
 
      ** Definition: Account Details accessed via access program.                             238581
 
      ** Country Details
 
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
 
      ** Account Officer
 
     D SDACOF        E DS                  EXTNAME(SDACOFPD)
 
      ** Customer Details
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D QQDFAC1       E                     EXTFLD(QQDFAC)
 
     D INFDS1        E DS                  EXTNAME(Y2IUDSP)                                   239243
                                                                                              239243
      ** File information data structure                                                      239243
 
     D DSDF10          DS            36
 
      ** Datastructure: Key List of Position File (GLACRFL0)
 
     D  ACRFNO                 1     10
 
     D WKSKEY          DS            36
 
      ** Datastructure: Subfile Start Key
 
     D  WKSRFN                 1     10
 
     D WKEKEY          DS            36
 
      ** Datastructure: Subfile End Key
 
     D  WKERFN                 1     10
 
     DDSPARM           DS            65                                                    MD040242A
     D DSBRCA                  1      3                                                    MD040242A
     D DSCNU1                  4      9                                                    MD040242A
     D DSCNU2                 10     15                                                    MD040242A
     D DSCCY                  16     18                                                    MD040242A
     D DSACO1                 19     28                                                    MD040242A
     D DSACO2                 29     38                                                    MD040242A
     D DSACSQ                 39     40                                                    MD040242A
     D DSACN1                 41     50                                                    MD040242A
     D DSACN2                 51     60                                                    MD040242A
     D DSACOC                 61     62                                                    MD040242A
     D DSATYP                 63     63                                                    MD040242A
     D DSCOLC                 64     65                                                    MD040242A
                                                                                           MD040242A
      ** Named Constants
 
     D C@NUMR          C                   CONST('1234567890 ')
     D C@STCP          C                   CONST('Complete   ')
     D C@STCR          C                   CONST('Created    ')
     D C@STPC          C                   CONST('Partial    ')
     D C@STDL          C                   CONST('Deleted    ')
     D C@STRC          C                   CONST('Rev/Crt    ')
     D C@STRV          C                   CONST('Reversed   ')
     D C@STRP          C                   CONST('Rev/Part   ')
 
     C/EJECT
      *****************************************************************
      *                                                               *
      ** Main Processing Control.                                     *
      *                                                               *
      *****************************************************************
 
     C     *INLR         DOWEQ     '0'
 
     C                   EXSR      XCPMSQ
 
     C     *INKC         CASEQ     *ON           PFKEXT
     C     *INKD         CASEQ     *ON           PFKPRM
     C     *INKE         CASEQ     *ON           PFKREF
     C     *INKL         CASEQ     *ON           PFKPRV
     C     D@FMTN        CASEQ     'GL019000C1'  PDFC1
     C     D@FMTN        CASEQ     'GL019000D1'  PDFD1
     C                   CAS                     XSDFS1
     C                   ENDCS
     C  NLR              READ      GL019000DF                             LR
     C                   ENDDO
 
     C/EJECT
      *****************************************************************
      *                                                               *
      *  PFKEXT: Process Function Key 3 - Exit                        *
      *                                                               *
      *****************************************************************
     C     PFKEXT        BEGSR
 
     C                   MOVE      *ON           *INLR
 
     C                   ENDSR
     C/SPACE 5
      *****************************************************************
      *                                                               *
      *  PFKPRM: Process Function Key 4 - Prompt                      *
      *                                                               *
      *****************************************************************
     C     PFKPRM        BEGSR
 
     C                   Z-ADD     *ZERO         WKERR
     C                   CLEAR                   WKLINE
     C                   CLEAR                   WKCOLM
     C     D@CRSR        DIV       256           WKLINE            2 0
     C                   MVR                     WKCOLM            2 0
 
      ** Detail Screen
 
     C                   MOVEA     '00000000'    *IN(40)
     C                   MOVEA     '000'         *IN(48)
     C                   MOVEA     '00000000'    *IN(54)
     C                   MOVEA     '00000'       *IN(62)
     C                   MOVEA     '00'          *IN(73)
     C                   MOVEA     '000'         *IN(78)
     C                   MOVE      *BLANKS       WKMSID
 
      ** If Branch Code prompted , call selection screen
 
     C     WKLINE        IFEQ      08
     C     WKCOLM        ANDGE     37
     C     WKCOLM        ANDLE     39
     C                   MOVEL     '?      '     WKBRCH
 
     C                   EXSR      XRBRCH
 
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     WKBRCH        S2BRCA
     C                   ENDIF
     C                   MOVEL     '1'           *IN40
     C                   ENDIF
 
      ** If Customer1 prompted, call selection screen
 
     C     WKLINE        IFEQ      09
     C     WKCOLM        ANDGE     37
     C     WKCOLM        ANDLE     42
     C                   MOVEL     '?      '     WKCUS
 
     C                   EXSR      XRCUST
 
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     WKCUS         S2CNU1
     C                   ENDIF
     C                   MOVEL     '1'           *IN41
     C                   ENDIF
 
      ** If Customer2 prompted, call selection screen
 
     C     WKLINE        IFEQ      09
     C     WKCOLM        ANDGE     45
     C     WKCOLM        ANDLE     51
     C                   MOVEL     '?      '     WKCUS
 
     C                   EXSR      XRCUST
 
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     WKCUS         S2CNU2
     C                   ENDIF
     C                   MOVEL     '1'           *IN42
     C                   ENDIF
 
      ** If Currency prompted, call selection screen
 
     C     WKLINE        IFEQ      10
     C     WKCOLM        ANDGE     37
     C     WKCOLM        ANDLE     39
     C                   MOVEL     '?      '     WKCUR
 
     C                   EXSR      XRCCY
 
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     WKCUR         S2CCY
     C                   ENDIF
     C                   MOVEL     '1'           *IN43
     C                   ENDIF
 
      ** If Account Code 1 prompted, call selection screen
 
     C     WKLINE        IFEQ      11
     C     WKCOLM        ANDGE     37
     C     WKCOLM        ANDLE     40
     C                   MOVEL     '?      '     WKACC
 
     C                   EXSR      XRACOD
 
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     WKACC         S2ACO1
     C                   ENDIF
     C                   MOVEL     '1'           *IN44
     C                   ENDIF
 
      ** If Account Code 2 prompted, call selection screen
 
     C     WKLINE        IFEQ      11
     C     WKCOLM        ANDGE     44
     C     WKCOLM        ANDLE     47
     C                   MOVEL     '?      '     WKACC
 
     C                   EXSR      XRACOD
 
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     WKACC         S2ACO2
     C                   ENDIF
     C                   MOVEL     '1'           *IN45
     C                   ENDIF
 
      ** If Account Officer, call selection screen
 
     C     WKLINE        IFEQ      14
     C     WKCOLM        ANDGE     37
     C     WKCOLM        ANDLE     38
     C                   MOVEL     '?      '     WKACO
 
     C                   EXSR      XRACO
 
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     WKACO         S2ACOC
     C                   ENDIF
     C                   MOVEL     '1'           *IN46
     C                   ENDIF
 
      ** If Country Code, call selection screen
 
     C     WKLINE        IFEQ      16
     C     WKCOLM        ANDGE     37
     C     WKCOLM        ANDLE     38
     C                   MOVEL     '?      '     WKCTR
 
     C                   EXSR      XRCTR
 
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     WKCTR         S2COLC
     C                   ENDIF
     C                   MOVEL     '1'           *IN47
     C                   ENDIF
 
      ** If To Branch Code prompted, call selection screen
 
     C     WKLINE        IFEQ      18
     C     WKCOLM        ANDGE     37
     C     WKCOLM        ANDLE     39
     C                   MOVEL     '?      '     WKBRCH
 
     C                   EXSR      XRBRCH
 
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     WKBRC         S2TBRC
     C                   ENDIF
     C                   MOVEL     '1'           *IN48
     C                   ENDIF
 
      ** If To Customer prompted, call selection screen
 
     C     WKLINE        IFEQ      19
     C     WKCOLM        ANDGE     37
     C     WKCOLM        ANDLE     42
     C                   MOVEL     '?      '     WKCUS
 
     C                   EXSR      XRCUST
 
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     WKCUS         S2TCNU
     C                   ENDIF
     C                   MOVEL     '1'           *IN49
     C                   ENDIF
 
      ** If To Acc Code prompted, call selection screen
 
     C     WKLINE        IFEQ      20
     C     WKCOLM        ANDGE     37
     C     WKCOLM        ANDLE     40
     C                   MOVEL     '?      '     WKACC
 
     C                   EXSR      XRACOD
 
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     WKACC         S2TACO
     C                   ENDIF
     C                   MOVEL     '1'           *IN50
     C                   ENDIF
 
     C                   EXSR      XSDFD1
 
     C                   ENDSR
     C/SPACE 5
      *****************************************************************
      *                                                               *
      *  PFKREF: Process Function Key 5 - Refresh Screen              *
      *                                                               *
      *****************************************************************
     C     PFKREF        BEGSR
 
     C                   EXSR      XCPMSQ
 
     C                   SELECT
     C     WKOPTN        WHENEQ    'A '
     C     WKOPTN        OREQ      ' A'
     C                   MOVE      WKOPTN        SCOPTN                                       239243
 
     C                   EXSR      XRACRF
 
     C                   MOVEL     ACRFNO        S2RFNO
     C                   MOVEL     ACDESC        S2DESC
     C                   MOVE      ACBRCA        S2BRCA
     C                   MOVE      ACCNU1        S2CNU1
     C                   MOVE      ACCNU2        S2CNU2
     C                   MOVE      ACCCY         S2CCY
     C                   MOVE      ACACO1        S2ACO1
     C                   MOVE      ACACO2        S2ACO2
     C                   MOVE      ACACSQ        S2ACSQ
     C                   MOVE      ACACN1        S2ACN1
     C                   MOVE      ACACN2        S2ACN2
     C                   MOVE      ACACOC        S2ACOC
     C                   MOVE      ACATYP        S2ATYP
     C                   MOVE      ACCOLC        S2COLC
     C                   MOVE      ACTBRC        S2TBRC
     C                   MOVE      ACTCNU        S2TCNU
     C                   MOVE      ACTACO        S2TACO
     C                   MOVE      ACTACS        S2TACS
 
     C                   EXSR      XCPMSQ
 
     C                   MOVEA     '1'           *IN(76)
 
     C                   EXSR      XSDFD1
 
     C                   MOVE      *BLANKS       SCOPTN
     C     WKOPTN        WHENEQ    'I'
     C     WKOPTN        OREQ      ' I'                                                       239243
     C                   MOVE      WKOPTN        SCOPTN                                       239243
 
     C                   EXSR      XRACRF
 
     C     *IN20         IFEQ      *OFF
      **********         MOVEL     'XX00031'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0031'     WKMSID                                     BUG27219
 
     C                   EXSR      XSPMSQ
 
     C                   ADD       1             WKERR
     C                   MOVEA     '11'          *IN(54)
     C                   ELSE
     C                   MOVEL     *BLANKS       S2DESC
     C                   MOVE      *BLANKS       S2BRCA
     C                   MOVE      *BLANKS       S2CNU1
     C                   MOVE      *BLANKS       S2CNU2
     C                   MOVE      *BLANKS       S2CCY
     C                   MOVE      *BLANKS       S2ACO1
     C                   MOVE      *BLANKS       S2ACO2
     C                   MOVE      *BLANKS       S2ACSQ
     C                   MOVE      *BLANKS       S2ACN1
     C                   MOVE      *BLANKS       S2ACN2
     C                   MOVE      *BLANKS       S2ACOC
     C                   MOVE      *BLANKS       S2ATYP
     C                   MOVE      *BLANKS       S2COLC
     C                   MOVE      *BLANKS       S2TBRC
     C                   MOVE      *BLANKS       S2TCNU
     C                   MOVE      *BLANKS       S2TACO
     C                   MOVE      *BLANKS       S2TACS
 
     C                   EXSR      XCPMSQ
 
     C                   MOVE      '1'           *IN76
 
     C                   EXSR      XSDFD1
 
     C                   MOVE      *BLANKS       SCOPTN
     C                   ENDIF
     C                   ENDSL
 
     C                   ENDSR
     C/SPACE 5
      *****************************************************************
      *                                                               *
      *  PFKPRV: Process Function Key 12 - Previous Screen            *
      *                                                               *
      *****************************************************************
     C     PFKPRV        BEGSR
 
     C                   EXSR      XCPMSQ
 
     C                   WRITE     GL019000F1
     C                   WRITE     MSGCTL
     C                   WRITE     GL019000C1
 
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  PDFC1: Process Display Format - Subfile Control (C1)         *
      *                                                               *
      *****************************************************************
     C     PDFC1         BEGSR
 
     C                   SELECT
     C     SCOPTN        WHENNE    *BLANKS
     C     SCOPTN        IFEQ      'A '
     C     SCOPTN        OREQ      ' A'
     C     SCOPTN        OREQ      'D '
     C     SCOPTN        OREQ      ' D'
     C     SCOPTN        OREQ      'E '
     C     SCOPTN        OREQ      ' E'
     C     SCOPTN        OREQ      'I '
     C     SCOPTN        OREQ      ' I'
     C     SCOPTN        OREQ      'RE'
 
     C                   EXSR      XVDFC1
 
     C                   ELSE
     C                   MOVE      *ON           *IN71
     C                   ADD       1             WKERR
      **********         MOVEL     'XX00016'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0016'     WKMSID                                     BUG27219
 
     C                   EXSR      XSPMSQ
 
     C                   WRITE     GL019000F1
     C                   WRITE     MSGCTL
     C                   WRITE     GL019000C1
     C                   ENDIF
     C     SCPOS1        WHENNE    *BLANKS
 
     C                   EXSR      XVDFC1
 
     C     WKERR         IFEQ      *ZERO
 
     C                   EXSR      XSDFS1
 
     C                   ENDIF
     C     *IN01         WHENEQ    *ON
     C     *IN02         OREQ      *ON
 
     C                   EXSR      XSDFS1
 
     C     *IN82         WHENEQ    *OFF
 
     C                   EXSR      PDFS1
 
     C                   ENDSL
 
     C                   CLEAR                   WKERR
 
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  PDFD1: Process Display Format - Detail (D1)                  *
      *                                                               *
      *****************************************************************
     C     PDFD1         BEGSR
 
      ** Process Detail Screen.
 
     C                   MOVEA     '00000000'    *IN(54)
     C                   MOVEA     '00000'       *IN(62)
     C                   MOVEA     '00'          *IN(73)
     C                   MOVEA     '000'         *IN(78)
     C                   MOVE      *BLANKS       WKMSID
 
      ** If Amend or Insert, Validate Input
 
     C                   SELECT
     C     WKOPTN        WHENEQ    'A '
     C     WKOPTN        OREQ      ' A'
     C     WKOPTN        OREQ      'I '
     C     WKOPTN        OREQ      ' I'
 
     C                   EXSR      XVDFD1
 
     C                   ENDSL
 
      ** If Insert Write Details
 
     C     WKOPTN        IFEQ      'I '
     C     WKERR         ANDEQ     0
     C     WKOPTN        OREQ      ' I'
     C     WKERR         ANDEQ     0
     C                   MOVE      S2RFNO        ACRFNO
     C                   MOVE      *BLANKS       ACSTAT
     C                   MOVE      S2DESC        ACDESC
     C                   MOVE      S2BRCA        ACBRCA
     C                   MOVE      S2CNU1        ACCNU1
     C                   MOVE      S2CNU2        ACCNU2
     C                   MOVE      S2CCY         ACCCY
     C                   MOVE      S2ACO1        ACACO1
     C                   MOVE      S2ACO2        ACACO2
     C                   MOVE      S2ACSQ        ACACSQ
     C                   MOVE      S2ACN1        ACACN1
     C                   MOVE      S2ACN2        ACACN2
     C                   MOVE      S2ACOC        ACACOC
     C                   MOVE      S2ATYP        ACATYP
     C                   MOVE      S2COLC        ACCOLC
     C                   MOVE      S2TBRC        ACTBRC
     C                   MOVE      S2TCNU        ACTCNU
     C                   MOVE      S2TACO        ACTACO
     C                   MOVE      S2TACS        ACTACS
     C                   MOVE      WKDFMT        ACCRTD
     C                   MOVE      *BLANKS       ACPRCD
     C                   MOVE      *BLANKS       WKOPTN
 
     C                   EXSR      XWACRF
      *
     C                   EXSR      XWSLAC
      *
     C                   ENDIF
 
      ** If Amend Update Details
 
     C     WKOPTN        IFEQ      'A '
     C     WKERR         ANDEQ     0
     C     WKOPTN        OREQ      ' A'
     C     WKERR         ANDEQ     0
     C                   MOVE      S2RFNO        ACRFNO
     C                   MOVE      S2DESC        ACDESC
     C                   MOVE      S2BRCA        ACBRCA
     C                   MOVE      S2CNU1        ACCNU1
     C                   MOVE      S2CNU2        ACCNU2
     C                   MOVE      S2CCY         ACCCY
     C                   MOVE      S2ACO1        ACACO1
     C                   MOVE      S2ACO2        ACACO2
     C                   MOVE      S2ACSQ        ACACSQ
     C                   MOVE      S2ACN1        ACACN1
     C                   MOVE      S2ACN2        ACACN2
     C                   MOVE      S2ACOC        ACACOC
     C                   MOVE      S2ATYP        ACATYP
     C                   MOVE      S2COLC        ACCOLC
     C                   MOVE      S2TBRC        ACTBRC
     C                   MOVE      S2TCNU        ACTCNU
     C                   MOVE      S2TACO        ACTACO
     C                   MOVE      S2TACS        ACTACS
     C                   MOVE      WKDFMT        ACCRTD
     C                   MOVE      *BLANKS       WKOPTN
 
     C                   EXSR      XUACRF
      *
     C                   EXSR      XDSLAC
      *
     C                   EXSR      XWSLAC
      *
     C                   ENDIF
 
      ** If Delete Remove Details
 
     C     WKOPTN        IFEQ      'D '
     C     WKOPTN        OREQ      ' D'
     C                   MOVE      *BLANKS       WKOPTN
     C     ACSTAT        IFEQ      'RC'
     C     ACSTAT        OREQ      'RP'
     C     ACPRCD        ANDEQ     *BLANKS
     C                   MOVE      'CP'          ACSTAT
     C                   MOVE      WKDFMT        ACPRCD
 
     C                   EXSR      XUACRF
 
     C                   ELSE
 
     C                   EXSR      XDACRF
 
     C                   ENDIF
      *
     C                   EXSR      XDSLAC
      *
     C                   ENDIF
 
      ** If Reverse, Reverse Details
 
     C     WKOPTN        IFEQ      'RE'
     C                   MOVE      *BLANKS       WKOPTN
     C                   MOVE      *BLANKS       ACPRCD
 
     C                   EXSR      XUACRF
 
     C                   EXSR      XUSLAC
 
     C                   ENDIF
 
      ** If there are options queued on the subfile,
      ** validate them, set screen data items and display detail screen.
      ** Otherwise, redisplay selection list.
 
     C     WKERR         IFEQ      0
     C     *IN22         IFEQ      *OFF
     C                   READC     GL019000S1                             22
     C                   ENDIF
 
     C     *IN22         DOWEQ     *OFF
     C     S1OPTN        ANDEQ     *BLANKS
     C                   MOVE      *OFF          *IN70
     C                   UPDATE    GL019000S1
     C                   READC     GL019000S1                             22
     C                   ENDDO
 
      ** For all records which have been selected with a valid option,
      ** set screen data items and display the detail screen
      ** Otherwise, redisplay selection list.
 
     C                   SELECT
     C     *IN22         WHENEQ    *ON
 
     C                   EXSR      XSDFS1
 
     C     S1OPTN        WHENEQ    'E '
     C     S1OPTN        OREQ      ' E'
     C                   MOVE      S1OPTN        WKOPTN
     C                   MOVE      S1OPTN        SCOPTN                                       239243
     C                   MOVE      *BLANKS       S1OPTN
     C                   UPDATE    GL019000S1
     C                   MOVEL     S1RFNO        ACRFNO
 
     C                   EXSR      XRACRF
 
     C                   MOVEL     ACRFNO        S2RFNO
     C                   MOVEL     ACDESC        S2DESC
     C                   MOVE      ACBRCA        S2BRCA
     C                   MOVE      ACCNU1        S2CNU1
     C                   MOVE      ACCNU2        S2CNU2
     C                   MOVE      ACCCY         S2CCY
     C                   MOVE      ACACO1        S2ACO1
     C                   MOVE      ACACO2        S2ACO2
     C                   MOVE      ACACSQ        S2ACSQ
     C                   MOVE      ACACN1        S2ACN1
     C                   MOVE      ACACN2        S2ACN2
     C                   MOVE      ACACOC        S2ACOC
     C                   MOVE      ACATYP        S2ATYP
     C                   MOVE      ACCOLC        S2COLC
     C                   MOVE      ACTBRC        S2TBRC
     C                   MOVE      ACTCNU        S2TCNU
     C                   MOVE      ACTACO        S2TACO
     C                   MOVE      ACTACS        S2TACS
 
     C                   EXSR      XCPMSQ
 
     C                   MOVEA     '11'          *IN(76)
 
     C                   EXSR      XSDFD1
 
     C     S1OPTN        WHENEQ    'A '
     C     S1OPTN        OREQ      ' A'
     C                   MOVE      S1OPTN        SCOPTN                                       239243
     C                   MOVEL     S1RFNO        ACRFNO
 
     C                   EXSR      XRACRF
 
     C     ACPRCD        IFEQ      *BLANKS
     C     ACSTAT        ANDEQ     'CR'
     C     ACPRCD        OREQ      *BLANKS
     C     ACSTAT        ANDEQ     'PC'
     C                   MOVE      S1OPTN        WKOPTN
     C                   MOVE      *BLANKS       S1OPTN
     C                   UPDATE    GL019000S1
     C                   MOVEL     ACRFNO        S2RFNO
     C                   MOVEL     ACDESC        S2DESC
     C                   MOVE      ACBRCA        S2BRCA
     C                   MOVE      ACCNU1        S2CNU1
     C                   MOVE      ACCNU2        S2CNU2
     C                   MOVE      ACCCY         S2CCY
     C                   MOVE      ACACO1        S2ACO1
     C                   MOVE      ACACO2        S2ACO2
     C                   MOVE      ACACSQ        S2ACSQ
     C                   MOVE      ACACN1        S2ACN1
     C                   MOVE      ACACN2        S2ACN2
     C                   MOVE      ACACOC        S2ACOC
     C                   MOVE      ACATYP        S2ATYP
     C                   MOVE      ACCOLC        S2COLC
     C                   MOVE      ACTBRC        S2TBRC
     C                   MOVE      ACTCNU        S2TCNU
     C                   MOVE      ACTACO        S2TACO
     C                   MOVE      ACTACS        S2TACS
 
     C                   EXSR      XCPMSQ
 
     C                   MOVE      '1'           *IN76
 
     C                   EXSR      XSDFD1
 
     C                   ELSE
     C                   MOVE      *ON           *IN70
     C                   UPDATE    GL019000S1
      **********         MOVEL     'XX00010'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0010'     WKMSID                                     BUG27219
 
     C                   EXSR      XSPMSQ
 
     C                   ADD       1             WKERR
     C                   WRITE     GL019000F1
     C                   WRITE     MSGCTL
     C                   WRITE     GL019000C1
     C                   ENDIF
     C     S1OPTN        WHENEQ    'D '
     C     S1OPTN        OREQ      ' D'
     C                   MOVE      S1OPTN        SCOPTN                                       239243
     C                   MOVEL     S1RFNO        ACRFNO
 
     C                   EXSR      XRACRF
 
     C     ACPRCD        IFEQ      *BLANKS
     C     ACSTAT        ANDEQ     'CR'
     C     ACPRCD        OREQ      *BLANKS
     C     ACSTAT        ANDEQ     'PC'
     C     ACPRCD        OREQ      *BLANKS
     C     ACSTAT        ANDEQ     'RC'
     C     ACPRCD        OREQ      *BLANKS
     C     ACSTAT        ANDEQ     'RP'
     C                   MOVE      S1OPTN        WKOPTN
     C                   MOVE      *BLANKS       S1OPTN
     C                   UPDATE    GL019000S1
     C                   MOVEA     '111'         *IN(75)
     C                   MOVE      ACRFNO        S2RFNO
     C                   MOVEL     ACDESC        S2DESC
     C                   MOVE      ACBRCA        S2BRCA
     C                   MOVE      ACCNU1        S2CNU1
     C                   MOVE      ACCNU2        S2CNU2
     C                   MOVE      ACCCY         S2CCY
     C                   MOVE      ACACO1        S2ACO1
     C                   MOVE      ACACO2        S2ACO2
     C                   MOVE      ACACSQ        S2ACSQ
     C                   MOVE      ACACN1        S2ACN1
     C                   MOVE      ACACN2        S2ACN2
     C                   MOVE      ACACOC        S2ACOC
     C                   MOVE      ACATYP        S2ATYP
     C                   MOVE      ACCOLC        S2COLC
     C                   MOVE      ACTBRC        S2TBRC
     C                   MOVE      ACTCNU        S2TCNU
     C                   MOVE      ACTACO        S2TACO
     C                   MOVE      ACTACS        S2TACS
 
     C                   EXSR      XSDFD1
 
     C                   ELSE
     C                   MOVE      *ON           *IN70
     C                   UPDATE    GL019000S1
      **********         MOVEL     'XX00010'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0010'     WKMSID                                     BUG27219
 
     C                   EXSR      XSPMSQ
 
     C                   ADD       1             WKERR
     C                   WRITE     GL019000F1
     C                   WRITE     MSGCTL
     C                   WRITE     GL019000C1
     C                   ENDIF
     C     S1OPTN        WHENEQ    'RE'
     C                   MOVE      S1OPTN        SCOPTN                                       239243
     C                   MOVEL     S1RFNO        ACRFNO
 
     C                   EXSR      XRACRF
 
     C     ACPRCD        IFNE      *BLANKS
     C     ACSTAT        ANDEQ     'CP'
     C     ACPRCD        ORNE      *BLANKS
     C     ACSTAT        ANDEQ     'PC'
     C                   MOVE      S1OPTN        WKOPTN
     C                   MOVE      *BLANKS       S1OPTN
     C                   UPDATE    GL019000S1
     C                   MOVE      '1'           *IN69
     C                   MOVEA     '11'          *IN(76)
     C                   MOVE      ACRFNO        S2RFNO
     C                   MOVEL     ACDESC        S2DESC
     C                   MOVE      ACBRCA        S2BRCA
     C                   MOVE      ACCNU1        S2CNU1
     C                   MOVE      ACCNU2        S2CNU2
     C                   MOVE      ACCCY         S2CCY
     C                   MOVE      ACACO1        S2ACO1
     C                   MOVE      ACACO2        S2ACO2
     C                   MOVE      ACACSQ        S2ACSQ
     C                   MOVE      ACACN1        S2ACN1
     C                   MOVE      ACACN2        S2ACN2
     C                   MOVE      ACACOC        S2ACOC
     C                   MOVE      ACATYP        S2ATYP
     C                   MOVE      ACCOLC        S2COLC
     C                   MOVE      ACTBRC        S2TBRC
     C                   MOVE      ACTCNU        S2TCNU
     C                   MOVE      ACTACO        S2TACO
     C                   MOVE      ACTACS        S2TACS
 
     C                   EXSR      XSDFD1
      *
     C                   ELSE
     C                   MOVE      *ON           *IN70
     C                   UPDATE    GL019000S1
      **********         MOVEL     'XX00010'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0010'     WKMSID                                     BUG27219
 
     C                   EXSR      XSPMSQ
 
     C                   ADD       1             WKERR
     C                   WRITE     GL019000F1
     C                   WRITE     MSGCTL
     C                   WRITE     GL019000C1
     C                   ENDIF
     C                   OTHER
     C                   MOVE      *ON           *IN70
     C                   UPDATE    GL019000S1
      **********         MOVEL     'XX00016'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0016'     WKMSID                                     BUG27219
 
     C                   EXSR      XSPMSQ
 
     C                   WRITE     GL019000F1
     C                   WRITE     MSGCTL
     C                   WRITE     GL019000C1
     C                   ENDSL
     C                   ENDIF
 
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  XVDFD1: Validate Detail Screen Input                         *
      *                                                               *
      *****************************************************************
     C     XVDFD1        BEGSR
 
     C                   Z-ADD     0             WKERR
 
      ** 'Branch Code', if entered, must be a valid Branch
      ** 'Branch Code', must be entered if 'To Branch' entered
 
     C                   SELECT
     C     S2BRCA        WHENNE    *BLANKS
     C                   MOVEL     S2BRCA        WKBRCH
 
     C                   EXSR      XRBRCH
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      *BLANKS       S2BRNM
      **********         MOVEL     'XX00020'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0020'     WKMSID                                     BUG27219
 
     C                   EXSR      XSPMSQ
 
     C                   ADD       1             WKERR
     C                   MOVE      *ON           *IN73
     C                   ELSE
     C                   MOVEL     A8BRCD        S2BRCA
     C                   MOVEL     A8BRNM        S2BRNM
     C                   ENDIF
     C     S2BRCA        WHENEQ    *BLANKS
     C     S2TBRC        ANDNE     *BLANKS
      **********         MOVEL     'XX00021'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0021'     WKMSID                                     BUG27219
 
     C                   EXSR      XSPMSQ
 
     C                   ADD       1             WKERR
     C                   MOVE      *ON           *IN73
     C                   ENDSL
 
      ** 'Customer(s)', if entered, must be a valid Customer
      ** 'Customer(s)', must be entered if 'To Customer' entered
 
     C     S2CNU1        IFNE      *BLANKS
     C                   MOVEL     S2CNU1        WKCUS
 
     C                   EXSR      XRCUST
 
     C     @RTCD         IFNE      *BLANKS
      **********         MOVEL     'XX00022'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0022'     WKMSID                                     BUG27219
 
     C                   EXSR      XSPMSQ
 
     C                   ADD       1             WKERR
     C                   MOVE      *ON           *IN74
     C                   ELSE
     C                   MOVEL     BBCUST        S2CNU1
                                                                                            MD040242
      ** 'Customer(s)', if valid, at least one account must exist                           MD040242
                                                                                            MD040242
     C     S2CNU1        CHAIN     GLACNTL6                           2021                  MD040242
     C     *IN21         IFEQ      *ON                                                      MD040242
     C     *LOCK         IN        LDA                                                      MD040242
     C                   MOVEL(P)  'GLACNTL6'    DBFILE                                     MD040242
     C                   MOVEL(P)  S2CNU1        DBKEY                                      MD040242
     C                   Z-ADD     180           DBASE                                      MD040242
     C                   OUT       LDA                                                      MD040242
                                                                                            MD040242
     C                   EXSR      *PSSR                                                    MD040242
                                                                                            MD040242
     C                   ENDIF                                                              MD040242
                                                                                            MD040242
     C     *IN20         IFEQ      *ON                                                      MD040242
     C                   MOVEL     'ATU0069'     WKMSID                                     MD040242
                                                                                            MD040242
     C                   EXSR      XSPMSQ                                                   MD040242
     C                   ADD       1             WKERR                                      MD040242
     C                   MOVE      *ON           *IN74                                      MD040242
     C                   ENDIF                                                              MD040242
                                                                                            MD040242
     C                   ENDIF
     C                   ENDIF
 
     C     S2CNU2        IFNE      *BLANKS
     C                   MOVEL     S2CNU2        WKCUS
 
     C                   EXSR      XRCUST
 
     C     @RTCD         IFNE      *BLANKS
      **********         MOVEL     'XX00022'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0022'     WKMSID                                     BUG27219
 
     C                   EXSR      XSPMSQ
 
     C                   ADD       1             WKERR
     C                   MOVE      *ON           *IN55
     C                   ELSE
     C                   MOVEL     BBCUST        S2CNU2
     C                   ENDIF
     C                   ENDIF
 
     C     S2CNU2        IFNE      *BLANKS
     C     S2CNU1        ANDEQ     *BLANKS
      **********         MOVEL     'XX00032'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0032'     WKMSID                                     BUG27219
 
     C                   EXSR      XSPMSQ
 
     C                   ADD       1             WKERR
     C                   MOVE      *ON           *IN74
     C                   ENDIF
 
     C     S2CNU1        IFEQ      *BLANKS
     C     S2TCNU        ANDNE     *BLANKS
      **********         MOVEL     'XX00023'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0023'     WKMSID                                     BUG27219
 
     C                   EXSR      XSPMSQ
 
     C                   ADD       1             WKERR
     C                   MOVE      *ON           *IN74
     C                   ENDIF
 
      ** 'Currency', if entered, must be a valid Currency
 
     C     S2CCY         IFNE      *BLANKS
     C                   MOVEL     S2CCY         WKCUR
 
     C                   EXSR      XRCCY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      *BLANKS       S2CYNM
      **********         MOVEL     'XX00024'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0024'     WKMSID                                     BUG27219
 
     C                   EXSR      XSPMSQ
 
     C                   ADD       1             WKERR
     C                   MOVE      *ON           *IN80
     C                   ELSE
     C                   MOVEL     A6CYCD        S2CCY
     C                   MOVEL     A6CYNM        S2CYNM
     C                   ENDIF
     C                   ENDIF
 
      ** 'Acc Code(s)', if entered, must be  valid Codes
      ** 'Acc Code(s)', must be entered if 'To Acc Code' entered
 
     C     S2ACO1        IFNE      *BLANKS
     C                   MOVEL     S2ACO1        WKACC
 
     C                   EXSR      XRACOD
 
     C     @RTCD         IFNE      *BLANKS
      **********         MOVEL     'XX00025'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0025'     WKMSID                                     BUG27219
 
     C                   EXSR      XSPMSQ
 
     C                   ADD       1             WKERR
     C                   MOVE      *ON           *IN78
     C                   ELSE
     C                   MOVEL     A5ACCD        S2ACO1
     C                   MOVEL     A5ACTY        WKACTY            1                          239121
     C                   ENDIF
     C                   ENDIF
 
     C     S2ACO2        IFNE      *BLANKS
     C                   MOVEL     S2ACO2        WKACC
 
     C                   EXSR      XRACOD
 
     C     @RTCD         IFNE      *BLANKS
      **********         MOVEL     'XX00025'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0025'     WKMSID                                     BUG27219
 
     C                   EXSR      XSPMSQ
 
     C                   ADD       1             WKERR
     C                   MOVE      *ON           *IN56
     C                   ELSE
     C                   MOVEL     A5ACCD        S2ACO2
     C                   ENDIF
     C                   ENDIF
 
     C     S2TACO        IFNE      *BLANKS                                                    238380
     C                   MOVEL     S2TACO        WKACC                                        238380
 
     C                   EXSR      XRACOD                                                     238380
 
     C     @RTCD         IFNE      *BLANKS                                                    238380
      **********         MOVEL     'XX00025'     WKMSID                              238380 BUG27219
     C                   MOVEL     'ATU0025'     WKMSID                              238380 BUG27219
 
     C                   EXSR      XSPMSQ                                                     238380
 
     C                   ADD       1             WKERR                                        238380
     C                   MOVE      *ON           *IN56                                        238380
     C                   ELSE
     C     A5TOIN        IFEQ      'Y'                                                        238380
      **********         MOVEL     'XX00049'     WKMSID                              238380 BUG27219
     C                   MOVEL     'ATU0049'     WKMSID                              238380 BUG27219
 
     C                   EXSR      XSPMSQ                                                     238380
 
     C                   ADD       1             WKERR                                        238380
     C                   MOVE      *ON           *IN64                                        238380
     C                   ELSE                                                                 238380
     C                   MOVEL     A5ACCD        S2TACO                                       238380
     C                   ENDIF                                                                238380
     C                   ENDIF                                                                238380
     C                   ENDIF                                                                238380
 
     C     S2ACO2        IFNE      *BLANKS
     C     S2ACO1        ANDEQ     *BLANKS
     C     S2TACO        ANDEQ     *BLANKS                                                    238380
      **********         MOVEL     'XX00032'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0032'     WKMSID                                     BUG27219
 
     C                   EXSR      XSPMSQ
 
     C                   ADD       1             WKERR
     C                   MOVE      *ON           *IN78
     C                   ENDIF
 
     C     S2ACO1        IFEQ      *BLANKS
     C     S2TACO        ANDNE     *BLANKS
      **********         MOVEL     'XX00027'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0027'     WKMSID                                     BUG27219
 
     C                   EXSR      XSPMSQ
 
     C                   ADD       1             WKERR
     C                   MOVE      *ON           *IN78
     C                   ENDIF
 
      ** 'Account Seq' must be a number between 1 and 99
 
     C                   SELECT
     C     S2ACSQ        WHENNE    *BLANKS
     C     S2ACSQ        IFLT      '01'
     C     S2ACSQ        ORGT      '99'
      **********         MOVEL     'XX00028'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0028'     WKMSID                                     BUG27219
 
     C                   EXSR      XSPMSQ
 
     C                   ADD       1             WKERR
     C                   MOVE      *ON           *IN79
     C                   ENDIF
 
     C     S2ACSQ        WHENEQ    *BLANKS
     C     S2TACS        ANDNE     *BLANKS
      **********         MOVEL     'XX00029'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0029'     WKMSID                                     BUG27219
 
     C                   EXSR      XSPMSQ
 
     C                   ADD       1             WKERR
     C                   MOVE      *ON           *IN79
     C                   ENDSL
 
      ** If Retail Account not given, check if Full Account code supplied                     238581
      ** and check if Account is valid                                                        238581
 
     C     S2ACN1        IFEQ      *BLANKS                                                    238581
     C     *IN73         IFEQ      *OFF                                                       238581
     C     S2BRCA        ANDNE     *BLANKS                                                    238581
     C     *IN74         ANDEQ     *OFF                                                       238581
     C     S2CNU1        ANDNE     *BLANKS                                                    238581
     C     *IN80         ANDEQ     *OFF                                                       238581
     C     S2CCY         ANDNE     *BLANKS                                                    238581
     C     *IN78         ANDEQ     *OFF                                                       238581
     C     S2ACO1        ANDNE     *BLANKS                                                    238581
     C     *IN79         ANDEQ     *OFF                                                       238581
     C     S2ACSQ        ANDNE     *BLANKS                                                    238581
     C                   MOVEL     S2BRCA        @BRCA                                        238581
     C                   MOVEL     S2CNU1        @CNUM                                        238581
     C                   MOVEL     S2CCY         @CUCD                                        238581
     C                   MOVEL     S2ACO1        @ACCD                                        238581
     C                   MOVEL     S2ACSQ        @ACSQ                                        238581
 
     C                   EXSR      XRACCT                                                     238581
 
     C     @RTCD         IFEQ      '*NRF   '                                                  238581
      **********         MOVEL     'XX00055'     WKMSID                              238581 BUG27219
     C                   MOVEL     'ATU0055'     WKMSID                              238581 BUG27219
 
     C                   EXSR      XSPMSQ                                                     238581
 
     C                   ADD       1             WKERR                                        238581
     C                   MOVE      *ON           *IN73                                        238581
     C                   MOVE      *ON           *IN74                                        238581
     C                   MOVE      *ON           *IN80                                        238581
     C                   MOVE      *ON           *IN78                                        238581
     C                   MOVE      *ON           *IN79                                        238581
     C                   ENDIF                                                                238581
 
     C     @RTCD         IFEQ      *BLANKS                                                    238581
     C     W#ACST        IFEQ      'C'                                                        238581
     C     W#ATYP        IFEQ      'R'                                                        238581
      **********         MOVEL     'XX00050'     WKMSID                              238581 BUG27219
     C                   MOVEL     'ATU0050'     WKMSID                              238581 BUG27219
 
     C                   EXSR      XSPMSQ                                                     238581
 
     C                   ADD       1             WKERR                                        238581
     C                   MOVE      *ON           *IN73                                        238581
     C                   MOVE      *ON           *IN74                                        238581
     C                   MOVE      *ON           *IN80                                        238581
     C                   MOVE      *ON           *IN78                                        238581
     C                   MOVE      *ON           *IN79                                        238581
     C                   ELSE
      **********         MOVEL     'XX00056'     WKMSID                              238581 BUG27219
     C                   MOVEL     'ATU0056'     WKMSID                              238581 BUG27219
 
     C                   EXSR      XSPMSQ                                                     238581
 
     C                   ADD       1             WKERR                                        238581
     C                   MOVE      *ON           *IN73                                        238581
     C                   MOVE      *ON           *IN74                                        238581
     C                   MOVE      *ON           *IN80                                        238581
     C                   MOVE      *ON           *IN78                                        238581
     C                   MOVE      *ON           *IN79                                        238581
     C                   ENDIF                                                                238581
     C                   ENDIF                                                                238581
     C                   ENDIF                                                                238581
     C                   ENDIF                                                                238581
     C                   ENDIF                                                                238581
 
      ** 'Retail Numbers' must not be entered if Account Code entered                         239121
      ** 'Retail Numbers', if entered, must be valid Retail A/c's
 
     C     S2ACN1        IFNE      *BLANKS                                                    239121
     C     S2ACO1        ANDNE     *BLANKS                                                    239121
      **********         MOVEL     'XX00057'     WKMSID                              239121 BUG27219
     C                   MOVEL     'ATU0057'     WKMSID                              239121 BUG27219
 
     C                   EXSR      XSPMSQ                                                     239121
 
     C                   ADD       1             WKERR                                        239121
     C                   MOVE      *ON           *IN57                                        239121
     C                   ELSE                                                                 239121
     C     S2ACN1        IFNE      *BLANKS
     C                   MOVE      S2ACN1        WKACNM           10 0
     C     KACNM         CHAIN     ACNUM                              2021
     C     *IN21         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL(P)  'ACNUM'       DBFILE
     C                   MOVEL(P)  S2ACN1        DBKEY
     C                   Z-ADD     030           DBASE
     C                   OUT       LDA
 
     C                   EXSR      *PSSR
 
     C                   ENDIF
 
     C     *IN20         IFEQ      *ON
     C*                  MOVEL     'XXX0030'     WKMSID                                     BUG27219
     C                   MOVEL     'USR9455'     WKMSID                                     BUG27219
 
     C                   EXSR      XSPMSQ
 
     C                   ADD       1             WKERR
     C                   MOVE      *ON           *IN57
     C                   ELSE                                                                 238581
     C     ACST          IFEQ      'C'                                                        238581
      **********         MOVEL     'XX00050'     WKMSID                              238581 BUG27219
     C                   MOVEL     'ATU0050'     WKMSID                              238581 BUG27219
 
     C                   EXSR      XSPMSQ                                                     238581
 
     C                   ADD       1             WKERR                                        238581
     C                   MOVE      *ON           *IN57                                        238581
     C                   ENDIF                                                                238581
     C                   ENDIF
     C                   ENDIF
 
     C     S2ACN2        IFNE      *BLANKS
     C                   MOVE      S2ACN2        WKACNM
     C     KACNM         CHAIN     ACNUM                              2021
     C     *IN21         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL(P)  'ACNUM'       DBFILE
     C                   MOVEL(P)  S2ACN2        DBKEY
     C                   Z-ADD     040           DBASE
     C                   OUT       LDA
 
     C                   EXSR      *PSSR
 
     C                   ENDIF
 
     C     *IN20         IFEQ      *ON
      **********         MOVEL     'XX00030'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0030'     WKMSID                                     BUG27219
 
     C                   EXSR      XSPMSQ
 
     C                   ADD       1             WKERR
     C                   MOVE      *ON           *IN58
     C                   ELSE                                                                 238581
     C     ACST          IFEQ      'C'                                                        238581
      **********         MOVEL     'XX00050'     WKMSID                              238581 BUG27219
     C                   MOVEL     'ATU0050'     WKMSID                              238581 BUG27219
 
     C                   EXSR      XSPMSQ                                                     238581
 
     C                   ADD       1             WKERR                                        238581
     C                   MOVE      *ON           *IN58                                        238581
     C                   ENDIF                                                                238581
     C                   ENDIF
     C                   ENDIF
      *
     C     S2ACN2        IFNE      *BLANKS
     C     S2ACN1        ANDEQ     *BLANKS
      **********         MOVEL     'XX00032'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0032'     WKMSID                                     BUG27219
 
     C                   EXSR      XSPMSQ
 
     C                   ADD       1             WKERR
     C                   MOVE      *ON           *IN57
     C                   ENDIF
     C                   ENDIF                                                                239121
 
      ** 'Account Officer', if entered, must be a valid Code
 
     C     S2ACOC        IFNE      *BLANKS
     C                   MOVEL     S2ACOC        WKACO
 
     C                   EXSR      XRACO
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      *BLANKS       S2ACON
      **********         MOVEL     'XX00047'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0047'     WKMSID                                     BUG27219
 
     C                   EXSR      XSPMSQ
 
     C                   ADD       1             WKERR
     C                   MOVE      *ON           *IN59
     C                   ELSE
     C                   MOVEL     AZACOC        S2ACOC
     C                   MOVEL     AZACON        S2ACON
     C                   ENDIF
     C                   ENDIF
 
      ** 'Account Type' must not be entered if Account Code or Retail                         239121
      ** Number is entered.                                                                   239121
      ** But, 'Account Type' can be entered if a range of Account Codes are                   239121
      ** entered.                                                                             239121
      ** 'Account Type' must be a valid code
 
     C     S2ATYP        IFNE      *BLANKS                                                    239121
     C     S2ACO1        ANDNE     *BLANKS                                                    239121
     C     S2ACO2        ANDEQ     *BLANKS                                                    239121
     C     S2ATYP        ORNE      *BLANKS                                                    239121
     C     S2ACN1        ANDNE     *BLANKS                                                    239121
      **********         MOVEL     'XX00058'     WKMSID                              239121 BUG27219
     C                   MOVEL     'ATU0058'     WKMSID                              239121 BUG27219
 
     C                   EXSR      XSPMSQ                                                     239121
 
     C                   ADD       1             WKERR                                        239121
     C                   MOVE      *ON           *IN60                                        239121
     C                   ELSE                                                                 239121
     C     S2ATYP        IFNE      *BLANKS
     C     S2ATYP        LOOKUP    ATY                                    25
     C     *IN25         IFEQ      *OFF
      **********         MOVEL     'XX00033'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0033'     WKMSID                                     BUG27219
 
     C                   EXSR      XSPMSQ
 
     C                   ADD       1             WKERR
     C                   MOVE      *ON           *IN60
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                                239121
 
      ** 'Country Of Domicile', if entered, must be a valid Code
 
     C     S2COLC        IFNE      *BLANKS
     C                   MOVEL     S2COLC        WKCTR
 
     C                   EXSR      XRCTR
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      *BLANKS       S2CNNM
      **********         MOVEL     'XX00048'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0048'     WKMSID                                     BUG27219
 
     C                   EXSR      XSPMSQ
 
     C                   ADD       1             WKERR
     C                   MOVE      *ON           *IN61
     C                   ELSE
     C                   MOVEL     A4CNCD        S2COLC
     C                   MOVEL     A4CNNM        S2CNNM
     C                   ENDIF
     C                   ENDIF
 
      ** 'To Branch Code', if entered, must be a valid Branch
      ** 'To Branch Code', must be entered if 'To Branch' entered
 
     C                   SELECT
     C     S2TBRC        WHENNE    *BLANKS
     C                   MOVEL     S2TBRC        WKBRCH
 
     C                   EXSR      XRBRCH
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      *BLANKS       S2TBRN
      **********         MOVEL     'XX00036'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0036'     WKMSID                                     BUG27219
 
     C                   EXSR      XSPMSQ
 
     C                   ADD       1             WKERR
     C                   MOVE      *ON           *IN62
     C                   ELSE
     C                   MOVEL     A8BRCD        S2TBRC
     C                   MOVEL     A8BRNM        S2TBRN
     C                   ENDIF
     C     S2TBRC        WHENEQ    *BLANKS
     C     S2BRCA        ANDNE     *BLANKS
      **********         MOVEL     'XX00037'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0037'     WKMSID                                     BUG27219
 
     C                   EXSR      XSPMSQ
 
     C                   ADD       1             WKERR
     C                   MOVE      *ON           *IN62
     C                   ENDSL
 
      ** 'To Customer', if entered, must be a valid Customer
      ** 'To Customer, must be blank if 'Customer' range is entered
      ** 'To Customer, must be blank if 'Retail#' entered
 
     C     S2TCNU        IFNE      *BLANKS
     C                   MOVEL     S2TCNU        WKCUS
 
     C                   EXSR      XRCUST
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      *BLANKS       S2TCRN
      **********         MOVEL     'XX00038'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0038'     WKMSID                                     BUG27219
 
     C                   EXSR      XSPMSQ
 
     C                   ADD       1             WKERR
     C                   MOVE      *ON           *IN63
     C                   ELSE
     C                   MOVEL     BBCUST        S2TCNU
     C                   MOVEL     BBCRNM        S2TCRN
     C                   ENDIF
     C                   ENDIF
 
     C     S2CNU1        IFNE      *BLANKS
     C     S2CNU2        ANDNE     *BLANKS
     C     S2TCNU        ANDNE     *BLANKS
      **********         MOVEL     'XX00039'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0039'     WKMSID                                     BUG27219
 
     C                   EXSR      XSPMSQ
 
     C                   ADD       1             WKERR
     C                   MOVE      *ON           *IN63
     C                   ENDIF
 
     C     S2ACN1        IFNE      *BLANKS
     C     S2TCNU        ANDNE     *BLANKS
      **********         MOVEL     'XX00040'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0040'     WKMSID                                     BUG27219
 
     C                   EXSR      XSPMSQ
 
     C                   ADD       1             WKERR
     C                   MOVE      *ON           *IN63
     C                   ENDIF
 
      ** 'To Acc Code', if entered, must be a valid Account Code
      ** and must be of the same type as 'Acc Code'                                           239121
      ** 'To Acc Code, must be blank if 'Acc Code' ranges is entered
      ** 'To Acc Code', must be blank if 'Retail#' entered
 
     C     S2TACO        IFNE      *BLANKS
     C                   MOVEL     S2TACO        WKACC
 
     C                   EXSR      XRACOD
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      *BLANKS       S2TACC
      **********         MOVEL     'XX00041'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0041'     WKMSID                                     BUG27219
 
     C                   EXSR      XSPMSQ
 
     C                   ADD       1             WKERR
     C                   MOVE      *ON           *IN64
     C                   ELSE
     C                   MOVEL     A5ACCD        S2TACO
     C                   MOVEL     A5ACCN        S2TACC
     C     WKACTY        IFNE      A5ACTY                                                     239121
      **********         MOVEL     'XX00051'     WKMSID                              239121 BUG27219
     C                   MOVEL     'ATU0051'     WKMSID                              239121 BUG27219
 
     C                   EXSR      XSPMSQ                                                     239121
 
     C                   ADD       1             WKERR                                        239121
     C                   MOVE      *ON           *IN64                                        239121
     C                   ENDIF                                                                239121
     C                   ENDIF
     C                   ENDIF
 
     C     S2ACO1        IFNE      *BLANKS
     C     S2ACO2        ANDNE     *BLANKS
     C     S2TACO        ANDNE     *BLANKS
      **********         MOVEL     'XX00042'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0042'     WKMSID                                     BUG27219
 
     C                   EXSR      XSPMSQ
 
     C                   ADD       1             WKERR
     C                   MOVE      *ON           *IN64
     C                   ENDIF
 
     C     S2ACN1        IFNE      *BLANKS
     C     S2TACO        ANDNE     *BLANKS
      **********         MOVEL     'XX00043'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0043'     WKMSID                                     BUG27219
 
     C                   EXSR      XSPMSQ
 
     C                   ADD       1             WKERR
     C                   MOVE      *ON           *IN64
     C                   ENDIF
 
      ** 'To Account Seq' must be a number between 1 and 99
      ** 'To Account Seq' must be blank if 'Retail#' entered
 
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
 
     C     S2ACN1        IFNE      *BLANKS
     C     S2TACS        ANDNE     *BLANKS
      **********         MOVEL     'XX00045'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0045'     WKMSID                                     BUG27219
 
     C                   EXSR      XSPMSQ
 
     C                   ADD       1             WKERR
     C                   MOVE      *ON           *IN65
     C                   ENDIF
 
      ** At least one of the Transfer Details must be entered
 
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
 
      ** If there is no error, check that at least one account exists for the selection    MD040242A
     C     WKERR         IFEQ      0                                                       MD040242A
     C                   EVAL      DSBRCA = S2BRCA                                         MD040242A
     C                   EVAL      DSCNU1 = S2CNU1                                         MD040242A
     C                   EVAL      DSCNU2 = S2CNU2                                         MD040242A
     C                   EVAL      DSCCY  = S2CCY                                          MD040242A
     C                   EVAL      DSACO1 = S2ACO1                                         MD040242A
     C                   EVAL      DSACO2 = S2ACO2                                         MD040242A
     C                   EVAL      DSACSQ = S2ACSQ                                         MD040242A
     C                   EVAL      DSACN1 = S2ACN1                                         MD040242A
     C                   EVAL      DSACN2 = S2ACN2                                         MD040242A
     C                   EVAL      DSACOC = S2ACOC                                         MD040242A
     C                   EVAL      DSATYP = S2ATYP                                         MD040242A
     C                   EVAL      DSCOLC = S2COLC                                         MD040242A
                                                                                           MD040242A
     C                   CALL      'GLC003300'                                             MD040242A
     C                   PARM                    DSPARM                                    MD040242A
     C                   PARM      *BLANKS       NOREC             1                       MD040242A
     C     NOREC         IFEQ      'Y'                                                     MD040242A
     C                   MOVEL     'ATU0070'     WKMSID                                     MD040242
     C                   EXSR      XSPMSQ                                                   MD040242
     C                   ADD       1             WKERR                                      MD040242
     C                   ENDIF                                                             MD040242A
                                                                                           MD040242A
     C                   ENDIF                                                             MD040242A
                                                                                           MD040242A
      ** If there are any errors, redisplay detail screen,
      ** otherwise update the file and return to subfile screen.
 
     C     WKERR         IFGT      0
     C                   MOVE      *ON           *IN76
 
     C                   EXSR      XSDFD1
 
     C                   ENDIF
 
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  PDFS1: Process Display Format - Subfile (S1)                 *
      *                                                               *
      *****************************************************************
     C     PDFS1         BEGSR
 
      ** Reset the error indicator and update the subfile for any records
      ** which were in error but which now have a blank Option.
 
     C                   READC     GL019000S1                             22
     C     *IN22         DOWEQ     *OFF
     C     S1OPTN        ANDEQ     *BLANKS
     C                   MOVE      *OFF          *IN70
     C                   UPDATE    GL019000S1
     C                   READC     GL019000S1                             22
     C                   ENDDO
 
      ** For all records which have been selected with a valid option (E),
      ** set screen data items and display the detail screen
      ** Otherwise, redisplay selection list.
 
     C                   SELECT
     C     *IN22         WHENEQ    *ON
 
     C                   EXSR      XSDFS1
      *
     C     S1OPTN        WHENEQ    'E '
     C     S1OPTN        OREQ      ' E'
     C                   MOVE      S1OPTN        WKOPTN
     C                   MOVE      S1OPTN        SCOPTN                                       239243
     C                   MOVE      *BLANKS       S1OPTN
     C                   UPDATE    GL019000S1
     C                   MOVE      *ON           *IN77
     C                   MOVEL     S1RFNO        ACRFNO
 
     C                   EXSR      XRACRF
 
     C                   MOVEL     ACRFNO        S2RFNO
     C                   MOVEL     ACDESC        S2DESC
     C                   MOVE      ACBRCA        S2BRCA
     C                   MOVE      ACCNU1        S2CNU1
     C                   MOVE      ACCNU2        S2CNU2
     C                   MOVE      ACCCY         S2CCY
     C                   MOVE      ACACO1        S2ACO1
     C                   MOVE      ACACO2        S2ACO2
     C                   MOVE      ACACSQ        S2ACSQ
     C                   MOVE      ACACN1        S2ACN1
     C                   MOVE      ACACN2        S2ACN2
     C                   MOVE      ACACOC        S2ACOC
     C                   MOVE      ACATYP        S2ATYP
     C                   MOVE      ACCOLC        S2COLC
     C                   MOVE      ACTBRC        S2TBRC
     C                   MOVE      ACTCNU        S2TCNU
     C                   MOVE      ACTACO        S2TACO
     C                   MOVE      ACTACS        S2TACS
 
     C                   EXSR      XCPMSQ
 
     C                   MOVEA     '11'          *IN(76)
 
     C                   EXSR      XSDFD1
      *
     C     S1OPTN        WHENEQ    'A '
     C     S1OPTN        OREQ      ' A'
     C                   MOVE      S1OPTN        SCOPTN                                       239243
     C                   MOVEL     S1RFNO        ACRFNO
 
     C                   EXSR      XRACRF
 
     C     ACPRCD        IFEQ      *BLANKS
     C     ACSTAT        ANDEQ     'CR'
     C     ACPRCD        OREQ      *BLANKS
     C     ACSTAT        ANDEQ     'PC'
     C                   MOVE      S1OPTN        WKOPTN
     C                   MOVE      *BLANKS       S1OPTN
     C                   UPDATE    GL019000S1
     C                   MOVEL     ACRFNO        S2RFNO
     C                   MOVEL     ACDESC        S2DESC
     C                   MOVE      ACBRCA        S2BRCA
     C                   MOVE      ACCNU1        S2CNU1
     C                   MOVE      ACCNU2        S2CNU2
     C                   MOVE      ACCCY         S2CCY
     C                   MOVE      ACACO1        S2ACO1
     C                   MOVE      ACACO2        S2ACO2
     C                   MOVE      ACACSQ        S2ACSQ
     C                   MOVE      ACACN1        S2ACN1
     C                   MOVE      ACACN2        S2ACN2
     C                   MOVE      ACACOC        S2ACOC
     C                   MOVE      ACATYP        S2ATYP
     C                   MOVE      ACCOLC        S2COLC
     C                   MOVE      ACTBRC        S2TBRC
     C                   MOVE      ACTCNU        S2TCNU
     C                   MOVE      ACTACO        S2TACO
     C                   MOVE      ACTACS        S2TACS
 
     C                   EXSR      XCPMSQ
 
     C                   MOVE      '1'           *IN76
 
     C                   EXSR      XSDFD1
 
     C                   ELSE
     C                   MOVE      *ON           *IN70
     C                   UPDATE    GL019000S1
      **********         MOVEL     'XX00010'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0010'     WKMSID                                     BUG27219
 
     C                   EXSR      XSPMSQ
 
     C                   ADD       1             WKERR
     C                   WRITE     GL019000F1
     C                   WRITE     MSGCTL
     C                   WRITE     GL019000C1
     C                   ENDIF
     C     S1OPTN        WHENEQ    'D '
     C     S1OPTN        OREQ      ' D'
     C                   MOVE      S1OPTN        SCOPTN                                       239243
     C                   MOVEL     S1RFNO        ACRFNO
 
     C                   EXSR      XRACRF
 
     C     ACPRCD        IFEQ      *BLANKS
     C     ACSTAT        ANDEQ     'CR'
     C     ACPRCD        OREQ      *BLANKS
     C     ACSTAT        ANDEQ     'PC'
     C     ACPRCD        OREQ      *BLANKS
     C     ACSTAT        ANDEQ     'RC'
     C     ACPRCD        OREQ      *BLANKS
     C     ACSTAT        ANDEQ     'RP'
     C                   MOVE      S1OPTN        WKOPTN
     C                   MOVE      *BLANKS       S1OPTN
     C                   UPDATE    GL019000S1
     C                   MOVEL     ACRFNO        S2RFNO
     C                   MOVEL     ACDESC        S2DESC
     C                   MOVE      ACBRCA        S2BRCA
     C                   MOVE      ACCNU1        S2CNU1
     C                   MOVE      ACCNU2        S2CNU2
     C                   MOVE      ACCCY         S2CCY
     C                   MOVE      ACACO1        S2ACO1
     C                   MOVE      ACACO2        S2ACO2
     C                   MOVE      ACACSQ        S2ACSQ
     C                   MOVE      ACACN1        S2ACN1
     C                   MOVE      ACACN2        S2ACN2
     C                   MOVE      ACACOC        S2ACOC
     C                   MOVE      ACATYP        S2ATYP
     C                   MOVE      ACCOLC        S2COLC
     C                   MOVE      ACTBRC        S2TBRC
     C                   MOVE      ACTCNU        S2TCNU
     C                   MOVE      ACTACO        S2TACO
     C                   MOVE      ACTACS        S2TACS
     C                   MOVEA     '111'         *IN(75)
 
     C                   EXSR      XSDFD1
 
     C                   ELSE
     C                   MOVE      *ON           *IN70
     C                   UPDATE    GL019000S1
      **********         MOVEL     'XX00010'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0010'     WKMSID                                     BUG27219
 
     C                   EXSR      XSPMSQ
 
     C                   ADD       1             WKERR
     C                   WRITE     GL019000F1
     C                   WRITE     MSGCTL
     C                   WRITE     GL019000C1
     C                   ENDIF
     C     S1OPTN        WHENEQ    'RE'
     C                   MOVE      S1OPTN        SCOPTN                                       239243
     C                   MOVEL     S1RFNO        ACRFNO
 
     C                   EXSR      XRACRF
 
     C     ACPRCD        IFNE      *BLANKS
     C     ACSTAT        ANDEQ     'CP'
     C     ACPRCD        ORNE      *BLANKS
     C     ACSTAT        ANDEQ     'PC'
     C                   MOVE      S1OPTN        WKOPTN
     C                   MOVE      *BLANKS       S1OPTN
     C                   UPDATE    GL019000S1
     C                   MOVEL     ACRFNO        S2RFNO
     C                   MOVEL     ACDESC        S2DESC
     C                   MOVE      ACBRCA        S2BRCA
     C                   MOVE      ACCNU1        S2CNU1
     C                   MOVE      ACCNU2        S2CNU2
     C                   MOVE      ACCCY         S2CCY
     C                   MOVE      ACACO1        S2ACO1
     C                   MOVE      ACACO2        S2ACO2
     C                   MOVE      ACACSQ        S2ACSQ
     C                   MOVE      ACACN1        S2ACN1
     C                   MOVE      ACACN2        S2ACN2
     C                   MOVE      ACACOC        S2ACOC
     C                   MOVE      ACATYP        S2ATYP
     C                   MOVE      ACCOLC        S2COLC
     C                   MOVE      ACTBRC        S2TBRC
     C                   MOVE      ACTCNU        S2TCNU
     C                   MOVE      ACTACO        S2TACO
     C                   MOVE      ACTACS        S2TACS
     C                   MOVEA     '1'           *IN(69)
     C                   MOVEA     '11'          *IN(76)
 
     C                   EXSR      XSDFD1
 
     C                   ELSE
     C                   MOVE      *ON           *IN70
     C                   UPDATE    GL019000S1
      **********         MOVEL     'XX00011'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0011'     WKMSID                                     BUG27219
 
     C                   EXSR      XSPMSQ
 
     C                   ADD       1             WKERR
     C                   WRITE     GL019000F1
     C                   WRITE     MSGCTL
     C                   WRITE     GL019000C1
     C                   ENDIF
     C                   OTHER
     C                   MOVE      *ON           *IN70
     C                   UPDATE    GL019000S1
      **********         MOVEL     'XX00017'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0017'     WKMSID                                     BUG27219
 
     C                   EXSR      XSPMSQ
 
     C                   WRITE     GL019000F1
     C                   WRITE     MSGCTL
     C                   WRITE     GL019000C1
     C                   ENDSL
 
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  XVDFC1: Validate Input to Subfile Control Screen (C1)        *
      *                                                               *
      *****************************************************************
     C     XVDFC1        BEGSR
 
     C                   Z-ADD     0             WKERR             5 0
     C                   MOVEA     '00'          *IN(54)
     C     SCOPTN        IFNE      *BLANKS
     C                   SELECT
     C     SCPOS1        WHENEQ    *BLANKS
      **********         MOVEL     'XX00018'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0018'     WKMSID                                     BUG27219
 
     C                   EXSR      XSPMSQ
 
     C                   ADD       1             WKERR
     C                   MOVE      *ON           *IN54
     C     SCOPTN        WHENEQ    'E '
     C     SCOPTN        OREQ      ' E'
     C                   MOVEL     SCPOS1        ACRFNO
 
     C                   EXSR      XRACRF
 
     C     *IN20         IFEQ      *ON
      **********         MOVEL     'XX00018'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0018'     WKMSID                                     BUG27219
 
     C                   EXSR      XSPMSQ
 
     C                   ADD       1             WKERR
     C                   MOVEA     '11'          *IN(54)
     C                   ELSE
     C                   MOVEL     ACRFNO        S2RFNO
     C                   MOVEL     ACDESC        S2DESC
     C                   MOVE      ACBRCA        S2BRCA
     C                   MOVE      ACCNU1        S2CNU1
     C                   MOVE      ACCNU2        S2CNU2
     C                   MOVE      ACCCY         S2CCY
     C                   MOVE      ACACO1        S2ACO1
     C                   MOVE      ACACO2        S2ACO2
     C                   MOVE      ACACSQ        S2ACSQ
     C                   MOVE      ACACN1        S2ACN1
     C                   MOVE      ACACN2        S2ACN2
     C                   MOVE      ACACOC        S2ACOC
     C                   MOVE      ACATYP        S2ATYP
     C                   MOVE      ACCOLC        S2COLC
     C                   MOVE      ACTBRC        S2TBRC
     C                   MOVE      ACTCNU        S2TCNU
     C                   MOVE      ACTACO        S2TACO
     C                   MOVE      ACTACS        S2TACS
 
     C                   EXSR      XCPMSQ
 
     C                   MOVEA     '11'          *IN(76)
 
     C                   EXSR      XSDFD1
 
     C                   MOVE      *BLANKS       SCOPTN
     C                   ENDIF
     C     SCOPTN        WHENEQ    'A '
     C     SCOPTN        OREQ      ' A'
     C                   MOVE      SCOPTN        WKOPTN
     C                   MOVEL     SCPOS1        ACRFNO
 
     C                   EXSR      XRACRF
 
     C     ACPRCD        IFNE      *BLANKS
     C     ACSTAT        OREQ      'RC'
     C     ACSTAT        OREQ      'RP'
      **********         MOVEL     'XX00010'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0010'     WKMSID                                     BUG27219
 
     C                   EXSR      XSPMSQ
 
     C                   ADD       1             WKERR
     C                   MOVE      *ON           *IN54
     C                   MOVE      *ON           *IN55
     C                   ELSE
     C     *IN20         IFEQ      *ON
      **********         MOVEL     'XX00018'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0018'     WKMSID                                     BUG27219
 
     C                   EXSR      XSPMSQ
 
     C                   ADD       1             WKERR
     C                   MOVE      *ON           *IN54
     C                   MOVE      *ON           *IN55
     C                   ELSE
     C                   MOVEL     ACRFNO        S2RFNO
     C                   MOVEL     ACDESC        S2DESC
     C                   MOVE      ACBRCA        S2BRCA
     C                   MOVE      ACCNU1        S2CNU1
     C                   MOVE      ACCNU2        S2CNU2
     C                   MOVE      ACCCY         S2CCY
     C                   MOVE      ACACO1        S2ACO1
     C                   MOVE      ACACO2        S2ACO2
     C                   MOVE      ACACSQ        S2ACSQ
     C                   MOVE      ACACN1        S2ACN1
     C                   MOVE      ACACN2        S2ACN2
     C                   MOVE      ACACOC        S2ACOC
     C                   MOVE      ACATYP        S2ATYP
     C                   MOVE      ACCOLC        S2COLC
     C                   MOVE      ACTBRC        S2TBRC
     C                   MOVE      ACTCNU        S2TCNU
     C                   MOVE      ACTACO        S2TACO
     C                   MOVE      ACTACS        S2TACS
 
     C                   EXSR      XCPMSQ
 
     C                   MOVE      '1'           *IN76
 
     C                   EXSR      XSDFD1
 
     C                   MOVE      *BLANKS       SCOPTN
     C                   ENDIF
     C                   ENDIF
     C     SCOPTN        WHENEQ    'I '
     C     SCOPTN        OREQ      ' I'
     C                   MOVE      SCOPTN        WKOPTN
     C                   MOVEL     SCPOS1        ACRFNO
 
     C                   EXSR      XRACRF
 
     C     *IN20         IFEQ      *OFF
      **********         MOVEL     'XX00031'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0031'     WKMSID                                     BUG27219
 
     C                   EXSR      XSPMSQ
 
     C                   ADD       1             WKERR
     C                   MOVEA     '11'          *IN(54)
     C                   ELSE
     C                   MOVEL     SCPOS1        S2RFNO
     C                   MOVEL     *BLANKS       S2DESC
     C                   MOVE      *BLANKS       S2BRCA
     C                   MOVE      *BLANKS       S2CNU1
     C                   MOVE      *BLANKS       S2CNU2
     C                   MOVE      *BLANKS       S2CCY
     C                   MOVE      *BLANKS       S2ACO1
     C                   MOVE      *BLANKS       S2ACO2
     C                   MOVE      *BLANKS       S2ACSQ
     C                   MOVE      *BLANKS       S2ACN1
     C                   MOVE      *BLANKS       S2ACN2
     C                   MOVE      *BLANKS       S2ACOC
     C                   MOVE      *BLANKS       S2ATYP
     C                   MOVE      *BLANKS       S2COLC
     C                   MOVE      *BLANKS       S2TBRC
     C                   MOVE      *BLANKS       S2TCNU
     C                   MOVE      *BLANKS       S2TACO
     C                   MOVE      *BLANKS       S2TACS
 
     C                   EXSR      XCPMSQ
 
     C                   MOVE      '1'           *IN76
 
     C                   EXSR      XSDFD1
 
     C                   MOVE      *BLANKS       SCOPTN
     C                   ENDIF
     C     SCOPTN        WHENEQ    'D '
     C     SCOPTN        OREQ      ' D'
     C                   MOVE      SCOPTN        WKOPTN
     C                   MOVEL     SCPOS1        ACRFNO
 
     C                   EXSR      XRACRF
 
     C     ACPRCD        IFNE      *BLANKS
      **********         MOVEL     'XX00010'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0010'     WKMSID                                     BUG27219
 
     C                   EXSR      XSPMSQ
 
     C                   ADD       1             WKERR
     C                   MOVE      *ON           *IN54
     C                   MOVE      *ON           *IN55
     C                   ELSE
     C     *IN20         IFEQ      *ON
      **********         MOVEL     'XX00018'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0018'     WKMSID                                     BUG27219
 
     C                   EXSR      XSPMSQ
 
     C                   ADD       1             WKERR
     C                   MOVE      *ON           *IN54
     C                   MOVE      *ON           *IN55
     C                   ELSE
     C                   MOVEL     ACRFNO        S2RFNO
     C                   MOVEL     ACDESC        S2DESC
     C                   MOVE      ACBRCA        S2BRCA
     C                   MOVE      ACCNU1        S2CNU1
     C                   MOVE      ACCNU2        S2CNU2
     C                   MOVE      ACCCY         S2CCY
     C                   MOVE      ACACO1        S2ACO1
     C                   MOVE      ACACO2        S2ACO2
     C                   MOVE      ACACSQ        S2ACSQ
     C                   MOVE      ACACN1        S2ACN1
     C                   MOVE      ACACN2        S2ACN2
     C                   MOVE      ACACOC        S2ACOC
     C                   MOVE      ACATYP        S2ATYP
     C                   MOVE      ACCOLC        S2COLC
     C                   MOVE      ACTBRC        S2TBRC
     C                   MOVE      ACTCNU        S2TCNU
     C                   MOVE      ACTACO        S2TACO
     C                   MOVE      ACTACS        S2TACS
 
     C                   EXSR      XCPMSQ
 
     C                   MOVEA     '111'         *IN(75)
 
     C                   EXSR      XSDFD1
 
     C                   MOVE      *BLANKS       SCOPTN
     C                   ENDIF
     C                   ENDIF
     C     SCOPTN        WHENEQ    'RE'
     C                   MOVE      SCOPTN        WKOPTN
     C                   MOVEL     SCPOS1        ACRFNO
 
     C                   EXSR      XRACRF
 
     C     ACPRCD        IFEQ      *BLANKS
     C     ACPRCD        ORNE      *BLANKS
     C     ACSTAT        ANDEQ     'RV'
     C     ACPRCD        ORNE      *BLANKS
     C     ACSTAT        ANDEQ     'RP'
      **********         MOVEL     'XX00011'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0011'     WKMSID                                     BUG27219
 
     C                   EXSR      XSPMSQ
 
     C                   ADD       1             WKERR
     C                   MOVE      *ON           *IN54
     C                   MOVE      *ON           *IN55
     C                   ELSE
     C     *IN20         IFEQ      *ON
      **********         MOVEL     'XX00018'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0018'     WKMSID                                     BUG27219
 
     C                   EXSR      XSPMSQ
 
     C                   ADD       1             WKERR
     C                   MOVE      *ON           *IN54
     C                   MOVE      *ON           *IN55
     C                   ELSE
      *
     C                   MOVEL     ACRFNO        S2RFNO
     C                   MOVEL     ACDESC        S2DESC
     C                   MOVE      ACBRCA        S2BRCA
     C                   MOVE      ACCNU1        S2CNU1
     C                   MOVE      ACCNU2        S2CNU2
     C                   MOVE      ACCCY         S2CCY
     C                   MOVE      ACACO1        S2ACO1
     C                   MOVE      ACACO2        S2ACO2
     C                   MOVE      ACACSQ        S2ACSQ
     C                   MOVE      ACACN1        S2ACN1
     C                   MOVE      ACACN2        S2ACN2
     C                   MOVE      ACACOC        S2ACOC
     C                   MOVE      ACATYP        S2ATYP
     C                   MOVE      ACCOLC        S2COLC
     C                   MOVE      ACTBRC        S2TBRC
     C                   MOVE      ACTCNU        S2TCNU
     C                   MOVE      ACTACO        S2TACO
     C                   MOVE      ACTACS        S2TACS
 
     C                   EXSR      XCPMSQ
 
     C                   MOVE      '1'           *IN69
     C                   MOVEA     '11'          *IN(76)
 
     C                   EXSR      XSDFD1
 
     C                   MOVE      *BLANKS       SCOPTN
     C                   ENDIF
     C                   ENDIF
     C                   OTHER
     C                   MOVE      *ON           *IN71
     C                   ADD       1             WKERR
      **********         MOVEL     'XX00016'     WKMSID                                     BUG27219
     C                   MOVEL     'ATU0016'     WKMSID                                     BUG27219
 
     C                   EXSR      XSPMSQ
 
     C                   ENDSL
 
      ** If no option has been entered i.e. positioning.
 
     C                   ELSE
 
      ** Check if Reference # is requested.
 
     C                   SELECT
     C     SCPOS1        WHENNE    *BLANKS
     C                   MOVEL     'SCPOS1'      WKPOSN            6
     C                   OTHER
     C                   MOVEL     *BLANKS       WKPOSN
     C                   ENDSL
     C                   ENDIF
 
      ** If errors have been found redisplay Subfile Control Screen.
 
     C     WKERR         IFGT      *ZERO
     C                   WRITE     GL019000F1
     C                   WRITE     MSGCTL
     C                   WRITE     GL019000C1
     C                   ENDIF
 
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  XSDFS1: Set Display Format - Subfile Screen (S1)             *
      *                                                               *
      *****************************************************************
     C     XSDFS1        BEGSR
 
      ** Initialise Data Items & Subfile.
 
     C                   MOVE      *BLANKS       SCOPTN
     C                   Z-ADD     13            WKS1MX            2 0
     C                   CLEAR                   DSDF10
     C                   MOVEA     '01'          *IN(81)
     C                   WRITE     GL019000C1
     C                   MOVEA     '11'          *IN(81)
 
      ** Evaluate File Start Position (WKSKEY). If none of the following
      ** conditions are met then the value of WKSKEY remains the same.
 
      ** Initialise field for positioning.
 
     C                   CLEAR                   ACRFNO
 
      ** (Page Down)
 
     C                   SELECT
     C     *IN01         WHENEQ    *ON
     C                   MOVE      WKEKEY        DSDF10
     C                   EXSR      XPACRF
     C                   EXSR      XSACRF
      *
     C     *IN22         IFEQ      *ON
     C                   CLEAR                   WKSKEY
     C                   ELSE
     C                   MOVE      DSDF10        WKSKEY
     C                   ENDIF
 
      ** (Page Up)
 
     C     *IN02         WHENEQ    *ON
     C                   MOVE      WKSKEY        DSDF10
 
     C                   EXSR      XPACRF
 
     C                   DO        WKS1MX
     C                   MOVE      'P'           WKREAD            1
 
     C                   EXSR      XSACRF
 
     C     *IN22         IFEQ      *ON
     C                   CLEAR                   WKSKEY
     C                   LEAVE
     C                   ENDIF
     C                   MOVE      DSDF10        WKSKEY
     C                   ENDDO
 
      ** Positioning - Reference Number.
 
     C     SCPOS1        WHENNE    *BLANKS
     C                   MOVEL     SCPOS1        ACRFNO
     C                   MOVE      DSDF10        WKSKEY
     C                   ENDSL
 
      ** Clear Positioning Fields.
 
     C                   CLEAR                   SCPOS1
 
      ** Position File to Start Key.
 
     C                   MOVE      WKSKEY        DSDF10
 
     C                   EXSR      XPACRF
 
      ** Set subfile with the next group of records.
      ** i.e. Read the Criteria and for each Reference
      ** - write details to the subfile
      **
     C                   DO        WKS1MX        SCRRN1
 
     C                   EXSR      XSACRF
 
     C     *IN22         IFEQ      *ON
     C                   LEAVE
     C                   ENDIF
 
     C                   MOVE      *BLANKS       S1OPTN
     C                   MOVE      ACRFNO        S1RFNO
 
     C                   SELECT
     C     ACSTAT        WHENEQ    'CP'
     C                   MOVEL     C@STCP        S1STAT
     C     ACSTAT        WHENEQ    'CR'
     C                   MOVEL     C@STCR        S1STAT
     C     ACSTAT        WHENEQ    'PC'
     C                   MOVEL     C@STPC        S1STAT
     C     ACSTAT        WHENEQ    'DL'
     C                   MOVEL     C@STDL        S1STAT
     C     ACSTAT        WHENEQ    'RC'
     C                   MOVEL     C@STRC        S1STAT
     C     ACSTAT        WHENEQ    'RV'
     C                   MOVEL     C@STRV        S1STAT
     C     ACSTAT        WHENEQ    'RP'
     C                   MOVEL     C@STRP        S1STAT
     C                   OTHER
     C                   MOVE      *BLANKS       S1STAT
     C                   ENDSL
 
     C                   MOVEL     ACCRTD        S1CRTD
     C                   MOVEL     ACPRCD        S1PRCD
     C                   MOVEL     ACDESC        S1DESC
 
      ** Write Sub File.
 
     C                   WRITE     GL019000S1
 
      ** Position File to Start Key.
 
     C     SCRRN1        IFEQ      1
     C                   MOVE      DSDF10        WKSKEY
     C                   MOVE      *OFF          *IN82
     C                   ENDIF
     C                   ENDDO
 
      ** Evaluate if last record on file.
 
     C     *IN22         IFEQ      *OFF
 
     C                   EXSR      XSACRF
 
     C                   ENDIF
 
     C     *IN22         IFEQ      *ON
     C                   MOVE      *OFF          *IN83
     C                   ELSE
     C                   MOVE      *ON           *IN83
     C                   ENDIF
     C                   MOVE      DSDF10        WKEKEY
     C                   Z-ADD     1             SCRRN1
 
      ** Display Screen
 
     C                   WRITE     GL019000F1
     C                   WRITE     MSGCTL
     C                   WRITE     GL019000C1
 
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  XSDFD1: Set Display Format - Detail Screen (D1)              *
      *                                                               *
      *****************************************************************
     C     XSDFD1        BEGSR
 
      ** Set Criteria Details.
 
     C                   MOVE      *BLANKS       SCPOS1
     C                   MOVE      *BLANKS       S2BRNM
     C                   MOVE      *BLANKS       S2CYNM
     C                   MOVE      *BLANKS       S2ACON
     C                   MOVE      *BLANKS       S2CNNM
     C                   MOVE      *BLANKS       S2TBRN
     C                   MOVE      *BLANKS       S2TCRN
     C                   MOVE      *BLANKS       S2TACC
 
      ** Set Currency Description
 
     C     S2CCY         IFNE      *BLANKS
     C                   MOVEL     S2CCY         WKCUR
 
     C                   EXSR      XRCCY
 
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     A6CYNM        S2CYNM
     C                   ENDIF
     C                   ENDIF
 
      ** Set Branch Description
 
     C     S2BRCA        IFNE      *BLANKS
     C                   MOVEL     S2BRCA        WKBRCH
 
     C                   EXSR      XRBRCH
 
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     A8BRNM        S2BRNM
     C                   ENDIF
     C                   ENDIF
 
      ** Set Acccount Officer Description
 
     C     S2ACOC        IFNE      *BLANKS
     C                   MOVEL     S2ACOC        WKACO
 
     C                   EXSR      XRACO
 
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     AZACON        S2ACON
     C                   ENDIF
     C                   ENDIF
 
      ** Set Country Description
 
     C     S2COLC        IFNE      *BLANKS
     C                   MOVEL     S2COLC        WKCTR
 
     C                   EXSR      XRCTR
 
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     A4CNNM        S2CNNM
     C                   ENDIF
     C                   ENDIF
 
      ** Set To Branch Description
 
     C     S2TBRC        IFNE      *BLANKS
     C                   MOVEL     S2TBRC        WKBRCH
 
     C                   EXSR      XRBRCH
 
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     A8BRNM        S2TBRN
     C                   ENDIF
     C                   ENDIF
 
      ** Set To Customer Description
 
     C     S2TCNU        IFNE      *BLANKS
     C                   MOVEL     S2TCNU        WKCUS
 
     C                   EXSR      XRCUST
 
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     BBCRNM        S2TCRN
     C                   ENDIF
     C                   ENDIF
 
      ** Set To Account Code Description
 
     C     S2TACO        IFNE      *BLANKS
     C                   MOVEL     S2TACO        WKACC
 
     C                   EXSR      XRACOD
 
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     A5ACCN        S2TACC
     C                   ENDIF
     C                   ENDIF
 
      ** Display Detail Screen.
 
     C                   WRITE     GL019000F2
     C                   WRITE     MSGCTL
     C                   WRITE     GL019000D1
 
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  XSACRF: Retrieve Default Details to load Subfile             *
      *                                                               *
      *****************************************************************
     C     XSACRF        BEGSR
 
     C                   SELECT
     C     WKPOSN        WHENEQ    'SCPOS1'
     C     WKREAD        IFEQ      'P'
     C                   READP     GLACRFL0                             2122
     C                   ELSE
     C                   READ      GLACRFL0                             2122
     C                   ENDIF
     C                   OTHER
     C     WKREAD        IFEQ      'P'
     C                   READP(N)  GLACRFPD                             2122                  239243
     C                   ELSE
     C                   READ(N)   GLACRFPD                             2122                  239243
     C                   ENDIF
     C                   ENDSL
 
     C     *IN21         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL(P)  'GLACRFPD'    DBFILE
     C                   MOVEL(P)  *BLANKS       DBKEY
     C                   Z-ADD     050           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVE      *BLANKS       WKREAD
 
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  XPACRF: Position Key                                         *
      *                                                               *
      *****************************************************************
     C     XPACRF        BEGSR
 
     C                   SELECT
     C     WKPOSN        WHENEQ    'SCPOS1'
     C     KACR0         SETLL     GLACRFL0
     C                   OTHER
     C     KACRF         SETLL     GLACRFPD
     C                   ENDSL
 
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  XCPMSQ: Clear Program Message Queue                          *
      *                                                               *
      *****************************************************************
     C     XCPMSQ        BEGSR
 
     C                   CALL      'CLRERMSG'
     C                   PARM      D@PGMN        WKPGMQ           10
     C                   PARM      '*SAME'       WKPGRL            5
 
     C                   MOVEA     '00000000'    *IN(40)
     C                   MOVEA     '000'         *IN(48)
     C                   MOVEA     '00000000'    *IN(54)
     C                   MOVEA     '00000'       *IN(62)
     C                   MOVE      '0'           *IN(69)
     C                   MOVEA     '00000000'    *IN(70)
     C                   MOVEA     '000'         *IN(78)
 
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  XRACRF: Retrieve Account Criteria                            *
      *                                                               *
      *****************************************************************
     C     XRACRF        BEGSR
 
     C     SCOPTN        IFEQ      'E '                                                       239243
     C     SCOPTN        OREQ      ' E'                                                       239243
     C     KACRF         CHAIN(N)  GLACRFPD                           2021                    239243
     C                   ELSE                                                                 239243
     C     KACRF         CHAIN     GLACRFPD                           2021
     C                   ENDIF                                                                239243
 
     C     *IN21         IFEQ      *ON
     C     @UMSID        IFEQ      'CPF5027'                                                  239243
      **********         MOVEL     'XX00059'     WKMSID                              239243 BUG27219
     C                   MOVEL     'ATU0059'     WKMSID                              239243 BUG27219
 
     C                   EXSR      XSPMSQ                                                     239243
 
     C                   MOVE      '1'           *IN54                                        239243
     C                   ADD       1             WKERR                                        239243
     C                   ELSE                                                                 239243
     C     *LOCK         IN        LDA
     C                   MOVEL(P)  'GLACRFPD'    DBFILE
     C                   MOVEL(P)  ACRFNO        DBKEY
     C                   Z-ADD     060           DBASE
     C                   OUT       LDA
 
     C                   EXSR      *PSSR
 
     C                   ENDIF                                                                239243
     C                   ENDIF
 
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  XRBRCH: Retrieve/Select Branch Code                          *
      *                                                               *
      *****************************************************************
     C     XRBRCH        BEGSR
 
      ** Retrieve/Select Branch Code. If the Branch Code field
      **  contains a ? then a selection list is displayed.
 
     C                   CALL      'AOBRCHR0'                           21
     C                   PARM      '*BLANKS'     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      WKBRCH        WKBRCH
     C     SDBRCH        PARM      SDBRCH        DSFDY
 
     C     *IN21         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBRCHPD'    DBFILE
     C                   MOVEL     SDBRCH        DBKEY
     C                   Z-ADD     070           DBASE
     C                   OUT       LDA
 
     C                   EXSR      *PSSR
 
     C                   ENDIF
 
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  XRCUST: Retrieve/Select Customer Code                        *
      *                                                               *
      *****************************************************************
     C     XRCUST        BEGSR
 
     C                   CALL      'AOCUSTR0'                           21
     C                   PARM      '*BLANKS'     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      WKCUS         WKCUS            10
     C                   PARM                    @KYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C     *IN21         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCUSTPD'    DBFILE
     C                   MOVEL     SDCUST        DBKEY
     C                   Z-ADD     080           DBASE
     C                   OUT       LDA
 
     C                   EXSR      *PSSR
 
     C                   ENDIF
 
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  XRCCY: Retrieve/Select Currency Code                         *
      *                                                               *
      *****************************************************************
     C     XRCCY         BEGSR
 
      ** Retrieve/Select Currency Code. If the Currency Code field
      ** contains a ? then a selection list is displayed.
 
     C                   CALL      'AOCURRR0'                           21
     C                   PARM      '*BLANKS'     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      WKCUR         WKCUR
     C     SDCURR        PARM      SDCURR        DSFDY
 
     C     *IN21         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     SDCURR        DBKEY
     C                   Z-ADD     090           DBASE
     C                   OUT       LDA
 
     C                   EXSR      *PSSR
 
     C                   ENDIF
 
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  XRACOD: Retrieve/Select Account Code                         *
      *                                                               *
      *****************************************************************
     C     XRACOD        BEGSR
 
      ** Retrieve/Select Account Code. If the Account Code field
      ** contains a ? then a selection list is displayed.
 
     C                   CALL      'AOACODR0'                           21
     C                   PARM      '*BLANKS'     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      WKACC         WKACC
     C     SDACOD        PARM      SDACOD        DSSDY
 
     C     *IN21         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDACODPD'    DBFILE
     C                   MOVEL     SDACOD        DBKEY
     C                   Z-ADD     100           DBASE
     C                   OUT       LDA
 
     C                   EXSR      *PSSR
 
     C                   ENDIF
 
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  XRACO: Retrieve/Select Account Officer                       *
      *                                                               *
      *****************************************************************
     C     XRACO         BEGSR
 
      * Retrieve/Select Account Officer. If the Account Officer field
      * contains a ? then a selection list is displayed.
 
     C                   CALL      'AOACOFR0'                           21
     C                   PARM      '*BLANKS'     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      WKACO         WKACO
     C     SDACOF        PARM      SDACOF        DSFDY
 
     C     *IN21         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDACOFPD'    DBFILE
     C                   MOVEL     SDACOF        DBKEY
     C                   Z-ADD     110           DBASE
     C                   OUT       LDA
 
     C                   EXSR      *PSSR
 
     C                   ENDIF
 
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  XRCTR: Retrieve/Select Country Code                          *
      *                                                               *
      *****************************************************************
     C     XRCTR         BEGSR
 
      ** Retrieve/Select Country Code. If the Country Code field
      ** contains a ? then a selection list is displayed.
 
     C                   CALL      'AOCTRYR0'                           21
     C                   PARM      '*BLANKS'     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      WKCTR         WKCTR
     C     SDCTRY        PARM      SDCTRY        DSFDY
 
     C     *IN21         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCTRYPD'    DBFILE
     C                   MOVEL     SDCTRY        DBKEY
     C                   Z-ADD     120           DBASE
     C                   OUT       LDA
 
     C                   EXSR      *PSSR
 
     C                   ENDIF
 
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  XUACRF: Update Criteria Details                              *
      *                                                               *
      *****************************************************************
     C     XUACRF        BEGSR
 
     C                   UPDATE    GLACRFD0                             21
     C     *IN21         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL(P)  'GLACRFPD'    DBFILE
     C                   MOVEL(P)  'UPDATE'      DBKEY
     C                   Z-ADD     130           DBASE
     C                   OUT       LDA
 
     C                   EXSR      *PSSR
 
     C                   ENDIF
 
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  XWACRF: Write Extension Details                              *
      *                                                               *
      *****************************************************************
     C     XWACRF        BEGSR
 
     C                   WRITE     GLACRFD0                             21
     C     *IN21         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL(P)  'GLACRFPD'    DBFILE
     C                   MOVEL(P)  'WRITE'       DBKEY
     C                   Z-ADD     140           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  XDACRF: Delete Extension Details                             *
      *                                                               *
      *****************************************************************
     C     XDACRF        BEGSR
 
     C                   DELETE    GLACRFD0                             21
 
     C     *IN21         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL(P)  'GLACRFPD'    DBFILE
     C                   MOVEL(P)  'DELETE'      DBKEY
     C                   Z-ADD     150           DBASE
     C                   OUT       LDA
 
     C                   EXSR      *PSSR
 
     C                   ENDIF
 
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  XDSLAC: CALL GLC003500 to Delete Selected Accounts from      *
      *          GLSLACPD                                             *
      *                                                               *
      *****************************************************************
     C     XDSLAC        BEGSR
 
     C                   CALL      'GLC003500'                          21
     C                   PARM                    S2RFNO
     C                   PARM                    @RTCD2            2
 
     C     *IN21         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL(P)  'GLC003500'   DBFILE
     C     'Delete '     CAT       'Accounts'    DBKEY
     C                   Z-ADD     020           DBASE
     C                   OUT       LDA
 
     C                   EXSR      *PSSR
 
     C                   ENDIF
 
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  XWSLAC: CALL GLC003200 to Write Sslected Accounts to         *
      *          GLSLACPD                                             *
      *                                                               *
      *****************************************************************
     C     XWSLAC        BEGSR
 
     C                   CALL      'GLC003200'                          21
     C                   PARM                    S2RFNO
     C                   PARM                    @RTCD2            2
 
     C     *IN21         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL(P)  'GLC003200'   DBFILE
     C     'Generate'    CAT       'Accounts'    DBKEY
     C                   Z-ADD     020           DBASE
     C                   OUT       LDA
 
     C                   EXSR      *PSSR
 
     C                   ENDIF
 
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  XUSLAC: CALL GLC003400 to Reverse Selected Accounts in       *
      *          GLSLACPD                                             *
      *                                                               *
      *****************************************************************
     C     XUSLAC        BEGSR
 
     C                   CALL      'GLC003400'                          21
     C                   PARM                    S2RFNO
     C                   PARM                    @RTCD2            2
 
     C     *IN21         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL(P)  'GLC003400'   DBFILE
     C     'Reverse '    CAT       'Accounts'    DBKEY
     C                   Z-ADD     021           DBASE
     C                   OUT       LDA
 
     C                   EXSR      *PSSR
 
     C                   ENDIF
 
     C                   ENDSR
     C/EJECT                                                                                  238581
      *****************************************************************                       238581
      *                                                               *                       238581
      *  XRACCT: Retrieve/Select Account Details.                     *                       238581
      *                                                               *                       238581
      *****************************************************************                       238581
     C     XRACCT        BEGSR                                                                238581
                                                                                              238581
      ** Retrieve Account Details.                                                            238581
                                                                                              238581
     C                   CALL      'AOACCTR0'                           21                    238581
     C                   PARM      '*BLANKS'     @RTCD             7                          238581
     C                   PARM      '*KEY   '     @OPTN             7                          238581
     C                   PARM                    @RETL            10                          238581
     C                   PARM                    @CNUM             6                          238581
     C                   PARM                    @CUCD             3                          238581
     C                   PARM                    @ACCD            10                          238581
     C                   PARM                    @ACSQ             2                          238581
     C                   PARM                    @BRCA             3                          238581
     C     SDACCT        PARM      SDACCT        DSSDY                                        238581
                                                                                              238581
     C     *IN21         IFEQ      *ON                                                        238581
     C     *LOCK         IN        LDA                                                        238581
     C                   MOVEL     'ACCNTAB'     DBFILE                                       238581
     C                   MOVEL     SDACCT        DBKEY                                        238581
     C                   Z-ADD     010           DBASE                                        238581
     C                   OUT       LDA                                                        238581
                                                                                              238581
     C                   EXSR      *PSSR                                                      238581
                                                                                              238581
     C                   ENDIF                                                                238581
                                                                                              238581
     C                   ENDSR                                                                238581
     C/EJECT
      *****************************************************************
      *                                                               *
      *  XSPMSQ: Send Messages to Program Message Queue.              *
      *                                                               *
      *****************************************************************
     C     XSPMSQ        BEGSR
 
     C                   CALL      'SNDERMSG'
     C                   PARM                    WKPGMQ           10
     C                   PARM      *BLANKS       WKPGRL            5
     C                   PARM                    WKMSID            7
     C                   PARM      'GLUSRMSG'    WKMSGF           10
     C                   PARM      *BLANKS       WKMSDA          132
     C                   PARM      *BLANKS       WKMSTP            7
 
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
 
     C                   CALL      'DBERRCTL'
 
     C                   ENDIF
     C                   SETON                                        U7U8LR
     C                   RETURN
 
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR: Initial Routine                                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Clear & Populate Local dataarea with program name.
 
     C     *LOCK         IN        LDA
     C                   CLEAR                   LDA
     C                   MOVEL(P)  D@PGMN        DBPGM
     C                   OUT       LDA
 
      ** Retrieve Run Date.
 
     C                   CALL      'AOBANKR0'                           9090
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      *BLANKS       DSFDY
 
      ** If return with an error (LR seton in called program) then
      ** process for database error.
 
     C     *IN90         IFEQ      '1'
     C*****@RTCD         OREQ      '*ERROR*'                                                BUG27769
     C     @RTCD         ORNE      *BLANKS                                                  BUG27769
     C     *LOCK         IN        LDA
     C                   MOVEL(P)  'AOBANKR0'    DBFILE
     C                   MOVEL(P)  '*FIRST'      DBKEY
     C                   Z-ADD     160           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVE      BJMRDT        SCDATE
     C                   MOVEL     BJMRDT        WKDFMT            9
     C                   MOVE      BJMRDT        WKYEAR            2 0
 
     C     WKYEAR        IFLT      72
     C     WKYEAR        ADD       2000          WKCCYY            4 0
     C                   ELSE
     C     WKYEAR        ADD       1900          WKCCYY
     C                   ENDIF
 
     C                   MOVE      WKCCYY        WKDFMT
 
      ** Initialise parameters, work fields, etc.
 
     C                   MOVE      *ON           *IN10
     C                   MOVE      D@JNAM        SCWSID
     C                   MOVE      D@USRI        SCUSER
 
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  @DEFN: Definition Routine  (Not Called)                      *
      *                                                               *
      *****************************************************************
     C     @DEFN         BEGSR
 
      ** Define Data Areas
 
     C     *DTAARA       DEFINE                  LDA
 
      ** Define Variables.
 
     C     *LIKE         DEFINE    S1OPTN        WKOPTN
     C     *LIKE         DEFINE    S2BRCA        WKBRCH
     C     *LIKE         DEFINE    S2CCY         WKCUR
     C     *LIKE         DEFINE    S2ACO1        WKACC
     C     *LIKE         DEFINE    S2ACOC        WKACO
     C     *LIKE         DEFINE    S2COLC        WKCTR
     C     *LIKE         DEFINE    S2TBRC        WKBRC
 
      ** Key Lists.
 
     C     KACRF         KLIST
     C                   KFLD                    ACRFNO
 
     C     KACR0         KLIST
     C                   KFLD                    ACRFNO
 
     C     KACNM         KLIST
     C                   KFLD                    WKACNM
 
     C                   ENDSR
     C/EJECT
**   ATY - Valid Account Types
NGDRCM
