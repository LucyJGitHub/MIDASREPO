     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2018')
      *****************************************************************
/*STD *  RPGSQLMOD                                                    *
/*EXI *  TEXT('Midas RE Customer Ranges Definition Query')            *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE001591 - Customer Ranges Definition Query                  *
      *                                                               *
      *  Function: This program forms the query for Customer Ranges   *
      *              to be used by REC376A.                           *
      *                                                               *
      *  (c) Finastra International Limited 2018                      *
      *                                                               *
      *  Last Amend No. CRE113  *CREATE    Date 05Feb18               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE113 - COB Optimisation of REC376A                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *INZSR        -  Program Initialisation Routine              *
      *  *PSSR         -  Error handling subroutine                   *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      ** Data Area giving Installation Control Details

      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
     D Apos            C                   const(x'7D')
     D CNumGE          C                   const(' (CCNUM *GE ')
     D CNumLE          C                   const(' *AND CCNUM *LE ')

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+


     D CusRangeDS    E DS                  EXTNAME(SDCUSRTD)

     D pSQL_RanOk      PR              N
     D  iSQLState                     5A   Const


      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+


     D @RUN            S              1
     D CPY2@           S             80


      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************

      ** Main Program

     C                   Eval      QRYSLT = *Blanks
      ** Set SQL return code
     C                   Eval      SQLCOD = 0

     C/exec sql
     C+ declare CustRangeFile Scroll Cursor
     C+  for select *
     C+  from SDCUSRTD
     C+  order by
     C+  CRFCIR, CRLCIR
     C/end-exec

     C/exec sql
     C+ open CustRangeFile
     C/end-exec

      ** Handle SQL Error (if not %EOF)
      *
     C                   If        SQLCOD < 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 3
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   ExSR      *PSSR
     C                   EndIf

     C/exec SQL
     C+ fetch next
     C+ from CustRangeFile
     C+ into :CusRangeDS
     C/end-exec

     C                   DOW       SQLCode <> 100

     C                   If        QRYSLT = *Blanks
     C                   EVAL      QRYSLT = CNumGE + Apos +
     C                             CRFCIR + Apos + CNumLE + Apos + CRLCIR +
     C                             Apos + ')'
     C                   Else
     C                   EVAL      QRYSLT = %TRIM(QRYSLT) + CNumGE + Apos +
     C                             CRFCIR + Apos + CNumLE + Apos + CRLCIR +
     C                             Apos + ')'
     C                   Endif

     C/exec SQL
     C+ fetch next
     C+ from CustRangeFile
     C+ into :CusRangeDS
     C/end-exec

     C                   If        SQLCode <> 100
     C                   EVAL      QRYSLT = %TRIM(QRYSLT) + ' *OR'
     C                   Endif

     C                   ENDDO

      ** Handle SQL Error (if not %EOF)

     C                   If        SQLCode < 100

     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 4
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   EndIf

     C/exec SQL
     C+ close CustRangeFile
     C/end-exec

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

      ** Set up copyright parameter

     C                   MOVEA     CPY@          CPY2@

      ** Receive entry parameters

     C     *ENTRY        PLIST
     C                   PARM                    QRYSLT         2000

      ** Define LDA

     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'RE001591'
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY =  *BLANKS
     C                   EVAL      DBASE = 1
     C                   OUT       LDA

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR   -  Error Handling Subroutine                         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   DUMP

     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   CALLB     'DBERRCTL'
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     P*****************************************************************
     P* pSQL_RanOK - See if last SQL statement ran ok.                *
     P*****************************************************************
     P pSQL_RanOk      b
     D pSQL_RanOk      pi              n
     D  iSQLState                     5a   Const

     C                   Return    %Subst(iSQLState:1:2) = '00'
     C                             or %Subst(iSQLState:1:2) = '01'

     P                 e
** CPY@
(c) Finastra International Limited 2018
