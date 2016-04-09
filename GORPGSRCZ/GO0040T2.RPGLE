     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GO Update Global TRAP - Feeder')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GO0040T2 - Midas GO Update Global TRAP - Feeder              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. AR1097467A *CREATE Date 11Apr13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1097467A - Expected 15% COB run optimization not met       *
      *                                                               *
      *****************************************************************
 
     FGOTAPSPD  IF   E           K DISK    INFSR( *PSSR ) USROPN
      ** Customer numbers and their record counts
 
     FGOTAPDPD  O    E             DISK    INFSR( *PSSR ) USROPN
     F                                     RENAME( GOTAPDD0 : DRIVERFL )
      ** Driver File
 
     FGOTAPIPD  UF A E             DISK    INFSR( *PSSR )
     F                                     RENAME( GOTAPID0 : INDEXFL )
      ** Index File
 
      ** Work Variables
 
     D True            C                   CONST( *ON )
     D False           C                   CONST( *OFF )
     D PSSRDone        S               N   INZ
     D BatchFull       S               N   INZ
     D EmptyFile       S               N   INZ
     D NRcdP           S             13P 0 INZ
 
      ** Entry Parameters
 
     D RcdPerSubtask   S              7P 0
     D ReturnCode      S              3A
 
      *****************************************************************
      *                                                               *
      * MAIN PROCESSING                                               *
      *                                                               *
      *****************************************************************
 
      ** Reinitialize work fields
 
     C                   EVAL      NRcdP = 0
     C                   EVAL      BatchFull = False
 
      ** Check where to get the first customer number for this batch
 
     C     1             SETLL     GOTAPIPD
     C                   READ      GOTAPIPD
 
     C                   IF        %EOF( GOTAPIPD )
     C     *LOVAL        SETLL     GOTAPSPD
     C                   ELSE
     C     IPCUSD        SETGT     GOTAPSPD
     C                   ENDIF
 
      ** Start getting the first and last customer numbers
      ** Set indicator if master file (GOWTRAPPD) is empty or not
 
     C                   READ      GOTAPSPD
     C                   DOW       NOT %EOF( GOTAPSPD )
 
     C                   EVAL      EmptyFile = False
 
     C                   IF        BatchFull
     C                   LEAVE
     C                   ENDIF
 
      ** If first record for this batch was read, set the first
      ** customer number for this batch
 
     C                   IF        NRcdP = 0
     C                   EVAL      DSCUSD = SCUSD
     C                   EVAL      DECUSD = SCUSD
     C                   ENDIF
 
      ** Update number of records processed
 
     C                   EVAL      NRcdP = NRcdP + SNRCD
 
      ** Exit loop if number of records processed has reached the
      ** record limit per subtask, otherwise set the last customer
      ** number for this batch
 
     C                   IF        NRcdP > RcdPerSubtask
     C                   EVAL      BatchFull = True
     C                   ELSE
     C                   EVAL      DECUSD = SCUSD
     C                   ENDIF
 
     C                   READ      GOTAPSPD
     C                   ENDDO
 
     C                   SELECT
 
      ** When there are records processed
 
     C                   WHEN      NRcdP > 0
     C                   OPEN      GOTAPDPD
     C                   WRITE     DRIVERFL
     C                   CLOSE     GOTAPDPD
 
     C                   EVAL      IPCUSD = DECUSD
     C                   IF        %EOF( GOTAPIPD )
     C                   WRITE     INDEXFL
     C                   ELSE
     C                   UPDATE    INDEXFL
     C                   ENDIF
 
      ** When GOTAPSPD file is empty to begin with
 
     C                   WHEN      EmptyFile
     C                   EVAL      ReturnCode = 'NRF'
 
      ** When there are no records left to process
 
     C                   OTHER
     C                   CLOSE     GOTAPSPD
     C                   EVAL      ReturnCode = 'EOF'
     C                   EVAL      *INLR = *ON
 
     C                   ENDSL
 
     C                   RETURN
 
      *****************************************************************
      *                                                               *
      * INITIAL ROUTINE                                               *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    RcdPerSubtask
     C                   PARM                    ReturnCode
 
      ** Assume that GOTAPSPD is empty; to be changed later if not
 
     C                   EVAL      EmptyFile = True
     C                   OPEN      GOTAPSPD
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * Exceptional Error Routine                                     *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   IF        NOT PSSRDone
     C                   EVAL      PSSRDone = True
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
     C                   ENDIF
 
     C                   ENDSR
