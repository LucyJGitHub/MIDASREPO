     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
 **** *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Alpha Loan - Upgrade Program')
 **** *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00253 - SM Alpha Loan - Upgrade Program                   *
      *                                                               *
      *  Function:  This program will update the following files:     *
      *             MXEXFFPD, GZCLOANCL, GZLOAMSDK, GZLEFEED,         *
      *             GZLEFEEAD, CLOANHH, FACHISA, LEFHST, MCLONCL,     *
      *             CUTX2HP, LEFEAM, LENQ, LENQLND, LVENTEL, LEPDUFPD,*
      *             LEACCNPD, LEPDFHPD, LEPDLHPD, ISACT, XLEFEED,     *
      *             XLEFFEDQD, CLOANCL, LOAMSDK, XLEFHST, LEFEED,     *
      *             LEFEEDQD, LEFEEAD, XLEPDUFPD, LEACCFPD,           *
      *             LEACCTPD, LEPK1DPD, LEPK2DPD, LEPK3DPD, GTEESGT,  *
      *             GTREFGR, LEGUX1PD and LEGUX2PD.                   *
      *             Data Area LEALLO positions 1 to 8 to 'AAAAAAAA'.  *
      *             Update file PSTTOM so that for all records where  *
      *             LKRECI = 'F' the first position of field LKLNNO   *
      *             will be blank.                                    *
      *                                                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. AR1085447D         Date 29Mar13               *
      *  Prev Amend No. AR1085447          Date 06Feb13               *
      *                 AR1078292          Date 31Jan13               *
      *                 AR1056323          Date 14Nov12               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148   *CREATE   Date 23Jul12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1085447D- Update new fields in CLOANCL, remove from ALR    *
      *  AR1085447 - Update new fields in CLOANCL.                    *
      *  AR1078292 - Replace SMU006PD as driving file for alpha loan  *
      *              reference migration tool.                        *
      *  AR1056323 - Revert back changes of CLE134 for LKEY1DP and    *
      *              LKEYFED                                          *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  CLE148 - Alpha Loan Reference                                *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** | D-specs                              |
      ** | =======                              |
      ** +--------------------------------------+
     D LEALLO        E DS                  EXTNAME(LEALLO) DTAARA(LEALLO)
     D SQLSTRING       S          32000A   VARYING INZ
 
     D UpgDS           DS
     D  LNFILE                       10A
     D  LNFLDN                       10A
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Update MXEXFFPD
     C                   EVAL      SQLSTRING =
     C                             'UPDATE MXEXFFPD SET ' +
     C                             'WHFLDT= ''A'' WHERE WHFLDI IN' +
     C                             '(''LNRF'', ''FELOAN'', ''LNNO'') WITH NC'
     C/Exec SQL
     C+ EXECUTE IMMEDIATE :SQLSTRING
     C/End-Exec
 
      ** Update PSTTOM
     C                   EVAL      SQLSTRING =
     C                             'UPDATE PSTTOM SET ' +
     C                             'LKLNNO= '''' CONCAT SUBSTR(LKLNNO,2,5)' +
     C                             'WHERE LKRECI = ''F'' WITH NC'
     C/Exec SQL
     C+ EXECUTE IMMEDIATE :SQLSTRING
     C/End-Exec
 
      ** Update GZCLOANCL
     C                   EVAL      SQLSTRING =
     C                             'UPDATE GZCLOANCL SET ' +
     C                             'LNRF= '''' WHERE LNRF= ''000000'' '+
     C                             ' WITH NC'
     C
     C/Exec SQL
     C+ EXECUTE IMMEDIATE :SQLSTRING
     C/End-Exec
     C                   EVAL      SQLSTRING =
     C                             'UPDATE GZCLOANCL SET ' +
     C                             'MLNR='''' WHERE MLNR=''000000'' ' +
     C                             ' WITH NC'
     C/Exec SQL
     C+ EXECUTE IMMEDIATE :SQLSTRING
     C/End-Exec
     C                   EVAL      SQLSTRING =
     C                             'UPDATE GZCLOANCL SET ' +
     C                             'TOLN='''' WHERE TOLN= ''000000'' '+
     C                             ' WITH NC'
     C/Exec SQL
     C+ EXECUTE IMMEDIATE :SQLSTRING
     C/End-Exec
 
      ** Update GZLOAMSDK
     C                   EVAL      SQLSTRING =
     C                             'UPDATE GZLOAMSDK SET ' +
     C                             'RLON='''' WHERE RLON=''000000'' '+
     C                             ' WITH NC'
     C/Exec SQL
     C+ EXECUTE IMMEDIATE :SQLSTRING
     C/End-Exec
     C                   EVAL      SQLSTRING =
     C                             'UPDATE GZLOAMSDK SET ' +
     C                             'ROLN='''' WHERE ROLN=''000000'' '+
     C                             ' WITH NC'
     C/Exec SQL
     C+ EXECUTE IMMEDIATE :SQLSTRING
     C/End-Exec
 
      ** Update GZLEFEED
     C                   EVAL      SQLSTRING =
     C                             'UPDATE GZLEFEED SET ' +
     C                             'FELOAN ='''' WHERE FELOAN =' +
     C                             ' ''000000'' WITH NC'
     C/Exec SQL
     C+ EXECUTE IMMEDIATE :SQLSTRING
     C/End-Exec
     C                   EVAL      SQLSTRING =
     C                             'UPDATE GZLEFEED SET ' +
     C                             'FEPLNR ='''' WHERE FEPLNR =' +
     C                             ' ''000000'' WITH NC'
     C/Exec SQL
     C+ EXECUTE IMMEDIATE :SQLSTRING
     C/End-Exec
 
      ** Update GZLEFEEAD
     C**********         EVAL      SQLSTRING =                                                CLE134
     C**********                   'UPDATE GZLEFEEAD SET ' +                                  CLE134
     C**********                   'FALOAN ='''' WHERE FELOAN =' +                            CLE134
     C**********                   ' ''000000'' WITH NC'                                      CLE134
     C                   EVAL      SQLSTRING =                                                CLE134
     C                             'UPDATE GZLEFEEAD SET ' +                                  CLE134
     C                             'FALOAN ='''' WHERE FALOAN =' +                            CLE134
     C                             ' ''000000'' WITH NC'                                      CLE134
     C/Exec SQL
     C+ EXECUTE IMMEDIATE :SQLSTRING
     C/End-Exec
 
      ** Update CLOANHH
     C                   EVAL      SQLSTRING =
     C                             'UPDATE CLOANHH SET ' +
     C                             'LNRF ='''' WHERE LNRF =' +
     C                             ' ''000000'' WITH NC'
     C/Exec SQL
     C+ EXECUTE IMMEDIATE :SQLSTRING
     C/End-Exec
 
      ** Update FACHISA
     C                   EVAL      SQLSTRING =
     C                             'UPDATE FACHISA SET ' +
     C                             'FALOAN ='''' WHERE FALOAN=' +
     C                             ' ''000000'' WITH NC'
     C/Exec SQL
     C+ EXECUTE IMMEDIATE :SQLSTRING
     C/End-Exec
 
      ** Update LEFHST
     C                   EVAL      SQLSTRING =
     C                             'UPDATE LEFHST SET ' +
     C                             'HILNRF ='''' WHERE HILNRF=' +
     C                             ' ''000000'' WITH NC'
     C/Exec SQL
     C+ EXECUTE IMMEDIATE :SQLSTRING
     C/End-Exec
 
      ** Update MCLONCL
     C                   EVAL      SQLSTRING =
     C                             'UPDATE MCLONCL SET' +
     C                             'LNRF ='''' WHERE LNRF=' +
     C                             ' ''000000'' WITH NC'
     C/Exec SQL
     C+ EXECUTE IMMEDIATE :SQLSTRING
     C/End-Exec
     C                   EVAL      SQLSTRING =
     C                             'UPDATE MCLONCL SET' +
     C                             'MLNRF ='''' WHERE MLNRF=' +
     C                             ' ''000000'' WITH NC'
     C/Exec SQL
     C+ EXECUTE IMMEDIATE :SQLSTRING
     C/End-Exec
     C                   EVAL      SQLSTRING =
     C                             'UPDATE MCLONCL SET' +
     C                             'OLNRF ='''' WHERE OLNRF=' +
     C                             ' ''000000'' WITH NC'
     C/Exec SQL
     C+ EXECUTE IMMEDIATE :SQLSTRING
     C/End-Exec
     C                   EVAL      SQLSTRING =
     C                             'UPDATE MCLONCL SET' +
     C                             'TOLN ='''' WHERE TOLN=' +
     C                             ' ''000000'' WITH NC'
     C/Exec SQL
     C+ EXECUTE IMMEDIATE :SQLSTRING
     C/End-Exec
 
      ** Update CUTX2HP
     C                   EVAL      SQLSTRING =
     C                             'UPDATE CUTX2HP SET' +
     C                             'LNRF ='''' WHERE LNRF=' +
     C                             ' ''000000'' WITH NC'
     C/Exec SQL
     C+ EXECUTE IMMEDIATE :SQLSTRING
     C/End-Exec
 
      ** Update LEFEAM
     C                   EVAL      SQLSTRING =
     C                             'UPDATE LEFEAM SET' +
     C                             'FELOAN ='''' WHERE FELOAN=' +
     C                             ' ''000000'' WITH NC'
     C/Exec SQL
     C+ EXECUTE IMMEDIATE :SQLSTRING
     C/End-Exec
 
      ** Update LENQ
     C                   EVAL      SQLSTRING =
     C                             'UPDATE LENQ SET' +
     C                             'NQLNRF ='''' WHERE NQLNRF=' +
     C                             ' ''000000 WITH NC'
     C/Exec SQL
     C+ EXECUTE IMMEDIATE :SQLSTRING
     C/End-Exec
 
      ** Update LENQLND
     C                   EVAL      SQLSTRING =
     C                             'UPDATE LENQ SET' +
     C                             'QLLNRF ='''' WHERE QLLNRF=' +
     C                             ' ''000000'' WITH NC'
     C/Exec SQL
     C+ EXECUTE IMMEDIATE :SQLSTRING
     C/End-Exec
 
      ** Update LVENTEL
     C                   EVAL      SQLSTRING =
     C                             'UPDATE LVENTEL SET' +
     C                             'LNRF ='''' WHERE LNRF=' +
     C                             ' ''000000'' WITH NC'
     C/Exec SQL
     C+ EXECUTE IMMEDIATE :SQLSTRING
     C/End-Exec
 
      ** Update LEPDUFPD
     C                   EVAL      SQLSTRING =
     C                             'UPDATE LEPDUFPD SET ' +
     C                             'YPLON ='''' WHERE YPLON =' +
     C                             ' ''000000'' WITH NC'
     C/Exec SQL
     C+ EXECUTE IMMEDIATE :SQLSTRING
     C/End-Exec
     C                   IF         SQLCOD < 0 AND SQLCOD <> -204
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      SQLSTRING =
     C                             'UPDATE LEPDUFPD SET ' +
     C                             'YPORG ='''' WHERE YPORG =' +
     C                             ' ''000000'' WITH NC'
     C/Exec SQL
     C+ EXECUTE IMMEDIATE :SQLSTRING
     C/End-Exec
     C                   IF         SQLCOD < 0 AND SQLCOD <> -204
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Update LEACCNPD
     C                   EVAL      SQLSTRING =
     C                             'UPDATE LEACCNPD SET ' +
     C                             'RPLNRF ='''' WHERE RPLNRF =' +
     C                             ' ''000000'' WITH NC'
     C/Exec SQL
     C+ EXECUTE IMMEDIATE :SQLSTRING
     C/End-Exec
     C                   IF         SQLCOD < 0 AND SQLCOD <> -204
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      SQLSTRING =
     C                             'UPDATE LEACCNPD SET ' +
     C                             'RPFLNR ='''' WHERE RPFLNR =' +
     C                             ' ''000000'' WITH NC'
     C/Exec SQL
     C+ EXECUTE IMMEDIATE :SQLSTRING
     C/End-Exec
     C                   IF         SQLCOD < 0 AND SQLCOD <> -204
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Update LEPDFHPD
     C                   EVAL      SQLSTRING =
     C                             'UPDATE LEPDFHPD SET ' +
     C                             'YPORG ='''' WHERE YPORG =' +
     C                             ' ''000000'' WITH NC'
     C/Exec SQL
     C+ EXECUTE IMMEDIATE :SQLSTRING
     C/End-Exec
     C                   IF         SQLCOD < 0 AND SQLCOD <> -204
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      SQLSTRING =
     C                             'UPDATE LEPDFHPD SET ' +
     C                             'YPLON ='''' WHERE YPLON =' +
     C                             ' ''000000'' WITH NC'
     C/Exec SQL
     C+ EXECUTE IMMEDIATE :SQLSTRING
     C/End-Exec
     C                   IF         SQLCOD < 0 AND SQLCOD <> -204
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Update LEPDLHPD
     C                   EVAL      SQLSTRING =
     C                             'UPDATE LEPDLHPD SET ' +
     C                             'YPORG ='''' WHERE YPORG =' +
     C                             ' ''000000'' WITH NC'
     C/Exec SQL
     C+ EXECUTE IMMEDIATE :SQLSTRING
     C/End-Exec
     C                   IF         SQLCOD < 0 AND SQLCOD <> -204
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      SQLSTRING =
     C                             'UPDATE LEPDLHPD SET ' +
     C                             'YPLON ='''' WHERE YPLON =' +
     C                             ' ''000000'' WITH NC'
     C/Exec SQL
     C+ EXECUTE IMMEDIATE :SQLSTRING
     C/End-Exec
     C                   IF         SQLCOD < 0 AND SQLCOD <> -204
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Update XHISACT
     C                   EVAL      SQLSTRING =
     C                             'UPDATE XHISACT SET ' +
     C                             'HALOAN ='''' WHERE HALOAN =' +
     C                             ' ''000000'' WITH NC'
     C/Exec SQL
     C+ EXECUTE IMMEDIATE :SQLSTRING
     C/End-Exec
 
      ** Update XLEFEED
     C                   EVAL      SQLSTRING =
     C                             'UPDATE XLEFEED SET ' +
     C                             'FELOAN ='''' WHERE FELOAN =' +
     C                             ' ''000000'' WITH NC'
     C/Exec SQL
     C+ EXECUTE IMMEDIATE :SQLSTRING
     C/End-Exec
     C                   EVAL      SQLSTRING =
     C                             'UPDATE XLEFEED SET ' +
     C                             'FEPLNR ='''' WHERE FEPLNR =' +
     C                             ' ''000000'' WITH NC'
     C/Exec SQL
     C+ EXECUTE IMMEDIATE :SQLSTRING
     C/End-Exec
 
      ** Update XLEFEEDQD
     C                   EVAL      SQLSTRING =
     C                             'UPDATE XLEFEEDQD SET' +
     C                             'FQLOAN ='''' WHERE FQLOAN =' +
     C                             ' ''000000'' WITH NC'
     C/Exec SQL
     C+ EXECUTE IMMEDIATE :SQLSTRING
     C/End-Exec
 
      ** Update CLOANCL
     C                   EVAL      SQLSTRING =
     C                             'UPDATE CLOANCL SET' +
     C                             'LNRF ='''' WHERE LNRF =' +
     C                             ' ''000000'' WITH NC'
     C/Exec SQL
     C+ EXECUTE IMMEDIATE :SQLSTRING
     C/End-Exec
     C                   EVAL      SQLSTRING =
     C                             'UPDATE CLOANCL SET' +
     C                             'MLNR ='''' WHERE MLNR =' +
     C                             ' ''000000'' WITH NC'
     C/Exec SQL
     C+ EXECUTE IMMEDIATE :SQLSTRING
     C/End-Exec
     C                   EVAL      SQLSTRING =
     C                             'UPDATE CLOANCL SET' +
     C                             'TOLN ='''' WHERE TOLN =' +
     C                             ' ''000000'' WITH NC'
     C/Exec SQL
     C+ EXECUTE IMMEDIATE :SQLSTRING
     C/End-Exec
 
      ** Update LOAMSDK
     C                   EVAL      SQLSTRING =
     C                             'UPDATE LOAMSDK SET' +
     C                             'RLON ='''' WHERE RLON =' +
     C                             ' ''000000'' WITH NC'
     C/Exec SQL
     C+ EXECUTE IMMEDIATE :SQLSTRING
     C/End-Exec
     C                   EVAL      SQLSTRING =
     C                             'UPDATE LOAMSDK SET' +
     C                             'ROLN ='''' WHERE ROLN =' +
     C                             ' ''000000'' WITH NC'
     C/Exec SQL
     C+ EXECUTE IMMEDIATE :SQLSTRING
     C/End-Exec
 
      ** Update XLEFHST
     C                   EVAL      SQLSTRING =
     C                             'UPDATE XLEFHST SET' +
     C                             'HILNRF ='''' WHERE HILNRF =' +
     C                             ' ''000000'' WITH NC'
     C/Exec SQL
     C+ EXECUTE IMMEDIATE :SQLSTRING
     C/End-Exec
 
      ** Update LEFEED
     C                   EVAL      SQLSTRING =
     C                             'UPDATE LEFEED SET ' +
     C                             'FELOAN ='''' WHERE FELOAN =' +
     C                             ' ''000000'' WITH NC'
     C/Exec SQL
     C+ EXECUTE IMMEDIATE :SQLSTRING
     C/End-Exec
     C                   EVAL      SQLSTRING =
     C                             'UPDATE LEFEED SET ' +
     C                             'FEPLNR ='''' WHERE FEPLNR =' +
     C                             ' ''000000'' WITH NC'
     C/Exec SQL
     C+ EXECUTE IMMEDIATE :SQLSTRING
     C/End-Exec
 
      ** Update LEFEEDQD
     C                   EVAL      SQLSTRING =
     C                             'UPDATE LEFEEDQD SET' +
     C                             'FQLOAN ='''' WHERE FQLOAN =' +
     C                             ' ''000000'' WITH NC'
     C/Exec SQL
     C+ EXECUTE IMMEDIATE :SQLSTRING
     C/End-Exec
 
      ** Update LEFEEAD
     C                   EVAL      SQLSTRING =
     C                             'UPDATE LEFEEAD SET' +
     C                             'FALOAN ='''' WHERE FALOAN =' +
     C                             ' ''000000'' WITH NC'
     C/Exec SQL
     C+ EXECUTE IMMEDIATE :SQLSTRING
     C/End-Exec
 
      ** Update XLEPDUFPD
     C                   EVAL      SQLSTRING =
     C                             'UPDATE XLEPDUFPD SET ' +
     C                             'YPLON ='''' WHERE YPLON =' +
     C                             ' ''000000'' WITH NC'
 
     C/Exec SQL
     C+ EXECUTE IMMEDIATE :SQLSTRING
     C/End-Exec
     C                   IF         SQLCOD < 0 AND SQLCOD <> -204
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C**********         EVAL      SQLSTRING =                                                CLE134
     C**********                   'UPDATE GZLEFEEAD SET ' +                                  CLE134
     C**********                   'YPORG ='''' WHERE YPORG =' +                              CLE134
     C**********                   ' ''000000'' WITH NC'                                      CLE134
     C***/Exec SQL                                                                            CLE134
     C***+  EXECUTE IMMEDIATE :SQLSTRING                                                      CLE134
     C***/End-Exec                                                                            CLE134
     C**********         IF         SQLCOD < 0 AND SQLCOD <> -204                             CLE134
     C**********         EXSR      *PSSR                                                      CLE134
     C**********         ENDIF                                                                CLE134
 
      ** File LEACCFPD
     C                   EVAL      SQLSTRING =
     C                             'UPDATE LEACCFPD SET SELNRF = ' +
     C                             'CASE ' +
     C                              'WHEN QQSELN = 0 THEN '' '' ELSE ' +
     C                              'CONCAT(' +
     C                                    'CASE LENGTH(TRIM(CHAR(QQSELN))) ' +
     C                                      'WHEN 1 THEN ''00000'' ' +
     C                                      'WHEN 2 THEN ''0000'' ' +
     C                                      'WHEN 3 THEN ''000'' ' +
     C                                      'WHEN 4 THEN ''00'' ' +
     C                                      'WHEN 5 THEN ''0'' ' +
     C                                      'ELSE '''' ' +
     C                                     'END, ' +
     C                                     'TRIM(CHAR(QQSELN))) ' +
     C                             'END, QQSELN = 0'
     C/Exec SQL
     C+ Execute Immediate :SQLSTRING
     C/End-Exec
     C                   IF         SQLCOD < 0 AND SQLCOD <> -204
     C                   EXSR      *PSSR
     C                   EndIf
 
      ***File*EDLKY1PD                                                              CLE134 AR1056323
     C**********         EVAL      SQLSTRING =                                      CLE134 AR1056323
     C**********                   'UPDATE EDLKY1PD SET LNNO = ' +                  CLE134 AR1056323
     C**********                   'CASE ' +                                        CLE134 AR1056323
     C**********                    'WHEN QQLNNO = 0 THEN '' '' ELSE ' +            CLE134 AR1056323
     C**********                    'CONCAT(' +                                     CLE134 AR1056323
     C**********                          'CASE LENGTH(TRIM(CHAR(QQLNNO))) ' +      CLE134 AR1056323
     C**********                            'WHEN 1 THEN ''00000'' ' +              CLE134 AR1056323
     C**********                            'WHEN 2 THEN ''0000'' ' +               CLE134 AR1056323
     C**********                            'WHEN 3 THEN ''000'' ' +                CLE134 AR1056323
     C**********                            'WHEN 4 THEN ''00'' ' +                 CLE134 AR1056323
     C**********                            'WHEN 5 THEN ''0'' ' +                  CLE134 AR1056323
     C**********                            'ELSE '''' ' +                          CLE134 AR1056323
     C**********                           'END, ' +                                CLE134 AR1056323
     C**********                           'TRIM(CHAR(QQLNNO))) ' +                 CLE134 AR1056323
     C**********                   'END, QQLNNO = 0'                                CLE134 AR1056323
     C***/Exec SQL                                                                  CLE134 AR1056323
     C***+ Execute Immediate :SQLSTRING                                             CLE134 AR1056323
     C***/End-Exec                                                                  CLE134 AR1056323
                                                                                    CLE134 AR1056323
     C**********         IF         SQLCOD < 0 AND SQLCOD <> -204                   CLE134 AR1056323
     C**********         EXSR      *PSSR                                            CLE134 AR1056323
     C**********         ENDIF                                                      CLE134 AR1056323
                                                                                              CLE134
      ** File LEIFEEPD                                                                        CLE134
     C                   EVAL      SQLSTRING =                                                CLE134
     C                             'UPDATE LEIFEEPD SET FLNRF = ' +                           CLE134
     C                             'CASE ' +                                                  CLE134
     C                              'WHEN QQLNRF = 0 THEN '' '' ELSE ' +                      CLE134
     C                              'CONCAT(' +                                               CLE134
     C                                    'CASE LENGTH(TRIM(CHAR(QQLNRF))) ' +                CLE134
     C                                      'WHEN 1 THEN ''00000'' ' +                        CLE134
     C                                      'WHEN 2 THEN ''0000'' ' +                         CLE134
     C                                      'WHEN 3 THEN ''000'' ' +                          CLE134
     C                                      'WHEN 4 THEN ''00'' ' +                           CLE134
     C                                      'WHEN 5 THEN ''0'' ' +                            CLE134
     C                                      'ELSE '''' ' +                                    CLE134
     C                                     'END, ' +                                          CLE134
     C                                     'TRIM(CHAR(QQLNRF))) ' +                           CLE134
     C                             'END, QQLNRF = 0'                                          CLE134
     C/Exec SQL                                                                               CLE134
     C+ Execute Immediate :SQLSTRING                                                          CLE134
     C/End-Exec                                                                               CLE134
     C                   IF         SQLCOD < 0 AND SQLCOD <> -204                             CLE134
     C                   EXSR      *PSSR                                                      CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      ** File LEVECLX1PD                                                                      CLE134
     C                   EVAL      SQLSTRING =                                                CLE134
     C                             'UPDATE LEVECLX1PD SET LEKLNRF = ' +                       CLE134
     C                             'CASE ' +                                                  CLE134
     C                              'WHEN QQLNRF = 0 THEN '' '' ELSE ' +                      CLE134
     C                              'CONCAT(' +                                               CLE134
     C                                    'CASE LENGTH(TRIM(CHAR(QQLNRF))) ' +                CLE134
     C                                      'WHEN 1 THEN ''00000'' ' +                        CLE134
     C                                      'WHEN 2 THEN ''0000'' ' +                         CLE134
     C                                      'WHEN 3 THEN ''000'' ' +                          CLE134
     C                                      'WHEN 4 THEN ''00'' ' +                           CLE134
     C                                      'WHEN 5 THEN ''0'' ' +                            CLE134
     C                                      'ELSE '''' ' +                                    CLE134
     C                                     'END, ' +                                          CLE134
     C                                     'TRIM(CHAR(QQLNRF))) ' +                           CLE134
     C                             'END, QQLNRF = 0'                                          CLE134
     C/Exec SQL                                                                               CLE134
     C+ Execute Immediate :SQLSTRING                                                          CLE134
     C/End-Exec                                                                               CLE134
     C                   IF         SQLCOD < 0 AND SQLCOD <> -204                             CLE134
     C                   EXSR      *PSSR                                                      CLE134
     C                   ENDIF                                                                CLE134
 
      ** File LEACCTPD
     C                   EVAL      SQLSTRING =
     C                             'UPDATE LEACCTPD SET SELNRF = ' +
     C                             'CASE ' +
     C                              'WHEN QQSELN = 0 THEN '' '' ELSE ' +
     C                              'CONCAT(' +
     C                                    'CASE LENGTH(TRIM(CHAR(QQSELN))) ' +
     C                                      'WHEN 1 THEN ''00000'' ' +
     C                                      'WHEN 2 THEN ''0000'' ' +
     C                                      'WHEN 3 THEN ''000'' ' +
     C                                      'WHEN 4 THEN ''00'' ' +
     C                                      'WHEN 5 THEN ''0'' ' +
     C                                      'ELSE '''' ' +
     C                                     'END, ' +
     C                                     'TRIM(CHAR(QQSELN))) ' +
     C                             'END, QQSELN = 0'
     C/Exec SQL
     C+ Execute Immediate :SQLSTRING
     C/End-Exec
     C                   IF         SQLCOD < 0 AND SQLCOD <> -204
     C                   EXSR      *PSSR
     C                   ENDIF
      ***File*LEPK1DPD                                                                     AR1056323
     C**********         EVAL      SQLSTRING =                                             AR1056323
     C**********                   'UPDATE LEPK1DPD SET SELNRF = ' +                       AR1056323
     C**********                   'CASE ' +                                               AR1056323
     C**********                    'WHEN QQSELN = 0 THEN '' '' ELSE ' +                   AR1056323
     C**********                    'CONCAT(' +                                            AR1056323
     C**********                          'CASE LENGTH(TRIM(CHAR(QQSELN))) ' +             AR1056323
     C**********                            'WHEN 1 THEN ''00000'' ' +                     AR1056323
     C**********                            'WHEN 2 THEN ''0000'' ' +                      AR1056323
     C**********                            'WHEN 3 THEN ''000'' ' +                       AR1056323
     C**********                            'WHEN 4 THEN ''00'' ' +                        AR1056323
     C**********                            'WHEN 5 THEN ''0'' ' +                         AR1056323
     C**********                            'ELSE '''' ' +                                 AR1056323
     C**********                           'END, ' +                                       AR1056323
     C**********                           'TRIM(CHAR(QQSELN))) ' +                        AR1056323
     C**********                   'END, QQSELN = 0'                                       AR1056323
     C***/Exec*SQL                                                                         AR1056323
     C***+*Execute*Immediate*:SQLSTRING                                                    AR1056323
     C***/End-Exec                                                                         AR1056323
     C**********         IF         SQLCOD < 0 AND SQLCOD <> -204                          AR1056323
     C**********         EXSR      *PSSR                                                   AR1056323
     C**********         ENDIF                                                             AR1056323
      ***File*LEPK2DPD                                                                     AR1056323
     C**********         EVAL      SQLSTRING =                                             AR1056323
     C**********                   'UPDATE LEPK2DPD SET SELNRF = ' +                       AR1056323
     C**********                   'CASE ' +                                               AR1056323
     C**********                    'WHEN QQSELN = 0 THEN '' '' ELSE ' +                   AR1056323
     C**********                    'CONCAT(' +                                            AR1056323
     C**********                          'CASE LENGTH(TRIM(CHAR(QQSELN))) ' +             AR1056323
     C**********                            'WHEN 1 THEN ''00000'' ' +                     AR1056323
     C**********                            'WHEN 2 THEN ''0000'' ' +                      AR1056323
     C**********                            'WHEN 3 THEN ''000'' ' +                       AR1056323
     C**********                            'WHEN 4 THEN ''00'' ' +                        AR1056323
     C**********                            'WHEN 5 THEN ''0'' ' +                         AR1056323
     C**********                            'ELSE '''' ' +                                 AR1056323
     C**********                           'END, ' +                                       AR1056323
     C**********                           'TRIM(CHAR(QQSELN))) ' +                        AR1056323
     C**********                   'END, QQSELN = 0'                                       AR1056323
     C***/Exec*SQL                                                                         AR1056323
     C***+*Execute*Immediate*:SQLSTRING                                                    AR1056323
     C***/End-Exec                                                                         AR1056323
     C**********         IF         SQLCOD < 0 AND SQLCOD <> -204                          AR1056323
     C**********         EXSR      *PSSR                                                   AR1056323
     C**********         ENDIF                                                             AR1056323
      ***File*LEPK3DPD                                                                     AR1056323
     C**********         EVAL      SQLSTRING =                                             AR1056323
     C**********                   'UPDATE LEACCFPD SET SELNRF = ' +                       AR1056323
     C**********                   'CASE ' +                                               AR1056323
     C**********                    'WHEN QQSELN = 0 THEN '' '' ELSE ' +                   AR1056323
     C**********                    'CONCAT(' +                                            AR1056323
     C**********                          'CASE LENGTH(TRIM(CHAR(QQSELN))) ' +             AR1056323
     C**********                            'WHEN 1 THEN ''00000'' ' +                     AR1056323
     C**********                            'WHEN 2 THEN ''0000'' ' +                      AR1056323
     C**********                            'WHEN 3 THEN ''000'' ' +                       AR1056323
     C**********                            'WHEN 4 THEN ''00'' ' +                        AR1056323
     C**********                            'WHEN 5 THEN ''0'' ' +                         AR1056323
     C**********                            'ELSE '''' ' +                                 AR1056323
     C**********                           'END, ' +                                       AR1056323
     C**********                           'TRIM(CHAR(QQSELN))) ' +                        AR1056323
     C**********                   'END, QQSELN = 0'                                       AR1056323
     C***/Exec*SQL                                                                         AR1056323
     C***+*Execute*Immediate*:SQLSTRING                                                    AR1056323
     C***/End-Exec                                                                         AR1056323
     C**********         IF         SQLCOD < 0 AND SQLCOD <> -204                          AR1056323
     C**********         EXSR      *PSSR                                                   AR1056323
     C**********         ENDIF                                                             AR1056323
 
      ** Update GTEESGT
     C                   EVAL      SQLSTRING =
     C                             'UPDATE GTEESGT SET ' +
     C                             'FCLN = ''''  CONCAT SUBSTR(FCLN,2,5)'+
     C                             'WHERE SUBSTR(FCLN,1,1) = ''F'' WITH NC'
 
     C/Exec SQL
     C+ EXECUTE IMMEDIATE :SQLSTRING
     C/End-Exec
 
      ** Update GTREFGR
     C                   EVAL      SQLSTRING =
     C                             'UPDATE GTREFGR SET ' +
     C                             'FCLN = ''''  CONCAT SUBSTR(FCLN,2,5)'+
     C                             'WHERE SUBSTR(FCLN,1,1) = ''F'' WITH NC'
 
     C/Exec SQL
     C+ EXECUTE IMMEDIATE :SQLSTRING
     C/End-Exec
 
      ** Update LEGUX1PD
     C                   EVAL      SQLSTRING =
     C                             'UPDATE LEGUX1PD SET ' +
     C                             'FCLN = ''''  CONCAT SUBSTR(FCLN,2,5)'+
     C                             'WHERE SUBSTR(FCLN,1,1) = ''F'' WITH NC'
 
     C/Exec SQL
     C+ EXECUTE IMMEDIATE :SQLSTRING
     C/End-Exec
 
      ** Update LEGUX2PD
     C                   EVAL      SQLSTRING =
     C                             'UPDATE LEGUX2PD SET ' +
     C                             'FCLN = ''''  CONCAT SUBSTR(FCLN,2,5)'+
     C                             'WHERE SUBSTR(FCLN,1,1) = ''F'' WITH NC'
 
     C/Exec SQL
     C+ EXECUTE IMMEDIATE :SQLSTRING
     C/End-Exec
 
     C                   EXSR      SRUpdate                                                   CLE134
 
      ** If there's an SQL error, set on U7 and U8.
     C                   IF        SQLCOD < 0
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   ELSE
      ** For Data area LEALLO set positions 1 to 8 to 'AAAAAAAA'.
     C     *LOCK         IN        LEALLO
     C                   EVAL      PCLAST = 'AAAAAAAA'
     C                   OUT       LEALLO
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON                                                CLE134
     C                   RETURN                                                               CLE134
                                                                                              CLE134
      *****************************************************************                       CLE134
      *                                                               *                       CLE134
      *  SRUpdate - Update additional files                           *                       CLE134
      *                                                               *                       CLE134
      *  Called by: Main                                              *                       CLE134
      *                                                               *                       CLE134
      *****************************************************************                       CLE134
     C     SRUpdate      BEGSR                                                                CLE134
                                                                                              CLE134
     C**********         EXSR      SRInzCloan                                      CLE134 AR1085447D
                                                                                              CLE134
     C                   EXSR      SRPreSql                                                   CLE134
                                                                                              CLE134
      ** Fetch first record                                                                   CLE134
     C                   EXSR      SRFetch                                                    CLE134
     C                   DOW       SQLCOD = *ZEROS                                            CLE134
                                                                                              CLE134
      ** Update File                                                                          CLE134
     C                   EVAL      SQLSTRING =                                                CLE134
     C                             'UPDATE ' + LNFILE +                                       CLE134
     C                             ' SET ' + LNFLDN + ' =''''' +                              CLE134
     C                             ' WHERE ' + LNFLDN + ' =' +                                CLE134
     C                             ' ''000000'' WITH NC'                                      CLE134
     C/exec sql                                                                               CLE134
     C+ execute immediate :SQLSTRING                                                          CLE134
     C/end-exec                                                                               CLE134
                                                                                              CLE134
     C                   EXSR      SRFetch                                                    CLE134
     C                   ENDDO                                                                CLE134
                                                                                              CLE134
      ** Close cursor                                                                         CLE134
     C                   EXSR      SRClose                                                    CLE134
                                                                                              CLE134
     C                   ENDSR                                                                CLE134
      *****************************************************************                       CLE134
      /EJECT                                                                                  CLE134
      *****************************************************************                       CLE134
      *****************************************************************            CLE134 AR1085447D
      ***SrInzCloan*-*Initialise*new*fields*for*GZCLOANCL/MCLOANCL*****            CLE134 AR1085447D
      *****************************************************************            CLE134 AR1085447D
      ***Called*By:*SRUpdate*******************************************            CLE134 AR1085447D
      *****************************************************************            CLE134 AR1085447D
      *****************************************************************            CLE134 AR1085447D
      **********                                                                   CLE134 AR1085447D
     C*****SRInzCloan    BEGSR                                                     CLE134 AR1085447D
      **********                                                                   CLE134 AR1085447D
      ***Update*GZCLOANCL**********************************************            CLE134 AR1085447D
     C**********         EVAL      SQLSTRING =                                     CLE134 AR1085447D
     C**********                   'UPDATE GZCLOANCL a ' +                         CLE134 AR1085447D
     C**********                   'SET a.ORLN = (SELECT b.YPORG FROM ' +          CLE134 AR1085447D
     C**********                   'LEPDUEPD b WHERE a.LNRF = b.YPLON ' +          CLE134 AR1085447D
     C**********                   'GROUP BY b.YPORG)' +                           CLE134 AR1085447D
     C**********                   'WHERE EXISTS (SELECT 1 FROM ' +                CLE134 AR1085447D
     C**********                   'LEPDUEPD b where a.LNRF = b.YPLON)'            CLE134 AR1085447D
      **********                                                                   CLE134 AR1085447D
     C*/exec*SQL                                                                   CLE134 AR1085447D
     C*+*execute immediate :SQLSTRING                                              CLE134 AR1085447D
     C*/end-exec                                                                   CLE134 AR1085447D
      **********                                                                   CLE134 AR1085447D
     C**********         EVAL      SQLSTRING =                                     CLE134 AR1085447D
     C**********                   'UPDATE GZCLOANCL a ' +                         CLE134 AR1085447D
     C**********                   'SET (a.OFCU, a.OFAC, a.OFSQ, a.OFLN) ' +       CLE134 AR1085447D
     C**********                   '= (SELECT DISTINCT b.YECNUM, ' +               CLE134 AR1085447D
     C**********                   'b.YEFACL, b. YESEQ, b.YPORG FROM ' +           CLE134 AR1085447D
     C**********                   'LEPDUFPD b WHERE a.LNRF = b.YPLON) ' +         CLE134 AR1085447D
     C**********                   'WHERE EXISTS (SELECT 1 FROM LEPDUFPD b ' +     CLE134 AR1085447D
     C**********                   'WHERE a.LNRF = b.YPLON)'                       CLE134 AR1085447D
      **********                                                                   CLE134 AR1085447D
     C*/exec*SQL                                                                   CLE134 AR1085447D
     C*+*execute immediate :SQLSTRING                                              CLE134 AR1085447D
     C*/end-exec                                                                   CLE134 AR1085447D
      **********                                                                   CLE134 AR1085447D
      ***Update*CLOANCL************************************************         AR1085447 AR1085447D
     C**********         EVAL      SQLSTRING =                                  AR1085447 AR1085447D
     C**********                   'UPDATE CLOANCL a ' +                        AR1085447 AR1085447D
     C**********                   'SET a.ORLN = (SELECT b.YPORG FROM ' +       AR1085447 AR1085447D
     C**********                   'LEPDUEPD b WHERE a.LNRF = b.YPLON ' +       AR1085447 AR1085447D
     C**********                   'GROUP BY b.YPORG) ' +                       AR1085447 AR1085447D
     C**********                   'WHERE EXISTS (SELECT 1 FROM ' +             AR1085447 AR1085447D
     C**********                   'LEPDUEPD b where a.LNRF = b.YPLON)'         AR1085447 AR1085447D
      **********                                                                AR1085447 AR1085447D
     C*/exec*SQL                                                                AR1085447 AR1085447D
     C*+*execute immediate :SQLSTRING                                           AR1085447 AR1085447D
     C*/end-exec                                                                AR1085447 AR1085447D
      **********                                                                AR1085447 AR1085447D
     C**********         EVAL      SQLSTRING =                                  AR1085447 AR1085447D
     C**********                   'UPDATE CLOANCL a ' +                        AR1085447 AR1085447D
     C**********                   'SET (a.OFCU, a.OFAC, a.OFSQ, a.OFLN) ' +    AR1085447 AR1085447D
     C**********                   '= (SELECT DISTINCT b.YECNUM, ' +            AR1085447 AR1085447D
     C**********                   'b.YEFACL, b. YESEQ, b.YPORG FROM ' +        AR1085447 AR1085447D
     C**********                   'LEPDUFPD b WHERE a.LNRF = b.YPLON) ' +      AR1085447 AR1085447D
     C**********                   'WHERE EXISTS (SELECT 1 FROM LEPDUFPD b ' +  AR1085447 AR1085447D
     C**********                   'WHERE a.LNRF = b.YPLON)'                    AR1085447 AR1085447D
      **********                                                                AR1085447 AR1085447D
     C*/exec*SQL                                                                AR1085447 AR1085447D
     C*+*execute immediate :SQLSTRING                                           AR1085447 AR1085447D
     C*/end-exec                                                                AR1085447 AR1085447D
      **********                                                                   CLE134 AR1085447D
      ***Update*MCLOANCL***********************************************            CLE134 AR1085447D
     C**********         EVAL      SQLSTRING =                                     CLE134 AR1085447D
     C**********                   'UPDATE MCLOANCL a ' +                          CLE134 AR1085447D
     C**********                   'SET a.ORLN = (SELECT b.YPORG FROM ' +          CLE134 AR1085447D
     C**********                   'LEPDUEPD b WHERE a.LNRF = b.YPLON ' +          CLE134 AR1085447D
     C**********                   'GROUP BY b.YPORG)' +                           CLE134 AR1085447D
     C**********                   'WHERE EXISTS (SELECT 1 FROM ' +                CLE134 AR1085447D
     C**********                   'LEPDUEPD b where a.LNRF = b.YPLON)'            CLE134 AR1085447D
      **********                                                                   CLE134 AR1085447D
     C*/exec*SQL                                                                   CLE134 AR1085447D
     C*+*execute immediate :SQLSTRING                                              CLE134 AR1085447D
     C*/end-exec                                                                   CLE134 AR1085447D
      **********                                                                   CLE134 AR1085447D
     C**********         EVAL      SQLSTRING =                                     CLE134 AR1085447D
     C**********                   'UPDATE MCLOANCL a ' +                          CLE134 AR1085447D
     C**********                   'SET (a.OFCU, a.OFAC, a.OFSQ, a.OFLN) ' +       CLE134 AR1085447D
     C**********                   '= (SELECT DISTINCT b.YECNUM, ' +               CLE134 AR1085447D
     C**********                   'b.YEFACL, b. YESEQ, b.YPORG FROM ' +           CLE134 AR1085447D
     C**********                   'LEPDUFPD b WHERE a.LNRF = b.YPLON) ' +         CLE134 AR1085447D
     C**********                   'WHERE EXISTS (SELECT 1 FROM LEPDUFPD b ' +     CLE134 AR1085447D
     C**********                   'WHERE a.LNRF = b.YPLON)'                       CLE134 AR1085447D
      **********                                                                   CLE134 AR1085447D
     C*/exec*SQL                                                                   CLE134 AR1085447D
     C*+*execute immediate :SQLSTRING                                              CLE134 AR1085447D
     C*/end-exec                                                                   CLE134 AR1085447D
      **********                                                                   CLE134 AR1085447D
     C**********         ENDSR                                                     CLE134 AR1085447D
      *****************************************************************                       CLE134
      /EJECT                                                                                  CLE134
      *****************************************************************                       CLE134
      *                                                               *                       CLE134
      *  SRPreSql - SR to prepare main SQL                            *                       CLE134
      *                                                               *                       CLE134
      *  Called by: SRUpdate                                          *                       CLE134
      *                                                               *                       CLE134
      *****************************************************************                       CLE134
     C     SRPreSql      BEGSR                                                                CLE134
                                                                                              CLE134
     C                   CLEAR                   UpgDS                                        CLE134
                                                                                              CLE134
      ** Declare cursor                                                                       CLE134
     C/exec sql                                                                               CLE134
     C+ declare UpgCursor cursor for                                                          CLE134
     C+       select LNFILE, LNFLDN                                                           CLE134
     C+       from                                                                            CLE134
     C********SMU006PD*********************************************                 CLE134 AR1078292
     C+       SMLOANPD                                                                     AR1078292
     C/end-exec                                                                               CLE134
                                                                                              CLE134
     ** Open cursor                                                                           CLE134
     C/exec sql                                                                               CLE134
     C+ open UpgCursor                                                                        CLE134
     C/end-exec                                                                               CLE134
                                                                                              CLE134
     C                   ENDSR                                                                CLE134
      *****************************************************************                       CLE134
      /EJECT                                                                                  CLE134
      *****************************************************************                       CLE134
      *                                                               *                       CLE134
      *  SRFetch - Fetch details                                      *                       CLE134
      *                                                               *                       CLE134
      *  Called by: SRUpdate                                          *                       CLE134
      *                                                               *                       CLE134
      *****************************************************************                       CLE134
     C     SRFetch       BEGSR                                                                CLE134
                                                                                              CLE134
     C/exec sql                                                                               CLE134
     C+ fetch next                                                                            CLE134
     C+  from UpgCursor                                                                       CLE134
     C+ into :UpgDS                                                                           CLE134
     C/end-exec                                                                               CLE134
                                                                                              CLE134
     C                   ENDSR                                                                CLE134
      *****************************************************************                       CLE134
      /EJECT                                                                                  CLE134
      *****************************************************************                       CLE134
      *                                                               *                       CLE134
      *  SRClose - Close detail cursor                                *                       CLE134
      *                                                               *                       CLE134
      *  Called by: SRUpdate                                          *                       CLE134
      *                                                               *                       CLE134
      *****************************************************************                       CLE134
     C     SRClose       BEGSR                                                                CLE134
                                                                                              CLE134
     C/exec sql                                                                               CLE134
     C+ close UpgCursor                                                                       CLE134
     C/end-exec                                                                               CLE134
                                                                                              CLE134
     C                   ENDSR                                                                CLE134
      *****************************************************************                       CLE134
      /EJECT                                                                                  CLE134
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Error Processing Subroutine.                *
      *                                                               *
      *  Called By: Various                                           *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   DUMP
      *
     C                   RETURN
     C                   EVAL      *INLR = *ON
     C                   ENDSR
      *
      *****************************************************************
