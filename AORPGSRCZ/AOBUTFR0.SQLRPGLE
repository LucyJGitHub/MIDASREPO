     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058071
/*STD *  RPGSQLBND                                                    *                     MD058071
/*EXI *  TEXT('Midas AO ED bulk transfer access object')
      *****************************************************************
      *                                                               *
      *  Midas  Access Objects                                        *
      *                                                               *
      *  AOBUTFR0 - Read Access to files available for                *
      *             bulk transfer                                     *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD058071           Date 11May21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 237033             Date 26May06               *
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CED005 *CREATE     Date 11AUG97               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD058071 - Deliverable Data Split for Export Data            *
      *  MD046248 - Finastra Rebranding                               *
      *  237033 - Apply 145111.                                       *
      *  145111 - DO NOT PRODUCE DUMP WHEN EXPORT DATA MODULE IS OFF. *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CED002 - Export Dta Enhancement for GIB                      *
      *                                                               *
      *****************************************************************
      /EJECT
      ************************************************************
      *
     F*EDBUTFL1* IF   E           K DISK    USROPN                                          MD058071
      ** IN - Files available for bulk transfer
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *  01 - No specific transfer request found on LF/EDBUTFL1       *
      *  02 - No general request found on LF/EDBUTFL1                 *
      *  03 - MIDAS EXPORT DATA MODULE IS ON.                         *   145111
      *                                                               *
      *                                                               *
      *****************************************************************
      *
      ** Copyright array
      *
      /EJECT
      ************************************************************
      *
     D*ED@FMT***     E DS                  EXTNAME(EDBUTFPD)                                MD058071
     D ED@FMT        E DS                  EXTNAME(EDBUTJW0)                                MD058071
      ** Drip feed files record format data structure
      *
     D P@FMT         E DS                  EXTNAME(DSFDY)
     D** External Data structure to hold the outgoing record format
     D** of the file.
      *
     D PGMDS          SDS
      * Program Status data structure
     D  PGNAME                 1     10
     D  PGLIBR                81     90
     D  PGJBNM               244    253
     D  PGUSER               254    263
     D  PGJBNO               264    269  0
      *
     D A@CPY           DS
     D** Copyright data structure
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                    145111
      **  MODULE DETAILS                                                  145111
      *                                                                   145111
      /EJECT
      *================================================================
      *  P R O G R A M     S T A R T                                  *
      *================================================================
      *
     C     *ENTRY        PLIST
     C                   PARM                    P@FILE           10
     C                   PARM                    P@MBR            10
     C                   PARM                    P@RTCD            7
     C                   PARM                    P@FMT
      *
      ** Copyright Statement
     C                   MOVEA     CPY@          ACT@             80
     C*                                                                   145111
     C** ACCESS MODULE DETAILS                                            145111
     C*                                                                   145111
     C                   CALL      'AOMMODR0'                                                  14511
     C                   PARM      '*DBERR'      WRTCD             7                           14511
     C                   PARM      '*FIRST'      WOPTN             7                           14511
     C     SDMMOD        PARM      SDMMOD        P@FMT                                         14511
      *                                                                   145111
      **  CHECK IF EXPORT DATA MODULE IS PRESENT IN THE SYSTEM.           145111
      *                                                                   145111
     C     BGNZST        IFEQ      'Y'                                                         14511
     C                   MOVE      '1'           *IN03                                         14511
     C                   END                                                                   14511
      *
      ** Key list to access LF/EDBUTFL1
     C     KEY1          KLIST
     C                   KFLD                    KFILE            20
      *
      ** Open file, setup key list values
     C**********         OPEN      EDBUTFL1                                                 MD058071
     C     P@FILE        CAT       P@MBR         KFILE
      *
      ** Check for specific transfer request (i.e. file and member)
     C*****KEY1*         CHAIN     EDBUTFL1                           01                    MD058071
     C/EXEC SQL                                                                             MD058071
     C+ SELECT *                                                                            MD058071
     C+ into :ED@FMT                                                                        MD058071
     C+ from EDBUTJW0                                                                       MD058071
     C+ where EDTRFN = :KFILE and EDEXFL= 'Y'                                               MD058071
     C/END-EXEC                                                                             MD058071
      *
      ** Specific request not found, check for general request of
      ** all members for requested file.
     C******IN01         IFEQ      '1'                                                      MD058071
     C     SQLCODE       IFEQ      100                                                      MD058071
     C                   MOVEL(P)  P@FILE        KFILE
     C*****KEY1*         CHAIN     EDBUTFL1                           02                    MD058071
     C/EXEC SQL                                                                             MD058071
     C+ SELECT *                                                                            MD058071
     C+ into :ED@FMT                                                                        MD058071
     C+ from EDBUTJW0                                                                       MD058071
     C+ where EDTRFN = :KFILE and EDEXFL= 'Y'                                               MD058071
     C/END-EXEC                                                                             MD058071
     C                   ENDIF
      *
      ** No general request found, return *FAILED
     C******IN02         IFEQ      '1'                                                      MD058071
     C     SQLCODE       IFEQ      100                                                      MD058071
     C                   MOVEL     '*FAILED'     P@RTCD
     C                   MOVEL     *BLANKS       P@FMT
     C**********         CLOSE     EDBUTFL1                                                 MD058071
     C                   SETON                                        LR
     C     *IN03         IFEQ      '1'                                                         14511
     C                   DUMP
     C                   END                                                                   14511
     C                   RETURN
     C                   ENDIF
      *
      ** Record found, set return format to contents of record found
     C                   MOVEL     ED@FMT        P@FMT
      *
      ** Close file, terminate program.
     C**********         CLOSE     EDBUTFL1                                                 MD058071
     C                   SETON                                        LR
     C                   RETURN
      *
      **************************************************************************
**CTDATA CPY@
(c) Finastra International Limited 2001
