     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UT Migration MUREX fields')
      *****************************************************************
      *                                                               *
      *  Midas - Migration Utility MM Deals                           *
      *                                                               *
      *  XXL000004 - Midas XX Migration Utility LUC109 - Murex MM     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2016            *
      *                                                               *
      *  Last Amend No. LUC109             Date 25Jan17               *
      *  Prev Amend No. LUC109 *Create     Date 14Oct16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC109  -R306 Netting flag not available in Loans            *
      *  LUC109 - HO Reporting                                        *
      *                                                               *
      *****************************************************************
      *
     D fromlib         S             10
     D tolib           S             10
     D fromlibtxt      S             22
     D tolibtxt        S             22
     D proctype        S              1                                         LUC109
      *
     D recursive       S              1
      *
     D s               S           5000
      *
     C     *entry        plist
     C                   parm                    fromlib
     C                   parm                    tolib
     C                   parm                    proctype                       LUC109
      *
     C                   select                                                 LUC109
      *                                                                         LUC109
     C                   when      proctype = '1'                               LUC109
     C                   exsr      ldni
      *                                                                         LUC109
     C                   when      proctype = '2'                               LUC109
     C                   exsr      ldniwithR306                                 LUC109
      *                                                                         LUC109
     C                   when      proctype = '3'                               LUC109
     C                   exsr      ldnionlyR306                                 LUC109
      *                                                                         LUC109
     C                   endsl                                                  LUC109
      *
     C                   eval      *inlr = *on
     C                   return
      *
      *****************************************************************
      /eject
      *****************************************************************
      *                                                               *
      * ldni - Migrate LDNI data                                      *
      *                                                               *
      * Called by: main                                               *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     ldni          begsr
      *
      * DEALSCX0
      *
     C                   if        fromlib <> *blanks
     C                   eval      fromlibtxt = ' ' + %trim(fromlib)
     C                             + '/T_GZLDNIEX'
     C                   else
     C                   eval      fromlibtxt = ' T_GZLDNIEX'
     C                   endif
      *
     C                   if        tolib <> *blanks
     C                   eval      tolibtxt = ' ' + %trim(tolib)
     C                             + '/DEALSCX0'
     C                   else
     C                   eval      tolibtxt = 'DEALSCX0'
     C                   endif
      *
     C                   clear                   s
     C                   eval      s='update '+tolibtxt
     C                   eval      s=%trim(s)+' a SET (MXTRNO, MXCNTL) = '
     C                   eval      s=%trim(s)+' (SELECT COALESCE(b.MXTRNO,'
     C                   eval      s=%trim(s)+ x'7D' + ' ' + x'7D' + '),'
     C                   eval      s=%trim(s)+' COALESCE(b.MXCNTL,'
     C                   eval      s=%trim(s)+ x'7D' + ' ' + x'7D' + ')'
     C                   eval      s=%trim(s)+' FROM'
     C                   eval      s=%trim(s)+%trimr(fromlibtxt)+' b WHERE'
     C                   eval      s=%trim(s)+' b.DDDLNO = a.MDLNO and'
     C                   eval      s=%trim(s)+' b.zone <> ' + x'7D'
     C                   eval      s=%trim(s)+ ' ' + x'7D' + ') WHERE'
     C                   eval      s=%trim(s)+' a.MDLNO IN (SELECT bb.DDDLNO'
     C                   eval      s=%trim(s)+' FROM'
     C                   eval      s=%trim(s)+%trimr(fromlibtxt)+' bb)'
      *
     C                   exsr      executesql
      *
     C                   endsr
      *
      *****************************************************************
      /eject                                                                    LUC109
      *****************************************************************         LUC109
      *                                                               *         LUC109
      * ldni - Migrate LDNI data, including R306                      *         LUC109
      *                                                               *         LUC109
      * Called by: main                                               *         LUC109
      *                                                               *         LUC109
      * Calls:                                                        *         LUC109
      *                                                               *         LUC109
      *****************************************************************         LUC109
      *                                                                         LUC109
     C     ldniwithR306  begsr                                                  LUC109
      *                                                                         LUC109
      * DEALSCX0                                                                LUC109
      *                                                                         LUC109
     C                   if        fromlib <> *blanks                           LUC109
     C                   eval      fromlibtxt = ' ' + %trim(fromlib)            LUC109
     C                             + '/T_GZLDNIEX'                              LUC109
     C                   else                                                   LUC109
     C                   eval      fromlibtxt = ' T_GZLDNIEX'                   LUC109
     C                   endif                                                  LUC109
      *                                                                         LUC109
     C                   if        tolib <> *blanks                             LUC109
     C                   eval      tolibtxt = ' ' + %trim(tolib)                LUC109
     C                             + '/DEALSCX0'                                LUC109
     C                   else                                                   LUC109
     C                   eval      tolibtxt = 'DEALSCX0'                        LUC109
     C                   endif                                                  LUC109
      *                                                                         LUC109
     C                   clear                   s                              LUC109
     C                   eval      s='update '+tolibtxt                         LUC109
     C                   eval      s=%trim(s)+' a SET (MXTRNO,MXNTAF,MXCNTL) = 'LUC109
     C                   eval      s=%trim(s)+' (SELECT COALESCE(b.MXTRNO,'     LUC109
     C                   eval      s=%trim(s)+ x'7D' + ' ' + x'7D' + '),'       LUC109
     C                   eval      s=%trim(s)+' COALESCE(b.R306,'               LUC109
     C                   eval      s=%trim(s)+ x'7D' + ' ' + x'7D' + '),'       LUC109
     C                   eval      s=%trim(s)+' COALESCE(b.MXCNTL,'             LUC109
     C                   eval      s=%trim(s)+ x'7D' + ' ' + x'7D' + ')'        LUC109
     C                   eval      s=%trim(s)+' FROM'                           LUC109
     C                   eval      s=%trim(s)+%trimr(fromlibtxt)+' b WHERE'     LUC109
     C                   eval      s=%trim(s)+' b.DDDLNO = a.MDLNO and'         LUC109
     C                   eval      s=%trim(s)+' b.zone <> ' + x'7D'             LUC109
     C                   eval      s=%trim(s)+ ' ' + x'7D' + ') WHERE'          LUC109
     C                   eval      s=%trim(s)+' a.MDLNO IN (SELECT bb.DDDLNO'   LUC109
     C                   eval      s=%trim(s)+' FROM'                           LUC109
     C                   eval      s=%trim(s)+%trimr(fromlibtxt)+' bb)'         LUC109
      *                                                                         LUC109
     C                   exsr      executesql                                   LUC109
      *                                                                         LUC109
     C                   endsr                                                  LUC109
      *                                                                         LUC109
      *****************************************************************         LUC109
      /eject                                                                    LUC109
      *****************************************************************         LUC109
      *                                                               *         LUC109
      * ldni - Migrate LDNI data, only R306                           *         LUC109
      *                                                               *         LUC109
      * Called by: main                                               *         LUC109
      *                                                               *         LUC109
      * Calls:                                                        *         LUC109
      *                                                               *         LUC109
      *****************************************************************         LUC109
      *                                                                         LUC109
     C     ldnionlyR306  begsr                                                  LUC109
      *                                                                         LUC109
      * DEALSCX0                                                                LUC109
      *                                                                         LUC109
     C                   if        fromlib <> *blanks                           LUC109
     C                   eval      fromlibtxt = ' ' + %trim(fromlib)            LUC109
     C                             + '/T_GZLDNIEX'                              LUC109
     C                   else                                                   LUC109
     C                   eval      fromlibtxt = ' T_GZLDNIEX'                   LUC109
     C                   endif                                                  LUC109
      *                                                                         LUC109
     C                   if        tolib <> *blanks                             LUC109
     C                   eval      tolibtxt = ' ' + %trim(tolib)                LUC109
     C                             + '/DEALSCX0'                                LUC109
     C                   else                                                   LUC109
     C                   eval      tolibtxt = 'DEALSCX0'                        LUC109
     C                   endif                                                  LUC109
      *                                                                         LUC109
     C                   clear                   s                              LUC109
     C                   eval      s='update '+tolibtxt                         LUC109
     C                   eval      s=%trim(s)+' a SET (MXNTAF) = '              LUC109
     C                   eval      s=%trim(s)+' (SELECT COALESCE(b.R306,'       LUC109
     C                   eval      s=%trim(s)+ x'7D' + ' ' + x'7D' + ')'        LUC109
     C                   eval      s=%trim(s)+' FROM'                           LUC109
     C                   eval      s=%trim(s)+%trimr(fromlibtxt)+' b WHERE'     LUC109
     C                   eval      s=%trim(s)+' b.DDDLNO = a.MDLNO and'         LUC109
     C                   eval      s=%trim(s)+' b.zone <> ' + x'7D'             LUC109
     C                   eval      s=%trim(s)+ ' ' + x'7D' + ') WHERE'          LUC109
     C                   eval      s=%trim(s)+' a.MDLNO IN (SELECT bb.DDDLNO'   LUC109
     C                   eval      s=%trim(s)+' FROM'                           LUC109
     C                   eval      s=%trim(s)+%trimr(fromlibtxt)+' bb)'         LUC109
      *                                                                         LUC109
     C                   exsr      executesql                                   LUC109
      *                                                                         LUC109
     C                   endsr                                                  LUC109
      *                                                                         LUC109
      *****************************************************************         LUC109
      /eject
      *****************************************************************
      *                                                               *
      * ExecuteSQL - Execute SQL statement                            *
      *                                                               *
      * Called by: *multi                                             *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     executesql    begsr
      *
     C/exec SQL
     C+ execute immediate :s
     C/end-exec
      *
     C     executesqle   endsr
      *
      /eject
      ********************************************************************
      *
     C     *pssr         begsr
      *
     C     recursive     ifeq      *BLANKS
     C                   move      'Y'           recursive
     C                   dump
     C                   seton                                        LRU7U8
     C                   return
     C                   endif
      *
     C     pssre         endsr
      *****************************************************************
