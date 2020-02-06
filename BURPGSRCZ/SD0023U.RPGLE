      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  DFTACTGRP(*NO) ACTGRP(*CALLER)                               *                       CAP084
/*EXI *  TEXT('Midas BU BackGnd Upd of Limit Rates on TABTG10')
     F********************************************************************
     F*
     F*  Midas Standing Data module
     F*
     F*     Background update of Limit rates on old currency codes files
     F*
      *  (c) Finastra International Limited 2001                      *
     F*
      *     Last Amend No. MD046248           Date 27Oct17            *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *     Prev Amend No. CAP084             Date 26Aug03            *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
     F*     Prev Amend No. E20297             DATE 18APR90
     F*                    S01230             DATE 07/11/89               S01230
     F*                    S01229             DATE 20/10/89               S01229
     F*
     F********************************************************************
     F*                                                                  *
      *     MD046248 - Finastra Rebranding                               *
     F*     CAP084  - Wrapper project - convert to ILE                   *
     F*     E20297  -  ADD RETURN CODE TO PARAMETER LIST                 *E20297
     F*     S01230  - STANDARDISE ACCESS PROGRAMS                        *S01230
     F*     S01229  -  SYNON FIELD NAME CHANGES                          *S01229
     F*                                                                  *
     F********************************************************************
     F*
     F* ID F  C  H  L    FUNCTION OF INDICATORS
     F*
     F*       20      Chain CCY Failed/Error TABTG10
     F*       31      Error on old CCY file
     F*       32      Error on Trailer file
     F*
     F********************************************************************
     FTABTG10   UF   E           K DISK
     F                                     COMMIT
     FTABLETXL  UF   E           K DISK
     F                                     COMMIT
      /EJECT
     D* Description     : Copyright notice for inclusion in all progra    S01230
     D*                                                                   S01230
     D********************************************************************S01230
     D********************************************************************S01230
      /EJECT                                                              S01230
     D*                                                                   S01230
     D* Description     : Copyright notice for inclusion in all programs  S01230
     D*                                                                   S01230
     D A@CPY           DS                                                       S01230
     D* Copyright array                                                   S01230
     D  CPY@                   1     80                                         S01230
     D                                     DIM(1) CTDATA PERRCD(1)              Copyright     arrS01
     I*                                                                   S01230
      /EJECT                                                              S01230
     C*
     C     *ENTRY        PLIST
     C                   PARM                    W0RTN             7            Return Code    E2029
     C*********************PARM           WCCY    3        Currency Code  S01229
     C                   PARM                    WCYCD             3            Currency Code  S0122
     C                   PARM                    WERLC            13 8          Exch Rate Limits
     C*
     C* Retrieve old currency file record
     C*
     C***********WCCY      CHAINTABTG10              20    Chain failed   S01229
     C     WCYCD         CHAIN     TABTG10                            20        Chain failed   S0122
     C*
     C* If CHAIN to file successful
     C*
     C     *IN20         IFEQ      '0'
     C                   Z-ADD     WERLC         ERLC                           Exch Rate Limits
     C*
     C* Update the Limit rate on TABTG10
     C*
     C                   UPDATE    TABTG10F                             31      ERROR
     C*
     C* If UPDATE to file successful
     C*
     C     *IN31         IFEQ      '0'
     C*
     C* Retrieve old trailer file record
     C*
     C     '20'          CHAIN     TABLETXF                           32        CHAIN FAILED
     C*
     C* If CHAIN to file successful
     C*
     C     *IN32         IFEQ      '0'
     C*
     C* Update the number of amends on the trailer file
     C*
     C                   ADD       1             NAMD                           No. Amends
     C*
     C                   UPDATE    TABLETXF                             32        ERROR
     C*
     C                   END
     C                   END
     C                   END
     C*                                                                   E20297
     C* If Error on CHAIN or UPDATE                                       E20297
     C*                                                                   E20297
     C     *IN20         IFEQ      '1'                                                         E2029
     C     *IN31         OREQ      '1'                                                         E2029
     C     *IN32         OREQ      '1'                                                         E2029
     C                   MOVE      '*ERROR*'     W0RTN                                         E2029
     C                   END                                                                   E2029
     C*
     C                   SETON                                        LR        Close Files
     C                   RETURN                                                 Exit
**CTDATA CPY@
(c) Finastra International Limited 2001
