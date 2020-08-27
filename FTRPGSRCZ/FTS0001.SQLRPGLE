     HDebug
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Add missing UDF records for FT:STP payments')
      *****************************************************************
      *                                                               *
      *  Midas - STP Functions                                        *
      *                                                               *
      *  FTS0001 - FT:STP payments - add UDF records                  *
      *                                                               *
      *  Function: For authorised FT:STP payments (IN and OP) add     *
      *            equivalent records to T_GZIPAYEX and T_GZOPAYEX    *
      *            respectively, if not found.                        *
      *                                                               *
      *  Component of: *None                                          *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. AR962605  *CREATE  Date 01May12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR962605 - Create UDF records for FT transactions from STP   *
      *             (Child: AR962606)                                 *
      *                                                               *
      *****************************************************************

      *****************************************************************

      * Entry parameters
     D P#ReturnCode    S              7A
     D P#PayReference  S             15A

      *****************************************************************

      * Work variable
     D Out_Zone        S             10A

      *****************************************************************
      * SQL Formats
     D nSPref          S             15A
     D nDDPref         S             15A
      *****************************************************************

     C     *Entry        PList
     C                   Parm                    P#Returncode
     C                   Parm                    P#PayReference

     C                   Eval      Out_Zone='LONDON'

      ** Depending on FT Payment Type

     C                   Select

      ** Outgoing Payments or Regular Payments

     C                   When      %Subst(P#PayReference:12:2) = 'OP' Or
     C                             %Subst(P#PayReference:12:2) = 'RP'
     C                   Exsr      SrOPay

      ** Incoming Payments

     C                   When      %Subst(P#PayReference:12:2) = 'IN'
     C                   Exsr      SrIPay
     C                   Endsl

     C                   Eval      *InLr = *On
     C                   Return
      *****************************************************************
     C     SrOPay        Begsr

     C                   Exsr      SrOpayExist

      ** If not found add

     C                   If        SqlCode <> 0
     C                   Exsr      SrInOPay
     C                   EndIf

      ** Always true

     C                   Eval      P#ReturnCode = 'T'

     C   U1              Dump

     C     ExOPay        Endsr
      *****************************************************************
     C     SrIPay        Begsr

     C                   Exsr      SrIPayExist

      ** If not found add

     C                   If        SqlCode <> 0
     C                   Exsr      SrInIPay
     C                   EndIf

      ** Always true

     C                   Eval      P#ReturnCode = 'T'

     C   U1              Dump

     C     ExIPay        Endsr
      *****************************************************************
     C     SrInOPay      Begsr

     C/Exec Sql
     C+
     C+  Insert Into T_GzOpayEx
     C+               (
     C+         Zone               ,
     C+         SPref
     C+               )
     C+         Values(
     C+         :Out_Zone               ,
     C+         :P#PayReference
     C+               )
     C+
     C/End-Exec

     C     ExInOPay      Endsr
      *****************************************************************
     C     SrOPayExist   Begsr

     C/Exec Sql
     C+
     C+  Select
     C+         SPref
     C+
     C+    Into
     C+        :nSPref
     C+
     C+  From T_GzOpayEx
     C+
     C+    Where SPref            = :P#PayReference
     C+      And Zone             = 'LONDON'
     C+
     C/End-Exec

     C     ExOPayExist   Endsr
      *****************************************************************
     C     SrIPayExist   Begsr

     C/Exec Sql
     C+
     C+  Select
     C+         DDPref
     C+
     C+    Into
     C+        :nDDPref
     C+
     C+  From T_GzIpayEx
     C+
     C+    Where DDPref           = :P#PayReference
     C+      And Zone             = 'LONDON'
     C+
     C/End-Exec

     C     ExIPayExist   Endsr
      *****************************************************************
     C     SrInIPay      Begsr

     C/Exec Sql
     C+
     C+  Insert Into T_GzIpayEx
     C+               (
     C+         Zone               ,
     C+         DDPref
     C+               )
     C+         Values(
     C+         :Out_Zone               ,
     C+         :P#PayReference
     C+               )
     C+
     C/End-Exec

     C     ExInIPay      Endsr
      *****************************************************************
