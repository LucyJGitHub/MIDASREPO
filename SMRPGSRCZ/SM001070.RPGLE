      *****************************************************************
     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*XBIA*  OVRDBF FILE(OLDUSER) TOFILE(MUSER)                           *
/*XBIB*  OVRDBF FILE(NEWUSER) TOFILE(MUSER)                           *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Select users and copy to new system')         *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SM001070 - Select and copy Midas user data to the new system *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *  Last Amend No. A1084804           Date 29Jan13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. B07809             Date 07Nov07               *
      *                 CUP034  *CREATE    Date 18Dec06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  A1084804 - Ensure user text is brought across.               *
      *  B07809 - Can not handle over 999 users.                      *
      *  CUP034 - MidasPlus user data migration.                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      * Indicators                                                    *
      *                                                               *
      *       01         ON if any position fields have changed.      *
      *       03         F3 has been pressed (Exit program).          *
      *       05         F5 has been pressed (Refresh screen).        *
      *       21         No select option entered.                    *
      *       30         ON to clear subfile records.                 *
      *       40         Record not found in OLDUSER file.            *
      *       50         EOF of OLDUSER file.                         *
      *       52         Record not found in NEWUSER file.            *
      *       57         invalid input for option.                    *
      *                                                               *
     F*****************************************************************
      /EJECT
     FSM1070DF  CF   E             WORKSTN
     F                                     SFILE(FMT1:RRN)
     FOLDUSER   IF   E           K DISK    INFSR(*PSSR)
      *
     FNEWUSER   IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(MUSERDDF:NEWUSERF) PREFIX(N)
      *
     D PSDS           SDS
      *
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  SWSID                244    253
     D  SUSER                254    263
      *
     C     *ENTRY        PLIST
     C                   PARM                    FRMSYS            2
     C                   PARM                    TOSYS             2
     C                   PARM                    MITEMDD           1
      *
      * Define fields
     C     *LIKE         DEFINE    USRP          RUSRP                          Rename To Name
     C     *LIKE         DEFINE    USER1         RUSER1                         Rename To Name
      *
      * Set up display screen heading .
     C                   MOVE      TOSYS         NEWSYS
      *
      * Key chaining to user file.
     C     MUKEY         KLIST
     C                   KFLD                    USRP
      *
     C     *LOVAL        SETLL     OLDUSER
      *
     C     *IN03         DOWEQ     *OFF
      *
      * Build subfile
     C  N57              MOVE      'Y'           NOREC             1
     C  N57              EXSR      BUILD
      *
      * If no records, send blank format, otherwise send subfile
     C     NOREC         IFEQ      'Y'
     C                   EXFMT     NORCD
     C                   ELSE
      *
     C                   WRITE     FMT0
     C                   EXFMT     FMT2
     C                   SETOFF                                       57
     C                   ENDIF
      *
      * If F3 pressed, exit program
     C     *IN03         IFEQ      *ON
     C                   ELSE
      *
      * If F5 pressed, rebuild subfile from the requested user profile.
     C     *IN05         IFEQ      *ON
     C     XXUSRP        SETLL     OLDUSER
      *
     C                   ELSE
      *
      * If position, rebuild from requested user profile.
      * Indicator 01 is set on if any field in the format has changed,
      * so it caters for the user changing the selection details and
      * pressing enter again.
      *
     C     *IN01         IFEQ      *ON
      *
     C     XXUSRP        IFNE      *BLANK
     C     XXUSRP        SETLL     OLDUSER
     C                   ELSE
     C     *LOVAL        SETLL     OLDUSER
     C                   ENDIF
      *
      * Else selection criteria XXUSRP has not been changed.
     C                   ELSE
      * ReadC if records are displayed.
     C     NOREC         IFEQ      'N'
     C                   READC     FMT1                                   21
      *
      * If *IN21 is on, no selection has been made - rebuild
      *
     C     *IN21         IFEQ      *ON
     C     *LOVAL        SETLL     OLDUSER
     C                   ELSE
      *
     C     *IN21         DOWEQ     *OFF
      *
      * When user is selected for rename/copy, call program to prompt for the
      * new rename user name
     C     XXOPT         IFEQ      'R'
     C                   CALL      'SMC1075'
     C                   PARM      *BLANK        RUSRP
     C                   PARM      *BLANK        RUSER1
      *
      * If the Rename To user name is blank, set on indicator for error msg.
     C     RUSRP         IFEQ      *BLANK
     C                   SETON                                        215798
     C                   SETON                                        8499
     C                   UPDATE    FMT1
     C                   GOTO      EXTTAG
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     XXOPT         IFEQ      'X'
     C                   MOVEL     USRP          RUSRP
     C                   MOVEL     USER1         RUSER1                                     A1084804
     C                   ENDIF
      *
      * if user is selected, write/update NEWUSER file.
     C     XXOPT         IFEQ      'X'
     C     XXOPT         OREQ      'R'
      *
      * Call external program to update user files.
     C                   CALL      'SMC001071'
     C                   PARM                    USRP
     C                   PARM                    FRMSYS
     C                   PARM                    TOSYS
     C                   PARM                    RTNCOD            5
     C                   PARM                    RUSRP
     C                   PARM                    MITEMDD
     C                   PARM                    RUSER1                                     A1084804
      *
      * If previous update ended in error, force rebuild of subfile.
     C     RTNCOD        IFEQ      'ERROR'
     C                   MOVE      *ON           *IN21
     C                   CLEAR                   RTNCOD
      *
      * Else if no error in updating new system files, READC next subfile
      *         record.
     C                   ELSE
      * blank the option after successful update.
     C     XXOPT         IFEQ      'X'
     C                   MOVE      'Yes'         EXIST
     C                   MOVE      'Y'           EXIND
     C                   ENDIF
     C                   MOVE      *BLANK        XXOPT
     C                   UPDATE    FMT1
     C                   READC     FMT1                                   21
     C                   ENDIF
      *
     C                   ELSE
     C                   READC     FMT1                                   21
     C                   ENDIF
      *
     C                   ENDDO
      *
      *  Reset file
     C     XXUSRP        SETLL     OLDUSER
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C     EXTTAG        TAG
      *
     C                   ENDDO
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
      ********************************************************************
      *   BUILD Subroutine - Build subfile                               *
      ********************************************************************
      *
     C     BUILD         BEGSR
      *
     C                   MOVE      *BLANKS       XXOPT
     C**********         Z-ADD     0             J                 3 0                     B07809
     C**********         Z-ADD     1             RRN               3 0                     B07809
     C                   Z-ADD     0             J                 4 0                     B07809
     C                   Z-ADD     1             RRN               4 0                     B07809
      *
     C                   MOVE      *ON           *IN30
     C                   WRITE     FMT2
     C                   MOVE      *OFF          *IN30
      *
     C                   READ      OLDUSER                                50
      *
      * If not EOF, build subfile.
     C     *IN50         DOWEQ     *OFF
      *
      * Only display users with RECI = 'D'.
     C     RECI          IFEQ      'D'
     C                   MOVE      'N'           NOREC
      *
      * Check if the user is in the new system and is active, move
      * 'Yes' to the 'Exist in the new system' field for display.
     C     MUKEY         CHAIN     NEWUSER                            52
     C     *IN52         IFEQ      *OFF
     C                   MOVE      'Yes'         EXIST
     C                   MOVE      'Y'           EXIND
     C                   ELSE
     C                   MOVE      *BLANK        EXIST
     C                   MOVE      'N'           EXIND
     C                   ENDIF
      *
     C                   ADD       1             J
     C                   WRITE     FMT1
     C                   ADD       1             RRN
      *
     C                   ENDIF
      *
     C                   READ      OLDUSER                                50
     C                   ENDDO
      *
     C                   ENDSR
      *
      /EJECT
      ********************************************************************
      *  *PSSR Subroutine - Error handling                               *
      ********************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   END
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
