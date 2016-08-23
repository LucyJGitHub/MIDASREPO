     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Generated Code amended for TS processing REIACD')      *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GO011301 - Bulk Update of Global File GZREIACD               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. CGP017  *CREATE    Date 06AUg12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGP017 - Global Layer - GOC0100 Task Split                   *
      *                                                               *
      *****************************************************************
 
     FREIACD    IF   E             DISK    RECNO(WKRRN)
     F                                     INFSR(*PSSR)
     FREIADVPD  IF   E           K DISK
     F                                     INFSR(*PSSR)
 
     D Z_REIAC       E DS                  EXTNAME(REIACD    )
     D G_REIAC       E DS                  EXTNAME(GZREIACD  )
     D                                     PREFIX(G_)
 
     D WKRRN           S              9S 0
     D RUNBEFORE       S              1A
     D I_ZONE          S             10A
     D I#ERMS          S             50A
 
      ** Main processing
 
     C                   Z-ADD     0             WKRRN
     C                   READ      REIADVPD
     C     GLFERN        SETLL     REIACD
     C                   READ      REIACD
     C                   DOW       NOT %EOF(REIACD)
     C                             AND WKRRN <= GLTERN
     C                   MOVEL     Z_REIAC       G_REIAC
B    C                   EVAL      G_BRCA = BRCA
     C                   EVAL      I#BFAF = 'A'
 
     C                   EXSR      UPGLBF
 
     C                   READ      REIACD
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  UPGLBF - Update Global File                                  *
      *                                                               *
      *****************************************************************
     C     UPGLBF        BEGSR
     C                   EVAL      I#ZONE = I_ZONE
     C                   EVAL      I#TRAP = 'N'
     C                   EVAL      I#BIMG = G_REIAC
     C                   EVAL      I#AIMG = G_REIAC
     C/COPY GPCPYSRCG,GPREIACD
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initial subroutine called automatically at program  *
      *           start                                               *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    I_ZONE
 
     C                   EVAL      I#ERMS = *BLANK
     C                   CLEAR                   Z_REIAC
     C                   CLEAR                   G_REIAC
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception error routine                      *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        RUNBEFORE = *BLANKS
     C                   EVAL      RUNBEFORE = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   RETURN
 
     C                   ENDSR
      *********************************************************************
