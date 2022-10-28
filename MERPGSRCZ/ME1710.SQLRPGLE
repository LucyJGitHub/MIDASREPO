     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058081
/*STD *  RPGSQLBND                                                    *                     MD058081
/*EXI *  TEXT('Midas ME Bilateral agreements maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - Message Management Module                            *
      *                                                               *
      *  ME1710 - Midas ME Bilateral Agreements Maintenance           *
      *                                                               *
      *  Function:  This program displays Bilateral Agreements        *
      *             subfile                                           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD058081           Date 11May21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      *                 CFT013  *CREATE    Date 25May00               *
      *                                                               *
      *-------------------------------------------------------------- *
      *                                                               *
      *  MD058081 - Deliverable Data Split for ME and MS              *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CFT014 - Straight-through Processing Phase 2 MT103 Messages  *
      *           Generation for FT.                                  *
      *  CFT013 - Straight-through Processing Phase 2 MT103 Messages  *
      *           Generation for non-FT.                              *
      *                                                               *
      *****************************************************************
      *
      ** Midas ME Bilateral Agreements display file
      *
     FME1710DF  CF   E             WORKSTN
     F                                     SFILE(RSFLRCD:SRRN)
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      *
      ** Midas ME Bilateral Agreement Types retrieval index
      *
     F*MEBATYL1* IF   E           K DISK                                                    MD058081
     F**********                           INFSR(*PSSR)                                     MD058081
      *
      ** Midas ME Bilateral Agreements update index
      *
     FMEBAGRL0  UF A E           K DISK
     F                                     COMMIT
     F                                     INFSR(*PSSR)
      *
      ** Midas ME Bilateral Agreements retrieval index
      *
     FMEBAGRL1  IF   E           K DISK
     F                                     INFSR(*PSSR)
      *
      ** Copyright notice for inclusion in all programs
      *
      *
      * Copyright array
      *
     D A@CPY           DS
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
      *
      ** Program data structure
      *
     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
      *
      ** Display file information data structure
      *
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      *
      ** Local data area data structure
      *
     D WLDA          E DS                  EXTNAME(LDA)
      *
      ** Data Structure for Bank's ICD access obj retrieval
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Data Structure for Branch Details access obj retrieval
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      *
      ** Data Structure for Customer Details access obj retrieval
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D  #DFAC1       E                     EXTFLD(QQDFAC)
      *
      ** Data Structure for Counterparty Nostro details
      *
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)
      *
      ** Data Structure for BIC Directory details
      *
     D MEBICD        E DS                  EXTNAME(MEBICDPD)
      *
      ** Long data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Data structure for PF/MEBAGRPD
      *
     D WDBRC         E DS                  EXTNAME(MEBAGRL0)
      *
      ** Data structure used by access program
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
     D ALPNUM          C                   CONST('ABCDEFGHIJKLMNOPQRST-
     D                                     UVWXYZ1234567890')
     D MEBATY        E DS                  EXTNAME(MEBTYJW0)                                MD058081
      *
      ** Initialize
      *
      *****************************************************************
      *
     C                   EXSR      SRINIT
      *
     C                   DO        *HIVAL
      *
      ** Initialise & load subfile page
      *
     C                   EXSR      SRIZSF
     C                   MOVEL     'N'           W0RSF             1
      *
      ** Display screen until reload requested
      *
     C     W0RSF         DOWEQ     'N'
      *
      ** Display screen
      *
     C                   EXSR      SRDSPS
      *
      ** Cancel & exit program
      *
     C   03              CAS                     SREXIT
      *
      ** Request subfile reload
      *
     C   05              CAS                     SRRQRL
      *
      ** Display next SFL page
      *
     C   27              CAS                     SRLDSF
      *
      ** Process screen input
      *
     C                   CAS                     SRPROC
     C                   END
      *
     C                   ENDDO
     C                   ENDDO
      *
      ** Terminate program
      *
     C                   MOVE      '1'           *INLR
      *****************************************************************
      /EJECT
     CSR   SRIZSF        BEGSR
      *================================================================
      ** Initialise and load subfile page
      *================================================================
      *
      ** Clear subfile
      *
     C                   SETON                                        80
     C                   WRITE     RSFLCTL
     C                   SETOFF                                       80
      *
      ** Reset no of records in subfile
      *
     C                   Z-ADD     *ZERO         WRRN              5 081
      *
     C     *LIKE         DEFINE    SEBATY        WZBATY
     C     *LIKE         DEFINE    SEBRCA        WZBRCA
     C     *LIKE         DEFINE    SEOTHP        WZOTHP
     C                   MOVE      *BLANKS       WZBATY
     C                   MOVE      *BLANKS       WZBRCA
     C                   MOVE      *BLANKS       WZOTHP
     C                   MOVEL     SEBATY        WZBATY
     C                   MOVEL     SEBRCA        WZBRCA
     C                   MOVEL     SEOTHP        WZOTHP
      *
      ** Position DBF file
      *
     C     KPOS          KLIST
     C                   KFLD                    M2BATY
     C                   KFLD                    M2BRCA
     C                   KFLD                    M2OTHP
      *
      ** Setup key
      *
     C                   MOVEL     SEBATY        M2BATY
     C                   MOVEL     SEBRCA        M2BRCA
     C                   MOVEL     SEOTHP        M2OTHP
     C     KPOS          SETLL     MEBAGRL1
     C                   READ      MEBAGRL1                             8782
      *
     C                   EXSR      SRLDSF
      *================================================================
     CSR   EXIZSF        ENDSR
      /EJECT
     CSR   SRLDSF        BEGSR
      *================================================================
      ** Load subfile page
      *================================================================
     C                   MOVE      '0'           *IN84
      *
      ** Re-establish fields in read-ahead record
      *
     C     *IN27         IFEQ      '1'
     C  N82              READP     MEBAGRL1                               90
     C  N82              READ      MEBAGRL1                               90
     C                   ENDIF
      *
      ** Start at previous highest record in SFL
      *
     C                   Z-ADD     WRRN          SRRN              5 0
     C                   Z-ADD     0             WCTR              5 0
     C                   Z-ADD     0             WCTR2             5 0
      *
      ** Set required pages based on *Set Cursor or *Subfile Pages
      *
     C     W0RR0         IFGT      0
     C     W0RR0         DIV       WSFPG         WSPG              3 0
     C                   MVR                     WSLIN             3 0
     C     WSLIN         IFGT      0
     C                   ADD       1             WSPG
     C                   END
     C     W0SPG         IFGT      WSPG
     C                   Z-ADD     W0SPG         WSPG
     C                   END
     C                   ELSE
     C                   Z-ADD     W0SPG         WSPG
     C                   END
      *
      ** Compute lines required based on pages
      *
     C     WSPG          MULT      WSFPG         WSFLN
     C     WSFLN         IFGT      999
     C                   Z-ADD     999           WSFLN
     C                   END
      *
      ** Load next SFL page until SFL page full, or
      ** Scan limit reached
      *
     C     *IN82         DOWEQ     '0'
     C     WCTR          ANDLT     WSFLN
     C     WCTR2         ANDLT     W0SLM
      *
      ** Setof record error indicators
      *
     C                   MOVE      *ALL'0'       WKIND0            9
     C                   MOVEA     WKIND0        *IN(31)
     C                   MOVE      '0'           *IN20
     C                   MOVE      '0'           *IN40
     C                   MOVE      '0'           *IN51
      *
     C     PMMODE        IFEQ      'E'
     C                   MOVE      '1'           *IN20
     C                   MOVE      '1'           *IN40
     C                   MOVE      '1'           *IN51
     C                   ENDIF
      *
     C                   EXSR      SRISFF
      *
      ** Load SFL fields
      *
     C                   EXSR      SRLSFF
     C                   MOVEL     WDBRC         SDBRC
      *
      ** Output to subfile
      *
     C                   ADD       1             SRRN
     C                   ADD       1             WCTR                 81
      *
     C                   WRITE     RSFLRCD
      *
      ** Increment scan check count
      *
     C                   ADD       1             WCTR2
     C                   READ      MEBAGRL1                               82
     C                   ENDDO
      *
      ** Save highest SFL record load can continue at end point
      *
     C     SRRN          IFGT      WRRN
      *
      ** Calculate top line
      *
     C     WCTR          DIV       WSFPG         WSPG
     C                   MVR                     WSLIN
     C     WSLIN         IFGT      0
     C     SRRN          SUB       WSLIN         SSFRC
     C                   ELSE
     C     SRRN          SUB       WSFPG         SSFRC
     C                   ENDIF
     C                   ADD       1             SSFRC
     C                   Z-ADD     SRRN          WRRN
     C                   ENDIF
      *
      ** If scan limit reached, display error message
      *
     C     WCTR2         IFGE      W0SLM
      *
      ** Send message 'Scan limit reached'
      *
     C                   MOVEL     'ME00010'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   Z-ADD     0             WCTR
     C                   ENDIF
      *================================================================
     CSR   LDEXIT        ENDSR
      /EJECT
     CSR   SRDSPS        BEGSR
      *================================================================
      ** Display screen
      *================================================================
     C     *IN82         IFEQ      '1'
     C     WRRN          ANDEQ     0
      *
      ** Send message '*No data to display'
      *
     C                   MOVEL     'ME00001'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   WRITE     RMSGCTL
      *
     C     PMMODE        IFEQ      'M'
     C                   MOVEL     WTXTC         SCTX1
     C                   ENDIF
      *
     C                   WRITE     RCMDTXT1
      *
      ** Update screen time
      *
     C                   TIME                    STIME
      *
     C                   EXFMT     RSFLCTL
      *
      ** Maintain subfile position where possible
      *
     C     @#SFRC        IFGT      *ZERO
     C                   Z-ADD     @#SFRC        SSFRC
     C                   ENDIF
      *
     C                   EXSR      SRCLR
      *================================================================
     CSR   EXDSPS        ENDSR
      /EJECT
     CSR   SRPROC        BEGSR
      *================================================================
      ** Process screen input
      *================================================================
     C     WZBATY        CASNE     SEBATY        SRRQRL
     C     WZBRCA        CASNE     SEBRCA        SRRQRL
     C     WZOTHP        CASNE     SEOTHP        SRRQRL
     C                   END
     C     W0RSF         CABEQ     'Y'           EXPROC
      *
     C     PMMODE        IFEQ      'E'
     C                   EXSR      SRRQRL
     C     W0RSF         CABEQ     'Y'           EXPROC
     C                   ENDIF
      *
     C                   MOVE      *BLANK        WERR              1
     C                   MOVE      'Y'           WNULL             1
      *
     C     WRRN          IFNE      0
      *
     C                   EXSR      SRPRS1
      *
     C     WERR          IFEQ      *BLANK
     C     WNULL         ANDEQ     'N'
     C                   EXSR      SRPRS2
     C                   ENDIF
      *
     C     WERR          IFEQ      *BLANK
     C     WNULL         ANDEQ     'N'
     C                   EXSR      SRPRS3
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     WNULL         IFEQ      'Y'
     C                   EXSR      SRRQRL
     C                   ENDIF
      *
     C     WERR          IFEQ      *BLANK
     C     *IN09         ANDEQ     '1'
     C                   MOVE      'ADD'         WMODE
     C                   MOVE      *ALL'0'       WKIND0
     C                   MOVEA     WKIND0        *IN(31)
     C                   MOVE      *BLANK        WETYP             1
     C                   MOVE      *BLANK        WEBRC             1
     C                   MOVE      *BLANKS       SBATY
     C                   MOVE      *BLANKS       SBRCA
     C                   MOVE      *BLANKS       SOTHP
     C                   MOVE      *BLANKS       SBAGD
     C                   MOVE      *BLANKS       WBBATY           10
     C                   MOVE      *BLANKS       WBBRCA            3
     C                   MOVE      *BLANKS       WBOTHP           11
     C                   MOVE      *BLANKS       WWARN2            1
     C                   MOVE      *BLANKS       WWARN3            1
      *
     C     *IN03         DOUEQ     '1'
     C     *IN12         OREQ      '1'
     C                   WRITE     RMSGCTL
     C                   MOVEL     WTXTA         SCTX1
     C                   WRITE     RCMDTXT1
     C                   TIME                    STIME
     C                   EXFMT     RADDMD
     C                   EXSR      SRCLR
      *
     C     *IN03         IFEQ      '1'
     C                   EXSR      SREXIT
     C                   ENDIF
      *
     C     *IN12         IFEQ      '1'
     C                   MOVE      'CHG'         WMODE
     C                   ELSE
     C                   MOVE      *ALL'0'       WKIND0
     C                   MOVEA     WKIND0        *IN(31)
     C                   MOVE      *BLANKS       WETYP
     C                   MOVE      *BLANKS       WEBRC
      *
     C     *IN05         IFEQ      '1'
     C                   MOVE      *BLANKS       SBATY
     C                   MOVE      *BLANKS       SBRCA
     C                   MOVE      *BLANKS       SOTHP
     C                   MOVE      *BLANKS       SBAGD
     C                   MOVE      *BLANKS       WBBATY
     C                   MOVE      *BLANKS       WBBRCA
     C                   MOVE      *BLANKS       WBOTHP
     C                   MOVE      *BLANKS       WWARN2
     C                   MOVE      *BLANKS       WWARN3
     C                   ELSE
     C                   MOVE      *BLANKS       WERROR
     C                   EXSR      SRVREC
      *
     C     WERROR        IFNE      'Y'
     C                   EXSR      SRADD
      *
     C     WERROR        IFNE      'Y'
     C                   COMMIT
     C                   MOVE      *BLANKS       SBATY
     C                   MOVE      *BLANKS       SBRCA
     C                   MOVE      *BLANKS       SOTHP
     C                   MOVE      *BLANKS       SBAGD
     C                   MOVE      *BLANKS       WBBATY
     C                   MOVE      *BLANKS       WBBRCA
     C                   MOVE      *BLANKS       WBOTHP
     C                   MOVE      *BLANKS       WWARN2
     C                   MOVE      *BLANKS       WWARN3
     C                   ELSE
     C                   MOVE      *ALL'1'       WKIND1            4
     C                   MOVEA     WKIND1        *IN(32)
     C                   ROLBK
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDIF
      *================================================================
     CSR   EXPROC        ENDSR
      /EJECT
     CSR   SRPRS1        BEGSR
      *================================================================
      ** Validate Option
      *================================================================
     C                   READC     RSFLRCD                                92
      *
      ** Process subfile record
      *
     C     *IN92         DOWEQ     '0'
      *
      ** Setof record error indicators
      *
     C                   MOVE      *ALL'0'       WKIND0
     C                   MOVEA     WKIND0        *IN(31)
     C                   MOVE      'N'           WNULL
     C                   MOVE      '1'           *IN84
     C     SCSEL         IFNE      'D'
     C     SCSEL         ANDNE     *BLANK
     C                   MOVE      '1'           *IN31
     C     WERR          IFEQ      *BLANK
     C                   MOVE      'Y'           WERR
     C                   Z-ADD     SRRN          SSFRC
     C                   MOVEL     'ME00002'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   UPDATE    RSFLRCD
     C                   READC     RSFLRCD                                92
     C                   ENDDO
      *================================================================
     CSR   EXPRS1        ENDSR
      /EJECT
     CSR   SRPRS2        BEGSR
      *================================================================
      ** Validate details
      *================================================================
     C                   READC     RSFLRCD                                92
      *
      ** Process subfile record
      *
     C     *IN92         DOWEQ     '0'
      *
      ** Setof record error indicators
      *
     C                   MOVE      *ALL'0'       WKIND0
     C                   MOVEA     WKIND0        *IN(31)
     C                   MOVE      *BLANK        WERROR            1
     C                   MOVE      'N'           WNULL
     C                   MOVE      '1'           *IN84
     C     SCSEL         IFEQ      *BLANK
     C                   EXSR      SRVREC
     C     WERROR        IFEQ      'Y'
     C     WERR          ANDEQ     *BLANK
     C                   MOVE      'Y'           WERR
     C                   Z-ADD     SRRN          SSFRC
     C                   ENDIF
     C                   ENDIF
     C                   UPDATE    RSFLRCD
     C                   READC     RSFLRCD                                92
     C                   ENDDO
      *================================================================
     CSR   EXPRS2        ENDSR
      /EJECT
     CSR   SRVREC        BEGSR
      *================================================================
      ** Validate details screen fields
      *================================================================
     C     WMODE         IFEQ      'ADD'
      *
     C     SBATY         IFEQ      *BLANKS
     C                   MOVEL     'ME00016'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN32
     C                   MOVE      'Y'           WETYP
     C                   MOVE      'Y'           WERROR
     C                   ELSE
     C*****SBATY         CHAIN     MEBATYL1                           61                    MD058081
     C/EXEC SQL                                                                             MD058081
     C+ SELECT *                                                                            MD058081
     C+ into :MEBATY                                                                        MD058081
     C+ from MEBTYJW0                                                                       MD058081
     C+ where M1BATY = :SBATY                                                               MD058081
     C/END-EXEC                                                                             MD058081
     C******IN61         IFEQ      '1'                                                      MD058081
     C     SQLCODE       IFNE      0                                                        MD058081
     C                   MOVEL     'ME00017'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN32
     C                   MOVE      'Y'           WETYP
     C                   MOVE      'Y'           WERROR
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     WMODE         IFEQ      'ADD'
      *
     C     SBRCA         IFNE      *BLANKS
     C**********           CALL 'AOBRCHR0'                                                    CGL029
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY'        @OPTN             7
     C                   PARM      SBRCA         AJCD              3
     C********** SDBRCH    PARM SDBRCH    DSFDY                                               CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'ME00019'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN33
     C                   MOVE      'Y'           WEBRC
     C                   MOVE      'Y'           WERROR
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVEL     SBATY         WBBATY
     C                   MOVEL     SBRCA         WBBRCA
      *
     C                   ENDIF
      *
     C     WMODE         IFEQ      'ADD'
     C                   MOVE      *BLANKS       WWRNX2            1
     C                   MOVE      *BLANKS       WWRNX3            1
      *
     C     SOTHP         IFEQ      *BLANKS
      *
     C     SBRCA         IFNE      *BLANKS
     C                   MOVEL     'ME00020'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN34
     C                   MOVE      'Y'           WERROR
     C                   ENDIF
      *
     C     WETYP         IFNE      'Y'
     C     SBRCA         ANDEQ     *BLANKS
     C     KTAB3         KLIST
     C                   KFLD                    W2BATY           10
     C                   KFLD                    W2BRCA            3
     C                   KFLD                    W2OTHP           11
     C                   MOVEL     SBATY         W2BATY
     C                   MOVE      *BLANKS       W2BRCA
     C                   MOVE      *BLANKS       W2OTHP
      *
     C     KTAB3         SETLL     MEBAGRL1
     C                   READ      MEBAGRL1                               61
     C     *IN61         IFEQ      '0'
     C     SBATY         ANDEQ     M2BATY
      *
     C     M2BRCA        IFNE      *BLANK
     C     M2OTHP        ANDNE     *BLANK
     C     WWARN2        ORNE      'Y'
     C                   MOVEL     'ME00021'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      *ALL'1'       WKIND3            3
     C                   MOVEA     WKIND3        *IN(32)
     C                   MOVE      'Y'           WERROR
     C                   ENDIF
      *
     C                   MOVE      'Y'           WWARN2
     C                   MOVE      'Y'           WWRNX2
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     SOTHP         IFNE      *BLANKS
     C                   EXSR      SRVOTP
     C                   ENDIF
      *
     C                   MOVEL     SOTHP         WBOTHP
      *
     C     WWRNX2        IFNE      'Y'
     C                   MOVE      *BLANKS       WWARN2
     C                   ENDIF
      *
     C     WWRNX3        IFNE      'Y'
     C                   MOVE      *BLANKS       WWARN3
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     SBAGD         IFEQ      *BLANKS
     C                   MOVEL     'ME00022'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN35
     C                   MOVE      'Y'           WERROR
     C                   ENDIF
      *================================================================
     CSR   EXVREC        ENDSR
      /EJECT
     CSR   SRVOTP        BEGSR
      *================================================================
      ** Validate entry for Other Party
      *================================================================
     C                   MOVE      *BLANKS       WWOTP             1
     C                   MOVE      *BLANKS       WOTHP            11
     C                   MOVE      *BLANKS       WOTH3             3
     C                   MOVE      *BLANKS       WOTH8             8
     C                   MOVE      SOTHP         WOTH3
     C     WOTH3         IFEQ      '***'
     C                   MOVEL     SOTHP         WOTH8
     C                   MOVEL     WOTH8         WOTHP
     C                   MOVE      *BLANKS       WOTH3
     C                   ELSE
     C                   MOVE      SOTHP         WOTHP
     C                   ENDIF
      *
     C                   MOVE      *BLANKS       WFLDC            11
     C                   MOVEL     WOTHP         WFLDC
     C                   MOVE      '0'           *IN70
     C     ALPNUM        CHECK     WFLDC         WFLDN             2 0    70
      *
     C     *IN70         IFEQ      '1'
     C     WFLDN         ANDEQ     9
     C     WOTH3         ANDEQ     *BLANKS
     C     *IN70         OREQ      '0'
     C                   CALL      'ME1400'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      WOTH8         PBICC             8
     C                   PARM      WOTH3         PBICB             3
     C                   PARM                    SDCUST
     C                   PARM                    SDCNST
     C                   PARM                    MEBICD
     C                   PARM      *BLANKS       POCUST            1
     C                   PARM      *BLANKS       POCNST            1
     C                   PARM      *BLANKS       POBICD            1
      *
     C     PRTCD         IFEQ      *BLANKS
     C                   GOTO      EXVOTP
     C                   ELSE
     C                   MOVE      'Y'           WWOTP
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     *IN70         IFEQ      '0'
     C     WWOTP         IFEQ      'Y'
     C                   EXSR      SRWOTP
     C                   ELSE
     C                   MOVEL     'ME00023'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN34
     C                   MOVE      'Y'           WERROR
     C                   ENDIF
     C                   GOTO      EXVOTP
     C                   ENDIF
      *
     C                   MOVE      *BLANKS       WCHCN6            6
     C                   MOVE      *BLANKS       WCHCN5            5
     C                   MOVEL     WOTHP         WCHCN6
     C                   MOVE      WOTHP         WCHCN5
     C                   MOVE      '0'           *IN52
     C                   TESTN                   WCHCN6               52
      *
     C     *IN52         IFEQ      '1'
     C     WCHCN5        ANDEQ     *BLANKS
     C                   MOVE      *BLANKS       WCUSTN            6
     C                   MOVE      WCHCN6        WCUSTN
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM      WCUSTN        @KEY              6
     C                   PARM      *BLANK        @KYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C     @RTCD         IFEQ      *BLANKS
      *
     C     BBCSID        IFEQ      *BLANKS
     C                   MOVEL     'ME00027'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN34
     C                   MOVE      'Y'           WERROR
     C                   GOTO      EXVOTP
     C                   ENDIF
      *
     C                   MOVEL     BBCSID        SOTHP
     C                   MOVE      *BLANKS       WBBCS3            3
     C                   MOVE      *BLANKS       WBBCS8            8
     C                   MOVEL     BBCSID        WBBCS8
     C                   MOVE      BBCSID        WBBCS3
     C                   CALL      'ME1400'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      WBBCS8        PBICC             8
     C                   PARM      WBBCS3        PBICB             3
     C                   PARM                    SDCUST
     C                   PARM                    SDCNST
     C                   PARM                    MEBICD
     C                   PARM      *BLANKS       POCUST
     C                   PARM      *BLANKS       POCNST
     C                   PARM      *BLANKS       POBICD
      *
     C     PRTCD         IFEQ      *BLANKS
     C                   GOTO      EXVOTP
     C                   ELSE
     C                   EXSR      SRWOTP
     C                   ENDIF
      *
     C                   ELSE
     C                   MOVEL     'ME00024'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN34
     C                   MOVE      'Y'           WERROR
     C                   ENDIF
     C                   GOTO      EXVOTP
     C                   ENDIF
      *
     C                   MOVE      *BLANKS       WCUSTC
     C                   MOVEL     WOTHP         WCUSTC           10
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM      WCUSTC        @KEY1            10
     C                   PARM      *BLANK        @KYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C     @RTCD         IFEQ      *BLANKS
      *
     C     BBCSID        IFEQ      *BLANKS
     C                   MOVEL     'ME00027'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN34
     C                   MOVE      'Y'           WERROR
     C                   GOTO      EXVOTP
     C                   ENDIF
      *
     C                   MOVEL     BBCSID        SOTHP
     C                   MOVE      *BLANKS       WBBCS3
     C                   MOVE      *BLANKS       WBBCS8
     C                   MOVEL     BBCSID        WBBCS8
     C                   MOVE      BBCSID        WBBCS3
      *
     C                   CALL      'ME1400'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      WBBCS8        PBICC             8
     C                   PARM      WBBCS3        PBICB             3
     C                   PARM                    SDCUST
     C                   PARM                    SDCNST
     C                   PARM                    MEBICD
     C                   PARM      *BLANKS       POCUST
     C                   PARM      *BLANKS       POCNST
     C                   PARM      *BLANKS       POBICD
      *
     C     PRTCD         IFEQ      *BLANKS
     C                   GOTO      EXVOTP
     C                   ELSE
     C                   EXSR      SRWOTP
     C                   ENDIF
      *
     C                   ELSE
      *
     C     WWOTP         IFEQ      'Y'
     C                   EXSR      SRWOTP
     C                   ELSE
     C                   MOVEL     'ME00024'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN34
     C                   MOVE      'Y'           WERROR
     C                   ENDIF
      *
     C                   ENDIF
      *================================================================
     CSR   EXVOTP        ENDSR
      /EJECT
     CSR   SRWOTP        BEGSR
      *================================================================
      ** Display warning msg for non-existing SWIFT Id entry
      ** for Other Party
      *================================================================
     C     SOTHP         IFNE      WBOTHP
     C     WWARN3        ORNE      'Y'
     C                   MOVEL     'ME00025'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN34
     C                   MOVE      'Y'           WERROR
     C                   ENDIF
     C                   MOVE      'Y'           WWARN3
     C                   MOVE      'Y'           WWRNX3
      *================================================================
     CSR   EXWOTP        ENDSR
      /EJECT
     CSR   SRPRS3        BEGSR
      *================================================================
      ** Update database
      *================================================================
     C                   MOVE      'N'           W0RSF
      *
     C                   READC     RSFLRCD                                92
      *
      ** Process subfile record
      *
     C     *IN92         DOWEQ     '0'
      *
      ** Setof record error indicators
      *
     C                   MOVE      *ALL'0'       WKIND0
     C                   MOVEA     WKIND0        *IN(31)
     C                   MOVE      *BLANK        WERROR
     C                   MOVE      '0'           *IN84
      *
     C     SCSEL         IFEQ      'D'
     C                   EXSR      SRDEL
     C                   EXSR      SRRQRL
     C                   ELSE
     C                   EXSR      SRAMD
     C                   ENDIF
      *
     C     WERROR        IFEQ      'Y'
     C                   MOVE      '1'           *IN84
     C                   MOVE      *ALL'1'       WKIND1
     C                   MOVEA     WKIND1        *IN(32)
     C     WMODE         IFEQ      'CHG'
     C                   MOVE      '1'           *IN31
     C                   MOVE      *ALL'1'       WKIND1
     C                   MOVEA     WKIND1        *IN(36)
     C                   ENDIF
      *
     C     WERR          IFEQ      *BLANK
     C                   MOVE      'Y'           WERR
     C                   Z-ADD     SRRN          SSFRC
     C                   ENDIF
      *
     C                   ROLBK
     C                   ELSE
     C                   COMMIT
     C                   ENDIF
      *
     C                   MOVE      *BLANK        SCSEL
     C                   UPDATE    RSFLRCD
     C                   READC     RSFLRCD                                92
     C                   ENDDO
      *
     C     WERR          IFNE      *BLANK
     C                   MOVE      'N'           W0RSF
     C                   ENDIF
      *================================================================
     CSR   EXPRS3        ENDSR
      /EJECT
     CSR   SRADD         BEGSR
      *================================================================
      ** Add record
      *================================================================
     C                   MOVEL     SBATY         M2BATY
     C                   MOVEL     SBRCA         M2BRCA
     C                   MOVEL     SOTHP         M2OTHP
     C     KPOS          CHAIN     @BAGRL0                            60
     C     *IN60         IFEQ      '0'
     C                   MOVEL     'ME00007'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   GOTO      EXADD
     C                   ENDIF
      *
     C                   MOVE      SBATY         M2BATY
     C                   MOVE      SBRCA         M2BRCA
     C                   MOVE      SOTHP         M2OTHP
     C                   MOVE      SBAGD         M2BAGD
     C                   MOVE      STIME         M2ACTM
     C                   MOVE      BJMRDT        M2ACDA
     C                   MOVE      BJRDNB        M2LCD
     C                   MOVE      'I'           M2ACTY
      *
     C                   WRITE     @BAGRL0                              91
      *
      ** Display error msg if file update not successful
      *
     C     *IN91         IFEQ      '1'
     C                   MOVEL     'ME00011'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   ELSE
     C                   MOVEL     'ME00026'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
      *================================================================
     CSR   EXADD         ENDSR
      /EJECT
     CSR   SRDEL         BEGSR
      *================================================================
      ** Delete record
      *================================================================
     C                   MOVEL     SBATY         M2BATY
     C                   MOVEL     SBRCA         M2BRCA
     C                   MOVEL     SOTHP         M2OTHP
     C     KPOS          CHAIN     @BAGRL0                            60
     C     *IN60         IFEQ      '1'
     C                   MOVEL     'ME00008'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   GOTO      EXDEL
     C                   ENDIF
      *
     C     WDBRC         IFNE      SDBRC
     C                   MOVEL     'ME00009'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   EXSR      SRLSFF
     C                   MOVEL     WDBRC         SDBRC
     C                   GOTO      EXDEL
     C                   ENDIF
      *
     C                   DELETE    @BAGRL0                              91
      *
      ** Display error msg if file update not successful
      *
     C     *IN91         IFEQ      '1'
     C                   MOVEL     'ME00011'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   ENDIF
      *================================================================
     CSR   EXDEL         ENDSR
      /EJECT
     CSR   SRAMD         BEGSR
      *================================================================
      ** Amend record
      *================================================================
     C                   MOVEL     SBATY         M2BATY
     C                   MOVEL     SBRCA         M2BRCA
     C                   MOVEL     SOTHP         M2OTHP
     C     KPOS          CHAIN     @BAGRL0                            60
     C     *IN60         IFEQ      '1'
     C                   MOVEL     'ME00008'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   GOTO      EXAMD
     C                   ENDIF
      *
     C     WDBRC         IFNE      SDBRC
     C                   MOVEL     'ME00009'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   EXSR      SRLSFF
     C                   MOVEL     WDBRC         SDBRC
     C                   GOTO      EXAMD
     C                   ENDIF
      *
     C                   MOVE      SBAGD         M2BAGD
     C                   MOVE      STIME         M2ACTM
     C                   MOVE      BJMRDT        M2ACDA
     C                   MOVE      BJRDNB        M2LCD
     C                   MOVE      'A'           M2ACTY
      *
     C                   UPDATE    @BAGRL0                              91
      *
      ** Display error msg if file update not successful
      *
     C     *IN91         IFEQ      '1'
     C                   MOVEL     'ME00011'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   ELSE
     C                   MOVEL     WDBRC         SDBRC
     C                   ENDIF
      *================================================================
     CSR   EXAMD         ENDSR
      /EJECT
     CSR   ZASNMS        BEGSR
      *================================================================
      ** Send message to program's message queue
      *================================================================
     C     ZAPGMQ        IFEQ      *BLANKS
     C                   MOVEL     ##PGM         ZAPGMQ
     C                   ENDIF
      *
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ           10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM                    ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C                   PARM                    ZAMSTP            7            Message type
      *================================================================
     CSR   EXSNMS        ENDSR
      /EJECT
     CSR   SRCLR         BEGSR
      *================================================================
      ** Clear messages in program queue
      *================================================================
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
      *================================================================
     CSR   EXCLR         ENDSR
      /EJECT
     CSR   SREXIT        BEGSR
      *================================================================
      ** Exit program processing
      *================================================================
     C                   SETON                                        LR
     C                   RETURN
      *================================================================
     CSR   EXEXIT        ENDSR
      /EJECT
     CSR   SRRQRL        BEGSR
      *================================================================
      ** Request subfile reload
      *================================================================
     C                   MOVEL     'Y'           W0RSF
      *================================================================
     CSR   EXRQRL        ENDSR
      /EJECT
     CSR   SRLSFF        BEGSR
      *================================================================
      ** Move MEBAGRL1 fields to subfile
      *================================================================
     C                   MOVEL     M2ACTM        SACTM
     C                   MOVEL     M2ACDA        SACDA
     C                   MOVEL     M2LCD         SLCD
     C                   MOVEL     M2ACTY        SACTY
     C                   MOVEL     M2BATY        SBATY
     C                   MOVEL     M2BRCA        SBRCA
     C                   MOVEL     M2OTHP        SOTHP
     C                   MOVEL     M2BAGD        SBAGD
      *================================================================
     CSR   EXLSFF        ENDSR
      /EJECT
     CSR   SRISFF        BEGSR
      *================================================================
      ** Initialise subfile fields
      *================================================================
     C                   MOVE      *BLANKS       SDBRC
     C                   MOVE      *BLANKS       SCSEL
     C                   MOVE      *BLANKS       SACTM
     C                   MOVE      *BLANKS       SACDA
     C                   MOVE      *BLANKS       SLCD
     C                   MOVE      *BLANKS       SACTY
     C                   MOVE      *BLANKS       SBATY
     C                   MOVE      *BLANKS       SBRCA
     C                   MOVE      *BLANKS       SOTHP
     C                   MOVE      *BLANKS       SBAGD
      *================================================================
     CSR   EXISFF        ENDSR
      /EJECT
     CSR   SRINIT        BEGSR
      *================================================================
      ** Initialisation
      *================================================================
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Entry parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C                   PARM                    PMMODE            1
      *
      ** Update LDA with initial values for DB error fields
      *
     C     *DTAARA       DEFINE    LDA           WLDA
     C     *LOCK         IN        WLDA
     C                   MOVE      *BLANKS       DBFILE
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVEL     'ME1710'      DBPGM
     C                   OUT       WLDA
      *
      ** Update Screen Time
      *
     C                   TIME                    STIME             6 0
      *
      ** Get Bank's Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*FIRST  '    P@OPTN            7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** If return with an error (LR seton in called program) then
      ** process for database error.
      *
     C     P@RTCD        IFNE      *BLANK
     C     *LOCK         IN        WLDA
     C                   MOVEL     '*FIRST'      DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE                                     1 *
     C                   Z-ADD     001           DBASE                                      ***
     C                   OUT       WLDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Get Midas Rundate
      *
     C                   MOVE      BJMRDT        SMRDT             7
      *
     C                   Z-ADD     11            WSFPG             3 0
     C                   Z-ADD     1             SSFRC
      *
      ** Maximum record number
      *
     C                   Z-ADD     *ZERO         WRRN
      *
      ** Scan limit
      *
     C                   Z-ADD     500           W0SLM             5 0
      *
      ** Subfile pages
      *
     C                   Z-ADD     1             W0SPG             3 0
     C                   Z-ADD     0             W0RR0             4 0
     C                   EXSR      SRCLR
     C                   Z-ADD     11            WSFLN             5 0
     C     PMMODE        IFEQ      'E'
      *
      ** Setup header text:
      *
     C                   MOVEL     'USR9107'     PMSGID            7            Message Identifier
     C                   MOVEL     'SDUSRMSG'    PMSGF            10
     C                   MOVE      *BLANKS       PMSGT            80
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     PMSGID        PARM      PMSGID        WQ0286            7            Message Identifier
     C     PMSGF         PARM      PMSGF         WQ0287           10            Message File Name
     C     PMSGT         PARM      PMSGT         WQ0288           80            Message Text
     C                   MOVEL     PMSGT         SURPT
      *
     C                   MOVE      *BLANKS       PMSGT            80
     C                   MOVEL     'USR3353'     PMSGID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     PMSGID        PARM      PMSGID        KE0286            7            Message Identifier
     C     PMSGF         PARM      PMSGF         KE0287           10            Message File Name
     C     PMSGT         PARM      PMSGT         KE0288           80            Message Text
     C                   MOVEL     PMSGT         SCTX1
      *
     C                   ELSE
      *
     C                   MOVEL     'SDUSRMSG'    PMSGF            10
     C                   MOVE      *BLANKS       PMSGT            80
      *
     C                   MOVEL     'USR9108'     PMSGID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     PMSGID        PARM      PMSGID        WQ0286            7            Message Identifier
     C     PMSGF         PARM      PMSGF         WQ0287           10            Message File Name
     C     PMSGT         PARM      PMSGT         WQ0288           80            Message Text
     C                   MOVEL     PMSGT         SURPT
      *
     C                   MOVE      *BLANKS       WTXTC            80
     C                   MOVE      *BLANKS       WTXTA            80
     C                   MOVE      *BLANKS       PMSGT            80
     C                   MOVEL     'USR3348'     PMSGID                         Message Identifier
      *
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     PMSGID        PARM      PMSGID        KE0286            7            Message Identifier
     C     PMSGF         PARM      PMSGF         KE0287           10            Message File Name
     C     PMSGT         PARM      PMSGT         KE0288           80            Message Text
     C                   MOVEL     PMSGT         WTXTC
      *
     C                   MOVE      *BLANKS       PMSGT            80
     C                   MOVEL     'USR3035'     PMSGID                         Message Identifier
      *
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     PMSGID        PARM      PMSGID        KE0286            7            Message Identifier
     C     PMSGF         PARM      PMSGF         KE0287           10            Message File Name
     C     PMSGT         PARM      PMSGT         KE0288           80            Message Text
     C                   MOVEL     PMSGT         WTXTA
     C                   ENDIF
      *
     C                   Z-ADD     99999         W0SLM
     C                   MOVE      *BLANKS       WMODE             3
     C                   MOVEL     'CHG'         WMODE
      *================================================================
     CSR   EXINIT        ENDSR
      /EJECT
     CSR   *PSSR         BEGSR
      *================================================================
      ** Standard db error processing
      *================================================================
      *
     C*COPY*SDCPYSRC,SDPSSRINT                                                              MD058081
     C/COPY SDCPYSRC,SDPSSRINTI                                                             MD058081
      *
      *================================================================
     CSR   EXPSSR        ENDSR
**CTDATA CPY@
(c) Finastra International Limited 2001
