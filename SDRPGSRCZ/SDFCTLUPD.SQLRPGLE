     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2024')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SD Customer Standing Data Controls Update')      *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDFCTLUPD - CUSTOMER STANDING DATA CONTROLS UPDATE           *
      *                                                               *
      *  (c) Finastra International Limited 2024                      *
      *                                                               *
      *  Last Amend No. MD060329  *CREATE  Date 22Jan24               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD060329 - API Performance degradation SP25                  *
      *                                                               *
      *****************************************************************

      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+

      **------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------------

      **------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **------------------------------------------------------------------------

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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D WRun            S              1A

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

      ** Main Processing

     C                   EXSR      SRMainProc

      ** Return

     C                   EXSR      SRReturn

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMainProc - Main Processing                                  *
      *                                                               *
      * Called by:  Main  Processing                                  *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRMainProc    BEGSR

     C                   EVAL      ReturnCode = *BLANKS
      *
      ** Start commitment control
     C/EXEC SQL
     C+ SET OPTION COMMIT = *CHG
     C/END-EXEC
      *

     C/EXEC SQL
     C+ insert into SDFCTLPP
     C+ (
     C+   PAHFLNM
     C+ , PAHNORC
     C+ , PAHNOIN
     C+ , PAHNOAM
     C+ , PAHNODL
     C+ )
     C+ Values
     C+ (
     C+   :FILENAME
     C+ , :NRECORDS
     C+ , :NINSERTS
     C+ , :NAMENDS
     C+ , :NDELETES
     C+ )
     C/END-EXEC
      *
      ** Write error detected.
     C                   IF        SQLCOD <> *Zero
     C                   EVAL      ReturnCode = '*ERROR'
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRReturn - Return to calling program                          *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRReturn      BEGSR

     C                   EVAL      RETCODE = ReturnCode
     C                   Return

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

      ** Program parameters

     C     *ENTRY        PLIST

      ** Input Parameters
      ** ================
      ** Return Code
      ** No. of Records
      ** No. of Inserts
      ** No. of Amends
      ** No. of Deletes
     C                   PARM                    RETCODE           7
     C                   PARM                    FILENAME         10
     C                   PARM                    NRECORDS          5 0
     C                   PARM                    NINSERTS          5 0
     C                   PARM                    NAMENDS           5 0
     C                   PARM                    NDELETES          5 0

      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.

      /COPY ZACPYSRC,DBFIELDS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *  Called by: *INZSR                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
     C                   EVAL      DBPGM = 'SDFCTLUPD'
     C                   DUMP
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2024
