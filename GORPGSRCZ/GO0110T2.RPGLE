     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GO Global Upd of Acc Ext-Tsk Spl wrt to drvr')   *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GO0110T2 - Global Update of Accounts Extension Task Split    *
      *             write records to driver                           *
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
 
     FACBXIXPD  UF A E           K DISK    COMMIT
     F                                     INFSR(*PSSR)
 
     FACBXDVPD  O    E           K DISK    COMMIT
     F                                     INFSR(*PSSR)
 
     D RecTot          S              7  0
     D Reccnt          S             10  0
     D RtCode          S              3
     D WRun            S              1A
 
     C     *ENTRY        PLIST
     C                   PARM                    RecTot
     C                   PARM                    Reccnt
     C                   PARM                    RtCode
 
     C                   EXSR      INIT
 
     C                   EXSR      TSPLIT
 
     C                   EXSR      CLSDWN
 
      *****************************************************************
      *                                                               *
      *  TSPLIT - Update Index File to reflect last account           *
      *           processed.                                          *
      *                                                               *
      *****************************************************************
     C     TSPLIT        BEGSR
 
     C                   IF        %EOF(ACBXIXPD)
     C                   EVAL      GLFRRN = 1
     C                   IF        RecTot < Reccnt
     C                   EVAL      GLTRRN = RecTot
     C                   ELSE
     C                   EVAL      GLTRRN = Reccnt
     C                   ENDIF
     C                   WRITE     ACBXIXF
     C                   ELSE
     C                   EVAL      GLFRRN = GLFRRN + Rectot
     C                   EVAL      GLTRRN = (Rectot + GLFRRN) - 1
     C                   IF        GLTRRN > Reccnt
     C                   EVAL      GLTRRN = Reccnt
     C                   ENDIF
     C                   UPDATE    ACBXIXF
     C                   ENDIF
 
     C                   EVAL      GLFERN = GLFRRN
     C                   EVAL      GLTERN = GLTRRN
     C                   WRITE     ACBXDVF
 
     C                   COMMIT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  INIT - Read Index file                                       *
      *                                                               *
      *****************************************************************
     C     INIT          BEGSR
 
      ** Read the index record to determine start position
      ** on accounts master.
 
     C                   READ      ACBXIXPD
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CLSDWN - Close Program                                       *
      *                                                               *
      *****************************************************************
     C     CLSDWN        BEGSR
 
     C                   IF        GLTRRN = Reccnt
     C                   EVAL      RtCode = 'EOF'
     C                   ENDIF
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
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
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
