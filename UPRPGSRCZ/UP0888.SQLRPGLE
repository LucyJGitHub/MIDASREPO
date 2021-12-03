     H DEBUG
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP Deliverable Data Split pgm for COB')
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade module                                       *
      *                                                               *
      *  UP0888 - Special program for DDS COB files                   *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. MD058986           Date 11Oct21               *
      *  Prev Amend No. MD055891 *CREATE   Date 01Sep20               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD058986 - Add Logical Delete for components and dependencies*
      *  MD055891 - Deliverable Data Split for COB                    *
      *                                                               *
      *****************************************************************
      *
      *
      *
      /EJECT
      * Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D CBDPRL        E DS                  EXTNAME(CBDPRBTD)
     D CBMEXC        E DS                  EXTNAME(CBMEXBTD)
     D CBMDCN        E DS                  EXTNAME(CBMDCBTD)

     D                 DS
     D  UNQNO                  1      3  0
     D  UNQNOA                 1      3

     D X_delta         S              3  0

     D                 DS
     D  UXQNO                  1      2  0
     D  UXQNOA                 1      2

     D X_xelta         S              2  0

      **************************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    DDSFile          10
     C                   PARM                    Error            10

     C                   If        DDSFILE = 'CBDPRCTD'
     C                   exsr      Sr_CBDPRL
     C                   ENDIF

     C                   If        DDSFILE = 'CBMEXCTD'
     C                   exsr      Sr_CBMEXC
     C                   ENDIF

     C                   If        DDSFILE = 'CBMDCCTD'
     C                   exsr      Sr_CBMDCN
     C                   ENDIF

     C                   SETON                                        LR
     C                   RETURN
      /SPACE 3
      *****************************************************************
     C     Sr_CBDPRL     BEGSR

      * read the Bespoke Dependency file by component/seq order by Unique No ascending
     C/EXEC SQL
     C+ declare ACursor insensitive scroll cursor for
     C+ select * from CBDPRBTD
     C+ order by DIDSON, DIDSOS, DIDRUN desc
     C/END-EXEC

     C/EXEC SQL
     C+ open ACursor
     C/END-EXEC

     C/EXEC SQL
     C+ fetch next from ACursor into :CBDPRL
     C/END-EXEC

     C                   If        SQLCODE = 0
     C                   MOVEL     DIDSON        DSON             10
     C                   MOVEL     DIDSOS        DSOS              5
      * set the highest Unique No to 999 by adding X_delta (999 - current DIDRUN)
      * and add X_delta to other component/seq
     C                   MOVEL     DIDRUN        UNQNOA
     C                   eval      X_delta = 999 - UNQNO

     C                   DOW       SQLCODE = 0

     C     DIDSON        IFEQ      DSON
     C     DIDSOS        ANDEQ     DSOS
     C                   MOVEL     DIDRUN        UNQNOA
     C                   eval      UNQNO = UNQNO + X_delta
     C/EXEC SQL
     C+ update CBDPRBTD set DIDRUN = :UNQNOA
     C+ where DIDSON = :DIDSON and DIDSOS = :DIDSOS and DIDRUN = :DIDRUN
     C+ and   DIDDON = :DIDDON and DIDDOS = :DIDDOS
     C/END-EXEC
     C                   IF        SQLCODE < 0
     C                   exsr      *PSSR
     C                   ENDIF
     C/EXEC SQL
     C+ update CBDPRXTD set DIDRUN = :UNQNOA
     C+ where DIDSON = :DIDSON and DIDSOS = :DIDSOS and DIDRUN = :DIDRUN
     C+ and   DIDDON = :DIDDON and DIDDOS = :DIDDOS
     C/END-EXEC
     C                   IF        SQLCODE < 0
     C                   exsr      *PSSR
     C                   ENDIF
     C                   else
      * set the highest Unique No to 999 by adding X_delta (999 - current DIDRUN)
      * and add X_delta to other component/seq
     C                   MOVEL     DIDRUN        UNQNOA
     C                   eval      X_delta = 999 - UNQNO
     C                   eval      UNQNO = UNQNO + X_delta
     C/EXEC SQL
     C+ update CBDPRBTD set DIDRUN = :UNQNOA
     C+ where DIDSON = :DIDSON and DIDSOS = :DIDSOS and DIDRUN = :DIDRUN
     C+ and   DIDDON = :DIDDON and DIDDOS = :DIDDOS
     C/END-EXEC
     C                   IF        SQLCODE < 0
     C                   exsr      *PSSR
     C                   ENDIF
     C/EXEC SQL
     C+ update CBDPRXTD set DIDRUN = :UNQNOA
     C+ where DIDSON = :DIDSON and DIDSOS = :DIDSOS and DIDRUN = :DIDRUN
     C+ and   DIDDON = :DIDDON and DIDDOS = :DIDDOS
     C/END-EXEC
     C                   IF        SQLCODE < 0
     C                   exsr      *PSSR
     C                   ENDIF
     C                   Endif

     C                   MOVEL     DIDSON        DSON
     C                   MOVEL     DIDSOS        DSOS

      * Read next record with matching key
     C/EXEC SQL
     C+ fetch next from ACursor into :CBDPRL
     C/END-EXEC

     C                   ENDDO
     C                   Endif

     C/EXEC SQL
     C+ close ACursor
     C/END-EXEC

     C                   ENDSR
      ********************************************************************
      /SPACE 3
      *****************************************************************
     C     Sr_CBMEXC     BEGSR

      * read the Bespoke Mutually Excl file by component/seq order by Unique No ascending
     C/EXEC SQL
     C+ declare BCursor insensitive scroll cursor for
     C+ select * from CBMEXBTD
     C+ order by DKCOTT, DKCSEQ, DKMEUN desc
     C/END-EXEC

     C/EXEC SQL
     C+ open BCursor
     C/END-EXEC

     C/EXEC SQL
     C+ fetch next from BCursor into :CBMEXC
     C/END-EXEC

     C                   If        SQLCODE = 0
     C                   MOVEL     DKCOTT        DSON             10
     C                   MOVEL     DKCSEQ        DSOS              5
      * set the highest Unique No to 99 by adding X_xelta (99 - current DKMEUN)
      * and add X_xelta to other component/seq
     C                   MOVEL     DKMEUN        UXQNOA
     C                   eval      X_xelta = 99 - UXQNO

     C                   DOW       SQLCODE = 0

     C     DKCOTT        IFEQ      DSON
     C     DKCSEQ        ANDEQ     DSOS
     C                   MOVEL     DKMEUN        UXQNOA
     C                   eval      UXQNO = UXQNO + X_xelta
     C/EXEC SQL
     C+ update CBMEXBTD set DKMEUN = :UXQNOA
     C+ where DKCOTT = :DKCOTT and DKCSEQ = :DKCSEQ and DKMEUN = :DKMEUN
     C+ and   DKMECN = :DKMECN and DKMECS = :DKMECS
     C/END-EXEC
     C                   IF        SQLCODE < 0
     C                   exsr      *PSSR
     C                   ENDIF
     C/EXEC SQL
     C+ update CBMEXXTD set DKMEUN = :UXQNOA
     C+ where DKCOTT = :DKCOTT and DKCSEQ = :DKCSEQ and DKMEUN = :DKMEUN
     C+ and   DKMECN = :DKMECN and DKMECS = :DKMECS
     C/END-EXEC
     C                   IF        SQLCODE < 0
     C                   exsr      *PSSR
     C                   ENDIF
     C                   else
      * set the highest Unique No to 99 by adding X_delta (99 - current DKMEUN)
      * and add X_xelta to other component/seq
     C                   MOVEL     DKMEUN        UXQNOA
     C                   eval      X_xelta = 99 - UXQNO
     C                   eval      UXQNO = UXQNO + X_xelta
     C/EXEC SQL
     C+ update CBMEXBTD set DKMEUN = :UXQNOA
     C+ where DKCOTT = :DKCOTT and DKCSEQ = :DKCSEQ and DKMEUN = :DKMEUN
     C+ and   DKMECN = :DKMECN and DKMECS = :DKMECS
     C/END-EXEC
     C                   IF        SQLCODE < 0
     C                   exsr      *PSSR
     C                   ENDIF
     C/EXEC SQL
     C+ update CBMEXXTD set DKMEUN = :UXQNOA
     C+ where DKCOTT = :DKCOTT and DKCSEQ = :DKCSEQ and DKMEUN = :DKMEUN
     C+ and   DKMECN = :DKMECN and DKMECS = :DKMECS
     C/END-EXEC
     C                   IF        SQLCODE < 0
     C                   exsr      *PSSR
     C                   ENDIF
     C                   Endif

     C                   MOVEL     DKCOTT        DSON
     C                   MOVEL     DKCSEQ        DSOS

      * Read next record with matching key
     C/EXEC SQL
     C+ fetch next from BCursor into :CBMEXC
     C/END-EXEC

     C                   ENDDO
     C                   Endif

     C/EXEC SQL
     C+ close BCursor
     C/END-EXEC

     C                   ENDSR
      ********************************************************************
      *****************************************************************
     C     Sr_CBMDCN     BEGSR                                                  ** *PSSR SR **

      * read the Module Conditions file by component/seq order by Unique No ascending
     C/EXEC SQL
     C+ declare CCursor insensitive scroll cursor for
     C+ select * from CBMDCBTD
     C+ order by DJCOTT, DJCSEQ, DJMCUN desc
     C/END-EXEC

     C/EXEC SQL
     C+ open CCursor
     C/END-EXEC

     C/EXEC SQL
     C+ fetch next from CCursor into :CBMDCN
     C/END-EXEC

     C                   If        SQLCODE = 0
     C                   MOVEL     DJCOTT        DSON             10
     C                   MOVEL     DJCSEQ        DSOS              5
      * set the highest Unique No to 99 by adding X_xelta (99 - current DJMCUN)
      * and add X_xelta to other component/seq
     C                   MOVEL     DJMCUN        UXQNOA
     C                   eval      X_xelta = 99 - UXQNO

     C                   DOW       SQLCODE = 0

     C     DJCOTT        IFEQ      DSON
     C     DJCSEQ        ANDEQ     DSOS
     C                   MOVEL     DJMCUN        UXQNOA
     C                   eval      UXQNO = UXQNO + X_xelta
     C/EXEC SQL
     C+ update CBMDCBTD set DJMCUN = :UXQNOA
     C+ where DJCOTT = :DJCOTT and DJCSEQ = :DJCSEQ and DJMCUN = :DJMCUN
     C/END-EXEC
     C                   IF        SQLCODE < 0
     C                   exsr      *PSSR
     C                   ENDIF
     C/EXEC SQL
     C+ update CBMDCXTD set DJMCUN = :UXQNOA
     C+ where DJCOTT = :DJCOTT and DJCSEQ = :DJCSEQ and DJMCUN = :DJMCUN
     C/END-EXEC
     C                   IF        SQLCODE < 0
     C                   exsr      *PSSR
     C                   ENDIF
     C                   else
      * set the highest Unique No to 99 by adding X_delta (99 - current DKMEUN)
      * and add X_xelta to other component/seq
     C                   MOVEL     DJMCUN        UXQNOA
     C                   eval      X_xelta = 99 - UXQNO
     C                   eval      UXQNO = UXQNO + X_xelta
     C/EXEC SQL
     C+ update CBMDCBTD set DJMCUN = :UXQNOA
     C+ where DJCOTT = :DJCOTT and DJCSEQ = :DJCSEQ and DJMCUN = :DJMCUN
     C/END-EXEC
     C                   IF        SQLCODE < 0
     C                   exsr      *PSSR
     C                   ENDIF
     C/EXEC SQL
     C+ update CBMDCXTD set DJMCUN = :UXQNOA
     C+ where DJCOTT = :DJCOTT and DJCSEQ = :DJCSEQ and DJMCUN = :DJMCUN
     C/END-EXEC
     C                   IF        SQLCODE < 0
     C                   exsr      *PSSR
     C                   ENDIF
     C                   Endif

     C                   MOVEL     DJCOTT        DSON
     C                   MOVEL     DJCSEQ        DSOS

      * Read next record with matching key
     C/EXEC SQL
     C+ fetch next from CCursor into :CBMDCN
     C/END-EXEC

     C                   ENDDO
     C                   Endif

     C/EXEC SQL
     C+ close CCursor
     C/END-EXEC


     C                   ENDSR
      ********************************************************************
      *****************************************************************
     C     *PSSR         BEGSR                                                  ** *PSSR SR **

     C                   EVAL      Error = '*Error'
     C                   DUMP

     C                   SETON                                        U7U8LR
     C                   RETURN

     C                   ENDSR
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2020
