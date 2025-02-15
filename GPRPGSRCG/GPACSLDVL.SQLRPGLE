     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas GP Access Supplied Validation List')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPACSLDVL - Access GP Supplied Validation List               *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. MD054605           Date 17Oct19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD033895           Date 16Apr15               *
      *                 MD024244*CREATE    Date 09Jan14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054605 - Deliverable Data Split for SDSVALPD               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD033895 - Correct parameters for UT000033.                  *
      *  MD024244 - Document Store Cannot Access Root Directory       *
      *                                                               *
      *****************************************************************
      *
      ** Entry parameters
      *
     D ReturnCode      S              7A
     D Action          S              1A
     D***Keyword***    S            256A                                                    MD033895
     D***Password**    S            256A                                                    MD033895
     D***Password2*    S            256A                                                    MD033895
     D***Desc******    S             50A                                                    MD033895
     D Keyword         S            100A                                                    MD033895
     D Password        S            600A                                                    MD033895
     D Password2       S            600A                                                    MD033895
     D Desc            S           1000A                                                    MD033895
      *
      ** Work Variables
      *
     D WRun            S              1A
     D GlobPref        S              2A
     D Library         S             10A
     D WAction         S              1A
     D***WPass2*       S            256A   INZ(*BLANKS)                                     MD033895
     D WPass2          S            600A   INZ(*BLANKS)                                     MD033895
      *
      ** UT000033 parameters
      *
     D PReturnCode     S              7A
     D PAction         S              1A
     D PValidList      S             10A
     D PLibrary        S             10A
     D***PUserName*    S            256A                                                    MD033895
     D***Pass1*****    S            256A                                                    MD033895
     D***Pass2*****    S            256A                                                    MD033895
     D***Descr*****    S             50A                                                    MD033895
     D PuserName       S            100A                                                    MD033895
     D PPass1          S            600A                                                    MD033895
     D PPass2          S            600A                                                    MD033895
     D PDescr          S           1000A                                                    MD033895
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Main Processing                                              *
      *                                                               *
      *****************************************************************
      *
      ** Format correct action code
      *
     C                   SELECT
      *
      ** Enquire / Find
      *
     C     Action        WHENEQ    'E'
     C                   EVAL      WAction = 'F'
      *
      ** Insert
      *
     C     Action        WHENEQ    'I'
     C                   EVAL      WAction = 'A'
      *
      ** Amend / Modify
      *
     C     Action        WHENEQ    'A'
     C                   EVAL      WAction = 'M'
     C                   EVAL      WPass2 = Password2
      *
      ** Delete
      *
     C     Action        WHENEQ    'D'
     C                   EVAL      WAction = 'D'
     C                   ENDSL
      *
      ** Call utility program for Common Validation List Functions
      *
     C                   CALL      'UT000033'
     C                   PARM                    PReturnCode
     C                   PARM      WAction       PAction
     C                   PARM      'GPLDAPVL'    PValidList
     C                   PARM      Library       PLibrary
     C                   PARM      Keyword       PuserName
     C                   PARM      Password      PPass1
     C                   PARM      WPass2        PPass2
     C                   PARM      Desc          PDescr
      *
      ** Return Error Code if not successful
      *
     C                   IF        PReturnCode <> *BLANKS
     C                   EVAL      ReturnCode = PReturnCode
     C                   ELSE
      *
      ** Return new password if action is amend
      *
     C                   SELECT
     C     Action        WHENEQ    'A'
     C                   EVAL      Password = Ppass2
      *
      ** Return as blank if action is delete
      *
     C     Action        WHENEQ    'D'
     C                   EVAL      Password = *BLANKS
      *
      ** Otherwise return default password
      *
     C                   OTHER
     C                   EVAL      Password = Ppass1
     C                   ENDSL
      *
     C                   EVAL      ReturnCode = '1'
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Routine                      *
      *                                                               *
      *  Calls: *PSSR                                                 *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
      *
     C                   PARM                    ReturnCode
     C                   PARM                    Action
     C                   PARM                    Keyword
     C                   PARM                    Password
     C                   PARM                    Password2
     C                   PARM                    Desc
      *
      ** Get Global System Prefix
      *
     C/EXEC SQL
     C**select*GIVAL into :GlobPref from SDSVALPD                                           MD054605
     C+ select GIVAL into :GlobPref from SDSVLJW0                                           MD054605
     C+ where GISVAL = 'GlobalSystemPrefix'
     C/END-EXEC
      *
     C                   EVAL      Library = GlobPref + 'GMLIB'
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception error routine                      *
      *                                                               *
      *  Called By: Automatically If a program error occurs,          *
      *             or directly by the program code using EXSR.       *
      *             This subroutine DUMPs the program just once.      *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   IF        WRun = *BLANKS
      *
     C                   EVAL      WRun = 'Y'
     C                   DUMP
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
