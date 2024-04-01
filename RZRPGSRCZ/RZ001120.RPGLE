     HDebug
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Get list of MPM Libraries')                            *
      *****************************************************************
      *                                                               *
      *  Midas - RZ Developments                                      *
      *                                                               *
      *  RZ001120 - Get List of MPM Libraries                         *
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
      *  Called By: RZC001120 - MPM Library Save                      *
      *                                                               *
/*    *  Last Amend No. AR1084152 *Create    Date 31Jan13             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1084152 - Automate MPM dbase and archiving during CoB      *
      *            - (Child:AR1084154)                                *
      *                                                               *
      *****************************************************************

     F*SdSValL0* IF   E           K Disk

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
     D C#LiveMMMUser   C                   'COBMeridianUsrLive'                 AR108415
     D C#TestMMMUser   C                   'COBMeridianUsrTest'                 AR108415
     D PRetCode        S              7A                                        AR108415
     D SValK1          S             20A                                        AR108415
     D SVal1           S            200A                                        AR108415
     D SValK2          S             20A                                        AR108415
     D SVal2           S            200A                                        AR108415
     D SValK3          S             20A                                        AR108415
     D SVal3           S            200A                                        AR108415
     D SValK4          S             20A                                        AR108415
     D SVal4           S            200A                                        AR108415
     D SValK5          S             20A                                        AR108415
     D SVal5           S            200A                                        AR108415
     D SValK6          S             20A                                        AR108415
     D SVal6           S            200A                                        AR108415
     D SValK7          S             20A                                        AR108415
     D SVal7           S            200A                                        AR108415
     D SValK8          S             20A                                        AR108415
     D SVal8           S            200A                                        AR108415
     D SValK9          S             20A                                        AR108415
     D SVal9           S            200A                                        AR108415
     D SValK10         S             20A                                        AR108415
     D SVal10          S            200A                                        AR108415


     C     *Entry        Plist
     C                   Parm                    O#MPLusDbPf
     C                   Parm                    O#MainMPMDb
     C                   Parm                    O#ArchMPMDb
     C                   Parm                    O#MMMUser                      AR108415

     C*****KSdSValL0     Klist                                                  AR108415
     C**********         KFld                    GiSVal                         AR108415
                                                                                AR108415
      * Get corresponding system values                                         AR108415
     C                   CALL      'AOSVALR0'                                   AR108415
     C                   PARM      *BLANKS       PRetCode                       AR108415
     C                   PARM      C#LiveSysDb   SValK1                         AR108415
     C                   PARM      *BLANKS       SVal1                          AR108415
     C                   PARM      C#LiveSysMPMDbSValK2                         AR108415
     C                   PARM      *BLANKS       SVal2                          AR108415
     C                   PARM      C#TestSysMPMDbSValK3                         AR108415
     C                   PARM      *BLANKS       SVal3                          AR108415
     C                   PARM      C#LiveSysMPMArSValK4                         AR108415
     C                   PARM      *BLANKS       SVal4                          AR108415
     C                   PARM      C#TestSysMPMArSValK5                         AR108415
     C                   PARM      *BLANKS       SVal5                          AR108415
     C                   PARM      C#LiveMMMUser SValK6                         AR108415
     C                   PARM      *BLANKS       SVal6                          AR108415
     C                   PARM      C#TestMMMUser SValK7                         AR108415
     C                   PARM      *BLANKS       SVal7                          AR108415
     C                   PARM      *BLANKS       SValK8                         AR108415
     C                   PARM      *BLANKS       SVal8                          AR108415
     C                   PARM      *BLANKS       SValK9                         AR108415
     C                   PARM      *BLANKS       SVal9                          AR108415
     C                   PARM      *BLANKS       SValK10                        AR108415
     C                   PARM      *BLANKS       SVal10                         AR108415
      *                                                                         AR108415
     C                   IF        PRetCode <> *BLANKS                          AR108415
     C                   EVAL      *INLR = *On                                  AR108415
     C                   ENDIF                                                  AR108415
      * Get Live System Library Prefix                                          AR108415
     C                   EVAL      O#LiveSysDb = SVal1                          AR108415
      * Get MPM Main Db name                                                    AR108415
     C                   IF        O#LiveSysDb = O#MPLusDbPf                    AR108415
     C                   EVAL      O#MainMPMDb = SVal2                          AR108415
     C                   ELSE                                                   AR108415
     C                   EVAL      O#MainMPMDb = SVal3                          AR108415
     C                   ENDIF                                                  AR108415
      * Get MPM Archive Db name                                                 AR108415
     C                   IF        O#LiveSysDb = O#MPLusDbPf                    AR108415
     C                   EVAL      O#ArchMPMDb = SVal4                          AR108415
     C                   ELSE                                                   AR108415
     C                   EVAL      O#ArchMPMDb = SVal5                          AR108415
     C                   ENDIF                                                  AR108415
      * Get Meridian User profile                                               AR108415
     C                   IF        O#LiveSysDb = O#MPLusDbPf                    AR108415
     C                   EVAL      O#MMMUser = SVal6                            AR108415
     C                   ELSE                                                   AR108415
     C                   EVAL      O#MMMUser = SVal7                            AR108415
     C                   ENDIF                                                  AR108415
                                                                                AR108415
      **Get*Live System Library Prefix                                          AR108415
     C**********         Eval      GiSVal = C#LiveSysDb                         AR108415
     C*****KSdSvalL0     Chain     @SValL0                                      AR108415
     C**********         If        %Found                                       AR108415
     C**********         Eval      O#LiveSysDb = %Subst(GiVal:1:2)              AR108415
     C**********         Endif                                                  AR108415

      **Get*MPM*Main Db name                                                    AR108415
     C**********         If        O#LiveSysDb = O#MPLusDbPf                    AR108415
     C**********         Eval      GiSVal = C#LiveSysMPMDb                      AR108415
     C**********         Else                                                   AR108415
     C**********         Eval      GiSVal = C#TestSysMPMDb                      AR108415
     C**********         Endif                                                  AR108415

     C*****KSdSvalL0     Chain     @SValL0                                      AR108415
     C**********         If        %Found                                       AR108415
     C**********         Eval      O#MainMPMDb = %Subst(GiVal:1:10)             AR108415
     C**********         Endif                                                  AR108415

      **Get*MPM*Archive Db name                                                 AR108415
     C**********         If        O#LiveSysDb = O#MPLusDbPf                    AR108415
     C**********         Eval      GiSVal = C#LiveSysMPMAr                      AR108415
     C**********         Else                                                   AR108415
     C**********         Eval      GiSVal = C#TestSysMPMAr                      AR108415
     C**********         Endif                                                  AR108415
     C*****KSdSvalL0     Chain     @SValL0                                      AR108415
     C**********         If        %Found                                       AR108415
     C**********         Eval      O#ArchMPMDb = %Subst(GiVal:1:10)             AR108415
     C**********         Endif                                                  AR108415

     C                   Eval      *InLr = *On
     C                   Return
