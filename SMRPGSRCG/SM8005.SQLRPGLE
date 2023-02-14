     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2022')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP OTM display attention key options')           *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  SM8005 - Midas UP OTM display attention key options          *
      *                                                               *
      *  Function: This program displays options availalbe when       *
      *            attention key is pressed from refresh monitor      *
      *            screen.                                            *
      *                                                               *
      *  (c) Finastra International Limited 2022                      *
      *                                                               *
      *  Last Amend No. MD060980           Date 30Jan23               *
      *  Prev Amend No. CUP046 *CREATE     Date 01Jun22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD060980 - Improvement to CUP046                             *
      *             1. make sure subsystem is started                 *
      *             2. send different msg depending on scenarios      *
      *             3. add option to cancel process                   *
      *  CUP046 - One Touch Bridge - refresh                          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of Indicators                                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Subroutine index.                                            *
      *                                                               *
      *                                                               *
      *****************************************************************
      /EJECT
      *
      ** Display File
     FSM8005GF  CF   E             WORKSTN

     DDisp             S              1
     DStatus           S              1
     DFail_Halt        S              1                                                     MD060980
     DBRIDGELIB        S             10                                                     MD060980
     DHalt             S              1                                                     MD060980
     DIncNo            S              5  0
      ** Declared Variables
       /EJECT
      *****************************************************************

     C                   setoff                                       5657
     C/exec SQL                                                                             MD060980
     C+ select GIVAL  into :BRIDGELIB                                                       MD060980
     C+ from GPSVLXTD where GISVAL = 'BrgDeliveredBrgLib'                                   MD060980
     C/end-exec                                                                             MD060980

     C     Redisplay     tag

      * check if migration of database is running (SMC008000 00500)
     C/exec SQL
     C+ select MIGSTS into :Status
     C+ from SMMIGRTD where MIGSEQ = 500
     C/end-exec

     C                   If        Status = ' ' or Status = 'C'
     C                             or Status = 'B'
     C/exec SQL
     C+ select MIGSTS into :Status
     C+ from SMMIGRTD where MIGSEQ = 10600
     C/end-exec
     C                   Endif

     C                   setoff                                       24
     C                   If        Status = 'R' or Status = 'F'
     C                   seton                                        24
     C                   Endif

      ** Check if migration is stopped                                                      MD060980
      *  1. no component is running                                                         MD060980
     C                   eval      Status = *blanks                                         MD060980
     C                   eval      Fail_Halt = 'N'                                          MD060980
     C                   eval      Halt = 'N'                                               MD060980
     C                   setoff                                       25                    MD060980
     C/exec SQL                                                                             MD060980
     C+ select MIGSTS into :Status                                                          MD060980
     C+ from SMMIGRTD where MIGSTS = 'R'                                                    MD060980
     C+ order by MIGINC desc                                                                MD060980
     C/end-exec                                                                             MD060980
     C                   If        SQLCODE = 100                                            MD060980
      *  either because a component is failed                                               MD060980
     C/exec SQL                                                                             MD060980
     C+ select MIGSTS into :Status                                                          MD060980
     C+ from SMMIGRTD where MIGSTS = 'F'                                                    MD060980
     C+ order by MIGINC desc                                                                MD060980
     C+ fetch first 1 row only                                                              MD060980
     C/end-exec                                                                             MD060980
     C                   If        SQLCODE = 0                                              MD060980
     C                   eval      Fail_Halt = 'Y'                                          MD060980
     C                   Endif                                                              MD060980
                                                                                            MD060980
      *  or component is halted                                                             MD060980
     C/exec SQL                                                                             MD060980
     C+ select MIGHLT into :Halt                                                            MD060980
     C+ from SMMIGRTD where MIGSTS = ' '                                                    MD060980
     C+ order by MIGINC asc                                                                 MD060980
     C+ fetch first 1 row only                                                              MD060980
     C/end-exec                                                                             MD060980
     C                   If        SQLCODE = 0                                              MD060980
     C                             and Halt = 'Y'                                           MD060980
     C                   eval      Fail_Halt = 'Y'                                          MD060980
     C                   Endif                                                              MD060980
                                                                                            MD060980
     C                   If        Fail_Halt = 'Y'                                          MD060980
     C                   seton                                        25                    MD060980
     C                   Endif                                                              MD060980
                                                                                            MD060980
     C                   Endif                                                              MD060980
                                                                                            MD060980
      ** Process first screen.
     C                   EXFMT     SM8005F0

     C     Exit          tag

      ** End program if F3 is pressed.
     C                   IF        *INKC = *ON
     C                   CALL      'UPC7999'
     C                   ENDIF

      ** Display migration status if F4 is pressed.
     C                   IF        *INKD = *ON
     C                   CALL      'SMC800074'
     C                   ENDIF

      ** Return if F12 is pressed.
     C                   IF        *INKL = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF

      ** Halt immed if F6 is pressed
     C                   IF        *INKF = *ON
      * find running or failed component
     C/exec SQL
     C+ select MIGINC into :IncNo
     C+ from SMMIGRTD where MIGSTS <> ' '  and MIGSTS <> 'C'
     C/end-exec
      * set halt indicator for the nex component
     C/exec SQL
     C+ update SMMIGRTD set MIGHLT = 'Y'
     C+ where MIGINC = :IncNo + 1
     C/end-exec
     C                   if        SQLCODE = 0
     C                   eval      ##NARR = 'Immediate halt added'
     C                   else
     C                   eval      ##NARR = 'Migration cannot be halted'
     C                   ENDIF

      * re-display screen with F6
     C                   seton                                        56
     C                   goto      Redisplay
     C                   ENDIF

      ** Halt before if F7 is pressed
     C                   IF        *INKG = *ON
     C                   seton                                        22
     C                   DOW       Disp = ' '
     C                   EXFMT     SM8005F0

      ** if F3 or F12
     C                   IF        *INKC = *ON or *INKL = *ON
     C                   goto      exit
     C                   ENDIF

     C                   setoff                                       57
      * enter valid component
     C                   IF        ##CMP = *blanks or ##SEQ = 0
     C                   eval      ##NARR = 'Invalid component'
     C                   seton                                        57
     C                   iter
     C                   ENDIF

      * make sure component exists
     C/exec SQL
     C+ select MIGINC into :IncNo
     C+ from SMMIGRTD where MIGCMP = :##CMP and MIGSEQ = :##SEQ
     C/end-exec
     C                   if        SQLCODE <> 0
     C                   eval      ##NARR = 'Component does not exist.'
     C                   seton                                        57
     C                   iter
     C                   ENDIF

      * make sure component has not run yet
     C/exec SQL
     C+ select MIGINC into :IncNo
     C+ from SMMIGRTD where MIGCMP = :##CMP and MIGSEQ = :##SEQ
     C+ and MIGSTS = ' '
     C/end-exec
     C                   if        SQLCODE <> 0
     C                   eval      ##NARR = 'Component already ran.'
     C                   seton                                        57
     C                   iter
     C                   ENDIF

      * insert halt
     C/exec SQL
     C+ update SMMIGRTD set MIGHLT = 'Y'
     C+ where MIGINC = :IncNo
     C/end-exec
     C                   if        SQLCODE <> 0
     C                   eval      ##NARR = 'Halt can not be set.'
     C                   seton                                        57
     C                   iter
     C                   else
     C                   eval      ##NARR = 'Halt set.'
     C                   seton                                        57
     C                   EXFMT     SM8005F0
     C                   eval      DISP = 'N'
     C                   ENDIF

     C                   ENDDO

     C                   ENDIF

      ** F10 Cancel process is pressed                                                      MD060980
     C                   IF        *INKJ = *ON                                              MD060980
     C                   seton                                        24                    MD060980
     C                   DOW       Disp = ' '                                               MD060980
     C                   EXFMT     SM8005F0                                                 MD060980
                                                                                            MD060980
      ** if F3 or F12                                                                       MD060980
     C                   IF        *INKC = *ON or *INKL = *ON                               MD060980
     C                   goto      exit                                                     MD060980
     C                   ENDIF                                                              MD060980
                                                                                            MD060980
     C                   setoff                                       57                    MD060980
      * enter valid component                                                               MD060980
     C                   IF        ##CNF <> 'Y' and   ##CNF <> 'N'                          MD060980
     C                   eval      ##NARR = 'Enter Y or N'                                  MD060980
     C                   seton                                        57                    MD060980
     C                   iter                                                               MD060980
     C                   ENDIF                                                              MD060980
                                                                                            MD060980
      * If F10 not confirmed, return to previous screen                                     MD060980
     C                   if        ##CNF = 'N'                                              MD060980
     C                   goto      Redisplay                                                MD060980
     C                   ENDIF                                                              MD060980
                                                                                            MD060980
                                                                                            MD060980
      * If F10 is confirmed, send *ABORT to DTAQ                                            MD060980
     C                   if        ##CNF = 'Y'                                              MD060980
     C                   CALL      'QSNDDTAQ'                                               MD060980
     C                   PARM      'SM_OTB_SVR'  DtqNam           10                        MD060980
     C                   PARM      BRIDGELIB     DtqLib           10                        MD060980
     C                   PARM      50            DtqLen            5 0                      MD060980
     C                   PARM      'ABORT   '    DtqDta           50                        MD060980
     C                   eval      *INKC = *ON                                              MD060980
     C                   goto      exit                                                     MD060980
     C                   ENDIF                                                              MD060980
                                                                                            MD060980
     C                   ENDDO                                                              MD060980
                                                                                            MD060980
     C                   ENDIF                                                              MD060980
                                                                                            MD060980
      ** End of program.
     C                   EVAL      *INLR = *ON
     C                   RETURN

      /EJECT
      *****************************************************************
