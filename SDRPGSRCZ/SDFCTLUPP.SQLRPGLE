     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2024')
      *****************************************************************
/*STD *  RPGSQLMOD                                                    *
/*EXI *  TEXT('Midas SD Customer Standing Data Controls COB Upd')     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDFCTLUPP - CUSTOMER STANDING DATA CONTROLS COB UPDATE       *
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

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Standing Data Controls File
     FSDFCTLL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT

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

      ** End Program

     C                   MOVE      *ON           *INLR

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
      *
      ** Process SDCUSTPD file
      *
     C                   EXSR      SRInitialize
     C                   EVAL      FNAME = 'SDCUSTPD'

     C/EXEC SQL
     C+ SELECT VALUE(SUM(PAHNORC),0), VALUE(SUM(PAHNOIN),0),
     C+        VALUE(SUM(PAHNOAM),0), VALUE(SUM(PAHNODL),0)
     C+ INTO :STOTREC, :SINSERT,
     C+      :SAMEND,  :SDELETE
     C+ FROM SDFCTLPP WHERE PAHFLNM = :FNAME
     C/END-EXEC

     C                   IF        SQLCOD = *ZERO
     C                   EXSR      SRUpdateFile
     C                   ENDIF
      *
      ** Process SDCMRKPD file
      *
     C                   EXSR      SRInitialize
     C                   EVAL      FNAME = 'SDCMRKPD'

     C/EXEC SQL
     C+ SELECT VALUE(SUM(PAHNORC),0), VALUE(SUM(PAHNOIN),0),
     C+        VALUE(SUM(PAHNOAM),0), VALUE(SUM(PAHNODL),0)
     C+ INTO :STOTREC, :SINSERT,
     C+      :SAMEND,  :SDELETE
     C+ FROM SDFCTLPP WHERE PAHFLNM = :FNAME
     C/END-EXEC

     C                   IF        SQLCOD = *ZERO
     C                   EXSR      SRUpdateFile
     C                   ENDIF
      *
      ** Process SDCFCDPD file
      *
     C                   EXSR      SRInitialize
     C                   EVAL      FNAME = 'SDCFCDPD'

     C/EXEC SQL
     C+ SELECT VALUE(SUM(PAHNORC),0), VALUE(SUM(PAHNOIN),0),
     C+        VALUE(SUM(PAHNOAM),0), VALUE(SUM(PAHNODL),0)
     C+ INTO :STOTREC, :SINSERT,
     C+      :SAMEND,  :SDELETE
     C+ FROM SDFCTLPP WHERE PAHFLNM = :FNAME
     C/END-EXEC

     C                   IF        SQLCOD = *ZERO
     C                   EXSR      SRUpdateFile
     C                   ENDIF
      *
      ** Process SDCHEQPD file
      *
     C                   EXSR      SRInitialize
     C                   EVAL      FNAME = 'SDCHEQPD'

     C/EXEC SQL
     C+ SELECT VALUE(SUM(PAHNORC),0), VALUE(SUM(PAHNOIN),0),
     C+        VALUE(SUM(PAHNOAM),0), VALUE(SUM(PAHNODL),0)
     C+ INTO :STOTREC, :SINSERT,
     C+      :SAMEND,  :SDELETE
     C+ FROM SDFCTLPP WHERE PAHFLNM = :FNAME
     C/END-EXEC

     C                   IF        SQLCOD = *ZERO
     C                   EXSR      SRUpdateFile
     C                   ENDIF
      *
      ** Process SDSAFEPD file
      *
     C                   EXSR      SRInitialize
     C                   EVAL      FNAME = 'SDSAFEPD'

     C/EXEC SQL
     C+ SELECT VALUE(SUM(PAHNORC),0), VALUE(SUM(PAHNOIN),0),
     C+        VALUE(SUM(PAHNOAM),0), VALUE(SUM(PAHNODL),0)
     C+ INTO :STOTREC, :SINSERT,
     C+      :SAMEND,  :SDELETE
     C+ FROM SDFCTLPP WHERE PAHFLNM = :FNAME
     C/END-EXEC

     C                   IF        SQLCOD = *ZERO
     C                   EXSR      SRUpdateFile
     C                   ENDIF
      *
      ** Process SDFOCSPD file
      *
     C                   EXSR      SRInitialize
     C                   EVAL      FNAME = 'SDFOCSPD'

     C/EXEC SQL
     C+ SELECT VALUE(SUM(PAHNORC),0), VALUE(SUM(PAHNOIN),0),
     C+        VALUE(SUM(PAHNOAM),0), VALUE(SUM(PAHNODL),0)
     C+ INTO :STOTREC, :SINSERT,
     C+      :SAMEND,  :SDELETE
     C+ FROM SDFCTLPP WHERE PAHFLNM = :FNAME
     C/END-EXEC

     C                   IF        SQLCOD = *ZERO
     C                   EXSR      SRUpdateFile
     C                   ENDIF
      *
      ** Process SDALTNPD file
      ** The processing of SDALTNPD to SDFCTLPA is also in SDALNAUPD program
      *
     C                   EXSR      SRInitialize
     C                   EVAL      FNAME = 'SDALTNPD'

     C/EXEC SQL
     C+ SELECT VALUE(SUM(PAHNORC),0), VALUE(SUM(PAHNOIN),0),
     C+        VALUE(SUM(PAHNOAM),0), VALUE(SUM(PAHNODL),0)
     C+ INTO :STOTREC, :SINSERT,
     C+      :SAMEND,  :SDELETE
     C+ FROM SDFCTLPP WHERE PAHFLNM = :FNAME
     C/END-EXEC

     C                   IF        SQLCOD = *ZERO
     C                   EXSR      SRUpdateFile
     C                   ENDIF
      *
      ** Process SDPLCSPD file
      *
     C                   EXSR      SRInitialize
     C                   EVAL      FNAME = 'SDPLCSPD'

     C/EXEC SQL
     C+ SELECT VALUE(SUM(PAHNORC),0), VALUE(SUM(PAHNOIN),0),
     C+        VALUE(SUM(PAHNOAM),0), VALUE(SUM(PAHNODL),0)
     C+ INTO :STOTREC, :SINSERT,
     C+      :SAMEND,  :SDELETE
     C+ FROM SDFCTLPP WHERE PAHFLNM = :FNAME
     C/END-EXEC

     C                   IF        SQLCOD = *ZERO
     C                   EXSR      SRUpdateFile
     C                   ENDIF
      *
      ** Process SDTICSPD file
      *
     C                   EXSR      SRInitialize
     C                   EVAL      FNAME = 'SDTICSPD'

     C/EXEC SQL
     C+ SELECT VALUE(SUM(PAHNORC),0), VALUE(SUM(PAHNOIN),0),
     C+        VALUE(SUM(PAHNOAM),0), VALUE(SUM(PAHNODL),0)
     C+ INTO :STOTREC, :SINSERT,
     C+      :SAMEND,  :SDELETE
     C+ FROM SDFCTLPP WHERE PAHFLNM = :FNAME
     C/END-EXEC

     C                   IF        SQLCOD = *ZERO
     C                   EXSR      SRUpdateFile
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUpdateFile - Update File SDFCTLPA                           *
      *                                                               *
      * Called by:  Main  Processing                                  *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRUpdateFile  BEGSR

     C     FNAME         CHAIN     SDFCTLL0                           90
     C     *IN90         IFEQ      *OFF

     C                   ADD       STOTREC       AHNORC
     C                   ADD       SINSERT       AHNOIN
     C                   ADD       SAMEND        AHNOAM
     C                   ADD       SDELETE       AHNODL
     C                   UPDATE    @AHREAU
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRInitialize - Initialize Fields                              *
      *                                                               *
      * Called by:  Main  Processing                                  *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRInitialize  BEGSR

     C                   MOVE      *BLANKS       FNAME            10
     C                   Z-ADD     *ZEROS        STOTREC           5 0
     C                   Z-ADD     *ZEROS        SINSERT           5 0
     C                   Z-ADD     *ZEROS        SAMEND            5 0
     C                   Z-ADD     *ZEROS        SDELETE           5 0
     C                   Z-ADD     *ZEROS        SQLCOD

      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.

      /COPY ZACPYSRC,DBFIELDS

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      **-------------------------------------------------------------------+
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **-------------------------------------------------------------------+
      ********************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2024
