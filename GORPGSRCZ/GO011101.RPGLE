     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Generated Code Amended for TS processing GLACNTQD')    *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GO011101 - Bulk Update of Global File GZGLACNTQD             *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CRE095             Date 25Apr14               *
      *                 CGL165             Date 17Feb15               *
      *                 CRE090             Date 14Feb14               *
      *                 MD023783           Date 25Nov13               *
      *                 CGP017  *CREATE    Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE095 - Rate Fixing for RE Accounts (Recompile)             *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CRE090 - Delay Capitalisation of Interest (Recompile)        *
      *  MD023783 - GOC011101 01022 Decimal data error occurred       *
      *             (Recompile)                                       *
      *  CGP017 - Global Layer - GOC0100 Task Split                   *
      *                                                               *
      *****************************************************************
     FGLACNTQD  IF   E             DISK    RECNO(WkRrn)
     F                                     INFSR(*PSSR)
     FGLAQDVPD  IF   E           K DISK
     F                                     INFSR(*PSSR)
 
     D Z_GLACNTL3    E DS                  EXTNAME(GLACNTQD)
     D G_GLACNTL3    E DS                  EXTNAME(GZGLACNTQD)
     D                                     PREFIX(G_)
 
     D WRun            S              1
     D WkRrn           S              9  0
 
      ** Main Process
 
     C                   Z-ADD     0             WkRrn
     C                   READ      GLAQDVPD
     C     GLFERN        SETLL     GLACNTQD
     C                   READ      GLACNTQD
 
     C                   DOW       NOT %EOF(GLACNTQD) AND WkRrn <= GLTERN
     C                   EVAL      G_GLACNTL3 = Z_GLACNTL3
B    C                   EVAL      G_F1BRCA = F1BRCA
     C                   EVAL      I#BFAF = 'A'
     C                   EXSR      UPGLBF
     C                   READ      GLACNTQD
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
     C                   EVAL      I#BIMG = G_GLACNTL3
     C                   EVAL      I#AIMG = G_GLACNTL3
     C/COPY GPCPYSRCG,GPGLACNTQD
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initial Processing                                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    I_ZONE           10
 
     C                   MOVEL     *BLANK        I#ERMS           50
     C                   CLEAR                   Z_GLACNTL3
     C                   CLEAR                   G_GLACNTL3
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
