     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD055681
/*STD *  RPGSQLBND                                                    *                     MD055681
/**** *  TEXT('Midas Set off 'on request' LMI extract')                                     MD055681
/EXI* *  TEXT('Midas Set off  on request  LMI extract')                                     MD055681
      *****************************************************************
      *                                                               *
      *  Midas - European Reporting                                   *
      *                                                               *
      *  ER1002 - Set off 'On request' LMI extract                    *
      *                                                               *
      *  Function:  This program will setof the feature ULX004 to     *
      *             run the LMI process 'on request'                  *
      *                                                               *
      *  Called By: ERC1002                                           *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD055681           Date 31Jul20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CER001             Date 25Apr05               *
      *                 ULX004             Date 27May97               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055681 - Deliverable Data Split for SAR                    *
      *  MD046248 - Finastra Rebranding                               *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  ULX004 - Capital Adequacy                                    *
      *                                                               *
      *****************************************************************
      *
     F*SCSARDL0* UF A E           K DISK                                                    MD055681
      *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   99  - Working indicator                                     *
      *                                                               *
      *                                                               *
      *****************************************************************
      *
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
     D PSDS           SDS
      *
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
     D SCSARD        E DS                  EXTNAME(SCSRDJW0)                                MD055681
     D                                     PREFIX(AB)                                       MD055681
      *****************************************************************
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
     C*****'ULX045'      CHAIN     SCSARDL0                           99                    MD055681
     C******IN99         IFEQ      *OFF                                                     MD055681
     C/EXEC SQL                                                                             MD055681
     C+ SELECT *                                                                            MD055681
     C+ into :SCSARD                                                                        MD055681
     C+ from SCSRDJW0                                                                       MD055681
     C+ where SARN = 'ULX045'                                                               MD055681
     C/END-EXEC                                                                             MD055681
     C                   IF        SQLCODE = 0                                              MD055681
     C**********         DELETE    @SARDL0                                                  MD055681
     C/EXEC SQL                                                                             MD055681
     C+ delete from SCSRDBTD                                                                MD055681
     C+ where SARN = 'ULX045'                                                               MD055681
     C/END-EXEC                                                                             MD055681
     C/EXEC SQL                                                                             MD055681
     C+ delete from SCSRDXTD                                                                MD055681
     C+ where SARN = 'ULX045'                                                               MD055681
     C/END-EXEC                                                                             MD055681
     C                   ENDIF
      *
     C                   MOVE      *ON           *INLR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2005
