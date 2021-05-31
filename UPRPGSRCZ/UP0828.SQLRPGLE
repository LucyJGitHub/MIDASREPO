     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD055265
/*STD *  RPGSQLBND                                                    *                     MD055265
/*EXI *  TEXT('Midas UP Upd. FCRPDSPA to = no of FCREPTPD records')
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade module                                       *
      *                                                               *
      *  UP0828 - Count FCREPTPD records and update FCRPDSPA          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD055265           Date 10Feb20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 138018             Date 06Jul98               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD055265 - Deliverable Data Split for Report Control Facility*
      *  MD046248 - Finastra Rebranding                               *
      *  138018  -  Update of FCRPDSPA added.                         *
      *                                                               *
      *****************************************************************
      * ID F  C  H  L    FUNCTION OF INDICATORS
      *
      *       20      End of file
      *       30      Chain - record not found
      *       69      Read, write or chain fail
      *       70 - 81 Indicators for changed fields
      *
     F*FCREPTPD* IF   E             DISK                                                    MD055265
     FFCRPDSPA  UF   E             DISK
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Array containing Copyright statement
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
     C                   MOVEL     *BLANKS       COUNT             5 0
     C**********         READ      FCREPTPD                               20                MD055265
      **********                                                                            MD055265
     C******IN20         DOWEQ     '0'                                                      MD055265
     C**********         ADD       1             COUNT                                      MD055265
     C**********         READ      FCREPTPD                               20                MD055265
     C**********         ENDDO                                                              MD055265
      *
     C/EXEC SQL                                                                             MD055265
     C+ declare Cursor insensitive scroll cursor for                                        MD055265
     C+ select *                                                                            MD055265
     C+  from FCREPUW0                                                                      MD055265
     C/END-EXEC                                                                             MD055265
                                                                                            MD055265
     C/EXEC SQL                                                                             MD055265
     C+ open Cursor                                                                         MD055265
     C/END-EXEC                                                                             MD055265
                                                                                            MD055265
     C/EXEC SQL                                                                             MD055265
     C+ get diagnostics :Count = DB2_NUMBER_ROWS                                            MD055265
     C/END-EXEC                                                                             MD055265
     C                   READ      FCRPDSPA                               20
     C                   Z-ADD     COUNT         ADNORC
     C                   UPDATE    FCRPDSA0
      *
     C                   SETON                                        LR
     C                   RETURN
**  CPY@
(c) Finastra International Limited 2001
