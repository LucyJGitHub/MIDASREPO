     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058071
/*STD *  RPGSQLBND                                                    *                     MD058071
/*EXI *  TEXT('Midas AO ED drip-feed transfer access object')
      *****************************************************************
      *                                                               *
      *  Midas  Access Objects                                        *
      *                                                               *
      *  AODFTFR0 - Read Access to files available for                *
      *                drip feed                                      *
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
      *                 CED002 *CREATE     DATE 20MAY97               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD058071 - Deliverable Data Split for Export Data            *
      *  MD046248 - Finastra Rebranding                               *
      *  CED002 - Export Dta Enhancement for GIB                      *
      *                                                               *
      *****************************************************************
      /EJECT
      ************************************************************
      *
     F*EDDFTFL1* IF   E           K DISK    USROPN                                          MD058071
      ** IN - Files available for drip feed
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *  01 - No specific transfer request found on LF/EDDFTFL1       *
      *  02 - No general request found on LF/EDDFTFL1                 *
      *  03 - No general request found on LF/EDDFTFL1                 *
      *  04 - No general request found on LF/EDDFTFL1                 *
      *                                                               *
      *                                                               *
      *****************************************************************
      *
      ** Copyright array
      *
      /EJECT
      ************************************************************
      *
     D*ED@FMT***     E DS                  EXTNAME(EDDFTFPD)                                MD058071
     D ED@FMT        E DS                  EXTNAME(EDDFTJW0)                                MD058071
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
      /EJECT
      *================================================================
      *  P R O G R A M     S T A R T                                  *
      *================================================================
      *
     C     *ENTRY        PLIST
     C                   PARM                    P@FILE           10
     C                   PARM                    P@MBR            10
     C                   PARM                    P@PGM            10
     C                   PARM                    P@RTCD            7
     C                   PARM                    P@FMT
      *
      ** Copyright Statement.
      *
     C                   MOVEA     CPY@          ACT@             80
      *
      ** Key list to access LF/EDDFTFL1
      *
     C     KEY1          KLIST
     C                   KFLD                    KFILE            20
     C                   KFLD                    KPGM             10
      *
      ** Open file, setup key list values
      *
     C**********         OPEN      EDDFTFL1                                                 MD058071
     C     P@FILE        CAT       P@MBR         KFILE
     C                   MOVEL     P@PGM         KPGM
      *
      ** Check for specific transfer request.
      *
     C*****KEY1*         CHAIN     EDDFTFL1                           01                    MD058071
     C/EXEC SQL                                                                             MD058071
     C+ SELECT *                                                                            MD058071
     C+ into :ED@FMT                                                                        MD058071
     C+ from EDDFTJW0                                                                       MD058071
     C+ where EGTRFN = :KFILE and EGORPR = :KPGM and EGEXFL = 'Y'                           MD058071
     C/END-EXEC                                                                             MD058071
      *
      ** Transfer request not found, check for general request of
      ** all members for requested file/program.
      *
     C******IN01         IFEQ      '1'                                                      MD058071
     C     SQLCODE       IFEQ      100                                                      MD058071
     C                   MOVEL     *BLANKS       KFILE
     C                   MOVEL     P@FILE        KFILE
     C*****KEY1*         CHAIN     EDDFTFL1                           02                    MD058071
     C/EXEC SQL                                                                             MD058071
     C+ SELECT *                                                                            MD058071
     C+ into :ED@FMT                                                                        MD058071
     C+ from EDDFTJW0                                                                       MD058071
     C+ where EGTRFN = :KFILE and EGORPR = :KPGM and EGEXFL = 'Y'                           MD058071
     C/END-EXEC                                                                             MD058071
     C                   ENDIF
      *
      ** Transfer request not found, check for general request of
      ** requested file/member for any program.
      *
     C******IN02         IFEQ      '1'                                                      MD058071
     C     SQLCODE       IFEQ      100                                                      MD058071
     C                   MOVEL     *BLANKS       KPGM
     C     P@FILE        CAT       P@MBR         KFILE
     C*****KEY1*         CHAIN     EDDFTFL1                           03                    MD058071
     C/EXEC SQL                                                                             MD058071
     C+ SELECT *                                                                            MD058071
     C+ into :ED@FMT                                                                        MD058071
     C+ from EDDFTJW0                                                                       MD058071
     C+ where EGTRFN = :KFILE and EGORPR = :KPGM and EGEXFL = 'Y'                           MD058071
     C/END-EXEC                                                                             MD058071
     C                   ENDIF
      *
      ** Transfer request not found, check for general request for
      ** requested file for any member/program.
      *
     C******IN03         IFEQ      '1'                                                      MD058071
     C     SQLCODE       IFEQ      100                                                      MD058071
     C                   MOVEL     *BLANKS       KFILE
     C                   MOVEL     P@FILE        KFILE
     C*****KEY1*         CHAIN     EDDFTFL1                           04                    MD058071
     C/EXEC SQL                                                                             MD058071
     C+ SELECT *                                                                            MD058071
     C+ into :ED@FMT                                                                        MD058071
     C+ from EDDFTJW0                                                                       MD058071
     C+ where EGTRFN = :KFILE and EGORPR = :KPGM and EGEXFL = 'Y'                           MD058071
     C/END-EXEC                                                                             MD058071
     C                   ENDIF
      *
      ** No record found, terminate program.
      *
     C******IN04         IFEQ      '1'                                                      MD058071
     C     SQLCODE       IFEQ      100                                                      MD058071
     C                   MOVEL     '*FAILED'     P@RTCD
     C                   MOVEL     *BLANKS       P@FMT
     C**********         CLOSE     EDDFTFL1                                                 MD058071
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
      *
      ** Record found, set return format to contents of record found
      *
     C                   MOVEL     ED@FMT        P@FMT
      *
      ** Close file, terminate program.
      *
     C**********         CLOSE     EDDFTFL1                                                 MD058071
     C                   SETON                                        LR
     C                   RETURN
      *
      **************************************************************************
**CTDATA CPY@
(c) Finastra International Limited 2001
