     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas EM T/F update of EMCEX')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Exposure Management Module                           *
      *                                                               *
      *  EM0730 - Midas EM T/F update of EMCEX                        *
      *                                                               *
      *  Function: This program updates the on-line exposure file     *
      *    (I/C    (EMCEXX2) for T/F  accounts for each customer as   *
      *    INIT)   At the close of business on the next working day.  *
      *                                                               *
      *         This program can be run   only if feature CTI002 is   *
      *         active.                                               *
      *                                                               *
      *         Reads all records in file EMTFCBL0 for customer and   *
      *         account - there will only be one record for each      *
      *         Customer / Account code.                              *
      *                                                               *
      *         Update the customer exposure on file EMCEXX2 - TFEX   *
      *         with the total exposure found for this customer.      *
      *                                                               *
      *  Called By: EMC0603  - I/C INIT                               *
      *                                                               *
      *  Calls: AOSARDR0 - Midas AO switchable features               *
      *         ZASNMG   - Midas SY Access object message handling    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD030956           Date 09Oct14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CTI002  *CREATE    Date 18NOV98               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD030956 - Additional changes to BFM-TI enhancement          *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  nnnnnn - (fix details)                                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    89         For EMTFCBPD reading                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  #UPDEMC - Update EMCEXX2                                     *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FEMTFCBL0  IF   E           K DISK    INFSR(*PSSR)
     FEMCEX     UF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(EMCEXX2F)
      /EJECT
     D WCUST           S              6
     D WTFEXC          S                   LIKE(CBEXP)
     D WTFOFB          S                   LIKE(CBOFFB)
      *
      ** Array containing Copyright statement
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      /SPACE 3
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
     D P@MGDA          DS
     D  @MG                    1     50
     D                                     DIM(1) CTDATA PERRCD(1)
      *
     D PSDS           SDS
      * Program Status data structure
     D  PGNAME                 1     10
     D  PGLIBR                81     90
     D  PGJBNM               244    253
     D  PGUSER               254    263
     D  PGJBNO               264    269  0
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      /EJECT
      *
      *CSTART
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Read in Installation Data
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT
      * Define work field SAR number field
     C                   MOVEL     *BLANK        WUSARN            6
      * Define work field Access Pgm Return Code
     C                   MOVEL     *BLANK        WUAPRC            7
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'EM0730'      DBPGM
     C                   OUT       LDA
      *
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
      *
     C     AGDFF         IFEQ      'M'
     C                   SETON                                        98
     C                   ENDIF
      *
      **Check*if*feature*CTI002*is*active.*****************************     I002            MD030956
      *****************************************************************                     MD030956
     C**********         MOVEL     'CTI002'      WUSARN                     I002            MD030956
     C**********         MOVEL     *BLANK        WUAPRC                     I002            MD030956
      **SAR*switched*on*check*-*Standard*Functions*********************                     MD030956
     C**********         CALL      'AOSARDR0'                           90  I002            MD030956
     C*****WUAPRC        PARM      WUAPRC        WQ0001            7        I002            MD030956
     C**********         PARM      '*VERIFY'     WQ0002            7        I002            MD030956
     C*****WUSARN        PARM      WUSARN        WQ0003            6        I002            MD030956
     C**********         PARM      *BLANK        WQ0004           76        I002            MD030956
      *****************************************************************     I002            MD030956
     C******IN90         IFEQ      '1'                                      I002            MD030956
      ***Check*return*code.********************************************     I002            MD030956
     C*****WUAPRC        ORNE      *BLANK                                   I002            MD030956
     C******LOCK         IN        LDA                                                      MD030956
     C**********         Z-ADD     007           DBASE                                      MD030956
     C**********         MOVEL     'CTI002  '    DBFILE                                     MD030956
     C**********         MOVEL     *BLANK        DBKEY                                      MD030956
     C**********         OUT       LDA                                                      MD030956
     C**********         EXSR      *PSSR                                                    MD030956
     C**********         ENDIF                                                              MD030956
      *
      *
      ** Feature CTI002 is active
      *
      *
     C     KTFCB         KLIST
     C                   KFLD                    CBCUST
     C                   KFLD                    CBACNO
     C                   MOVEL     *LOVAL        CBCUST
     C                   Z-ADD     0             CBACNO
     C     KTFCB         SETGT     EMTFCBL0
     C                   READ      EMTFCBL0                               89
      *
      ** Do until end of file.
      *
     C     *IN89         DOWEQ     '0'
      *
      *  Customer breakdown
      *
     C     CBCUST        IFNE      WCUST
     C     WCUST         IFNE      *BLANKS
     C                   EXSR      #UPDEMC
     C                   ENDIF
     C                   MOVEL     CBCUST        WCUST
     C                   Z-ADD     0             WTFEXC
     C                   Z-ADD     0             WTFOFB
     C                   ENDIF
      *
     C                   ADD       CBEXP         WTFEXC
     C                   ADD       CBOFFB        WTFOFB
      *
     C                   READ      EMTFCBL0                               89
     C                   ENDDO
      *
      ** Dont forget the last breakdown
     C                   EXSR      #UPDEMC
      *
     C     ENDPGM        TAG
     C                   SETON                                        LR
     C                   RETURN
      *
      ********************************************************************
      /EJECT
      *
      ********************************************************************
      *                                                                  *
      *     UPDATE EXPOSURE BALANCE IN EMCEXX2                           *
      *                                                                  *
      *     CALLED FROM :-  MAIN PROCESSING                              *
      *                                                                  *
      ********************************************************************
      *
     C     #UPDEMC       BEGSR
      *
      * Ensure that at least 1 record read
     C     WCUST         IFNE      *BLANKS
     C                   MOVEL     WCUST         MCUNA                      I002
      *
     C*****MCUNA         CHAIN     EMCEX                              86                      CSD027
     C     MCUNA         CHAIN     EMCEXX2F                           86                      CSD027
      *
     C     *IN86         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     006           DBASE
     C                   MOVEL     'EMCEXX2'     DBFILE
     C                   MOVEL     MCUNA         DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   Z-ADD     WTFEXC        TFEX
     C                   Z-ADD     WTFOFB        TFOF
     C                   UPDATE    EMCEXX2F                             70
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *
      ********************************************************************
      *
      *
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   ENDIF
      *
      ************ END PROGRAM *******************************************
     C                   SETON                                        U7U8LR
     C                   RETURN
      ********************************************************************
      *
     C                   ENDSR
      *
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
