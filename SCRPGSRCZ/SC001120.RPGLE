     HDebug
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Get list of MPM Libraries')                            *
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC001120 - Get List of MPM Libraries                         *
      *                                                               *
      *  Function:  This program accesses system values               *
      *             to establish which libraries are part of the      *
      *             MPM Environment                                   *
      *                                                               *
      *             There are 7 system values:                        *
      *                                                               *
      *             LiveSysDbPrefix   - Live DM Lib prefix i.e. UA    *
      *             LiveSysMPMDbLib   - Live System MPM Library       *
      *             TestSysMPMDbLib   - Test System MPM Library       *
      *             LiveSysMPMArcDbLib- Live System MPM Archive Library
      *             TestSysMPMArcDbLib- Test System MPM Archive Library
      *             COBMeridianUsrLive- Live User used for archiving  *
      *             COBMeridianUsrTest- Test User used for archiving  *
      *                                                               *
      *  Called By: SCC001120 - MPM Library Save                      *
      *                                                               *
      *  Last Amend No. MD057372  *Create    Date 10Sep21             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD057372  - Re-develop approach for MD-10209                 *
      *                                                               *
      *****************************************************************

     D O#MPLusDbPf     S              2A
     D O#MainMPMDb     S             10A
     D O#ArchMPMDb     S             10A
     D O#MMMUser       S             10A

     D O#LiveSysDb     S              2A

     D C#LiveSysDb     C                   'LiveSysDbPrefix'
     D C#LiveSysMPMDb  C                   'LiveSysMPMDbLib'
     D C#TestSysMPMDb  C                   'TestSysMPMDbLib'
     D C#LiveSysMPMAr  C                   'LiveSysMPMArcDbLib'
     D C#TestSysMPMAr  C                   'TestSysMPMArcDbLib'
     D C#LiveMMMUser   C                   'COBMeridianUsrLive'
     D C#TestMMMUser   C                   'COBMeridianUsrTest'
     D PRetCode        S              7A
     D SValK1          S             20A
     D SVal1           S            200A
     D SValK2          S             20A
     D SVal2           S            200A
     D SValK3          S             20A
     D SVal3           S            200A
     D SValK4          S             20A
     D SVal4           S            200A
     D SValK5          S             20A
     D SVal5           S            200A
     D SValK6          S             20A
     D SVal6           S            200A
     D SValK7          S             20A
     D SVal7           S            200A
     D SValK8          S             20A
     D SVal8           S            200A
     D SValK9          S             20A
     D SVal9           S            200A
     D SValK10         S             20A
     D SVal10          S            200A

     C     *Entry        Plist
     C                   Parm                    O#MPLusDbPf
     C                   Parm                    O#MainMPMDb
     C                   Parm                    O#ArchMPMDb
     C                   Parm                    O#MMMUser

      ** Get corresponding system values

     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      C#LiveSysDb   SValK1
     C                   PARM      *BLANKS       SVal1
     C                   PARM      C#LiveSysMPMDbSValK2
     C                   PARM      *BLANKS       SVal2
     C                   PARM      C#TestSysMPMDbSValK3
     C                   PARM      *BLANKS       SVal3
     C                   PARM      C#LiveSysMPMArSValK4
     C                   PARM      *BLANKS       SVal4
     C                   PARM      C#TestSysMPMArSValK5
     C                   PARM      *BLANKS       SVal5
     C                   PARM      C#LiveMMMUser SValK6
     C                   PARM      *BLANKS       SVal6
     C                   PARM      C#TestMMMUser SValK7
     C                   PARM      *BLANKS       SVal7
     C                   PARM      *BLANKS       SValK8
     C                   PARM      *BLANKS       SVal8
     C                   PARM      *BLANKS       SValK9
     C                   PARM      *BLANKS       SVal9
     C                   PARM      *BLANKS       SValK10
     C                   PARM      *BLANKS       SVal10

     C                   IF        PRetCode <> *BLANKS
     C                   EVAL      *INLR = *On
     C                   ENDIF

      ** Get Live System Library Prefix

     C                   EVAL      O#LiveSysDb = SVal1

      ** Get MPM Main Db name

     C                   IF        O#LiveSysDb = O#MPLusDbPf
     C                   EVAL      O#MainMPMDb = SVal2
     C                   ELSE
     C                   EVAL      O#MainMPMDb = SVal3
     C                   ENDIF

      ** Get MPM Archive Db name

     C                   IF        O#LiveSysDb = O#MPLusDbPf
     C                   EVAL      O#ArchMPMDb = SVal4
     C                   ELSE
     C                   EVAL      O#ArchMPMDb = SVal5
     C                   ENDIF

      ** Get Meridian User profile

     C                   IF        O#LiveSysDb = O#MPLusDbPf
     C                   EVAL      O#MMMUser = SVal6
     C                   ELSE
     C                   EVAL      O#MMMUser = SVal7
     C                   ENDIF

     C                   Eval      *InLr = *On
     C                   Return
