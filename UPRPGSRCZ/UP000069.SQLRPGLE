     H DEBUG
     H COPYRIGHT('(c) Finastra International 2023')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP ADBU Script for LF rebuild')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade Module                                       *
      *                                                               *
      *  UP000069 - This program updates the new ORDER field in       *
      *             UPZORDTD based on the table UPZDEPTD.             *
      *                                                               *
      *  (c) Finastra International 2023                              *
      *                                                               *
      *  Last Amend No. MD060960 *CREATE     Date 16Jan23             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD060960 - Some dependents do not exist yet as their         *
      *             CRTDUPOBJ has not been executed yet. Fix is to    *
      *             rebuild the order.                                *
      *                                                               *
      *****************************************************************
     D SQLEOF          C                   Const( 100 )
     D SQLOK           C                   Const( 0 )
     D ERROR           S             10A
     D Sav_Fil         S             10A

     D Order_Ct        S              5  0
     D UPZDEP        E DS                  EXTNAME(UPZDEPTD)
       /EJECT
      *****************************************************************
      *                                                               *
      *  MAIN PROCESSING                                              *
      *                                                               *
      *****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    ERROR


      * Read the dependencies table
     C/exec SQL
     C+ declare CursorRdZ cursor for
     C+ select *
     C+ from UPZDEPTD a
     C+ where (UPLEVL = 0 and UPFLAG = 'D') or UPLEVL > 0
     C+ order by UPLEVL, UPFILD
     C/end-exec

     C/exec SQL
     C+ open CursorRdZ
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from CursorRdZ
     C+ into :UPZDEP
     C/end-exec


     C                   DOW       SQLCODE = 0

      ** skip if same field name is read
     C                   if        UPFILD <> Sav_Fil

     C                   eval      Order_Ct = Order_Ct + 1
      ** update
     C/exec SQL
     C+ update UPZORDTD set ORORDR = :Order_Ct
     C+ where ORFILE = :UPFILD
     C/end-exec

     C                   eval      Sav_Fil = UPFILD
     C                   endif

     C/exec SQL
     C+ fetch next
     C+ from CursorRdZ
     C+ into :UPZDEP
     C/end-exec

     C                   ENDDO


     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
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
      *
     C                   DUMP
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   EVAL      ERROR = '*Error'
      *
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
