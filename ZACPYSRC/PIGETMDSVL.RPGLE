      *****************************************************************
      *                                                               *
      *  Midas - /COPY Member (RPG)                                   *
      *                                                               *
      *  PIGETMDSVL - AOSVALR0 Wrapper                                *
      *                                                               *
      *  Function:  This provides alternate interface for             *
      *             AOSVALR0 (optional parameters)                    *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CDL096  *CREATE    Date 22Sep14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *                                                               *
      *****************************************************************
 
     P*****************************************************************
     P* Procedure name: GetMidasSysVal                                *
     P* Purpose: Wrapper for AOSVALR0                                 *
     P*****************************************************************
 
     P GetMidasSysVal  B
     D GetMidasSysVal  PI             7A
 
     D  SysVal1                      20A   CONST
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
 
     D  PReturnCode    S              7A
     D  PSysVal        S             20A   Dim(10) Inz
     D  PCurVal        S            200A   Dim(10) Inz
 
     C* Override default parameters
 
     C                   If        %Parms >= 2
     C                   Eval      PsysVal(1) = SysVal1
     C                   Eval      PCurVal(1) = CurrentVal1
     C                   EndIf
 
     C                   If        %Parms >= 4
     C                   Eval      PsysVal(2) = SysVal2
     C                   Eval      PCurVal(2) = CurrentVal2
     C                   EndIf
     C
     C                   If        %Parms >= 6
     C                   Eval      PsysVal(3) = SysVal3
     C                   Eval      PCurVal(3) = CurrentVal3
     C                   EndIf
     C
     C                   If        %Parms >= 8
     C                   Eval      PsysVal(4) = SysVal4
     C                   Eval      PCurVal(4) = CurrentVal4
     C                   EndIf
     C
     C                   If        %Parms >= 10
     C                   Eval      PsysVal(5) = SysVal5
     C                   Eval      PCurVal(5) = CurrentVal5
     C                   EndIf
     C
     C                   If        %Parms >= 12
     C                   Eval      PsysVal(6) = SysVal6
     C                   Eval      PCurVal(6) = CurrentVal6
     C                   EndIf
     C
     C                   If        %Parms >= 14
     C                   Eval      PsysVal(7) = SysVal7
     C                   Eval      PCurVal(7) = CurrentVal7
     C                   EndIf
     C
     C                   If        %Parms >= 16
     C                   Eval      PsysVal(8) = SysVal8
     C                   Eval      PCurVal(8) = CurrentVal8
     C                   EndIf
     C
     C                   If        %Parms >= 18
     C                   Eval      PsysVal(9) = SysVal9
     C                   Eval      PCurVal(9) = CurrentVal9
     C                   EndIf
     C
     C                   If        %Parms >= 20
     C                   Eval      PsysVal(10) = SysVal10
     C                   Eval      PCurVal(10) = CurrentVal10
     C                   EndIf
 
     C                   CallP     RtvMidasSysVal( PReturnCode:
     C                                             PSysVal(1) :
     C                                             PCurVal(1) :
     C                                             PSysVal(2) :
     C                                             PCurVal(2) :
     C                                             PSysVal(3) :
     C                                             PCurVal(3) :
     C                                             PSysVal(4) :
     C                                             PCurVal(4) :
     C                                             PSysVal(5) :
     C                                             PCurVal(5) :
     C                                             PSysVal(6) :
     C                                             PCurVal(6) :
     C                                             PSysVal(7) :
     C                                             PCurVal(7) :
     C                                             PSysVal(8) :
     C                                             PCurVal(8) :
     C                                             PSysVal(9) :
     C                                             PCurVal(9) :
     C                                             PSysVal(10):
     C                                             PCurVal(10)   )
 
     C* Return retrieved values
 
     C                   If        %Parms >= 2
     C                   Eval      CurrentVal1 = PCurVal(1)
     C                   EndIf
 
     C                   If        %Parms >= 4
     C                   Eval      CurrentVal2 = PCurVal(2)
     C                   EndIf
     C
     C                   If        %Parms >= 6
     C                   Eval      CurrentVal3 = PCurVal(3)
     C                   EndIf
     C
     C                   If        %Parms >= 8
     C                   Eval      CurrentVal4 = PCurVal(4)
     C                   EndIf
     C
     C                   If        %Parms >= 10
     C                   Eval      CurrentVal5 = PCurVal(5)
     C                   EndIf
     C
     C                   If        %Parms >= 12
     C                   Eval      CurrentVal6 = PCurVal(6)
     C                   EndIf
     C
     C                   If        %Parms >= 14
     C                   Eval      CurrentVal7 = PCurVal(7)
     C                   EndIf
     C
     C                   If        %Parms >= 16
     C                   Eval      CurrentVal8 = PCurVal(8)
     C                   EndIf
     C
     C                   If        %Parms >= 18
     C                   Eval      CurrentVal9 = PCurVal(9)
     C                   EndIf
     C
     C                   If        %Parms >= 20
     C                   Eval      CurrentVal10 = PCurVal(10)
     C                   EndIf
 
     C                   RETURN    PReturnCode
 
     P                 E
     P*****************************************************************
