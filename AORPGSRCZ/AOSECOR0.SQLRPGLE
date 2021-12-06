     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2021')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas AO SE Linked Enquiry Access Object')             *
      *****************************************************************
      *                                                               *
      *  Midas - Access Object Module                                 *
      *                                                               *
      *  AOSECOR0 - Midas AO SE Linked Enquiry Access Object          *
      *                                                               *
      *  Function:  This program retrieves records form SECON file    *
      *                                                               *
      *  (c) Finastra International Limited 2021                      *
      *                                                               *
      *  Last Amend No. MD058079 *CREATE   Date 11May21               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD058079 - Deliverable Data Split for sundry files           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRReturn - Return Error Code and Set Parameters              *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
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
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** File information data structure for external file DSFDY
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** File information data structure for external old SECOND file
     D SECOND        E DS                  EXTNAME(SECONJW0)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D PRtcd           S              7A
     D POptn           S              7A
     D P_Frm           S              8A
     D P_Opt           S              2A
     D X_Frm           S              8A
     D X_Opt           S              2A
      *
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Receive entry parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    PRtcd
     C                   PARM                    POptn
     C                   PARM                    P_Frm
     C                   PARM                    P_Opt
     C                   PARM      SECOND        DSFDY
      *
     C                   eval      X_Frm = P_Frm
     C                   eval      X_Opt = P_Opt
      ** Caller requests record indicated by key :
      *
     C                   IF        (POptn = '*KEY   ')
     C                             OR (POptn = '*VERIFY')
      *
     C/EXEC SQL
     C+ SELECT *
     C+ into :SECOND
     C+ from SECONJW0
     C+ where FROM = :X_Frm and OPTN = :X_Opt
     C/END-EXEC
     C                   SETOFF                                       9095
     C                   If        SQLCODE = 100
     C                   SETON                                        95
     C                   ENDIF
     C                   If        SQLCODE <> 100 and SQLCODE <> 0
     C                   SETON                                        90
     C                   ENDIF

      *
      *
     C                   ENDIF
      *
      ** Caller requests record indicated by invaild option :
      *
     C                   IF        (POptn <> '*KEY   ')
     C                             AND (POptn <>  '*NEXT  ')
     C                             AND (POptn <>  '*PREV  ')
     C                             AND (POptn <>  '*VERIFY')
     C                             AND (POptn <>  '*FREE  ')
     C                             AND (POptn <>  '*SAME  ')
      *
     C                   EVAL      *IN96 = *ON
     C                   ENDIF
      *
     C                   EXSR      SRReturn
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReturn - Return Error Code and Set Parameters Subroutine   *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRReturn      BEGSR
      *
     C                   EVAL      PRtcd = *BLANKS
      *
     C                   SELECT
      *
     C                   WHEN      *IN90 = *ON
     C                   EVAL      PRtcd = '*ERROR '
     C                   EVAL      *INLR = *ON
      *
     C                   WHEN      *IN95 = *ON
     C                   EVAL      PRtcd = '*NRF   '
      *
     C                   WHEN      *IN96 = *ON
     C                   EVAL      PRtcd = '*OPTION'
      *
     C                   ENDSL
      *
      *
      *
     C                   IF        (POptn <> '*VERIFY')
     C                             AND (POptn <> '*FREE  ')
     C                             AND (PRtcd <> '*OPTION')
      *
     C                   EVAL      DSFDY = SECOND
      *
     C                   ENDIF
      *
     C                   SETON                                        LR
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
