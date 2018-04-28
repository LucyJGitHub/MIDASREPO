     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Cross ccy swaps extra settlements inst.')
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Module                                       *
      *                                                               *
      *  IRVXSET01 - Cross Ccy Swaps Extra Settlements Instructions   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Last Amend No. CIR003  *CREATE    Date 12Sep00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CIR003 - Principal Exchange on Cross Currencies IRS          *
      *                                                               *
      *****************************************************************
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
     D/COPY ZACPYSRC,PSDS
 
     D/COPY ZACPYSRC,ERR_ARRAYS
 
     D PPrEx           DS
     D  WVDIN                  1      1
     D  WININ                  2      2
     D  WMTIN                  3      3
 
     D PPrOk           DS
     D  WVDOK                  1      1
     D  WINOK                  2      2
     D  WMTOK                  3      3
 
     D Idx             S              2  0
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
     C                   Z-ADD     0             Idx
      *
      ** Validate 'VALUE DATE'
      *
     C     WVDIN         IFNE      'Y'
     C     WVDIN         ANDNE     'N'
     C                   ADD       1             Idx
     C                   MOVE      'N'           WVDOK
     C                   MOVE      'MMM0791'     MsgIdArr(Idx)
     C                   ENDIF
      *
     C     WVDIN         IFEQ      'Y'
     C     PVDEI         IFNE      'Y'
     C     PPDEI         ANDNE     'Y'
     C                   ADD       1             Idx
     C                   MOVE      'N'           WVDOK
     C                   MOVE      'MMM0792'     MsgIdArr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
      ** Validate 'INTEREST DATE'
      *
     C     WININ         IFNE      'Y'
     C     WININ         ANDNE     'N'
     C                   ADD       1             Idx
     C                   MOVE      'N'           WINOK
     C                   MOVE      'MMM0793'     MsgIdArr(Idx)
     C                   ENDIF
      *
      ** Validate 'MATURITY DATE'
      *
     C     WMTIN         IFNE      'Y'
     C     WMTIN         ANDNE     'N'
     C                   ADD       1             Idx
     C                   MOVE      'N'           WMTOK
     C                   MOVE      'MMM0794'     MsgIdArr(Idx)
     C                   ENDIF
      *
     C     WMTIN         IFEQ      'Y'
     C     PMDEI         IFNE      'Y'
     C     PPDEI         ANDNE     'Y'
     C                   ADD       1             Idx
     C                   MOVE      'N'           WMTOK
     C                   MOVE      'MMM0795'     MsgIdArr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * #INIT  - Initial Routine                                      *
      *                                                               *
      *****************************************************************
      *
     C     #INIT         BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    PVDEI             1
     C                   PARM                    PMDEI             1
     C                   PARM                    PPDEI             1
     C                   PARM                    PPrEx
     C                   PARM                    PPrOK
     C                   PARM                    MsgIdArr
      *
     C                   ENDSR
      *
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
