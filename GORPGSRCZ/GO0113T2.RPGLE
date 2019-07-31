     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GO Global Upd RE Int&Chg-Tsk Spl wrt to drv')    *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GO0113T2 - Global Update of RE Interest and Charge Task      *
      *             Split write records to driver                     *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGP017  *CREATE    Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGP017 - Global Layer - GOC0100 Task Split                   *
      *                                                               *
      *****************************************************************
 
     FREIAIXPD  UF A E           K DISK    COMMIT
     F                                     INFSR(*PSSR)
 
     FREIADVPD  O    E           K DISK    COMMIT
     F                                     INFSR(*PSSR)
 
     D RECTOT          S              7  0
     D RECCNT          S             10  0
     D RTCODE          S              3
     D WRUN            S              1A
 
     C     *ENTRY        PLIST
     C                   PARM                    RECTOT
     C                   PARM                    RECCNT
     C                   PARM                    RTCODE
 
     C                   EXSR      INIT
 
     C                   EXSR      TSPLIT
 
     C                   EXSR      CLSDWN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  TSPLIT - Update Index File to reflect last account           *
      *           processed.                                          *
      *                                                               *
      *****************************************************************
     C     TSPLIT        BEGSR
 
     C                   IF        %EOF(REIAIXPD)
     C                   EVAL      GLFRRN = 1
     C                   IF        RECTOT < RECCNT
     C                   EVAL      GLTRRN = RECTOT
     C                   ELSE
     C                   EVAL      GLTRRN = RECCNT
     C                   ENDIF
     C                   WRITE     REIAIXF
     C                   ELSE
     C                   EVAL      GLFRRN = GLFRRN + RECTOT
     C                   EVAL      GLTRRN = (RECTOT + GLFRRN) - 1
     C                   IF        GLTRRN > RECCNT
     C                   EVAL      GLTRRN = RECCNT
     C                   ENDIF
     C                   UPDATE    REIAIXF
     C                   ENDIF
 
     C                   EVAL      GLFERN = GLFRRN
     C                   EVAL      GLTERN = GLTRRN
     C                   WRITE     REIADVF
 
     C                   COMMIT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  INIT - Read index file                                       *
      *                                                               *
      *****************************************************************
     C     INIT          BEGSR
 
      ** Read the index record to determine start position
      ** on accounts master.
 
     C                   READ      REIAIXPD
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CLSDWN - Close program                                       *
      *                                                               *
      *****************************************************************
     C     CLSDWN        BEGSR
 
     C                   IF        GLTRRN = RECCNT
     C                   EVAL      RTCODE = 'EOF'
     C                   ENDIF
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        WRUN = *BLANK
     C                   EVAL      WRUN = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
