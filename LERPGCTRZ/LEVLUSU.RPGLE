     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Validate Lump Sum Code')
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEVLUSU - Validate Lump Sum Code                             *
      *                                                               *
      *  Function:  This module receives a parameter containing a     *
      *             putative Lump-sum code, and confirms whether it   *
      *             is a valid code or not and return the associated  *
      *             rate.                                             *
      *             If it is valid the 10A return code will be blank, *
      *             if it is not it will contain 'Error'              *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CER001  *CREATE    Date 25Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Lump-Sum Provision Rates
      *
     FERLUMPL0  IF   E           K DISK    INFSR(*PSSR)
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in
      ** in Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the
      ** size of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **---------------------------------------------------------------
 
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
      *
      ** Lump Sum Provision Code
      *
     D PLusu           S              2
     D PVLura          S              4S 0
     D PVLusu          S              2S 0
      *
      ** Define parameters for call module
      *
     D PAlignOk        S              1A
     D PField          S             16A
     D PADec           S              1P 0
     D PADig           S              2P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** MAIN PROCESSING
      *****************************************************************
      *
      ** Initialization
      *
      ** Reset the error flag to prevent problems on subsequent calls
      *
     C                   RESET                   ErrorFound
     C                   RESET                   PAlignOk
      *
      ** Move '0' if the import/export code is blanks
      *
     C                   IF        PLusu      = *BLANKS
     C                   EVAL      PLusu      = '00'
     C                   ENDIF
      *
      ** Validation
      *
      ** If the Import/Export Indicator is entered,
      *
     C                   EVAL      *IN99      = *OFF
     C                   TESTN                   PLusu                99
      *
     C                   IF        *IN99 <> *ON
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      #MSGID     = 'ER60003'
     C                   GOTO      #ERROR
     C                   ENDIF
      *
     C                   MOVEL(P)  PLusu         PField
     C                   EVAL      PADec      = 0
     C                   EVAL      PADig      = 2
      *
     C                   CALLB     'ZALIGN'
     C                   PARM                    PAlignOk
     C                   PARM                    PField
     C                   PARM                    PADec
     C                   PARM                    PADig
      *
      ** Input is not valid
      *
     C                   IF        PAlignOk   = 'N'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      #MSGID     = 'ER60003'
     C                   GOTO      #ERROR
     C                   ENDIF
      *
     C                   MOVE      PField        PVLusu
      *
     C                   IF        PVLusu<> 0
      *
     C     PVLusu        CHAIN     ERLUMPL0
     C                   IF        NOT %FOUND(ERLUMPL0)
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      #MSGID     = 'ER60003'
     C                   GOTO      #ERROR
     C                   ENDIF
      *
     C                   EVAL      PVLura     = LSRATE
     C                   ENDIF
      *
      ** If an error was found, set the return code appropriately
      *
     C     #ERROR        TAG
      *
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn  = 'Error '
     C                   ENDIF
      *
      ** Return
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    #MsgID
     C                   PARM                    PLusu
     C                   PARM                    PVLura
     C                   PARM                    PVLusu
      *
      ** Program, module and procedure names for database error
      ** processing.
      ** =============================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
** CPY@
(c) Finastra International Limited 2005
