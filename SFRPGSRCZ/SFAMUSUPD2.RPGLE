     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD
/*EXI *  TEXT('Maintain Equation Unit Access Security File')
      *****************************************************************
      *                                                               *
      *  Midas - Security Profile Facility                            *
      *                                                               *
      *  SFAMUSUPD2 - Maintain Equation Unit Access Security File     *
      *                                                               *
      *  Function:  This program Updates Equation table for User      *
      *             profiles                                          *
      *                                                               *
      *  Called By: SFAMUSVU                                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. CRE026B  *CREATE    Date 19Dec06              *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE026B - Maintain Equation Unit Access Security File KAPSEC *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
      * Unit Access Security File
     FKAPSEC    UF A E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      **-----------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **-----------------------------------------------------------------------
 
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
 
      * Unit Access Security File Layout
     D KapsecDs      E DS                  EXTNAME(KAPSEC)
 
      * Array to hold the field values of Authorised Unit
     D Unit_Arr        S              3A   DIM(10)
 
      * Array to hold the field values of Initial Menu if Unit
     D Menu_Arr        S             10A   DIM(10)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      * Index for arrays of error messages ids
     D Idx             S              3P 0 INZ(0)
 
      * Work Field to hold the value from Data Area KAPUNMNM
     D WUnit_DA        S              3A
 
      * Work Field to hold the field values of Authorised Unit
     D Wunit           S             30A
 
      * Work Field to hold the field values of Initial Menu if Unit
     D Wmenu           S            100A
 
      * Array Counter
     D WIndex          S              2S 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
     C                   EXSR      ResetCycle
 
      * Read the data area KAPUNMNM to retrieve the Unit Mnemonic
     C     *DTAARA       DEFINE                  KAPUNMNM          3
     C                   IN        KAPUNMNM
     C                   EVAL      WUnit_DA = KAPUNMNM
 
     C                   SELECT
 
     C                   WHEN      Actn = 'I'
     C                   EXSR      Insert
 
     C                   WHEN      Actn = 'D'
     C                   EXSR      Delete
 
     C                   ENDSL
 
     C                   RETURN
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
     C                   PARM                    Actn              1
     C                   PARM                    UsrPrf           10
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
      * Setup the name of the message file from which the message
      * handler will get the messages
     C                   EVAL      MsgFArray(1) = 'SFUSRMSG'
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ResetCycle - Reset error information that is gradually        *
      *              updated during each run of this program          *
      *                                                               *
      *****************************************************************
     C     ResetCycle    BEGSR
 
     C                   RESET                   FldNameArr
     C                   RESET                   MsgIDArr
     C                   RESET                   MsgDtaArr
     C                   RESET                   WFldNamArr
     C                   RESET                   WMsgIDArr
     C                   RESET                   WMsgDtaArr
 
     C                   RESET                   Idx
 
     C                   RESET                   WIndex
 
     C                   RESET                   Unit_Arr
     C                   RESET                   Menu_Arr
 
     C                   CLEAR                   KapsecDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ******************************************************************
      *                                                                *
      * Insert - Insert New User or New Unit Mnemonic to the           *
      *          existing user                                         *
      *                                                                *
      ******************************************************************
     C     Insert        BEGSR
 
      * Read the Unit Access Security File
     C     UsrPrf        CHAIN     KAPSEC
 
      * If the User does not exist
     C                   IF        Not %Found(KAPSEC)
     C                   EVAL      SECUSR = UsrPrf
     C                   EVAL      SECUN1 = WUnit_DA
     C                   EVAL      SECMN1 = 'WMENU1'
 
     C                   WRITE     SECF
 
      * If User exists
     C                   ELSE
 
     C                   EVAL      WUnit = %Subst(KapsecDs:11:30)
     C                   EVAL      WMenu = %Subst(KapsecDs:41:100)
      *
     C                   MOVEA     WUnit         Unit_Arr
     C                   MOVEA     WMenu         Menu_Arr
      *
      * Check that all Unit Mnemonic for the current User are not fill
     C                   EVAL      Windex = %LOOKUP(' ':Unit_Arr)
     C                   IF        Windex = 0
      * All Unit Mnemonics are filled, Error
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'SECUN     '
     C                   EVAL      MsgIdArr(Idx)= 'SFM0490'
     C                   ENDIF
 
      * If no error, do further processing
     C                   IF        Idx = 0
 
      * Populate the corresponding array elements based on the Index
     C                   EVAL      Unit_Arr(Windex) = WUnit_DA
     C                   EVAL      Menu_Arr(Windex) = 'WMENU1'
 
     C                   MOVEA     Unit_Arr      WUnit
     C                   MOVEA     Menu_Arr      WMenu
 
      * Populate the database fields
     C                   EVAL      %Subst(KapsecDs:11:30) = WUnit
     C                   EVAL      %Subst(KapsecDs:41:100) = WMenu
 
      * Update Unit Access Security File
     C                   UPDATE    SECF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Delete - Delete existing Unit Mnemonic                        *
      *                                                               *
      *****************************************************************
     C     Delete        BEGSR
 
      * Read the Unit Access Security File
     C     UsrPrf        CHAIN     KAPSEC
 
      * If User exists
     C                   IF        %Found(KAPSEC)
 
     C                   EVAL      WUnit = %Subst(KapsecDs:11:30)
     C                   EVAL      WMenu = %Subst(KapsecDs:41:100)
 
     C                   MOVEA     WUnit         Unit_Arr
     C                   MOVEA     WMenu         Menu_Arr
 
      * Retrieve the Index of the Unit Mnemonic to be deleted
     C                   EVAL      WIndex = %LOOKUP(WUnit_DA:Unit_Arr)
 
      * Check if Unit Mnemonic does exists for the current User
     C                   IF        WIndex <> 0
 
      * Blank out the corresponding array elements based on the
      * index retrieved
     C                   EVAL      Unit_Arr(Windex) = *Blanks
     C                   EVAL      Menu_Arr(Windex) = *Blanks
 
     C                   MOVEA     Unit_Arr      WUnit
     C                   MOVEA     Menu_Arr      WMenu
      * Populate the database fields
     C                   EVAL      %Subst(KapsecDs:11:30) = WUnit
     C                   EVAL      %Subst(KapsecDs:41:100) = WMenu
 
      * Check if no Unit Mnemonic exists for the user after deletion
     C                   IF        %Subst(KapsecDS:11:30) = *Blanks
     C                   DELETE    SECF
     C                   ELSE
     C                   UPDATE    SECF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      * The following /COPY contains the standard program status
      * subroutine, including a bound call to the DBERRCTL module.
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
      *****************************************************************
