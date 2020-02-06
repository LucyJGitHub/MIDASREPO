     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2009')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas RE GLRGSUPD Initialisation')
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE4038 - Midas RE GLRGSUPD Initialisation                    *
      *                                                               *
      *  (c) Finastra International Limited 2009                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. CRE015  *CREATE    Date 18Dec09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE015 - Retail Term and Notice Accounts                     *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas GL Sundry Postings Register File
     FGLRGSUPD  UF A E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
 
     D WSARN           S              6    INZ('CRE015')
     D @RUN            S              1
 
      *****************************************************************
      * MAIN PROCESSING
      *****************************************************************
 
     C     WSARN         CHAIN     GLRGSUPD
 
     C                   IF        NOT %FOUND(GLRGSUPD)
 
     C                   EVAL      E1SARN = 'CRE015'
     C                   EVAL      E1POST = 'Y'
     C                   EVAL      E1STA1 = *BLANKS
     C                   EVAL      E1ANWD = 'Y'
     C                   EVAL      E1STA2 = *BLANKS
     C                   EVAL      E1PROJ = 'N'
     C                   EVAL      E1STA3 = 'C'
     C                   WRITE     GLRGSUD0
 
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program Exception Subroutine.                        *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C     @RUN          IFEQ      *BLANK
 
     C                   MOVE      'Y'           @RUN
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   DUMP
 
     C                   ENDIF
 
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
** CPY@
(c) Finastra International Limited 2009
