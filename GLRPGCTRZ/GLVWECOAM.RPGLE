     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate WECOAM Correction Amount')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger ILE Module                            *
      *                                                               *
      *  GLVWECOAM  - Validate Correction Amount                      *
      *                                                               *
      *  Function:  This module receives a parameter containing an    *
      *             amount and confirm whether it is a correct amount *
      *             If it is valid the 10A return code will be blank, *
      *             if it is not it will contain 'Error'              *
      *                                                               *
      ***Component*of:**SP123CTYLX*-*CORE*LuxeModule*service*program***                       CER001
      *  Component of:  SP6GL0004  - Core service program             *                       CER001
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CER001             Date 25Apr05               *
      *                 ULX606  *CREATE    Date 18Sep00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER001 - LUX Uprade to MidasPlus                             *
      *  ULX606 - API Luxembourg - Function GLAMAD                    *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
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
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External DS for currency details
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for access programs, long data structure
 
      **
      **   Declared variables
      **   ==================
      **
 
      ** Define parameters received
     D #6LXCOAM        S             15A
     D #6LXWECOAM      S             15  0
     D #1CCY           S              3A
     D BNDCSP          S              1A
 
      ** Define parameters for call module
     D @@ALPH          S             16A
     D @@IDP           S              3  0
     D @@IINT          S              3  0
     D @@MTID          S              1A
     D @@ERCD          S              1  0
     D @@AMT           S             15  0
 
     D @CCY            S              3A
 
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
      ** Call AOCURRR0 to retrieve currency informations
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*BLANKS'     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      #1CCY         @CCY
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     #1CCY         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   Z-ADD     A6NBDP        @@IDP
     C     15            SUB       A6NBDP        @@IINT
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVE      #6LXCOAM      @@ALPH
     C                   MOVE      'Y'           @@MTID
      *
      ** Call the module ZA0840 for validate and align the correction
      ** amount
      *
     C                   CALLB     'ZA0840'
     C                   PARM                    RetCodeOut
     C                   PARM                    @@ALPH
     C                   PARM                    @@IDP
     C                   PARM                    @@IINT
     C                   PARM                    @@MTID
     C                   PARM                    @@ERCD
     C                   PARM                    @@AMT
     C                   PARM                    BNDCSP
      *
      ** If an error was found in the validation of the
      ** correction amount, sending a message
      *
     C     @@ERCD        IFNE      0
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'ER89001'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
      *
      ** If the amount returned by the subroutine is negative
      ** sending a message
      *
     C     @@AMT         IFLT      *ZEROS
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'ER89001'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
      *
     C                   MOVE      @@AMT         #6LXWECOAM
     C                   MOVE      @@ALPH        #6LXCOAM
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
     C                   PARM                    #6LXCOAM
     C                   PARM                    #6LXWECOAM
     C                   PARM                    #1CCY
      ** Decimal separator (1A, from SDDEALPD, via caller)
     C                   PARM                    BNDCSP
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
