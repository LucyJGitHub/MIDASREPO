     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058068
/*STD *  RPGSQLBND                                                    *                     MD058068
/*EXI *  TEXT('Midas BoE Loans Extract Criteria Report')              *
      *****************************************************************
      *                                                               *
      *  Midas - Bank of England                                      *
      *                                                               *
      *  BY3030 - Loans Extract Criteria Report                       *
      *                                                               *
      *  Function:  This program prints a report of Loan Extract      *
      *             Criteria                                          *
      *                                                               *
      *  Called By: mmCnnnn - (program name)                          *
      *                                                               *
      *  (c) Finastra International Limited 1997                      *
      *                                                               *
      *  Last Amend No. MD058068           Date 11May21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 LLN021             Date 19Nov03               *
      *                 LLN012             Date 30Sep99               *
      *                                                               *
      *---------------------------------------------------------------*
      *  Amendment Details:                                           *
      *                                                               *
      *  MD058068 - Deliverable Data Split for Bank of England        *
      *  MD046248 - Finastra Rebranding                               *
      *  LLN021 - BoE Profit and Loss return                          *
      *  LLN012 - Additional BoE Changes (Patch B)                    *
      *                                                               *
      *****************************************************************
      *
      * File description for files defined
     FBYLEEXPP  UF   E           K DISK    INFSR(*PSSR)
     F                                     INFDS(INFDS1)
     F*BYPRODPP* IF   E           K DISK    INFSR(*PSSR)                                    MD058068
     FBY3030P1  O    E             PRINTER INFSR(*PSSR)
     F                                     OFLIND(*IN50)
     F                                     INFDS(SPOOL)
      /EJECT
      **************************************************************************
      *                                                               *
      *  Indicators Used:                                             *
      *  ~~~~~~~~~~~~~~~                                              *
      *  40 - Print 'Status' heading in report                        *
      *  50 - Page Overflow                                           *
      *  89 - READ BYLEEXPP                                           *
      *  90 - General error indicator                                 *
      *                                                               *
      **************************************************************************
      *  Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      /SPACE 3
      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Data Structure using Bank file format
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Program Status Data Structure
     D PSDS           SDS
     D  ULPGM            *PROC
     D  ULWSID               244    253
     D  ULUSER               254    263
      *
      ** File information data structure (for database files only)
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      *
      ** File information data structure (for printer files only)
     D SPOOL           DS
     D  ULSPFL                83     92
     D  ULSNUM               123    124B 0
      *
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
     D BYPROD        E DS                  EXTNAME(BYPRDJW0)                                MD058068
      *
      /EJECT
      *****************************************************************
      * Main Processing                                               *
      *                                                               *
      * Calls: SR/#LMAIN - Report Processing                          *
      *        SR/#LTERM - Termination Processing                     *
      *****************************************************************
      *
      *
      *  Report Processing
     C                   EXSR      #LMAIN
      *
      *
      *  Termination Processing
     C                   EXSR      #LTERM
      *
      *
      /EJECT
      *****************************************************************
      * #LMAIN - Report Processing                                    *
      *                                                               *
      * Called by:  Main Processing                                   *
      *                                                               *
      * Calls:                                                        *
      *****************************************************************
      *
     C     #LMAIN        BEGSR                                                  ** SR/#LMAIN**
      *
      **  Set indicators, based on run mode
     C                   READ      BYLEEXPP                               89
     C     *IN89         DOWEQ     *OFF
      *
      *   Process record according to run mode
     C     ULMODE        IFEQ      'LIST'
     C     ULMODE        OREQ      'AUDIT'
     C     L3LCD         ANDEQ     BJRDNB
     C     ULMODE        OREQ      'INTERIM'
     C     L3LCD         ANDEQ     BJRDNB
      *
      *   Format report fields and print details
     C                   EXSR      #LREPT
      *
      *   If run mode is AUDIT and record deleted
     C     ULMODE        IFEQ      'AUDIT'
     C     L3CHTP        ANDEQ     'D'
     C     K1LEEX        DELETE    BYLEEXPP                           90
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   READ      BYLEEXPP                               89
     C                   ENDDO
      *
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * #LREPT - Formats report fields and prints report              *
      *                                                               *
      * Called by: #LMAIN                                             *
      *                                                               *
      * Calls:                                                        *
      *****************************************************************
      *
     C     #LREPT        BEGSR                                                  ** SR/#LREPT**
      *
      *   Retrieve product code narrative
     C                   MOVE      L3PCOD        LDPCOD
     C*****LDPCOD        CHAIN     BYPRODPP                           90                    MD058068
     C/EXEC SQL                                                                             MD058068
     C+ SELECT *                                                                            MD058068
     C+ into :BYPROD                                                                        MD058068
     C+ from BYPRDJW0                                                                       MD058068
     C+ where LDPCOD = :LDPCOD                                                              MD058068
     C/END-EXEC                                                                             MD058068
      *
      ** Check for error
     C******IN90         IFEQ      *ON                                                      MD058068
     C     SQLCODE       IFEQ      100                                                      MD058068
     C     *LOCK         IN        LDA
     C                   MOVEL     ULPGM         DBPGM                          ************
     C                   MOVEL     L3PCOD        DBKEY                          * DBERR 02 *
     C                   MOVEL     'BYPRODPP'    DBFILE                         ************
     C                   Z-ADD     2             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      *
      ** Move physical file fields into print file fields
     C                   MOVE      L3LTYP        L#LTYP
     C                   MOVE      L3LNST        L#LNST
     C                   MOVE      L3LINS        L#LINS
     C                   MOVE      L3PCOD        L#PCOD
     C                   MOVE      LDDESC        L#DESC
     C                   MOVE      L3NPER        L#NPER                                        LLN01
      *                                                                   LLN021
     C     LLN021        IFEQ      'Y'                                                         LLN02
      *                                                                   LLN021
     C                   MOVE      L3PLCR        L#PLCR                                        LLN02
     C                   MOVE      *BLANKS       L#DES2                                        LLN02
     C     L3PLCR        IFNE      0                                                           LLN02
      *   Retrieve product code narrative                                 LLN021
     C                   MOVE      L3PLCR        LDPCOD                                        LLN02
     C*****LDPCOD        CHAIN     BYPRODPP                           90              LLN02 MD058068
     C/EXEC SQL                                                                             MD058068
     C+ SELECT *                                                                            MD058068
     C+ into :BYPROD                                                                        MD058068
     C+ from BYPRDJW0                                                                       MD058068
     C+ where LDPCOD = :LDPCOD                                                              MD058068
     C/END-EXEC                                                                             MD058068
     C******IN90         IFEQ      *ON                                                      MD058068
     C     SQLCODE       IFEQ      100                                                      MD058068
     C     *LOCK         IN        LDA                                                         LLN02
     C                   MOVEL     ULPGM         DBPGM                          ************   LLN02
     C                   MOVEL(P)  LDPCOD        DBKEY                          * DBERR 10 *   LLN02
     C                   MOVEL     'BYPRODPP'    DBFILE                         ************   LLN02
     C                   Z-ADD     10            DBASE                                         LLN02
     C                   OUT       LDA                                                         LLN02
     C                   EXSR      *PSSR                                                       LLN02
     C                   ENDIF                                                                 LLN02
     C                   MOVE      LDDESC        L#DES2                                        LLN02
     C                   ENDIF                                                                 LLN02
      *                                                                   LLN021
     C                   MOVE      L3PLCG        L3PLCG                                        LLN02
     C                   MOVE      *BLANKS       L#DES3                                        LLN02
     C     L3PLCG        IFNE      0                                                           LLN02
      *   Retrieve product code narrative                                 LLN021
     C                   MOVE      L3PLCG        LDPCOD                                        LLN02
     C*****LDPCOD        CHAIN     BYPRODPP                           90              LLN02 MD058068
     C/EXEC SQL                                                                             MD058068
     C+ SELECT *                                                                            MD058068
     C+ into :BYPROD                                                                        MD058068
     C+ from BYPRDJW0                                                                       MD058068
     C+ where LDPCOD = :LDPCOD                                                              MD058068
     C/END-EXEC                                                                             MD058068
     C******IN90         IFEQ      *ON                                                      MD058068
     C     SQLCODE       IFEQ      100                                                      MD058068
     C     *LOCK         IN        LDA                                                         LLN02
     C                   MOVEL     ULPGM         DBPGM                          ************   LLN02
     C                   MOVEL(P)  LDPCOD        DBKEY                          * DBERR 11 *   LLN02
     C                   MOVEL     'BYPRODPP'    DBFILE                         ************   LLN02
     C                   Z-ADD     11            DBASE                                         LLN02
     C                   OUT       LDA                                                         LLN02
     C                   EXSR      *PSSR                                                       LLN02
     C                   ENDIF                                                                 LLN02
     C                   MOVE      LDDESC        L#DES3                                        LLN02
     C                   ENDIF                                                                 LLN02
      *                                                                   LLN021
     C                   MOVE      L3PLTX        L#PLTX                                        LLN02
     C                   MOVE      *BLANKS       L#DES4                                        LLN02
     C     L3PLTX        IFNE      0                                                           LLN02
      *   Retrieve product code narrative                                 LLN021
     C                   MOVE      L3PLTX        LDPCOD                                        LLN02
     C*****LDPCOD        CHAIN     BYPRODPP                           90              LLN02 MD058068
     C/EXEC SQL                                                                             MD058068
     C+ SELECT *                                                                            MD058068
     C+ into :BYPROD                                                                        MD058068
     C+ from BYPRDJW0                                                                       MD058068
     C+ where LDPCOD = :LDPCOD                                                              MD058068
     C/END-EXEC                                                                             MD058068
     C******IN90         IFEQ      *ON                                                      MD058068
     C     SQLCODE       IFEQ      100                                                      MD058068
     C     *LOCK         IN        LDA                                                         LLN02
     C                   MOVEL     ULPGM         DBPGM                          ************   LLN02
     C                   MOVEL(P)  LDPCOD        DBKEY                          * DBERR 12 *   LLN02
     C                   MOVEL     'BYPRODPP'    DBFILE                         ************   LLN02
     C                   Z-ADD     12            DBASE                                         LLN02
     C                   OUT       LDA                                                         LLN02
     C                   EXSR      *PSSR                                                       LLN02
     C                   ENDIF                                                                 LLN02
     C                   MOVE      LDDESC        L#DES4                                        LLN02
     C                   ENDIF                                                                 LLN02
      *                                                                   LLN021
     C                   ENDIF                                                                 LLN02
      *
      ** Report Action Code for AUDIT and INTERIM
     C     ULMODE        IFEQ      'AUDIT  '
     C     ULMODE        OREQ      'INTERIM'
      *
     C                   SELECT
     C     L3CHTP        WHENEQ    'I'
     C                   MOVE      'Inserted'    L#CHTP
     C     L3CHTP        WHENEQ    'A'
     C                   MOVE      'Amended '    L#CHTP
     C     L3CHTP        WHENEQ    'D'
     C                   MOVE      'Deleted '    L#CHTP
     C                   ENDSL
      *
     C                   ENDIF
      *
     C                   WRITE     BY3030D1                                     Detail
      *
      **  Write new header on page overflow
     C     *IN50         IFEQ      *ON
     C                   WRITE     BY3030H1
     C                   MOVE      *OFF          *IN50
     C                   ENDIF
      *
     C                   MOVE      'Y'           ULWRIT
     C                   ENDSR
      /EJECT
      *****************************************************************
      * #LTERM - Termination Processing                               *
      *                                                               *
      * Called by:  Main Processing                                   *
      *                                                               *
      * Calls:                                                        *
      *****************************************************************
      *
     C     #LTERM        BEGSR                                                  ** SR/#LTERM**
      *
      ** If no records written, report this on print file
     C     ULWRIT        IFNE      'Y'
     C                   WRITE     BY3030D2                                     No details
     C                   ENDIF
      *
     C                   WRITE     BY3030F1                                     Footer
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * #LDEFN - Field Definition Routine                             *
      *                                                               *
      * Called by:  None - Contains definitions only                  *
      *                                                               *
      * Calls: None                                                   *
      *****************************************************************
      *
     C     #LDEFN        BEGSR                                                  ** SR/#LDEFN**
      *
      ** Define external data areas
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
      *
      ** Define and initialise work fields
     C                   Z-ADD     0             ULSFNO            6 0          Spool file no.
     C                   MOVE      *BLANKS       ULRTCD            1            Return code
     C                   MOVE      *BLANKS       ULERRI            1            Pgm error indicator
     C                   MOVE      *BLANKS       P@RTCD            7            Return code
     C                   MOVE      *BLANKS       P@OPTN            7
     C                   MOVE      *BLANKS       ULTIME            6 0          System time
     C                   MOVE      *BLANKS       ULSF1             6 0
     C                   MOVE      *BLANKS       ULPARM            3
     C                   MOVE      *BLANKS       ULZERR            1            Error flag
     C                   MOVE      *BLANKS       ULWRIT            1            Flag: record written
     C                   MOVE      *BLANKS       ULENTY            3
     C                   MOVEA     CPY@          ULCPY@           80            Copyright
      *
     C     K1LEEX        KLIST
     C                   KFLD                    L3LTYP
     C                   KFLD                    L3LNST
     C                   KFLD                    L3LINS
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
      *
      *  Check if error has previously been reported
     C     ULERRI        IFEQ      *BLANK
     C                   MOVE      'Y'           ULERRI
     C                   MOVE      'Y'           ULRTCD
     C                   DUMP
     C                   ENDIF
      *
      *  Set on external indicators
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
      *
      *  Terminate program
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      * Called by:  At program initialisation                         *
      *                                                               *
      * Calls: None                                                   *
      *****************************************************************
      *
     C     *INZSR        BEGSR                                                  ** *INZSR SR**
      *
     C     *ENTRY        PLIST
     C                   PARM                    ULMODE            7            Run mode
     C                   PARM                    ULRSEQ            5            Report sequence
     C                   PARM                    ULRTCD                         Return code
      *
      *  Get Bank Details
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANK        P@RTCD
     C                   PARM      '*FIRST '     P@OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Check Return Code
     C     P@RTCD        IFNE      *BLANKS
     C     BJTYLC        OREQ      'D'                                          ON-DELETED
     C     *LOCK         IN        LDA
     C                   MOVEL     ULPGM         DBPGM                          ************
     C                   MOVEL     '*NONE'       DBKEY                          * DBERR 01 *
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   Z-ADD     1             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Ensure Report Spool File is recorded by RCF
     C                   Z-ADD     ULSNUM        ULSFNO
     C**********           CALL 'ZSFILE'                                                      LLN021
     C**********           PARM           ULRSEQ                                              LLN021
     C**********           PARM *BLANK    ULENTY                                              LLN021
     C**********           PARM           ULSPFL                                              LLN021
     C**********           PARM           ULSFNO                                              LLN021
     C**********           PARM           ULZERR                                              LLN021
      *
      ** If error occured in SFILE, call error handling routine
     C     ULZERR        IFNE      *BLANKS
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Switch on 'ACTION' field in display file
     C     ULMODE        IFEQ      'AUDIT  '
     C     ULMODE        OREQ      'INTERIM'
     C                   MOVE      *ON           *IN40
     C                   ENDIF
      *
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
     C     BJDFIN        IFEQ      'M'
     C                   MOVE      *ON           *IN98
     C                   ELSE
     C                   MOVE      *OFF          *IN98
     C                   END
      *
      *  Write report headings
     C                   MOVEL     ULMODE        L#MODE
     C                   WRITE     BY3030H1
      *
      **  LLN021 check                                                    LLN021
     C                   CALL      'AOSARDR0'                                                  LLN02
     C                   PARM      *BLANK        P@RTCD                                        LLN02
     C                   PARM      '*VERIFY'     P@OPTN                                        LLN02
     C                   PARM      'LLN021'      @SARD             6                           LLN02
      *                                                                   LLN021
     C     P@RTCD        IFEQ      *BLANK                                                      LLN02
     C                   MOVE      'Y'           LLN021            1                           LLN02
     C                   MOVE      *ON           *IN87                                         LLN02
     C                   ELSE                                                                  LLN02
     C                   MOVE      'N'           LLN021                                        LLN02
     C                   MOVE      *OFF          *IN87                                         LLN02
     C                   ENDIF                                                                 LLN02
      *
     C                   ENDSR
      /EJECT
      ********************************************************************
**  CPY@
(c) Finastra International Limited 1997
