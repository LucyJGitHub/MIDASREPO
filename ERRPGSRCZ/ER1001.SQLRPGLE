     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD055681
/*STD *  RPGSQLBND                                                    *                     MD055681
/***I *  TEXT('Midas Set on 'on request' LMI extract')                                      MD055681
/*EXI *  TEXT('Midas Set on  on request  LMI extract')                                      MD055681
      *****************************************************************
      *                                                               *
      *  Midas - European Reporting                                   *
      *                                                               *
      *  ER1001 - Set on 'On request' LMI extract                     *
      *                                                               *
      *  Function:  This program will set on the feature ULX004 to    *
      *             run the LMI process 'on request'                  *
      *                                                               *
      *  Called By:                                                   *
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
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Externak data structure for access program format
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Data structure for access program, short data structure
      *
     D WWSARD          C                   CONST(' ON REQUEST LMI EXTR-
     D                                     ACT')
      ** Feature description
     D SCSARD        E DS                  EXTNAME(SCSRDJW0)                                MD055681
     D                                     PREFIX(AB)                                       MD055681
      *
      *****************************************************************
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Access bank detail
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     P@RTCD            7
     C                   PARM      '*FIRST '     P@OPTN            7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Check if end of month,
      ** The IML extract runs every on of month, so in case of end of month
      ** the feature shouldn't be set on
      *
     C                   CALL      'SD2000'
     C                   PARM      *BLANKS       WWEOM             1
     C                   PARM      *BLANKS       WWEOY             1
     C                   PARM      *BLANKS       WWERR             1
      *
      ** If not end of month and the feature ULX045 doesn't exist, add the
      ** feature in the file.
      *
     C     WWEOM         IFNE      'Y'
     C*****'ULX045'      CHAIN     SCSARDL0                           99                    MD055681
     C******IN99         IFEQ      *ON                                                      MD055681
     C/EXEC SQL                                                                             MD055681
     C+ SELECT *                                                                            MD055681
     C+ into :SCSARD                                                                        MD055681
     C+ from SCSRDJW0                                                                       MD055681
     C+ where SARN = 'ULX045'                                                               MD055681
     C/END-EXEC                                                                             MD055681
     C                   IF        SQLCODE = 100                                            MD055681
     C                   MOVEL     'ULX045'      ABSARN
     C                   MOVEL     WWSARD        ABSARD
     C                   Z-ADD     BJRDNB        ABLCD
     C                   MOVE      'I'           ABTYLC
     C**********         WRITE     @SARDL0                                                  MD055681
     C/EXEC SQL                                                                             MD055681
     C+ insert into SCSRDBTD                                                                MD055681
     C+ (                                                                                   MD055681
     C+   SARN                                                                              MD055681
     C+ , SARD                                                                              MD055681
     C+ , LCD                                                                               MD055681
     C+ , TYLC                                                                              MD055681
     C+ , ZONE                                                                              MD055681
     C+ , ENABLD                                                                            MD055681
     C+ , MODE                                                                              MD055681
     C+ )                                                                                   MD055681
     C+ Values                                                                              MD055681
     C+ (                                                                                   MD055681
     C+   :ABSARN                                                                           MD055681
     C+ , :ABSARD                                                                           MD055681
     C+ , :ABLCD                                                                            MD055681
     C+ , 'I'                                                                               MD055681
     C+ , ' '                                                                               MD055681
     C+ , 'E'                                                                               MD055681
     C+ , 'B'                                                                               MD055681
     C+ )                                                                                   MD055681
     C/END-EXEC                                                                             MD055681
     C/EXEC SQL                                                                             MD055681
     C+ insert into SCSRDXTD                                                                MD055681
     C+ (                                                                                   MD055681
     C+   SARN                                                                              MD055681
     C+ , LCD                                                                               MD055681
     C+ , TYLC                                                                              MD055681
     C+ , ZONE                                                                              MD055681
     C+ , ENABLD                                                                            MD055681
     C+ , MODE                                                                              MD055681
     C+ )                                                                                   MD055681
     C+ Values                                                                              MD055681
     C+ (                                                                                   MD055681
     C+   :ABSARN                                                                           MD055681
     C+ , :ABLCD                                                                            MD055681
     C+ , 'I'                                                                               MD055681
     C+ , ' '                                                                               MD055681
     C+ , 'E'                                                                               MD055681
     C+ , 'B'                                                                               MD055681
     C+ )                                                                                   MD055681
     C/END-EXEC                                                                             MD055681
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVE      *ON           *INLR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2005
