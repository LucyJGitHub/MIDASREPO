     H DATEDIT(*YMD)
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD056555
/*STD *  RPGSQLBND                                                    *                     MD056555
/*EXI *  TEXT('Midas SC Switchable f by init pgm report')
     H/TITLE Midas SC Switchable f by init pgm report
     F* CRTRPGPGM
      *
     H* SYNOPSIS :
     H* - Print report of file contents
      *
     H* Generated by  : SYNON/2  Version:  1080
     H* Function type : Print file
      *
     H* Company       : Close of Business SYNON model
     H*  System  : Midas COB
     H* User name     : HAUT
     H* Date          : 07/07/93  Time  : 18:09:46
      *  (c) Finastra International Limited 2001                      *
      *
      *================================================================
     F* Maintenance   :
     F*****************************************************************
     F*                                                                  *
      *  Last Amend No. MD056555           Date 31Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 S01430             Date 07Jul93               *
     F*                                                                  *
     F********************************************************************
     F*                                                                  *
      *  MD056555 - Deliverable Data Split for SAR group              *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
     F*     S01430 - SWITCHABILITY ENHANCEMENTS PHASE 2                  *
     F*              INCLUSION OF SWITCHABLE FEATURE INITIALISATION      *
     F*              PROGRAMS                                            *
     F*                                                                  *
     F********************************************************************
     F*SCSARPL1* IF   E           K DISK                                                    MD056555
      * RTV : Midas SC Switchable f - initialisation pgm
      *
     FSC3090P1  O    E             PRINTER OFLIND(*IN97)
     F                                     INFDS(INFDS$)
      * PRT: Midas SC Switchable f by init pgm report
      *
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D********************************************************************
     D*
     D* Description     : Copyright notice for inclusion in all programs
     D*
      /EJECT
      * Data structures:
     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
      * Program data structure
     D JBDTTM          DS
      * Job date/time
     D  ##JDT                  1      6  0
     D  ##JYY                  1      2  0
     D  ##JMM                  3      4  0
     D  ##JDD                  5      6  0
     D  ##JTM                  7     12  0
     D  ##JHH                  7      8  0
     D  ##JNN                  9     10  0
     D  ##JSS                 11     12  0
     D A@CPY           DS
     D* Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)              Copyright     array
     D RUNDAT          DS
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  SUC                   11     11
     D  DFF                   12     12
     D  MBIN                  13     13
     D P@BANK        E DS                  EXTNAME(SDBANKPD)
      * @BTREE4 - BANK RECORD FORMAT DATA STRUCTURE
      *
     D P@FMT         E DS                  EXTNAME(DSFDY)
     D* FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D*
      *
     D INFDS$        E DS                  EXTNAME(Y2I$DSP)
      * Printer file information data structure
      *
      /EJECT
      * Parameter declarations
     D P1PARM          DS
      * I : RST Switchable Feature Number
     D  P1SARN                 1      6
     D P2PARM          DS
      * I : RST Description
     D  P2SARD                 1     50
     D SCSARP        E DS                  EXTNAME(SCSRPJW0)                                MD056555
      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C     P1SARN        PARM                    WP0001            6            Switchable Feat
     C     P2SARD        PARM                    WP0002           50            Description
      *****************************************************************
      * Initialise
     C                   EXSR      ZZINIT
      *
      * Print  Switchable F - Ini: Mainline
     C                   EXSR      A0MAIN
      * Print headers then End of report format
     C                   EXSR      Q0PRNT
     C                   WRITE     $DENDRPT
      * Exit program
     C                   EXSR      ZXEXPG
      * ------------------------------------------------------
      /EJECT
     CSR   A0MAIN        BEGSR
      *================================================================
      * Print  Switchable F - Ini: Mainline
      *================================================================
      * Declare restrictor key work fields
     C     *LIKE         DEFINE    AKSARN        WQKA01                         Switchable Feat
      * Define keylist
     C     KRSA          KLIST
     C                   KFLD                    WQKA01                         Switchable Feat
      * Move fields to key list
     C                   MOVEL     P1SARN        WQKA01                         Switchable Feat
      * Establish starting position
     C*****KRSA          SETLL     @SARPL1                                      *           MD056555
     C/EXEC SQL                                                                             MD056555
     C+ declare ACursor insensitive scroll cursor for                                       MD056555
     C+ select * from SCSRPJW0                                                              MD056555
     C+ where AKSARN = :WQKA01                                                              MD056555
     C+ order by AKSARN, AKPNAM                                                             MD056555
     C/END-EXEC                                                                             MD056555
                                                                                            MD056555
     C/EXEC SQL                                                                             MD056555
     C+ open ACursor                                                                        MD056555
     C/END-EXEC                                                                             MD056555
                                                                                            MD056555
      * Read first record with user selection
     C                   EXSR      A3READ
     C     W0EOFA        IFNE      '0'                                          IF
     C                   ELSE
      * Request all headings
     C                   MOVEL     'Y'           W0AL1P            1            First page
     C                   MOVEL     'Y'           W0AL00            1            Switchable Feat
      * Set column headings flag
     C                   MOVE      'Y'           W0ACDT
      * Print report body
     C     W0EOFA        DOWEQ     '0'                                          DOW
      * Prepare heading formats for printing
     C                   EXSR      A1PHDR
      * Print report detail line
     C                   EXSR      A2PDTL
      * Read next record with user selection
     C                   EXSR      A3READ
      * Print totals
     C                   EXSR      A4PTOT
     C                   END                                                    WOD
     C                   END                                                    FI
      *================================================================
     CSR   A0EXIT        ENDSR
      /EJECT
     CSR   A1PHDR        BEGSR
      *================================================================
      * Prepare heading formats for printing
      *================================================================
     C     W0AL1P        IFEQ      'Y'
      * Signal that format is now ready to print
     C                   MOVE      'Y'           W0AP1P            1
     C                   END
      *
     C     W0AL00        IFEQ      'Y'
      * Load key header format
     C                   MOVEL     AKSARN        $BSARN                         Switchable Feat
     C                   MOVEL     *BLANK        $BSDES                         Description of
      * Signal that format is now ready to print
     C                   MOVE      'Y'           W0AP00            1
     C                   END
      *
      *================================================================
     CSR   A1EXIT        ENDSR
      /EJECT
     CSR   A2PDTL        BEGSR
      *================================================================
      * Process detail record
      *================================================================
      * Load details format
     C                   MOVEL     AKSARN        $CSARN                         Switchable Feat
     C                   MOVEL     AKPNAM        $CPNAM                         Program Name
     C                   MOVEL     AKPDSC        $CPDSC                         Program Descrip
     C                   MOVEL     AKPRVC        $CPRVC                         Program Previou
     C                   MOVEL     AKTYL1        $CTYL1                         Type of Last Ch
     C                   Z-ADD     AKLCD         $CLCD                          Last change dat
     C                   MOVEL     *BLANK        $CACDT                         Alpha Change Da
     C                   MOVEL     *BLANK        $CALCH                         Alpha of Last C
      * Signal that format is now ready to print
     C                   MOVE      'Y'           W0APDT            1
      * Call print routine
     C                   EXSR      Q0PRNT
      *
      *================================================================
     CSR   A2EXIT        ENDSR
      /EJECT
     CSR   A3READ        BEGSR
      *================================================================
      * Read next record
      *================================================================
      * Hold current values
     C     *LIKE         DEFINE    AKSARN        WZA001                         Switchable Feat
     C                   MOVEL     AKSARN        WZA001
      * Read next record
     C     W0RSL         DOUEQ     'Y'                                          DOU
     C     W0EOFA        OREQ      '1'
     C*****KRSA*         READE     @SARPL1                                90    *           MD056555
     C/EXEC SQL                                                                             MD056555
     C+ fetch next from ACursor into :SCSARP                                                MD056555
     C/END-EXEC                                                                             MD056555
     C                   SETOFF                                       90                    MD056555
     C                   IF        SQLCODE = 100                                            MD056555
     C                   SETON                                        90                    MD056555
     C                   Endif                                                              MD056555
                                                                                            MD056555
      * Transfer error indicator to EOF flag
     C                   MOVEL     *IN90         W0EOFA            1
      * Quit if no record read
     C     W0EOFA        IFNE      '1'                                          IF
      * Select record unless user action states otherwise
     C                   MOVEL     'Y'           W0RSL             1
     C                   END                                                    FI
     C                   END                                                    UOD
      *
      * Reset key level breaks
     C                   MOVEL     *BLANK        W0AL00            1            Switchable Feat
     C     W0EOFA        IFEQ      '1'
      * End of file - Signal all level breaks
     C                   MOVEL     'Y'           W0AL00            1            Switchable Feat
     C                   ELSE
      * Next record - Detect level breaks
     C     AKSARN        IFNE      WZA001                                       Switchable Feat
      * Set on level break indicator
     C                   MOVEL     'Y'           W0AL00
     C                   END
     C                   END
      *================================================================
     CSR   A3EXIT        ENDSR
      /EJECT
     CSR   A4PTOT        BEGSR
      *================================================================
      * Print report Totals
      *================================================================
      * Print level break totals as required
     C     W0AL00        IFEQ      'Y'
      * Signal header format is no longer ready
     C                   MOVEL     *BLANK        W0AP00
     C                   END
      *
     C     W0EOFA        IFEQ      '1'
     C                   END
      *
      *================================================================
     CSR   A4EXIT        ENDSR
      /EJECT
     CSR   Q0PRNT        BEGSR
      *================================================================
      * Print report formats
      *================================================================
      * Select formats to print
     C                   EXSR      Q1FSEL
      * Calculate length of formats selected for printing
     C                   EXSR      Q2PLEN
      * Add column heading length to print length
     C                   ADD       W0COLN        W0FSUM
     C     W0NEWP        IFNE      'Y'
      * Signal overflow if requested headings would cause
      * detail format to start past the overflow line
     C     W0FSUM        IFGT      W0OFL
     C                   MOVE      'Y'           W0NEWP
     C                   ELSE
      * Signal overflow if requested headings would cause
      * Detail format to be printed past end of page
     C                   ADD       W0DTLN        W0FSUM
     C     W0FSUM        IFGT      W0PGL
     C                   MOVE      'Y'           W0NEWP
     C                   END
     C                   END
     C                   END
      * Print Standard report header of Print  Switchable F - Ini
      * If it is ready to print, then do so,
     C     W0NEWP        IFEQ      'Y'                                          IF
     C                   EXSR      Q3PTNP
     C                   END                                                    FI
      *
      * Print First Page Format of Print  Switchable F - Ini
      * If it is ready to print, then do so,
      * or if new page & print on new page selected &
      * active then set print format flag
     C     W0AP1P        IFEQ      'Y'                                          IF
     C     W0NEWP        OREQ      'Y'
     C     W0AP1P        ANDEQ     'P'
      * Reset format print flag
     C                   MOVE      *BLANK        W0AP1P
      * Clear first page flag.
     C                   MOVE      *BLANK        W0AL1P
     C                   END                                                    FI
      * Print Switchable Feature Number of Print  Switchable F - Ini
      * If it is ready to print, then do so,
      * or if new page & print on new page selected &
      * active then set print format flag
     C     W0AP00        IFEQ      'Y'                                          IF
     C     W0NEWP        OREQ      'Y'
     C     W0AP00        ANDEQ     'P'
     C                   MOVEL     'Y'           W0PFM
      * USER: On print of Switchable Feature Number format
     C                   MOVEL     P2SARD        $BSDES                         Description of
     C     W0PFM         IFEQ      'Y'
      * Print format
     C                   WRITE     $BKEYHDR
      * Set column headings flag
     C                   MOVE      'Y'           W0ACDT
     C                   END                                                    FI
      *
      * Reset format print flag
     C                   MOVE      *BLANK        W0AP00
     C                   END                                                    FI
      * Print Detail line. of Print  Switchable F - Ini
      * If new page then set column headings active
     C     W0NEWP        IFEQ      'Y'
     C                   MOVE      'Y'           W0ACDT            1
     C                   END
      * If it is ready to print, then do so,
      * or if new page & print on new page selected &
      * active then set print format flag
     C     W0APDT        IFEQ      'Y'                                          IF
     C     W0NEWP        OREQ      'Y'
     C     W0APDT        ANDEQ     'P'
     C                   MOVEL     'Y'           W0PFM
      * USER: On print of detail format
      * Convert Day No to Date - Rundate  *
     C                   CALL      'ZDATE2'                             90      Convert Day No
     C                   PARM      AKLCD         WQ0001            5 0          Work Midas Day
     C                   PARM      WUE3ST        WQ0002            1            date format fla
     C     WUWCDT        PARM      *ZERO         WQ0003            6 0          Work Converted
     C     WUWADT        PARM      *BLANK        WQ0004            7            Work Converted
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   END
      *
     C                   MOVEL     WUWADT        $CACDT                         Alpha Change Da
      * CUR.Alpha of Last Change Type = Condition name of DB1.Type of Last Chang
     C                   CALL      'CBRVCNR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1100307       Y2LSNO            7 0          List number
     C                   PARM      AKTYL1        W0INVL           20            Type of Last Ch
     C                   PARM      ' '           W0VLMP            1            Value mapped
     C     $CALCH        PARM                    W0CNNM           25            Alpha of Last C
      *
     C     W0PFM         IFEQ      'Y'
      * Convert fields to external form
      * Print column headings if required
     C     W0ACDT        IFEQ      'Y'
     C                   WRITE     $CCOLHDG
      * Clear column headings control flag
     C                   MOVE      *BLANK        W0ACDT
     C                   END                                                    FI
      * Print format
     C                   WRITE     $CDTLRCD
     C                   END                                                    FI
      *
      * Reset format print flag
     C                   MOVE      *BLANK        W0APDT
     C                   END                                                    FI
      * Clear new page flag
     C                   MOVE      *BLANK        W0NEWP
      *================================================================
     CSR   Q0EXIT        ENDSR
      /EJECT
     CSR   Q1FSEL        BEGSR
      *================================================================
      * Format select
      *================================================================
      *================================================================
     CSR   Q1EXIT        ENDSR
      /EJECT
     CSR   Q2PLEN        BEGSR
      *================================================================
      * Evaluate print length
      *================================================================
     C                   Z-ADD     @$CLN         W0FSUM            3 0
     C                   Z-ADD     *ZERO         W0DTLN            3 0
     C                   Z-ADD     *ZERO         W0COLN            3 0
      * * First Page Format of Print  Switchable F - Ini
     C     W0AP1P        IFEQ      'Y'
     C                   ADD       0             W0FSUM
     C                   END                                                    FI
      *
      * * Switchable Feature Number of Print  Switchable F - Ini
     C     W0AP00        IFEQ      'Y'
     C                   ADD       3             W0FSUM
     C                   END                                                    FI
      *
      * * Detail line. of Print  Switchable F - Ini
     C     W0APDT        IFEQ      'Y'
     C                   Z-ADD     1             W0DTLN
     C     W0ACDT        IFEQ      'Y'
     C                   Z-ADD     5             W0COLN
     C                   END                                                    FI
     C                   END                                                    FI
      *
      *================================================================
     CSR   Q2EXIT        ENDSR
      /EJECT
     CSR   Q3PTNP        BEGSR
      *================================================================
      * Format select
      *================================================================
     C                   WRITE     $APAGHDR
      * Clear page overflow indicator
     C                   SETOFF                                       97        *
      *================================================================
     CSR   Q3EXIT        ENDSR
      /EJECT
     CSR   ZXEXPG        BEGSR
      *================================================================
      * Exit program
      *================================================================
     C/EXEC SQL                                                                             MD056555
     C+ close ACursor                                                                       MD056555
     C/END-EXEC                                                                             MD056555
     C                   MOVEL     *BLANK        P0RTN
     C                   EXSR      ZYEXPG
      *================================================================
     CSR   ZXEXIT        ENDSR
      /EJECT
     CSR   ZYEXPG        BEGSR
      *================================================================
      * Exit program: Direct
      *================================================================
      * Terminate program
     C                   SETON                                        LR
      *
      * Exit program
     C                   RETURN
      *
      *================================================================
     CSR   ZYEXIT        ENDSR
      /EJECT
     CSR   ZZINIT        BEGSR
      *================================================================
      * Initialisation
      *================================================================
     C                   MOVE      *BLANK        P0RTN
     C                   MOVE      *BLANK        W0RTN             7
     C                   MOVEL     *BLANK        W0RSL             1
     C                   MOVEL     *BLANK        W0RSF             1
      * Setup job date/time
      *
     C                   Z-ADD     UDATE         ##JDT
     C                   TIME                    ##JTM
      * Update screen time
     C                   TIME                    ##TME             6 0
      * Define work field midas rundate
     C                   MOVEL     *BLANK        WUAANA            7
      * Define work field run day number
     C                   Z-ADD     *ZERO         WUAKTX            5 0
      * Define work field Set Up Complete
     C                   MOVEL     *BLANK        WUAUST            1
      * Define work field date format flag
     C                   MOVEL     *BLANK        WUE3ST            1
      * Define work field Multi-branching Indicator
     C                   MOVEL     *BLANK        WUF1ST            1
      * Define work field Work Converted Date (6.0)
     C                   Z-ADD     *ZERO         WUWCDT            6 0
      * Define work field Work Converted Date (7A)
     C                   MOVEL     *BLANK        WUWADT            7
     C                   MOVEL     ##PGM         $APGM
     C                   MOVEL     *BLANK        W0PFM             1
     C                   Z-ADD     *ZERO         @$WRK             4 0
     C                   Z-ADD     *ZERO         @$HDL             4 0
      * Adjust page length and overflow as necessary
     C     @$PGL         SUB       2             W0PGL             4 0
     C     @$OFL         IFGE      W0PGL
     C     W0PGL         SUB       2             W0OFL             4 0
     C                   ELSE
     C                   Z-ADD     @$OFL         W0OFL
     C                   END
      * Clear overflow indicator
     C                   SETOFF                                       97
      * Request new page
     C                   MOVEL     'Y'           W0NEWP            1
      * USER: Initialise program
      * Standard RPG Creation Par - Standard functions  *
      * Copyright Statement - Standard functions  *
      * SC3090P  Last Amend Box - Switchable F - Init Pgm  *
      * Get Rundate for PRTF - Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          $AAANA
      * Get Bank Title for PRTF - Standard functions  *
      *****************************************************************
      *
      *   Declare Bank Details Data Structure
      *   And Extract User Report Title from Bank details
      *
      *****************************************************************
      *
     C                   CALL      'AOBANKR0'
     C                   PARM                    P@RTCD            7            B:Return code
     C                   PARM      '*FIRST'      P@OPTN            7            I:Option
     C     P@BANK        PARM      P@BANK        P@FMT                          O:Format
      *
     C                   MOVEL     BJURPT        $AURPT
      *================================================================
     CSR   ZZEXIT        ENDSR
**CTDATA CPY@
(c) Finastra International Limited 2001
