     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP Find job description on SMIMP*')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP0127 - Find job description on SMIMP*                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CUP042 *REWRITE    Date 07Nov14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSC017             Date 26Feb03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP042 - Changes for Bridge deliverable data split           *
      *  CSC017 - Change library list to 250.                         *
      *                                                               *
      *****************************************************************
      *
     D PJobDesc        S             10
     D PLayer          S              7
     D PRtnCode        S              1
     D JobDesc         S                   LIKE(PJobDesc)
      *
     C     *ENTRY        PLIST
     C                   PARM                    PJobDesc
     C                   PARM                    PLayer
     C                   PARM                    PRtnCode
      *
     C                   EVAL      PRtnCode = 'N'
      *
     C/exec SQL
     C+ select
     C+   DFNAME
     C+ into
     C+   :JobDesc
     C+ from SMIMPJW0
     C+ where
     C+     DFSMNU = 'CreateJobDesc'
     C+ and DFNAME = :PJobDesc
     C+ and DFLAYR = :PLayer
     C+ and DFMODE = 'C'
     C+ and DFDEL  = 'N'
     C/end-exec
      *
     C                   IF        SQLCODE = 0
     C                   EVAL      PRtnCode = 'Y'
     C                   ENDIF
      *
     C                   RETURN
      ********************************************************************
