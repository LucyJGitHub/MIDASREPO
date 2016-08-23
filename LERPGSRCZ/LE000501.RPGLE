     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE Get End Time for PDP Component to fail')      *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000501 - Midas LE Get End Time for PDP Component to fail   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. AR1095331          Date 07Apr13               *
      *  Prev Amend No. AR1085742*CREATE   Date 06Jan13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1095331 - BFTC Security Issues                             *
      *  AR1085742 - Recovery handling when PDP components loop due   *
      *              to database connection issues                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      **------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------
 
      ** +--------------------------------------+
      **   Manually included D-specs            +
      **   =========================            +
      ** +--------------------------------------+
 
     D*StartTime       S               T                                                   AR1095331
     D*EndTime         S               T                                                   AR1095331
     D StartTime       S               Z                                                   AR1095331
     D EndTime         S               Z                                                   AR1095331
     D WTime           S             20S 0                                                 AR1095331
     D WaitTime        S             20A                                                   AR1095331
 
     D*ExitTime1       DS             8                                                    AR1095331
     D**ExitHH1*               1      2A                                                   AR1095331
     D**ExitMM1*               4      5A                                                   AR1095331
     D**ExitSS1*               7      8A                                                   AR1095331
 
     D*ExitTime2       DS             6                                                    AR1095331
     D**ExitHH2*               1      2A                                                   AR1095331
     D**ExitMM2*               3      4A                                                   AR1095331
     D**ExitSS2*               5      6A                                                   AR1095331
 
     D PRetCode        S              7A
     D PWaitTime       S              5A
     D PW              S              5S 0
     D POP01           S             20A
     D PVL01           S            200A
     D POP02           S             20A
     D PVL02           S            200A
     D POP03           S             20A
     D PVL03           S            200A
     D POP04           S             20A
     D PVL04           S            200A
     D POP05           S             20A
     D PVL05           S            200A
     D POP06           S             20A
     D PVL06           S            200A
     D POP07           S             20A
     D PVL07           S            200A
     D POP08           S             20A
     D PVL08           S            200A
     D POP09           S             20A
     D PVL09           S            200A
     D POP10           S             20A
     D PVL10           S            200A
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
     C                   TIME                    StartTime
      *
     C     StartTime     ADDDUR    PW:*Seconds   EndTime
      *                                                                                    AR1095331
     C     *ISO          MOVEL     EndTime       WTime                                     AR1095331
     C                   MOVEL     WTime         WaitTime                                  AR1095331
      *
     C**********         EVAL      ExitTime1 = %Char(EndTime: *HMS)                        AR1095331
      *
     C**********         MOVEL     ExitHH1       ExitHH2                                   AR1095331
     C**********         MOVEL     ExitMM1       ExitMM2                                   AR1095331
     C**********         MOVEL     ExitSS1       ExitSS2                                   AR1095331
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C**********         PARM                    ExitTime2                                 AR1095331
     C                   PARM                    WaitTime                                  AR1095331
      *
     C                   EVAL      POP01 = 'PDCLJavaRespWait'
      *
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM                    POP01
     C                   PARM      *BLANKS       PVL01
     C                   PARM      *BLANKS       POP02
     C                   PARM      *BLANKS       PVL02
     C                   PARM      *BLANKS       POP03
     C                   PARM      *BLANKS       PVL03
     C                   PARM      *BLANKS       POP04
     C                   PARM      *BLANKS       PVL04
     C                   PARM      *BLANKS       POP05
     C                   PARM      *BLANKS       PVL05
     C                   PARM      *BLANKS       POP06
     C                   PARM      *BLANKS       PVL06
     C                   PARM      *BLANKS       POP07
     C                   PARM      *BLANKS       PVL07
     C                   PARM      *BLANKS       POP08
     C                   PARM      *BLANKS       PVL08
     C                   PARM      *BLANKS       POP09
     C                   PARM      *BLANKS       PVL09
     C                   PARM      *BLANKS       POP10
     C                   PARM      *BLANKS       PVL10
      *
     C                   IF        PRetCode <>  *BLANKS
     C                   MOVEL     'SDSVALPD'    DBFILE
     C                   Z-ADD     1             DBASE                U7U8
     C                   MOVEL     POP01         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      PWaitTime= PVL01
     C                   MOVEL     PWaitTime     PW
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: None                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   END
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2013
