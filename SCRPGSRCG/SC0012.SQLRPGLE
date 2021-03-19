     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SC Midas information screen SysVal')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  SC0012 - Midas SC Midas information screen SysVal            *
      *                                                               *
      *                                                               *
      *  (c) Finastra International 2020                              *
      *                                                               *
      *  Last Amend No. MD056783   *CREATE   Date 22Sep20             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056783 - System Values helptext improvments                *
      *                                                               *
      *****************************************************************

     D MSG_Arr         S           1000
     D Strng70         DS
     D  St70                          1    DIM(70)
     D X_Line          S             70    DIM(15)

     D Ix              S              5  0
     D Iz              S              5  0
     D n               S              5  0
     D Stop            S              1

      /SPACE 3
      *
     D PSDS           SDS
      *
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  R_JOB                244    253
     D  R_USER               254    263


     **************************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    Line1            70
     C                   PARM                    Line2            70
     C                   PARM                    Line3            70
     C                   PARM                    Line4            70
     C                   PARM                    Line5            70
     C                   PARM                    Line6            70
     C                   PARM                    Line7            70
     C                   PARM                    Line8            70
     C                   PARM                    Line9            70
     C                   PARM                    Line10           70
     C                   PARM                    Line11           70
     C                   PARM                    Line12           70
     C                   PARM                    Line13           70
     C                   PARM                    Line14           70
     C                   PARM                    Line15           70
     C                   PARM                    MessageId      1000

     C                   eval      MSG_Arr = MessageId
     C                   eval      Stop = 'N'
     C                   eval      Ix = 1
     C                   eval      n  = 1

     C                   DOU       Stop = 'Y'
      * search for first blank backwards
     C                   eval      Strng70 = %subst(MSG_Arr:Ix:70)
     C                   If        Strng70 = *blanks
     C                   leave
     C                   Endif
     C                   eval      Iz = 70
     C                   DOW       St70(Iz) <> ' '
     C                             and Iz > 0
     C                   eval      Iz = Iz -1
     C                   ENDDO
     C                   eval      X_Line(n) = %subst(Strng70:1:Iz)
     C                   eval      n =n +1
     C                   eval      Ix = Ix + Iz
     C                   If        Iz = 0
     C                   eval      Stop = 'Y'
     C                   Endif
     C                   ENDDO

     C                   eval      Line1 = X_Line(1)
     C                   eval      Line2 = X_Line(2)
     C                   eval      Line3 = X_Line(3)
     C                   eval      Line4 = X_Line(4)
     C                   eval      Line5 = X_Line(5)
     C                   eval      Line6 = X_Line(6)
     C                   eval      Line7 = X_Line(7)
     C                   eval      Line8 = X_Line(8)
     C                   eval      Line9 = X_Line(9)
     C                   eval      Line10 = X_Line(10)
     C                   eval      Line11 = X_Line(11)
     C                   eval      Line12 = X_Line(12)
     C                   eval      Line13 = X_Line(13)
     C                   eval      Line14 = X_Line(14)
     C                   eval      Line15 = X_Line(15)

     C     ENDPGM        TAG

     C                   EVAL      *INLR = *ON
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **

     C                   DUMP

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
