     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058085
/*STD *  RPGSQLBND                                                    *                     MD058085
/*EXI *  TEXT('Midas RE Initialisation program for CRT005')
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE0015 - Initialisation Program for CRT005                   *
      *                                                               *
      *  Function:  This program will initialise the value of the     *
      *             new fields in the ICD record for PF/SDBAIIPD      *
      *             when the enhancement CRT005 is installed.         *
      *                                                               *
      *  Called By: REC0015 - Initialisation CLP for Feature CRT005   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD058085           Date 11May21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *                 CRT005  *CREATE    Date 09Aug01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058085 - Deliverable Data Split for Standing Data          *
      *  MD046248 - Finastra Rebranding                               *
      *  CRT005 - Cashier Enhancement for Cash In/Cash Out            *
      *                                                               *
      *****************************************************************
      *
     FSDBAIIPD  UF   E             DISK    INFSR(*PSSR)
      ** Midas Standing Data CI ICD
      *
     F*SDBAITL0* UF   E           K DISK    INFSR(*PSSR)                                    MD058085
      ** Midas Standing Data CI Transaction Types
      *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   01 - Read SDBAIIPD indicator                                *
      *   02 - Read SDBAITL0 indicator                                *
      *                                                               *
      * U7+U8 - Database Error                                        *
      *                                                               *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      /EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Array containing Copyright statement
     D SDBAIP        E DS                  EXTNAME(SDBATJW0)                                MD058085
      *
     C/EJECT
      *****************************************************************
      *                       M A I N L I N E S                       *
      *****************************************************************
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Initialise new fields
      *
     C                   READ      SDBAIIPD                               01
      *
     C     *IN01         DOWEQ     *OFF
     C                   MOVE      'Y'           FUTCI
     C     'RE4122'      CAT       '00E'         FUTCIP
     C                   MOVE      'Y'           FUTCO
     C     'RE4122'      CAT       '00F'         FUTCOP
     C                   MOVE      'Y'           FUTTI
     C     'RE4122'      CAT       '0JE'         FUTTIP
     C                   MOVE      'Y'           FUTTO
     C     'RE4122'      CAT       '0JF'         FUTTOP
     C                   UPDATE    SDBAIID0
     C                   READ      SDBAIIPD                               01
     C                   ENDDO
      *
      ** Set 'Data Queue for Process' to blanks because current value
      ** 'NOTAPPLIC' is misleading since Balance Cash processing is now
      ** available in Midas
      *
     C                   MOVEL     'SP251   '    WDQNM            10
      *
     C*****WDQNM         SETLL     SDBAITL0                                                 MD058085
     C*****WDQNM         READE     SDBAITL0                               02                MD058085
      *
     C******IN02         IFEQ      '0'                                                      MD058085
     C**********         MOVE      *BLANKS       FXDQNM                                     MD058085
     C**********         UPDATE    @BAITL0                                                  MD058085
     C**********         ENDIF                                                              MD058085
     C/EXEC SQL                                                                             MD058085
     C+ update SDBATXTD set                                                                 MD058085
     C+   FXDQNM = :FXDQNM                                                                  MD058085
     C+ where FXBAIT = :WDQNM                                                               MD058085
     C/END-EXEC                                                                             MD058085
      *
     C                   MOVE      *ON           *INLR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by:                                                    *
      * Calls: None                                                   *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   END
      *
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
     C                   ENDSR
      *
**  CPY@
(c) Finastra International Limited 2001
