     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GO Global Update RE Commision TS Server')        *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing                                    *
      *                                                               *
      *  GO0112T2 - Global Update RE Commision TS Server              *
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
     FRECOMIPD  UF A E             DISK    COMMIT
     F                                     INFSR(*PSSR)
      ** Retail Commisions Index File
 
     FRECOMDPD  O    E             DISK    COMMIT
     F                                     INFSR(*PSSR)
      ** Retail Commisions Driver File
      *
      ** Variables/Constants/Data Structures
      *
     D RecPerSubTask   S              7P 0
     D TotalRecCount   S             10P 0
     D ReturnCode      S              3A
     D RunBefore       S              1N   INZ
     D True            C                   CONST(*ON)
     D False           C                   CONST(*OFF)
 
      /COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
      /EJECT
      *****************************************************************
      *                                                               *
      * MAIN ROUTINE                                                  *
      *                                                               *
      *****************************************************************
 
      ** Update (or write to) index file to
      ** reflect last account processed.
 
     C     1             SETLL     RECOMIPD
     C                   READ      RECOMIPD
 
      ** If no records yet in index, write
 
     C                   IF        %EOF(RECOMIPD)
 
     C                   EVAL      RCFRRN = 1
 
     C                   IF        RecPerSubTask < TotalRecCount
     C                   EVAL      RCTRRN = RecPerSubTask
     C                   ELSE
     C                   EVAL      RCTRRN = TotalRecCount
     C                   ENDIF
 
     C                   WRITE     RECOMIP0
     C                   ENDIF
 
      ** else, calculate from and to RRN then update
 
     C                   IF        NOT %EOF(RECOMIPD)
     C                   EVAL      RCFRRN = RCFRRN + RecPerSubTask
     C                   EVAL      RCTRRN = RecPerSubTask + RCFRRN - 1
 
     C                   IF        RCTRRN > TotalRecCount
     C                   EVAL      RCTRRN = TotalRecCount
     C                   ENDIF
 
     C                   UPDATE    RECOMIP0
     C                   ENDIF
 
      ** Write from and to RRN to driver file
 
     C                   WRITE     RECOMDP0
 
     C                   COMMIT
 
      ** If all records processed then close program
 
     C                   EXSR      CLOSEDOWN
     C                   RETURN
      *****************************************************************
 
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initialisation Routine                               *
      * Called By: First Program Call                                 *
      * Calls : None                                                  *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    RecPerSubTask
     C                   PARM                    TotalRecCount
     C                   PARM                    ReturnCode
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * CLOSEDOWN - Closes program and returns EOF code when all RRN  *
      *             of records have been sent                         *
      * Called By : Main Routine                                      *
      * Calls : None                                                  *
      *                                                               *
      *****************************************************************
 
     C     CLOSEDOWN     BEGSR
 
     C                   IF        RCTRRN = TotalRecCount
     C                   EVAL      ReturnCode = 'EOF'
     C                   ENDIF
 
     C                   EVAL      *INLR       = *ON
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR - Program Error Handler Subroutine                      *
      * Called By : Program Exception Errors                          *
      * Calls : None                                                  *
      *                                                               *
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
