     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas AO Customer Details by Country of Tax')
      *****************************************************************
      *                                                               *
      *  Midas - Access Objects                                       *
      *                                                               *
      *  AOACTXR0 - Customer Details by Country of Tax                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. CER069  *CREATE    Date 03Jul14               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CER069 - German Tax Enhancement                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of Indicators                                            *
      *                                                               *
      *       LR      LAST RECORD                                     *
      *       U7      DATABASE ERROR                                  *
      *       U8      DATABASE ERROR                                  *
      *                                                               *
      *****************************************************************
      *
     D SDACTX        E DS                  EXTNAME(SDACTXPD)
     D PRtcd           S              7
     D POptn           S              7
     D PCust           S              6
     D PBrca           S              3
     D WLCCD           S              3
     D WCTAX           S              2
     D WRun            S              1
 
     C     *ENTRY        PLIST
     C                   PARM                    PRtcd
     C                   PARM                    POptn
     C                   PARM                    PCust
     C                   PARM                    PBrca
     C                   PARM                    SDACTX
 
     C                   IF        POptn = '*FREE  '
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   IF        POptn = '*KEY   '
 
      ** Retrieve Branch Location Code
     C/EXEC SQL
     C+ Select  A8LCCD
     C+  into   :WLCCD
     C+  from   SDBRCHPD
     C+  where  A8BRCD = :PBrca
     C/END-EXEC
 
      ** Retrieve Country Code
     C/EXEC SQL
     C+ Select  DVCNCD
     C+  into   :WCTAX
     C+  from   SDLOCNPD
     C+  where  DVLCCD = :WLCCD
     C/END-EXEC
 
      ** Retrieve Customer by Country of Tax
     C/EXEC SQL
     C+ Select  *
     C+  into   :SDACTX
     C+  from   SDACTXPD
     C+  where  AXCUST = :PCust and
     C+         AXCTTX = :WCTAX
     C/END-EXEC
 
      ** No record found
     C                   IF        SQLCODE <> 0
     C                   EVAL      PRtcd = '*NRF   '
     C                   ENDIF
 
     C                   ENDIF
 
     C                   RETURN
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
