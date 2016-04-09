     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Process CAR migration DEALSDB')               *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SMU00004 - German Feature migration for DEALSDB              *
      *                                                               *
      *  Called By: SMUC00000                                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2009            *
      *                                                               *
      *  Last Amend No. CGL165             Date 15Feb17               *
      *  Prev Amend No. CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CSM011  *CREATE    Date 08May09               *
      *                 XXXXXX             Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CSM011 - Midas SM Process CAR migration                      *
      *                                                               *
      *****************************************************************
     FSMUGF04PD IF   E             DISK
      * Template file for FXDEALX0
     FDEALALL   UF   E             DISK    IGNORE(DEALSDAF:DEALSDCF:DEALSDDF)
     F                                     IGNORE(DEALSDEF:DEALSDFF:DEALSDGF)
      *
      /EJECT
      *
     D Recursive       S              1
      *
      * Read template file.
     C     1             SETLL     SMUGF04PD
     C                   READ      SMUGF04PD
     C                   DOW       NOT %EOF
      *
     C     XDN38         CHAIN     DEALSDBF
     C                   IF        %FOUND
     C                   EVAL      FGREIN = XRECP
     C                   UPDATE    DEALSDBF
     C                   ENDIF
      *
     C                   READ      SMUGF04PD
     C                   ENDDO
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive = *blanks
     C                   EVAL      Recursive = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
