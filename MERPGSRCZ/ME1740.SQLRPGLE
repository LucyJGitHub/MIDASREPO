     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058081
/*STD *  RPGSQLBND                                                    *                     MD058081
/*EXI *  TEXT('Midas ME SWIFT ISO country codes maintenance')         *
      *****************************************************************
      *                                                               *
      *  Midas - Message Management Module                            *
      *                                                               *
      *  ME1740 - Midas ME SWIFT ISO Country Codes Maintenance        *
      *                                                               *
      *  Function:  This program displays Country Codes subfile       *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD058081           Date 11May21               *
      *  Prev Amend No. MD048931           Date 19Dec17               *
      *                 MD046248           Date 27Oct17               *
      *                 CFT051             Date 02Jun15               *
      *                 MD023040           Date 25Oct13               *
      *                 MD023517           Date 18Nov13               *
      *                 MD023261           Date 05Nov13               *
      *                 MD023086           Date 28Oct13               *
      *                 MD023471           Date 14Nov13               *
      *                 MD023458           Date 14Nov13               *
      *                 MD023358           Date 11Nov13               *
      *                 MD022957           Date 31Oct13               *
      *                 MD023077           Date 03Nov13               *
      *                 MD022942           Date 18Oct13               *
      *                 MD022777           Date 17Oct13               *
      *                 MD022749           Date 10Oct13               *
      *                 MD022592           Date 02Oct13               *
      *                 MD022401           Date 13Sep13               *
      *                 MD022005           Date 10Sep13               *
      *                 MD022293           Date 08Sep13               *
      *                 MD021957           Date 06Sep13               *
      *                 MD022295           Date 10Sep13               *
      *                 MD021995           Date 08Sep13               *
      *                 CSW213             Date 03Jun13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 255919             Date 06Aug08               *
      *                 BUG14933           Date 02Oct07               *
      *                 CSW207A            Date 24Jul07               *
      *                 CSW207             Date 07Jul07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032             Date 11Sep06               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CFT017             Date 12Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014  *CREATE    Date 25May00               *
      *                                                               *
      *-------------------------------------------------------------- *
      *                                                               *
      *  MD058081 - Deliverable Data Split for ME and MS              *
      *  MD048931 - Remove the limit of 10 for BBAN Bank Length field *
      *  MD046248 - Finastra Rebranding                               *
      *  CFT051 - SWIFTRef Directories 2014                           *
      *  MD023040 - Any entry in BBAN Bank Length is only allowed if  *
      *             BBAN Length is greater than zero.                 *
      *  MD023517 - Validation for M3IBAR should only be mandatory if *
      *             IBAN Country Code is inputted.                    *
      *  MD023261 - IBAN Structure Fields when ISO ctry code and IBAN *
      *             ctry code and ISO ctry code are not the same are  *
      *             disabled but has underlines (Recompile)           *
      *  MD023086 - Incorrect screen title for enquired ISOM in       *
      *             enquiry menu.                                     *
      *  MD023471 - Delete is not working properly when done the 2nd  *
      *             time                                              *
      *  MD023458 - Account Number Length may only be input when the  *
      *             IBAN Country code is input but Account number     *
      *             length is disabled.                               *
      *  MD023358 - SWIFTRef Country Code Description should be       *
      *             extracted from MEBICCPD and not MEBIB3PD.         *
      *  MD022957 - Defaulting is not working when the value is zero. *
      *  MD023077 - No Error Message Generated                        *
      *  MD022942 - Changed indicator used for IBAN Required field.   *
      *  MD022777 - Field "IBAN Required in MT103+" should not be     *
      *             dependent on CFT050.
      *  MD022749 - No details shown for Enquiry ISOE                 *
      *  MD022592 - Error encountered but amend was accepted          *
      *  MD022401 - Inconsistent behavior, some fields default to '0' *
      *  MD022005 - IBAN Structure fields are amendable when ISO      *
      *             country code and IBAN country code are different  *
      *  MD022293 - No warning message displayed when ISO country code*
      *             is not in SWIFTRef Country code file.             *
      *  MD021957 - Incorrect error description in Branch Id Start    *
      *             Position field                                    *
      *  MD022295 - BBAN Length Error Message exists unexpectedly     *
      *  MD021995 - No validation on field Account Number Start       *
      *             Position when Account Number Length is 0 or blank *
      *  CSW213 - SWIFT Changes 2013                                  *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *  255919 - Reversed checking of CSW207 on when sending error   *
      *           ME00003.  It is not possible to add new ISO country *
      *           code when CSW207 is ON.                             *
      *  BUG14933 - Error in checking switchable feature CSW207       *
      *  CSW207A - SWIFT 2007 Changes (Recompile)                     *
      *  CSW207 - SWIFT 2007 Standard Changes                         *
      *  CFT032 - Account line in field 50X in MT103                  *
      *  CFT017 - Multilateral Inter-bank Exchange Fee.               *
      *  CFT014 - Straight-through Processing Phase 2 MT103 Messages  *
      *           Generation for FT.                                  *
      *                                                               *
      *****************************************************************
      *
      ** Midas ME SWIFT ISO Country Codes display file
      *
     FME1740DF  CF   E             WORKSTN
     F                                     SFILE(RSFLRCD:SRRN)
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
     F                                     SFILE(RSFLRCDB:SRRNB)
      *
      ** Midas ME SWIFT ISO Country Codes retrieval index
      *
     F*MEISOCL1* IF   E           K DISK                                                    MD058081
     F**********                           INFSR(*PSSR)                                     MD058081
      *                                                                                       CSW213
      ** Midas ME SWIFT ISO country codes with IBAN Country Code                              CSW213
      *                                                                                       CSW213
     F*MEISOCL3* IF   E           K DISK                                                    MD058081
     F**********                           INFSR(*PSSR)                                     MD058081
      *                                                                                       CSW213
      ** Midas ME BIC Countries file by country retrieval                                     CSW213
      *                                                                                       CSW213
     FMEBICCL1  IF   E           K DISK
     F                                     INFSR(*PSSR)
      *                                                                                       CSW213
      ** Midas SWIFTRef IBAN Plus Structure                                                   CSW213
      *                                                                                       CSW213
     FMEIBNSL0  IF   E           K DISK
     F                                     INFSR(*PSSR)
      *                                                                                       CSW213
      ** Midas SWIFTRef IBAN Plus Structure                                                   CSW213
      *                                                                                       CSW213
     F***MEBIB3L3IF  E           K        DISK                                       CSW213 MD023358
     F**********                                    KINFSR *PSSR                     CSW213 MD023358
      *
      ** Midas ME SWIFT ISO Country Codes update index
      *
     F*MEISOCL0* UF A E           K DISK                                                    MD058081
     F**********                           COMMIT                                           MD058081
     F**********                           INFSR(*PSSR)                                     MD058081
      *                                                                                       CSW213
      ** Midas SD Country codes update                                                        CSW213
      *                                                                                       CSW213
     FSDCTRYL2  UF   E           K DISK
     F                                     COMMIT
     F                                     INFSR(*PSSR)
      *
      ** Copyright notice for inclusion in all programs
      * Copyright array
      *
     D A@CPY           DS
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
      *
      *
      *COPY*ZSRSRC,ZDATE2Z1                                                          CSW213 MD058081
      /COPY ZSRSRC,ZDATE2Z1LE                                                               MD058081
      *COPY*ZSRSRC,ZALIGNZ1                                                          CSW213 MD058081
      /COPY ZSRSRC,ZALIGNZ1LE                                                               MD058081
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
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** SAR Details Accessed via access program                                              CFT017
      *                                                                                       CFT017
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Data structure for PF/MEISOCPD
      *
     D*WDBRC***      E DS                  EXTNAME(MEISOCL0)                                MD058081
     D WDBRC         E DS                  EXTNAME(MEISOJW0)                                MD058081
     D                                     PREFIX(X)                                        MD058081
      *
     D MEISOC        E DS                  EXTNAME(MEISOJW0)                                MD058081
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)                                MD058081
      ** Data structure used by access program
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
     D ALPNUM          C                   CONST('ABCDEFGHIJKLMNOPQRST-
     D                                     UVWXYZ1234567890')
      *                                                                                       CSW213
     D ALPONL          C                   CONST('ABCDEFGHIJKLMNOPQRST-
     D                                     UVWXYZ')
      *
      ** Initialize
      *
     D TotRow          S              3  0                                                  MD058081
      *****************************************************************
     C                   EXSR      SRINIT
      *
     C     CSW213        IFEQ      'Y'
     C     CFT050        OREQ      'Y'
     C                   EXSR      SMAINB
     C                   ELSE
      *                                                                                       CSW213
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
     C                   ENDIF
      *                                                                                       CSW213
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
     C********** *LIKE     DEFN SEISOC    WZISOC                                              CSW213
     C                   MOVE      *BLANKS       WZISOC
     C                   MOVEL     SEISOC        WZISOC
      *
      ** Position DBF file
      *
     C********** KPOS      KLIST                                                              CSW213
     C**********           KFLD           M3ISOC                                              CSW213
      *
      ** Setup key
      *
     C                   MOVEL     SEISOC        M3ISOC
     C*****KPOS*         SETLL     MEISOCL1                                                 MD058081
     C**********         READ      MEISOCL1                             8782                MD058081
     C/EXEC SQL                                                                             MD058081
     C+ close ACursor                                                                       MD058081
     C/END-EXEC                                                                             MD058081
                                                                                            MD058081
     C/EXEC SQL                                                                             MD058081
     C+ declare ACursor insensitive scroll cursor for                                       MD058081
     C+ select * from MEISOJW0                                                              MD058081
     C+ where M3ISOC >= :M3ISOC                                                             MD058081
     C+ order by M3ISOC                                                                     MD058081
     C/END-EXEC                                                                             MD058081
                                                                                            MD058081
     C/EXEC SQL                                                                             MD058081
     C+ open ACursor                                                                        MD058081
     C/END-EXEC                                                                             MD058081
                                                                                            MD058081
     C/EXEC SQL                                                                             MD058081
     C+ fetch next from ACursor into :MEISOC                                                MD058081
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
     C**N82*****         READP     MEISOCL1                               90                MD058081
     C**N82*****         READ      MEISOCL1                               90                MD058081
     C                   If        *IN82 = '0'                                              MD058081
     C/EXEC SQL                                                                             MD058081
     C+ fetch prior from ACursor into :MEISOC                                               MD058081
     C/END-EXEC                                                                             MD058081
     C/EXEC SQL                                                                             MD058081
     C+ fetch next from ACursor into :MEISOC                                                MD058081
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
     C                   MOVE      *ALL'0'       WKIND0            4
     C                   MOVEA     WKIND0        *IN(31)
     C                   MOVE      '0'           *IN36
     C                   MOVE      '0'           *IN38
     C                   MOVE      '0'           *IN20
     C                   MOVE      '0'           *IN21
     C                   MOVE      '0'           *IN40
     C                   MOVE      '0'           *IN41
     C                   MOVE      '0'           *IN42
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
     C                   eval      WDBRC = M3ISOC                                           MD058081
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
     C**********         READ      MEISOCL1                               82                MD058081
     C/EXEC SQL                                                                             MD058081
     C+ fetch next from ACursor into :MEISOC                                                MD058081
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
     C     WZISOC        ANDNE     SEISOC
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
     C                   MOVE      '0'           *IN36
     C                   MOVE      '0'           *IN38
     C                   MOVE      '0'           *IN41
     C                   MOVE      '0'           *IN42
     C                   MOVE      'N'           WNULL
     C                   MOVE      '1'           *IN84
     C     SCSEL         IFNE      'D'
     C     SCSEL         ANDNE     *BLANK
     C                   MOVE      '1'           *IN34
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
     C                   MOVE      '0'           *IN36
     C                   MOVE      '0'           *IN38
     C                   MOVE      '0'           *IN41
     C                   MOVE      '0'           *IN42
     C                   MOVE      *BLANK        WERROR            1
     C                   MOVE      '0'           *IN84
     C     WMODE         IFEQ      'CHG'
     C     SISOC         ORNE      *BLANKS
     C     SISOD         ORNE      *BLANKS
     C     SSCHT         ORNE      *BLANKS
     C     SSEEA         ORNE      *BLANKS
     C********** SFATF     ORNE *BLANKS                                                CFT032 CSW207
     C     CFT017        ANDEQ     'Y'
     C     SFATF         ORNE      *BLANKS
     C     SMFID         ORNE      *BLANKS
     C     CSW207        ANDEQ     'Y'
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
     C     WMODE         OREQ      'LST'
      *
     C     SISOC         IFEQ      *BLANKS
     C     SISOD         ANDNE     *BLANKS
     C     SISOC         OREQ      *BLANKS
     C     SSCHT         ANDNE     *BLANKS
     C     SISOC         OREQ      *BLANKS
     C     SSEEA         ANDNE     *BLANKS
     C********** SISOC     OREQ *BLANKS                                                CFT032 CSW207
     C********** SFATF     ANDNE*BLANKS                                                CFT032 CSW207
     C     CFT017        ANDEQ     'Y'
     C     SISOC         OREQ      *BLANKS
     C     SFATF         ANDNE     *BLANKS
     C     SISOC         OREQ      *BLANKS
     C     SMFID         ANDNE     *BLANKS
     C********** CSW207    OREQ 'Y'                                                    CSW207 255919
     C                   MOVEL     'ME00003'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN31
     C                   MOVE      'Y'           WERROR
     C                   ENDIF
      *
     C     SISOC         IFNE      *BLANKS
     C                   MOVE      *BLANKS       WFLDC
     C                   MOVEL     SISOC         WFLDC             2
     C                   MOVE      '0'           *IN70
     C     ALPNUM        CHECK     WFLDC                                  70
     C     *IN70         IFEQ      '1'
     C                   MOVEL     'ME00004'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN31
     C                   MOVE      'Y'           WERROR
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     SISOD         IFEQ      *BLANKS
     C     SISOC         ANDNE     *BLANKS
     C     SISOD         OREQ      *BLANKS
     C     SSCHT         ANDNE     *BLANKS
     C     SISOD         OREQ      *BLANKS
     C     SSEEA         ANDNE     *BLANKS
     C     SISOD         OREQ      *BLANKS
     C     SFATF         ANDNE     *BLANKS
     C     CFT017        ANDEQ     'Y'
     C                   MOVEL     'ME00005'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN32
     C                   MOVE      'Y'           WERROR
     C                   ENDIF
      *
     C     SSCHT         IFEQ      *BLANK
     C     SISOC         ANDNE     *BLANKS
     C     SSCHT         OREQ      *BLANK
     C     SISOD         ANDNE     *BLANKS
     C                   MOVE      'N'           SSCHT
     C                   ENDIF
      *                                                                                       CFT017
      ** If CFT017 is installed and required fields are filled in while EEA member flag       CFT017
      ** is blanks, default this to 'N'                                                       CFT017
      *                                                                                       CFT017
     C     CFT017        IFEQ      'Y'
      *                                                                                       CFT017
     C     SSEEA         IFEQ      *BLANK
     C     SISOC         ANDNE     *BLANKS
     C     SSEEA         OREQ      *BLANK
     C     SISOD         ANDNE     *BLANKS
     C                   MOVE      'N'           SSEEA
     C                   ENDIF
      *                                                                                       CFT017
     C                   ENDIF
      *                                                                                       CFT032
     C     SFATF         IFEQ      *BLANKS
     C     SISOC         ANDNE     *BLANKS
     C     SFATF         OREQ      *BLANKS
     C     SISOD         ANDNE     *BLANKS
     C                   MOVE      'N'           SFATF
     C     CSW207        IFEQ      'Y'
     C                   MOVE      'N'           SMFID
     C                   ENDIF
     C                   ENDIF
      *
     C     SSCHT         IFNE      *BLANK
     C     SSCHT         ANDNE     'Y'
     C     SSCHT         ANDNE     'N'
     C                   MOVEL     'ME00006'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN33
     C                   MOVE      'Y'           WERROR
     C                   ENDIF
      *                                                                                       CFT017
      ** If EEA member flag is not blank, 'Y' nor 'N', send error message                     CFT017
      *                                                                                       CFT017
     C     SSEEA         IFNE      *BLANK
     C     SSEEA         ANDNE     'Y'
     C     SSEEA         ANDNE     'N'
     C     CFT017        ANDEQ     'Y'
     C                   MOVEL     'ME00028'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN36
     C                   MOVE      'Y'           WERROR
     C                   ENDIF
      *                                                                                       CFT032
     C     SFATF         IFNE      *BLANK
     C     SFATF         ANDNE     'Y'
     C     SFATF         ANDNE     'N'
     C                   MOVEL     'ME21818'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN38
     C                   MOVE      'Y'           WERROR
     C                   ENDIF
      *                                                                                       CSW207
     C     SMFID         IFNE      *BLANK
     C     SMFID         ANDNE     'Y'
     C     SMFID         ANDNE     'N'
     C                   MOVEL     'ME00042'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN41
     C                   MOVE      'Y'           WERROR
     C                   ENDIF
      *                                                                                       CSW207
     C     CSW209        IFEQ      'Y'
     C     SM205         IFEQ      *BLANK
     C                   MOVEL     'N'           SM205
     C                   ELSE
     C     SM205         IFNE      'Y'
     C     SM205         ANDNE     'N'
     C                   MOVEL     'ME21820'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN42
     C                   MOVE      'Y'           WERROR
     C                   ENDIF
     C                   ENDIF
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
     C                   MOVE      '0'           *IN36
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
     C                   MOVE      '1'           *IN33
     C                   MOVE      '1'           *IN36
     C                   MOVE      '1'           *IN38
     C                   MOVE      '1'           *IN41
     C     CSW209        IFEQ      'Y'
     C                   MOVE      '1'           *IN42
     C                   ENDIF
     C     *IN50         IFEQ      '0'
     C     *IN51         ANDEQ     '0'
     C                   MOVE      '1'           *IN34
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
     C*****SISOC         CHAIN     @ISOCL0                            60                    MD058081
     C/EXEC SQL                                                                             MD058081
     C+ SELECT *                                                                            MD058081
     C+ into :MEISOC                                                                        MD058081
     C+ from MEISOJW0                                                                       MD058081
     C+ where M3ISOC = :SISOC                                                               MD058081
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
     C                   MOVE      SISOC         M3ISOC
     C                   MOVE      SISOD         M3ISOD
     C                   MOVE      SSCHT         M3SCHT
     C                   MOVE      SSEEA         M3EEAM
     C                   MOVE      SFATF         M3FATF
      *                                                                                       CSW207
     C     CSW207        IFEQ      'Y'
     C                   MOVE      SMFID         M3MFID
     C                   ENDIF
      *                                                                                       CSW207
     C     CSW209        IFEQ      'Y'
     C                   MOVE      SM205         M3M205
     C                   ENDIF
      *                                                                                       CSW209
     C                   MOVE      ##JOB         M3ACJN
     C                   MOVE      ##USR         M3ACUN
     C                   MOVE      STIME         M3ACTM
     C                   MOVE      BJMRDT        M3ACDA
     C                   MOVE      'I'           M3ACTY
      *
     C**********         WRITE     @ISOCL0                              91                  MD058081
     C/EXEC SQL                                                                             MD058081
     C+ insert into MEISOBTD                                                                MD058081
     C+ (                                                                                   MD058081
     C+   M3ISOC                                                                            MD058081
     C+  ,M3ISOD                                                                            MD058081
     C+  ,M3SCHT                                                                            MD058081
     C+  ,M3ACJN                                                                            MD058081
     C+  ,M3ACUN                                                                            MD058081
     C+  ,M3ACTM                                                                            MD058081
     C+  ,M3ACDA                                                                            MD058081
     C+  ,M3ACTY                                                                            MD058081
     C+  ,M3EEAM                                                                            MD058081
     C+  ,M3FATF                                                                            MD058081
     C+  ,M3MFID                                                                            MD058081
     C+  ,M3M205                                                                            MD058081
     C+  ,M3SEPA                                                                            MD058081
     C+  ,M3IBAC                                                                            MD058081
     C+  ,M3IBAR                                                                            MD058081
     C+  ,M3OCDT                                                                            MD058081
     C+  ,M3MCDT                                                                            MD058081
     C+  ,M3CCSP                                                                            MD058081
     C+  ,M3CCLN                                                                            MD058081
     C+  ,M3ICSP                                                                            MD058081
     C+  ,M3ICLN                                                                            MD058081
     C+  ,M3BBSP                                                                            MD058081
     C+  ,M3BBLN                                                                            MD058081
     C+  ,M3BISP                                                                            MD058081
     C+  ,M3BILN                                                                            MD058081
     C+  ,M3BRSP                                                                            MD058081
     C+  ,M3BRLN                                                                            MD058081
     C+  ,M3INLN                                                                            MD058081
     C+  ,M3ACSP                                                                            MD058081
     C+  ,M3ACLN                                                                            MD058081
     C+  ,M3TBLN                                                                            MD058081
     C+  ,M3TILN                                                                            MD058081
     C+  ,M3MODE                                                                            MD058081
     C+ )                                                                                   MD058081
     C+ Values                                                                              MD058081
     C+ (                                                                                   MD058081
     C+   :M3ISOC                                                                           MD058081
     C+  ,:M3ISOD                                                                           MD058081
     C+  ,:M3SCHT                                                                           MD058081
     C+  ,:M3ACJN                                                                           MD058081
     C+  ,:M3ACUN                                                                           MD058081
     C+  ,:M3ACTM                                                                           MD058081
     C+  ,:M3ACDA                                                                           MD058081
     C+  ,:M3ACTY                                                                           MD058081
     C+  ,:M3EEAM                                                                           MD058081
     C+  ,:M3FATF                                                                           MD058081
     C+  ,:M3MFID                                                                           MD058081
     C+  ,:M3M205                                                                           MD058081
     C+  ,:M3SEPA                                                                           MD058081
     C+  ,:M3IBAC                                                                           MD058081
     C+  ,:M3IBAR                                                                           MD058081
     C+  ,:M3OCDT                                                                           MD058081
     C+  ,:M3MCDT                                                                           MD058081
     C+  ,:M3CCSP                                                                           MD058081
     C+  ,:M3CCLN                                                                           MD058081
     C+  ,:M3ICSP                                                                           MD058081
     C+  ,:M3ICLN                                                                           MD058081
     C+  ,:M3BBSP                                                                           MD058081
     C+  ,:M3BBLN                                                                           MD058081
     C+  ,:M3BISP                                                                           MD058081
     C+  ,:M3BILN                                                                           MD058081
     C+  ,:M3BRSP                                                                           MD058081
     C+  ,:M3BRLN                                                                           MD058081
     C+  ,:M3INLN                                                                           MD058081
     C+  ,:M3ACSP                                                                           MD058081
     C+  ,:M3ACLN                                                                           MD058081
     C+  ,:M3TBLN                                                                           MD058081
     C+  ,:M3TILN                                                                           MD058081
     C+  ,'B'                                                                               MD058081
     C+ )                                                                                   MD058081
     C/END-EXEC                                                                             MD058081
     C/EXEC SQL                                                                             MD058081
     C+ insert into MEISOXTD                                                                MD058081
     C+ (                                                                                   MD058081
     C+   M3ISOC                                                                            MD058081
     C+  ,M3ISOD                                                                            MD058081
     C+  ,M3SCHT                                                                            MD058081
     C+  ,M3ACJN                                                                            MD058081
     C+  ,M3ACUN                                                                            MD058081
     C+  ,M3ACTM                                                                            MD058081
     C+  ,M3ACDA                                                                            MD058081
     C+  ,M3ACTY                                                                            MD058081
     C+  ,M3EEAM                                                                            MD058081
     C+  ,M3FATF                                                                            MD058081
     C+  ,M3MFID                                                                            MD058081
     C+  ,M3M205                                                                            MD058081
     C+  ,M3SEPA                                                                            MD058081
     C+  ,M3IBAC                                                                            MD058081
     C+  ,M3IBAR                                                                            MD058081
     C+  ,M3OCDT                                                                            MD058081
     C+  ,M3MCDT                                                                            MD058081
     C+  ,M3CCSP                                                                            MD058081
     C+  ,M3CCLN                                                                            MD058081
     C+  ,M3ICSP                                                                            MD058081
     C+  ,M3ICLN                                                                            MD058081
     C+  ,M3BBSP                                                                            MD058081
     C+  ,M3BBLN                                                                            MD058081
     C+  ,M3BISP                                                                            MD058081
     C+  ,M3BILN                                                                            MD058081
     C+  ,M3BRSP                                                                            MD058081
     C+  ,M3BRLN                                                                            MD058081
     C+  ,M3INLN                                                                            MD058081
     C+  ,M3ACSP                                                                            MD058081
     C+  ,M3ACLN                                                                            MD058081
     C+  ,M3TBLN                                                                            MD058081
     C+  ,M3TILN                                                                            MD058081
     C+  ,M3MODE                                                                            MD058081
     C+ )                                                                                   MD058081
     C+ Values                                                                              MD058081
     C+ (                                                                                   MD058081
     C+   :M3ISOC                                                                           MD058081
     C+  ,:M3ISOD                                                                           MD058081
     C+  ,:M3SCHT                                                                           MD058081
     C+  ,:M3ACJN                                                                           MD058081
     C+  ,:M3ACUN                                                                           MD058081
     C+  ,:M3ACTM                                                                           MD058081
     C+  ,:M3ACDA                                                                           MD058081
     C+  ,:M3ACTY                                                                           MD058081
     C+  ,:M3EEAM                                                                           MD058081
     C+  ,:M3FATF                                                                           MD058081
     C+  ,:M3MFID                                                                           MD058081
     C+  ,:M3M205                                                                           MD058081
     C+  ,:M3SEPA                                                                           MD058081
     C+  ,:M3IBAC                                                                           MD058081
     C+  ,:M3IBAR                                                                           MD058081
     C+  ,:M3OCDT                                                                           MD058081
     C+  ,:M3MCDT                                                                           MD058081
     C+  ,:M3CCSP                                                                           MD058081
     C+  ,:M3CCLN                                                                           MD058081
     C+  ,:M3ICSP                                                                           MD058081
     C+  ,:M3ICLN                                                                           MD058081
     C+  ,:M3BBSP                                                                           MD058081
     C+  ,:M3BBLN                                                                           MD058081
     C+  ,:M3BISP                                                                           MD058081
     C+  ,:M3BILN                                                                           MD058081
     C+  ,:M3BRSP                                                                           MD058081
     C+  ,:M3BRLN                                                                           MD058081
     C+  ,:M3INLN                                                                           MD058081
     C+  ,:M3ACSP                                                                           MD058081
     C+  ,:M3ACLN                                                                           MD058081
     C+  ,:M3TBLN                                                                           MD058081
     C+  ,:M3TILN                                                                           MD058081
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
     C*****SISOC         CHAIN     @ISOCL0                            60                    MD058081
     C/EXEC SQL                                                                             MD058081
     C+ SELECT *                                                                            MD058081
     C+ into :MEISOC                                                                        MD058081
     C+ from MEISOJW0                                                                       MD058081
     C+ where M3ISOC = :SISOC                                                               MD058081
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
     C                   eval      WDBRC = M3ISOC                                           MD058081
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
     C**********         DELETE    @ISOCL0                              91                  MD058081
     C                   If        M3MODE = 'B'                                             MD058081
     C/EXEC SQL                                                                             MD058081
     C+ delete from MEISOBTD                                                                MD058081
     C+ where M3ISOC = :SISOC                                                               MD058081
     C/END-EXEC                                                                             MD058081
     C/EXEC SQL                                                                             MD058081
     C+ delete from MEISOXTD                                                                MD058081
     C+ where M3ISOC = :SISOC                                                               MD058081
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
     C*****SISOC         CHAIN     @ISOCL0                            60                    MD058081
     C/EXEC SQL                                                                             MD058081
     C+ SELECT *                                                                            MD058081
     C+ into :MEISOC                                                                        MD058081
     C+ from MEISOJW0                                                                       MD058081
     C+ where M3ISOC = :SISOC                                                               MD058081
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
     C                   eval      WDBRC = M3ISOC                                           MD058081
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
     C                   MOVE      SISOD         M3ISOD
     C                   MOVE      SSCHT         M3SCHT
     C                   MOVE      SSEEA         M3EEAM
     C                   MOVE      SFATF         M3FATF
     C                   MOVE      SMFID         M3MFID
     C     CSW209        IFEQ      'Y'
     C                   MOVE      SM205         M3M205
     C                   ENDIF
     C                   MOVE      ##JOB         M3ACJN
     C                   MOVE      ##USR         M3ACUN
     C                   MOVE      STIME         M3ACTM
     C                   MOVE      BJMRDT        M3ACDA
     C                   MOVE      'A'           M3ACTY
      *
     C**********         UPDATE    @ISOCL0                              91                  MD058081
     C/EXEC SQL                                                                             MD058081
     C+ update MEISOXTD set                                                                 MD058081
     C+   M3ISOD = :M3ISOD                                                                  MD058081
     C+ , M3SCHT = :M3SCHT                                                                  MD058081
     C+ , M3EEAM = :M3EEAM                                                                  MD058081
     C+ , M3FATF = :M3FATF                                                                  MD058081
     C+ , M3MFID = :M3MFID                                                                  MD058081
     C+ , M3M205 = :M3M205                                                                  MD058081
     C+ , M3ACJN = :M3ACJN                                                                  MD058081
     C+ , M3ACUN = :M3ACUN                                                                  MD058081
     C+ , M3ACTM = :M3ACTM                                                                  MD058081
     C+ , M3ACDA = :M3ACDA                                                                  MD058081
     C+ , M3ACTY = :M3ACTY                                                                  MD058081
     C+ where M3ISOC = :SISOC                                                               MD058081
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
      ** Move MEISOCL1 fields to subfile
      *================================================================
     C                   MOVEL     M3ACJN        SACJN
     C                   MOVEL     M3ACUN        SACUN
     C                   MOVEL     M3ACTM        SACTM
     C                   MOVEL     M3ACDA        SACDA
     C                   MOVEL     M3ACTY        SACTY
     C                   MOVEL     M3ISOC        SISOC
     C                   MOVEL     M3ISOD        SISOD
     C                   MOVEL     M3SCHT        SSCHT
     C                   MOVEL     M3EEAM        SSEEA
     C                   MOVEL     M3FATF        SFATF
      *                                                                                     MD022592
      **When record has been updated by another workstation include fields                  MD022592
      **introduced by CSW213 in file MEISOCPD                                               MD022592
      *                                                                                     MD022592
     C                   MOVEL     M3IBAC        SIBAC
     C                   MOVEL     M3SEPA        SSEPA
     C                   MOVEL     M3IBAR        SIBAR
     C                   MOVEL     M3CCSP        SCCSP
     C                   MOVEL     M3CCLN        SCCLN
     C                   MOVEL     M3ICSP        SICSP
     C                   MOVEL     M3ICLN        SICLN
     C                   MOVEL     M3BBSP        SBBSP
     C                   MOVEL     M3BBLN        SBBLN
     C                   MOVEL     M3BISP        SBISP
     C                   MOVEL     M3BILN        SBILN
     C                   MOVEL     M3BRSP        SBRSP
     C                   MOVEL     M3BRLN        SBRLN
     C                   MOVEL     M3INLN        SINLN
     C                   MOVEL     M3ACSP        SACSP
     C                   MOVEL     M3ACLN        SACLN
     C                   MOVEL     M3TBLN        STBLN
     C                   MOVEL     M3TILN        STILN
      *                                                                                     MD022592
      ** Avoid '000000' value on Optional and Mandatory Commende date field to              MD022592
      ** block error message regarding invalid date.                                        MD022592
      *                                                                                     MD022592
     C     SOCDT         IFNE      *BLANKS
     C     M3OCDT        IFEQ      0
     C                   MOVE      *BLANKS       SOCDT
     C                   ELSE
     C                   MOVEL     M3OCDT        SOCDT
     C                   ENDIF
     C                   ENDIF
     C     SMCDT         IFNE      *BLANKS
     C     M3MCDT        IFEQ      0
     C                   MOVE      *BLANKS       SMCDT
     C                   ELSE
     C                   MOVEL     M3MCDT        SMCDT
     C                   ENDIF
     C                   ENDIF
     C                   EXSR      SPOPDF
     C     CSW207        IFEQ      'Y'
     C                   MOVEL     M3MFID        SMFID
     C                   ENDIF
      *                                                                                       CSW209
     C     CSW209        IFEQ      'Y'
     C                   MOVEL     M3M205        SM205
     C                   ENDIF
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
     C                   MOVE      *BLANKS       SISOC
     C                   MOVE      *BLANKS       SISOD
     C                   MOVE      *BLANKS       SSCHT
     C                   MOVE      *BLANKS       SSEEA
     C                   MOVE      *BLANKS       SFATF
     C     CSW207        IFEQ      'Y'
     C                   MOVE      *BLANKS       SMFID
     C                   ENDIF
     C     CSW209        IFEQ      'Y'
     C                   MOVE      *BLANKS       SM205
     C                   ENDIF
      *================================================================
     CSR   EXISFF        ENDSR
      /EJECT
     CSR   SMAINB        BEGSR
      *================================================================                       CSW213
      ** Main Processing B for CSW213                                                         CSW213
      *================================================================                       CSW213
      *                                                                                       CSW213
     C     PMMODE        IFEQ      'E'
     C     PMISOC        ANDNE     *BLANKS
     C                   MOVE      *ON           *IN20
     C                   MOVEL     WTXTE         SCTX1
     C                   EXSR      SPROCB
     C                   ELSE
     C                   DO        *HIVAL
      *                                                                                       CSW213
      ** Initialise & load subfile page                                                       CSW213
      *                                                                                       CSW213
     C                   EXSR      SRZSFB
     C                   MOVEL     'N'           W0RSF             1
      *                                                                                       CSW213
      ** Display screen until reload requested                                                CSW213
      *                                                                                       CSW213
     C     W0RSF         DOWEQ     'N'
      *                                                                                       CSW213
      ** Display screen                                                                       CSW213
      *                                                                                       CSW213
     C                   EXSR      SDSPSB
      *                                                                                       CSW213
      ** *IN03 Cancel & exit program, *IN05 Request subfile reload                            CSW213
      *                                                                                       CSW213
     C   03              CAS                     SREXIT
     C   05              CAS                     SRRQRL
     C   27              CAS                     SLDSFB
      *                                                                                       CSW213
      ** Process screen input/add new record                                                  CSW213
      *                                                                                       CSW213
     C                   CAS                     SPROCB
     C                   ENDCS
      *                                                                                       CSW213
     C                   ENDDO
     C                   ENDDO
      *                                                                                       CSW213
     C                   ENDIF
      *================================================================                       CSW213
     CSR   EXAINB        ENDSR
      /EJECT                                                                                  CSW213
     CSR   SRZSFB        BEGSR
      *================================================================                       CSW213
      ** Alternate SRIZSF routine                                                             CSW213
      *================================================================                       CSW213
      *                                                                                       CSW213
      ** Clear subfile                                                                        CSW213
      *                                                                                       CSW213
     C                   SETON                                        80
     C                   WRITE     RSFLCTLB
     C                   SETOFF                                       80
      *                                                                                       CSW213
      ** Reset no of records in subfile                                                       CSW213
      *                                                                                       CSW213
     C                   Z-ADD     *ZERO         WRRN              5 081
     C     *IN05         IFEQ      *ON
     C                   MOVE      *BLANKS       SEISOC
     C                   ENDIF
      *                                                                                       CSW213
     C     WMODE         IFNE      'ADD'
     C                   MOVE      *BLANKS       WZISOC
     C                   MOVEL     SEISOC        WZISOC
      *                                                                                       CSW213
      ** Position DBF file                                                                    CSW213
      *                                                                                       CSW213
     C                   MOVEL     SEISOC        M3ISOC
     C*****KPOS*         SETLL     MEISOCL1                                                 MD058081
      *                                                                                       CSW213
     C     PMMODE        IFEQ      'E'
     C     PMMODE        OREQ      'M'
     C     PMISOC        IFEQ      *BLANKS
     C                   MOVEL     WTXTE1        SCTX1
     C**********         READ      MEISOCL1                             8782                MD058081
     C/EXEC SQL                                                                             MD058081
     C+ close BCursor                                                                       MD058081
     C/END-EXEC                                                                             MD058081
                                                                                            MD058081
     C/EXEC SQL                                                                             MD058081
     C+ declare BCursor insensitive scroll cursor for                                       MD058081
     C+ select * from MEISOJW0                                                              MD058081
     C+ where M3ISOC >= :PMISOC                                                             MD058081
     C+ order by M3ISOC                                                                     MD058081
     C/END-EXEC                                                                             MD058081
                                                                                            MD058081
     C/EXEC SQL                                                                             MD058081
     C+ open BCursor                                                                        MD058081
     C/END-EXEC                                                                             MD058081
                                                                                            MD058081
     C/EXEC SQL                                                                             MD058081
     C+ fetch next from BCursor into :MEISOC                                                MD058081
     C/END-EXEC                                                                             MD058081
                                                                                            MD058081
     C                   setoff                                       82                    MD058081
     C                   If        SQLCODE = 100                                            MD058081
     C                   seton                                        82                    MD058081
     C                   Endif                                                              MD058081
                                                                                            MD058081
     C                   ELSE
     C*****PMISOC        READE     MEISOCL1                             8782                MD058081
     C/EXEC SQL                                                                             MD058081
     C+ close UCursor                                                                       MD058081
     C/END-EXEC                                                                             MD058081
                                                                                            MD058081
     C/EXEC SQL                                                                             MD058081
     C+ declare UCursor insensitive scroll cursor for                                       MD058081
     C+ select * from MEISOJW0                                                              MD058081
     C+ where M3ISOC  = :PMISOC                                                             MD058081
     C+ order by M3ISOC                                                                     MD058081
     C/END-EXEC                                                                             MD058081
                                                                                            MD058081
     C/EXEC SQL                                                                             MD058081
     C+ open UCursor                                                                        MD058081
     C/END-EXEC                                                                             MD058081
                                                                                            MD058081
     C/EXEC SQL                                                                             MD058081
     C+ fetch next from UCursor into :MEISOC                                                MD058081
     C/END-EXEC                                                                             MD058081
                                                                                            MD058081
     C                   setoff                                       82                    MD058081
     C                   If        SQLCODE = 100                                            MD058081
     C                   seton                                        82                    MD058081
     C                   Endif                                                              MD058081
                                                                                            MD058081
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSW213
     C                   ELSE
     C                   MOVE      '0'           *IN82
     C                   ENDIF
     C                   EXSR      SLDSFB
      *================================================================                       CSW213
     CSR   EXZSFB        ENDSR
      /EJECT                                                                                  CSW213
     CSR   SLDSFB        BEGSR
      *================================================================                       CSW213
      ** Alternate SRLDSF routine                                                             CSW213
      *================================================================                       CSW213
      ** Load subfile page                                                                    CSW213
      *================================================================                       CSW213
     C                   MOVE      '0'           *IN84
      *                                                                                       CSW213
      ** Re-establish fields in read-ahead record                                             CSW213
      *                                                                                       CSW213
     C     *IN27         IFEQ      '1'
     C     WMODE         ANDNE     'ADD'
      *                                                                                       CSW213
     C     PMMODE        IFEQ      'E'
     C     PMISOC        OREQ      *BLANKS
     C**N82*****         READ      MEISOCL1                               90                MD058081
     C**N82*****         READP     MEISOCL1                               90                MD058081
     C/EXEC SQL                                                                             MD058081
     C+ fetch prior from BCursor into :MEISOC                                               MD058081
     C/END-EXEC                                                                             MD058081
     C/EXEC SQL                                                                             MD058081
     C+ fetch next from BCursor into :MEISOC                                                MD058081
     C/END-EXEC                                                                             MD058081
     C                   ELSE
     C**N82PMISOC        READPE    MEISOCL1                               90                MD058081
     C**N82*****         READE     MEISOCL1                               90                MD058081
     C                   If        *IN82 = '0'                                              MD058081
     C/EXEC SQL                                                                             MD058081
     C+ fetch prior from UCursor into :MEISOC                                               MD058081
     C/END-EXEC                                                                             MD058081
     C/EXEC SQL                                                                             MD058081
     C+ fetch next from UCursor into :MEISOC                                                MD058081
     C/END-EXEC                                                                             MD058081
     C                   Endif                                                              MD058081
     C                   ENDIF
     C                   ENDIF                                                              MD058081
      *                                                                                       CSW213
      ** Start at previous highest record in SFL                                              CSW213
      *                                                                                       CSW213
     C                   Z-ADD     WRRN          SRRNB             5 0
     C                   Z-ADD     0             WCTR              5 0
     C                   Z-ADD     0             WCTR2             5 0
      *                                                                                       CSW213
      ** Set required pages based on *Set Cursor or *Subfile Pages                            CSW213
      *                                                                                       CSW213
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
      *                                                                                       CSW213
      ** Compute lines required based on pages                                                CSW213
      *                                                                                       CSW213
     C     WSPG          MULT      WSFPG         WSFLN
     C     WSFLN         IFGT      999
     C                   Z-ADD     999           WSFLN
     C                   ENDIF
      *                                                                                       CSW213
      ** Load next SFL page until SFL page full, or                                           CSW213
      ** Scan limit reached                                                                   CSW213
      *                                                                                       CSW213
     C******IN82         DOWEQ     '0'                                                      MD058081
     C     SQLCODE       DOWEQ     0                                                        MD058081
     C     WCTR          ANDLT     WSFLN
     C     WCTR2         ANDLT     W0SLM
      *                                                                                       CSW213
      ** Setof record error indicators                                                        CSW213
      *                                                                                       CSW213
     C                   MOVE      *ALL'0'       WKIND0            4
     C                   MOVEA     WKIND0        *IN(31)
     C                   MOVE      '0'           *IN36
     C                   MOVE      '0'           *IN38
     C                   MOVE      '0'           *IN20
     C                   MOVE      '0'           *IN21
     C                   MOVE      '0'           *IN40
     C                   MOVE      '0'           *IN41
     C                   MOVE      '0'           *IN42
     C                   MOVE      '0'           *IN50
     C                   MOVE      '0'           *IN51
      *                                                                                       CSW213
     C     PMMODE        IFEQ      'E'
     C                   MOVE      '1'           *IN20
     C                   MOVE      '1'           *IN40
     C                   MOVE      '1'           *IN76
      *                                                                                       CSW213
     C                   ELSE
     C     WMODE         IFEQ      'ADD'
     C                   MOVE      '1'           *IN50
     C                   ENDIF
     C     WMODE         IFEQ      'LST'
     C                   MOVE      '1'           *IN21
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSW213
     C                   EXSR      SISFFB
      *                                                                                       CSW213
     C     WMODE         IFNE      'ADD'
      *                                                                                       CSW213
      ** Load SFL fields                                                                      CSW213
      *                                                                                       CSW213
     C                   EXSR      SLSFFB
     C                   eval      WDBRC = M3ISOC                                           MD058081
     C                   MOVEL     WDBRC         SDBRC
     C                   ENDIF
      *                                                                                       CSW213
      ** Output to subfile                                                                    CSW213
      *                                                                                       CSW213
     C                   ADD       1             SRRNB
     C                   ADD       1             WCTR                 81
      *                                                                                       CSW213
     C                   WRITE     RSFLRCDB
      *                                                                                       CSW213
      ** Increment scan check count                                                           CSW213
      *                                                                                       CSW213
     C                   ADD       1             WCTR2
     C     WMODE         IFNE      'ADD'
      *                                                                                       CSW213
     C     PMMODE        IFEQ      'E'
     C     PMISOC        OREQ      *BLANKS
     C**********         READ      MEISOCL1                               82                MD058081
     C/EXEC SQL                                                                             MD058081
     C+ fetch next from BCursor into :MEISOC                                                MD058081
     C/END-EXEC                                                                             MD058081
     C                   ELSE
     C*****PMISOC        READE     MEISOCL1                               82                MD058081
     C/EXEC SQL                                                                             MD058081
     C+ fetch next from UCursor into :MEISOC                                                MD058081
     C/END-EXEC                                                                             MD058081
     C                   ENDIF
      *                                                                                       CSW213
     C                   ENDIF
     C                   ENDDO
      *                                                                                       CSW213
      ** Save highest SFL record load can continue at end point                               CSW213
      *                                                                                       CSW213
     C     SRRNB         IFGT      WRRN
      *                                                                                       CSW213
      ** Calculate top line                                                                   CSW213
      *                                                                                       CSW213
     C     WCTR          DIV       WSFPG         WSPG
     C                   MVR                     WSLIN
     C     WSLIN         IFGT      0
     C     SRRNB         SUB       WSLIN         SSFRC
     C                   ELSE
     C     SRRNB         SUB       WSFPG         SSFRC
     C                   ENDIF
     C                   ADD       1             SSFRC
     C                   Z-ADD     SRRNB         WRRN
     C                   ENDIF
      *                                                                                       CSW213
      ** If scan limit reached, display error message                                         CSW213
      *                                                                                       CSW213
     C     WCTR2         IFGE      W0SLM
      *                                                                                       CSW213
      ** Send message 'Scan limit reached'                                                    CSW213
      *                                                                                       CSW213
     C                   MOVEL     'ME00010'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   Z-ADD     0             WCTR
     C                   ENDIF
      *================================================================                       CSW213
     CSR   EXDSFB        ENDSR
      /EJECT                                                                                  CSW213
      *================================================================                       CSW213
     CSR   SDSPSB        BEGSR
      *================================================================                       CSW213
      ** Alternate SRDSPS routine                                                             CSW213
      *================================================================                       CSW213
      ** Display screen                                                                       CSW213
      *================================================================                       CSW213
     C     *IN82         IFEQ      '1'
     C     WRRN          ANDEQ     0
      *                                                                                       CSW213
      ** Send message '*No data to display'                                                   CSW213
      *                                                                                       CSW213
     C                   MOVEL     'ME00001'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   WRITE     RMSGCTL
      *                                                                                       CSW213
     C     PMMODE        IFEQ      'M'
     C     WMODE         IFEQ      'LST'
     C                   MOVEL     WTXTC         SCTX1
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSW213
     C     PMMODE        IFEQ      'E'
     C                   MOVEL     WTXTE1        SCTX1
     C                   ENDIF
      *                                                                                     MD022749
     C                   WRITE     RCMDTXT1
      *                                                                                       CSW213
      ** Update screen time                                                                   CSW213
      *                                                                                       CSW213
     C                   TIME                    STIME
      *                                                                                       CSW213
     C                   EXFMT     RSFLCTLB
      *                                                                                       CSW213
      ** Maintain subfile position where possible                                             CSW213
      *                                                                                       CSW213
     C     @#SFRC        IFGT      *ZERO
     C                   Z-ADD     @#SFRC        SSFRC
     C                   ENDIF
      *                                                                                       CSW213
     C                   EXSR      SRCLR
      *================================================================                       CSW213
     CSR   EXSPSB        ENDSR
      /EJECT                                                                                  CSW213
     CSR   SPROCB        BEGSR
      *================================================================                       CSW213
      ** Alternate SRPROC routine                                                             CSW213
      *================================================================                       CSW213
     C     WMODE         IFNE      'ADD'
     C     WZISOC        ANDNE     SEISOC
     C                   EXSR      SRRQRL
     C     W0RSF         CABEQ     'Y'           EXROCB
     C                   ENDIF
      *                                                                                       CSW213
     C     PMMODE        IFEQ      'E'
     C********** PMISOC    IFNE *BLANKS                                              CSW213 MD022749
     C     PMISOC        ANDNE     *BLANKS
     C                   MOVEL     'E'           SCSEL
     C                   MOVEL     PMISOC        SISOC
     C                   EXSR      SPROCR
     C**********           ENDIF                                                     CSW213 MD022749
     C                   EXSR      SRRQRL
     C     W0RSF         CABEQ     'Y'           EXROCB
     C                   ENDIF
      *                                                                                       CSW213
     C                   READC     RSFLRCDB                               92
      *                                                                                       CSW213
     C     SCSEL         IFEQ      ' '
     C     *IN09         ANDEQ     *ON
     C                   MOVE      *OFF          *IN12
     C                   MOVE      *OFF          *IN20
     C                   MOVE      *ON           *IN30
     C                   EXSR      SPROCC
     C                   ELSE
      *                                                                                       CSW213
     C                   MOVE      *OFF          *IN30
     C     *IN92         DOWEQ     '0'
      *                                                                                       CSW213
     C                   MOVE      *BLANKS       WERR
      *                                                                                       CSW213
      ** Update screen time                                                                   CSW213
      *                                                                                       CSW213
     C                   TIME                    STIME
      *                                                                                       CSW213
      ** Process subfile record and validate options                                          CSW213
      *                                                                                       CSW213
     C     SCSEL         IFNE      ' '
     C     SCSEL         ANDNE     'E'
     C     SCSEL         ANDNE     'A'
     C     SCSEL         ANDNE     'D'
     C     WERR          ANDEQ     *BLANK
     C     PMMODE        OREQ      'E'
     C     SCSEL         ANDNE     ' '
     C     SCSEL         ANDNE     'E'
     C                   MOVE      *ON           *IN34
     C                   MOVE      'Y'           WERR
     C                   Z-ADD     SRRNB         SSFRC
     C                   MOVEL     'ME00002'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   MOVE      *OFF          *IN34
     C                   EXSR      SRCLR
     C                   ENDIF
      *                                                                                       CSW213
     C     PMMODE        IFEQ      'M'
     C                   MOVE      *BLANKS       SCTX1
     C                   MOVEL     WTXTC         SCTX1
     C                   ENDIF
      *                                                                                       CSW213
     C                   SELECT
     C     SCSEL         WHENEQ    'E'
     C                   MOVE      *ON           *IN20
     C                   MOVEL     WTXTE         SCTX1
     C                   EXSR      SPROCR
     C     SCSEL         WHENEQ    'A'
     C     PMMODE        ANDEQ     'M'
     C                   MOVE      *OFF          *IN20
     C                   MOVE      *ON           *IN28
     C                   MOVEL     WTXTU         SCTX1
     C                   EXSR      SPROCU
     C     SCSEL         WHENEQ    'D'
     C     PMMODE        ANDEQ     'M'
     C                   EXSR      SPROCD
     C                   ENDSL
      *                                                                                       CSW213
     C     WERR          IFEQ      *BLANK
     C                   MOVE      *BLANKS       SCSEL
     C                   ENDIF
     C                   UPDATE    RSFLRCDB
     C     WERR          IFNE      *BLANK
     C                   WRITE     RMSGCTL
     C                   WRITE     RCMDTXT1
     C                   EXSR      SRCLR
     C                   ENDIF
      *                                                                                       CSW213
     C                   READC     RSFLRCDB                               92
      *                                                                                       CSW213
     C     *IN03         IFEQ      *ON
     C                   MOVE      *ON           *IN92
     C                   ENDIF
      *                                                                                       CSW213
     C                   ENDDO
     C                   ENDIF
      *================================================================                       CSW213
     CSR   EXROCB        ENDSR
      /EJECT                                                                                  CSW213
     CSR   SPROCC        BEGSR
      *================================================================                       CSW213
      ** Add new ISO country code                                                             CSW213
      *================================================================                       CSW213
     C                   MOVE      'N'           WRUN              1
     C                   EXSR      SPCLDF
     C                   MOVEL     WTXTU         SCTX1
     C                   MOVE      'N'           WSVAL             1
     C                   Z-ADD     0             WWARN             2 0
      *                                                                                       CSW213
     C     WSVAL         DOWEQ     'N'
     C     *IN12         ANDEQ     *OFF
      *                                                                                       CSW213
      ** Refresh page                                                                         CSW213
      *                                                                                       CSW213
     C                   MOVE      *OFF          *IN22
     C     WREFR         IFEQ      'N'
     C     WERROR        ANDNE     'Y'
     C                   MOVE      *ON           *IN22
     C                   ENDIF
      *                                                                                     MD022005
     C                   EXSR      SDSPD1
     C     WSVAL         IFEQ      'N'
     C     *IN12         ANDEQ     *OFF
     C                   MOVE      'N'           WSVAL
     C                   MOVE      'N'           SPREL
      *                                                                                     MD023517
      ** Clear IBAN Structure fields when IBAN country code is changed                      MD023517
      ** to blanks or from being a non-reference (ISO country code <>                       MD023517
      ** IBAN country code) to a reference record (ISO country code =                       MD023517
      ** IBAN country code).                                                                MD023517
      *                                                                                     MD023517
     C     W3IBAC        IFNE      SIBAC
     C     SIBAC         IFEQ      *BLANKS
     C     SIBAC         OREQ      SISOC
     C                   EXSR      CLIBAN
     C                   ENDIF
     C                   ENDIF
      *                                                                                     MD023517
     C                   EXSR      VALADF
     C                   MOVE      SIBAC         W3IBAC            2
     C     WRUN          IFEQ      'N'
     C                   MOVE      'Y'           WRUN
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *                                                                                       CSW213
     C     WSVAL         IFEQ      'Y'
     C     SIBAC         IFEQ      SISOC
     C     SIBAC         ORNE      SISOC
     C     SIBAC         ANDEQ     *BLANKS
     C                   EXSR      SPOPPD
     C                   ENDIF
     C                   EXSR      SRADD
     C                   COMMIT
     C                   EXSR      SRSYNC
     C                   COMMIT
     C                   EXSR      SRRQRL
     C                   ELSE
     C                   ROLBK
     C                   ENDIF
      *                                                                                       CSW213
     C                   MOVE      *OFF          *IN12
     C                   MOVE      *OFF          *IN03
     C                   MOVE      *OFF          *IN30
     C                   EXSR      SRCLR
      *================================================================                       CSW213
     CSR   EXROCC        ENDSR
      /EJECT                                                                                  CSW213
     CSR   SPROCR        BEGSR
      *================================================================                       CSW213
      ** Retrieve existing ISO country code record                                            CSW213
      *================================================================                       CSW213
     C                   MOVE      'N'           SPREL             1
     C                   MOVEL     SISOC         WFLDC             2
     C                   EXSR      SPCLDF
     C                   MOVE      *OFF          *IN60
     C*****WFLDC*        CHAIN     MEISOCL1                           60                    MD058081
     C/EXEC SQL                                                                             MD058081
     C+ SELECT *                                                                            MD058081
     C+ into :MEISOC                                                                        MD058081
     C+ from MEISOJW0                                                                       MD058081
     C+ where M3ISOC = :WFLDC                                                               MD058081
     C/END-EXEC                                                                             MD058081
     C******IN60         IFEQ      *ON                                                      MD058081
     C     SQLCODE       IFEQ      100                                                      MD058081
     C                   MOVEL     'ME00008'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   GOTO      EXROCR
     C                   ELSE
     C                   EXSR      SRRCTY
     C                   EXSR      SPOPDF
     C                   WRITE     RCMDTXT1
     C     SIBAC         IFNE      *BLANKS
     C                   MOVE      *ON           *IN72
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSW213
     C     SCSEL         IFEQ      'E'
     C                   EXFMT     ME1740D1
     C     *IN03         IFEQ      *ON
     C                   EXSR      SREXIT
     C                   ENDIF
     C                   ENDIF
      *================================================================                       CSW213
     CSR   EXROCR        ENDSR
      /EJECT                                                                                  CSW213
     CSR   SPROCU        BEGSR
      *================================================================                       CSW213
      ** Amend existing ISO country code record                                               CSW213
      *================================================================                       CSW213
     C                   MOVE      *OFF          *IN22
     C                   MOVE      SISOC         WISOC
     C                   EXSR      SPCLDF
     C                   MOVE      WISOC         SISOC
     C                   EXSR      SPROCR
     C********** M3ISOC    IFEQ M3IBAC                                               CSW213 MD022005
     C     M3ISOC        IFEQ      SIBAC
     C                   MOVE      'Y'           WREFR             1
     C                   ELSE
     C                   MOVE      'N'           WREFR
     C                   MOVE      *ON           *IN22
     C                   ENDIF
     C                   MOVE      'N'           WSVAL             1
     C                   Z-ADD     0             WWARN             2 0
      *                                                                                       CSW213
      ** Validation                                                                           CSW213
      *                                                                                       CSW213
     C     WSVAL         DOWEQ     'N'
     C     *IN12         ANDEQ     *OFF
     C                   EXSR      SDSPD1
     C     WSVAL         IFEQ      'N'
     C     *IN12         ANDEQ     *OFF
     C                   MOVE      'N'           WSVAL
      *                                                                                     MD023517
      ** Clear IBAN Structure fields when IBAN country code is changed                      MD023517
      ** to blanks or from being a non-reference (ISO country code <>                       MD023517
      ** IBAN country code) to a reference record (ISO country code =                       MD023517
      ** IBAN country code).                                                                MD023517
      *                                                                                     MD023517
     C     M3IBAC        IFNE      *BLANKS
     C     M3IBAC        ANDNE     SIBAC
     C     SIBAC         IFEQ      *BLANKS
     C     SIBAC         OREQ      SISOC
     C     WRUN          ANDNE     'Y'
     C                   EXSR      CLIBAN
     C                   MOVE      'Y'           WRUN
     C                   ENDIF
     C                   ENDIF
      *                                                                                     MD023517
     C                   EXSR      VALADF
     C                   ENDIF
      *                                                                                       CSW213
     C     WSVAL         IFEQ      'Y'
     C     *IN12         ANDEQ     *OFF
     C                   EXSR      SRAMDB
     C     WERROR        IFNE      'Y'
     C                   COMMIT
     C                   EXSR      SRSYNC
     C                   COMMIT
     C                   EXSR      SRRQRL
     C                   ELSE
     C                   MOVE      'N'           WSVAL
     C                   ROLBK
     C                   ENDIF
     C                   ELSE
     C                   ROLBK
     C                   ENDIF
      *                                                                                       CSW213
     C                   ENDDO
      *                                                                                       CSW213
     C                   MOVE      *OFF          *IN12
     C                   MOVE      *OFF          *IN28
     C                   EXSR      SRCLR
      *================================================================                       CSW213
     CSR   EXROCU        ENDSR
      /EJECT                                                                                  CSW213
     CSR   SRAMDB        BEGSR
      *================================================================                       CSW213
      ** Alternate SRAMD routine                                                              CSW213
      *================================================================                       CSW213
     C*****SISOC         CHAIN     MEISOCL0                           60                    MD058081
     C/EXEC SQL                                                                             MD058081
     C+ SELECT *                                                                            MD058081
     C+ into :MEISOC                                                                        MD058081
     C+ from MEISOJW0                                                                       MD058081
     C+ where M3ISOC = :SISOC                                                               MD058081
     C/END-EXEC                                                                             MD058081
     C******IN60         IFEQ      '1'                                                      MD058081
     C     SQLCODE       IFEQ      100                                                      MD058081
     C                   MOVEL     'ME00008'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   GOTO      EXAMDB
     C                   ENDIF
      *                                                                                       CSW213
     C                   eval      WDBRC = M3ISOC                                           MD058081
     C     WDBRC         IFNE      SDBRC
     C                   MOVEL     'ME00009'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   EXSR      SRLSFF
     C                   MOVEL     WDBRC         SDBRC
     C                   GOTO      EXAMDB
     C                   ENDIF
      *                                                                                       CSW213
     C                   MOVE      SISOD         M3ISOD
     C                   MOVE      SSCHT         M3SCHT
     C                   MOVE      SSEEA         M3EEAM
     C                   MOVE      SFATF         M3FATF
     C                   MOVE      SMFID         M3MFID
     C     CSW209        IFEQ      'Y'
     C                   MOVE      SM205         M3M205
     C                   ENDIF
     C                   MOVE      ##JOB         M3ACJN
     C                   MOVE      ##USR         M3ACUN
     C                   MOVE      STIME         M3ACTM
     C                   MOVE      BJMRDT        M3ACDA
     C                   MOVE      'A'           M3ACTY
     C                   EXSR      SPOPPD
      *                                                                                       CSW213
     C**********         UPDATE    @ISOCL0                              91                  MD058081
     C/EXEC SQL                                                                             MD058081
     C+ update MEISOXTD set                                                                 MD058081
     C+   M3ISOD = :M3ISOD                                                                  MD058081
     C+ , M3SCHT = :M3SCHT                                                                  MD058081
     C+ , M3EEAM = :M3EEAM                                                                  MD058081
     C+ , M3FATF = :M3FATF                                                                  MD058081
     C+ , M3MFID = :M3MFID                                                                  MD058081
     C+ , M3M205 = :M3M205                                                                  MD058081
     C+ , M3ACJN = :M3ACJN                                                                  MD058081
     C+ , M3ACUN = :M3ACUN                                                                  MD058081
     C+ , M3ACTM = :M3ACTM                                                                  MD058081
     C+ , M3ACDA = :M3ACDA                                                                  MD058081
     C+ , M3ACTY = :M3ACTY                                                                  MD058081
     C+ where M3ISOC = :SISOC                                                               MD058081
     C/END-EXEC                                                                             MD058081
      *                                                                                       CSW213
      ** Display error msg if file update not successful                                      CSW213
      *                                                                                       CSW213
     C******IN91         IFEQ      '1'                                                      MD058081
     C     SQLCODE       IFNE      0                                                        MD058081
     C                   MOVEL     'ME00011'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   ELSE
     C                   MOVEL     WDBRC         SDBRC
     C                   ENDIF
      *================================================================                       CSW213
     CSR   EXAMDB        ENDSR
      /EJECT                                                                                  CSW213
     CSR   SPROCD        BEGSR
      *================================================================                       CSW213
      ** Delete existing ISO country code record                                              CSW213
      *================================================================                       CSW213
     C                   MOVE      *ON           *IN73
     C                   MOVE      *ON           *IN20
     C                   MOVE      *ON           *IN26
     C                   MOVE      *OFF          *IN12
     C                   MOVEL     WTXTD         SCTX1
     C                   EXSR      SPROCR
      *                                                                                       CSW213
      ** Check for attached records if reference                                              CSW213
      *                                                                                       CSW213
     C     SISOC         IFEQ      SIBAC
      *                                                                                       CSW213
     C                   MOVE      SIBAC         WIBAC
     C******LOVAL        SETLL     MEISOCL3
     C*****KSYNC         SETLL     MEISOCL3
     C*****KSYNC         READE     MEISOCL3                               60
      **********                                                                              CSW213
     C******IN60         DOWEQ     *OFF
     C******IN73         ANDEQ     *ON
     C                   eval      TotRow = 0                                               MD058081
     C     *IN73         IFEQ      *ON                                                      MD058081
     C*****M3ISOC        IFNE      SISOC
     C/EXEC SQL                                                                             MD058081
     C+ declare ChkCursor insensitive scroll cursor for                                     MD058081
     C+ select * from MEISOJW0                                                              MD058081
     C+ where M3IBAC = :WIBAC                                                               MD058081
     C/END-EXEC                                                                             MD058081
                                                                                            MD058081
     C/EXEC SQL                                                                             MD058081
     C+ open ChkCursor                                                                      MD058081
     C/END-EXEC                                                                             MD058081
                                                                                            MD058081
     C/EXEC SQL                                                                             MD058081
     C+ get diagnostics :TotRow = DB2_NUMBER_ROWS                                           MD058081
     C/END-EXEC                                                                             MD058081
                                                                                            MD058081
     C/EXEC SQL                                                                             MD058081
     C+ close ChkCursor                                                                     MD058081
     C/END-EXEC                                                                             MD058081
     C                   IF        TotRow = 0                                               MD058081
     C                   MOVEL     'ME21879'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      *OFF          *IN73
     C                   EXSR      SIBSCE
     C                   WRITE     RMSGCTL
     C                   ENDIF
     C*****KSYNC         READE     MEISOCD0                               60                MD058081
     C**********         ENDDO                                                              MD058081
     C                   ENDIF                                                              MD058081
      *                                                                                       CSW213
     C                   ENDIF
      *                                                                                       CSW213
     C     *IN10         DOWEQ     *OFF
     C     *IN12         ANDEQ     *OFF
     C                   EXFMT     ME1740D1
     C                   ENDDO
      *                                                                                       CSW213
     C     *IN10         IFEQ      *ON
     C     *IN73         ANDEQ     *ON
     C                   EXSR      SRDEL
     C                   COMMIT
     C                   EXSR      SRRQRL
     C                   MOVE      *OFF          *IN10
     C                   ENDIF
      *                                                                                       CSW213
      *================================================================                       CSW213
     CSR   EXROCD        ENDSR
      /EJECT                                                                                  CSW213
     CSR   SDSPD1        BEGSR
      *================================================================                       CSW213
      ** Refresh ME1740D1                                                                     CSW213
      *================================================================                       CSW213
     C                   WRITE     RMSGCTL
     C                   WRITE     RCMDTXT1
     C                   EXFMT     ME1740D1
     C                   EXSR      SRCLR
      *================================================================                       CSW213
     CSR   EXSPD1        ENDSR
      /EJECT                                                                                  CSW213
     C     CLIBAN        BEGSR
      *================================================================                     MD023517
      ** Clear IBAN Structure Information fields                                            MD023517
      *================================================================                     MD023517
     C                   MOVE      *BLANKS       STILN
     C                   MOVE      *BLANKS       SBBSP
     C                   MOVE      *BLANKS       SBBLN
     C                   MOVE      *BLANKS       SCCSP
     C                   MOVE      *BLANKS       SCCLN
     C                   MOVE      *BLANKS       SICSP
     C                   MOVE      *BLANKS       SICLN
     C                   MOVE      *BLANKS       SBISP
     C                   MOVE      *BLANKS       SBILN
     C                   MOVE      *BLANKS       SBRSP
     C                   MOVE      *BLANKS       SBRLN
     C                   MOVE      *BLANKS       STBLN
     C                   MOVE      *BLANKS       SINLN
     C                   MOVE      *BLANKS       SACSP
     C                   MOVE      *BLANKS       SACLN
     C                   MOVE      *BLANKS       SOCDT
     C                   MOVE      *BLANKS       SMCDT
      *================================================================                     MD023517
     C                   ENDSR
      /EJECT                                                                                MD023517
     CSR   SPOPPD        BEGSR
      *================================================================                       CSW213
      ** Moving to data to MEISOCL1                                                           CSW213
      *================================================================                       CSW213
      *                                                                                       CSW213
      ** Old field                                                                            CSW213
      *                                                                                       CSW213
     C                   MOVEL     SIBAC         M3IBAC
      *                                                                                       CSW213
      ** New introduced                                                                       CSW213
      *                                                                                       CSW213
     C                   MOVEL     SSEPA         M3SEPA
     C                   MOVEL     SIBAR         M3IBAR
     C                   Z-ADD     ZTILN         M3TILN
     C                   Z-ADD     ZBBSP         M3BBSP
     C                   Z-ADD     ZBBLN         M3BBLN
     C                   Z-ADD     ZCCSP         M3CCSP
     C                   Z-ADD     ZCCLN         M3CCLN
     C                   Z-ADD     ZICSP         M3ICSP
     C                   Z-ADD     ZICLN         M3ICLN
     C                   Z-ADD     ZBISP         M3BISP
     C                   Z-ADD     ZBILN         M3BILN
     C                   Z-ADD     ZBRSP         M3BRSP
     C                   Z-ADD     ZBRLN         M3BRLN
     C                   Z-ADD     ZTBLN         M3TBLN
     C                   Z-ADD     ZINLN         M3INLN
     C                   Z-ADD     ZACSP         M3ACSP
     C                   Z-ADD     ZACLN         M3ACLN
     C                   Z-ADD     ZOCDT         M3OCDT
     C                   Z-ADD     ZMCDT         M3MCDT
      *                                                                                       CSW213
      *================================================================                       CSW213
     CSR   EXOPPD        ENDSR
      /EJECT                                                                                  CSW213
     CSR   VALADF        BEGSR
      *================================================================                       CSW213
      ** Validate ME1740D1 screen as introduced in CSW213                                     CSW213
      *================================================================                       CSW213
     C     WWARN         IFGT      0
     C                   ADD       10            WWARN
     C                   ENDIF
     C                   MOVE      'N'           WERROR
     C                   EXSR      SRSIND
      *                                                                                       CSW213
     C     *IN30         IFEQ      *ON
     C     SISOC         IFEQ      *BLANKS
     C                   MOVEL     'ME00003'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   MOVE      *ON           *IN67
      *                                                                                       CSW213
     C                   ELSE
     C                   MOVE      *OFF          *IN70
     C     ALPONL        CHECK     SISOC                                  70
     C     *IN70         IFEQ      *ON
     C                   MOVEL     'ME00004'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   MOVE      *ON           *IN67
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSW213
     C*****SISOC         CHAIN     MEISOCL0                           60                    MD058081
     C/EXEC SQL                                                                             MD058081
     C+ SELECT *                                                                            MD058081
     C+ into :MEISOC                                                                        MD058081
     C+ from MEISOJW0                                                                       MD058081
     C+ where M3ISOC = :SISOC                                                               MD058081
     C/END-EXEC                                                                             MD058081
     C******IN60         IFEQ      '0'                                                      MD058081
     C     SQLCODE       IFEQ      0                                                        MD058081
     C                   MOVEL     'ME00007'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   MOVE      *ON           *IN67
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSW213
     C                   MOVE      SISOC         WFLDC
     C                   EXSR      SRRCTY
      *                                                                                       CSW213
      ** Check old fields                                                                     CSW213
      *                                                                                       CSW213
     C                   EXSR      SRVREC
     C     WERROR        IFEQ      'Y'
     C                   MOVE      'N'           WSVAL
     C                   ELSE
      *                                                                                       CSW213
      ** New fields introduced by CSW213                                                      CSW213
      *                                                                                       CSW213
      *                                                                                       CSW213
      ** SEPA                                                                                 CSW213
      *                                                                                       CSW213
     C     SSEPA         IFNE      *BLANK
     C     SSEPA         ANDNE     'Y'
     C     SSEPA         ANDNE     'N'
     C                   MOVEL     'ME21821'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   MOVE      *ON           *IN44
     C                   ENDIF
      *                                                                                       CSW213
      ** IBAN Country Code                                                                    CSW213
      *                                                                                       CSW213
     C     CFT004        IFEQ      'Y'
     C                   EXSR      SCHKBC
     C                   ENDIF
      *                                                                                       CSW213
      ** IBAN Required in MT103+/MT102+ and MT103+                                            CSW213
      *                                                                                       CSW213
     C     CFT004        IFEQ      'Y'
     C     CSW213        ANDEQ     'Y'
     C     SIBAR         IFNE      'Y'
     C     SIBAR         ANDNE     'N'
     C     SIBAC         ANDNE     *BLANKS
     C                   MOVEL     'ME21827'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   MOVE      *ON           *IN46
     C                   ENDIF
      *                                                                                     MD023517
     C     SIBAR         IFNE      *BLANKS
     C     SIBAC         ANDEQ     *BLANKS
     C                   MOVEL     'ME21828'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   MOVE      *ON           *IN46
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSW213
      ** IBAN Structure Fields                                                                CSW213
      *                                                                                       CSW213
     C     SIBAC         IFNE      *BLANK
     C     SIBAC         ANDEQ     SISOC
     C                   EXSR      SRIBSC
     C                   ENDIF
      *                                                                                       CSW213
      ** Default non-reference values                                                         CSW213
      *                                                                                       CSW213
     C     WREFR         IFEQ      'N'
     C     WERROR        ANDEQ     'N'
     C                   MOVE      SIBAC         RFIBAC
     C                   MOVE      *BLANKS       NRISOC
     C                   MOVE      'Y'           SPREL
     C                   MOVE      *ON           *IN22
     C                   EXSR      SRRIBS
     C                   EXSR      SPOPDF
     C                   ENDIF
      *                                                                                       CSW213
      ** Error and screen handling                                                            CSW213
      *                                                                                       CSW213
     C     SCSEL         IFEQ      'A'
     C                   EXSR      CHKCHG
     C     WCHG          IFEQ      'N'
     C                   ADD       9             WWARN
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSW213
     C     WERROR        IFEQ      'Y'
     C                   Z-ADD     0             WWARN
     C                   ELSE
     C     WWARN         IFEQ      0
     C     WWARN         ORGE      10
     C                   MOVE      'Y'           WSVAL
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSW213
     C                   ENDIF
      *================================================================                       CSW213
     CSR   EXLADF        ENDSR
      /EJECT                                                                                  CSW213
     CSR   SCHKBC        BEGSR
      *================================================================                       CSW213
      ** Validate SIBAC                                                                       CSW213
      *================================================================                       CSW213
     C                   MOVE      'N'           WIBNS
     C                   MOVE      'N'           WREFR             1
     C                   MOVE      *OFF          *IN71
      *                                                                                       CSW213
     C     SIBAC         IFEQ      *BLANKS
     C     SIBAR         IFEQ      'Y'
     C     SBBLN         ORNE      *BLANKS
     C                   MOVEL     'ME21824'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   MOVE      *ON           *IN45
     C                   GOTO      EXHKBC
     C                   ELSE
     C                   ADD       9             WWARN
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSW213
     C     SIBAC         IFNE      *BLANKS
      *                                                                                       CSW213
     C                   MOVE      *OFF          *IN70
     C     ALPONL        CHECK     SIBAC                                  70
     C     *IN70         IFEQ      *ON
     C                   MOVEL     'ME21822'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   MOVE      *ON           *IN45
     C                   GOTO      EXHKBC
     C                   ENDIF
      *                                                                                       CSW213
      ** Check whether reference or non-reference record                                      CSW213
      *                                                                                       CSW213
     C     SIBAC         IFEQ      SISOC
     C                   MOVE      'Y'           WREFR
     C                   MOVE      'N'           SPREL
     C                   MOVE      *ON           *IN71
     C                   MOVE      *OFF          *IN22
     C                   ENDIF
      *                                                                                       CSW213
     C     WREFR         IFEQ      'N'
     C                   MOVE      *OFF          *IN70
     C*****SIBAC         CHAIN     MEISOCL1                           70                    MD058081
     C/EXEC SQL                                                                             MD058081
     C+ SELECT *                                                                            MD058081
     C+ into :MEISOC                                                                        MD058081
     C+ from MEISOJW0                                                                       MD058081
     C+ where M3ISOC = :SIBAC                                                               MD058081
     C/END-EXEC                                                                             MD058081
     C******IN70         IFEQ      *ON                                                      MD058081
     C     SQLCODE       IFEQ      100                                                      MD058081
     C                   MOVEL     'ME21823'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   MOVE      *ON           *IN45
     C                   GOTO      EXHKBC
     C                   ENDIF
      *                                                                                       CSW213
     C**********           MOVEL'ME21876' ZAMSID                                     CSW213 MD022005
     C**********           MOVEL'MEMSG'   ZAMSGF                                     CSW213 MD022005
     C**********           EXSR ZASNMS                                               CSW213 MD022005
      *                                                                                       CSW213
     C                   ENDIF
      *                                                                                       CSW213
     C     CFT050        IFEQ      'Y'
      *                                                                                       CSW213
     C                   MOVE      *OFF          *IN70
     C     SIBAC         CHAIN     MEBICCL1                           70
     C     *IN70         IFEQ      *ON
     C                   MOVEL     'ME21825'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   ADD       1             WWARN
     C                   ENDIF
      *                                                                                       CSW213
     C                   MOVE      *OFF          *IN70
     C     SIBAC         CHAIN     MEIBNSL0                           70
     C     *IN70         IFEQ      *ON
     C                   MOVEL     'ME21826'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   ADD       1             WWARN
     C                   ENDIF
      *                                                                                     MD022293
     C                   MOVE      *OFF          *IN70
     C     SISOC         CHAIN     MEBICCL1                           70
     C     *IN70         IFEQ      *ON
     C                   MOVEL     'ME21881'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   ADD       1             WWARN
     C                   ENDIF
      *                                                                                       CSW213
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSW213
     C     SIBAC         IFNE      *BLANKS
     C                   MOVE      *ON           *IN72
     C                   ADD       1             WWARN
     C                   ENDIF
      *                                                                                       CSW213
     C                   MOVE      *OFF          *IN70
     C                   MOVE      'Y'           WIBNS
      *================================================================                       CSW213
     CSR   EXHKBC        ENDSR
      /EJECT                                                                                  CSW213
     CSR   SRIBSC        BEGSR
      *================================================================                       CSW213
      ** Check IBAN Structure fields for Reference Record Input                               CSW213
      *================================================================                       CSW213
      *                                                                                       CSW213
      ** BBAN Start Position                                                                  CSW213
      *                                                                                       CSW213
      *                                                                                       CSW213
      ***Defaulting****************************************************              CSW213 MD022957
      **********                                                                     CSW213 MD022957
     C********** SBBLN     IFNE *BLANK                                               CSW213 MD022957
     C********** SBBSP     ANDEQ*BLANK                                               CSW213 MD022957
     C**********           MOVE '5'       SBBSP                                      CSW213 MD022957
     C**********           ENDIF                                                     CSW213 MD022957
      **********                                                                     CSW213 MD022957
      **********                                                                     CSW213 MD022957
     C********** SBBSP     IFNE *BLANK                                               CSW213 MD022957
     C********** SBBSP     ANDNEWSBBSP                                               CSW213 MD022957
      **********                                                                     CSW213 MD022957
     C********** SISOC     IFNE SIBAC                                                CSW213 MD022957
     C**********           MOVEL'ME21874' ZAMSID                                     CSW213 MD022957
     C**********           MOVEL'MEMSG'   ZAMSGF                                     CSW213 MD022957
     C**********           EXSR ZASNMS                                               CSW213 MD022957
     C**********           MOVE *ON       *IN66                                      CSW213 MD022957
     C**********           EXSR SIBSCE                                               CSW213 MD022957
     C**********           ENDIF                                                     CSW213 MD022957
      *                                                                                       CSW213
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      SBBSP         ZFIELD
     C                   Z-ADD     2             ZADIG
     C                   Z-ADD     0             ZADEC
     C                   EXSR      ZALIGN
     C     *IN99         IFEQ      *ON
     C                   MOVEL     'ME21873'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   MOVE      *ON           *IN66
     C                   ELSE
     C                   MOVE      ZFIELD        ZBBSP             2 0
     C                   EXSR      ZEDIT
     C     ZBBSP         IFEQ      0
     C                   MOVE      *BLANKS       SBBSP
     C                   ELSE
     C                   MOVE      ZFIELD        SBBSP
     C                   ENDIF
     C                   ENDIF
      *                                                                                     MD022957
     C     SBBSP         IFNE      WSBBSP
     C     ZBBSP         IFNE      5
     C     ZBBSP         ANDNE     0
     C                   MOVEL     'ME21880'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   MOVE      *ON           *IN66
     C                   ENDIF
     C**********           EXSR ZEDIT                                                CSW213 MD022957
     C**********           MOVE ZFIELD    SBBSP                                      CSW213 MD022957
     C**********           ENDIF                                                     CSW213 MD022957
      *                                                                                     MD022957
     C     SISOC         IFNE      SIBAC
     C                   MOVEL     'ME21874'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN66
     C                   EXSR      SIBSCE
     C                   ENDIF
      *                                                                                       CSW213
     C                   ENDIF
      *                                                                                       CSW213
      ** BBAN Length                                                                          CSW213
      *                                                                                       CSW213
     C********** SBBLN     IFEQ *BLANK                                               CSW213 MD022957
     C********** WREFR     ANDEQ'Y'                                                  CSW213 MD022957
     C********** WWARN     ANDGE10                                                   CSW213 MD022957
     C**********           MOVEL'ME21877' ZAMSID                                     CSW213 MD022957
     C**********           MOVEL'MEMSG'   ZAMSGF                                     CSW213 MD022957
     C**********           EXSR ZASNMS                                               CSW213 MD022957
     C**********           MOVE 'Y'       WERROR                                     CSW213 MD022957
     C**********           MOVE *ON       *IN55                                      CSW213 MD022957
     C**********           ENDIF                                                     CSW213 MD022957
      **********                                                                     CSW213 MD022957
     C********** SBBLN     IFNE *BLANK                                               CSW213 MD022957
     C********** SBBLN     ANDNEWSBBLN                                               CSW213 MD022957
      **********                                                                     CSW213 MD022957
     C********** SISOC     IFNE SIBAC                                                CSW213 MD022957
     C**********           MOVEL'ME21845' ZAMSID                                     CSW213 MD022957
     C**********           MOVEL'MEMSG'   ZAMSGF                                     CSW213 MD022957
     C**********           EXSR ZASNMS                                               CSW213 MD022957
     C**********           MOVE *ON       *IN55                                      CSW213 MD022957
     C**********           EXSR SIBSCE                                               CSW213 MD022957
     C**********           ENDIF                                                     CSW213 MD022957
      *                                                                                       CSW213
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      SBBLN         ZFIELD
     C                   Z-ADD     2             ZADIG
     C                   Z-ADD     0             ZADEC
     C                   EXSR      ZALIGN
     C     *IN99         IFEQ      *ON
     C                   MOVEL     'USR3716'     ZAMSID
     C                   MOVEL     'GB'          ZAMSGF
     C                   MOVE      'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      *BLANKS       ZAMSGF
     C                   MOVE      'Y'           WERROR
     C                   MOVE      *ON           *IN55
     C                   ELSE
     C                   MOVE      ZFIELD        ZBBLN             2 0
     C                   EXSR      ZEDIT
     C     ZBBLN         IFEQ      0
     C                   MOVE      *BLANKS       SBBLN
     C                   ELSE
     C                   MOVE      ZFIELD        SBBLN
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSW213
     C     SBBLN         IFNE      WSBBLN
     C     ZBBLN         IFLT      0
     C     ZBBLN         ORGT      30
     C                   MOVEL     'USR3718'     ZAMSID
     C                   MOVEL     'GB'          ZAMSGF
     C                   MOVE      'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      *BLANKS       ZAMSGF
     C                   MOVE      'Y'           WERROR
     C                   MOVE      *ON           *IN55
     C                   ENDIF
      *                                                                                       CSW213
     C     SISOC         IFNE      SIBAC
     C                   MOVEL     'ME21845'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN55
     C                   EXSR      SIBSCE
     C                   ENDIF
     C                   ENDIF
      **********                                                                     CSW213 MD022957
      ***Default*for*Total*IBAN*Length*on*input*of*BBAN*Length*********              CSW213 MD022957
      **********                                                                     CSW213 MD022957
     C********** ZBBLN     IFNE 0                                                    CSW213 MD022957
     C********** STILN     ANDEQ*BLANKS                                              CSW213 MD022957
     C********** WREFR     ANDEQ'Y'                                                  CSW213 MD022957
     C********** ZBBLN     ADD  4         ZTILN                                      CSW213 MD022957
     C**********           MOVE ZTILN     STILN                                      CSW213 MD022957
     C**********           ENDIF                                                     CSW213 MD022957
      *                                                                                       CSW213
      ** Total IBAN Length                                                                    CSW213
      *                                                                                       CSW213
     C********** STILN     IFNE *BLANK                                               CSW213 MD022957
     C********** STILN     ANDNEWSTILN                                               CSW213 MD022957
      **********                                                                     CSW213 MD022957
     C********** SISOC     IFNE SIBAC                                                CSW213 MD022957
     C**********           MOVEL'ME21871' ZAMSID                                     CSW213 MD022957
     C**********           MOVEL'MEMSG'   ZAMSGF                                     CSW213 MD022957
     C**********           EXSR ZASNMS                                               CSW213 MD022957
     C**********           MOVE *ON       *IN61                                      CSW213 MD022957
     C**********           EXSR SIBSCE                                               CSW213 MD022957
     C**********           ENDIF                                                     CSW213 MD022957
      *                                                                                       CSW213
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      STILN         ZFIELD
     C                   Z-ADD     2             ZADIG
     C                   Z-ADD     0             ZADEC
     C                   EXSR      ZALIGN
     C     *IN99         IFEQ      *ON
     C                   MOVEL     'ME21870'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   MOVE      *ON           *IN61
     C                   ELSE
     C                   MOVE      ZFIELD        ZTILN             2 0
     C                   EXSR      ZEDIT
     C     ZTILN         IFEQ      0
     C                   MOVE      *BLANKS       STILN
     C                   ELSE
     C                   MOVE      ZFIELD        STILN
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSW213
     C     STILN         IFNE      WSTILN
     C********** ZTILN     IFLT 0                                                    CSW213 MD022957
     C     ZTILN         IFLT      6
     C     ZTILN         ANDNE     0
     C     ZTILN         ORGT      34
     C                   MOVEL     'ME21872'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   MOVE      *ON           *IN61
     C                   ENDIF
      *                                                                                       CSW213
     C     SISOC         IFNE      SIBAC
     C                   MOVEL     'ME21871'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN61
     C                   EXSR      SIBSCE
     C                   ENDIF
     C                   ENDIF
      **********                                                                     CSW213 MD022957
      ***BBAN*Length*and*Start*Position********************************              CSW213 MD022957
      **********                                                                     CSW213 MD022957
     C********** ZBBLN     IFNE 0                                                    CSW213 MD022957
     C********** ZBBSP     ANDNE0                                                    CSW213 MD022957
     C********** WREFR     ANDEQ'Y'                                                  CSW213 MD022957
      **********                                                                     CSW213 MD022957
     C********** ZTILN     ADD  1         TFCTR   30                                 CSW213 MD022957
     C********** TFCTR     SUB  ZBBSP     TFCTR                                      CSW213 MD022957
     C********** ZBBLN     IFNE TFCTR                                                CSW213 MD022957
     C**********           MOVEL'ME21860' ZAMSID                                     CSW213 MD022957
     C**********           MOVEL'MEMSG'   ZAMSGF                                     CSW213 MD022957
     C**********           EXSR ZASNMS                                               CSW213 MD022957
     C**********           MOVE 'Y'       WERROR                                     CSW213 MD022957
     C**********           MOVE *ON       *IN55                                      CSW213 MD022957
     C**********           ENDIF                                                     CSW213 MD022957
      **********                                                                     CSW213 MD022957
     C********** ZTILN     ADD  1         TFCTR   30                                 CSW213 MD022957
     C********** TFCTR     SUB  ZBBLN     TFCTR                                      CSW213 MD022957
     C********** ZBBSP     IFGT TFCTR                                                CSW213 MD022957
     C**********           MOVEL'ME21875' ZAMSID                                     CSW213 MD022957
     C**********           MOVEL'MEMSG'   ZAMSGF                                     CSW213 MD022957
     C**********           EXSR ZASNMS                                               CSW213 MD022957
     C**********           MOVE 'Y'       WERROR                                     CSW213 MD022957
     C**********           MOVE *ON       *IN66                                      CSW213 MD022957
     C**********           ENDIF                                                     CSW213 MD022957
      **********                                                                     CSW213 MD022957
     C**********           ENDIF                                                     CSW213 MD022957
      *                                                                                       CSW213
      ** Country Code Start Position                                                          CSW213
      *                                                                                       CSW213
     C********** SCCSP     IFEQ *BLANK                                               CSW213 MD022957
     C********** ZBBLN     ANDNE0                                                    CSW213 MD022957
     C********** WREFR     ANDEQ'Y'                                                  CSW213 MD022957
     C**********           MOVE '1'       SCCSP                                      CSW213 MD022957
     C**********           ENDIF                                                     CSW213 MD022957
      **********                                                                     CSW213 MD022957
     C********** SCCSP     IFNE *BLANK                                               CSW213 MD022957
     C********** SCCSP     ANDNEWSCCSP                                               CSW213 MD022957
      **********                                                                     CSW213 MD022957
     C********** SISOC     IFNE SIBAC                                                CSW213 MD022957
     C**********           MOVEL'ME21834' ZAMSID                                     CSW213 MD022957
     C**********           MOVEL'MEMSG'   ZAMSGF                                     CSW213 MD022957
     C**********           EXSR ZASNMS                                               CSW213 MD022957
     C**********           MOVE *ON       *IN49                                      CSW213 MD022957
     C**********           EXSR SIBSCE                                               CSW213 MD022957
     C**********           ENDIF                                                     CSW213 MD022957
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      SCCSP         ZFIELD
     C                   Z-ADD     2             ZADIG
     C                   Z-ADD     0             ZADEC
     C                   EXSR      ZALIGN
     C     *IN99         IFEQ      *ON
     C                   MOVEL     'ME21833'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   MOVE      *ON           *IN49
     C                   ELSE
     C                   MOVE      ZFIELD        ZCCSP             2 0
     C                   EXSR      ZEDIT
     C     ZCCSP         IFEQ      0
     C                   MOVE      *BLANKS       SCCSP
     C                   ELSE
     C                   MOVE      ZFIELD        SCCSP
     C                   ENDIF
     C                   ENDIF
      *                                                                                     MD022957
     C     SCCSP         IFNE      WSCCSP
     C     ZCCSP         IFNE      1
     C     ZCCSP         ANDNE     0
     C                   MOVEL     'ME21835'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   MOVE      *ON           *IN49
     C                   ENDIF
      *                                                                                     MD022957
     C     SISOC         IFNE      SIBAC
     C                   MOVEL     'ME21834'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN49
     C                   EXSR      SIBSCE
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSW213
      ** Country Code Length                                                                  CSW213
      *                                                                                       CSW213
     C********** SCCLN     IFEQ *BLANK                                               CSW213 MD022957
     C********** ZBBLN     ANDNE0                                                    CSW213 MD022957
     C********** WREFR     ANDEQ'Y'                                                  CSW213 MD022957
     C**********           MOVE '2'       SCCLN                                      CSW213 MD022957
     C**********           ENDIF                                                     CSW213 MD022957
      **********                                                                     CSW213 MD022957
     C********** SCCLN     IFNE *BLANK                                               CSW213 MD022957
     C********** SCCLN     ANDNEWSCCLN                                               CSW213 MD022957
      **********                                                                     CSW213 MD022957
     C********** SISOC     IFNE SIBAC                                                CSW213 MD022957
     C**********           MOVEL'ME21837' ZAMSID                                     CSW213 MD022957
     C**********           MOVEL'MEMSG'   ZAMSGF                                     CSW213 MD022957
     C**********           EXSR ZASNMS                                               CSW213 MD022957
     C**********           MOVE *ON       *IN52                                      CSW213 MD022957
     C**********           EXSR SIBSCE                                               CSW213 MD022957
     C**********           ENDIF                                                     CSW213 MD022957
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      SCCLN         ZFIELD
     C                   Z-ADD     1             ZADIG
     C                   Z-ADD     0             ZADEC
     C                   EXSR      ZALIGN
     C     *IN99         IFEQ      *ON
     C                   MOVEL     'ME21836'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   MOVE      *ON           *IN52
     C                   ELSE
     C                   MOVE      ZFIELD        ZCCLN             2 0
     C                   EXSR      ZEDIT
     C     ZCCLN         IFEQ      0
     C                   MOVE      *BLANKS       SCCLN
     C                   ELSE
     C                   MOVE      ZFIELD        SCCLN
     C                   ENDIF
     C                   ENDIF
      *                                                                                     MD022957
     C     SCCLN         IFNE      WSCCLN
     C     ZCCLN         IFNE      2
     C     ZCCLN         ANDNE     0
     C                   MOVEL     'ME21838'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   MOVE      *ON           *IN52
     C                   ENDIF
      *                                                                                     MD022957
     C     SISOC         IFNE      SIBAC
     C                   MOVEL     'ME21837'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN52
     C                   EXSR      SIBSCE
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSW213
      ** IBAN Check Digit Start Position                                                      CSW213
      *                                                                                       CSW213
     C********** SICSP     IFEQ *BLANK                                               CSW213 MD022957
     C********** ZBBLN     ANDNE0                                                    CSW213 MD022957
     C********** WREFR     ANDEQ'Y'                                                  CSW213 MD022957
     C**********           MOVE '3'       SICSP                                      CSW213 MD022957
     C**********           ENDIF                                                     CSW213 MD022957
      **********                                                                     CSW213 MD022957
     C********** SICSP     IFNE *BLANK                                               CSW213 MD022957
     C********** SICSP     ANDNEWSICSP                                               CSW213 MD022957
     C********** SISOC     IFNE SIBAC                                                CSW213 MD022957
     C**********           MOVEL'ME21840' ZAMSID                                     CSW213 MD022957
     C**********           MOVEL'MEMSG'   ZAMSGF                                     CSW213 MD022957
     C**********           EXSR ZASNMS                                               CSW213 MD022957
     C**********           MOVE *ON       *IN53                                      CSW213 MD022957
     C**********           EXSR SIBSCE                                               CSW213 MD022957
     C**********           ENDIF                                                     CSW213 MD022957
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      SICSP         ZFIELD
     C                   Z-ADD     2             ZADIG
     C                   Z-ADD     0             ZADEC
     C                   EXSR      ZALIGN
     C     *IN99         IFEQ      *ON
     C                   MOVEL     'ME21839'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   MOVE      *ON           *IN53
     C                   ELSE
     C                   MOVE      ZFIELD        ZICSP             2 0
     C                   EXSR      ZEDIT
     C     ZICSP         IFEQ      0
     C                   MOVE      *BLANKS       SICSP
     C                   ELSE
     C                   MOVE      ZFIELD        SICSP
     C                   ENDIF
     C                   ENDIF
      *                                                                                     MD022957
     C     SICSP         IFNE      WSICSP
     C     ZICSP         IFNE      3
     C     ZICSP         ANDNE     0
     C                   MOVEL     'ME21841'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   MOVE      *ON           *IN53
     C                   ENDIF
      *                                                                                     MD022957
     C     SISOC         IFNE      SIBAC
     C                   MOVEL     'ME21840'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN53
     C                   EXSR      SIBSCE
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSW213
      ** IBAN Check Digit Length                                                              CSW213
      *                                                                                       CSW213
     C********** SICLN     IFEQ *BLANK                                               CSW213 MD022957
     C********** ZBBLN     ANDNE0                                                    CSW213 MD022957
     C********** WREFR     ANDEQ'Y'                                                  CSW213 MD022957
     C**********           MOVE '2'       SICLN                                      CSW213 MD022957
     C**********           ENDIF                                                     CSW213 MD022957
      **********                                                                     CSW213 MD022957
     C********** SICLN     IFNE *BLANK                                               CSW213 MD022957
     C********** SICLN     ANDNEWSICLN                                               CSW213 MD022957
      **********                                                                     CSW213 MD022957
     C********** SISOC     IFNE SIBAC                                                CSW213 MD022957
     C**********           MOVEL'ME21843' ZAMSID                                     CSW213 MD022957
     C**********           MOVEL'MEMSG'   ZAMSGF                                     CSW213 MD022957
     C**********           EXSR ZASNMS                                               CSW213 MD022957
     C**********           MOVE *ON       *IN54                                      CSW213 MD022957
     C**********           EXSR SIBSCE                                               CSW213 MD022957
     C**********           ENDIF                                                     CSW213 MD022957
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      SICLN         ZFIELD
     C                   Z-ADD     2             ZADIG
     C                   Z-ADD     0             ZADEC
     C                   EXSR      ZALIGN
     C     *IN99         IFEQ      *ON
     C                   MOVEL     'ME21842'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   MOVE      *ON           *IN54
     C                   ELSE
     C                   MOVE      ZFIELD        ZICLN             2 0
     C                   EXSR      ZEDIT
     C     ZICLN         IFEQ      0
     C                   MOVE      *BLANKS       SICLN
     C                   ELSE
     C                   MOVE      ZFIELD        SICLN
     C                   ENDIF
     C                   ENDIF
      *                                                                                     MD022957
     C     SICLN         IFNE      WSICLN
     C     ZICLN         IFNE      2
     C     ZICLN         ANDNE     0
     C                   MOVEL     'ME21844'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   MOVE      *ON           *IN54
     C                   ENDIF
      *                                                                                     MD022957
     C     SISOC         IFNE      SIBAC
     C                   MOVEL     'ME21843'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN54
     C                   EXSR      SIBSCE
     C                   ENDIF
     C                   ENDIF
      *                                                                                     MD022957
      ** Default BBAN Length if IBAN Total Length is input                                  MD022957
      *                                                                                     MD022957
     C     ZTILN         IFGE      6
     C     ZTILN         ANDLE     34
     C     ZBBLN         ANDEQ     0
     C                   MOVE      *BLANKS       ZFIELD
     C     ZTILN         SUB       4             ZBBLN
     C                   MOVE      ZBBLN         ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SBBLN
     C                   ENDIF
      *                                                                                     MD022957
     C     SBBLN         IFEQ      *BLANK
     C     WREFR         ANDEQ     'Y'
     C     WRUN          ANDEQ     'Y'
     C                   MOVEL     'ME21877'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   MOVE      *ON           *IN55
     C                   ENDIF
      *                                                                                     MD022957
      ** Default BBAN Start Position to 5 if BBAN Length is input                           MD022957
      *                                                                                     MD022957
     C     ZBBLN         IFGT      0
     C     ZBBSP         ANDEQ     0
     C                   MOVE      '5'           SBBSP
     C                   MOVE      5             ZBBSP
     C                   ENDIF
      *                                                                                     MD022957
      ** Default IBAN Total Length if BBAN Length is input                                  MD022957
      *                                                                                     MD022957
     C     ZBBLN         IFGT      0
     C     ZTILN         ANDEQ     0
     C     WREFR         ANDEQ     'Y'
     C                   MOVE      *BLANKS       ZFIELD
     C     ZBBLN         ADD       4             ZTILN
     C                   MOVE      ZTILN         ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        STILN
     C                   ENDIF
      *                                                                                     MD022957
      ** BBAN Length and Start Position                                                     MD022957
      *                                                                                     MD022957
     C     ZBBLN         IFNE      0
     C     ZBBSP         ANDNE     0
     C     WREFR         ANDEQ     'Y'
      *                                                                                     MD022957
     C     ZTILN         ADD       1             TFCTR             3 0
     C     TFCTR         SUB       ZBBSP         TFCTR
     C     ZBBLN         IFNE      TFCTR
     C                   MOVEL     'ME21860'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   MOVE      *ON           *IN55
     C                   ENDIF
      *                                                                                     MD022957
     C                   ENDIF
      *                                                                                     MD022957
      ** Default Country Code Start Position when BBAN Length is input                      MD022957
      *                                                                                     MD022957
     C     ZCCSP         IFEQ      0
     C     ZBBLN         ANDGT     0
     C     WREFR         ANDEQ     'Y'
     C                   MOVE      '1'           SCCSP
     C                   MOVE      1             ZCCSP
     C                   ENDIF
      *                                                                                     MD022957
      ** Default Country Code Length if BBAN Length is input                                MD022957
      *                                                                                     MD022957
     C     ZCCLN         IFEQ      0
     C     ZBBLN         ANDGT     0
     C     WREFR         ANDEQ     'Y'
     C                   MOVE      '2'           SCCLN
     C                   MOVE      2             ZCCLN
     C                   ENDIF
      *                                                                                     MD022957
      ** Default IBAN Check Digit Start Position if BBAN Length is input                    MD022957
      *                                                                                     MD022957
     C     ZICSP         IFEQ      0
     C     ZBBLN         ANDGT     0
     C     WREFR         ANDEQ     'Y'
     C                   MOVE      '3'           SICSP
     C                   MOVE      3             ZICSP
     C                   ENDIF
      *                                                                                     MD022957
      ** Default IBAN Check Digit Length if BBAN Length is input                            MD022957
      *                                                                                     MD022957
     C     ZICLN         IFEQ      0
     C     ZBBLN         ANDGT     0
     C     WREFR         ANDEQ     'Y'
     C                   MOVE      '2'           SICLN
     C                   MOVE      2             ZICLN
     C                   ENDIF
      *                                                                                       CSW213
      ** Bank ID Start Position                                                               CSW213
      *                                                                                       CSW213
     C********** SBISP     IFNE *BLANK                                               CSW213 MD022295
     C********** SBISP     ANDNEWSBISP                                               CSW213 MD022295
     C     SBISP         IFNE      WSBISP
     C     SBISP         ORNE      WZBISP
      *                                                                                       CSW213
     C********** SISOC     IFNE SIBAC                                                CSW213 MD023458
     C**********           MOVEL'ME21848' ZAMSID                                     CSW213 MD023458
     C**********           MOVEL'MEMSG'   ZAMSGF                                     CSW213 MD023458
     C**********           EXSR ZASNMS                                               CSW213 MD023458
     C**********           MOVE *ON       *IN56                                      CSW213 MD023458
     C**********           EXSR SIBSCE                                               CSW213 MD023458
     C**********           ENDIF                                                     CSW213 MD023458
      *                                                                                       CSW213
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      SBISP         ZFIELD
     C                   Z-ADD     2             ZADIG
     C                   Z-ADD     0             ZADEC
     C                   EXSR      ZALIGN
     C     *IN99         IFEQ      *ON
     C                   MOVEL     'ME21847'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   MOVE      *ON           *IN56
     C                   ELSE
     C                   MOVE      ZFIELD        ZBISP             2 0
     C                   EXSR      ZEDIT
     C     SBISP         IFNE      *BLANKS
     C                   MOVE      ZFIELD        SBISP
     C                   ENDIF
     C                   MOVE      ZFIELD        WZBISP
     C                   ENDIF
      *                                                                                       CSW213
     C                   ENDIF
      *                                                                                       CSW213
      ** Bank ID Length                                                                       CSW213
      *                                                                                       CSW213
     C********** SBILN     IFNE *BLANK                                               CSW213 MD022295
     C********** SBILN     ANDNEWSBILN                                               CSW213 MD022295
     C     SBILN         IFNE      WSBILN
     C     SBILN         ORNE      WZBILN
      *                                                                                       CSW213
     C********** SISOC     IFNE SIBAC                                                CSW213 MD023458
     C**********           MOVEL'ME21851' ZAMSID                                     CSW213 MD023458
     C**********           MOVEL'MEMSG'   ZAMSGF                                     CSW213 MD023458
     C**********           EXSR ZASNMS                                               CSW213 MD023458
     C**********           MOVE *ON       *IN57                                      CSW213 MD023458
     C**********           EXSR SIBSCE                                               CSW213 MD023458
     C**********           ENDIF                                                     CSW213 MD023458
      *                                                                                       CSW213
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      SBILN         ZFIELD
     C                   Z-ADD     2             ZADIG
     C                   Z-ADD     0             ZADEC
     C                   EXSR      ZALIGN
     C     *IN99         IFEQ      *ON
     C                   MOVEL     'ME21850'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   MOVE      *ON           *IN57
     C                   ELSE
     C                   MOVE      ZFIELD        ZBILN             2 0
     C                   EXSR      ZEDIT
     C     SBILN         IFNE      *BLANKS
     C                   MOVE      ZFIELD        SBILN
     C                   ENDIF
     C                   MOVE      ZFIELD        WZBILN
     C                   ENDIF
      *                                                                                       CSW213
     C                   ENDIF
      *                                                                                       CSW213
      ** Bank ID Length and Start Position                                                    CSW213
      *                                                                                       CSW213
     C     WREFR         IFEQ      'Y'
      *                                                                                       CSW213
     C     ZTILN         ADD       1             TFCTR             3 0
     C     TFCTR         SUB       ZBILN         TFCTR
     C     ZBISP         IFGT      TFCTR
     C                   MOVEL     'ME21849'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   MOVE      *ON           *IN56
     C                   ENDIF
      *                                                                                       CSW213
     C     ZTILN         ADD       1             TFCTR             3 0
     C     TFCTR         SUB       ZBISP         TFCTR
     C     ZBILN         IFGT      TFCTR
     C                   MOVEL     'ME21852'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   MOVE      *ON           *IN57
     C                   ENDIF
      *                                                                                       CSW213
     C                   ENDIF
      *                                                                                       CSW213
      ** Branch ID Start Position                                                             CSW213
      *                                                                                       CSW213
     C********** SBRSP     IFNE *BLANK                                               CSW213 MD022295
     C********** SBRSP     ANDNEWSBRSP                                               CSW213 MD022295
     C     SBRSP         IFNE      WSBRSP
     C     SBRSP         ORNE      WZBRSP
      *                                                                                       CSW213
     C********** SISOC     IFNE SIBAC                                                CSW213 MD023458
     C**********           MOVEL'ME21855' ZAMSID                                     CSW213 MD023458
     C**********           MOVEL'MEMSG'   ZAMSGF                                     CSW213 MD023458
     C**********           EXSR ZASNMS                                               CSW213 MD023458
     C**********           MOVE *ON       *IN59                                      CSW213 MD023458
     C**********           EXSR SIBSCE                                               CSW213 MD023458
     C**********           ENDIF                                                     CSW213 MD023458
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      SBRSP         ZFIELD
     C                   Z-ADD     2             ZADIG
     C                   Z-ADD     0             ZADEC
     C                   EXSR      ZALIGN
     C     *IN99         IFEQ      *ON
     C                   MOVEL     'ME21854'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   MOVE      *ON           *IN59
     C                   ELSE
     C                   MOVE      ZFIELD        ZBRSP             2 0
     C                   EXSR      ZEDIT
     C     SBRSP         IFNE      *BLANKS
     C                   MOVE      ZFIELD        SBRSP
     C                   ENDIF
     C                   MOVE      ZFIELD        WZBRSP
     C                   ENDIF
      *                                                                                       CSW213
     C                   ENDIF
      *                                                                                       CSW213
      ** Branch ID Length                                                                     CSW213
      *                                                                                       CSW213
     C********** SBRLN     IFNE *BLANK                                               CSW213 MD022295
     C********** SBRLN     ANDNEWSBRLN                                               CSW213 MD022295
     C     SBRLN         IFNE      WSBRLN
     C     SBRLN         ORNE      WZBRLN
      *                                                                                       CSW213
     C********** SISOC     IFNE SIBAC                                                CSW213 MD023458
     C**********           MOVEL'ME21858' ZAMSID                                     CSW213 MD023458
     C**********           MOVEL'MEMSG'   ZAMSGF                                     CSW213 MD023458
     C**********           EXSR ZASNMS                                               CSW213 MD023458
     C**********           MOVE *ON       *IN58                                      CSW213 MD023458
     C**********           EXSR SIBSCE                                               CSW213 MD023458
     C**********           ENDIF                                                     CSW213 MD023458
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      SBRLN         ZFIELD
     C**********           Z-ADD1         ZADIG                                      CSW213 MD021957
     C                   Z-ADD     2             ZADIG
     C                   Z-ADD     0             ZADEC
     C                   EXSR      ZALIGN
     C     *IN99         IFEQ      *ON
     C                   MOVEL     'ME21857'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   MOVE      *ON           *IN58
     C                   ELSE
     C                   MOVE      ZFIELD        ZBRLN             2 0
     C                   EXSR      ZEDIT
     C     SBRLN         IFNE      *BLANKS
     C                   MOVE      ZFIELD        SBRLN
     C                   ENDIF
     C                   MOVE      ZFIELD        WZBRLN
     C                   ENDIF
      *                                                                                       CSW213
     C                   ENDIF
      *                                                                                       CSW213
      ** Branch ID Length and Start Position                                                  CSW213
      *                                                                                       CSW213
     C     WREFR         IFEQ      'Y'
      *                                                                                       CSW213
     C     ZTILN         ADD       1             TFCTR             3 0
     C     TFCTR         SUB       ZBRLN         TFCTR
     C     ZBRSP         IFGT      TFCTR
     C                   MOVEL     'ME21856'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   MOVE      *ON           *IN59
     C                   ENDIF
      *                                                                                       CSW213
     C     ZTILN         ADD       1             TFCTR             3 0
     C     TFCTR         SUB       ZBRSP         TFCTR
     C     ZBRLN         IFGT      TFCTR
     C                   MOVEL     'ME21859'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   MOVE      *ON           *IN58
     C                   ENDIF
      *                                                                                       CSW213
     C                   ENDIF
      *                                                                                       CSW213
      ** BBAN Bank Length                                                                     CSW213
      *                                                                                       CSW213
     C********** STBLN     IFEQ *BLANK                                               CSW213 MD022957
     C********** WREFR     ANDEQ'Y'                                                  CSW213 MD022957
     C********** WWARN     ANDGE10                                                   CSW213 MD022957
     C**********           MOVEL'ME21878' ZAMSID                                     CSW213 MD022957
     C**********           MOVEL'MEMSG'   ZAMSGF                                     CSW213 MD022957
     C**********           EXSR ZASNMS                                               CSW213 MD022957
     C**********           MOVE *ON       *IN62                                      CSW213 MD022957
     C**********           MOVE 'Y'       WERROR                                     CSW213 MD022957
     C**********           ENDIF                                                     CSW213 MD022957
      **********                                                                     CSW213 MD022957
     C********** STBLN     IFNE *BLANK                                               CSW213 MD022957
     C********** STBLN     ANDNEWSTBLN                                               CSW213 MD022957
      **********                                                                     CSW213 MD022957
     C********** SISOC     IFNE SIBAC                                                CSW213 MD022957
     C**********           MOVEL'ME21853' ZAMSID                                     CSW213 MD022957
     C**********           MOVEL'MEMSG'   ZAMSGF                                     CSW213 MD022957
     C**********           EXSR ZASNMS                                               CSW213 MD022957
     C**********           MOVE *ON       *IN62                                      CSW213 MD022957
     C**********           EXSR SIBSCE                                               CSW213 MD022957
     C**********           ENDIF                                                     CSW213 MD022957
      *                                                                                       CSW213
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      STBLN         ZFIELD
     C                   Z-ADD     2             ZADIG
     C                   Z-ADD     0             ZADEC
     C                   EXSR      ZALIGN
     C     *IN99         IFEQ      *ON
     C                   MOVEL     'USR3717'     ZAMSID
     C                   MOVEL     'GB'          ZAMSGF
     C                   MOVE      'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      *BLANKS       ZAMSGF
     C                   MOVE      'Y'           WERROR
     C                   MOVE      *ON           *IN62
     C                   ELSE
     C                   MOVE      ZFIELD        ZTBLN             2 0
     C                   EXSR      ZEDIT
     C     ZTBLN         IFEQ      0
     C                   MOVE      *BLANKS       STBLN
     C                   ELSE
     C                   MOVE      ZFIELD        STBLN
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSW213
     C     STBLN         IFEQ      *BLANK
     C     WREFR         ANDEQ     'Y'
     C     WRUN          ANDEQ     'Y'
     C                   MOVEL     'ME21878'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN62
     C                   MOVE      'Y'           WERROR
     C                   ENDIF
      *                                                                                     MD022957
     C                   MOVE      *BLANKS       WTBLN             2 0
     C     ZBILN         ADD       ZBRLN         WTBLN
     C     ZTBLN         IFLT      WTBLN
     C                   MOVEL     'ME21884'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      *BLANKS       ZAMSGF
     C                   MOVE      'Y'           WERROR
     C                   MOVE      *ON           *IN62
     C                   ENDIF
      *                                                                                     MD022957
     C     STBLN         IFNE      WSTBLN
     C     SCSEL         ANDEQ     'A'
     C     W2TBLN        ORNE      WSTBLN
     C     SCSEL         ANDEQ     *BLANKS
      *                                                                                       CFT051
     C     CFT051        IFEQ      'Y'
      *                                                                                       CFT051
     C     ZTBLN         IFLE      0
     C     W2TBLN        ANDNE     *BLANKS
     C     ZTBLN         ORGT      15
     C     W2TBLN        ANDNE     *BLANKS
     C                   MOVEL     'USR0963'     ZAMSID
     C                   MOVEL     'GB'          ZAMSGF
     C                   MOVE      'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      *BLANKS       ZAMSGF
     C                   MOVE      'Y'           WERROR
     C                   MOVE      *ON           *IN62
     C                   ENDIF
      *                                                                                       CFT051
     C                   ELSE
      *                                                                                       CFT051
     C********** ZTBLN     IFLT 0                                                    CSW213 MD022957
     C********** ZTBLN     IFLE 0                                                  MD022957 MD048931
     C********** W2TBLN    ANDNE*BLANKS                                              CFT051 MD048931
     C********** ZTBLN     ORGT 10                                                   CSW213 MD048931
     C********** W2TBLN    ANDNE*BLANKS                                              CFT051 MD048931
     C**********           MOVEL'USR3720' ZAMSID                                     CSW213 MD048931
     C**********           MOVEL'GB'      ZAMSGF                                     CSW213 MD048931
     C**********           MOVE 'SDUSRMSG'ZAMSGF                                     CSW213 MD048931
     C**********           EXSR ZASNMS                                               CSW213 MD048931
     C**********           MOVE *BLANKS   ZAMSGF                                     CSW213 MD048931
     C**********           MOVE 'Y'       WERROR                                     CSW213 MD048931
     C**********           MOVE *ON       *IN62                                      CSW213 MD048931
     C**********           ENDIF                                                     CSW213 MD048931
      *                                                                                       CSW213
     C                   ENDIF
      *                                                                                       CFT051
     C     ZBBLN         IFEQ      0
     C********** ZTBLN     IFGT 0                                                    CSW213 MD023040
     C********** ZTBLN     IFGE 0                                                    MD023040 CFT051
     C     ZTBLN         IFGT      0
     C                   MOVEL     'USR3719'     ZAMSID
     C                   MOVEL     'GB'          ZAMSGF
     C                   MOVE      'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      *BLANKS       ZAMSGF
     C                   MOVE      'Y'           WERROR
     C                   MOVE      *ON           *IN62
     C                   ENDIF
      *                                                                                       CSW213
     C                   ELSE
     C     ZTBLN         IFGT      ZBBLN
     C                   MOVEL     'USR3721'     ZAMSID
     C                   MOVEL     'GB'          ZAMSGF
     C                   MOVE      'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      *BLANKS       ZAMSGF
     C                   MOVE      'Y'           WERROR
     C                   MOVE      *ON           *IN62
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSW213
     C     SISOC         IFNE      SIBAC
     C                   MOVEL     'ME21853'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN62
     C                   EXSR      SIBSCE
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSW213
      ** IBAN National Id Length                                                              CSW213
      *                                                                                       CSW213
     C********** SINLN     IFNE *BLANK                                               CSW213 MD022295
     C********** SINLN     ANDNEWSINLN                                               CSW213 MD022295
     C     SINLN         IFNE      WSINLN
     C     SINLN         ORNE      WZINLN
      *                                                                                       CSW213
     C********** SISOC     IFNE SIBAC                                                CSW213 MD023458
     C**********           MOVEL'ME21862' ZAMSID                                     CSW213 MD023458
     C**********           MOVEL'MEMSG'   ZAMSGF                                     CSW213 MD023458
     C**********           EXSR ZASNMS                                               CSW213 MD023458
     C**********           MOVE *ON       *IN63                                      CSW213 MD023458
     C**********           EXSR SIBSCE                                               CSW213 MD023458
     C**********           ENDIF                                                     CSW213 MD023458
      *                                                                                       CSW213
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      *BLANKS       W2TBLN
     C                   MOVE      SINLN         ZFIELD
     C                   MOVE      STBLN         W2TBLN            2
     C                   Z-ADD     2             ZADIG
     C                   Z-ADD     0             ZADEC
     C                   EXSR      ZALIGN
     C     *IN99         IFEQ      *ON
     C                   MOVEL     'ME21861'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   MOVE      *ON           *IN63
     C                   ELSE
     C                   MOVE      ZFIELD        ZINLN             2 0
     C                   EXSR      ZEDIT
     C     SINLN         IFNE      *BLANKS
     C                   MOVE      ZFIELD        SINLN
     C                   ENDIF
     C                   MOVE      ZFIELD        WZINLN
     C                   ENDIF
      *                                                                                       CSW213
     C     ZINLN         IFGT      ZTILN
     C                   MOVEL     'ME21863'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   MOVE      *ON           *IN63
     C                   ENDIF
      *                                                                                       CSW213
     C                   ENDIF
      *                                                                                       CSW213
      ** Account Number Start Position                                                        CSW213
      *                                                                                       CSW213
     C     SACSP         IFNE      WSACSP
     C     SACSP         ORNE      WZACSP
      *                                                                                       CSW213
     C     SISOC         IFNE      SIBAC
     C                   MOVEL     'ME21865'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN65
     C                   EXSR      SIBSCE
     C                   ENDIF
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      SACSP         ZFIELD
     C                   Z-ADD     2             ZADIG
     C                   Z-ADD     0             ZADEC
     C                   EXSR      ZALIGN
     C     *IN99         IFEQ      *ON
     C                   MOVEL     'ME21864'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   MOVE      *ON           *IN65
     C                   ELSE
     C                   MOVE      ZFIELD        ZACSP             2 0
     C                   EXSR      ZEDIT
     C     SACSP         IFNE      *BLANKS
     C                   MOVE      ZFIELD        SACSP
     C                   ENDIF
     C                   MOVE      ZFIELD        WZACSP
     C                   ENDIF
      *                                                                                       CSW213
     C                   ENDIF
      *                                                                                       CSW213
      ** Account Number Length                                                                CSW213
      *                                                                                       CSW213
     C********** SACLN     IFNE WSACLN                                               CSW213 MD022957
     C********** SACLN     ORNE WZACLN                                               CSW213 MD022957
      **********                                                                     CSW213 MD022957
     C********** SISOC     IFNE SIBAC                                                CSW213 MD022957
     C**********           MOVEL'ME21868' ZAMSID                                     CSW213 MD022957
     C**********           MOVEL'MEMSG'   ZAMSGF                                     CSW213 MD022957
     C**********           EXSR ZASNMS                                               CSW213 MD022957
     C**********           MOVE *ON       *IN64                                      CSW213 MD022957
     C**********           EXSR SIBSCE                                               CSW213 MD022957
     C**********           ENDIF                                                     CSW213 MD022957
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      SACLN         ZFIELD
     C                   Z-ADD     2             ZADIG
     C                   Z-ADD     0             ZADEC
     C                   EXSR      ZALIGN
     C     *IN99         IFEQ      *ON
     C                   MOVEL     'ME21867'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   MOVE      *ON           *IN64
     C                   ELSE
     C                   MOVE      ZFIELD        ZACLN             2 0
     C                   EXSR      ZEDIT
     C     SACLN         IFNE      *BLANKS
     C                   MOVE      ZFIELD        SACLN
     C                   ENDIF
     C                   MOVE      ZFIELD        WZACLN
     C                   ENDIF
      *                                                                                       CSW213
     C********** SACLN     IFNE WSACLN                                             MD022957 MD023458
     C********** SACLN     ORNE WZACLN                                             MD022957 MD023458
      **********                                                                   MD022957 MD023458
     C********** SISOC     IFNE SIBAC                                              MD022957 MD023458
     C**********           MOVEL'ME21868' ZAMSID                                   MD022957 MD023458
     C**********           MOVEL'MEMSG'   ZAMSGF                                   MD022957 MD023458
     C**********           EXSR ZASNMS                                             MD022957 MD023458
     C**********           MOVE *ON       *IN64                                    MD022957 MD023458
     C**********           EXSR SIBSCE                                             MD022957 MD023458
     C**********           ENDIF                                                   MD022957 MD023458
     C**********           ENDIF                                                     CSW213 MD023458
      *                                                                                       CSW213
      ** Account Number Length and Start Position                                             CSW213
      *                                                                                       CSW213
     C*********  ZACLN     IFNE 0                                                    CSW213 MD021995
     C*********  ZACSP     ANDNE0                                                    CSW213 MD021995
     C*********  WREFR     ANDEQ'Y'                                                  CSW213 MD021995
     C     WREFR         IFEQ      'Y'
      *                                                                                       CSW213
     C     ZTILN         ADD       1             TFCTR             3 0
     C     TFCTR         SUB       ZACLN         TFCTR
     C     ZACSP         IFGT      TFCTR
     C                   MOVEL     'ME21866'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   MOVE      *ON           *IN65
     C                   ENDIF
      *                                                                                       CSW213
     C     ZTILN         ADD       1             TFCTR             3 0
     C     TFCTR         SUB       ZACSP         TFCTR
     C     ZACLN         IFGT      TFCTR
     C                   MOVEL     'ME21869'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   MOVE      *ON           *IN64
     C                   ENDIF
      *                                                                                       CSW213
     C                   ENDIF
      *                                                                                     MD022957
     C     ZTILN         IFGT      0
     C     ZTBLN         ANDGT     0
     C     ZACLN         ANDEQ     0
     C     WREFR         ANDEQ     'Y'
      *                                                                                     MD022957
      ** Default Account Number Length if IBAN Total Length and                             MD022957
      ** BBAN Bank Length are input                                                         MD022957
      *                                                                                     MD022957
     C     *IN61         IFEQ      *OFF
     C     *IN62         ANDEQ     *OFF
     C                   MOVE      *BLANKS       ZFIELD
     C     ZTILN         SUB       4             WACLN             2 0
     C     WACLN         SUB       ZTBLN         ZACLN
     C     ZACLN         IFGE      0
     C                   MOVE      ZACLN         ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SACLN
     C                   ENDIF
      *                                                                                     MD022957
     C                   ELSE
     C                   MOVEL     'ME21882'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   MOVE      *ON           *IN64
     C                   ENDIF
      *                                                                                     MD022957
     C                   ENDIF
      *                                                                                     MD022957
      ** IBAN Total Length must be greater than or equal to the sum                         MD022957
      ** of Country Code Length, IBAN Check Digit Length, BBAN Bank                         MD022957
      ** Length and Account Number Length                                                   MD022957
      *                                                                                     MD022957
     C     ZACLN         IFGT      0
      *                                                                                     MD022957
     C                   Z-ADD     0             WTILN             2 0
     C     ZCCLN         ADD       ZICLN         WTILN
     C     WTILN         ADD       ZTBLN         WTILN
     C     WTILN         ADD       ZACLN         WTILN
      *                                                                                     MD022957
     C     ZTILN         IFLT      WTILN
     C                   MOVEL     'ME21883'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   MOVE      *ON           *IN61
     C                   ENDIF
      *                                                                                     MD022957
     C                   ENDIF
      *                                                                                       CSW213
     C     ZBBLN         IFGT      ZTILN
     C     ZBBLN         ORLT      ZCCLN
     C     ZBBLN         ORLT      ZICLN
     C     ZBBLN         ORLT      ZBILN
     C     ZBBLN         ORLT      ZBRLN
     C     ZBBLN         ORLT      ZTBLN
     C     ZBBLN         ORLT      ZINLN
     C     ZBBLN         ORLT      ZACLN
     C                   MOVEL     'USR0798'     ZAMSID
     C                   MOVEL     'GB'          ZAMSGF
     C                   MOVE      'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      *BLANKS       ZAMSGF
     C                   MOVE      'Y'           WERROR
     C                   MOVE      *ON           *IN55
     C                   ENDIF
      *                                                                                       CSW213
      ** Optional Commence Date                                                               CSW213
      *                                                                                       CSW213
     C                   MOVE      'N'           WDERR             1
     C     SOCDT         IFEQ      *BLANKS
     C                   Z-ADD     0             ZOCDT
     C                   ENDIF
      *                                                                                       CSW213
     C     SOCDT         IFNE      *BLANKS
     C     SOCDT         ANDNE     WSOCDT
     C     SISOC         IFNE      SIBAC
     C                   MOVEL     'ME21830'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN47
     C                   EXSR      SIBSCE
     C                   ENDIF
      *                                                                                       CSW213
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      SOCDT         ZFIELD
     C                   Z-ADD     6             ZADIG
     C                   Z-ADD     0             ZADEC
     C                   EXSR      ZALIGN
     C     *IN99         IFEQ      *ON
     C                   MOVE      'Y'           WDERR
     C                   ENDIF
      *                                                                                       CSW213
     C                   MOVE      SOCDT         ZDATE
     C                   EXSR      ZDATE1
     C     *IN99         IFEQ      *ON
     C     WDERR         OREQ      'Y'
     C                   MOVEL     'ME21829'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   MOVE      *ON           *IN47
     C                   ELSE
     C                   Z-ADD     ZDAYNO        ZOCDT             5 0
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSW213
      ** Mandatory Commence Date                                                              CSW213
      *                                                                                       CSW213
     C                   MOVE      'N'           WDERR
     C     SMCDT         IFEQ      *BLANKS
     C                   Z-ADD     0             ZMCDT
     C                   ENDIF
      *                                                                                       CSW213
     C     SMCDT         IFNE      *BLANKS
     C     SMCDT         ANDNE     WSMCDT
     C     SISOC         IFNE      SIBAC
     C                   MOVEL     'ME21832'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN48
     C                   EXSR      SIBSCE
     C                   ENDIF
      *                                                                                       CSW213
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      SOCDT         ZFIELD
     C                   Z-ADD     6             ZADIG
     C                   Z-ADD     0             ZADEC
     C                   EXSR      ZALIGN
     C     *IN99         IFEQ      *ON
     C                   MOVE      'Y'           WDERR
     C                   ENDIF
      *                                                                                       CSW213
     C                   MOVE      *BLANKS       ZDATE
     C                   MOVE      SMCDT         ZDATE
     C                   EXSR      ZDATE1
     C     *IN99         IFEQ      *ON
     C     WDERR         OREQ      'Y'
     C                   MOVEL     'ME21831'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   MOVE      *ON           *IN48
     C                   ELSE
     C                   Z-ADD     ZDAYNO        ZMCDT             5 0
     C                   ENDIF
     C                   ENDIF
      *================================================================                       CSW213
     CSR   EXIBSC        ENDSR
      /EJECT                                                                                  CSW213
     CSR   SIBSCE        BEGSR
      *================================================================                       CSW213
      ** Invalidate Change IBAN Country Code for non-reference                                CSW213
      *================================================================                       CSW213
     C                   MOVE      'Y'           WERROR
     C                   MOVE      *ON           *IN45
      *================================================================                       CSW213
     CSR   EXBSCE        ENDSR
      /EJECT                                                                                  CSW213
     CSR   SRSYNC        BEGSR
      *================================================================                       CSW213
      ** Synchronize BBAN Length and BBAN Bank Length for any attached                        CSW213
      *================================================================                       CSW213
     C     SIBAC         IFEQ      SISOC
     C                   EXSR      SSYNCO
     C                   ELSE
     C                   EXSR      SSYNCS
     C                   ENDIF
      *================================================================                       CSW213
     CSR   EXSYNC        ENDSR
      /EJECT                                                                                  CSW213
     CSR   SSYNCO        BEGSR
      *================================================================                       CSW213
      ** Synchronize IBAN Structure to any attached ISO records and                           CSW213
      ** update BBAN Length and BBAN Bank Length in SDCTRYPD                                  CSW213
      *================================================================                       CSW213
     C                   MOVE      *OFF          *IN60
     C                   MOVE      *BLANKS       WISOC
     C                   MOVE      M3IBAC        WIBAC
     C                   MOVE      M3IBAC        RFIBAC
     C                   MOVE      M3BBLN        RFBBLN
     C                   MOVE      M3TBLN        RFTBLN
     C                   EXSR      MOVREF
      *                                                                                       CSW213
     C******LOVAL        SETLL     MEISOCL3                                                 MD058081
     C*****KSYNC         SETLL     MEISOCL3                                                 MD058081
     C*****KSYNC         READE     MEISOCL3                               60                MD058081
     C/EXEC SQL                                                                             MD058081
     C+ close ICursor                                                                       MD058081
     C/END-EXEC                                                                             MD058081
                                                                                            MD058081
     C/EXEC SQL                                                                             MD058081
     C+ declare ICursor insensitive scroll cursor for                                       MD058081
     C+ select * from MEISOJW0                                                              MD058081
     C+ where M3IBAC = :WIBAC                                                               MD058081
     C+ order by M3IBAC                                                                     MD058081
     C/END-EXEC                                                                             MD058081
                                                                                            MD058081
     C/EXEC SQL                                                                             MD058081
     C+ open ICursor                                                                        MD058081
     C/END-EXEC                                                                             MD058081
                                                                                            MD058081
     C/EXEC SQL                                                                             MD058081
     C+ fetch next from ICursor into :MEISOC                                                MD058081
     C/END-EXEC                                                                             MD058081
      *                                                                                       CSW213
     C******IN60         DOWEQ     *OFF                                                     MD058081
     C     SQLCODE       DOWEQ     0                                                        MD058081
     C                   MOVE      M3ISOC        NRISOC
      *                                                                                       CSW213
     C     M3ISOC        IFNE      RFIBAC
     C*****NRISOC        CHAIN     MEISOCL0                           60                    MD058081
     C/EXEC SQL                                                                             MD058081
     C+ SELECT *                                                                            MD058081
     C+ into :MEISOC                                                                        MD058081
     C+ from MEISOJW0                                                                       MD058081
     C+ where M3ISOC = :NRISOC                                                              MD058081
     C/END-EXEC                                                                             MD058081
     C******IN60         IFEQ      '0'                                                      MD058081
     C     SQLCODE       IFEQ      0                                                        MD058081
     C                   EXSR      RTVREF
     C**********         UPDATE    @ISOCL0                              91                  MD058081
     C/EXEC SQL                                                                             MD058081
     C+ update MEISOXTD set                                                                 MD058081
     C+   M3OCDT = :M3OCDT                                                                  MD058081
     C+ , M3MCDT = :M3MCDT                                                                  MD058081
     C+ , M3CCSP = :M3CCSP                                                                  MD058081
     C+ , M3CCLN = :M3CCLN                                                                  MD058081
     C+ , M3ICSP = :M3ICSP                                                                  MD058081
     C+ , M3ICLN = :M3ICLN                                                                  MD058081
     C+ , M3BBSP = :M3BBSP                                                                  MD058081
     C+ , M3BBLN = :M3BBLN                                                                  MD058081
     C+ , M3BISP = :M3BISP                                                                  MD058081
     C+ , M3BILN = :M3BILN                                                                  MD058081
     C+ , M3BRSP = :M3BRSP                                                                  MD058081
     C+ , M3BRLN = :M3BRLN                                                                  MD058081
     C+ , M3INLN = :M3INLN                                                                  MD058081
     C+ , M3ACSP = :M3ACSP                                                                  MD058081
     C+ , M3ACLN = :M3ACLN                                                                  MD058081
     C+ , M3TBLN = :M3TBLN                                                                  MD058081
     C+ , M3TILN = :M3TILN                                                                  MD058081
     C+ where M3ISOC = :NRISOC                                                              MD058081
     C/END-EXEC                                                                             MD058081
      *                                                                                       CSW213
      ** Display error msg if file update not successful                                      CSW213
      *                                                                                       CSW213
     C******IN91         IFEQ      *ON                                                      MD058081
     C     SQLCODE       IFNE      0                                                        MD058081
     C                   MOVEL     'ME00011'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   ELSE
     C                   eval      WDBRC = M3ISOC                                           MD058081
     C                   MOVEL     WDBRC         SDBRC
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSW213
     C                   ENDIF
      *                                                                                       CSW213
      ** Synchronize in A4BBAN and A4BBRL in SDCTRYPD                                         CSW213
      *                                                                                       CSW213
     C                   EXSR      SSYNCC
      *                                                                                       CSW213
     C*****KSYNC         READE     MEISOCD0                               60                MD058081
     C/EXEC SQL                                                                             MD058081
     C+ fetch next from ICursor into :MEISOC                                                MD058081
     C/END-EXEC                                                                             MD058081
     C                   ENDDO
     C/EXEC SQL                                                                             MD058081
     C+ close ICursor                                                                       MD058081
     C/END-EXEC                                                                             MD058081
                                                                                            MD058081
      *================================================================                       CSW213
     CSR   EXYNCO        ENDSR
      /EJECT                                                                                  CSW213
     CSR   SSYNCS        BEGSR
      *================================================================                       CSW213
      ** Synchronize IBAN Structure on Reference                                              CSW213
      *================================================================                       CSW213
     C                   MOVE      M3ISOC        NRISOC
     C                   MOVE      M3IBAC        WIBAC
      *                                                                                       CSW213
     C*****KSYNC         CHAIN     MEISOCL3                           60                    MD058081
     C/EXEC SQL                                                                             MD058081
     C+ SELECT *                                                                            MD058081
     C+ into :MEISOC                                                                        MD058081
     C+ from MEISOJW0                                                                       MD058081
     C+ where M3IBAC = :WIBAC                                                               MD058081
     C/END-EXEC                                                                             MD058081
      *                                                                                       CSW213
     C******IN60         IFEQ      *OFF                                                     MD058081
     C     SQLCODE       IFEQ      0                                                        MD058081
     C                   EXSR      MOVREF
     C*****NRISOC        CHAIN     MEISOCL0                           60                    MD058081
     C/EXEC SQL                                                                             MD058081
     C+ SELECT *                                                                            MD058081
     C+ into :MEISOC                                                                        MD058081
     C+ from MEISOJW0                                                                       MD058081
     C+ where M3ISOC = :NRISOC                                                              MD058081
     C/END-EXEC                                                                             MD058081
     C******IN60         IFEQ      '0'                                                      MD058081
     C     SQLCODE       IFEQ      0                                                        MD058081
     C                   EXSR      RTVREF
     C**********         UPDATE    @ISOCL0                              91                  MD058081
     C/EXEC SQL                                                                             MD058081
     C+ update MEISOXTD set                                                                 MD058081
     C+   M3OCDT = :M3OCDT                                                                  MD058081
     C+ , M3MCDT = :M3MCDT                                                                  MD058081
     C+ , M3CCSP = :M3CCSP                                                                  MD058081
     C+ , M3CCLN = :M3CCLN                                                                  MD058081
     C+ , M3ICSP = :M3ICSP                                                                  MD058081
     C+ , M3ICLN = :M3ICLN                                                                  MD058081
     C+ , M3BBSP = :M3BBSP                                                                  MD058081
     C+ , M3BBLN = :M3BBLN                                                                  MD058081
     C+ , M3BISP = :M3BISP                                                                  MD058081
     C+ , M3BILN = :M3BILN                                                                  MD058081
     C+ , M3BRSP = :M3BRSP                                                                  MD058081
     C+ , M3BRLN = :M3BRLN                                                                  MD058081
     C+ , M3INLN = :M3INLN                                                                  MD058081
     C+ , M3ACSP = :M3ACSP                                                                  MD058081
     C+ , M3ACLN = :M3ACLN                                                                  MD058081
     C+ , M3TBLN = :M3TBLN                                                                  MD058081
     C+ , M3TILN = :M3TILN                                                                  MD058081
     C+ where M3ISOC = :NRISOC                                                              MD058081
     C/END-EXEC                                                                             MD058081
      *                                                                                       CSW213
      ** Display error msg if file update not successful                                      CSW213
      *                                                                                       CSW213
     C******IN91         IFEQ      *ON                                                      MD058081
     C     SQLCODE       IFNE      0                                                        MD058081
     C                   MOVEL     'ME00011'     ZAMSID
     C                   MOVEL     'MEMSG'       ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           WERROR
     C                   ELSE
     C                   eval      WDBRC = M3ISOC                                           MD058081
     C                   MOVEL     WDBRC         SDBRC
     C                   ENDIF
      *                                                                                       CSW213
     C                   ENDIF
     C                   EXSR      SSYNCC
     C                   ENDIF
      *================================================================                       CSW213
     CSR   EXYNCS        ENDSR
      /EJECT                                                                                  CSW213
     CSR   SSYNCC        BEGSR
      *================================================================                       CSW213
      ** Synchronize BBAN Length and BBAN Bank Length on SDCTRYPD                             CSW213
      *================================================================                       CSW213
     C     *LOVAL        SETLL     SDCTRYL2
     C     NRISOC        SETLL     SDCTRYL2
     C     NRISOC        READE     SDCTRYL2                               60
      *                                                                                       CSW213
     C     *IN60         DOWEQ     *OFF
     C                   Z-ADD     RFBBLN        A4BBAN
     C     CFT051        IFEQ      'Y'
     C                   Z-ADD     RFINLN        A4BBRL
     C                   ELSE
     C                   Z-ADD     RFTBLN        A4BBRL
     C                   ENDIF
     C                   UPDATE    SDCTRYD0
     C     NRISOC        READE     SDCTRYD0                               60
     C                   ENDDO
      *                                                                                       CSW213
     C                   MOVE      *OFF          *IN60
      *================================================================                       CSW213
     CSR   EXYNCC        ENDSR
      /EJECT                                                                                  CSW213
     CSR   SRRIBS        BEGSR
      *================================================================                       CSW213
      ** Retrieve Reference IBAN Structure values                                             CSW213
      *================================================================                       CSW213
     C*****RFIBAC        CHAIN     MEISOCL1                           60                    MD058081
     C/EXEC SQL                                                                             MD058081
     C+ SELECT *                                                                            MD058081
     C+ into :MEISOC                                                                        MD058081
     C+ from MEISOJW0                                                                       MD058081
     C+ where M3ISOC = :RFIBAC                                                              MD058081
     C/END-EXEC                                                                             MD058081
     C******IN60         IFEQ      *OFF                                                     MD058081
     C     SQLCODE       IFEQ      0                                                        MD058081
     C     RFIBAC        IFEQ      M3IBAC
     C                   EXSR      MOVREF
     C                   ENDIF
     C                   ENDIF
     C                   MOVE      *OFF          *IN60
     C     NRISOC        IFNE      *BLANKS
     C*****NRISOC        CHAIN     MEISOCL1                           60                    MD058081
     C/EXEC SQL                                                                             MD058081
     C+ SELECT *                                                                            MD058081
     C+ into :MEISOC                                                                        MD058081
     C+ from MEISOJW0                                                                       MD058081
     C+ where M3ISOC = :NRISOC                                                              MD058081
     C/END-EXEC                                                                             MD058081
     C******IN60         IFEQ      *OFF                                                     MD058081
     C     SQLCODE       IFEQ      0                                                        MD058081
     C                   EXSR      RTVREF
     C                   ENDIF
     C                   ENDIF
      *================================================================                       CSW213
     CSR   EXRIBS        ENDSR
      /EJECT                                                                                  CSW213
     CSR   SRRCTY        BEGSR
      *================================================================                       CSW213
      ** Retrieve SWIFTRef Country Code Description                                           CSW213
      *================================================================                       CSW213
     C                   MOVE      *BLANKS       SBICD
     C     CFT050        IFEQ      'Y'
     C********** WFLDC     CHAINMEBIB3L3             60                              CSW213 MD023358
     C     WFLDC         CHAIN     MEBICCL1                           60
     C     *IN60         IFEQ      *OFF
     C**********           MOVELB3CNT1    SBICD                                      CSW213 MD023358
     C                   MOVEL     BCCNTY        SBICD
     C                   ELSE
     C                   MOVEL     NFCNTY        SBICD
     C                   ENDIF
     C                   ENDIF
      *================================================================                       CSW213
     CSR   EXRCTY        ENDSR
      /EJECT                                                                                  CSW213
     CSR   SPOPDF        BEGSR
      *================================================================                       CSW213
      ** Moving to data to ME1740D1 and work fields                                           CSW213
      *================================================================                       CSW213
     C     SPREL         IFEQ      'N'
     C                   EXSR      SLSFFB
     C                   MOVEL     M3SEPA        SSEPA
     C                   MOVEL     M3IBAR        SIBAR
     C                   ENDIF
      *                                                                                       CSW213
     C     SIBAC         IFNE      *BLANKS
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      M3TILN        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        STILN
     C                   MOVE      ZFIELD        WSTILN
     C                   Z-ADD     M3TILN        ZTILN
      *                                                                                       CSW213
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      M3BBSP        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SBBSP
     C                   MOVE      ZFIELD        WSBBSP
     C                   Z-ADD     M3BBSP        ZBBSP
      *                                                                                       CSW213
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      M3BBLN        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SBBLN
     C                   MOVE      ZFIELD        WSBBLN
     C                   Z-ADD     M3BBLN        ZBBLN
      *                                                                                       CSW213
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      M3CCSP        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCCSP
     C                   MOVE      ZFIELD        WSCCSP
     C                   Z-ADD     M3CCSP        ZCCSP
      *                                                                                       CSW213
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      M3CCLN        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCCLN
     C                   MOVE      ZFIELD        WSCCLN
     C                   Z-ADD     M3CCLN        ZCCLN
      *                                                                                       CSW213
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      M3ICSP        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SICSP
     C                   MOVE      ZFIELD        WSICSP
     C                   Z-ADD     M3ICSP        ZICSP
      *                                                                                       CSW213
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      M3ICLN        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SICLN
     C                   MOVE      ZFIELD        WSICLN
     C                   Z-ADD     M3ICLN        ZICLN
      *                                                                                       CSW213
     C********** M3BISP    IFNE 0                                                  MD022401 MD022957
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      M3BISP        ZFIELD
     C                   EXSR      ZEDIT
     C     PMMODE        IFEQ      'M'
     C     SCSEL         ANDEQ     'A'
     C     M3BISP        ANDEQ     0
     C                   MOVE      *BLANKS       SBISP
     C                   MOVE      *BLANKS       WSBISP
     C                   ELSE
     C                   MOVE      ZFIELD        SBISP
     C                   MOVE      ZFIELD        WSBISP
     C                   ENDIF
     C                   Z-ADD     M3BISP        ZBISP
     C**********           ENDIF                                                   MD022401 MD022957
      *                                                                                       CSW213
     C********** M3BILN    IFNE 0                                                  MD022401 MD022957
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      M3BILN        ZFIELD
     C                   EXSR      ZEDIT
     C     PMMODE        IFEQ      'M'
     C     SCSEL         ANDEQ     'A'
     C     M3BILN        ANDEQ     0
     C                   MOVE      *BLANKS       SBILN
     C                   MOVE      *BLANKS       WSBILN
     C                   ELSE
     C                   MOVE      ZFIELD        SBILN
     C                   MOVE      ZFIELD        WSBILN
     C                   ENDIF
     C                   Z-ADD     M3BILN        ZBILN
     C**********           ENDIF                                                   MD022401 MD022957
      *                                                                                       CSW213
     C********** M3BRSP    IFNE 0                                                    CSW213 MD022957
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      M3BRSP        ZFIELD
     C                   EXSR      ZEDIT
     C     PMMODE        IFEQ      'M'
     C     SCSEL         ANDEQ     'A'
     C     M3BRSP        ANDEQ     0
     C                   MOVE      *BLANKS       SBRSP
     C                   MOVE      *BLANKS       WSBRSP
     C                   ELSE
     C                   MOVE      ZFIELD        SBRSP
     C                   MOVE      ZFIELD        WSBRSP
     C                   ENDIF
     C                   Z-ADD     M3BRSP        ZBRSP
     C**********           ENDIF                                                     CSW213 MD022957
     C********** M3BRLN    IFNE 0                                                    CSW213 MD022957
     C********** M3BRLN    OREQ 0                                                    CSW213 MD022957
     C********** M3INLN    ANDNE0                                                    CSW213 MD022957
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      M3BRLN        ZFIELD
     C                   EXSR      ZEDIT
     C     PMMODE        IFEQ      'M'
     C     SCSEL         ANDEQ     'A'
     C     M3BRLN        ANDEQ     0
     C                   MOVE      *BLANKS       SBRLN
     C                   MOVE      *BLANKS       WSBRLN
     C                   ELSE
     C                   MOVE      ZFIELD        SBRLN
     C                   MOVE      ZFIELD        WSBRLN
     C                   ENDIF
     C                   Z-ADD     M3BRLN        ZBRLN
     C**********           ENDIF                                                     CSW213 MD022957
     C********** M3TBLN    IFNE 0                                                    CSW213 MD022957
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      M3TBLN        ZFIELD
     C                   EXSR      ZEDIT
     C     PMMODE        IFEQ      'M'
     C     SCSEL         ANDEQ     'A'
     C     M3TBLN        ANDEQ     0
     C                   MOVE      *BLANKS       STBLN
     C                   MOVE      *BLANKS       WSTBLN
     C                   ELSE
     C                   MOVE      ZFIELD        STBLN
     C                   MOVE      ZFIELD        WSTBLN
     C                   ENDIF
     C                   Z-ADD     M3TBLN        ZTBLN
     C**********           ENDIF                                                     CSW213 MD022957
     C********** M3INLN    IFNE 0                                                    CSW213 MD022957
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      M3INLN        ZFIELD
     C                   EXSR      ZEDIT
     C     PMMODE        IFEQ      'M'
     C     SCSEL         ANDEQ     'A'
     C     M3INLN        ANDEQ     0
     C                   MOVE      *BLANKS       SINLN
     C                   MOVE      *BLANKS       WSINLN
     C                   ELSE
     C                   MOVE      ZFIELD        SINLN
     C                   MOVE      ZFIELD        WSINLN
     C                   ENDIF
     C                   Z-ADD     M3INLN        ZINLN
     C**********           ENDIF                                                     CSW213 MD022957
      *                                                                                       CSW213
     C********** M3ACSP    IFNE 0                                                  MD022401 MD022957
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      M3ACSP        ZFIELD
     C                   EXSR      ZEDIT
     C     PMMODE        IFEQ      'M'
     C     SCSEL         ANDEQ     'A'
     C     M3ACSP        ANDEQ     0
     C                   MOVE      *BLANKS       SACSP
     C                   MOVE      *BLANKS       WSACSP
     C                   MOVE      *BLANKS       WZACSP
     C                   ELSE
     C                   MOVE      ZFIELD        SACSP
     C                   MOVE      ZFIELD        WSACSP
     C                   MOVE      ZFIELD        WZACSP
     C                   ENDIF
     C                   Z-ADD     M3ACSP        ZACSP
     C**********           ENDIF                                                   MD022401 MD022957
      *                                                                                       CSW213
     C********** M3ACLN    IFNE 0                                                  MD022401 MD022957
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      M3ACLN        ZFIELD
     C                   EXSR      ZEDIT
     C     PMMODE        IFEQ      'M'
     C     SCSEL         ANDEQ     'A'
     C     M3ACLN        ANDEQ     0
     C                   MOVE      *BLANKS       SACLN
     C                   MOVE      *BLANKS       WSACLN
     C                   MOVE      *BLANKS       WZACLN
     C                   ELSE
     C                   MOVE      ZFIELD        SACLN
     C                   MOVE      ZFIELD        WSACLN
     C                   MOVE      ZFIELD        WZACLN
     C                   ENDIF
     C                   Z-ADD     M3ACLN        ZACLN
     C**********           ENDIF                                                   MD022401 MD022957
      *                                                                                       CSW213
     C     M3OCDT        IFNE      0
     C                   Z-ADD     M3OCDT        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         SOCDT
     C                   MOVE      ZDATE         WSOCDT
     C                   Z-ADD     M3OCDT        ZOCDT
     C                   ELSE
     C                   MOVE      *BLANKS       SOCDT
     C                   ENDIF
     C     M3MCDT        IFNE      0
     C                   Z-ADD     M3MCDT        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         SMCDT
     C                   MOVE      ZDATE         WSMCDT
     C                   Z-ADD     M3MCDT        ZMCDT
     C                   ELSE
     C                   MOVE      *BLANKS       SMCDT
     C                   ENDIF
     C                   ENDIF
      *================================================================                       CSW213
     CSR   EXOPDF        ENDSR
      /EJECT                                                                                  CSW213
     CSR   MOVREF        BEGSR
      *================================================================                       CSW213
      ** Move to reference DS                                                                 CSW213
      *================================================================                       CSW213
     C                   Z-ADD     M3OCDT        RFOCDT            5 0
     C                   Z-ADD     M3MCDT        RFMCDT            5 0
     C                   Z-ADD     M3CCSP        RFCCSP            2 0
     C                   Z-ADD     M3CCLN        RFCCLN            1 0
     C                   Z-ADD     M3ICSP        RFICSP            2 0
     C                   Z-ADD     M3ICLN        RFICLN            2 0
     C                   Z-ADD     M3BBSP        RFBBSP            2 0
     C                   Z-ADD     M3BBLN        RFBBLN            2 0
     C                   Z-ADD     M3BISP        RFBISP            2 0
     C                   Z-ADD     M3BILN        RFBILN            2 0
     C                   Z-ADD     M3BRSP        RFBRSP            2 0
     C                   Z-ADD     M3BRLN        RFBRLN            2 0
     C                   Z-ADD     M3INLN        RFINLN            2 0
     C                   Z-ADD     M3ACSP        RFACSP            2 0
     C                   Z-ADD     M3ACLN        RFACLN            2 0
     C                   Z-ADD     M3TBLN        RFTBLN            2 0
     C                   Z-ADD     M3TILN        RFTILN            2 0
      *================================================================                       CSW213
     CSR   EXMREF        ENDSR
      /EJECT                                                                                  CSW213
     C     RTVREF        BEGSR
      *================================================================                       CSW213
      ** Move to MEISOCPD fields                                                              CSW213
      *================================================================                       CSW213
     C                   Z-ADD     RFOCDT        M3OCDT
     C                   Z-ADD     RFMCDT        M3MCDT
     C                   Z-ADD     RFCCSP        M3CCSP
     C                   Z-ADD     RFCCLN        M3CCLN
     C                   Z-ADD     RFICSP        M3ICSP
     C                   Z-ADD     RFICLN        M3ICLN
     C                   Z-ADD     RFBBSP        M3BBSP
     C                   Z-ADD     RFBBLN        M3BBLN
     C                   Z-ADD     RFBISP        M3BISP
     C                   Z-ADD     RFBILN        M3BILN
     C                   Z-ADD     RFBRSP        M3BRSP
     C                   Z-ADD     RFBRLN        M3BRLN
     C                   Z-ADD     RFINLN        M3INLN
     C                   Z-ADD     RFACSP        M3ACSP
     C                   Z-ADD     RFACLN        M3ACLN
     C                   Z-ADD     RFTBLN        M3TBLN
     C                   Z-ADD     RFTILN        M3TILN
      *================================================================                       CSW213
     C     EXRREF        ENDSR
      /EJECT                                                                                  CSW213
     CSR   SPCLDF        BEGSR
      *================================================================                       CSW213
      ** Reset ME1740D1 screen for use                                                        CSW213
      *================================================================                       CSW213
     C                   MOVE      ##USR         WUSR             10
     C                   MOVE      SMRDT         WMRD              7
     C                   MOVE      ##JOB         WJOB             10
     C                   MOVE      STIME         WTIM              6 0
     C                   CLEAR                   ME1740D1
     C                   CLEAR                   WDBRC
     C                   MOVE      WUSR          ##USR
     C                   MOVE      WMRD          SMRDT
     C                   MOVE      WJOB          ##JOB
     C                   MOVE      WTIM          STIME
      *                                                                                       CSW213
     C                   EXSR      SRSIND
      *                                                                                       CSW213
     C                   Z-ADD     0             ZTILN
     C                   Z-ADD     0             ZBBSP
     C                   Z-ADD     0             ZBBLN
     C                   Z-ADD     0             ZCCSP
     C                   Z-ADD     0             ZCCLN
     C                   Z-ADD     0             ZICSP
     C                   Z-ADD     0             ZICLN
     C                   Z-ADD     0             ZBISP
     C                   Z-ADD     0             ZBILN
     C                   Z-ADD     0             ZBRSP
     C                   Z-ADD     0             ZBRLN
     C                   Z-ADD     0             ZTBLN
     C                   Z-ADD     0             ZINLN
     C                   Z-ADD     0             ZACSP
     C                   Z-ADD     0             ZACLN
     C                   Z-ADD     0             ZOCDT
     C                   Z-ADD     0             ZMCDT
      *                                                                                       CSW213
     C                   MOVE      *BLANKS       WSIBAR
     C                   MOVE      *BLANKS       WSOCDT
     C                   MOVE      *BLANKS       WSMCDT
     C                   MOVE      *BLANKS       WSCCSP
     C                   MOVE      *BLANKS       WSCCLN
     C                   MOVE      *BLANKS       WSICSP
     C                   MOVE      *BLANKS       WSICLN
     C                   MOVE      *BLANKS       WSBBSP
     C                   MOVE      *BLANKS       WSBBLN
     C                   MOVE      *BLANKS       WSBISP
     C                   MOVE      *BLANKS       WSBILN
     C                   MOVE      *BLANKS       WSBRSP
     C                   MOVE      *BLANKS       WSBRLN
     C                   MOVE      *BLANKS       WSINLN
     C                   MOVE      *BLANKS       WSACSP
     C                   MOVE      *BLANKS       WSACLN
     C                   MOVE      *BLANKS       WSTBLN
     C                   MOVE      *BLANKS       WSTILN
     C                   MOVE      *BLANKS       WZACSP
     C                   MOVE      *BLANKS       WZACLN
     C                   MOVE      *BLANKS       WZBISP
     C                   MOVE      *BLANKS       WZBILN
     C                   MOVE      *BLANKS       WZBRSP
     C                   MOVE      *BLANKS       WZBRLN
     C                   MOVE      *BLANKS       WZINLN
      *================================================================                       CSW213
     CSR   EXCLDF        ENDSR
      /EJECT                                                                                  CSW213
     CSR   SRSIND        BEGSR
      *================================================================                       CSW213
      ** Reset indicators for ME1740D1                                                        CSW213
      *================================================================                       CSW213
     C                   MOVEA     '00'          *IN(32)
     C**********           MOVEA'010'     *IN,36                                     CSW213 MD023077
     C                   MOVE      '0'           *IN36
     C                   MOVE      '0'           *IN38
     C                   MOVEA     '00'          *IN(41)
     C                   MOVEA     '000000'      *IN(44)
     C                   MOVEA     '00000000'    *IN(52)
     C                   MOVEA     '00000000'    *IN(61)
     C                   MOVE      *OFF          *IN67
     C                   MOVEA     '00'          *IN(71)
      *================================================================                       CSW213
     CSR   EXSIND        ENDSR
      /EJECT                                                                                  CSW213
     CSR   SLSFFB        BEGSR
      *================================================================                       CSW213
      ** Alternate SRLSFF routine                                                             CSW213
      *================================================================                       CSW213
      ** Move MEISOCL1 fields to subfile                                                      CSW213
      *================================================================                       CSW213
     C                   MOVEL     M3ACJN        SACJN
     C                   MOVEL     M3ACUN        SACUN
     C                   MOVEL     M3ACTM        SACTM
     C                   MOVEL     M3ACDA        SACDA
     C                   MOVEL     M3ACTY        SACTY
     C                   MOVEL     M3ISOC        SISOC
     C                   MOVEL     M3ISOD        SISOD
     C                   MOVEL     M3SCHT        SSCHT
     C                   MOVEL     M3EEAM        SSEEA
     C                   MOVEL     M3FATF        SFATF
     C                   MOVEL     M3IBAC        SIBAC
      *                                                                                       CSW213
     C     CSW207        IFEQ      'Y'
     C                   MOVEL     M3MFID        SMFID
     C                   ENDIF
      *                                                                                       CSW213
     C     CSW209        IFEQ      'Y'
     C                   MOVEL     M3M205        SM205
     C                   ENDIF
      *================================================================                       CSW213
     CSR   EXLSFB        ENDSR
      /EJECT                                                                                  CSW213
     CSR   SISFFB        BEGSR
      *================================================================                       CSW213
      ** Alternate SRISFF routine                                                             CSW213
      *================================================================                       CSW213
      ** Initialise subfile fields                                                            CSW213
      *================================================================                       CSW213
     C                   MOVE      *BLANKS       SDBRC
     C                   MOVE      *BLANKS       SCSEL
     C                   MOVE      *BLANKS       SACJN
     C                   MOVE      *BLANKS       SACUN
     C                   MOVE      *BLANKS       SACTM
     C                   MOVE      *BLANKS       SACDA
     C                   MOVE      *BLANKS       SACTY
     C                   MOVE      *BLANKS       SISOC
     C                   MOVE      *BLANKS       SISOD
     C                   MOVE      *BLANKS       SSCHT
     C                   MOVE      *BLANKS       SSEEA
     C                   MOVE      *BLANKS       SFATF
     C                   MOVE      *BLANKS       SIBAC
      *                                                                                       CSW213
     C     CSW207        IFEQ      'Y'
     C                   MOVE      *BLANKS       SMFID
     C                   ENDIF
     C     CSW209        IFEQ      'Y'
     C                   MOVE      *BLANKS       SM205
     C                   ENDIF
      *================================================================                       CSW213
     CSR   EXISFB        ENDSR
      /EJECT                                                                                  CSW213
     CSR   CHKCHG        BEGSR
      *================================================================                       CSW213
      ** Change for screen changes                                                            CSW213
      *================================================================                       CSW213
     C                   MOVE      'N'           WCHG              1
     C     SOCDT         IFNE      WSOCDT
     C     SMCDT         ORNE      WSMCDT
     C     SCCSP         ORNE      WSCCSP
     C     SCCLN         ORNE      WSCCLN
     C     SICSP         ORNE      WSICSP
     C     SICLN         ORNE      WSICLN
     C     SBBSP         ORNE      WSBBSP
     C     SBBLN         ORNE      WSBBLN
     C     SBISP         ORNE      WSBISP
     C     SBILN         ORNE      WSBILN
     C     SBRSP         ORNE      WSBRSP
     C     SBRLN         ORNE      WSBRLN
     C     SINLN         ORNE      WSINLN
     C     SACSP         ORNE      WSACSP
     C     SACLN         ORNE      WSACLN
     C     STBLN         ORNE      WSTBLN
     C     STILN         ORNE      WSTILN
     C                   MOVE      'Y'           WCHG
     C                   ENDIF
      *================================================================                       CSW213
     CSR   EXKCHG        ENDSR
      /EJECT                                                                                  CSW213
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
     C                   PARM                    PMISOC            2
      *
      ** Update LDA with initial values for DB error fields
      *
     C     *DTAARA       DEFINE    LDA           WLDA
     C     *LOCK         IN        WLDA
     C                   MOVE      *BLANKS       DBFILE
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVEL     'ME1740'      DBPGM
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
      *  If return with an error (LR seton in called program) then
      *  process for database error.
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
     C                   CALL      'AODEALR1'                                               MD058081
     C                   PARM      '*BLANK'      P@RTCD                                     MD058081
     C                   PARM      '*FIRST'      P@OPTN                                     MD058081
     C     SDDEAL        PARM      SDDEAL        DSFDY                                      MD058081
                                                                                            MD058081
      ** Get Midas Rundate
      *
     C                   MOVE      BJMRDT        SMRDT             7
      *
     C                   Z-ADD     14            WSFPG             3 0
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
     C                   Z-ADD     14            WSFLN             5 0
     C     PMMODE        IFEQ      'E'
      *
      ** Setup header text:
      *
     C                   MOVEL     'USR9103'     PMSGID            7            Message Identifier
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
     C                   MOVE      *BLANKS       WTXTE            80
     C                   MOVE      *BLANKS       WTXTE1           80
      *                                                                                       CSW213
     C                   MOVE      *BLANKS       PMSGT            80
     C                   MOVEL     'USR2920'     PMSGID
      *                                                                                       CSW213
     C                   CALL      'SDRTVTXT'                           90
     C     PMSGID        PARM      PMSGID        KE0286            7
     C     PMSGF         PARM      PMSGF         KE0287           10
     C     PMSGT         PARM      PMSGT         KE0288           80
     C                   MOVEL     PMSGT         WTXTE
      *                                                                                       CSW213
     C                   MOVE      *BLANKS       PMSGT            80
     C                   MOVEL     'USR9020'     PMSGID
      *                                                                                       CSW213
     C                   CALL      'SDRTVTXT'                           90
     C     PMSGID        PARM      PMSGID        KE0286            7
     C     PMSGF         PARM      PMSGF         KE0287           10
     C     PMSGT         PARM      PMSGT         KE0288           80
     C                   MOVEL     PMSGT         WTXTE1
      *                                                                                       CSW213
     C                   ELSE
      *
     C                   MOVEL     'SDUSRMSG'    PMSGF            10
     C                   MOVE      *BLANKS       PMSGT            80
      *
     C                   MOVEL     'USR9104'     PMSGID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     PMSGID        PARM      PMSGID        WQ0286            7            Message Identifier
     C     PMSGF         PARM      PMSGF         WQ0287           10            Message File Name
     C     PMSGT         PARM      PMSGT         WQ0288           80            Message Text
     C                   MOVEL     PMSGT         SURPT
      *
     C                   MOVE      *BLANKS       WTXTC            80
     C                   MOVE      *BLANKS       WTXTA            80
     C                   MOVE      *BLANKS       WTXTE            80
     C                   MOVE      *BLANKS       WTXTD            80
     C                   MOVE      *BLANKS       WTXTU            80
     C                   MOVE      *BLANKS       NFCNTY           80
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
      *                                                                                       CSW213
     C                   MOVE      *BLANKS       PMSGT            80
     C                   MOVEL     'USR4330'     PMSGID
      *                                                                                       CSW213
     C                   CALL      'SDRTVTXT'                           90
     C     PMSGID        PARM      PMSGID        KE0286            7
     C     PMSGF         PARM      PMSGF         KE0287           10
     C     PMSGT         PARM      PMSGT         KE0288           80
     C                   MOVEL     PMSGT         WTXTD
      *                                                                                       CSW213
     C                   MOVE      *BLANKS       PMSGT            80
     C                   MOVEL     'USR2920'     PMSGID
      *                                                                                       CSW213
     C                   CALL      'SDRTVTXT'                           90
     C     PMSGID        PARM      PMSGID        KE0286            7
     C     PMSGF         PARM      PMSGF         KE0287           10
     C     PMSGT         PARM      PMSGT         KE0288           80
     C                   MOVEL     PMSGT         WTXTE
      *                                                                                       CSW213
     C                   MOVE      *BLANKS       PMSGT            80
     C                   MOVEL     'USR9020'     PMSGID
      *                                                                                       CSW213
     C                   CALL      'SDRTVTXT'                           90
     C     PMSGID        PARM      PMSGID        KE0286            7
     C     PMSGF         PARM      PMSGF         KE0287           10
     C     PMSGT         PARM      PMSGT         KE0288           80
     C                   MOVEL     PMSGT         WTXTE1
      *                                                                                       CSW213
     C                   MOVE      *BLANKS       PMSGT            80
     C                   MOVEL     'USR0640'     PMSGID
      *                                                                                       CSW213
     C                   CALL      'SDRTVTXT'                           90
     C     PMSGID        PARM      PMSGID        KE0286            7
     C     PMSGF         PARM      PMSGF         KE0287           10
     C     PMSGT         PARM      PMSGT         KE0288           80
     C                   MOVEL     PMSGT         NFCNTY
      *                                                                                       CSW213
     C                   MOVE      *BLANKS       PMSGT            80
     C                   MOVEL     'GBY2USR'     PMSFT            10
     C                   MOVE      'MSG'         PMSFT
     C                   MOVEL     'Y2U0406'     PMSGID
      *                                                                                       CSW213
     C                   CALL      'SDRTVTXT'                           90
     C     PMSGID        PARM      PMSGID        KE0286            7
     C     PMSFT         PARM      PMSFT         KE0287           10
     C     PMSGT         PARM      PMSGT         KE0288           80
     C                   MOVEL     PMSGT         WTXTU
      *                                                                                       CSW213
     C                   ENDIF
      *                                                                                       CFT017
      ** Call access object to find out if switchable feature CFT017 is installed             CFT017
      *                                                                                       CFT017
     C                   MOVEL     'N'           CFT017            1
     C                   MOVEL     *OFF          *IN37
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CFT017'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CFT017
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF'
     C     *LOCK         IN        WLDA
     C                   MOVEL     'CFT017'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     002           DBASE
     C                   OUT       WLDA
     C                   EXSR      *PSSR
     C                   ELSE
      *                                                                                       CFT017
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CFT017
     C                   MOVE      *ON           *IN37
     C                   ENDIF
      *                                                                                       CFT017
     C                   ENDIF
      *                                                                                       CSW207
      ** Call SWIFT200 to find out if switchable feature CSW207 is installed                  CSW207
      *                                                                                       CSW207
     C                   CALL      'SWIF2007'
     C                   PARM      *BLANKS       P@RTCD
      *                                                                                       CSW207
     C     P@RTCD        IFEQ      'CSW2007'
     C                   MOVE      'Y'           CSW207            1
     C                   MOVE      *ON           *IN39
     C                   ELSE
     C**********           MOVE 'Y'       CSW207                                     CSW207 BUG14933
     C                   MOVE      'N'           CSW207
     C                   MOVE      *OFF          *IN39
     C                   ENDIF
      ** Check if SWIFT 2009 is installed                                                     CSW209
      *                                                                                       CSW209
     C                   CALL      'SWIF2009'
     C                   PARM                    P@RTCD
     C     P@RTCD        IFEQ      'CSW2009'
     C                   MOVE      'Y'           CSW209            1
     C                   MOVE      *ON           *IN43
     C                   ELSE
     C                   MOVE      *OFF          *IN43
     C                   ENDIF
      *
      ** Check if SWIFT 2013 is installed                                                     CSW213
      *                                                                                       CSW213
     C                   CALL      'SWIF2013'
     C                   PARM                    P@RTCD
     C     P@RTCD        IFEQ      'CSW2013'
     C                   MOVE      'Y'           CSW213            1
     C                   ELSE
     C                   MOVE      'N'           CSW213            1
     C                   ENDIF
      *                                                                                       CSW213
      ** Check if CFT004 is installed                                                         CSW213
      *                                                                                       CSW213
     C                   MOVEL     'N'           CFT004            1
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CFT004'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CSW213
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF'
     C     *LOCK         IN        WLDA
     C                   MOVEL     'CFT004'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     002           DBASE
     C                   OUT       WLDA
     C                   EXSR      *PSSR
     C                   ELSE
      *                                                                                       CSW213
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CFT004
     C                   ENDIF
      *                                                                                       CSW213
     C                   ENDIF
      *                                                                                       CSW213
      ** Check if CFT050 is installed                                                         CSW213
      *                                                                                       CSW213
     C                   MOVEL     'N'           CFT050            1
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CFT050'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CSW213
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF'
     C     *LOCK         IN        WLDA
     C                   MOVEL     'CFT050'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     002           DBASE
     C                   OUT       WLDA
     C                   EXSR      *PSSR
     C                   ELSE
      *                                                                                       CSW213
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CFT050
     C                   ENDIF
      *                                                                                       CSW213
     C                   ENDIF
      *                                                                                       CFT051
      ** Check if CFT051 is installed                                                         CFT051
      *                                                                                       CFT051
     C                   MOVEL     'N'           CFT051            1
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CFT051'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CFT051
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF'
     C     *LOCK         IN        WLDA
     C                   MOVEL     'CFT051'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     003           DBASE
     C                   OUT       WLDA
     C                   EXSR      *PSSR
     C                   ELSE
      *                                                                                       CFT051
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CFT051
     C                   ENDIF
      *                                                                                       CFT051
     C                   ENDIF
      *                                                                                       CSW213
      ** Check if CFT008 is installed                                                         CSW213
      *                                                                                       CSW213
     C                   MOVEL     'N'           CFT008            1
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CFT008'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CSW213
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF'
     C     *LOCK         IN        WLDA
     C                   MOVEL     'CFT008'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     002           DBASE
     C                   OUT       WLDA
     C                   EXSR      *PSSR
     C                   ELSE
      *                                                                                       CSW213
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CFT008
     C                   MOVE      *ON           *IN74
     C                   ENDIF
      *                                                                                       CSW213
     C                   ENDIF
      *                                                                                       CSW213
      ** Initialization definitions                                                           CSW213
      *                                                                                       CSW213
     C     KPOS          KLIST
     C                   KFLD                    M3ISOC
      *                                                                                       CSW213
     C     KSYNC         KLIST
     C                   KFLD                    WIBAC
      *                                                                                       CSW213
     C     *LIKE         DEFINE    SEISOC        WZISOC
     C     *LIKE         DEFINE    M3ISOC        WISOC
     C     *LIKE         DEFINE    M3ISOC        NRISOC
     C     *LIKE         DEFINE    M3IBAC        WIBAC
     C     *LIKE         DEFINE    M3IBAC        RFIBAC
     C     *LIKE         DEFINE    SIBAR         WSIBAR
     C     *LIKE         DEFINE    SOCDT         WSOCDT
     C     *LIKE         DEFINE    SMCDT         WSMCDT
     C     *LIKE         DEFINE    SCCSP         WSCCSP
     C     *LIKE         DEFINE    SCCLN         WSCCLN
     C     *LIKE         DEFINE    SICSP         WSICSP
     C     *LIKE         DEFINE    SICLN         WSICLN
     C     *LIKE         DEFINE    SBBSP         WSBBSP
     C     *LIKE         DEFINE    SBBLN         WSBBLN
     C     *LIKE         DEFINE    SBISP         WSBISP
     C     *LIKE         DEFINE    SBILN         WSBILN
     C     *LIKE         DEFINE    SBRSP         WSBRSP
     C     *LIKE         DEFINE    SBRLN         WSBRLN
     C     *LIKE         DEFINE    SINLN         WSINLN
     C     *LIKE         DEFINE    SACSP         WSACSP
     C     *LIKE         DEFINE    SACLN         WSACLN
     C     *LIKE         DEFINE    STBLN         WSTBLN
     C     *LIKE         DEFINE    STILN         WSTILN
     C     *LIKE         DEFINE    SACSP         WZACSP
     C     *LIKE         DEFINE    SACLN         WZACLN
     C     *LIKE         DEFINE    SBISP         WZBISP
     C     *LIKE         DEFINE    SBILN         WZBILN
     C     *LIKE         DEFINE    SBRSP         WZBRSP
     C     *LIKE         DEFINE    SBRLN         WZBRLN
     C     *LIKE         DEFINE    SINLN         WZINLN
      *                                                                                       CSW213
     C                   Z-ADD     99999         W0SLM
     C                   MOVE      *BLANKS       WMODE             3
     C     CSW213        IFNE      'Y'
     C     CFT050        ANDNE     'Y'
     C                   MOVEL     'CHG'         WMODE
     C                   ELSE
     C                   MOVE      'LST'         WMODE
      *                                                                                       CSW213
      ** Allow IBAN Structure field to be displayed                                           CSW213
      *                                                                                       CSW213
     C     CFT004        IFEQ      'Y'
     C     CFT050        IFEQ      'Y'
     C     CSW213        OREQ      'Y'
     C                   MOVE      'Y'           WIBNS             1
     C                   MOVE      *ON           *IN69
     C                   ELSE
     C                   MOVE      *OFF          *IN69
     C                   ENDIF
     C                   ENDIF
      *                                                                                     MD022777
      ** IBAN Required in MT102/MT103 field to be displayed                                 MD022777
      *                                                                                     MD022777
     C     CFT004        IFEQ      'Y'
     C     CSW213        ANDEQ     'Y'
     C**********           MOVE *ON       *IN70                                    MD022777 MD022942
     C                   MOVE      *ON           *IN75
     C                   ELSE
     C**********           MOVE *OFF      *IN70                                    MD022777 MD022942
     C                   MOVE      *OFF          *IN75
     C                   ENDIF
      *                                                                                       CSW213
      ** Overwrite for WTXTC                                                                  CSW213
      *                                                                                       CSW213
     C                   MOVE      *BLANKS       PMSGT            80
     C                   MOVEL     'USR0101'     PMSGID
      *                                                                                       CSW213
     C                   CALL      'SDRTVTXT'                           90
     C     PMSGID        PARM      PMSGID        KE0286            7
     C     PMSGF         PARM      PMSGF         KE0287           10
     C     PMSGT         PARM      PMSGT         KE0288           80
     C                   MOVEL     PMSGT         WTXTC
      *                                                                                       CSW213
     C                   ENDIF
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
      *COPY*ZSRSRC,ZDATE1Z2                                                                 MD058081
      /COPY ZSRSRC,ZDATE1Z2LE                                                               MD058081
     C*COPY*ZSRSRC,ZDATE2Z2                                                          CSW213 MD058081
     C/COPY ZSRSRC,ZDATE2Z2LE                                                               MD058081
      *COPY*ZSRSRC,ZALIGNZ2                                                          CSW213 MD058081
     C/COPY ZSRSRC,ZALIGNZ2LE                                                               MD058081
      *COPY*ZSRSRC,ZEDITZ2                                                           CSW213 MD058081
     C/COPY ZSRSRC,ZEDITZ2LE                                                                MD058081
** CPY@     : Copyright notice for inclusion in all programs
(c) Finastra International Limited 2001
**   ZYDY - YEARS IN DAYS CUMULATIVE IN FOUR YEAR SPAN                                        CSW213
0366073110961461                                                                              CSW213
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR                                            CSW213
000031059090120151181212243273304334365                                                       CSW213
**   ZMNM - MONTHS SHORT NAMES                                                                CSW213
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC                                                          CSW213
