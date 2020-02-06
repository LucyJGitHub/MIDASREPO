     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2007')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
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
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. BUG14000 *CREATE   Date 18May07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG14000 - Midas Plus error on User Functions                *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      * GP Global Menu Item Text
     FGPMTXTPD  IF   E             DISK    PREFIX(A_)
     F                                     INFSR(*PSSR)
 
      * SF Zonal Menu Action Codes by Unique Code
     FSFMENUJ0  IF   E           K DISK    PREFIX(B_)
     F                                     INFSR(*PSSR)
 
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
 
      *---------------------------------------------------------------
      ** Mainline Processing
      *---------------------------------------------------------------
      *
      * Read the file until end of file
     C                   READ      GPMTXTPD
      *
     C                   DOW       Not %EOF(GPMTXTPD)
      *
      * For the Menu Index retrieve all the fields from the join file
      *
     C     A_MIINDX      CHAIN     SFMENUJ0
      *
     C                   IF        %FOUND(SFMENUJ0)
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
     C                   READ      GPMTXTPD
      *
     C                   ENDDO
      *
     C                   CLOSE     SFMNUEXPD
 
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
