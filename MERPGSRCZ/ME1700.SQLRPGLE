     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058081
/*STD *  RPGSQLBND                                                    *                     MD058081
/*EXI *  TEXT('Midas ME Bilateral agreement types maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - Message Management Module                            *
      *                                                               *
      *  ME1700 - Midas ME Bilateral Agreement Types Maintenance      *
      *                                                               *
      *  Function:  This program displays Bilateral Agreement Types   *
      *             subfile                                           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD058081           Date 11May21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG24356           Date 16Jun09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      *                 CFT013  *CREATE    Date 25May00               *
      *                                                               *
      *-------------------------------------------------------------- *
      *                                                               *
      *  MD058081 - Deliverable Data Split for ME and MS              *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG24356-Cannot add records in Bilateral Agreement Type      *
      *           Maintenance.                                        *
      *  CFT014 - Straight-through Processing Phase 2 MT103 Messages  *
      *           Generation for FT.                                  *
      *  CFT013 - Straight-through Processing Phase 2 MT103 Messages  *
      *           Generation for non-FT.                              *
      *                                                               *
      *****************************************************************
      *
      ** Midas ME Bilateral Agreement Types display file
      *
     FME1700DF  CF   E             WORKSTN
     F                                     SFILE(RSFLRCD:SRRN)
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      *
      ** Midas ME Bilateral Agreement Types retrieval index
      *
     F*MEBATYL1* IF   E           K DISK                                                    MD058081
     F**********                           INFSR(*PSSR)                                     MD058081
      *
      ** Midas ME Bilateral Agreement Types update index
      *
     F*MEBATYL0* UF A E           K DISK                                                    MD058081
     F**********                           COMMIT                                           MD058081
     F**********                           INFSR(*PSSR)                                     MD058081
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
      ** Bank's data structure
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Long data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Data structure for PF/MEBATYPD
      *
     D*WDBRC***      E DS                  EXTNAME(MEBATYL0)                                MD058081
     D WDBRC         E DS                  EXTNAME(MEBTYJW0)                                MD058081
     D                                     PREFIX(X)                                        MD058081
      *
      ** Data structure used by access program
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
     D ALPNUM          C                   CONST('ABCDEFGHIJKLMNOPQRST-
     D**********    'UVWXYZ1234567890'                                                      BUG24356
     D                                     UVWXYZ1234567890_')                                    BU
      *
     D MEBATY        E DS                  EXTNAME(MEBTYJW0)                                MD058081
      ** Initialize
      *
      *****************************************************************
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
     C     WMODE         IFNE      'ADD'
     C     *LIKE         DEFINE    SEBATY        WZBATY
     C                   MOVE      *BLANKS       WZBATY
     C                   MOVEL     SEBATY        WZBATY
      *
      ** Position DBF file
      *
     C     KPOS          KLIST
     C                   KFLD                    M1BATY
      *
      ** Setup key
      *
     C                   MOVEL     SEBATY        M1BATY
     C*****KPOS*         SETLL     MEBATYL1                                                 MD058081
     C**********         READ      MEBATYL1                             8782                MD058081
     C/EXEC SQL                                                                             MD058081
     C+ close ACursor                                                                       MD058081
     C/END-EXEC                                                                             MD058081
                                                                                            MD058081
     C/EXEC SQL                                                                             MD058081
     C+ declare ACursor insensitive scroll cursor for                                       MD058081
     C+ select * from MEBTYJW0                                                              MD058081
     C+ where M1BATY >= :M1BATY                                                             MD058081
     C+ order by M1BATY                                                                     MD058081
     C/END-EXEC                                                                             MD058081
                                                                                            MD058081
     C/EXEC SQL                                                                             MD058081
     C+ open ACursor                                                                        MD058081
     C/END-EXEC                                                                             MD058081
                                                                                            MD058081
     C/EXEC SQL                                                                             MD058081
     C+ fetch next from ACursor into :MEBATY                                                MD058081
     C/END-EXEC                                                                             MD058081
                                                                                            MD058081
     C                   setoff                                       82                    MD058081
     C                   If        SQLCODE = 100                                            MD058081
     C                   seton                                        82                    MD058081
     C                   Endif                                                              MD058081
                                                                                            MD058081
     C                   ELSE
     C                   MOVE      '0'           *IN82
     C                   ENDIF
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
     C     WMODE         ANDNE     'ADD'
     C**N82*****         READP     MEBATYL1                               90                MD058081
     C**N82*****         READ      MEBATYL1                               90                MD058081
     C                   If        *IN82 = '0'                                              MD058081
     C/EXEC SQL                                                                             MD058081
     C+ fetch prior from ACursor into :MEBATY                                               MD058081
     C/END-EXEC                                                                             MD058081
     C/EXEC SQL                                                                             MD058081
     C+ fetch next from ACursor into :MEBATY                                                MD058081
     C/END-EXEC                                                                             MD058081
     C                   Endif                                                              MD058081
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
     C                   ENDIF
     C     W0SPG         IFGT      WSPG
     C                   Z-ADD     W0SPG         WSPG
     C                   ENDIF
     C                   ELSE
     C                   Z-ADD     W0SPG         WSPG
     C                   ENDIF
      *
      ** Compute lines required based on pages
      *
     C     WSPG          MULT      WSFPG         WSFLN
     C     WSFLN         IFGT      999
     C                   Z-ADD     999           WSFLN
     C                   ENDIF
      *
     C     WMODE         IFEQ      'ADD'                                                    MD058081
     C                   eval      SQLCODE = 0                                              MD058081
     C                   ENDIF                                                              MD058081
      ** Load next SFL page until SFL page full, or
      ** Scan limit reached
      *
     C******IN82         DOWEQ     '0'                                                      MD058081
     C     SQLCODE       DOWEQ     0                                                        MD058081
     C     WCTR          ANDLT     WSFLN
     C     WCTR2         ANDLT     W0SLM
      *
      ** Setof record error indicators
      *
     C                   MOVE      *ALL'0'       WKIND0            3
     C                   MOVEA     WKIND0        *IN(31)
     C                   MOVE      '0'           *IN20
     C                   MOVE      '0'           *IN21
     C                   MOVE      '0'           *IN40
     C                   MOVE      '0'           *IN50
     C                   MOVE      '0'           *IN51
      *
     C     PMMODE        IFEQ      'E'
     C                   MOVE      '1'           *IN20
     C                   MOVE      '1'           *IN40
     C                   MOVE      '1'           *IN51
     C                   ELSE
     C     WMODE         IFEQ      'ADD'
     C                   MOVE      '1'           *IN50
     C                   ENDIF
     C     WMODE         IFEQ      'CHG'
     C                   MOVE      '1'           *IN21
     C                   ENDIF
     C                   ENDIF
      *
     C                   EXSR      SRISFF
      *
     C     WMODE         IFNE      'ADD'
      *
      ** Load SFL fields
      *
     C                   EXSR      SRLSFF
     C                   eval      WDBRC = M1BATY                                           MD058081
     C                   MOVEL     WDBRC         SDBRC
     C                   ENDIF
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
     C     WMODE         IFNE      'ADD'
     C**********         READ      MEBATYL1                               82                MD058081
     C/EXEC SQL                                                                             MD058081
     C+ fetch next from ACursor into :MEBATY                                                MD058081
     C/END-EXEC                                                                             MD058081
     C                   ENDIF
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
     CSR   EXLDSF        ENDSR
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
     C     WMODE         IFEQ      'CHG'
     C                   MOVEL     WTXTC         SCTX1
     C                   ELSE
     C                   MOVEL     WTXTA         SCTX1
     C                   ENDIF
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
     C     WMODE         IFNE      'ADD'
     C     WZBATY        ANDNE     SEBATY
     C                   EXSR      SRRQRL
     C     W0RSF         CABEQ     'Y'           EXPROC
     C                   ENDIF
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
     C     WMODE         IFEQ      'CHG'
     C                   EXSR      SRPRS1
     C                   ENDIF
      *
     C     WERR          IFEQ      *BLANK
     C     WNULL         ANDEQ     'N'
     C     WMODE         OREQ      'ADD'
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
     C     WERR          IFEQ      *BLANK
     C     *IN09         ANDEQ     '1'
     C     WMODE         IFEQ      'ADD'
     C                   MOVE      'CHG'         WMODE
     C                   ELSE
     C                   MOVE      'ADD'         WMODE
     C                   ENDIF
     C                   EXSR      SRRQRL
     C                   ENDIF
      *
     C     WNULL         IFEQ      'Y'
     C                   EXSR      SRRQRL
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
     C                   MOVEL     *ALL'0'       WKIND0
     C                   MOVEA     WKIND0        *IN(31)
     C                   MOVE      'N'           WNULL
     C                   MOVE      '1'           *IN84
     C     SCSEL         IFNE      'D'
     C     SCSEL         ANDNE     *BLANK
     C                   MOVE      '1'           *IN33
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
     C                   MOVEL     *ALL'0'       WKIND0
     C                   MOVEA     WKIND0        *IN(31)
     C                   MOVE      *BLANK        WERROR            1
     C                   MOVE      '0'           *IN84
     C     WMODE         IFEQ      'CHG'
     C     SBATY         ORNE      *BLANKS
     C     SBATD         ORNE      *BLANKS
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
     C     SBATD         ANDNE     *BLANKS
     C                   MOVEL     'ME00012'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN31
     C                   MOVE      'Y'           WERROR
     C                   ENDIF
      *
     C     SBATY         IFNE      *BLANKS
     C                   MOVE      *BLANKS       WFLDC
     C                   MOVEL     SBATY         WFLDC            10
     C                   MOVE      '0'           *IN70
     C     ALPNUM        CHECK     WFLDC         N                 2 0    70
     C     *IN70         IFEQ      '1'
     C     11            SUB       N             Y                 2 0
     C                   MOVE      *BLANK        WCHR             10
     C     Y             SUBST     WFLDC:N       WCHR
     C     WCHR          IFNE      *BLANK
     C                   MOVEL     'ME00014'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN31
     C                   MOVE      'Y'           WERROR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     SBATD         IFEQ      *BLANKS
     C     SBATY         ANDNE     *BLANKS
     C                   MOVEL     'ME00015'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN32
     C                   MOVE      'Y'           WERROR
     C                   ENDIF
      *================================================================
     CSR   EXVREC        ENDSR
      /EJECT
     CSR   SRPRS3        BEGSR
      *================================================================
      ** Update database
      *================================================================
     C     WMODE         IFEQ      'ADD'
     C                   EXSR      SRRQRL
     C                   ELSE
     C                   MOVE      'N'           W0RSF
     C                   ENDIF
      *
     C                   READC     RSFLRCD                                92
      *
      ** Process subfile record
      *
     C     *IN92         DOWEQ     '0'
      *
      ** Setof record error indicators
      *
     C                   MOVEL     *ALL'0'       WKIND0
     C                   MOVEA     WKIND0        *IN(31)
     C                   MOVE      *BLANK        WERROR
     C                   MOVE      '0'           *IN84
      *
     C     WMODE         IFEQ      'ADD'
     C                   EXSR      SRADD
     C                   ELSE
     C     SCSEL         IFEQ      'D'
     C                   EXSR      SRDEL
     C                   EXSR      SRRQRL
     C                   ELSE
     C                   EXSR      SRAMD
     C                   ENDIF
     C                   ENDIF
      *
     C     WERROR        IFEQ      'Y'
     C                   MOVE      '1'           *IN84
     C                   MOVE      '1'           *IN31
     C                   MOVE      '1'           *IN32
     C     *IN50         IFEQ      '0'
     C     *IN51         ANDEQ     '0'
     C                   MOVE      '1'           *IN33
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
     C*****SBATY         CHAIN     @BATYL0                            60                    MD058081
     C/EXEC SQL                                                                             MD058081
     C+ SELECT *                                                                            MD058081
     C+ into :MEBATY                                                                        MD058081
     C+ from MEBTYJW0                                                                       MD058081
     C+ where M1BATY = :SBATY                                                               MD058081
     C/END-EXEC                                                                             MD058081
     C******IN60         IFEQ      '0'                                                      MD058081
     C     SQLCODE       IFEQ      0                                                        MD058081
     C                   MOVEL     'ME00007'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   GOTO      EXADD
     C                   ENDIF
      *
     C                   MOVE      SBATY         M1BATY
     C                   MOVE      SBATD         M1BATD
     C                   MOVE      ##JOB         M1ACJN
     C                   MOVE      ##USR         M1ACUN
     C                   MOVE      STIME         M1ACTM
     C                   MOVE      BJMRDT        M1ACDA
     C                   MOVE      'I'           M1ACTY
      *
     C**********         WRITE     @BATYL0                              91                  MD058081
     C/EXEC SQL                                                                             MD058081
     C+ insert into MEBTYBTD                                                                MD058081
     C+ (                                                                                   MD058081
     C+   M1BATY                                                                            MD058081
     C+  ,M1BATD                                                                            MD058081
     C+  ,M1ACJN                                                                            MD058081
     C+  ,M1ACUN                                                                            MD058081
     C+  ,M1ACTM                                                                            MD058081
     C+  ,M1ACDA                                                                            MD058081
     C+  ,M1ACTY                                                                            MD058081
     C+  ,M1MODE                                                                            MD058081
     C+ )                                                                                   MD058081
     C+ Values                                                                              MD058081
     C+ (                                                                                   MD058081
     C+   :M1BATY                                                                           MD058081
     C+  ,:M1BATD                                                                           MD058081
     C+  ,:M1ACJN                                                                           MD058081
     C+  ,:M1ACUN                                                                           MD058081
     C+  ,:M1ACTM                                                                           MD058081
     C+  ,:M1ACDA                                                                           MD058081
     C+  ,:M1ACTY                                                                           MD058081
     C+  ,'B'                                                                               MD058081
     C+ )                                                                                   MD058081
     C/END-EXEC                                                                             MD058081
     C/EXEC SQL                                                                             MD058081
     C+ insert into MEBTYXTD                                                                MD058081
     C+ (                                                                                   MD058081
     C+   M1BATY                                                                            MD058081
     C+  ,M1BATD                                                                            MD058081
     C+  ,M1ACJN                                                                            MD058081
     C+  ,M1ACUN                                                                            MD058081
     C+  ,M1ACTM                                                                            MD058081
     C+  ,M1ACDA                                                                            MD058081
     C+  ,M1ACTY                                                                            MD058081
     C+  ,M1MODE                                                                            MD058081
     C+ )                                                                                   MD058081
     C+ Values                                                                              MD058081
     C+ (                                                                                   MD058081
     C+   :M1BATY                                                                           MD058081
     C+  ,:M1BATD                                                                           MD058081
     C+  ,:M1ACJN                                                                           MD058081
     C+  ,:M1ACUN                                                                           MD058081
     C+  ,:M1ACTM                                                                           MD058081
     C+  ,:M1ACDA                                                                           MD058081
     C+  ,:M1ACTY                                                                           MD058081
     C+  ,'B'                                                                               MD058081
     C+ )                                                                                   MD058081
     C/END-EXEC                                                                             MD058081
      *
      ** Display error msg if file update not successful
      *
     C******IN91         IFEQ      '1'                                                      MD058081
     C     SQLCODE       IFNE      0                                                        MD058081
     C                   MOVEL     'ME00011'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   ENDIF
      *================================================================
     CSR   EXADD         ENDSR
      /EJECT
     CSR   SRDEL         BEGSR
      *================================================================
      ** Delete record
      *================================================================
     C*****SBATY         CHAIN     @BATYL0                            60                    MD058081
     C/EXEC SQL                                                                             MD058081
     C+ SELECT *                                                                            MD058081
     C+ into :MEBATY                                                                        MD058081
     C+ from MEBTYJW0                                                                       MD058081
     C+ where M1BATY = :SBATY                                                               MD058081
     C/END-EXEC                                                                             MD058081
     C******IN60         IFEQ      '1'                                                      MD058081
     C     SQLCODE       IFEQ      100                                                      MD058081
     C                   MOVEL     'ME00008'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   GOTO      EXDEL
     C                   ENDIF
      *
     C                   eval      WDBRC = M1BATY                                           MD058081
     C     WDBRC         IFNE      SDBRC
     C                   MOVEL     'ME00009'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   EXSR      SRLSFF
     C                   eval      WDBRC = M1BATY                                           MD058081
     C                   MOVEL     WDBRC         SDBRC
     C                   GOTO      EXDEL
     C                   ENDIF
      *
      * all records should be bespoke                                                       MD058081
     C**********         DELETE    @BATYL0                              91                  MD058081
     C                   If        M1MODE = 'B'                                             MD058081
     C/EXEC SQL                                                                             MD058081
     C+ delete from MEBTYBTD                                                                MD058081
     C+ where M1BATY = :SBATY                                                               MD058081
     C/END-EXEC                                                                             MD058081
     C/EXEC SQL                                                                             MD058081
     C+ delete from MEBTYXTD                                                                MD058081
     C+ where M1BATY = :SBATY                                                               MD058081
     C/END-EXEC                                                                             MD058081
     C                   Endif                                                              MD058081
      *
      ** Display error msg if file update not successful
      *
     C******IN91         IFEQ      '1'                                                      MD058081
     C     SQLCODE       IFNE      0                                                        MD058081
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
     C*****SBATY         CHAIN     @BATYL0                            60                    MD058081
     C/EXEC SQL                                                                             MD058081
     C+ SELECT *                                                                            MD058081
     C+ into :MEBATY                                                                        MD058081
     C+ from MEBTYJW0                                                                       MD058081
     C+ where M1BATY = :SBATY                                                               MD058081
     C/END-EXEC                                                                             MD058081
     C******IN60         IFEQ      '1'                                                      MD058081
     C     SQLCODE       IFEQ      100                                                      MD058081
     C                   MOVEL     'ME00008'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   GOTO      EXAMD
     C                   ENDIF
      *
     C                   eval      WDBRC = M1BATY                                           MD058081
     C     WDBRC         IFNE      SDBRC
     C                   MOVEL     'ME00009'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   EXSR      SRLSFF
     C                   eval      WDBRC = M1BATY                                           MD058081
     C                   MOVEL     WDBRC         SDBRC
     C                   GOTO      EXAMD
     C                   ENDIF
      *
     C                   MOVE      SBATD         M1BATD
     C                   MOVE      ##JOB         M1ACJN
     C                   MOVE      ##USR         M1ACUN
     C                   MOVE      STIME         M1ACTM
     C                   MOVE      BJMRDT        M1ACDA
     C                   MOVE      'A'           M1ACTY
      *
     C**********         UPDATE    @BATYL0                              91                  MD058081
     C/EXEC SQL                                                                             MD058081
     C+ update MEBTYXTD set                                                                 MD058081
     C+   M1BATD = :M1BATD                                                                  MD058081
     C+  ,M1ACJN = :M1ACJN                                                                  MD058081
     C+  ,M1ACUN = :M1ACUN                                                                  MD058081
     C+  ,M1ACTM = :M1ACTM                                                                  MD058081
     C+  ,M1ACDA = :M1ACDA                                                                  MD058081
     C+  ,M1ACTY = :M1ACTY                                                                  MD058081
     C+ where M1BATY = :SBATY                                                               MD058081
     C/END-EXEC                                                                             MD058081
      *
      ** Display error msg if file update not successful
      *
     C******IN91         IFEQ      '1'                                                      MD058081
     C     SQLCODE       IFNE      0                                                        MD058081
     C                   MOVEL     'ME00011'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   ELSE
     C                   eval      WDBRC = M1BATY                                           MD058081
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
      ** Move MEBATYL1 fields to subfile
      *================================================================
     C                   MOVEL     M1ACJN        SACJN
     C                   MOVEL     M1ACUN        SACUN
     C                   MOVEL     M1ACTM        SACTM
     C                   MOVEL     M1ACDA        SACDA
     C                   MOVEL     M1ACTY        SACTY
     C                   MOVEL     M1BATY        SBATY
     C                   MOVEL     M1BATD        SBATD
      *================================================================
     CSR   EXLSFF        ENDSR
      /EJECT
     CSR   SRISFF        BEGSR
      *================================================================
      ** Initialise subfile fields
      *================================================================
     C                   MOVE      *BLANKS       SDBRC
     C                   MOVE      *BLANKS       SCSEL
     C                   MOVE      *BLANKS       SACJN
     C                   MOVE      *BLANKS       SACUN
     C                   MOVE      *BLANKS       SACTM
     C                   MOVE      *BLANKS       SACDA
     C                   MOVE      *BLANKS       SACTY
     C                   MOVE      *BLANKS       SBATY
     C                   MOVE      *BLANKS       SBATD
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
     C                   MOVEL     'ME1700'      DBPGM
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
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     001           DBASE
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
     C                   MOVEL     'USR9105'     PMSGID            7            Message Identifier
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
     C                   MOVEL     'USR9106'     PMSGID            7            Message Identifier
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
     C                   MOVEL     'USR9102'     PMSGID                         Message Identifier
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
