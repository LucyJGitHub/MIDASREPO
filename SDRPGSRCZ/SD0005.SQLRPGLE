      *****************************************************************
/**** *  RPGBASE                                                      *                     MD056890
/*STD *  RPGSQLBND                                                    *                     MD056890
/*EXI *  TEXT('Midas SD Maint calling pgm to check Wn')
     F*
     F*********************************************************************
     F***                                                               ***
     F***      Midas Standing Data Module
     F***                                                               ***
     F***      SD0005 - CALLS SD MAINTENANCES PROGRAMS AND CHECKS FOR   ***
     F***               WINDOW PROCESSING                               ***
     F***                                                               ***
      *  (c) Finastra International Limited 2001                      *
     F***                                                               ***
      *  Last Amend No. MD057705           Date 21Jan21               *
      *  Prev Amend No. MD056890           Date 11Oct20               *
      *                 MD055681           Date 31Jul20               *
      *                 MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 214109             Date 17Oct06               *
      *                 CPK018             Date 19Mar05               *
      * Midas Release 4.01 -------------------------------------------*
      *                 189102             Date 13Feb02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 E24414             Date 16Jul91               *
      *                 E20528             Date 08Aug90               *
     F***                                                               ***
     F********************************************************************
     F***                                                              ***
      *  MD057705 - Deliverable Data Split for SDOREFPD               *
      *  MD056890 - Deliverable Data Split for SDMREFPD               *
      *  MD055681 - Deliverable Data Split for SAR                    *
      *  MD046248 - Finastra Rebranding                               *
      *  214109 - Override SDECOSPD to SDECOSLXPD                     *
      *  CPK018 - Change to make windows switchable. Replace use of   *
      *           - Replace use of SDMREFL1 with SDMREFJ0.            *
      *  189102 - Replace READ with standard access object in re-     *
      *           trieving modules present.                           *
     F***   E24414 - CALL UP SINGLE EDIT RECORD IF EITHER A MANDATORY  ***
     F***            OR AN OPTIONAL WINDOW IS DEFINED.                 ***
     F***                                                              ***
     F***   E20528 - RECORD LEVEL FUNCTION CALLED IF THERE IS A        ***
     F***            WINDOW ON SDOREFPD                                ***
     F******************************************************************
     F***SDMMODPDIF  E                    DISK                                                189102
     F*SDMREFL1IF*E*******    K        DISK                                                   CPK018
     F*SDMREFJ0* IF   E           K DISK                                                    MD056890
     F*SDOREFL1* IF   E           K DISK                                         E20528     MD057705
     D MSG             S             40    DIM(1) CTDATA PERRCD(1)
     D OVR             S             51    DIM(1) CTDATA PERRCD(1)
     D DLTOVR          S             21    DIM(1) CTDATA PERRCD(1)
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *                                                                                       189102
      ** Data structure for modules file                                                      189102
      *                                                                                       189102
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
     D SDMREF        E DS                  EXTNAME(SDMRFJW1)                                MD056890
     D NullInds        s              5i 0 dim(17)                                          MD056890
     D SDOREF        E DS                  EXTNAME(SDOREJW0)                                MD057705
      *                                                                                       189102
     D*  DATA STRUCTURE FOR COMPILATION  - COPYRIGHT INSERTION
     D CPYR@#          DS
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D  CPY@##                 1     20
     C*
     C*  ENTRY PARAMETERS ARE PROGRAM NAMES
     C*
     C     *ENTRY        PLIST
     C                   PARM                    PGM1              8
     C                   PARM                    PGM2              8
     C                   PARM                    PGMMD             1
     C                   PARM                    PGM3              8
     C*
     C                   MOVEL     PGM1          PGM51             5
     C                   MOVEL     PGM2          PGM52             5
     C     PGM51         IFEQ      'SD009'
     C     PGM52         OREQ      'SD009'
     C                   CALL      'QCMDEXC'                            16
     C                   PARM                    OVR
     C                   PARM      51            WLEN             15 5
     C                   END
     C     PGM1          IFEQ      *BLANKS
     C**N92*****           CALL PGM2                     90                                   189102
      *                                                                                       189102
     C     *IN92         IFEQ      '0'
     C                   CALL      PGM2                                 90
     C                   PARM                    WORTN             7
     C                   PARM                    PGMMD
     C                   ENDIF
      *                                                                                       189102
     C                   ELSE
     C*
     C*  IF NO ALTERNATIVE PROGRAM FOR WINDOWS (PGM2) CALL PGM1
     C*
     C     PGM2          IFEQ      *BLANKS
     C*
     C                   CALL      PGM1                                 90
     C                   PARM                    WORTN             7
     C*
     C                   ELSE
     C*
     C**********           READ SDMMODPD                 91                                   189102
      *                                                                                       189102
      ** Access Midas module details.                                                         189102
      *                                                                                       189102
     C                   CALL      'AOMMODR0'
     C                   PARM      '*MSG'        @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *                                                                                       189102
     C     @RTCD         IFNE      *BLANKS
     C                   EXSR      *PSSR
     C                   ENDIF
     C*
     C*  CHECK MMOD FOR WINDOW PROCESSING FLAG 'YES'
     C*
     C     BGWDPR        IFEQ      'Y'
     C*
     C*  CHECK SDMREFPD TO SEE IF WINDOW PROCESSING DEFINED
     C*  AND CHECK SDOREFPD TO SEE IF WINDOW PROCESSING DEFINED           E20528
     C*
     C                   MOVEL     PGM3          WPGM3            10
     C********** WPGM3     CHAINSDMREFL1             92                                       CPK018
     C*****WPGM3         CHAIN     SDMREFJ0                           92                    MD056890
     C/EXEC SQL                                                                             MD056890
     C+ SELECT *                                                                            MD056890
     C+ into :SDMREF :NullInds                                                              MD056890
     C+ from SDMRFJW1                                                                       MD056890
     C+ where DLNMCP = :WPGM3                                                               MD056890
     C/END-EXEC                                                                             MD056890
     C                   setoff                                       92                    MD056890
     C                   If        SQLCODE = 100                                            MD056890
     C                   seton                                        92                    MD056890
     C                   Endif                                                              MD056890
                                                                                            MD056890
     C*****WPGM3         CHAIN     SDOREFL1                           93              E2052 MD057705
     C/EXEC SQL                                                                             MD057705
     C+ SELECT *                                                                            MD057705
     C+ into :SDOREF                                                                        MD057705
     C+ from SDOREJW0                                                                       MD057705
     C+ where DMNMCP = :WPGM3                                                               MD057705
     C/END-EXEC                                                                             MD057705
     C                   setoff                                       93                    MD057705
     C                   If        SQLCODE = 100                                            MD057705
     C                   seton                                        93                    MD057705
     C                   Endif                                                              MD057705
                                                                                            MD057705
     C     *IN92         IFEQ      '1'                                                         E2052
     C************IN93     OREQ '1'                                 E20528E24414
     C     *IN93         ANDEQ     '1'                                                         E2441
     C***92******          CALL PGM1                   90                 E20528
     C                   CALL      PGM1                                 90                     E2052
     C                   PARM                    W0RTN             7
     C**N92******          CALL PGM2                   90                 E20528
     C                   ELSE                                                                  E2052
     C                   CALL      PGM2                                 90                     E2052
     C                   PARM                    W0RTN             7
     C                   PARM                    PGMMD
     C                   END                                                                   E2052
     C*
     C                   ELSE
     C                   CALL      PGM1                                 90
     C                   PARM                    WORTN             7
     C                   END
     C                   END
     C                   END
     C*
     C*  SEND ERROR MESSAGE IF CALL OR READ OPERATIONS FAIL
     C*
     C***91*****                                                                              189102
     C***OR*90**    MSG,1     DSPLY'*EXT'    REPLY   1                                        189102
     C     *IN90         IFEQ      '1'
     C     MSG(1)        DSPLY     '*EXT'        REPLY             1
     C                   ENDIF
     C*
     C                   SETON                                        LR
     C     PGM51         IFEQ      'SD009'
     C     PGM52         OREQ      'SD009'
     C                   CALL      'QCMDEXC'                            16
     C                   PARM                    DLTOVR
     C                   PARM      21            WLEN             15 5
     C                   END
     C*                                                                                       214109
     C                   RETURN
      *****************************************************************                       189102
      *                                                               *                       189102
      * *PSSR --- Subroutine to handle abnormal error conditions.     *                       189102
      *                                                               *                       189102
      * CALLED FROM: After abnormal operation occurs.                 *                       189102
      *                                                               *                       189102
      * CALLS: None.                                                  *                       189102
      *                                                               *                       189102
      *****************************************************************                       189102
      *                                                                                       189102
     C     *PSSR         BEGSR
      *                                                                                       189102
     C     @RUN          IFEQ      *BLANKS
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   ENDIF
     C                   MOVE      '1'           *INLR
     C                   RETURN
      *                                                                                       189102
     C                   ENDSR
      *****************************************************************                       189102
     C*
**CTDATA CPY@
(c) Finastra International Limited 2001
**CTDATA MSG
Transaction Failed, Enter to Continue
**CTDATA OVR
OVRDBF FILE(SDECOSPD) TOFILE(SDECOSLXPD) SHARE(*NO)
**CTDATA DLTOVR
DLTOVR FILE(SDECOSPD)
