     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO IBAN validate external IBAN')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Access Object                                        *
      *                                                               *
      *  AOIBANR5 - Validate External IBAN                            *
      *                                                               *
      *  Called By:                                                   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER045             Date 20Jul09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG25904           Date 09Sep09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 255381             Date 11Jul08               *
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CFT004  *CREATE    Date 19Jul99               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER045 - German Features - Reporting Bundesbank (Recompile)  *
      *  BUG25904 - Reverse 255381.
      *  255381 - IBAN Length should include Country Code and         *
      *           Check digit code to the count to make it easier     *
      *           maintaining IBAN length as most Bankers Almanac     *
      *           quotes IBAN Length including the first 4 char       *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CFT004 - International Bank Account Number                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *     30 - LOOKUP                                               *
      *                                                               *
      *****************************************************************
     FSDCTRYL2  IF   E           K DISK
      /EJECT
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *                                                               *
      *****************************************************************
      /EJECT
      *
     D                 DS
     D ALPHAN                  1     36    DIM(36) CTDATA PERRCD(36)
      *
     D A@CPY           DS
      * Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
      *
      *
     D                 DS
      * IBAN
     D PIBAN1                  1     34                                         I:IBAN Number
     D AIBAN                   1     34    DIM(34)
      *
     C*CSTART
      *****************************************************
     C     *ENTRY        PLIST
     C                   PARM                    P@RTCD            7            B:Return code
     C                   PARM                    PIBAN            34            I:Option
      *****************************************************
      *MAIN
      *
     C                   MOVE      *BLANKS       P@RTCD
     C                   MOVE      PIBAN         PIBAN1
      *
      * Validate ISO Country Code
     C     2             SUBST     PIBAN:1       WKISO             2
     C     WKISO         CHAIN     SDCTRYL2                           70
      *   If not found, Generate Error Code 1
     C     *IN70         IFEQ      *ON
     C                   MOVE      '1'           P@RTCD
     C                   RETURN
     C                   ENDIF
      *
      * Check length of BBAN
     C     A4BBAN        IFGT      0
     C                   ELSE
      *   If not correct, Generate Error Code 2
     C                   MOVE      '2'           P@RTCD
     C                   RETURN
     C                   ENDIF
      *
      * Valid characters
     C                   Z-ADD     1             WPOS              2 0
     C     WPOS          DOWLE     34
     C     AIBAN(WPOS)   ANDNE     *BLANK
      *
     C     AIBAN(WPOS)   LOOKUP    ALPHAN                                 30
     C     *IN30         IFEQ      *OFF
      *   If invalid character, Generate Error Code 3
     C                   MOVE      '3'           P@RTCD
     C                   RETURN
     C                   ENDIF
     C                   ADD       1             WPOS
     C                   ENDDO
      *
      * Check IBAN is correct length
     C                   Z-ADD     1             WPOS              2 0
     C     ' '           LOOKUP    AIBAN(WPOS)                            30
     C     *IN30         IFEQ      *OFF
     C                   Z-ADD     35            WPOS
     C                   ENDIF
     C**********         SUB       5             WPOS                                         255381
     C**********         SUB       1             WPOS                                255381 BUG25904
     C                   SUB       5             WPOS                                       BUG25904
     C     WPOS          IFNE      A4BBAN
      *   If invalid Length, Generate Error Code 4
     C                   MOVE      '4'           P@RTCD
     C                   RETURN
     C                   ENDIF
      *
      * Check if Check Digits are Corrects
     C                   CALLB     'AOIBANR0'
     C                   PARM      *BLANKS       @@RTCD            7
     C                   PARM      'V'           @@ACTN            1
     C                   PARM      WKISO         @@ISO             2
     C                   PARM      PIBAN         @@IBAN           34
     C                   PARM                    @@OUT1           30
     C                   PARM                    @@OUT2           34
     C                   PARM                    @@OUT3            2
      *
      *   If invalid Check Digits, Generate Error Code 5
     C     @@RTCD        IFNE      *BLANKS
     C                   MOVE      '5'           P@RTCD
     C                   RETURN
     C                   ENDIF
      *
     C                   SETON                                        LR
     C                   RETURN
      *
      /EJECT
      ********************************************************************
** ALPHAN
ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789
** CPY@
(c) Finastra International Limited 2001
