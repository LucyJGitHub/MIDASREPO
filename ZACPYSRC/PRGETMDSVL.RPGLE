      *****************************************************************
      *                                                               *
      *  Midas - /COPY Member (RPG)                                   *
      *                                                               *
      *  PRGETMDSVL - AOSVALR0 Wrapper                                *
      *                                                               *
      *  Function:  This includeds alternate prototype for            *
      *             AOSVALR0                                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. CDL096  *CREATE    Date 22Sep14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *                                                               *
      *****************************************************************
 
     D*****************************************************************
     D* Prototype for procedure: RtvMidasSysVal                       *
     D*****************************************************************
 
     D RtvMidasSysVal  PR                  ExtPgm('AOSVALR0')
 
     D  ReturnCode                    7A
 
     D  SysVal1                      20A
     D  CurrentVal1                 200A
 
     D  SysVal2                      20A
     D  CurrentVal2                 200A
 
     D  SysVal3                      20A
     D  CurrentVal3                 200A
 
     D  SysVal4                      20A
     D  CurrentVal4                 200A
 
     D  SysVal5                      20A
     D  CurrentVal5                 200A
 
     D  SysVal6                      20A
     D  CurrentVal6                 200A
 
     D  SysVal7                      20A
     D  CurrentVal7                 200A
 
     D  SysVal8                      20A
     D  CurrentVal8                 200A
 
     D  SysVal9                      20A
     D  CurrentVal9                 200A
 
     D  SysVal10                     20A
     D  CurrentVal10                200A
 
     D*****************************************************************
     D* Prototype for procedure: GetMidasSysVal                       *
     D*****************************************************************
 
     D GetMidasSysVal  PR             7A
 
     D  SysVal1                      20A                    CONST
     D  CurrentVal1                 200A
 
     D  SysVal2                      20A   OPTIONS(*NOPASS) CONST
     D  CurrentVal2                 200A   OPTIONS(*NOPASS)
 
     D  SysVal3                      20A   OPTIONS(*NOPASS) CONST
     D  CurrentVal3                 200A   OPTIONS(*NOPASS)
 
     D  SysVal4                      20A   OPTIONS(*NOPASS) CONST
     D  CurrentVal4                 200A   OPTIONS(*NOPASS)
 
     D  SysVal5                      20A   OPTIONS(*NOPASS) CONST
     D  CurrentVal5                 200A   OPTIONS(*NOPASS)
 
     D  SysVal6                      20A   OPTIONS(*NOPASS) CONST
     D  CurrentVal6                 200A   OPTIONS(*NOPASS)
 
     D  SysVal7                      20A   OPTIONS(*NOPASS) CONST
     D  CurrentVal7                 200A   OPTIONS(*NOPASS)
 
     D  SysVal8                      20A   OPTIONS(*NOPASS) CONST
     D  CurrentVal8                 200A   OPTIONS(*NOPASS)
 
     D  SysVal9                      20A   OPTIONS(*NOPASS) CONST
     D  CurrentVal9                 200A   OPTIONS(*NOPASS)
 
     D  SysVal10                     20A   OPTIONS(*NOPASS) CONST
     D  CurrentVal10                200A   OPTIONS(*NOPASS)
 
     D*****************************************************************
