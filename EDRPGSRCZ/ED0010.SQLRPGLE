     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058071
/*STD *  RPGSQLBND                                                    *                     MD058071
/**** *  GENOPT(*OPTIMIZE)                                            *                     MD058071
/*EXI *  TEXT('Midas ED Bulk transfer preparation')
      *****************************************************************
      *                                                               *
      *  Midas - Midas Export Data Interface Module                   *
      *                                                               *
      *  ED0010 - BULK TRANSFER PREPARATION                           *
      *                                                               *
      *  Function:  This program splits the list of files to be       *
      *             copied in preparation for DTA retrieval. There   *
      *             will be one list per COB stream active in the     *
      *             system. CREATED WITH *OPTIMIZE                    *
      *                                                               *
      *  Called By: EDC0010 - Bulk Transfer Preparation Component     *
      *                                                               *
      *  Calls:     AOBANKR0 - Access Object for Bank Details ICD     *
      *             AOCOBPR0 - Access Object for COB ICD Details      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD058071           Date 11May21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CED002             DATE 13MAY97               *
      *                 CED001             DATE 27AUG96               *
      *                 S01493 *CREATE     DATE 03Jun94               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058071 - Deliverable Data Split for Export Data            *
      *  MD046248 - Finastra Rebranding                               *
      *  CED002  - Midas ED Enhancements                              *
      *            Recompiled for changes to EDBUTFPD/EDFBUTPD        *
      *  CED001  - Midas Export Data Phases III & IV                  *
      *  S01493  - Midas Export Data Interface Module.                *
      *                                                               *
      *****************************************************************
      *
     F*EDBUTFPD* IF   E             DISK    INFSR(*PSSR)                                    MD058071
      *                                                                   CED001
     FEDFBUTPD  O    E             DISK    INFSR(*PSSR)                         CED001
     F                                     RENAME(EDBUTFD0:EDFBUTD0)            CED001
      **************                                                      CED001
     F*EDBUT0PDO***E                    DISK         KINFSR *PSSR         CED001
     F************EDBUTFD0                          KRENAMEEDBUT0D0       CED001
      ****Stream*0*file                                                   CED001
     F*EDBUT1PDO***E                    DISK         KINFSR *PSSR         CED001
     F************EDBUTFD0                          KRENAMEEDBUT1D0       CED001
      ****Stream*1*file                                                   CED001
     F*EDBUT2PDO***E                    DISK         KINFSR *PSSR         CED001
     F************EDBUTFD0                          KRENAMEEDBUT2D0       CED001
      ****Stream*2*file                                                   CED001
     F*EDBUT3PDO***E                    DISK         KINFSR *PSSR         CED001
     F************EDBUTFD0                          KRENAMEEDBUT3D0       CED001
      ****Stream*3*file                                                   CED001
     F*EDBUT4PDO***E                    DISK         KINFSR *PSSR         CED001
     F************EDBUTFD0                          KRENAMEEDBUT4D0       CED001
      ****Stream*4*file                                                   CED001
     F*EDBUT5PDO***E                    DISK         KINFSR *PSSR         CED001
     F************EDBUTFD0                          KRENAMEEDBUT5D0       CED001
      ****Stream*5*file                                                   CED001
     F*EDBUT6PDO***E                    DISK         KINFSR *PSSR         CED001
     F************EDBUTFD0                          KRENAMEEDBUT6D0       CED001
      ****Stream*6*file                                                   CED001
     F*EDBUT7PDO***E                    DISK         KINFSR *PSSR         CED001
     F************EDBUTFD0                          KRENAMEEDBUT7D0       CED001
      ****Stream*7*file                                                   CED001
     F*EDBUT8PDO***E                    DISK         KINFSR *PSSR         CED001
     F************EDBUTFD0                          KRENAMEEDBUT8D0       CED001
      ****Stream*8*file                                                   CED001
     F*DBUT9PDO***E*                   DISK         KINFSR *PSSR          CED001
     F************EDBUTFD0                          KRENAMEEDBUT9D0       CED001
      ****Stream*9*file                                                   CED001
     FED0010AU  O    E             PRINTER
     F/COPY WNCPYSRC,ED0010F001
      *
      /TITLE FUNCTION OF INCICATORS
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *    01  - READ OF EDBUTFPD                                     *
      *    41  - ED0010AU HEADER PRINTED                              *
      *                                                               *
      *    98  - Date Format: DDMMYY (off); MMDDYY (on)               *
      *  90-99 - Used by Standard Subroutines                         *
      *                                                               *
      *  U7+U8 - Database Error                                       *
      *                                                               *
      *****************************************************************
      /TITLE SUBROUTINE INDEX
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  #INIT  - Initial Processing                                  *
      *  #DETL  - Perform Detail Processing                           *
      *  *PSSR  - Program error handling routine                      *
      *                                                               *
      *****************************************************************
     D/TITLE E-SPECIFICATIONS
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      ***  Array for Object Copyright Statement.
      *
     D/TITLE I-SPECIFICATIONS
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First Data Structure for Access Objects
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank Details
      *
     D/COPY WNCPYSRC,ED0010I001
     D*SDCOBP****E*DSSDCOBPPD                                             CED001
      ***COB*ICD*Details                                                  CED001
     D******************                                                  CED001
     D*DTQA*****     E DS                  EXTNAME(EDBUTFPD)                    CED001      MD058071
     D DTQA          E DS                  EXTNAME(EDBUTJW0)                                MD058071
     D**  Data Queue Structure                                            CED001
     D*                                                                   CED001
     D DBERR           DS           256
      * Data structure for data-base error processing.
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
      *
      ** PROGRAM STATUS DATA STRUCTURE
     D                SDS
     D  WSID                 244    253
     D  USID                 254    263
     D #EXSC           S             10                                                     MD058071
     C/TITLE Main Processing
      *================================================================
      *  P R O G R A M     S T A R T                                  *
      *================================================================
      *
     C     *ENTRY        PLIST                                                              MD058071
     C                   PARM                    EXSC             10                        MD058071
      ***  Perform Initialisation.
      *
     C                   EXSR      #INIT
      *
      ***  Perform Detail Processing.
      *
     C                   EXSR      #DETL
      *
      *================================================================
      *  P R O G R A M     E N D                                      *
      *                                                               *
     C                   SETON                                        LR
     C                   RETURN
      *                                                               *
      *================================================================
      /TITLE SR/INIT
      *****************************************************************
      *                                                               *
      *  INIT   - Subroutine to do Program Initialisation.            *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls    : None.                                             *
      *                                                               *
      *****************************************************************
      *
     C     #INIT         BEGSR
      *
      ***  Copyright Statement.
      *
     C                   MOVEA     CPY@          ACT@             80
      *
      *** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     WRTCD             7
     C                   PARM      '*FIRST '     WOPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     WRTCD         IFNE      *BLANKS
     C                   Z-ADD     001           DBASE                          ***************
     C                   MOVEL     'SDBANKPD'    DBFILE                         * DB ERROR 01 *
     C                   MOVE      *BLANKS       DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   END
      *
      ***  Check System Date Format, DDMMYY (*IN98 off)
      ***                            MMDDYY (*IN98 on).
      *
     C     BJDFIN        IFEQ      'M'
     C                   SETON                                        98
     C                   ELSE
     C                   SETOFF                                       98
     C                   END
      *
      *** Audit Header
      *
     C                   WRITE     HEADAU
     C                   SETON                                        41
      **************                                                      CED001
      ****Access*COB ICD Details                                          CED001
      **************                                                      CED001
     C**************       CALL 'AOCOBPR0'                                CED001
     C**************       PARM '*MSG   ' WRTCD   7                       CED001
     C**************       PARM '*FIRST ' WOPTN   7                       CED001
     C***********SDCOBP    PARM SDCOBP    DSFDY                           CED001
      **************                                                      CED001
     C***********WRTCD     IFNE *BLANKS                                   CED001
     C**************       Z-ADD002       DBASE            ***************CED001
     C**************       MOVEL'SDCOBPPD'DBFILE           * DB ERROR 02 *CED001
     C**************       MOVE *BLANKS   DBKEY            ***************CED001
     C**************       EXSR *PSSR                                     CED001
     C**************       END                                            CED001
      **************                                                      CED001
      *****Initialisations                                                CED001
      **************                                                      CED001
     C************LIKE     DEFN DOMNAS    USTRC                           CED001
     C************LIKE     DEFN DOMNAS    UCOBS                           CED001
     C***********DOMNAS    SUB  1         UCOBS                           CED001
     C**************       Z-ADD0         USTRC                           CED001
     C                   Z-ADD     0             UFLSR             9 0                         CED00
     C                   Z-ADD     34            DTQALN                                        CED00
     C/COPY WNCPYSRC,ED0010C001
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/PROCES
      *****************************************************************
      *                                                               *
      *  PROCES - Subroutine to do the Detail Processing.             *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *****************************************************************
      *
     C     #DETL         BEGSR
      *
     C                   eval      #EXSC = EXSC                                             MD058071
     C**********         READ      EDBUTFPD                               01                MD058071
     C/EXEC SQL                                                                             MD058071
     C+ declare ACursor insensitive scroll cursor for                                       MD058071
     C+ select * from EDBUTJW0                                                              MD058071
     C+ where EDEXSC = :#EXSC                                                               MD058071
     C+ order by EDEXSC, EDSQCD                                                             MD058071
     C/END-EXEC                                                                             MD058071
                                                                                            MD058071
     C/EXEC SQL                                                                             MD058071
     C+ open ACursor                                                                        MD058071
     C/END-EXEC                                                                             MD058071
                                                                                            MD058071
     C/EXEC SQL                                                                             MD058071
     C+ fetch next from ACursor into :DTQA                                                  MD058071
     C/END-EXEC                                                                             MD058071
                                                                                            MD058071
      *
      ***  Process until End of valid records.
      *
     C******IN01         DOWEQ     *OFF                                         B1          MD058071
     C     SQLCODE       DOWEQ     0                                            B1          MD058071
      *
      **   Write to the next stream file
      *
     C***********USTRC     IFEQ 0                          B2             CED001
     C**************       WRITEEDBUT0D0                                  CED001
     C**************       ENDIF                           E2             CED001
      **************                                                      CED001
     C***********USTRC     IFEQ 1                          B2             CED001
     C**************       WRITEEDBUT1D0                                  CED001
     C**************       ENDIF                           E2             CED001
      **************                                                      CED001
     C***********USTRC     IFEQ 2                          B2             CED001
     C**************       WRITEEDBUT2D0                                  CED001
     C**************       ENDIF                           E2             CED001
      **************                                                      CED001
     C***********USTRC     IFEQ 3                          B2             CED001
     C**************       WRITEEDBUT3D0                                  CED001
     C**************       ENDIF                           E2             CED001
      **************                                                      CED001
     C***********USTRC     IFEQ 4                          B2             CED001
     C**************       WRITEEDBUT4D0                                  CED001
     C**************       ENDIF                           E2             CED001
      **************                                                      CED001
     C***********USTRC     IFEQ 5                          B2             CED001
     C**************       WRITEEDBUT5D0                                  CED001
     C**************       ENDIF                           E2             CED001
      **************                                                      CED001
     C***********USTRC     IFEQ 6                          B2             CED001
     C**************       WRITEEDBUT6D0                                  CED001
     C**************       ENDIF                           E2             CED001
      **************                                                      CED001
     C***********USTRC     IFEQ 7                          B2             CED001
     C**************       WRITEEDBUT7D0                                  CED001
     C**************       ENDIF                           E2             CED001
      **************                                                      CED001
     C***********USTRC     IFEQ 8                          B2             CED001
     C**************       WRITEEDBUT8D0                                  CED001
     C**************       ENDIF                           E2             CED001
      **************                                                      CED001
     C***********USTRC     IFEQ 9                          B2             CED001
     C**************       WRITEEDBUT9D0                                  CED001
     C**************       ENDIF                           E2             CED001
      **************                                                      CED001
      ****INCREMENT*STREAM COUNTER, UP TO NUMBER OF ACTIVE STREAMS        CED001
      **************                                                      CED001
     C**************       ADD  1         USTRC                           CED001
     C***********USTRC     IFGT UCOBS                      B2             CED001
     C**************       Z-ADD0         USTRC                           CED001
     C**************       ENDIF                           E2             CED001
      *                                                                   CED001
      *** Copy Files to be transferred to Failed Components File          CED001
      *** and The Data Queue                                              CED001
      *                                                                   CED001
     C     EDEXFL        IFEQ      'Y'                                                         CED00
     C/COPY WNCPYSRC,ED0010C002
      *                                                                   CED001
     C                   WRITE     EDFBUTD0                                                    CED00
      *                                                                   CED001
     C                   CALL      'QSNDDTAQ'                                                  CED00
     C                   PARM      'EDBULKQ'     DTQANM           10                           CED00
     C                   PARM      '*LIBL'       DTQALB           10                           CED00
     C                   PARM                    DTQALN            5 0                         CED00
     C                   PARM                    DTQA                                          CED00
      *                                                                   CED001
     C/COPY WNCPYSRC,ED0010C003
     C                   ENDIF                                                                 CED00
      *
     C                   ADD       1             UFLSR
      *
      ** READ NEXT RECORD
     C**********         READ      EDBUTFPD                               01                MD058071
     C/EXEC SQL                                                                             MD058071
     C+ fetch next from ACursor into :DTQA                                                  MD058071
     C/END-EXEC                                                                             MD058071
      *
     C                   ENDDO                                                  E1
      *
      *** Audit Detail
      *
     C                   WRITE     DETAILAU
      *
     C/EXEC SQL                                                                             MD058071
     C+ close ACursor                                                                       MD058071
     C/END-EXEC                                                                             MD058071
                                                                                            MD058071
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/*PSSR
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Error Processing Subroutine.                *
      *                                                               *
      *  Called By: Various                                           *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  *** *PSSR  ***
      *
     C                   SETON                                        U7U8LR
      *
      ***  Check to see that *PSSR has not already been called.
      *
     C     WRUN          IFEQ      *BLANK
     C                   MOVE      'Y'           WRUN              1
     C                   MOVEL     'ED0010'      DBPGM
      *
     C     *DTAARA       DEFINE    LDA           WLDA            256
     C     *LOCK         IN        WLDA
     C                   MOVEL     DBERR         WLDA
     C                   OUT       WLDA
      *
      ***  ERROR REPORT  ED0010AU
      *
     C     *IN41         IFEQ      *OFF
     C                   WRITE     HEADAU
     C                   SETON                                        41
     C                   ENDIF
      *
     C                   WRITE     DBERROR
      *
     C                   DUMP
     C                   END
      *
      ** Exit program
      *
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      ***
**  CPY@
(c) Finastra International Limited 2001
