     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD055681
/*STD *  RPGSQLBND                                                    *                     MD055681
/*EXI *  TEXT('Midas SC Validates new SAR details')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC3100V - Switchable Features Command Validation Program     *
      *                                                               *
      *  Function:  This program validates the field entries made     *
      *             using command keys SCCRTKEY/SCCRTKEYB.            *
      *                                                               *
      *  Called By: SCC3100                                           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD055681           Date 31Jul20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CGP002             Date 03Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CSC005  *CREATE    Date 08May98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055681 - Deliverable Data Split for SAR                    *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGP002 - Global Processing.                                  *
      *           - Rename SCCSECPD to GP file.                       *
      *  CSC005 - New suite of programs and files to permit           *
      *           insertion of switchable features via passwords.     *
      *                                                               *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  INIT   - Program Initialisation                              *
      *  PROCES - Detail Processing                                   *
      *  EXIT   - End Processing                                      *
      *  *PSSR  - Program Error Processing Subroutine                 *
      *****************************************************************
     F*SCSARSL1* UF A E           K DISK    INFSR(*PSSR)                                    MD055681
     F*SCCSECL1IF*E*****      K        DISK         KINFSR *PSSR                              CGP002
     FGPCSECL1  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Update core switchable features file with new details
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)              Copyright     array
     D/EJECT
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
      **                                    142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
      ** Data Area giving Installation Control Details
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
     D PSDS           SDS
      *
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
     D SPOOL1          DS
      *
      ***  File Information Data Structure for SC3100V.
      *
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
      *
      ***  Dummy Data Structures used by Access Programs.
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D*                                                                   S01486
     D DSFDY         E DS                  EXTNAME(DSFDY)                       S01194
      *
      ** Date and time fields                                             S01486
      *
     D                 DS
     D  TMSTMP                 1     12  0                                      CSC
     D  AUTIME                 1      6  0                                      CSC
     D  DATE                   7     12  0                                      CSC
      *
      ** Release levels                                                   S01486
      *
     D REL104          C                   CONST('ABS R10.4')
     D REL105          C                   CONST('ABS R10.5')
     D SCSARS        E DS                  EXTNAME(SCSRSJW0)                                MD055681
     C/TITLE Main Processing
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
      *
      ***  Perform Initialisation.
      *
     C                   EXSR      INIT
      *
      ***  Perform Detail Processing.
      *
     C                   EXSR      PROCES
      *
      ***  Perform Detail Processing.
      *
     C                   EXSR      EXIT
      *
      *
      *================================================================
      *  P R O G R A M   E N D                                        *
      *================================================================
     C/EJECT
      *****************************************************************
      *                                                               *
      *  INIT   - Subroutine to do Program Initialisation.            *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *****************************************************************
      *
     C     INIT          BEGSR                                                  ***  INIT  ***
      *
      ** Set up copyright parameter and time
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ***  Receive Parameter List.
      *
     C     *ENTRY        PLIST
      * Switchable feature ID
     C                   PARM                    SARN              6
      * Password
     C                   PARM                    PASS             16
      * New details flag
     C                   PARM                    NEWD              1
      * Switchable feature description
     C                   PARM                    SARD             50
      * Primary module
     C                   PARM                    PRIM              2
      * Complex module conditions flag
     C                   PARM                    CEMI              1
      * Release level, work field
     C                   PARM                    WRELL             5
      * Interim release level, work field
     C                   PARM                    WIREL             2
      * Collection
     C                   PARM                    CLVL              4
      * Release status
     C                   PARM                    RSTS              1
      * Default (on/off)
     C                   PARM                    DFLT              3
      * Maintained by
     C                   PARM                    MNTB              1
      * Chargeable?
     C                   PARM                    CHRG              1
      * Folder
     C                   PARM                    FLRN             35
      * Document
     C                   PARM                    DOCN             11
      * Help tag
     C                   PARM                    HELP              8
      * Core (C = Core, B = Non-Core)
     C                   PARM                    CORE              1
      * Return code
     C                   PARM                    RTNCDE            7
      *
      ***  Initialise LDA field.
      *
     C                   MOVEL     'SC3100V'     DBPGM
      *
      ***  Call Access Program for Bank Details - Title, Run Date and
      ***  Run Day Number.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     WRTCD             7
     C                   PARM      '*FIRST '     WOPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ***  Handle Database Error.
      *
     C     WRTCD         IFNE      *BLANKS
     C                   MOVE      'SDBANKPD'    DBFILE                         ***************
     C                   Z-ADD     001           DBASE                          * DB ERROR 01 *
     C                   EXSR      *PSSR                                        ***************
     C                   ENDIF
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/PROCES
      *****************************************************************
      *                                                               *
      *  PROCES - Subroutine to do the Detail Processing.             *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     PROCES        BEGSR                                                  *** PROCES ***
      *
      ** Position interim release level value for report.
      *
     C                   MOVEL     WIREL         WIREL2            3
     C                   MOVE      WIREL2        IREL              5
      * Convert command input for release level into form suitable
      * for report, and recognisable by logical files.
     C                   SELECT
     C     WRELL         WHENEQ    'R10.4'
     C                   MOVEL     REL104        RELL             10
     C     WRELL         WHENEQ    'R10.5'
     C                   MOVEL     REL105        RELL
     C     WRELL         WHENEQ    'DBAR1'
     C                   MOVEL     'DBA R1'      RELL
     C     WRELL         WHENEQ    'DBAR2'
     C                   MOVEL     'DBA R2'      RELL
     C     WRELL         WHENEQ    'DBAR3'
     C                   MOVEL     'DBA R3'      RELL
     C                   ENDSL
     C*****SARN*         CHAIN     SCSARSL1                           75                    MD055681
     C                   If        CORE = 'C'                                               MD055681
     C/EXEC SQL                                                                             MD055681
     C+ SELECT *                                                                            MD055681
     C+ into :SCSARS                                                                        MD055681
     C+ from SCSRSJW0                                                                       MD055681
     C+ where AXSARN = :SARN and AXMODE = 'C'                                               MD055681
     C/END-EXEC                                                                             MD055681
     C                   else                                                               MD055681
     C/EXEC SQL                                                                             MD055681
     C+ SELECT *                                                                            MD055681
     C+ into :SCSARS                                                                        MD055681
     C+ from SCSRSJW0                                                                       MD055681
     C+ where AXSARN = :SARN and AXMODE = 'B'                                               MD055681
     C/END-EXEC                                                                             MD055681
     C                   Endif                                                              MD055681
      *
      * save SQLCODE as *IN75 was saved                                                     MD055681
     C                   setoff                                       75                    MD055681
     C                   IF        SQLCODE = 100                                            MD055681
     C                   seton                                        75                    MD055681
     C                   Endif                                                              MD055681
      ** SAR is not on file, but update mode has been selected...
      *
     C******IN75         IFEQ      *ON                                                      MD055681
     C     SQLCODE       IFEQ      100                                                      MD055681
     C     NEWD          ANDEQ     'N'
     C                   MOVEL     '*NUPD'       RTNCDE
     C                   EXSR      EXIT
     C                   ENDIF
     C     NEWD          IFEQ      'Y'
      *
      ** SAR is already on file, ie we are updating ...
      *
     C******IN75         IFEQ      *OFF                                                     MD055681
     C                   IF        SQLCODE = 0                                              MD055681
     C     SARD          IFNE      *BLANKS
     C                   MOVE      SARD          AXSARD
     C                   ENDIF
     C     PRIM          IFNE      *BLANKS
     C                   MOVE      PRIM          AXPRIM
     C                   ENDIF
     C     CEMI          IFNE      *BLANKS
     C                   MOVE      CEMI          AXCEMI
     C                   ENDIF
     C     RELL          IFNE      *BLANKS
     C                   MOVE      RELL          AXRELL
     C                   ENDIF
     C     IREL          IFNE      *BLANKS
     C                   MOVE      IREL          AXIREL
     C                   ENDIF
     C     CLVL          IFNE      *BLANKS
     C                   MOVE      CLVL          AXCLVL
     C                   ENDIF
     C     RSTS          IFNE      *BLANKS
     C                   MOVE      RSTS          AXRSTS
     C                   ENDIF
     C     DFLT          IFNE      *BLANKS
     C                   MOVE      DFLT          AXDFLT
     C                   ENDIF
     C     MNTB          IFNE      *BLANKS
     C                   MOVE      MNTB          AXMNTB
     C                   ENDIF
     C     CHRG          IFNE      *BLANKS
     C                   MOVE      CHRG          AXCHRG
     C                   ENDIF
     C     FLRN          IFNE      *BLANKS
     C                   MOVE      FLRN          AXFLRN
     C                   ENDIF
     C     DOCN          IFNE      *BLANKS
     C                   MOVE      DOCN          AXDOCN
     C                   ENDIF
     C     HELP          IFNE      *BLANKS
     C                   MOVE      HELP          AXHELP
     C                   ENDIF
     C**********         UPDATE    SCSARSD0                                                 MD055681
     C                   If        CORE = 'C'                                               MD055681
     C/EXEC SQL                                                                             MD055681
     C+ update SCSRSCTD set                                                                 MD055681
     C+  AXSARD = :AXSARD,                                                                  MD055681
     C+  AXPRIM = :AXPRIM,                                                                  MD055681
     C+  AXCEMI = :AXCEMI,                                                                  MD055681
     C+  AXRELL = :AXRELL,                                                                  MD055681
     C+  AXIREL = :AXIREL,                                                                  MD055681
     C+  AXCLVL = :AXCLVL,                                                                  MD055681
     C+  AXRSTS = :AXRSTS,                                                                  MD055681
     C+  AXDFLT = :AXDFLT,                                                                  MD055681
     C+  AXMNTB = :AXMNTB,                                                                  MD055681
     C+  AXCHRG = :AXCHRG,                                                                  MD055681
     C+  AXFLRN = :AXFLRN,                                                                  MD055681
     C+  AXDOCN = :AXDOCN,                                                                  MD055681
     C+  AXHELP = :AXHELP,                                                                  MD055681
     C+  AXPROT = 'Y',                                                                      MD055681
     C+  AXMODE = 'C'                                                                       MD055681
     C+ where AXSARN = :SARN                                                                MD055681
     C/END-EXEC                                                                             MD055681
     C/EXEC SQL                                                                             MD055681
     C+ update SCSRSXTD set                                                                 MD055681
     C+  AXMODE = 'C'                                                                       MD055681
     C+ where AXSARN = :SARN                                                                MD055681
     C/END-EXEC                                                                             MD055681
     C                   else                                                               MD055681
     C/EXEC SQL                                                                             MD055681
     C+ update SCSRSBTD set                                                                 MD055681
     C+  AXSARD = :AXSARD,                                                                  MD055681
     C+  AXPRIM = :AXPRIM,                                                                  MD055681
     C+  AXCEMI = :AXCEMI,                                                                  MD055681
     C+  AXRELL = :AXRELL,                                                                  MD055681
     C+  AXIREL = :AXIREL,                                                                  MD055681
     C+  AXCLVL = :AXCLVL,                                                                  MD055681
     C+  AXRSTS = :AXRSTS,                                                                  MD055681
     C+  AXDFLT = :AXDFLT,                                                                  MD055681
     C+  AXMNTB = :AXMNTB,                                                                  MD055681
     C+  AXCHRG = :AXCHRG,                                                                  MD055681
     C+  AXFLRN = :AXFLRN,                                                                  MD055681
     C+  AXDOCN = :AXDOCN,                                                                  MD055681
     C+  AXHELP = :AXHELP,                                                                  MD055681
     C+  AXPROT = 'Y',                                                                      MD055681
     C+  AXMODE = 'B'                                                                       MD055681
     C+ where AXSARN = :SARN                                                                MD055681
     C/END-EXEC                                                                             MD055681
     C/EXEC SQL                                                                             MD055681
     C+ update SCSRSXTD set                                                                 MD055681
     C+  AXMODE = 'B'                                                                       MD055681
     C+ where AXSARN = :SARN                                                                MD055681
     C/END-EXEC                                                                             MD055681
     C                   Endif                                                              MD055681
                                                                                            MD055681
     C                   ENDIF
     C                   ENDIF
      *
      ** A record is not currently present on file so all the critical
      ** fields must be filled in.
      *
     C     *IN75         IFEQ      *ON
     C     PRIM          IFEQ      *BLANKS
     C     SARD          OREQ      *BLANKS
     C     RELL          OREQ      *BLANKS
     C     IREL          OREQ      *BLANKS
     C     CLVL          OREQ      *BLANKS
      *
      ** If the following are left blank on the non-core command
      ** then this is OK, but they are mandatory for core.
      *
     C     CORE          IFEQ      'C'
     C     FLRN          OREQ      *BLANKS
     C     DOCN          OREQ      *BLANKS
     C     HELP          OREQ      *BLANKS
     C                   ENDIF
      * A field has been left blank - error.
     C                   MOVEL     '*EMPT'       RTNCDE
     C                   EXSR      EXIT
     C                   ENDIF
     C                   ENDIF
      *
      ** Does user have authority to update this feature?
      *
     C********** SARN      CHAINSCCSECL1             95                                       CGP002
     C     SARN          CHAIN     GPCSECL1                           95
      *
      ** If switchable feature already exists on file and this
      ** is an update function, we need to know if the user has
      ** authority to update - are non-core attempting to update
      ** core features or vice versa?
      *
     C     *IN95         IFEQ      '0'
     C     CORE          IFNE      RECI
     C                   MOVEL     '*UPD'        RTNCDE
     C                   ENDIF
     C                   ENDIF
      *
      ** Check to see if password is made up of valid characters,
      ** ie, A to Z.
      *
     C     1             DO        16            COU               2 0
     C     1             SUBST     PASS:COU      SFCHAR            1
     C     SFCHAR        IFLT      'A'
     C     SFCHAR        ORGT      'Z'
     C     SFCHAR        IFNE      *BLANK
     C                   MOVEL     '*ENCR'       RTNCDE
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
      ** If the delivered files have been successfully updated,
      ** we can add the SAR to SARS/SARZ.
      *
     C     *IN75         IFEQ      *ON
     C     RTNCDE        ANDEQ     *BLANKS
     C                   MOVE      SARN          AXSARN
     C                   MOVE      SARD          AXSARD
     C                   MOVE      PRIM          AXPRIM
     C                   MOVE      CEMI          AXCEMI
     C                   MOVE      RELL          AXRELL
     C                   MOVE      IREL          AXIREL
     C                   MOVE      CLVL          AXCLVL
     C                   MOVE      RSTS          AXRSTS
     C                   MOVE      DFLT          AXDFLT
     C                   MOVE      CHRG          AXCHRG
     C                   MOVE      MNTB          AXMNTB
     C                   MOVE      FLRN          AXFLRN
     C                   MOVE      DOCN          AXDOCN
     C                   MOVE      HELP          AXHELP
     C**********         WRITE     SCSARSD0                                                 MD055681
      * As OVRDBF is not done anymore, CORE field must be tested instead                    MD055681
     C                   If        CORE = 'C'                                               MD055681
     C/EXEC SQL                                                                             MD055681
     C+ insert into SCSRSCTD                                                                MD055681
     C+ (                                                                                   MD055681
     C+   AXSARN                                                                            MD055681
     C+ , AXSARD                                                                            MD055681
     C+ , AXPRIM                                                                            MD055681
     C+ , AXCEMI                                                                            MD055681
     C+ , AXRELL                                                                            MD055681
     C+ , AXIREL                                                                            MD055681
     C+ , AXCLVL                                                                            MD055681
     C+ , AXRSTS                                                                            MD055681
     C+ , AXDFLT                                                                            MD055681
     C+ , AXMNTB                                                                            MD055681
     C+ , AXCHRG                                                                            MD055681
     C+ , AXFLRN                                                                            MD055681
     C+ , AXDOCN                                                                            MD055681
     C+ , AXHELP                                                                            MD055681
     C+ , AXPROT                                                                            MD055681
     C+ , AXMODE                                                                            MD055681
     C+ )                                                                                   MD055681
     C+ Values                                                                              MD055681
     C+ (                                                                                   MD055681
     C+   :AXSARN                                                                           MD055681
     C+ , :AXSARD                                                                           MD055681
     C+ , :AXPRIM                                                                           MD055681
     C+ , :AXCEMI                                                                           MD055681
     C+ , :AXRELL                                                                           MD055681
     C+ , :AXIREL                                                                           MD055681
     C+ , :AXCLVL                                                                           MD055681
     C+ , :AXRSTS                                                                           MD055681
     C+ , :AXDFLT                                                                           MD055681
     C+ , :AXMNTB                                                                           MD055681
     C+ , :AXCHRG                                                                           MD055681
     C+ , :AXFLRN                                                                           MD055681
     C+ , :AXDOCN                                                                           MD055681
     C+ , :AXHELP                                                                           MD055681
     C+ , 'Y'                                                                               MD055681
     C+ , 'C'                                                                               MD055681
     C+ )                                                                                   MD055681
     C/END-EXEC                                                                             MD055681
     C/EXEC SQL                                                                             MD055681
     C+ insert into SCSRSXTD                                                                MD055681
     C+ (                                                                                   MD055681
     C+   AXSARN                                                                            MD055681
     C+ , AXMODE                                                                            MD055681
     C+ )                                                                                   MD055681
     C+ Values                                                                              MD055681
     C+ (                                                                                   MD055681
     C+   :AXSARN                                                                           MD055681
     C+ , 'C'                                                                               MD055681
     C+ )                                                                                   MD055681
     C/END-EXEC                                                                             MD055681
     C                   else                                                               MD055681
     C/EXEC SQL                                                                             MD055681
     C+ insert into SCSRSBTD                                                                MD055681
     C+ (                                                                                   MD055681
     C+   AXSARN                                                                            MD055681
     C+ , AXSARD                                                                            MD055681
     C+ , AXPRIM                                                                            MD055681
     C+ , AXCEMI                                                                            MD055681
     C+ , AXRELL                                                                            MD055681
     C+ , AXIREL                                                                            MD055681
     C+ , AXCLVL                                                                            MD055681
     C+ , AXRSTS                                                                            MD055681
     C+ , AXDFLT                                                                            MD055681
     C+ , AXMNTB                                                                            MD055681
     C+ , AXCHRG                                                                            MD055681
     C+ , AXFLRN                                                                            MD055681
     C+ , AXDOCN                                                                            MD055681
     C+ , AXHELP                                                                            MD055681
     C+ , AXPROT                                                                            MD055681
     C+ , AXMODE                                                                            MD055681
     C+ )                                                                                   MD055681
     C+ Values                                                                              MD055681
     C+ (                                                                                   MD055681
     C+   :AXSARN                                                                           MD055681
     C+ , :AXSARD                                                                           MD055681
     C+ , :AXPRIM                                                                           MD055681
     C+ , :AXCEMI                                                                           MD055681
     C+ , :AXRELL                                                                           MD055681
     C+ , :AXIREL                                                                           MD055681
     C+ , :AXCLVL                                                                           MD055681
     C+ , :AXRSTS                                                                           MD055681
     C+ , :AXDFLT                                                                           MD055681
     C+ , :AXMNTB                                                                           MD055681
     C+ , :AXCHRG                                                                           MD055681
     C+ , :AXFLRN                                                                           MD055681
     C+ , :AXDOCN                                                                           MD055681
     C+ , :AXHELP                                                                           MD055681
     C+ , 'Y'                                                                               MD055681
     C+ , 'B'                                                                               MD055681
     C+ )                                                                                   MD055681
     C/END-EXEC                                                                             MD055681
     C/EXEC SQL                                                                             MD055681
     C+ insert into SCSRSXTD                                                                MD055681
     C+ (                                                                                   MD055681
     C+   AXSARN                                                                            MD055681
     C+ , AXMODE                                                                            MD055681
     C+ )                                                                                   MD055681
     C+ Values                                                                              MD055681
     C+ (                                                                                   MD055681
     C+   :AXSARN                                                                           MD055681
     C+ , 'B'                                                                               MD055681
     C+ )                                                                                   MD055681
     C/END-EXEC                                                                             MD055681
     C                   endif                                                              MD055681
                                                                                            MD055681
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      *****************************************************************
      *                                                               *
      *  EXIT   - Subroutine to END PROGRAM                           *
      *                                                               *
      *  Called By: PROCES                                            *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
     C     EXIT          BEGSR
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDSR
      *****************************************************************
      /TITLE SR/*PSSR
      *****************************************************************
      *                                                               *
      *  *PSSR  - Error control subroutine                            *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR **
      *
      ***  Check to see that *PSSR has not already been called.
      *
     C     WRUN          IFEQ      *BLANK
     C                   MOVE      'Y'           WRUN              1
      *
     C     *DTAARA       DEFINE    LDA           WLDA            256
     C     *LOCK         IN        WLDA
     C                   MOVEL     DBFILE        WLDA
     C                   OUT       WLDA
      *
     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   ENDIF
      *
      ***  If *PSSR already run, then just end the program here.
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *****************************************************************
      *
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
