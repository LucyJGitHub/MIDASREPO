     H DEBUG
     H COPYRIGHT('(c) Finastra International 2022')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP CFTA insert record in UPCFTNTD')              *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP4034 - Midas UP CFTA insert record in UPCFTNTD             *
      *                                                               *
      *  (c) Finastra International Limited 2022                      *
      *                                                               *
      *  Last Amend No. MD059732 *CREATE   Date 18Aug22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD059732 - DDS improvements, report conflict only            *
      *           - Applied for MD-60291.                             *      
      *                                                               *
      *****************************************************************
     D/COPY ZACPYSRC,PSDS
      *****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    XFILE            10
     C                   PARM                    XCOUNT           10 0

     C/EXEC SQL
     C+ insert into UPCFTNTD
     C+ (
     C+   X_FILE
     C+  ,X_CFTN
     C+ )
     C+ Values
     C+ (
     C+   :XFILE
     C+  ,:XCOUNT
     C+ )
     C/END-EXEC

     C                   RETURN

      *****************************************************************
