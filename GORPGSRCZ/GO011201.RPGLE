     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Bulk Sync Global Layer GZRECOMD')             *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing                                    *
      *                                                               *
      *  GO011201 - Midas GO Bulk Sync Global Layer GZRECOMD          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. CGP017   *CREATE   Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGP017 - Global Layer - GOC0100 Task Split                   *
      *                                                               *
      *****************************************************************
      *
      ** File Declarations
      *
     FRECOMD    IF   E             DISK    RECNO(WKRRN)
     F                                     INFSR(*PSSR)
      ** Retail Commisions File
 
     FRECOMDPD  IF   E             DISK    USROPN
     F                                     INFSR(*PSSR)
      ** Task Split Driver File
      *
      ** Variables/Constants/Data Structure Declarations
      *
     D WKRRN           S              9P 0 Inz
     D RunBefore       S              1N   Inz
     D I#ERMS          S             50A   Inz
     D True            C                   CONST(*ON)
     D False           C                   CONST(*OFF)
 
      /COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
 
     D Z_RECOM       E DS                  EXTNAME(RECOMD)
      ** Zonal RECOM Data Structure
 
     D G_RECOM       E DS                  EXTNAME(RECOMD)
     D                                     PREFIX(G_)
      ** Global RECOM Data Structure
 
      /EJECT
      *****************************************************************
      *                                                               *
      * MAIN ROUTINE                                                  *
      *                                                               *
      *****************************************************************
     C                   EVAL      WKRRN = 0
 
     C                   OPEN      RECOMDPD
 
     C     1             SETLL     RECOMDPD
     C                   READ      RECOMDPD
 
     C     RCFRRN        SETLL     RECOMD
     C                   READ      RECOMD
 
     C                   DOW       NOT %EOF(RECOMD) AND WKRRN <= RCTRRN
     C                   EVAL      G_RECOM = Z_RECOM
     C                   EVAL      G_BRCA = BRCA
     C                   EVAL      I#BFAF = 'A'
     C                   EXSR      UPD_GLOBFILE
     C                   READ      RECOMD
     C                   ENDDO
 
     C                   CLOSE     RECOMDPD
 
     C                   RETURN
 
      /EJECT
      *****************************************************************
      *                                                               *
      * UPD_GLOBFILE - Calls GPRECOMD program to update global file   *
      * Called By: Main Routine                                       *
      * Calls: GPRECOMD                                               *
      *                                                               *
      *****************************************************************
      *
     C     UPD_GLOBFILE  BEGSR
     C                   EVAL      I#ZONE = I_ZONE
     C                   EVAL      I#TRAP = 'N'
     C                   EVAL      I#BIMG = G_RECOM
     C                   EVAL      I#AIMG = G_RECOM
      /COPY GPCPYSRCG,GPRECOMD
     C                   ENDSR
      *****************************************************************
 
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initialisation routine                               *
      * Called By: Automatically at first program call                *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    I_ZONE           10
 
     C                   EVAL      I#ERMS = *BLANKS
     C                   CLEAR                   Z_RECOM
     C                   CLEAR                   G_RECOM
     C                   ENDSR
      *****************************************************************
 
      /EJECT
      *****************************************************************
      * *PSSR  --- ABNORMAL ERROR CONDITIONS
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        NOT RunBefore
     C                   EVAL      RunBefore = True
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
 
     C                   RETURN
 
     C                   ENDSR
      *********************************************************************
