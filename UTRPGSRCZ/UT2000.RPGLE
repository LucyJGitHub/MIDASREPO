     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2024')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT Change JOBD Library List')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Utilities Module                                     *
      *                                                               *
      *  UT2000 - Update the JOBD's Library List, move zzDZLIB        *
      *             after ggGTALIB                                    *
      *                                                               *
      *  (c) Finastra International Limited 2024                      *
      *                                                               *
      *  Last Amend No. MD061981 *CREATE   Date 15Jan24               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD061981 - 24x7 - Library List Changes                       *
      *                                                               *
      *****************************************************************

      ** Declared Variables
     D FoundPosDZ      S              4  0
     D EndPosDZ        S              4  0
     D FoundPosGTA     S              4  0
     D EndPosGTA       S              4  0
     D EndLen          S              4  0
     D TempLibl        S           2750
     D NewLibl         S           2750
     D DZLIB           S             11
     D JobDLibl        S           2750A

      ** ENTRY PARAMETERS

     C     *ENTRY        PLIST
     C                   PARM                    JobDLibl

      ** Remove DZLIB in LIBL
     C     'DZLIB'       SCAN      JobDLibl:1    FoundPosDZ               01
     C                   IF        *IN01 = *ON
     C                   EVAL      FoundPosDZ = FoundPosDZ - 2
     C                   EVAL      EndPosDZ = FoundPosDZ + 11
     C                   EVAL      EndLen = 2750 - EndPosDZ
     C                   EVAL      DZLIB = %SUBST(JobDLibl:FoundPosDZ:10)
     C                   EVAL      TempLibl=%SUBST(JobDLibl:1:FoundPosDZ-1) +
     C                             %SUBST(JobDLibl:EndPosDZ:EndLen)
      ** Insert DZLIB after GTALIB
     C     'GTALIB'      SCAN      TempLibl:1    FoundPosGTA              02
     C                   IF        *IN02 = *ON
     C                   Eval      FoundPosGTA = FoundPosGTA - 2
     C                   Eval      EndPosGTA = FoundPosGTA + 11
     C                   EVAL      EndLen = 2750 - EndPosGTA
     C                   EVAL      NewLibl = %SUBST(TempLibl:1:EndPosGTA-1) +
     C                             DZLIB + %SUBST(TempLibl:EndPosGTA:EndLen)
     C                   EVAL      JobDLibl = NewLibl
     C                   ENDIF
     C                   ENDIF
      *
     C                   RETURN
      *****************************************************************
