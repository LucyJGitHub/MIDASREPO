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
      *  SFMENUEXT - SF User Maintenance + Menu Items Details         *
      *                                                               *
      *  Function: This program writes the data to an extract         *
      *            file which is then used to display the data        *
      *            in the list view for User Functions on the         *
      *            front end.                                         *
      *                                                               *
      *  (c) Finastra International Limited 2007                      *
      *                                                               *
      *  Last Amend No. MD055681           Date 31Jul20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG13587 *CREATE   Date 20Apr07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055681 - Deliverable Data Split for SAR                    *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG13587 - Zone file built over file in global layer         *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      *
      * SC Switchable Feature Menu Items
     FSCSARIPD  IF   E             DISK
     F                                     INFSR(*PSSR)
      *
      * SC Switchable Feature Description
     F*SCSARDL0* IF   E           K DISK                                                    MD055681
     F**********                           INFSR(*PSSR)                                     MD055681
      *
      * GP Global Menu Item Text
     FGPMTXTL0  IF   E           K DISK    PREFIX(A_)
     F                                     INFSR(*PSSR)
      *
      * GP Zonal Menu Master
     FSFMENUL0  IF   E           K DISK    PREFIX(B_)
     F                                     INFSR(*PSSR)
      *
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
     D*SCSARD**      E DS                  EXTNAME(SCSARDPD)                                MD055681
     D SCSARD        E DS                  EXTNAME(SCSRDJW0)                                MD055681
     D                                     PREFIX(AB)                                       MD055681
      ** EXTERNAL DS FOR SAR DETAILS

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE

      *---------------------------------------------------------------
      ** Mainline Processing
      *---------------------------------------------------------------
      *
     C                   READ      SCSARIPD
      *
      * Read the SARI file for the Switchable Feature until end of file
      *
     C                   DOW       Not %EOF(SCSARIPD)
      *
     C                   IF        %EOF(SCSARIPD)
     C                   LEAVE
     C                   ENDIF
      *
      * Check whether the Switchable Feature is valid or not
      *
     C*****ADSARN        CHAIN     SCSARDL0                                                 MD055681
     C/EXEC SQL                                                                             MD055681
     C+ SELECT *                                                                            MD055681
     C+ into :SCSARD                                                                        MD055681
     C+ from SCSRDJW0                                                                       MD055681
     C+ where SARN = :ADSARN                                                                MD055681
     C/END-EXEC                                                                             MD055681
      *
     C**********         IF        %FOUND(SCSARDL0)                                         MD055681
     C                   IF        SQLCode = 0                                              MD055681
      *
      * For the Switchable Feature and Menu Index capture the Menu Shortname and
      * Description
      *
     C     ADINDX        CHAIN     GPMTXTL0
      *
     C                   IF        %FOUND(GPMTXTL0)
      *
     C                   EVAL      MISNAM = A_MISNAM
     C                   EVAL      MIINAR = A_MIINAR
     C                   EVAL      MISARN = ABSARN
      *
      *
     C     A_MIINDX      CHAIN     SFMENUL0
      *
     C                   IF        %FOUND(SFMENUL0)
      *
     C                   EVAL      MIINDX = B_MIINDX
     C                   EVAL      ALLOWACT = B_MIAAC1 + B_MIAAC2 + B_MIAAC3 +
     C                                   B_MIAAC4 + B_MIAAC5 + B_MIAAC6 +
     C                                   B_MIAAC7 + B_MIAAC8 + B_MIAAC9 +
     C                                   B_MIAAC10
     C                   EVAL      MISECL = B_MISECL
      *
     C                   WRITE     SFMNUEXD0
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   READ      SCSARIPD
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
