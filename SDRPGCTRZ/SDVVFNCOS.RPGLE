     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate VFNCOS New Economic Sector Code')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDVVFNCOS  - Validate New Economic Sector Code               *
      *                                                               *
      *  Function:  This module receives a parameter containing a new *
      *             economic sector code, and confirms wether it is a *
      *             valid new economic sector code.                   *
      *             If it is valid the 10A return code will be blank, *
      *             if it is not it will contain 'Error'              *
      *                                                               *
      *  Component of:  SP121CTYLX - Core Luxembourg service program  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CER001             Date 25Apr05               *
      *  Prev Amend No. ULX609  *CREATE    Date 31Jul00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER001 - LUX Upgrade to MidasPlus (Recompile only)           *
      *  ULX609 - API Luxembourg - Function SDCUSD                    *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas ER Country Codes - LU Ext. index
     F***SDCTRYY6  IF   E           K DISK    INFSR(*PSSR)                                    CER001
     FSDCTX2L0  IF   E           K DISK    INFSR(*PSSR)                                       CER001
 
      ** Midas ER Institutions - Economic Sectors
     F***SDINSTY6  IF   E           K DISK    INFSR(*PSSR)                                    CER001
     FSDINX1L0  IF   E           K DISK    INFSR(*PSSR)                                       CER001
 
      ** Midas ER New Economic Sector table IML97/138
     FSDNCOSPD  IF   E           K DISK    INFSR(*PSSR)
 
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
      ** DS for access programs, short data structure
 
      **
      **   Declared variables
      **   ==================
      **
     D W6LXNCOS        S              4S 0
 
      ** Define *entry parameters
     D #6LXNCOS        S              4A
     D #1COLC          S              2A
     D #1LINC          S              2A
 
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
     C                   SETOFF                                           98
      *
      ** Validate the new economic sector code
      *
     C                   DO
      *
      ** Retrieve data SDCTRYPD
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
      ***Retrieve*data*SDCTRYY6****************************************                       CER001
      ** Retrieve data SDCTX2L0                                                               CER001
      *
     C*****#1COLC        CHAIN     SDCTRYY6                           99                      CER001
     C     #1COLC        CHAIN     SDCTX2L0                           99                      CER001
     C     *IN99         IFEQ      *ON
     C**********         MOVEL     'SDCTRYY6'    DBFILE                                       CER001
     C                   MOVEL     'SDCTX2L0'    DBFILE                                       CER001
     C                   MOVEL     '901'         DBASE                          ****************
     C                   MOVEL     *BLANKS       DBKEY                          * DB*ERROR 901 *
     C                   MOVEL     #1COLC        DBKEY                          ****************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Economic Sector Code empty
      *
     C     #6LXNCOS      IFEQ      *BLANKS
      *
      ***Retrieve*data*from*SDINSTY6***********************************                       CER001
      ** Retrieve data from SDINX1L0                                                          CER001
      *
     C*****#1LINC        CHAIN     SDINSTY6                           99                      CER001
     C     #1LINC        CHAIN     SDINX1L0                           99                      CER001
     C     *IN99         IFEQ      *ON
     C                   MOVE      '9000'        #6LXNCOS
     C                   LEAVE
     C                   ENDIF
      *
      ** Institution Code found - set up default code
      *
     C                   SELECT
     C     A4ISOC        WHENEQ    'LU'
     C                   MOVE      AONCOL        #6LXNCOS
     C     A4ISOC        WHENNE    'LU'
     C     WFEMUM        ANDEQ     'Y'
     C                   MOVE      AONCOE        #6LXNCOS
     C                   OTHER
     C                   MOVE      AONCOO        #6LXNCOS
     C                   ENDSL
     C                   LEAVE
      *
     C                   ENDIF
      *
      ** Economic Sector Code not empty - check it
      *
     C                   MOVE      #6LXNCOS      W6LXNCOS
     C     W6LXNCOS      CHAIN     SDNCOSPD                           99
     C     *IN99         IFEQ      *ON
     C                   MOVE      *ON           *IN98
     C                   LEAVE
     C                   ENDIF
      *
      ** Economic Sector Code found, not valid in the country
      *
     C     A4ISOC        IFEQ      'LU'
     C     VNCNLU        ANDNE     'Y'
     C                   MOVE      *ON           *IN98
     C                   ENDIF
     C     WFEMUM        IFEQ      'Y'
     C     A4ISOC        ANDNE     'LU'
     C     VNCNEM        ANDNE     'Y'
     C                   MOVE      *ON           *IN98
     C                   ENDIF
     C     A4ISOC        IFNE      'LU'
     C     WFEMUM        ANDNE     'Y'
     C     VNCNOT        ANDNE     'Y'
     C                   MOVE      *ON           *IN98
     C                   ENDIF
      *
     C                   ENDDO
      *
      ** If error .......
      *
     C     *IN98         IFEQ      *ON
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'ER00112'     #MSGID
     C                   GOTO      #ERROR
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
     C                   PARM                    #6LXNCOS
     C                   PARM                    #1COLC
     C                   PARM                    #1LINC
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
(c) Misys International Banking Systems Ltd. 2005
