     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Set user to role')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SM000046 - Set user to role                                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. AR1085933          Date 06Feb13               *
      *  Prev Amend No. CBF005   *CREATE   Date 04Jul11               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  AR1085933 - Position to function not working properly        *
      *  CBF005 - BF Infrastructure: Single Security User Maintenance *
      *           Profile                                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators                                            *
      *                                                               *
      *       03         F3 has been pressed (Exit program)           *
      *       05         F5 has been pressed (Refresh screen)         *
      *       80         Clear subfile                                *
      *       82         On to display next subfile page              *
      * ???   86         Subfile putover                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Subroutines                                                  *
      *                                                               *
      * *main                                                         *
      *    - InitSfl : Inititalise subfile                            *
      *    - BuildSfl : Build subfile                                 *
      *    - ProcSfl : Process subfile                                *
      *       - BuildPerm : Write records to role / permission file   *
      *          - FindPerm* : Find permission on SMBFACPD            *
      * *PSSR : Error processing                                      *
      *                                                               *
      *****************************************************************
     FSM000046DFCF   E             WORKSTN SFILE(SM000046S0:SflRRN)
     F                                     INFSR(*PSSR)
      *
     D PJob            S             10
     D PUser           S             10
     D SFlRRN          S              4  0
     D SflStart        S             10
     D Action          S              1
     D Permission      S            256
     D Recursive       S              1    INZ('N')
     D Looper          S              4  0                                                 AR1085933
     D Count           S              4  0                                                 AR1085933
      *
     D BFUB          E DS                  EXTNAME(SMBFUBPD)
     D BFAC          E DS                  EXTNAME(SMBFACPD)
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
     C     *ENTRY        PLIST
     C                   PARM                    PJob
     C                   PARM                    PUser
      *
     C                   EVAL      DJOB = PJob
     C                   EVAL      DCUSR = PUser
      *
      * Return point for Refresh option.
     C     START         TAG
      * Initialise subfile.
     C                   EXSR      InitSfl
      *
      * Build  subfile.
     C                   EXSR      BuildSfl
      *
      * Process when action taken from screen.
     C                   EXSR      ProcSfl
     C                   IF        *IN03 <> *ON                                            AR1085933
     C                   GOTO      START                                                   AR1085933
     C                   ENDIF                                                             AR1085933
      *                                                                                    AR1085933
     C**********         IF        *IN05 = *ON                                             AR1085933
     C**********         GOTO      START                                                   AR1085933
     C**********         ENDIF                                                             AR1085933
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * ProcSfl - Process subfile                                     *
      *                                                               *
      * Called by: *main                                              *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     ProcSfl       BEGSR
      *
      * If F3 or F5 taken then leave subroutine.
     C                   IF        *IN03 = *ON or
     C                             *IN05 = *ON
     C                   GOTO      ProcSflE
     C                   ENDIF
      *
      * If user has been asked to move to position to subfile.
     C                   IF        DPOS <> *blank
     C                   EVAL      SflStart = DPOS
     C**********         EVAL      *IN05 = *ON                                             AR1085933
     C                   GOTO      ProcSflE
     C                   ENDIF
      *
      * If user has added or changed a role to the subfile.
     C                   READC     SM000046S0
     C                   DOW       NOT(%EOF)
     C                   EXSR      BuildPerms
     C                   READC     SM000046S0
     C                   ENDDO
     C**********         EVAL      *IN05 = *ON                                             AR1085933
      *
     C     ProcSflE      ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * InitSfl - Initialise subfile                                  *
      *                                                               *
      * Called by: *main                                              *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     InitSfl       BEGSR
      *
     C                   EVAL      SflRRN = 1
     C                   EVAL      *IN80 = *ON
     C                   WRITE     SM000046C0
     C                   EVAL      *IN80 = *OFF
      *
     C     InitSflE      ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * BuildSfl - Build subfile                                      *
      *                                                               *
      * Called by: *main                                              *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     BuildSfl      BEGSR
      *
      * Read through SMBFUBPD (list of users) to get users and existing roles.
     C/exec SQL
     C+ declare UBcursor cursor for
     C+ select * from SMBFUBPD
     C*+*where*UBUSER*>=*:SflStart*************************************                    AR1085933
     C+ order by UBUSER, UBBRCH
     C/end-exec
      *
     C/exec SQL
     C+ open UBcursor
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from UBcursor
     C+ into: BFUB
     C/end-exec
      *
     C                   EVAL      Match = 1                                               AR1085933
     C                   EVAL      Looper = 1                                              AR1085933
     C                   DOW       SQLCODE = 0
      *
     C                   IF        (UBUSER = SflStart                                      AR1085933
     C                                OR %scan(SflStart:UBUSER:1) <> 0)                    AR1085933
     C                             AND Match = 1                                           AR1085933
     C                   EVAL      Match = Looper                                          AR1085933
     C                   ENDIF                                                             AR1085933
      *                                                                                    AR1085933
     C                   EVAL      DUSER = UBUSER
     C                   EVAL      DBRCH = UBBRCH
     C                   EVAL      DROLE = UBROLE
     C                   EVAL      *IN80 = *ON
     C                   WRITE     SM000046S0
     C                   EVAL      *IN80 = *OFF
     C                   EVAL      SflRRN = SflRRN + 1
      *
     C/exec SQL
     C+ fetch next
     C+ from UBcursor
     C+ into: BFUB
     C/end-exec
      *
     C                   EVAL      Looper = Looper + 1                                     AR1085933
     C                   ENDDO
      *
     C/exec SQL
     C+ close UBcursor
     C/end-exec
      *
     C                   EVAL      DPOS = ''                                               AR1085933
     C                   EVAL      *IN82 = *ON
     C                   WRITE     SM000046F0
     C                   EXFMT     SM000046C0
      *
     C     BuildSflE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * BuildPerms - Associate permissions with role                  *
      *                                                               *
      * Called by: ProcSfl                                            *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     BuildPerms    BEGSR
      *                                                                                    AR1085933
     C                   EVAL      Count = 0                                               AR1085933
      /free
           Exec SQL
                Select count(*) into :Count
                from SMBFUBPD
                where UBUSER = :DUSER and UBBRCH = :DBRCH and UBROLE <> '';                AR1085933
      /end-free
     C                   IF        DROLE = '' and Count > 0                                AR1085933
      /free
           Exec SQL
                Delete from SMBFRPQT
                where RPROLE
                = (select UBROLE from SMBFUBPD
                   where UBUSER = :DUSER and UBBRCH = :DBRCH);                             AR1085933
      /end-free
     C                   ENDIF                                                             AR1085933
      *
      ** First update user file with role name.
      *
     C                   EVAL      Count = 0                                               AR1085933
      /free
           Exec SQL
                Select count(*) into :Count
                from SMBFUBPD
                where UBROLE = :DROLE;                                                     AR1085933
      /end-free
     C                   IF        COUNT < 1                                               AR1085933
      *                                                                                    AR1085933
     C/exec SQL
     C+ update SMBFUBPD
     C+ set UBROLE = :DROLE
     C+ where UBUSER = :DUSER and UBBRCH = :DBRCH
     C/end-exec
      *                                                                                    AR1085933
     C                   ELSE                                                              AR1085933
     C                   GOTO      BuildPermsE                                             AR1085933
     C                   ENDIF                                                             AR1085933
      *
      ** Find permissions (menu code + action) from Midas data.
      *
     C/exec SQL
     C+ declare ACcursor cursor for
     C+ select * from SMBFACPD
     C+ where ACUSER = :DUSER and ACBRCH = :DBRCH
     C/end-exec
      *
     C/exec SQL
     C+ open ACcursor
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from ACcursor
     C+ into: BFAC
     C/end-exec
      *
     C                   DOW       SQLCODE = 0
      *
      ** Check each action code (I, E, etc.) and find equivalent permission.
      *
     C                   IF        ACAC01 <> ' '
     C                   EVAL      Action = ACAC01
     C                   EXSR      FindPerm
     C                   ENDIF
     C                   IF        ACAC02 <> ' '
     C                   EVAL      Action = ACAC02
     C                   EXSR      FindPerm
     C                   ENDIF
     C                   IF        ACAC03 <> ' '
     C                   EVAL      Action = ACAC03
     C                   EXSR      FindPerm
     C                   ENDIF
     C                   IF        ACAC04 <> ' '
     C                   EVAL      Action = ACAC04
     C                   EXSR      FindPerm
     C                   ENDIF
     C                   IF        ACAC05 <> ' '
     C                   EVAL      Action = ACAC05
     C                   EXSR      FindPerm
     C                   ENDIF
     C                   IF        ACAC06 <> ' '
     C                   EVAL      Action = ACAC06
     C                   EXSR      FindPerm
     C                   ENDIF
     C                   IF        ACAC07 <> ' '
     C                   EVAL      Action = ACAC07
     C                   EXSR      FindPerm
     C                   ENDIF
     C                   IF        ACAC08 <> ' '
     C                   EVAL      Action = ACAC08
     C                   EXSR      FindPerm
     C                   ENDIF
     C                   IF        ACAC09 <> ' '
     C                   EVAL      Action = ACAC09
     C                   EXSR      FindPerm
     C                   ENDIF
     C                   IF        ACAC10 <> ' '
     C                   EVAL      Action = ACAC10
     C                   EXSR      FindPerm
     C                   ENDIF
      *
     C/exec SQL
     C+ fetch next
     C+ from ACcursor
     C+ into: BFAC
     C/end-exec
      *
     C                   ENDDO
      *
     C/exec SQL
     C+ close ACcursor
     C/end-exec
      *
     C     BuildPermsE   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * FindPerm - Identify permission associated with menu code and  *
      *            action                                             *
      *                                                               *
      * Called by: BuildPerms                                         *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     FindPerm      BEGSR
      *
      ** Find the matching permission for the menu code and action.
      *
     C/exec SQL
     C+ select PMARTF into :Permission
     C+ from MITB_PERMM
     C+ where PMINDX = :ACINDX and PMACTC = :Action
     C/end-exec
      *
      ** Write record to the role / permission file'.
      *
     C                   IF        Permission <> ''                                        AR1085933
     C/exec SQL
     C+ insert into SMBFRPQT (
     C+ RPROLE, RPARTF
     C+ )
     C+ values (
     C+ :DROLE, :Permission
     C+ )
     C/end-exec
     C                   ENDIF                                                             AR1085933
      *
     C     FindPermE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  -   Program exception error routine                    *
      *            Called automatically if a program error occurs,    *
      *            or directly by the program code using EXSR.        *
      *            This subroutine DUMPs the program just once.       *
      *                                                               *
      * Called by: *INZSR                                             *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive = *BLANK
     C                   EVAL      Recursive = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
