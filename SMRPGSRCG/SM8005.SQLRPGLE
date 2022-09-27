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
      *  Last Amend No. CUP046 *CREATE     Date 01Jun22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
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
     DIncNo            S              5  0
      ** Declared Variables
       /EJECT
      *****************************************************************

     C                   setoff                                       5657

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

      ** End of program.
     C                   EVAL      *INLR = *ON
     C                   RETURN

      /EJECT
      *****************************************************************
