     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGSQLMOD                                                    *
/*EXI *  DATFMT(*ISO)                                                 *                     MD037445
/*EXI *  TEXT('Midas MM Drop records from T_GZDEAMEX per zone')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Module                                  *
      *                                                               *
      *  Midas MM Drop records from T_GZDEAMEX per zone               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *  Last Amend No. MD037445           Date 11May16               *
      *  Prev Amend No. CSF011             Date 12Sep11               *
      *                 AR828639           Date 13Sep11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 237113             Date 06Apr06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD037445 - Failed component SCC041119 00001 during COB run   *
      *  CSF011 - Customer Name on Inputs (Recompile)                 *
      *  AR828639 - MMEXDEAM compare (Recompile)                      *
      *  237113 - Drop records from extension file T_GZDEAMEX if not  *
      *           found in zone MMDEAMPP.                             *
      *                                                               *
      *****************************************************************
 
     D/COPY ZACPYSRC,STD_D_SPEC
     d t_gzdeamDS    e ds                  extname(V_EXDEAMG) prefix(m_)
 
     d sqlcmd          s          32000a   varying
     d apos            c                   const('''')
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
     C** Get Zone
     C                   EXSR      SRZONE
 
      ** The SELECT statement found here is similar to view V_EXDEAMG
      ** View V_EXDEAMG will list records not found on master file
      **    GZMMDEAMPP but on T_GZDEAMEX.
      ** Do note that V_EXDEAMG will not be accurate when one zone
      **    is running COB.
 
      /free
          sqlcmd = 'SELECT +
                    EX.ZONE, EX.DDDLNO, EX.DDVDAT, EX.DDDS38 +
                    FROM T_GZDEAMEX EX +
                    LEFT EXCEPTION JOIN V_MMDEAMPP PP ON +
                    EX.DDDLNO = PP.HNDA38 AND EX.DDDS38 = PP.HNDS38 +
                    AND EX.DDVDAT = PP.FHNDVSD AND EX.ZONE = PP.CUSTZONE +
                    WHERE EX.ZONE = ' + apos + O#ZONE + apos ;
      /end-free
 
     c/exec sql
     c+   whenever SQLERROR goto ERREX
     c/end-exec
 
     c/exec sql
     c+   declare mainCursor cursor
     c+     for mainStatement
     c/end-exec
 
     c/exec sql
     c+   prepare mainStatement
     c+     from :sqlcmd
     c/end-exec
 
     c/exec sql
     c+   open mainCursor
     c/end-exec
 
     c/exec sql
     c+   fetch next from mainCursor
     c+     into :t_gzdeamDS
     c/end-exec
 
      ** Delete records for the current zone only
 
     C                   DOW       sqlstt = '00000'
 
     c/exec sql
     c+   DELETE FROM T_GZDEAMEX
     c+          WHERE   ZONE = :m_ZONE AND DDDLNO = :m_DDDLNO AND
     c+              DDVDAT = :m_DDVDAT AND DDDS38 = :m_DDDS38 AND
     c+              ZONE = :O#ZONE
     c/end-exec
 
      ** Check for successful completion
     C                   If        SQLCOD <> 0
     C                   ExSR      *PSSR
     C                   EndIf
 
     c/exec sql
     c+   fetch next from mainCursor
     c+     into :t_gzdeamDS
     c/end-exec
 
     C                   ENDDO
 
     c/exec sql
     c+    close mainCursor
     c/end-exec
 
     C                   IF        1 = 0
     C     ERREX         TAG
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      *INLR = '1'
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRZONE - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRZONE        BEGSR
 
     C                   MOVEL     *BLANK        I#RTCD            7
     C                   MOVEL     *BLANK        I#ERMS           50
 
      ** Get Zone
 
     C                   CALL      'GOGETZONE'
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
 
      ** INPUTS
     C                   PARM      'N'           I#FULLCHECK       1
 
      ** OUTPUTS
     C                   PARM                    O#ZONE           10
     C                   PARM                    O#SHTC            4
     C                   PARM                    O#RDNB            5 0
     C                   PARM                    O#DNWD            5 0
     C                   PARM                    O#BCCY            3
     C                   PARM                    O#NJOB            1 0
 
      ** Error detected  (*PSSR will end the program)
 
     C     I#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN GOGETZONE'
     C                   EXSR      *PSSR
     C                   END
 
      ** No Zone
 
     C     O#ZONE        IFEQ      *BLANK
     C                   EVAL      I#ERMS = 'NO ZONE PRESENT'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
