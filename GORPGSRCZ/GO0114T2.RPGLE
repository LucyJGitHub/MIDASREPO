     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GO Global Upd of CUSD -TskSplWritetoDriver')     *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GO0114T2 - Midas GO Global Update of Customer Details        *
      *             Task Split write records to driver                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. CGP017  *CREATE    Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGP017 - Global Layer - GOC0100 Task Split                   *
      *                                                               *
      *****************************************************************
 
     FSDCUIXPD  UF A E           K DISK    COMMIT
     F                                     INFSR(*PSSR)
 
     FSDCUDVPD  O    E           K DISK    COMMIT
     F                                     INFSR(*PSSR)
 
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
 
     D INPSSR                          N
     D PRecTot         S              7  0
     D PRecCnt         S             10  0
     D PRtCode         S              3
 
      ** Main Processing
 
     C     *ENTRY        PLIST
     C                   PARM                    PRecTot
     C                   PARM                    PRecCnt
     C                   PARM                    PRtCode
 
     C                   EXSR      INIT
     C                   EXSR      TSPLIT
     C                   EXSR      CLOSEDOWN
 
      *****************************************************************
      *                                                               *
      *  TSPLIT - Update Index File to reflect last record processed. *
      *  Called by: Main Processing                                   *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
     C     TSPLIT        BEGSR
 
      ** Update (or write to) index file to reflect last
      ** account processed.
 
     C                   IF        %EOF
 
     C                   EVAL      GLFRRN = 1
     C                   IF        PRecTot < PRecCnt
     C                   EVAL      GLTRRN = PRecTot
     C                   ELSE
     C                   EVAL      GLTRRN = PRecCnt
     C                   ENDIF
 
     C                   WRITE     SDCUIXF
 
     C                   ELSE
 
     C                   EVAL      GLFRRN = GLFRRN + PRecTot
     C                   EVAL      GLTRRN = (PRecTot + GLFRRN) - 1
     C                   IF        GLTRRN > PRecCnt
     C                   EVAL      GLTRRN = PRecCnt
     C                   ENDIF
     C                   UPDATE    SDCUIXF
 
     C                   ENDIF
 
     C                   EVAL      GLFERN = GLFRRN
     C                   EVAL      GLTERN = GLTRRN
     C                   WRITE     SDCUDVF
 
     C                   COMMIT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  INIT - Read index file                                       *
      *  Called by: Main Processing                                   *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
     C     INIT          BEGSR
 
      ** Read the index record to determine start position on
      ** accounts master.
 
     C                   READ      SDCUIXPD
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CLOSEDOWN - Close program.                                   *
      *  Called by: Main Program                                      *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
     C     CLOSEDOWN     BEGSR
 
     C                   IF        GLTRRN = PRecCnt
     C                   EVAL      PRtCode = 'EOF'
     C                   ENDIF
     C                   EVAL      *INLR       = *ON
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
 
     C                   IF        NOT INPSSR
     C                   EVAL      INPSSR      = *ON
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INLR       = *ON
     C                   EVAL      *INU7       = *ON
     C                   EVAL      *INU8       = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
