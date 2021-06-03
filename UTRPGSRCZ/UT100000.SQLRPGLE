     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/**** *  RPGBASEBND                                                   *                     MD056612
/*STD *  RPGSQLBND                                                    *                     MD056612
/*EXI *  TEXT('Midas UT Utility to Set QNAME for New MX Format')      *
      *****************************************************************
      *                                                               *
      *  Midas - Utilities                                            *
      *                                                               *
      *  UT100000 - Midas UT Utility to Set QNAME for New MX Format   *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. MD056612           Date 12Sep20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD031372 *CREATE   Date 21Nov14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056612 - Deliverable Data Split for MX group               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD031372 - Update MXEXFDPD.EXMSGQ field with the queue name  *
      *             setup for static data.                            *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** MX Export Format Details file

     F*MXEXFDL2* UF   E           K DISK    INFSR(*PSSR)                                    MD056612

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D WEMSGQ          S                   LIKE(EXMSGQ)
     D WFormat         S             10A
     D InParm          S             10A
     D MXEXFD        E DS                  EXTNAME(MXEXDJW0)                                MD056612

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      *
      ** Get queue name from one of CTI006 static data format
      *
      *
     C                   MOVEL     'TISDACOD'    WFormat
     C*****WFormat       CHAIN     MXEXFDL2                           90                    MD056612
     C/EXEC SQL                                                                             MD056612
     C+ SELECT *                                                                            MD056612
     C+ into :MXEXFD                                                                        MD056612
     C+ from MXEXDJW0                                                                       MD056612
     C+ where EXFMT  = :WFormat                                                             MD056612
     C/END-EXEC                                                                             MD056612
     C                   MOVEL     EXMSGQ        WEMSGQ
      *
      ** Set retrieved value to the new format
      *
     C*****InParm        CHAIN     MXEXFDL2                           90                    MD056612
     C                   MOVEL     WEMSGQ        EXMSGQ
     C**********         UPDATE    MXEXFDP0                                                 MD056612
     C/exec SQL                                                                             MD056612
     C+ update MXEXDXTD                                                                     MD056612
     C+ set EXMSGQ = :WEMSGQ                                                                MD056612
     C+ where EXFMT = :InParm                                                               MD056612
     C/end-exec                                                                             MD056612

     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST

      ** Input Parameters
      ** ================
      ** Return Code

     C                   PARM                    InParm

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program Exception Subroutine                         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   DUMP

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON

     C                   RETURN

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2014
