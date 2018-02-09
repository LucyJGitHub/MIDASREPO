     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate VFECOS Economic Sector Code')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDVVFECOS  - Validate Economic Sector Code                   *
      *                                                               *
      *  Function:  This module setup the economic sector code.       *
      *                                                               *
      *  Component of:  SP121CTYLX - Core Luxembourg service program  *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CER001             Date 25Apr05               *
      *                 212921             Date 20Jan03               *
      *                 ULX609  *CREATE    Date 31Jul00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER001 - LUX Upgrade to MidasPlus (Recompile only)           *
      *  212921 - No error given when the Economic Sector does not    *
      *           exist                                               *
      *  ULX609 - API Luxembourg - Function SDCUSD                    *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     F* In DBA3, file SDECOSPD is renamed SDECOSLXPD
     FSDECOSLXPDIF   E           K DISK    INFSR(*PSSR)
 
     F***SDINSTY6  IF   E           K DISK    INFSR(*PSSR)                                    CER001
     FSDINX1L0  IF   E           K DISK    INFSR(*PSSR)                                       CER001
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
     D/COPY ZACPYSRC,PROCPARMS
 
      ** The following /COPY line includes the definitions for error &
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      **
      **   Named constants
      **   ===============
      **
 
      **
      **   Arrays and Data Structures
      **   ==========================
      **
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
      ** External DS for country details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** DS for access programs, Short data structure
 
      **
      **   Declared variables
      **   ==================
      **
 
      ** Define *entry parameters
     D #6LXECOS        S              4A
     D #1LINC          S              2A
     D #1COLC          S              2A
 
      ** Define parameters for call module
     D @KEY1           S              2A
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *                M A I N  P R O C E S S I N G                   *
      *                                                               *
      *****************************************************************
      *
      **
      ** Initial processing is performed automatically: the *INZSR is
      ** executed at program activation.
      **
      *
      ** Reset the error flag to prevent problems on subsequent calls
      *
     C                   RESET                   ErrorFound
      *
     C                   MOVE      *BLANKS       @KEY1
      *
     C                   CALL      'AOCTRYR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      #1COLC        @KEY1
     C     SDCTRY        PARM      SDCTRY        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDCTRYL0'    DBFILE                         ***************
     C                   MOVEL     '900'         DBASE                          * DBERROR 900 *
     C                   MOVEL     #1COLC        DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Setup the field if blanks
      *
     C     #6LXECOS      IFEQ      *BLANKS
      *
     C*****#1LINC        CHAIN     SDINSTY6                           99                      CER001
     C     #1LINC        CHAIN     SDINX1L0                           99                      CER001
      *
     C     *IN99         IFEQ      *ON
     C                   MOVE      '4000'        #6LXECOS
      *
     C                   ELSE
     C                   SELECT
     C     #1COLC        WHENEQ    'LU'
     C                   MOVE      AOECOL        #6LXECOS
     C     #1COLC        WHENEQ    'BE'
     C                   MOVE      AOECOB        #6LXECOS
     C                   OTHER
     C                   MOVE      AOECOO        #6LXECOS
     C                   ENDSL
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Econ. Sec. Code not empty   - check it
      *
     C                   MOVE      #6LXECOS      W6LXECOS          4 0
     C     W6LXECOS      CHAIN     SDECOSLXPD                         99
     C     *IN99         IFEQ      *OFF
      *
      ** Econ. Sec. Code found, not valid in the country
      *
     C     A4ISOC        IFEQ      'LU'
     C     VGCNLU        ANDNE     'Y'
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'ER00112'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
     C     A4ISOC        IFEQ      'BE'
     C     VGCNBE        ANDNE     'Y'
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'ER00112'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
     C     A4ISOC        IFNE      'LU'
     C     A4ISOC        ANDNE     'BE'
     C     VGCNOT        ANDNE     'Y'
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'ER00112'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
     C                   ELSE                                                   212921
     C                   EVAL      ErrorFound = 'Y'                             212921
     C                   MOVEL     'ER00112'     #MSGID                         212921
     C                   GOTO      #ERROR                                       212921
     C                   ENDIF
      *
      ** If an error was found, set the return code appropriately
      *
     C     #ERROR        TAG
      *
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
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
      ** Parameters
      *
     C     *entry        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    #MsgID
     C                   PARM                    #6LXECOS
     C                   PARM                    #1LINC
     C                   PARM                    #1COLC
      *
      ** Set the program, module and procedure names for database
      ** error processing.  Note: this /COPY requires that the PSDS
      ** /COPY is also included.
      *
     C                   EVAL      DBPgm  = PSProcPgm
     C                   EVAL      DBMod  = PSProcMod
     C                   EVAL      DBProc = PSProcName
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Program, module and procedure names for database error process*
      *                                                               *
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2005
