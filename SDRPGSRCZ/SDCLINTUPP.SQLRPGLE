     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2024')
      *****************************************************************
/*STD *  RPGSQLMOD                                                    *
/*EXI *  TEXT('Midas SD Main Client Details COB Update')              *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCLINTUPP - MAIN CLIENT DETAILS COB UPDATE                  *
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

      ** Customer Master File
     FCLINT     UF A E           K DISK
     F                                     COMMIT
     F                                     IGNORE(CLINTCBF)
     F                                     IGNORE(CLINTCCF)
     F                                     IGNORE(CLINTC1F)
     F                                     IGNORE(CLINTSEF)

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
      ** Process CLINTCA file
      *
     C                   EXSR      SRInitialize

     C/EXEC SQL
     C+ SELECT VALUE(SUM(CLNTINS),0), VALUE(SUM(CLNTDEL),0),
     C+        VALUE(SUM(CLNTAMD),0)
     C+ INTO :CINSERT, :CDELETE,
     C+      :CAMEND
     C+ FROM SDCLINTPP
     C/END-EXEC

     C                   IF        SQLCOD = *ZERO
     C                   EXSR      SRUpdateFile
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUpdateFile - Update File CLINTCA                            *
      *                                                               *
      * Called by:  Main  Processing                                  *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRUpdateFile  BEGSR

     C                   MOVE      *BLANKS       CNUM              6
     C                   MOVE      '0'           RCDT              1

     C     CLKEY         CHAIN     CLINTCAF                           90
     C     *IN90         IFEQ      *OFF

     C                   ADD       CINSERT       TINS
     C                   ADD       CDELETE       TDEL
     C                   ADD       CAMEND        TAMD
     C                   UPDATE    CLINTCAF
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

     C                   Z-ADD     *ZEROS        CINSERT           5 0
     C                   Z-ADD     *ZEROS        CDELETE           5 0
     C                   Z-ADD     *ZEROS        CAMEND            5 0
     C                   Z-ADD     *ZEROS        SQLCOD

      ** Define CLINTCA file key
     C     CLKEY         KLIST
     C                   KFLD                    CNUM
     C                   KFLD                    RCDT

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
