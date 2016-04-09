     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GO GPWTRAPPD Housekeeping - Write Drvr File')    *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing                                    *
      *                                                               *
      *  GO2110T2 - GPWTRAPPD Housekeeping - Write Driver File        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD023876A          Date 06Jan14               *
      *  Prev Amend No. MD023876 *CREATE   Date 14Nov13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD023876A - Wrong location of task split objects             *
      *  MD023876 - GOC210000 Performance Issues                      *
      *                                                               *
      *****************************************************************
      *
     F***GPWTRPCPD IF   E           K DISK    RENAME(GPWTPCP0:CONTROLFL)                   MD023876A
     FGOWTRPCPD IF   E           K DISK    RENAME(GOWTPCP0:CONTROLFL)                      MD023876A
     F                                     BLOCK(*YES)
     F                                     INFSR(*PSSR)
     F***GPWTRPIPD UF A E             DISK    RENAME(GPWTPIP0:INDEXFL)                     MD023876A
     FGOWTRPIPD UF A E             DISK    RENAME(GOWTPIP0:INDEXFL)                        MD023876A
     F                                     INFSR(*PSSR)
     F                                     COMMIT
     F***GPWTRPDPD O    E             DISK    RENAME(GPWTPDP0:DRIVERFL)                    MD023876A
     FGOWTRPDPD O    E             DISK    RENAME(GOWTPDP0:DRIVERFL)                       MD023876A
     F                                     INFSR(*PSSR)
     F                                     COMMIT
     F                                     USROPN
      /EJECT
      *****************************************************************
      *                                                               *
      *              DECLARATIONS - VARIABLES/CONSTANTS               *
      *                                                               *
      *****************************************************************
 
      ** Parameters
 
     D RecPerSubtask   S              7P 0
     D ReturnCode      S              3A
 
      ** Work Variables
 
     D TotCount        S             16P 0 INZ
     D PSSRDone        S              1N   INZ(False)
     D IdxFileEmpty    S              1N   INZ(True)
 
     D True            C                   CONST(*ON)
     D False           C                   CONST(*OFF)
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *                       MAIN PROCESSING                         *
      *                                                               *
      *****************************************************************
 
      ** Get last batch processed, otherwise start at the first record
 
     C*****1****         CHAIN     GPWTRPIPD                                               MD023876A
     C     1             CHAIN     GOWTRPIPD                                               MD023876A
     C**********         IF        %FOUND(GPWTRPIPD)                                       MD023876A
     C                   IF        %FOUND(GOWTRPIPD)                                       MD023876A
     C*****LCTID         SETGT     GPWTRPCPD                                               MD023876A
     C     LCTID         SETGT     GOWTRPCPD                                               MD023876A
     C                   EVAL      IdxFileEmpty = False
     C                   ELSE
     C******START        SETLL     GPWTRPCPD                                               MD023876A
     C     *START        SETLL     GOWTRPCPD                                               MD023876A
     C                   EVAL      IdxFileEmpty = True
     C                   ENDIF
 
     C                   EVAL      ReturnCode = ' '
     C                   EVAL      TotCount = 0
 
      ** If there are still records to be processed
 
     C**********         READ      GPWTRPCPD                                               MD023876A
     C                   READ      GOWTRPCPD                                               MD023876A
     C                   IF        NOT %EOF
     C                   EVAL      SCTID = CTID
     C                   ENDIF
 
      ** Write to driver file the batch to be processed
      ** Update index file to keep track of last record processed
 
     C**********         DOW       NOT %EOF(GPWTRPCPD)                                     MD023876A
     C                   DOW       NOT %EOF(GOWTRPCPD)                                     MD023876A
     C                             AND TotCount < RecPerSubtask
     C                   EVAL      TotCount = TotCount + RECCTR
 
     C**********         READ      GPWTRPCPD                                               MD023876A
     C                   READ      GOWTRPCPD                                               MD023876A
     C                   ENDDO
 
     C                   IF        TotCount > 0
 
     C                   EVAL      ECTID = CTID
 
     C**********         OPEN      GPWTRPDPD                                               MD023876A
     C                   OPEN      GOWTRPDPD                                               MD023876A
     C                   WRITE     DRIVERFL
     C**********         CLOSE     GPWTRPDPD                                               MD023876A
     C                   CLOSE     GOWTRPDPD                                               MD023876A
 
     C                   EVAL      LCTID = CTID
 
     C                   IF        IdxFileEmpty
     C                   WRITE     INDEXFL
     C                   ELSE
     C                   UPDATE    INDEXFL
     C                   ENDIF
 
     C                   ENDIF
 
      ** If EOF reached and record written to driver file
 
     C**********         IF        %EOF(GPWTRPCPD) AND TotCount > 0                        MD023876A
     C                   IF        %EOF(GOWTRPCPD) AND TotCount > 0                        MD023876A
     C                   EVAL      ReturnCode = 'EOF'
     C                   EVAL      *INLR = *ON
 
      ** when EOF reached and no record written to driver file
 
     C**********         ELSEIF    %EOF(GPWTRPCPD) AND TotCount = 0                        MD023876A
     C                   ELSEIF    %EOF(GOWTRPCPD) AND TotCount = 0                        MD023876A
     C                   EVAL      ReturnCode = 'NRF'
     C                   EVAL      *INLR = *ON
     C                   ENDIF
 
     C                   COMMIT
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initialization Routine                               *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    RecPerSubtask
     C                   PARM                    ReturnCode
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR - Program Exception Error Routine                       *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        NOT PSSRDone
     C                   DUMP
     C                   EVAL      PSSRDone = True
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
