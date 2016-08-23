     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*S*D****RPGBASEBND****************************************************                       CAP070
/*STD *  RPGBASEMOD                                                   *                       CAP070
/*EXI *  TEXT('Midas LE Calculate share')
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE2024 - Calculate Share (Amount/Percentage)                 *
      *                                                               *
      *  Function:                                                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Last Amend No. CAP070             Date 04Mar02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Prev Amend No. CLE004  *CREATE    Date 140297                *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP070 - Conversion of LE inputs into modular structure to   *
      *           use as APIs.                                        *
      *  CLE004 - Customer Lending Enhancements - Syndications.       *
      *                                                               *
      *****************************************************************
      *
      **
     C     *ENTRY        PLIST
      *  Facility amount (Prime facility)
     C                   PARM                    P#PAMT           13
      *  Share Percentage
     C                   PARM                    P#SHPC           15
      *  Facility amount
     C                   PARM                    P#FAMT           13
      *  Share type
     C                   PARM                    P#SHTP            1
      *
      ** Move int numeric fields
     C                   MOVE      P#SHPC        W#SHPC           1512
     C                   MOVE      P#FAMT        W#FAMT           13 0
     C                   MOVE      P#PAMT        W#PAMT           13 0
      *
      **
     C     P#SHTP        IFEQ      'P'
      *
      **  Calculate amount
     C     W#PAMT        MULT      W#SHPC        W#WRK1           2814
     C     W#WRK1        DIV       100           W#WRK1           2814
     C                   Z-ADD(H)  W#WRK1        W#WRK2           14 0
     C                   MOVEL     W#WRK2        W#WRK3           14
     C                   MOVEL     W#WRK3        W#1STC            1
     C     W#1STC        IFNE      '0'
     C                   MOVEL     W#WRK3        W#WRK4           14 1
     C                   Z-ADD(H)  W#WRK4        W#FAMT
     C                   ELSE
     C                   MOVE      W#WRK3        W#FAMT
     C                   ENDIF
     C                   MOVEL     W#FAMT        P#FAMT
      *
      **  Calculate Percentage
     C                   ELSE
      *
     C     W#FAMT        MULT      100           W#WRK5           15 0
     C     W#WRK5        DIV(H)    W#PAMT        W#WRK6           1512
     C                   MOVEL     W#WRK6        P#SHPC
      *
     C                   ENDIF
      *                                                               *
     C                   SETON                                        LR
     C                   RETURN
      *                                                               *
