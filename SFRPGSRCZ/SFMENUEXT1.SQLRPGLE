     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2007')
      *****************************************************************
/**** *  RPGBASEBNC                                                   *                     MD055681
/*STD *  RPGSQLBND                                                    *                     MD055681
/*EXI *  TEXT('User Functions - Branch List View')
      *****************************************************************
      *                                                               *
      *  Midas - Security Profile Facility                            *
      *                                                               *
      *  SFMENUEXT1 - SF User Maintenance + Menu Items Details        *
      *                                                               *
      *  Function: This program writes the data to an extract         *
      *            file which is then used to display the data        *
      *            in the list view for User Functions on the         *
      *            front end.                                         *
      *                                                               *
      *  (c) Finastra International Limited 2007                      *
      *                                                               *
      *  Last Amend No. MD056561           Date 31Aug20               *
      *  Prev Amend No. MD055681           Date 31Jul20               *
      *                 MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG14000 *CREATE   Date 18May07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056561 - Deliverable Data Split for SFMENUPD and GPMTXTPD  *
      *  MD055681 - Deliverable Data Split for SAR                    *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG14000 - Midas Plus error on User Functions                *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      * GP Global Menu Item Text
     F*GPMTXTPD* IF   E             DISK    PREFIX(A_)                                      MD056561
     F**********                           INFSR(*PSSR)                                     MD056561

      * SF Zonal Menu Action Codes by Unique Code
     F*SFMENUJ0* IF   E           K DISK    PREFIX(B_)                                      MD056561
     F**********                           INFSR(*PSSR)                                     MD056561

      * Zonal Extract File for List View
     FSFMNUEXPD O    E             DISK    USROPN
     F                                     INFSR(*PSSR)

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------

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

     D Cmd             S           1000
     D Len             S             15  5

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SAR DETAILS

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D SFMENU        E DS                  EXTNAME(SFMNUJW1)                                MD056561
     D                                     PREFIX(B_)                                       MD056561
     D NullInds        s              5i 0 dim(22)                                          MD056561
     D GPMTXT        E DS                  EXTNAME(GPMTXJW0)                                MD056561
     D                                     PREFIX(A_)                                       MD056561

      *---------------------------------------------------------------
      ** Mainline Processing
      *---------------------------------------------------------------
      *
      * Read the file until end of file
     C**********         READ      GPMTXTPD                                                 MD056561
     C/EXEC SQL                                                                             MD056561
     C+ declare ACursor insensitive scroll cursor for                                       MD056561
     C+ select * from GPMTXJW0                                                              MD056561
     C+ where MIDEL <> 'Y'                                                                  MD056561
     C+ order by MISNAM                                                                     MD056561
     C/END-EXEC                                                                             MD056561
                                                                                            MD056561
     C/EXEC SQL                                                                             MD056561
     C+ open ACursor                                                                        MD056561
     C/END-EXEC                                                                             MD056561
                                                                                            MD056561
     C/EXEC SQL                                                                             MD056561
     C+ fetch next from ACursor into :GPMTXT                                                MD056561
     C/END-EXEC                                                                             MD056561
                                                                                            MD056561
      *
     C**********         DOW       Not %EOF(GPMTXTPD)                                       MD056561
     C                   DOW       SQLCODE = 0                                              MD056561
      *
      * For the Menu Index retrieve all the fields from the join file
      *
     C*****A_MIINDX      CHAIN     SFMENUJ0                                                 MD056561
     C/EXEC SQL                                                                             MD056561
     C+ SELECT *                                                                            MD056561
     C+ into :SFMENU :NullInds                                                              MD056561
     C+ from SFMNUJW1                                                                       MD056561
     C+ where MIINDX = :A_MIINDX                                                            MD056561
     C/END-EXEC                                                                             MD056561
      *
     C**********         IF        %FOUND(SFMENUJ0)                                         MD056561
     C                   IF        SQLCODE = 0                                              MD056561
     C                             or SQLCODE = 811                                         MD056561
      * Populate the fields to the extract file
     C                   EVAL      MIINDX = A_MIINDX
     C                   EVAL      MISNAM = A_MISNAM
     C                   EVAL      MIINAR = A_MIINAR
     C                   EVAL      MISARN = B_SARN
     C                   EVAL      MISECL = B_MISECL
     C                   EVAL      ALLOWACT = B_MIAAC1 + B_MIAAC2 + B_MIAAC3 +
     C                                        B_MIAAC4 + B_MIAAC5 + B_MIAAC6 +
     C                                        B_MIAAC7 + B_MIAAC8 + B_MIAAC9 +
     C                                        B_MIAAC10
      * Write the data to the extract file
     C                   WRITE     SFMNUEXD0
      *
     C                   ENDIF
      *
     C**********         READ      GPMTXTPD                                                 MD056561
     C/EXEC SQL                                                                             MD056561
     C+ fetch next from ACursor into :GPMTXT                                                MD056561
     C/END-EXEC                                                                             MD056561
      *
     C                   ENDDO
      *
     C                   CLOSE     SFMNUEXPD

     C/EXEC SQL                                                                             MD056561
     C+ close ACursor                                                                       MD056561
     C/END-EXEC                                                                             MD056561
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR
      *
      * Clear the file SFMNUEXPD before processing further
      *
     C                   EVAL      Cmd = 'CLRPFM FILE(SFMNUEXPD)'
     C                   EVAL      LEN = %LEN(Cmd)

     C                   CALL      'QCMDEXC'
     C                   PARM                    Cmd
     C                   PARM                    Len

     C                   IF        NOT %OPEN(SFMNUEXPD)
     C                   OPEN      SFMNUEXPD
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *****************************************************************

     C     *pssr         BEGSR

     C                   DUMP

     C                   EVAL      *inu7 = *on
     C                   EVAL      *inu8 = *on
     C                   EVAL      *inlr = *on

     C                   IF        RunBefore <> 'Y'

     C                   EVAL      RunBefore = 'Y'

      ** Load the APDUMP fields
     C     *lock         IN        APDUMP                               99

      ** If there is an error in reading the APDUMP data area, it
      ** probably doesn't exist, so call the procedure which creates it
      ** and try again.
     C                   IF        *in99

     C                   CLEAR                   PSSRRetCde
     C                   CALL      'APCCRTQTO'
     C                   PARM                    PSSRRetCde       10
     C     *lock         IN        APDUMP

     C                   ENDIF

     C                   EVAL      ARErrMod = PSProcMod
     C                   OUT       APDUMP

     C                   CALL      'DBERRCTL'

     C                   ENDIF

     C                   RETURN

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2007
