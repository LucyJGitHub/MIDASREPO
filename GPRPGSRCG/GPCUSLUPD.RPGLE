     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GP Global Customer Details Updater')             *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPCUSLUPD - Midas GP Global Customer Details Updater         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Prev Amend No. CGP017  *CREATE    Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGP017 - Global Layer - GOC0100 Task Split                   *
      *                                                               *
      *****************************************************************
     FGPGLCUSLL1UF A E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(G_)
 
     D Z_GPGLCUSL    E DS                  EXTNAME(GPGLCUSL)
     D G_GPGLCUSL    E DS                  EXTNAME(GPGLCUSL)
     D                                     PREFIX(G_)
 
      ** ENTRY PARAMETERS
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
     C                   PARM                    I#Delete          1
     C                   PARM                    I#RecordIMAGE 32000
 
     C                   EVAL      Z_GPGLCUSL = I#RecordIMAGE
 
     C     K_GPGLCUSL    CHAIN     GPGLCUSLL1
 
      ** Delete
 
     C                   IF        I#Delete = 'Y'
     C                             AND %FOUND(GPGLCUSLL1)
     C                   DELETE    GPGLCUSLL1
     C                   ELSE
 
      ** 'UPDATE or WRITE'
 
     C                   CLEAR                   G_GPGLCUSL
     C                   EVAL      G_GPGLCUSL = Z_GPGLCUSL
 
     C                   IF        %FOUND(GPGLCUSLL1)
     C                   UPDATE    GPGLCUSL
     C                   ELSE
     C                   WRITE     GPGLCUSL
     C                   ENDIF
     C                   ENDIF
 
     C                   RETURN
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      *                                                               *
      * *INZSR - Initial subroutine called automatically at program   *
      *          start                                                *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     K_GPGLCUSL    KLIST
     C                   KFLD                    CGBRCD
     C                   KFLD                    CGCNUM
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *                                                               *
      * *PSSR  --- Abnormal Error Conditions                          *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   EVAL      I#RTCD = '*ERROR'
     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   EVAL      *INLR = '1'
     C                   DUMP
 
     C                   IF        I#ERMS = *BLANK
     C                   EVAL      I#ERMS = 'UNEXPECTED ERROR'
     C                   ENDIF
 
     C                   RETURN
     C                   ENDSR
      *****************************************************************
