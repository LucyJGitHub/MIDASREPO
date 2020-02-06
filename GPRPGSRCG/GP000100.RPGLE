     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GP Call maintenance/enquiry function')           *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing                                    *
      *                                                               *
      *  GP000100 - Call maintenance/enquiry function                 *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CCB023             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CGP002  *CREATE    Date 02Jul03               *
      *                 xxxxxx             Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *  MD046248 - Finastra Rebranding                               *
      *  CCB023 - COB Restructure - Input Cycle Termination           *
      *           Restructuring (Recompile)                           *
      *  CGP002 - Global Processing data download                     *
      *                                                               *
      *****************************************************************
      **
      ** +--------------------------------------+
      ** ¦ Files                                ¦
      ** ¦ =====                                ¦
      ** +--------------------------------------+
      *
     FGPDWNLL1  IF   E           K DISK    INFSR(*PSSR)
      **
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Program Status Data Structure
     D/COPY GPCPYSRCG,PSDS
      *
      * Midas Local Data Area for database error reporting
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      * The following fields are defined in the external file:
      *                                     134 141 DBFile
      *                                     142 170 DBKey
      *                                     171 180 DBPgm
      *                                     181 1830DBase
      *                                     184 193 DBMod
      *                                     194 203 DBProc
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D Call_Cmd        C                   'CALL PGM('
      *
     D PARM_Kwrd       C                   ' PARM('
      *
     D SAVLIBL_Cmd     C                   'SAVLIBL SAVDTL(GP000100DQ)'
      *
     D RSTLIBL_Cmd     C                   'RSTLIBL SAVEDLIBL(GP000100DQ)'
      *
     D ENDCMTCTL_Cmd   C                   'ENDCMTCTL'
      *
     D DLTZMUSER_Cmd   C                   'DLTDTAARA DTAARA(QTEMP/ZMUSER)'
      *
     D CRTZMITEM_Cmd   C                   'CRTDTAARA DTAARA(QTEMP/ZMITEM) +
     D                                     TYPE(*CHAR) LEN(10)'
      *
     D DLTZMITEM_Cmd   C                   'DLTDTAARA DTAARA(QTEMP/ZMITEM)'
      *
     D Close_bracket   C                   ')'
      *
     D Cmd_String      S           1160
     D Cmd_String1     S           1160
     D Cmd_Length      S             15  5 INZ(1160)
     D Call_program    S              1
     D Call_menu       S              1
     D StartCmtCtl     S              1
     D CmtReturn       S             10
     D UserError       S              1  0
     D MenuItem        S              8
     D MenuItemCall    S            100
     D @RUN            S              1
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
     C     *ENTRY        PLIST
     C                   PARM                    Mode              1
     C                   PARM                    System_ID         2
     C                   PARM                    Key_Desc         20
      *
     C     GPDWNLL0Key   KLIST
     C                   KFLD                    System_ID
     C                   KFLD                    Key_Desc
      *
      * Find program to be called for maintenance or enquiry.
     C     GPDWNLL0Key   SETLL     GPDWNLL1
     C     GPDWNLL0Key   CHAIN     GPDWNLL1                           11
     C                   IF        *IN11 = *ON
     C                   EVAL      DBKEY = System_ID + Key_Desc
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * Build up call to program depending on mode.
      * Enquiry mode
     C                   IF        Mode = 'E'
      *
     C                   IF        DLEPGM <> '*NONE'
      *
      * Set up menu item and code.
     C                   IF        DLEPGM = '*MENU_ITEM'
     C                   EVAL      Call_menu = 'Y'
     C                   EVAL      MenuItem = %SUBST(DLEPRM:1:4)
     C                   EVAL      MenuItem = %TRIMR(MenuItem) +
     C                             %SUBST(DLEPRM:6:4)
     C                   ELSE
      *
      * Set up program to call.
     C                   EVAL      Call_program = 'Y'
     C                   EVAL      Cmd_String1 = Call_Cmd +
     C                             DLEPGM +
     C                             Close_bracket
      *
      * Set up parameters if necessary.
     C                   IF        DLEPRM <> *blanks
     C                   EVAL      Cmd_String1 = %TRIMR(Cmd_String1) +
     C                             PARM_Kwrd +
     C                             DLEPRM +
     C                             Close_bracket
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      * Maintenance mode
     C                   IF        Mode = 'M'
      *
     C                   IF        DLMPGM <> '*NONE'
      *
      * Set up menu item and code.
     C                   IF        DLMPGM = '*MENU_ITEM'
     C                   EVAL      Call_menu = 'Y'
     C                   EVAL      MenuItem = %SUBST(DLMPRM:1:4)
     C                   EVAL      MenuItem = %TRIMR(MenuItem) +
     C                             %SUBST(DLMPRM:6:4)
     C                   ELSE
      *
      * Set up program to call.
     C                   EVAL      Call_program = 'Y'
     C                   EVAL      Cmd_String1 = Call_Cmd +
     C                             DLMPGM +
     C                             Close_bracket
      *
      * Set up parameters if necessary.
     C                   IF        DLMPRM <> *blanks
     C                   EVAL      Cmd_String1 = %TRIMR(Cmd_String1) +
     C                             PARM_Kwrd +
     C                             DLMPRM +
     C                             Close_bracket
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   IF        Call_program = 'Y' or
     C                             Call_menu = 'Y'
      * Save library list.
     C                   EVAL      Cmd_String = SAVLIBL_Cmd
     C                   CALL      'QCMDEXC'
     C                   PARM                    Cmd_String
     C                   PARM                    Cmd_Length
     C                   CLEAR                   Cmd_String
      *
      * Call program to change library for zone Midas system.
     C                   CALL      'UPC0014'
     C                   PARM                    System_ID
      *
     C                   ENDIF
      *
      * If program is to be called directly.
     C                   IF        Call_program = 'Y'
      * Call program for maintenance or enquiry.
     C                   CALL      'QCMDEXC'
     C                   PARM                    Cmd_String1
     C                   PARM                    Cmd_Length
     C                   CLEAR                   Cmd_String1
     C                   ENDIF
      *
      * If program is to be called through a menu item.
     C                   IF        Call_menu = 'Y'
      * Call program to begin commitment control
     C                   CALL      'SCCMTCTL'
     C                   PARM      'S'           StartCmtCtl
     C                   PARM                    CmtReturn
      * Call program to set up Midas user profile data.
     C                   EVAL      Cmd_String = DLTZMITEM_Cmd
     C                   CALL      'QCMDEXC'                            21
     C                   PARM                    Cmd_String
     C                   PARM                    Cmd_Length
     C                   CLEAR                   Cmd_String
     C                   EVAL      Cmd_String = CRTZMITEM_Cmd
     C                   CALL      'QCMDEXC'
     C                   PARM                    Cmd_String
     C                   PARM                    Cmd_Length
     C                   CLEAR                   Cmd_String
     C                   EVAL      Cmd_String = DLTZMUSER_Cmd
     C                   CALL      'QCMDEXC'                            21
     C                   PARM                    Cmd_String
     C                   PARM                    Cmd_Length
     C                   CLEAR                   Cmd_String
     C                   CALL      'SFC0400'
      * Call program to access menu items.
     C                   CALL      'SC000100'
     C                   PARM                    MenuItem
     C                   PARM                    MenuItemCall
     C                   EVAL      Cmd_String = MenuItemCall
     C                   CALL      'QCMDEXC'
     C                   PARM                    Cmd_String
     C                   PARM                    Cmd_Length
     C                   CLEAR                   Cmd_String
      * End commitment control if started by this program.
     C                   IF        CmtReturn <> '*ACTIVE'
     C                   EVAL      Cmd_String = ENDCMTCTL_Cmd
     C                   CALL      'QCMDEXC'
     C                   PARM                    Cmd_String
     C                   PARM                    Cmd_Length
     C                   CLEAR                   Cmd_String
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        Call_program = 'Y' or
     C                             Call_menu = 'Y'
      * Restore original library list.
     C                   EVAL      Cmd_String = RSTLIBL_Cmd
     C                   CALL      'QCMDEXC'
     C                   PARM                    Cmd_String
     C                   PARM                    Cmd_Length
     C                   CLEAR                   Cmd_String
      *
     C                   ENDIF
      *
     C     ENDPGM        TAG
     C                   SETON                                        LR
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
