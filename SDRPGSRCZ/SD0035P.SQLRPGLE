     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058085
/*STD *  RPGSQLBND                                                    *                     MD058085
/*EXI *  TEXT('Midas SD TI account types list report')
      *****************************************************************
      *                                                               *
      *  Midas - Trade Inovation (TI) Module                          *
      *                                                               *
      *  SD0035P - TI Accounts Types Report                           *
      *                                                               *
      *  Program Function: Lists TI Account Types                     *
      *                                                               *
      *  Phase(s): I/C by Menu Request                                *
      *                                                               *
      *  Called By: SDC541P                                           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD058085           Date 11May21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CTI004             Date 12Apr04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CTI099             Date 14Jul99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CTI001   *CREATE   Date 16JUL97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058085 - Deliverable Data Split for Standing Data          *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CTI004 - MidasPlus-TI Integration Enchancements              *
      *           Account Codes Integration                           *
      *  CTI099 - Utility to open accounts for Midas/TI Interface     *
      *  CTI001 - Midas / Trade Innovation Interface Phase 1          *
      *                                                               *
      *****************************************************************
      *
      * TI Account Types
     F*SDTIACPD* IF   E             DISK    INFSR(*PSSR)                                    MD058085
      *
     FSD0035AU  O    E             PRINTER
     F                                     INFDS(SPOOLU)
     FSD0035P1  O    E             PRINTER USROPN
     F                                     INFDS(SPOOL1)
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   89  - End of File                                           *
      *   98  - Date Format: DDMMYY (off); MMDDYY (on)                *
      * 90-99 - Used by Standard Subroutines                          *
      *                                                               *
      * U7+U8 - Database Error                                        *
      *                                                               *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  AUDIT  - Produce Audit Report and End Program                *
      *  *PSSR  - Program Error processing Subroutine                 *
      *  RCFP1  - RCF processing for P1 Report                        *
      *  RCFAU  - RCF processing for Audit Report                     *
      *                                                               *
      *****************************************************************
     D/EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      ** Array containing Copyright statement
      *
      /SPACE 3
     D SDTIIN        E DS                  EXTNAME(SDTIINPD)
      **  TI ICD FIle                                                                         CTI099
      *                                                                   156783
     D DSFDY         E DS                  EXTNAME(DSFDY)                       156783
      **  Short data structure for access programs                        156783
      *
     D DBERR         E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D**   BANK DETAILS                                                                       CTI004
     D SDTIAC        E DS                  EXTNAME(SDTIAJW0)                                MD058085
     D PSDS           SDS
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
     D RUNDAT          DS
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  SUC                   11     11
     D  DFF                   12     12
     D  MBIN                  13     13
     D SPOOL1          DS
      ***  File Information Data Structure for TI0311P1.
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
      *
     D SPOOLU          DS
      ***  File Information Data Structure for TI0311AU.
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
      *
     C/TITLE Main Processing
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
      *
     C**********         READ      SDTIACPD                               89                MD058085
     C/EXEC SQL                                                                             MD058085
     C+ close ACursor                                                                       MD058085
     C/END-EXEC                                                                             MD058085
                                                                                            MD058085
     C/EXEC SQL                                                                             MD058085
     C+ declare ACursor insensitive scroll cursor for                                       MD058085
     C+ select * from SDTIAJW0                                                              MD058085
     C+ order by GDC5AT                                                                     MD058085
     C/END-EXEC                                                                             MD058085
                                                                                            MD058085
     C/EXEC SQL                                                                             MD058085
     C+ open ACursor                                                                        MD058085
     C/END-EXEC                                                                             MD058085
                                                                                            MD058085
     C/EXEC SQL                                                                             MD058085
     C+ fetch next from ACursor into :SDTIAC                                                MD058085
     C/END-EXEC                                                                             MD058085
                                                                                            MD058085
     C                   setoff                                       89                    MD058085
     C                   If        SQLCODE = 100                                            MD058085
     C                   seton                                        89                    MD058085
     C                   Endif                                                              MD058085
                                                                                            MD058085
      *
     C     *IN89         IFEQ      *OFF
      *
     C                   OPEN      SD0035P1
     C                   EXSR      RCFP1
      *
     C     *IN89         DOWEQ     *OFF
      *
     C                   ADD       1             RCOUNT
      *
      ** Check that sufficient lines remain for the Format.
     C                   Z-ADD     5             RQDLN1            3 0
     C     OFLLN1        SUB       PRTLN1        DIFLN1            3 0
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF
      *
     C     GDBCNO        IFEQ      '000000'
     C                   MOVE      *BLANKS       GDBCNO
     C                   ELSE
      * Check if it is SP101 Account Type
     C                   CALL      'AOTIINR0'
     C                   PARM      '*MSG'        WWRTCD            7
     C                   PARM      '*FIRST'      WWOPTN            7
     C     SDTIIN        PARM      SDTIIN        DSFDY
     C     TIATYP        IFEQ      GDC5AT
     C                   MOVEL     GDBCNO        WBCNO             3
     C                   MOVEL     *BLANKS       GDBCNO
     C                   MOVEL     WBCNO         GDBCNO
     C                   ELSE
     C                   MOVEL     GDBCNO        GDBCNO
     C                   ENDIF
     C                   ENDIF
     C                   MOVEL     GDVFFM        GDRFFM            1
      *                                                                                       CTI099
     C                   WRITE     DETAIL
      *
     C**********         READ      SDTIACPD                               89                MD058085
     C/EXEC SQL                                                                             MD058085
     C+ fetch next from ACursor into :SDTIAC                                                MD058085
     C/END-EXEC                                                                             MD058085
                                                                                            MD058085
     C                   setoff                                       89                    MD058085
     C                   If        SQLCODE = 100                                            MD058085
     C                   seton                                        89                    MD058085
     C                   Endif                                                              MD058085
      *
     C                   ENDDO
      *
     C                   WRITE     TRAILP1
     C                   CLOSE     SD0035P1
      *
     C                   ENDIF
      *
     C                   EXSR      AUDIT
      *
      *================================================================
      *  P R O G R A M   E N D                                        *
      *================================================================
     C/EJECT
      *****************************************************************
      *                                                               *
      *  INIT   - Subroutine to do Program Initialisation.            *
      *                                                               *
      *  Called By: Automatically                                     *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    PRTNCD            7
     C                   PARM                    PMODE             1
     C                   PARM                    PSEQ              5
     C                   PARM                    PLEVEL            1
     C                   PARM                    PENT              3
      * Get Rundate - Rundate  *                                                              CTI004
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          BJMRDT
      * Get Title                                                                             CTI004
      * Get Bank Title - Bank Details  *                                                      CTI004
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ***  Initialise LDA field.
      *
     C                   MOVEL     'SD0035P'     DBPGM
      *
     C     *DTAARA       DEFINE    LDA           @LDA            256
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/AUDIT
      *****************************************************************
      *                                                               *
      *  AUDIT  - Subroutine to Output Audit report and End Program.  *
      *                                                               *
      *  Called By: Main Processing, *PSSR                            *
      *  Calls: None.                                                 *
      *                                                               *
      *****************************************************************
      *
     C     AUDIT         BEGSR
      *
      ***  RCF Processing for Audit File.
     C                   EXSR      RCFAU
      *
      ***  Output Report Header and File Controls.
     C                   WRITE     HEADAU
     C                   WRITE     CONTROL
      *
      ***  If there is a DB Error, Output the DB Error Information.
     C     *INU7         IFEQ      *ON
     C                   WRITE     DBERROR
     C                   ENDIF
      *
      ***  If there are no details
     C     RCOUNT        IFEQ      0
     C                   WRITE     NODTLS
     C                   ENDIF
      *
      ***  End Program and Return.
      *
     C                   SETON                                        LR
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/*PSSR
      *****************************************************************
      *                                                               *
      *  *PSSR  - Error control subroutine                            *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
      ***  Check to see that *PSSR has not already been called.
      *
     C     WRUN          IFEQ      *BLANK
     C                   MOVE      'Y'           WRUN              1
      *
     C     *LOCK         IN        @LDA
     C                   MOVEL     DBERR         @LDA
     C                   OUT       @LDA
     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   EXSR      AUDIT
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
      /TITLE SR/RCFP1
      *****************************************************************
      *                                                               *
      *  RCFP1  - Subroutine to register the P1 Printer File via RCF. *
      *                                                               *
      *****************************************************************
      *
     C     RCFP1         BEGSR
      *
      ***  Ensure Report Spool File recorded by RCF.
      *
     C                   Z-ADD     SFNUM1        ZSNUM             6 0
      *
     C                   CALL      'ZSFILE'
     C                   PARM      PSEQ          SEQ               5
     C                   PARM                    SENTY             3
     C                   PARM                    SFILE1
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR             1
      *
      ***  If Error occurs during ZSFILE Processing, then return to the
      ***  Calling Program.
      *
     C     ZSERR         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/RCFAU
      *****************************************************************
      *                                                               *
      *  RCFAU  - Subroutine to register the AU Printer File via RCF. *
      *                                                               *
      *****************************************************************
      *
     C     RCFAU         BEGSR
      *
      ***  Ensure Audit Spool File recorded by RCF.
      *
     C                   Z-ADD     SFNUMU        ZSNUMU            6 0
      *
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       SEQ
     C                   PARM      *BLANKS       SENTY
     C                   PARM                    SFILEU
     C                   PARM                    ZSNUMU
     C                   PARM      *BLANK        ZSERR
      *
      ***  If Error occurs during ZSFILE Processing, then return to the
      ***  Calling Program.
      *
     C     ZSERR         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
